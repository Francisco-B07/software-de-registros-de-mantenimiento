import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../infrastructure/config/auth-private";

import { deriveTechnicalPassword } from "../infrastructure/crypto/technical-password";
import { createSupabaseFirstAdminAuthProvisioningSource } from "../infrastructure/supabase/auth-admin-boundary";
import { createSupabaseFirstAdminAuthTechnicalPasswordStateSource } from "../infrastructure/supabase/first-admin-auth-technical-password-state-source";
import type {
  FirstAdminAuthHandoffContext,
  FirstAdminAuthProvisioningResult,
  FirstAdminAuthProvisioningSource,
  FirstAdminAuthTechnicalPasswordStateSource,
} from "./first-admin-onboarding";

type TechnicalPasswordConfig = Readonly<
  Pick<
    ReturnType<typeof getPrivateAuthConfig>,
    "passwordPolicy" | "technicalPasswordKeys"
  >
>;

type Dependencies = Readonly<{
  createProvisioningSource?: () => FirstAdminAuthProvisioningSource;
  createTechnicalPasswordStateSource?: () => FirstAdminAuthTechnicalPasswordStateSource;
  resolveTechnicalPassword?: (
    authBridgeCredentialId: string,
    technicalPasswordKeyVersion: string,
  ) => string;
}>;

type TechnicalPasswordState = Readonly<{
  rotationState: "READY" | "PENDING_ROTATION" | "FAIL_CLOSED";
  technicalPasswordKeyVersion: string | null;
}>;

type TechnicalPasswordResolution =
  | Readonly<{
      outcome: "READY";
      technicalPassword: string;
    }>
  | Readonly<{ outcome: "UNAVAILABLE" }>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const KEY_VERSION_PATTERN = /^[A-Za-z0-9._-]+$/;
const TECHNICAL_PASSWORD_STATE_KEYS = [
  "auth_bridge_credential_id",
  "rotation_state",
  "technical_password_key_version",
] as const;

function boundedFailure(
  outcome: "DEFINITE_FAILURE" | "AMBIGUOUS_FAILURE",
): FirstAdminAuthProvisioningResult {
  return Object.freeze({ outcome });
}

function normalizeProvisioningResult(
  value: unknown,
): FirstAdminAuthProvisioningResult {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return boundedFailure("AMBIGUOUS_FAILURE");
  }

  const result = value as Readonly<Record<string, unknown>>;
  if (
    result.outcome === "CREATED" &&
    typeof result.authUserId === "string" &&
    UUID_PATTERN.test(result.authUserId) &&
    Object.keys(result).sort().join("\u0000") ===
      ["authUserId", "outcome"].sort().join("\u0000")
  ) {
    return Object.freeze({
      authUserId: result.authUserId.toLowerCase(),
      outcome: "CREATED",
    });
  }

  if (
    (result.outcome === "DUPLICATE_OR_CONFLICT" ||
      result.outcome === "DEFINITE_FAILURE" ||
      result.outcome === "AMBIGUOUS_FAILURE") &&
    Object.keys(result).length === 1
  ) {
    return Object.freeze({ outcome: result.outcome });
  }

  return boundedFailure("AMBIGUOUS_FAILURE");
}

function parseTechnicalPasswordState(
  value: unknown,
  expectedAuthBridgeCredentialId: string,
): TechnicalPasswordState | null {
  if (!Array.isArray(value) || value.length !== 1) {
    return null;
  }

  const row: unknown = value[0];
  if (typeof row !== "object" || row === null || Array.isArray(row)) {
    return null;
  }

  const fields = row as Readonly<Record<string, unknown>>;
  if (
    Object.keys(fields).sort().join("\u0000") !==
      [...TECHNICAL_PASSWORD_STATE_KEYS].sort().join("\u0000") ||
    typeof fields.auth_bridge_credential_id !== "string" ||
    !UUID_PATTERN.test(fields.auth_bridge_credential_id) ||
    fields.auth_bridge_credential_id.toLowerCase() !==
      expectedAuthBridgeCredentialId ||
    (fields.rotation_state !== "READY" &&
      fields.rotation_state !== "PENDING_ROTATION" &&
      fields.rotation_state !== "FAIL_CLOSED")
  ) {
    return null;
  }

  if (fields.rotation_state === "READY") {
    if (
      typeof fields.technical_password_key_version !== "string" ||
      !KEY_VERSION_PATTERN.test(fields.technical_password_key_version)
    ) {
      return null;
    }

    return Object.freeze({
      rotationState: "READY",
      technicalPasswordKeyVersion:
        fields.technical_password_key_version,
    });
  }

  if (fields.technical_password_key_version !== null) {
    return null;
  }

  return Object.freeze({
    rotationState: fields.rotation_state,
    technicalPasswordKeyVersion: null,
  });
}

function unavailableTechnicalPassword(): TechnicalPasswordResolution {
  return Object.freeze({ outcome: "UNAVAILABLE" });
}

export function resolveFirstAdminTechnicalPassword(
  authBridgeCredentialId: string,
  technicalPasswordKeyVersion: string,
  config: TechnicalPasswordConfig = getPrivateAuthConfig(),
): string {
  if (
    !UUID_PATTERN.test(authBridgeCredentialId) ||
    !KEY_VERSION_PATTERN.test(technicalPasswordKeyVersion)
  ) {
    throw new Error("First-admin technical password resolution failed.");
  }

  return deriveTechnicalPassword({
    authBridgeCredentialId: authBridgeCredentialId.toLowerCase(),
    keyMaterial: resolvePrivateKey(
      config.technicalPasswordKeys,
      technicalPasswordKeyVersion,
    ),
    policy: config.passwordPolicy,
  });
}

export function createFirstAdminTechnicalPasswordService(
  dependencies: Dependencies = {},
) {
  const createTechnicalPasswordStateSource =
    dependencies.createTechnicalPasswordStateSource ??
    createSupabaseFirstAdminAuthTechnicalPasswordStateSource;
  const resolveTechnicalPassword =
    dependencies.resolveTechnicalPassword ?? resolveFirstAdminTechnicalPassword;

  return Object.freeze({
    async resolve(
      context: FirstAdminAuthHandoffContext,
    ): Promise<TechnicalPasswordResolution> {
      if (
        !UUID_PATTERN.test(context.authBridgeCredentialId) ||
        (context.boundAuthUserId !== null &&
          !UUID_PATTERN.test(context.boundAuthUserId)) ||
        typeof context.targetEmail !== "string" ||
        context.targetEmail.length === 0 ||
        context.targetEmail !== context.targetEmail.trim()
      ) {
        return unavailableTechnicalPassword();
      }

      const authBridgeCredentialId =
        context.authBridgeCredentialId.toLowerCase();
      let technicalPasswordState: TechnicalPasswordState | null;
      try {
        technicalPasswordState = parseTechnicalPasswordState(
          await createTechnicalPasswordStateSource().resolveTechnicalPasswordState(
            authBridgeCredentialId,
          ),
          authBridgeCredentialId,
        );
      } catch {
        return unavailableTechnicalPassword();
      }

      if (
        technicalPasswordState === null ||
        technicalPasswordState.rotationState !== "READY" ||
        technicalPasswordState.technicalPasswordKeyVersion === null
      ) {
        return unavailableTechnicalPassword();
      }

      try {
        return Object.freeze({
          outcome: "READY",
          technicalPassword: resolveTechnicalPassword(
            authBridgeCredentialId,
            technicalPasswordState.technicalPasswordKeyVersion,
          ),
        });
      } catch {
        return unavailableTechnicalPassword();
      }
    },
  });
}

export function createFirstAdminAuthProvisioningService(
  dependencies: Dependencies = {},
) {
  const createProvisioningSource =
    dependencies.createProvisioningSource ??
    createSupabaseFirstAdminAuthProvisioningSource;
  const technicalPasswordService =
    createFirstAdminTechnicalPasswordService(dependencies);

  return Object.freeze({
    async provision(
      context: FirstAdminAuthHandoffContext,
    ): Promise<FirstAdminAuthProvisioningResult> {
      if (
        !UUID_PATTERN.test(context.authBridgeCredentialId) ||
        context.boundAuthUserId !== null ||
        typeof context.targetEmail !== "string" ||
        context.targetEmail.length === 0 ||
        context.targetEmail !== context.targetEmail.trim()
      ) {
        return boundedFailure("DEFINITE_FAILURE");
      }

      const technicalPassword = await technicalPasswordService.resolve(context);
      if (technicalPassword.outcome !== "READY") {
        return boundedFailure("DEFINITE_FAILURE");
      }

      try {
        return normalizeProvisioningResult(
          await createProvisioningSource().provisionVerifiedFirstAdminIdentity({
            authoritativeEmail: context.targetEmail,
            technicalPassword: technicalPassword.technicalPassword,
          }),
        );
      } catch {
        return boundedFailure("AMBIGUOUS_FAILURE");
      }
    },
  });
}
