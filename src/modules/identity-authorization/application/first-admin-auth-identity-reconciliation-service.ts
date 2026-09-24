import { createSupabaseTechnicalSignInBoundary } from "../infrastructure/supabase/technical-sign-in";
import type {
  TechnicalSessionCandidate,
  TechnicalSignInResult,
} from "./auth-session-bridge";
import {
  createFirstAdminAuthProvisioningService,
  createFirstAdminTechnicalPasswordService,
} from "./first-admin-auth-provisioning-service";
import {
  createFirstAdminAuthHandoffService,
} from "./first-admin-onboarding-service";
import type {
  FirstAdminAuthHandoffContext,
  FirstAdminAuthHandoffResult,
  FirstAdminPostSignInAuthHandoffCorrelationResult,
} from "./first-admin-onboarding";

export type FirstAdminAuthIdentityReconciliationResult =
  | Readonly<{
      authUserId: string;
      intentId: string;
      outcome: "SESSION_CANDIDATE";
      sessionCandidate: TechnicalSessionCandidate;
    }>
  | Readonly<{
      outcome:
        | "NOT_ELIGIBLE"
        | "IDENTITY_INCOMPATIBLE"
        | "REPAIR_REQUIRED"
        | "AUTH_DENIED_OR_UNAVAILABLE"
        | "RETRYABLE_FAILURE"
        | "SECURITY_CORRELATION_FAILURE";
    }>;

type HandoffService = Pick<
  ReturnType<typeof createFirstAdminAuthHandoffService>,
  "resolve" | "resolvePostSignInAuthHandoffCorrelation"
>;
type ProvisioningService = Pick<
  ReturnType<typeof createFirstAdminAuthProvisioningService>,
  "provision"
>;
type TechnicalPasswordService = Pick<
  ReturnType<typeof createFirstAdminTechnicalPasswordService>,
  "resolve"
>;
type SignInBoundary = Pick<
  ReturnType<typeof createSupabaseTechnicalSignInBoundary>,
  "signIn"
>;

type Dependencies = Readonly<{
  handoffService?: HandoffService;
  provisioningService?: ProvisioningService;
  signInBoundary?: SignInBoundary;
  technicalPasswordService?: TechnicalPasswordService;
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function failure(
  outcome: Exclude<
    FirstAdminAuthIdentityReconciliationResult["outcome"],
    "SESSION_CANDIDATE"
  >,
): FirstAdminAuthIdentityReconciliationResult {
  return Object.freeze({ outcome });
}

function mapHandoffFailure(
  result: Exclude<FirstAdminAuthHandoffResult, { outcome: "ELIGIBLE" }>,
): FirstAdminAuthIdentityReconciliationResult {
  switch (result.outcome) {
    case "IDENTITY_INCOMPATIBLE":
      return failure("IDENTITY_INCOMPATIBLE");
    case "INFRASTRUCTURE_FAILURE":
      return failure("RETRYABLE_FAILURE");
    case "SECURITY_CORRELATION_FAILURE":
      return failure("SECURITY_CORRELATION_FAILURE");
    case "GRANT_EXPIRED":
    case "GRANT_REVOKED":
    case "GRANT_CONSUMED":
      return failure("NOT_ELIGIBLE");
  }
}

function mapSignInFailure(
  result: Exclude<TechnicalSignInResult, { outcome: "SESSION_CANDIDATE" }>,
): FirstAdminAuthIdentityReconciliationResult {
  switch (result.outcome) {
    case "DEFINITE_CREDENTIAL_FAILURE":
      return failure("REPAIR_REQUIRED");
    case "AUTH_DENIED_OR_UNAVAILABLE":
      return failure("AUTH_DENIED_OR_UNAVAILABLE");
    case "AMBIGUOUS_FAILURE":
      return failure("RETRYABLE_FAILURE");
  }
}

function preserveContext(
  context: FirstAdminAuthHandoffContext,
): FirstAdminAuthHandoffContext {
  return Object.freeze({
    authBridgeCredentialId: context.authBridgeCredentialId,
    boundAuthUserId: context.boundAuthUserId,
    currentChallengeId: context.currentChallengeId,
    handoffSessionGrantId: context.handoffSessionGrantId,
    identityCompatibility: context.identityCompatibility,
    intentId: context.intentId,
    maintenanceCompanyId: context.maintenanceCompanyId,
    targetEmail: context.targetEmail,
  });
}

function contextMatchesInitial(
  initial: FirstAdminAuthHandoffContext,
  current: FirstAdminAuthHandoffContext,
): boolean {
  return (
    current.intentId === initial.intentId &&
    current.maintenanceCompanyId === initial.maintenanceCompanyId &&
    current.targetEmail === initial.targetEmail &&
    current.currentChallengeId === initial.currentChallengeId &&
    current.handoffSessionGrantId === initial.handoffSessionGrantId &&
    current.authBridgeCredentialId === initial.authBridgeCredentialId &&
    current.identityCompatibility === initial.identityCompatibility &&
    current.boundAuthUserId === null
  );
}

function correlationMatches(
  initial: FirstAdminAuthHandoffContext,
  authUserId: string,
  post: Extract<
    FirstAdminPostSignInAuthHandoffCorrelationResult,
    { outcome: "CORRELATED_CONSUMED" }
  >,
): boolean {
  return (
    post.intentId === initial.intentId &&
    post.maintenanceCompanyId === initial.maintenanceCompanyId &&
    post.targetEmail === initial.targetEmail &&
    post.currentChallengeId === initial.currentChallengeId &&
    post.handoffSessionGrantId === initial.handoffSessionGrantId &&
    post.authBridgeCredentialId === initial.authBridgeCredentialId &&
    post.bridgeAuthUserId === authUserId &&
    post.grantAuthUserId === authUserId &&
    post.bridgeAuthUserId === post.grantAuthUserId &&
    post.identityCompatibility === initial.identityCompatibility
  );
}

function mapPostCorrelationFailure(
  result: Exclude<
    FirstAdminPostSignInAuthHandoffCorrelationResult,
    { outcome: "CORRELATED_CONSUMED" }
  >,
): FirstAdminAuthIdentityReconciliationResult {
  switch (result.outcome) {
    case "IDENTITY_INCOMPATIBLE":
      return failure("IDENTITY_INCOMPATIBLE");
    case "INFRASTRUCTURE_FAILURE":
      return failure("RETRYABLE_FAILURE");
    case "NOT_CONSUMED":
    case "SECURITY_CORRELATION_FAILURE":
      return failure("SECURITY_CORRELATION_FAILURE");
  }
}

export function createFirstAdminAuthIdentityReconciliationService(
  dependencies: Dependencies = {},
) {
  const handoffService =
    dependencies.handoffService ?? createFirstAdminAuthHandoffService();
  const provisioningService =
    dependencies.provisioningService ??
    createFirstAdminAuthProvisioningService();
  const signInBoundary =
    dependencies.signInBoundary ?? createSupabaseTechnicalSignInBoundary();
  const technicalPasswordService =
    dependencies.technicalPasswordService ??
    createFirstAdminTechnicalPasswordService();

  async function signIn(
    context: FirstAdminAuthHandoffContext,
  ): Promise<TechnicalSignInResult | null> {
    try {
      const password = await technicalPasswordService.resolve(context);
      if (password.outcome !== "READY") {
        return null;
      }
      return await signInBoundary.signIn({
        email: context.targetEmail,
        technicalPassword: password.technicalPassword,
      });
    } catch {
      return null;
    }
  }

  async function correlate(
    initial: FirstAdminAuthHandoffContext,
    signedIn: Extract<TechnicalSignInResult, { outcome: "SESSION_CANDIDATE" }>,
  ): Promise<FirstAdminAuthIdentityReconciliationResult> {
    let post: FirstAdminPostSignInAuthHandoffCorrelationResult;
    try {
      post = await handoffService.resolvePostSignInAuthHandoffCorrelation(
        initial.intentId,
      );
    } catch {
      return failure("RETRYABLE_FAILURE");
    }

    if (post.outcome !== "CORRELATED_CONSUMED") {
      return mapPostCorrelationFailure(post);
    }

    if (!correlationMatches(initial, signedIn.authUserId, post)) {
      return failure("SECURITY_CORRELATION_FAILURE");
    }

    return Object.freeze({
      authUserId: signedIn.authUserId,
      intentId: initial.intentId,
      outcome: "SESSION_CANDIDATE",
      sessionCandidate: signedIn.sessionCandidate,
    });
  }

  return Object.freeze({
    async reconcile(
      intentId: string,
    ): Promise<FirstAdminAuthIdentityReconciliationResult> {
      if (!UUID_PATTERN.test(intentId)) {
        return failure("SECURITY_CORRELATION_FAILURE");
      }

      let initialResolution: FirstAdminAuthHandoffResult;
      try {
        initialResolution = await handoffService.resolve({
          intentId: intentId.toLowerCase(),
        });
      } catch {
        return failure("RETRYABLE_FAILURE");
      }
      if (initialResolution.outcome !== "ELIGIBLE") {
        return mapHandoffFailure(initialResolution);
      }

      const initial = preserveContext(initialResolution.context);
      const initialSignIn = await signIn(initial);
      if (initialSignIn === null) {
        return failure("REPAIR_REQUIRED");
      }

      if (initial.boundAuthUserId !== null) {
        if (initialSignIn.outcome !== "SESSION_CANDIDATE") {
          return mapSignInFailure(initialSignIn);
        }
        if (initialSignIn.authUserId !== initial.boundAuthUserId) {
          return failure("SECURITY_CORRELATION_FAILURE");
        }
        return correlate(initial, initialSignIn);
      }

      if (initialSignIn.outcome === "SESSION_CANDIDATE") {
        return correlate(initial, initialSignIn);
      }
      if (initialSignIn.outcome !== "DEFINITE_CREDENTIAL_FAILURE") {
        return mapSignInFailure(initialSignIn);
      }

      let currentResolution: FirstAdminAuthHandoffResult;
      try {
        currentResolution = await handoffService.resolve({
          intentId: initial.intentId,
        });
      } catch {
        return failure("RETRYABLE_FAILURE");
      }
      if (currentResolution.outcome !== "ELIGIBLE") {
        return mapHandoffFailure(currentResolution);
      }
      if (!contextMatchesInitial(initial, currentResolution.context)) {
        return failure("SECURITY_CORRELATION_FAILURE");
      }

      let provisioningResult: Awaited<
        ReturnType<ProvisioningService["provision"]>
      >;
      try {
        provisioningResult = await provisioningService.provision(
          currentResolution.context,
        );
      } catch {
        return failure("RETRYABLE_FAILURE");
      }

      if (provisioningResult.outcome === "DEFINITE_FAILURE") {
        return failure("REPAIR_REQUIRED");
      }
      if (provisioningResult.outcome === "AMBIGUOUS_FAILURE") {
        return failure("RETRYABLE_FAILURE");
      }

      const reconciliationSignIn = await signIn(currentResolution.context);
      if (reconciliationSignIn === null) {
        return provisioningResult.outcome === "CREATED"
          ? failure("SECURITY_CORRELATION_FAILURE")
          : failure("REPAIR_REQUIRED");
      }
      if (reconciliationSignIn.outcome !== "SESSION_CANDIDATE") {
        return provisioningResult.outcome === "CREATED"
          ? failure("SECURITY_CORRELATION_FAILURE")
          : mapSignInFailure(reconciliationSignIn);
      }
      if (
        provisioningResult.outcome === "CREATED" &&
        reconciliationSignIn.authUserId !== provisioningResult.authUserId
      ) {
        return failure("SECURITY_CORRELATION_FAILURE");
      }

      return correlate(initial, reconciliationSignIn);
    },
  });
}
