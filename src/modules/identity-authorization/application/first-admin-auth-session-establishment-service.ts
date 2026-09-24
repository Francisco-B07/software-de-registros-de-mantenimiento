import type { SupabaseServerCookieMethods } from "../../../infrastructure/supabase/server";

import { createSupabaseFirstAdminAuthSessionDeliveryBoundary } from "../infrastructure/supabase/first-admin-auth-session-delivery";
import {
  createFirstAdminAuthIdentityReconciliationService,
  type FirstAdminAuthIdentityReconciliationResult,
} from "./first-admin-auth-identity-reconciliation-service";
import { createFirstAdminAuthHandoffService } from "./first-admin-onboarding-service";
import type {
  FirstAdminPostSignInAuthHandoffCorrelationResult,
} from "./first-admin-onboarding";

export type FirstAdminAuthSessionEstablishmentResult = Readonly<{
  outcome:
    | "SESSION_ESTABLISHED"
    | "SESSION_ALREADY_ESTABLISHED"
    | "SESSION_RECOVERY_REQUIRED"
    | "IDENTITY_INCOMPATIBLE"
    | "AUTH_SESSION_DELIVERY_FAILED"
    | "RETRYABLE_FAILURE"
    | "SECURITY_CORRELATION_FAILURE";
}>;

type ReconciliationService = Pick<
  ReturnType<typeof createFirstAdminAuthIdentityReconciliationService>,
  "reconcile"
>;
type HandoffService = Pick<
  ReturnType<typeof createFirstAdminAuthHandoffService>,
  "resolvePostSignInAuthHandoffCorrelation"
>;
type SessionDeliveryBoundary = Pick<
  ReturnType<typeof createSupabaseFirstAdminAuthSessionDeliveryBoundary>,
  "establishCandidate" | "inspectExistingSession"
>;

type Dependencies = Readonly<{
  handoffService?: HandoffService;
  reconciliationService?: ReconciliationService;
  sessionDeliveryBoundary?: SessionDeliveryBoundary;
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function result(
  outcome: FirstAdminAuthSessionEstablishmentResult["outcome"],
): FirstAdminAuthSessionEstablishmentResult {
  return Object.freeze({ outcome });
}

function mapReconciliationFailure(
  reconciliation: Exclude<
    FirstAdminAuthIdentityReconciliationResult,
    { outcome: "SESSION_CANDIDATE" }
  >,
): FirstAdminAuthSessionEstablishmentResult {
  switch (reconciliation.outcome) {
    case "IDENTITY_INCOMPATIBLE":
      return result("IDENTITY_INCOMPATIBLE");
    case "SECURITY_CORRELATION_FAILURE":
      return result("SECURITY_CORRELATION_FAILURE");
    case "RETRYABLE_FAILURE":
      return result("RETRYABLE_FAILURE");
    case "AUTH_DENIED_OR_UNAVAILABLE":
    case "REPAIR_REQUIRED":
      return result("AUTH_SESSION_DELIVERY_FAILED");
    case "NOT_ELIGIBLE":
      return result("SESSION_RECOVERY_REQUIRED");
  }
}

function mapFinalGuardFailure(
  guard: Exclude<
    FirstAdminPostSignInAuthHandoffCorrelationResult,
    { outcome: "CORRELATED_CONSUMED" }
  >,
): FirstAdminAuthSessionEstablishmentResult {
  switch (guard.outcome) {
    case "IDENTITY_INCOMPATIBLE":
      return result("IDENTITY_INCOMPATIBLE");
    case "INFRASTRUCTURE_FAILURE":
      return result("RETRYABLE_FAILURE");
    case "NOT_CONSUMED":
    case "SECURITY_CORRELATION_FAILURE":
      return result("SECURITY_CORRELATION_FAILURE");
  }
}

function finalGuardMatches(
  guard: Extract<
    FirstAdminPostSignInAuthHandoffCorrelationResult,
    { outcome: "CORRELATED_CONSUMED" }
  >,
  intentId: string,
  authUserId: string,
): boolean {
  return (
    guard.intentId === intentId &&
    guard.bridgeAuthUserId === authUserId &&
    guard.grantAuthUserId === authUserId &&
    guard.bridgeAuthUserId === guard.grantAuthUserId &&
    (guard.identityCompatibility === "NO_APPLICATION_IDENTITY" ||
      guard.identityCompatibility ===
        "COMPATIBLE_EXISTING_APPLICATION_IDENTITY")
  );
}

export function createFirstAdminAuthSessionEstablishmentService(
  requestCookies: SupabaseServerCookieMethods,
  dependencies: Dependencies = {},
) {
  const reconciliationService =
    dependencies.reconciliationService ??
    createFirstAdminAuthIdentityReconciliationService();
  const handoffService =
    dependencies.handoffService ?? createFirstAdminAuthHandoffService();
  const sessionDeliveryBoundary =
    dependencies.sessionDeliveryBoundary ??
    createSupabaseFirstAdminAuthSessionDeliveryBoundary(requestCookies);

  async function finalGuard(
    intentId: string,
  ): Promise<FirstAdminPostSignInAuthHandoffCorrelationResult> {
    return handoffService.resolvePostSignInAuthHandoffCorrelation(intentId);
  }

  return Object.freeze({
    async establish(
      intentId: string,
    ): Promise<FirstAdminAuthSessionEstablishmentResult> {
      if (!UUID_PATTERN.test(intentId)) {
        return result("SECURITY_CORRELATION_FAILURE");
      }
      const normalizedIntentId = intentId.toLowerCase();

      let reconciliation: FirstAdminAuthIdentityReconciliationResult;
      try {
        reconciliation = await reconciliationService.reconcile(
          normalizedIntentId,
        );
      } catch {
        return result("RETRYABLE_FAILURE");
      }

      if (reconciliation.outcome === "SESSION_CANDIDATE") {
        let guard: FirstAdminPostSignInAuthHandoffCorrelationResult;
        try {
          guard = await finalGuard(normalizedIntentId);
        } catch {
          return result("RETRYABLE_FAILURE");
        }
        if (guard.outcome !== "CORRELATED_CONSUMED") {
          return mapFinalGuardFailure(guard);
        }
        if (
          !finalGuardMatches(
            guard,
            reconciliation.intentId,
            reconciliation.authUserId,
          )
        ) {
          return result("SECURITY_CORRELATION_FAILURE");
        }

        return sessionDeliveryBoundary.establishCandidate(
          reconciliation.sessionCandidate,
          reconciliation.authUserId,
        );
      }

      if (reconciliation.outcome !== "NOT_ELIGIBLE") {
        return mapReconciliationFailure(reconciliation);
      }

      const existing = await sessionDeliveryBoundary.inspectExistingSession();
      if (existing.outcome === "RETRYABLE_FAILURE") {
        return result("RETRYABLE_FAILURE");
      }
      if (existing.outcome === "NO_VALID_SESSION") {
        return result("SESSION_RECOVERY_REQUIRED");
      }

      let guard: FirstAdminPostSignInAuthHandoffCorrelationResult;
      try {
        guard = await finalGuard(normalizedIntentId);
      } catch {
        return result("RETRYABLE_FAILURE");
      }
      if (guard.outcome !== "CORRELATED_CONSUMED") {
        return mapFinalGuardFailure(guard);
      }
      if (!finalGuardMatches(guard, normalizedIntentId, existing.subject)) {
        return result("SECURITY_CORRELATION_FAILURE");
      }
      if ((await existing.commit()) !== "COMMITTED") {
        return result("AUTH_SESSION_DELIVERY_FAILED");
      }

      return result("SESSION_ALREADY_ESTABLISHED");
    },
  });
}
