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

export type FirstAdminAuthHandoffIdentityCompatibility =
  | "NO_APPLICATION_IDENTITY"
  | "COMPATIBLE_EXISTING_APPLICATION_IDENTITY"
  | "INCOMPATIBLE_IDENTITY";

export type FirstAdminAuthHandoffContext = Readonly<{
  authBridgeCredentialId: string;
  boundAuthUserId: string | null;
  currentChallengeId: string;
  handoffSessionGrantId: string;
  identityCompatibility: Exclude<
    FirstAdminAuthHandoffIdentityCompatibility,
    "INCOMPATIBLE_IDENTITY"
  >;
  intentId: string;
  maintenanceCompanyId: string;
  targetEmail: string;
}>;

export type FirstAdminAuthHandoffResult =
  | Readonly<{
      context: FirstAdminAuthHandoffContext;
      outcome: "ELIGIBLE";
    }>
  | Readonly<{
      identityCompatibility: FirstAdminAuthHandoffIdentityCompatibility;
      outcome: "GRANT_EXPIRED" | "GRANT_REVOKED" | "GRANT_CONSUMED";
    }>
  | Readonly<{ outcome: "IDENTITY_INCOMPATIBLE" }>
  | Readonly<{ outcome: "SECURITY_CORRELATION_FAILURE" }>
  | Readonly<{ outcome: "INFRASTRUCTURE_FAILURE" }>;

export type FirstAdminPostSignInAuthHandoffCorrelationResult =
  | Readonly<{
      authBridgeCredentialId: string;
      bridgeAuthUserId: string;
      currentChallengeId: string;
      grantAuthUserId: string;
      handoffSessionGrantId: string;
      identityCompatibility: Exclude<
        FirstAdminAuthHandoffIdentityCompatibility,
        "INCOMPATIBLE_IDENTITY"
      >;
      intentId: string;
      maintenanceCompanyId: string;
      outcome: "CORRELATED_CONSUMED";
      targetEmail: string;
    }>
  | Readonly<{ outcome: "NOT_CONSUMED" }>
  | Readonly<{ outcome: "IDENTITY_INCOMPATIBLE" }>
  | Readonly<{ outcome: "SECURITY_CORRELATION_FAILURE" }>
  | Readonly<{ outcome: "INFRASTRUCTURE_FAILURE" }>;

export type ResolveFirstAdminAuthHandoffInput = Readonly<{
  intentId: string;
}>;

export type FirstAdminAuthProvisioningOutcome =
  | "CREATED"
  | "DUPLICATE_OR_CONFLICT"
  | "DEFINITE_FAILURE"
  | "AMBIGUOUS_FAILURE";

export type FirstAdminAuthProvisioningResult =
  | Readonly<{
      authUserId: string;
      outcome: "CREATED";
    }>
  | Readonly<{
      outcome: Exclude<FirstAdminAuthProvisioningOutcome, "CREATED">;
    }>;

export type FirstAdminAuthProvisioningSourceInput = Readonly<{
  authoritativeEmail: string;
  technicalPassword: string;
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

export interface FirstAdminAuthHandoffSource {
  resolveAuthHandoff(intentId: string): Promise<unknown>;
}

export interface FirstAdminAuthTechnicalPasswordStateSource {
  resolveTechnicalPasswordState(
    authBridgeCredentialId: string,
  ): Promise<unknown>;
}

export interface FirstAdminAuthProvisioningSource {
  provisionVerifiedFirstAdminIdentity(
    input: FirstAdminAuthProvisioningSourceInput,
  ): Promise<FirstAdminAuthProvisioningResult>;
}

export function genericFirstAdminOnboardingDenial(): Error {
  return new Error("First-admin onboarding request denied.");
}
