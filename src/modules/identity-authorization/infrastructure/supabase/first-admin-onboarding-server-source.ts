import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "../../../../infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "../../../../infrastructure/config/supabase-public";

import type {
  FirstAdminAuthHandoffSource,
  FirstAdminOnboardingServerSource,
  FirstAdminOnboardingVerificationResult,
} from "../../application/first-admin-onboarding";

type Row = Readonly<Record<string, unknown>>;

function firstRow(data: unknown): Row {
  if (!Array.isArray(data) || data.length !== 1) {
    throw new Error("First-admin onboarding server operation denied.");
  }

  const row: unknown = data[0];
  if (typeof row !== "object" || row === null || Array.isArray(row)) {
    throw new Error("First-admin onboarding server operation denied.");
  }

  return row as Row;
}

function requireString(row: Row, key: string): string {
  const value = row[key];
  if (typeof value !== "string" || !value) {
    throw new Error("First-admin onboarding server operation denied.");
  }
  return value;
}

function parseBytea(value: unknown): Uint8Array {
  if (typeof value !== "string" || !/^\\x[0-9a-f]{64}$/i.test(value)) {
    throw new Error("First-admin onboarding server operation denied.");
  }

  return new Uint8Array(Buffer.from(value.slice(2), "hex"));
}

export function createSupabaseFirstAdminOnboardingServerSource(): FirstAdminOnboardingServerSource &
  FirstAdminAuthHandoffSource {
  const { supabaseSecretKey } = getPrivateAuthConfig();
  const { url } = getSupabasePublicConfig();
  const client = createClient(url, supabaseSecretKey, {
    auth: {
      autoRefreshToken: false,
      detectSessionInUrl: false,
      persistSession: false,
    },
  });

  const source: FirstAdminOnboardingServerSource & FirstAdminAuthHandoffSource = {
    async getChallengeMaterial(intentId, email, verificationOperationId) {
      const response = await client.rpc(
        "get_first_admin_onboarding_challenge_material",
        {
          p_email: email,
          p_intent_id: intentId,
          p_verification_operation_id: verificationOperationId,
        },
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding server operation denied.");
      }

      const row = firstRow(response.data);
      return Object.freeze({
        challengeId: requireString(row, "challenge_id"),
        verifier: parseBytea(row.verifier),
        verifierKeyVersion: requireString(row, "verifier_key_version"),
      });
    },

    async getDeliveryTarget(intentId, challengeId) {
      const response = await client.rpc(
        "get_first_admin_onboarding_delivery_target",
        {
          p_challenge_id: challengeId,
          p_intent_id: intentId,
        },
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding server operation denied.");
      }

      const row = firstRow(response.data);
      return Object.freeze({
        email: requireString(row, "target_email"),
        expiresAt: requireString(row, "expires_at"),
      });
    },

    async verifyTransition(input) {
      const response = await client.rpc(
        "verify_first_admin_onboarding_challenge",
        {
          p_email: input.email,
          p_expected_challenge_id: input.challengeId,
          p_intent_id: input.intentId,
          p_matched: input.matched,
          p_technical_password_key_version:
            input.technicalPasswordKeyVersion,
          p_verification_operation_id: input.verificationOperationId,
        },
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding server operation denied.");
      }

      const row = firstRow(response.data);
      const attemptNumber = row.attempt_number;
      const handoffReady = row.handoff_ready;
      const outcome = row.outcome;

      if (
        typeof attemptNumber !== "number" ||
        typeof handoffReady !== "boolean" ||
        (outcome !== "CONSUMED" &&
          outcome !== "EXHAUSTED" &&
          outcome !== "INVALID")
      ) {
        throw new Error("First-admin onboarding server operation denied.");
      }

      return Object.freeze({
        attemptNumber,
        handoffReady,
        outcome,
      }) satisfies FirstAdminOnboardingVerificationResult;
    },

    async resolveAuthHandoff(intentId) {
      const response = await client.rpc("resolve_first_admin_auth_handoff", {
        p_intent_id: intentId,
      });

      if (response.error !== null) {
        throw new Error("First-admin auth handoff resolution failed.");
      }

      return response.data;
    },
  };

  return Object.freeze(source);
}

export function createSupabaseFirstAdminAuthHandoffSource(): FirstAdminAuthHandoffSource {
  const source = createSupabaseFirstAdminOnboardingServerSource();

  return Object.freeze({
    resolveAuthHandoff: (intentId: string) =>
      source.resolveAuthHandoff(intentId),
  });
}
