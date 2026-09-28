export type FirstAdminProfileCompletionInput = Readonly<{
  firstName: string;
  lastName: string;
  operationId: string;
}>;

export type FirstAdminProfileCompletionDeniedReason =
  | "AUTHORIZATION_DENIED"
  | "IDENTITY_INCOMPATIBLE"
  | "INITIAL_MEMBERSHIP_CONFLICT"
  | "INVALID_INPUT"
  | "ONBOARDING_ALREADY_COMPLETED"
  | "SECURITY_CORRELATION_FAILURE";

export type FirstAdminProfileCompletionResult =
  | Readonly<{
      companyMembershipId: string;
      completedAt: string;
      outcome: "COMPLETED";
      platformUserId: string;
      reason: "COMPLETED";
    }>
  | Readonly<{
      companyMembershipId: string;
      completedAt: string;
      outcome: "ALREADY_COMPLETED";
      platformUserId: string;
      reason: "ALREADY_COMPLETED";
    }>
  | Readonly<{
      companyMembershipId: null;
      completedAt: null;
      outcome: "DENIED";
      platformUserId: null;
      reason: FirstAdminProfileCompletionDeniedReason;
    }>;

export type FirstAdminOnboardingState =
  | Readonly<{
      completedAt: null;
      state: "PENDING_PROFILE";
    }>
  | Readonly<{
      completedAt: string;
      state: "COMPLETED";
    }>
  | Readonly<{
      completedAt: null;
      state: "UNAVAILABLE";
    }>;

export interface FirstAdminProfileCompletionSource {
  complete(input: FirstAdminProfileCompletionInput): Promise<unknown>;
  resolveState(): Promise<unknown>;
}

export type FirstAdminProfileCompletionSourceFactory =
  () => Promise<FirstAdminProfileCompletionSource>;
