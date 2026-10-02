import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "../../../../infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "../../../../infrastructure/config/supabase-public";

import type {
  LaterUserEnrollmentServerSource,
  LaterUserEnrollmentVerificationResult,
} from "../../application/later-user-enrollment";

type Row = Readonly<Record<string, unknown>>;

function firstRow(data: unknown): Row {
  if (!Array.isArray(data) || data.length !== 1) {
    throw new Error("Later-user enrollment server operation denied.");
  }
  const row: unknown = data[0];
  if (typeof row !== "object" || row === null || Array.isArray(row)) {
    throw new Error("Later-user enrollment server operation denied.");
  }
  return row as Row;
}

function requireString(row: Row, key: string): string {
  const value = row[key];
  if (typeof value !== "string" || value.length === 0) {
    throw new Error("Later-user enrollment server operation denied.");
  }
  return value;
}

function parseBytea(value: unknown): Uint8Array {
  if (typeof value !== "string" || !/^\\x[0-9a-f]{64}$/i.test(value)) {
    throw new Error("Later-user enrollment server operation denied.");
  }
  return new Uint8Array(Buffer.from(value.slice(2), "hex"));
}

export function createSupabaseLaterUserEnrollmentServerSource(): LaterUserEnrollmentServerSource {
  const { supabaseSecretKey } = getPrivateAuthConfig();
  const { url } = getSupabasePublicConfig();
  const client = createClient(url, supabaseSecretKey, {
    auth: {
      autoRefreshToken: false,
      detectSessionInUrl: false,
      persistSession: false,
    },
  });

  return Object.freeze({
    async getChallengeMaterial(
      intentId: string,
      email: string,
      verificationOperationId: string,
    ) {
      const response = await client.rpc(
        "get_later_user_enrollment_challenge_material",
        {
          p_email: email,
          p_intent_id: intentId,
          p_verification_operation_id: verificationOperationId,
        },
      );
      if (response.error !== null) {
        throw new Error("Later-user enrollment server operation denied.");
      }
      const row = firstRow(response.data);
      return Object.freeze({
        challengeId: requireString(row, "challenge_id"),
        verifier: parseBytea(row.verifier),
        verifierKeyVersion: requireString(row, "verifier_key_version"),
      });
    },

    async getDeliveryTarget(intentId: string, challengeId: string) {
      const response = await client.rpc(
        "get_later_user_enrollment_delivery_target",
        {
          p_challenge_id: challengeId,
          p_intent_id: intentId,
        },
      );
      if (response.error !== null) {
        throw new Error("Later-user enrollment server operation denied.");
      }
      const row = firstRow(response.data);
      return Object.freeze({
        email: requireString(row, "target_email"),
        expiresAt: requireString(row, "expires_at"),
      });
    },

    async verifyTransition(
      input: Parameters<LaterUserEnrollmentServerSource["verifyTransition"]>[0],
    ) {
      const response = await client.rpc(
        "verify_later_user_enrollment_challenge",
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
        throw new Error("Later-user enrollment server operation denied.");
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
        throw new Error("Later-user enrollment server operation denied.");
      }

      return Object.freeze({
        attemptNumber,
        handoffReady,
        outcome,
      }) satisfies LaterUserEnrollmentVerificationResult;
    },
  });
}
