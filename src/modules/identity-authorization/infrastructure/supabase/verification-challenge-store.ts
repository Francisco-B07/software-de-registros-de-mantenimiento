import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "@infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "@infrastructure/config/supabase-public";

import type { VerificationAttemptOutcome } from "../../application/verification-challenge";

type ChallengeMaterial = Readonly<{
  verifier: Uint8Array;
  verifierKeyVersion: string;
}>;

type IssueResult = Readonly<{
  challengeId: string;
  expiresAt: string;
  issuedAt: string;
}>;

type Row = Readonly<Record<string, unknown>>;

function firstRow(data: unknown): Row {
  if (!Array.isArray(data) || data.length !== 1) {
    throw new Error("Verification challenge persistence operation denied.");
  }

  const row: unknown = data[0];

  if (typeof row !== "object" || row === null) {
    throw new Error("Verification challenge persistence operation denied.");
  }

  return row as Row;
}

function requireString(row: Row, key: string): string {
  const value = row[key];

  if (typeof value !== "string" || !value) {
    throw new Error("Verification challenge persistence operation denied.");
  }

  return value;
}

function nullableString(row: Row, key: string): string | null {
  const value = row[key];

  if (value === null) {
    return null;
  }

  return requireString(row, key);
}

function parseBytea(value: unknown): Uint8Array {
  if (typeof value !== "string" || !/^\\x[0-9a-f]{64}$/i.test(value)) {
    throw new Error("Verification challenge persistence operation denied.");
  }

  return new Uint8Array(Buffer.from(value.slice(2), "hex"));
}

function bytea(value: Uint8Array): string {
  return `\\x${Buffer.from(value).toString("hex")}`;
}

export function createSupabaseVerificationChallengeStore() {
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
    async getMaterial(
      challengeId: string,
      email: string,
    ): Promise<ChallengeMaterial> {
      const response = await client.rpc("get_verification_challenge_material", {
        p_challenge_id: challengeId,
        p_email: email,
      });

      if (response.error) {
        throw new Error("Verification challenge persistence operation denied.");
      }

      const row = firstRow(response.data);

      return Object.freeze({
        verifier: parseBytea(row.verifier),
        verifierKeyVersion: requireString(row, "verifier_key_version"),
      });
    },

    async issue(input: Readonly<{
      challengeId: string;
      email: string;
      operationId: string;
      verifier: Uint8Array;
      verifierKeyVersion: string;
    }>): Promise<IssueResult> {
      const response = await client.rpc("issue_verification_challenge", {
        p_challenge_id: input.challengeId,
        p_email: input.email,
        p_issue_operation_id: input.operationId,
        p_verifier: bytea(input.verifier),
        p_verifier_key_version: input.verifierKeyVersion,
      });

      if (response.error) {
        throw new Error("Verification challenge persistence operation denied.");
      }

      const row = firstRow(response.data);

      return Object.freeze({
        challengeId: requireString(row, "challenge_id"),
        expiresAt: requireString(row, "expires_at"),
        issuedAt: requireString(row, "issued_at"),
      });
    },

    async resend(input: Readonly<{
      challengeId: string;
      email: string;
      operationId: string;
      predecessorChallengeId: string;
      verifier: Uint8Array;
      verifierKeyVersion: string;
    }>): Promise<IssueResult> {
      const response = await client.rpc("resend_verification_challenge", {
        p_challenge_id: input.challengeId,
        p_email: input.email,
        p_issue_operation_id: input.operationId,
        p_predecessor_challenge_id: input.predecessorChallengeId,
        p_verifier: bytea(input.verifier),
        p_verifier_key_version: input.verifierKeyVersion,
      });

      if (response.error) {
        throw new Error("Verification challenge persistence operation denied.");
      }

      const row = firstRow(response.data);

      return Object.freeze({
        challengeId: requireString(row, "challenge_id"),
        expiresAt: requireString(row, "expires_at"),
        issuedAt: requireString(row, "issued_at"),
      });
    },

    async verifyTransition(input: Readonly<{
      challengeId: string;
      email: string;
      matched: boolean;
      operationId: string;
      technicalPasswordKeyVersion: string;
    }>): Promise<VerificationAttemptOutcome> {
      const response = await client.rpc("verify_verification_challenge", {
        p_challenge_id: input.challengeId,
        p_email: input.email,
        p_matched: input.matched,
        p_technical_password_key_version: input.technicalPasswordKeyVersion,
        p_verification_operation_id: input.operationId,
      });

      if (response.error) {
        throw new Error("Verification challenge persistence operation denied.");
      }

      const row = firstRow(response.data);
      const attemptNumber = row.attempt_number;
      const outcome = row.outcome;

      if (
        typeof attemptNumber !== "number" ||
        (outcome !== "CONSUMED" &&
          outcome !== "EXHAUSTED" &&
          outcome !== "INVALID")
      ) {
        throw new Error("Verification challenge persistence operation denied.");
      }

      return Object.freeze({
        attemptNumber,
        authBridgeCredentialId: nullableString(
          row,
          "auth_bridge_credential_id",
        ),
        outcome,
        sessionGrantId: nullableString(row, "session_grant_id"),
      });
    },
  });
}
