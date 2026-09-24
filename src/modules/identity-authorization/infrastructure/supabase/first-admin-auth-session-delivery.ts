import type { CookieMethodsServer, CookieOptions } from "@supabase/ssr";

import {
  createSupabaseServerClient,
  type SupabaseServerCookieMethods,
} from "../../../../infrastructure/supabase/server";

import type { TechnicalSessionCandidate } from "../../application/auth-session-bridge";
import { readTechnicalSessionCandidate } from "./technical-session-candidate-server-vault";

type CookieMutation = Readonly<{
  name: string;
  options: CookieOptions;
  value: string;
}>;

export type ExistingFirstAdminAuthSessionInspection =
  | Readonly<{
      commit: () => Promise<"COMMITTED" | "FAILED">;
      outcome: "VALIDATED";
      subject: string;
    }>
  | Readonly<{ outcome: "NO_VALID_SESSION" }>
  | Readonly<{ outcome: "RETRYABLE_FAILURE" }>;

export type FirstAdminAuthSessionCandidateDeliveryResult = Readonly<{
  outcome:
    | "SESSION_ESTABLISHED"
    | "AUTH_SESSION_DELIVERY_FAILED"
    | "RETRYABLE_FAILURE"
    | "SECURITY_CORRELATION_FAILURE";
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function isNonEmptyString(value: unknown): value is string {
  return (
    typeof value === "string" && value.length > 0 && value.trim() === value
  );
}

function boundedCandidateResult(
  outcome: FirstAdminAuthSessionCandidateDeliveryResult["outcome"],
): FirstAdminAuthSessionCandidateDeliveryResult {
  return Object.freeze({ outcome });
}

function createBufferedCookieLifecycle(
  target: SupabaseServerCookieMethods,
): Readonly<{
  commit: () => Promise<"COMMITTED" | "FAILED">;
  cookieMethods: SupabaseServerCookieMethods;
  hasMutations: () => boolean;
}> {
  const cookieMutations: CookieMutation[] = [];
  const responseHeaders = new Map<string, string>();
  let commitAttempted = false;
  const bufferMutations: NonNullable<CookieMethodsServer["setAll"]> = (
    cookiesToSet,
    headers,
  ) => {
    cookieMutations.push(...cookiesToSet);
    Object.entries(headers).forEach(([name, value]) => {
      responseHeaders.set(name, value);
    });
  };

  return Object.freeze({
    async commit(): Promise<"COMMITTED" | "FAILED"> {
      if (commitAttempted) {
        return "FAILED";
      }
      commitAttempted = true;

      if (cookieMutations.length === 0) {
        return "COMMITTED";
      }

      try {
        await target.setAll(
          [...cookieMutations],
          Object.fromEntries(responseHeaders),
        );
        return "COMMITTED";
      } catch {
        return "FAILED";
      }
    },
    cookieMethods: Object.freeze({
      getAll: target.getAll,
      setAll: bufferMutations,
    }),
    hasMutations() {
      return cookieMutations.length > 0;
    },
  });
}

export function createSupabaseFirstAdminAuthSessionDeliveryBoundary(
  requestCookies: SupabaseServerCookieMethods,
) {
  return Object.freeze({
    async establishCandidate(
      sessionCandidate: TechnicalSessionCandidate,
      expectedAuthUserId: string,
    ): Promise<FirstAdminAuthSessionCandidateDeliveryResult> {
      const expectedSubject = expectedAuthUserId.toLowerCase();
      if (!UUID_PATTERN.test(expectedSubject)) {
        return boundedCandidateResult("SECURITY_CORRELATION_FAILURE");
      }

      let providerSession;
      try {
        providerSession = readTechnicalSessionCandidate(sessionCandidate);
      } catch {
        return boundedCandidateResult("SECURITY_CORRELATION_FAILURE");
      }

      try {
        if (
          providerSession.token_type !== "bearer" ||
          !isNonEmptyString(providerSession.access_token) ||
          !isNonEmptyString(providerSession.refresh_token) ||
          !UUID_PATTERN.test(providerSession.user?.id ?? "") ||
          providerSession.user.id.toLowerCase() !== expectedSubject
        ) {
          return boundedCandidateResult("SECURITY_CORRELATION_FAILURE");
        }

        const buffered = createBufferedCookieLifecycle(requestCookies);
        const supabase = await createSupabaseServerClient(
          buffered.cookieMethods,
        );
        const adoption = await supabase.auth.setSession({
          access_token: providerSession.access_token,
          refresh_token: providerSession.refresh_token,
        });

        if (adoption.error || !adoption.data.session || !adoption.data.user) {
          return boundedCandidateResult("AUTH_SESSION_DELIVERY_FAILED");
        }
        if (
          adoption.data.user.id.toLowerCase() !== expectedSubject ||
          adoption.data.session.user.id.toLowerCase() !== expectedSubject
        ) {
          return boundedCandidateResult("SECURITY_CORRELATION_FAILURE");
        }

        const validation = await supabase.auth.getClaims();
        if (validation.error || !validation.data?.claims) {
          return boundedCandidateResult("AUTH_SESSION_DELIVERY_FAILED");
        }
        if (validation.data.claims.sub.toLowerCase() !== expectedSubject) {
          return boundedCandidateResult("SECURITY_CORRELATION_FAILURE");
        }
        if (!buffered.hasMutations()) {
          return boundedCandidateResult("AUTH_SESSION_DELIVERY_FAILED");
        }
        if ((await buffered.commit()) !== "COMMITTED") {
          return boundedCandidateResult("AUTH_SESSION_DELIVERY_FAILED");
        }

        return boundedCandidateResult("SESSION_ESTABLISHED");
      } catch {
        return boundedCandidateResult("RETRYABLE_FAILURE");
      }
    },

    async inspectExistingSession(): Promise<ExistingFirstAdminAuthSessionInspection> {
      try {
        const buffered = createBufferedCookieLifecycle(requestCookies);
        const supabase = await createSupabaseServerClient(
          buffered.cookieMethods,
        );
        const validation = await supabase.auth.getClaims();
        const subject = validation.data?.claims?.sub;
        if (
          validation.error ||
          !isNonEmptyString(subject) ||
          !UUID_PATTERN.test(subject)
        ) {
          return Object.freeze({ outcome: "NO_VALID_SESSION" });
        }

        return Object.freeze({
          commit: buffered.commit,
          outcome: "VALIDATED",
          subject: subject.toLowerCase(),
        });
      } catch {
        return Object.freeze({ outcome: "RETRYABLE_FAILURE" });
      }
    },
  });
}
