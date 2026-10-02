import type {
  CurrentAuthorizationResult,
  ValidatedAuthIdentity,
} from "./application/authorization-context";
import { createAuthSessionBridgeService } from "./application/auth-session-bridge-service";
import { resolveCurrentAuthorizationContextWithSource } from "./application/resolve-current-authorization-context";
import { createSupabaseCurrentAuthorizationSource } from "./infrastructure/supabase/current-authorization-source";
import { createVerificationChallengeService } from "./application/verification-challenge-service";
import { createSupabaseAuthAdminBoundary } from "./infrastructure/supabase/auth-admin-boundary";
import { createSupabaseTechnicalSignInBoundary } from "./infrastructure/supabase/technical-sign-in";
import { resolveCurrentGlobalAuthorizationWithSource } from "./application/resolve-current-global-authorization";
import { createSupabaseCurrentGlobalAuthorizationSource } from "./infrastructure/supabase/current-global-authorization-source";
import {
  applyCompanyMembershipLifecycleWithSource,
  type CompanyMembershipLifecycleInput,
} from "./application/apply-company-membership-lifecycle";
import { createSupabaseCompanyMembershipLifecycleSource } from "./infrastructure/supabase/company-membership-lifecycle-source";
import {
  createFirstAdminAuthHandoffService,
  createFirstAdminOnboardingService,
} from "./application/first-admin-onboarding-service";
import { createFirstAdminAuthProvisioningService } from "./application/first-admin-auth-provisioning-service";
import { createFirstAdminAuthIdentityReconciliationService } from "./application/first-admin-auth-identity-reconciliation-service";
import {
  createFirstAdminAuthSessionEstablishmentService,
} from "./application/first-admin-auth-session-establishment-service";
import { createFirstAdminPostVerificationService } from "./application/first-admin-post-verification-service";
import { createFirstAdminProfileCompletionService } from "./application/first-admin-profile-completion-service";
import type { FirstAdminVerificationCodeDelivery } from "./application/first-admin-onboarding";
import { createLaterUserEnrollmentService } from "./application/later-user-enrollment-service";
import type { LaterUserVerificationCodeDelivery } from "./application/later-user-enrollment";
import { createUnavailableLaterUserVerificationDelivery } from "./infrastructure/delivery/later-user-verification-delivery";
import type { SupabaseServerCookieMethods } from "../../infrastructure/supabase/server";

export type {
  CurrentAuthorizationContext,
  CurrentAuthorizationResult,
  TenantRole,
  ValidatedAuthIdentity,
} from "./application/authorization-context";
export type {
  IssueVerificationChallengeInput,
  ResendVerificationChallengeInput,
  VerificationAttemptOutcome,
  VerifyVerificationChallengeInput,
} from "./application/verification-challenge";
export type {
  AuthProvisioningResult,
  CreateAuthUserInput,
  TechnicalSignInInput,
  TechnicalSignInResult,
  UpdateTechnicalPasswordInput,
} from "./application/auth-session-bridge";
export type { EstablishTechnicalIdentityInput } from "./application/auth-session-bridge-service";
export type { FirstAdminAuthIdentityReconciliationResult } from "./application/first-admin-auth-identity-reconciliation-service";
export type { FirstAdminAuthSessionEstablishmentResult } from "./application/first-admin-auth-session-establishment-service";
export type { FirstAdminPostVerificationResult } from "./application/first-admin-post-verification-service";
export type {
  FirstAdminOnboardingState,
  FirstAdminProfileCompletionInput,
  FirstAdminProfileCompletionResult,
} from "./application/first-admin-profile-completion";
export type { CurrentGlobalAuthorizationResult } from "./application/resolve-current-global-authorization";
export type {
  CompanyMembershipLifecycleInput,
  CompanyMembershipLifecycleResult,
} from "./application/apply-company-membership-lifecycle";
export type {
  DeliveryOutcome,
  EstablishFirstAdminOnboardingIntentInput,
  FirstAdminAuthHandoffContext,
  FirstAdminAuthHandoffIdentityCompatibility,
  FirstAdminAuthHandoffResult,
  FirstAdminAuthProvisioningOutcome,
  FirstAdminAuthProvisioningResult,
  FirstAdminOnboardingIssueResult,
  FirstAdminOnboardingVerificationResult,
  FirstAdminVerificationCodeDelivery,
  FirstAdminVerificationCodeDeliveryInput,
  ResendFirstAdminOnboardingChallengeInput,
  ResolveFirstAdminAuthHandoffInput,
  VerifyFirstAdminOnboardingChallengeInput,
} from "./application/first-admin-onboarding";
export type {
  EstablishLaterUserEnrollmentIntentInput,
  LaterUserDeliveryOutcome,
  LaterUserEnrollmentIssueResult,
  LaterUserEnrollmentVerificationResult,
  LaterUserIntendedRole,
  LaterUserVerificationCodeDelivery,
  LaterUserVerificationCodeDeliveryInput,
  ResendLaterUserEnrollmentChallengeInput,
  VerifyLaterUserEnrollmentChallengeInput,
} from "./application/later-user-enrollment";

export function resolveCurrentAuthorizationContext(
  identity: ValidatedAuthIdentity | null | undefined,
): Promise<CurrentAuthorizationResult> {
  return resolveCurrentAuthorizationContextWithSource(
    identity,
    createSupabaseCurrentAuthorizationSource,
  );
}

export function resolveCurrentGlobalAuthorization(
  identity: ValidatedAuthIdentity | null | undefined,
): Promise<import("./application/resolve-current-global-authorization").CurrentGlobalAuthorizationResult> {
  return resolveCurrentGlobalAuthorizationWithSource(
    identity,
    createSupabaseCurrentGlobalAuthorizationSource,
  );
}

export function getVerificationChallengeService() {
  return createVerificationChallengeService();
}

export function getAuthProvisioningBoundary() {
  return createSupabaseAuthAdminBoundary();
}

export function getTechnicalSignInBoundary() {
  return createSupabaseTechnicalSignInBoundary();
}

export function getAuthSessionBridgeService() {
  return createAuthSessionBridgeService();
}

export function applyCompanyMembershipLifecycle(
  input: CompanyMembershipLifecycleInput,
) {
  return applyCompanyMembershipLifecycleWithSource(
    input,
    createSupabaseCompanyMembershipLifecycleSource,
  );
}

export function getFirstAdminOnboardingService(
  delivery: FirstAdminVerificationCodeDelivery,
) {
  return createFirstAdminOnboardingService(delivery);
}

export function getLaterUserEnrollmentService(
  delivery: LaterUserVerificationCodeDelivery,
) {
  return createLaterUserEnrollmentService(delivery);
}

export function getLaterUserEnrollmentVerificationService() {
  return createLaterUserEnrollmentService(
    createUnavailableLaterUserVerificationDelivery(),
  );
}

export function getFirstAdminAuthHandoffService() {
  return createFirstAdminAuthHandoffService();
}

export function getFirstAdminAuthProvisioningService() {
  return createFirstAdminAuthProvisioningService();
}

export function getFirstAdminAuthIdentityReconciliationService() {
  return createFirstAdminAuthIdentityReconciliationService();
}

export function getFirstAdminAuthSessionEstablishmentService(
  requestCookies: SupabaseServerCookieMethods,
) {
  return createFirstAdminAuthSessionEstablishmentService(requestCookies);
}

export function getFirstAdminProfileCompletionService() {
  return createFirstAdminProfileCompletionService();
}

const verificationOnlyDelivery: FirstAdminVerificationCodeDelivery =
  Object.freeze({
    async deliver() {
      throw new Error("Challenge delivery is unavailable in this boundary.");
    },
  });

export function getFirstAdminPostVerificationService(
  requestCookies: SupabaseServerCookieMethods,
) {
  return createFirstAdminPostVerificationService({
    sessionEstablishmentService:
      createFirstAdminAuthSessionEstablishmentService(requestCookies),
    verificationService: createFirstAdminOnboardingService(
      verificationOnlyDelivery,
    ),
  });
}
