export type IssueVerificationChallengeInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  operationId: string;
}>;

export type ResendVerificationChallengeInput =
  IssueVerificationChallengeInput &
    Readonly<{
      predecessorChallengeId: string;
    }>;

export type VerifyVerificationChallengeInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  operationId: string;
}>;

export type VerificationAttemptOutcome = Readonly<{
  attemptNumber: number;
  authBridgeCredentialId: string | null;
  outcome: "CONSUMED" | "EXHAUSTED" | "INVALID";
  sessionGrantId: string | null;
}>;

export function genericVerificationDenial(): Error {
  return new Error("Verification request denied.");
}
