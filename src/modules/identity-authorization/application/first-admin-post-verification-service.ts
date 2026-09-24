import type { FirstAdminAuthSessionEstablishmentResult } from "./first-admin-auth-session-establishment-service";
import type {
  FirstAdminOnboardingVerificationResult,
  VerifyFirstAdminOnboardingChallengeInput,
} from "./first-admin-onboarding";

export type FirstAdminPostVerificationResult = Readonly<{
  outcome:
    | "SUCCESS"
    | "RETRYABLE_NEW_ATTEMPT"
    | "RETRYABLE_FAILURE"
    | "FRESH_PROOF_REQUIRED"
    | "TERMINAL_FAILURE";
}>;

type VerificationService = Readonly<{
  verify(
    input: VerifyFirstAdminOnboardingChallengeInput,
  ): Promise<FirstAdminOnboardingVerificationResult>;
}>;

type SessionEstablishmentService = Readonly<{
  establish(intentId: string): Promise<FirstAdminAuthSessionEstablishmentResult>;
}>;

type Dependencies = Readonly<{
  sessionEstablishmentService: SessionEstablishmentService;
  verificationService: VerificationService;
}>;

function result(
  outcome: FirstAdminPostVerificationResult["outcome"],
): FirstAdminPostVerificationResult {
  return Object.freeze({ outcome });
}

function mapSessionOutcome(
  session: FirstAdminAuthSessionEstablishmentResult,
): FirstAdminPostVerificationResult {
  switch (session.outcome) {
    case "SESSION_ESTABLISHED":
    case "SESSION_ALREADY_ESTABLISHED":
      return result("SUCCESS");
    case "RETRYABLE_FAILURE":
      return result("RETRYABLE_FAILURE");
    case "SESSION_RECOVERY_REQUIRED":
      return result("FRESH_PROOF_REQUIRED");
    case "AUTH_SESSION_DELIVERY_FAILED":
    case "IDENTITY_INCOMPATIBLE":
    case "SECURITY_CORRELATION_FAILURE":
      return result("TERMINAL_FAILURE");
  }
}

export function createFirstAdminPostVerificationService({
  sessionEstablishmentService,
  verificationService,
}: Dependencies) {
  return Object.freeze({
    async complete(
      input: VerifyFirstAdminOnboardingChallengeInput,
    ): Promise<FirstAdminPostVerificationResult> {
      let verification: FirstAdminOnboardingVerificationResult;
      try {
        verification = await verificationService.verify(input);
      } catch {
        return result("TERMINAL_FAILURE");
      }

      if (verification.outcome === "INVALID") {
        return result("RETRYABLE_NEW_ATTEMPT");
      }
      if (verification.outcome === "EXHAUSTED") {
        return result("FRESH_PROOF_REQUIRED");
      }
      if (!verification.handoffReady) {
        return result("TERMINAL_FAILURE");
      }

      try {
        return mapSessionOutcome(
          await sessionEstablishmentService.establish(input.intentId),
        );
      } catch {
        return result("RETRYABLE_FAILURE");
      }
    },
  });
}
