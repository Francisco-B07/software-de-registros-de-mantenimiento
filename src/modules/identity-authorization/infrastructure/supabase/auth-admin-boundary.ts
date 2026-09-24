import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "../../../../infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "../../../../infrastructure/config/supabase-public";

import {
  genericAuthBridgeDenial,
  type AuthProvisioningResult,
  type CreateAuthUserInput,
  type UpdateTechnicalPasswordInput,
} from "../../application/auth-session-bridge";
import type {
  FirstAdminAuthProvisioningResult,
  FirstAdminAuthProvisioningSource,
  FirstAdminAuthProvisioningSourceInput,
} from "../../application/first-admin-onboarding";

const DUPLICATE_AUTH_ERROR_CODES = new Set([
  "email_exists",
  "user_already_exists",
]);

const DEFINITE_AUTH_ERROR_CODES = new Set([
  "bad_json",
  "bad_jwt",
  "email_provider_disabled",
  "not_admin",
  "validation_failed",
  "weak_password",
]);

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function createAuthAdminClient() {
  const { supabaseSecretKey } = getPrivateAuthConfig();
  const { url } = getSupabasePublicConfig();

  return createClient(url, supabaseSecretKey, {
    auth: {
      autoRefreshToken: false,
      detectSessionInUrl: false,
      persistSession: false,
    },
  });
}

function boundedFailure(
  outcome: Exclude<FirstAdminAuthProvisioningResult["outcome"], "CREATED">,
): FirstAdminAuthProvisioningResult {
  return Object.freeze({ outcome });
}

function classifyCreateUserError(error: unknown): FirstAdminAuthProvisioningResult {
  if (typeof error !== "object" || error === null) {
    return boundedFailure("AMBIGUOUS_FAILURE");
  }

  const code = Reflect.get(error, "code");
  if (typeof code !== "string") {
    return boundedFailure("AMBIGUOUS_FAILURE");
  }

  if (DUPLICATE_AUTH_ERROR_CODES.has(code)) {
    return boundedFailure("DUPLICATE_OR_CONFLICT");
  }

  return boundedFailure(
    DEFINITE_AUTH_ERROR_CODES.has(code)
      ? "DEFINITE_FAILURE"
      : "AMBIGUOUS_FAILURE",
  );
}

export function createSupabaseAuthAdminBoundary() {
  const client = createAuthAdminClient();

  return Object.freeze({
    async createVerifiedEmailUser(
      input: CreateAuthUserInput,
    ): Promise<AuthProvisioningResult> {
      const response = await client.auth.admin.createUser({
        email: input.email,
        email_confirm: true,
        password: input.technicalPassword,
      });

      if (response.error || !response.data.user?.id) {
        throw genericAuthBridgeDenial();
      }

      return Object.freeze({ authUserId: response.data.user.id });
    },

    async updateTechnicalPassword(
      input: UpdateTechnicalPasswordInput,
    ): Promise<AuthProvisioningResult> {
      const response = await client.auth.admin.updateUserById(input.authUserId, {
        password: input.technicalPassword,
      });

      if (response.error || !response.data.user?.id) {
        throw genericAuthBridgeDenial();
      }

      return Object.freeze({ authUserId: response.data.user.id });
    },
  });
}

export function createSupabaseFirstAdminAuthProvisioningSource(): FirstAdminAuthProvisioningSource {
  const client = createAuthAdminClient();

  return Object.freeze({
    async provisionVerifiedFirstAdminIdentity(
      input: FirstAdminAuthProvisioningSourceInput,
    ): Promise<FirstAdminAuthProvisioningResult> {
      try {
        const response = await client.auth.admin.createUser({
          email: input.authoritativeEmail,
          email_confirm: true,
          password: input.technicalPassword,
        });

        if (response.error !== null) {
          return classifyCreateUserError(response.error);
        }

        const authUserId = response.data.user?.id;
        if (typeof authUserId !== "string" || !UUID_PATTERN.test(authUserId)) {
          return boundedFailure("AMBIGUOUS_FAILURE");
        }

        return Object.freeze({
          authUserId: authUserId.toLowerCase(),
          outcome: "CREATED",
        });
      } catch {
        return boundedFailure("AMBIGUOUS_FAILURE");
      }
    },
  });
}
