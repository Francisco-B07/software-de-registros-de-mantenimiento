export type FirstAdminOnboardingIssueReason =
  | "ALREADY_RECONCILED"
  | "AUTHORIZATION_DENIED"
  | "COMPETING_INTENT"
  | "ESTABLISHED"
  | "HANDOFF_READY"
  | "IDEMPOTENCY_CONFLICT"
  | "INCONSISTENT_AUTHORITY"
  | "INVALID_INPUT"
  | "NOT_ELIGIBLE"
  | "RESENT"
  | "STALE_OR_CONFLICT";

export type FirstAdminOnboardingIssueOutcome =
  | "ALREADY_RECONCILED"
  | "CONFLICT"
  | "DENIED"
  | "ESTABLISHED"
  | "RESENT"
  | "STALE_OR_CONFLICT";

export type DeliveryOutcome = "DELIVERED" | "FAILED" | "NOT_ATTEMPTED";

export type EstablishFirstAdminOnboardingIntentInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  establishmentOperationId: string;
  intentId: string;
  issueOperationId: string;
  maintenanceCompanyId: string;
}>;

export type ResendFirstAdminOnboardingChallengeInput = Readonly<{
  challengeId: string;
  code: string;
  intentId: string;
  issueOperationId: string;
}>;

export type VerifyFirstAdminOnboardingChallengeInput = Readonly<{
  code: string;
  email: string;
  intentId: string;
  verificationOperationId: string;
}>;

export type FirstAdminOnboardingIssueResult = Readonly<{
  challengeId: string | null;
  changed: boolean;
  delivery: DeliveryOutcome;
  expiresAt: string | null;
  intentId: string | null;
  issuedAt: string | null;
  outcome: FirstAdminOnboardingIssueOutcome;
  reason: FirstAdminOnboardingIssueReason;
}>;

export type FirstAdminOnboardingVerificationResult = Readonly<{
  attemptNumber: number;
  handoffReady: boolean;
  outcome: "CONSUMED" | "EXHAUSTED" | "INVALID";
}>;

export type FirstAdminVerificationCodeDeliveryInput = Readonly<{
  challengeId: string;
  code: string;
  email: string;
  expiresAt: string;
  intentId: string;
}>;

export interface FirstAdminVerificationCodeDelivery {
  deliver(input: FirstAdminVerificationCodeDeliveryInput): Promise<void>;
}

export interface FirstAdminOnboardingMutationSource {
  establish(input: Readonly<{
    challengeId: string;
    email: string;
    establishmentOperationId: string;
    intentId: string;
    issueOperationId: string;
    maintenanceCompanyId: string;
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

export type FirstAdminOnboardingMutationSourceFactory =
  () => Promise<FirstAdminOnboardingMutationSource>;

export interface FirstAdminOnboardingServerSource {
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
  }>): Promise<FirstAdminOnboardingVerificationResult>;
}

export function genericFirstAdminOnboardingDenial(): Error {
  return new Error("First-admin onboarding request denied.");
}
