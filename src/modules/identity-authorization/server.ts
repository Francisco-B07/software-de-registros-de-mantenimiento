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
export type { CurrentGlobalAuthorizationResult } from "./application/resolve-current-global-authorization";
export type {
  CompanyMembershipLifecycleInput,
  CompanyMembershipLifecycleResult,
} from "./application/apply-company-membership-lifecycle";

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
