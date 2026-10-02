export type LaterUserIntendedRole = "COMPANY_ADMIN" | "TECHNICIAN";

export type LaterUserEnrollmentIssueOutcome =
  | "ALREADY_RECONCILED"
  | "CONFLICT"
  | "DENIED"
  | "ESTABLISHED"
  | "RESENT"
  | "STALE_OR_CONFLICT";

export type LaterUserEnrollmentIssueReason =
  | "ALREADY_RECONCILED"
  | "AUTHORIZATION_DENIED"
  | "ESTABLISHED"
  | "HANDOFF_READY"
  | "IDEMPOTENCY_CONFLICT"
  | "INVALID_INPUT"
  | "NOT_ELIGIBLE"
  | "PRODUCT_DECISION_REQUIRED"
  | "RESENT"
  | "RESTART_REPLACE_UNDEFINED"
  | "STALE_OR_CONFLICT";

export type LaterUserDeliveryOutcome =
  | "DELIVERED"
  | "FAILED"
  | "NOT_ATTEMPTED";

export type EstablishLaterUserEnrollmentIntentInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  establishmentOperationId: string;
  intendedRole: LaterUserIntendedRole;
  intentId: string;
  issueOperationId: string;
}>;

export type ResendLaterUserEnrollmentChallengeInput = Readonly<{
  challengeId: string;
  code: string;
  intentId: string;
  issueOperationId: string;
}>;

export type VerifyLaterUserEnrollmentChallengeInput = Readonly<{
  code: string;
  email: string;
  intentId: string;
  verificationOperationId: string;
}>;

export type LaterUserEnrollmentIssueResult = Readonly<{
  challengeId: string | null;
  changed: boolean;
  delivery: LaterUserDeliveryOutcome;
  expiresAt: string | null;
  intentId: string | null;
  issuedAt: string | null;
  outcome: LaterUserEnrollmentIssueOutcome;
  reason: LaterUserEnrollmentIssueReason;
}>;

export type LaterUserEnrollmentVerificationResult = Readonly<{
  attemptNumber: number;
  handoffReady: boolean;
  outcome: "CONSUMED" | "EXHAUSTED" | "INVALID";
}>;

export type LaterUserVerificationCodeDeliveryInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  expiresAt: string;
  intentId: string;
  verificationUrl: string;
}>;

export interface LaterUserVerificationCodeDelivery {
  deliver(input: LaterUserVerificationCodeDeliveryInput): Promise<void>;
}

export interface LaterUserEnrollmentMutationSource {
  establish(input: Readonly<{
    challengeId: string;
    email: string;
    establishmentOperationId: string;
    intendedRole: LaterUserIntendedRole;
    intentId: string;
    issueOperationId: string;
    verifier: Uint8Array;
    verifierKeyVersion: string;
  }>): Promise<unknown>;
  resend(input: Readonly<{
    challengeId: string;
    intentId: string;
    issueOperationId: string;
    verifier: Uint8Array;
    verifierKeyVersion: string;
  }>): Promise<unknown>;
}

export type LaterUserEnrollmentMutationSourceFactory =
  () => Promise<LaterUserEnrollmentMutationSource>;

export interface LaterUserEnrollmentServerSource {
  getChallengeMaterial(
    intentId: string,
    email: string,
    verificationOperationId: string,
  ): Promise<Readonly<{
    challengeId: string;
    verifier: Uint8Array;
    verifierKeyVersion: string;
  }>>;
  getDeliveryTarget(
    intentId: string,
    challengeId: string,
  ): Promise<Readonly<{
    email: string;
    expiresAt: string;
  }>>;
  verifyTransition(input: Readonly<{
    challengeId: string;
    email: string;
    intentId: string;
    matched: boolean;
    technicalPasswordKeyVersion: string;
    verificationOperationId: string;
  }>): Promise<LaterUserEnrollmentVerificationResult>;
}

export function genericLaterUserEnrollmentDenial(): Error {
  return new Error("Later-user enrollment request denied.");
}
