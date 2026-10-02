import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../infrastructure/config/auth-private";
import { getTrustedAppOrigin } from "../../../infrastructure/config/app-origin";

import {
  compareChallengeVerifiers,
  createChallengeVerifier,
} from "../infrastructure/crypto/challenge-verifier";
import { createSupabaseLaterUserEnrollmentMutationSource } from "../infrastructure/supabase/later-user-enrollment-source";
import { createSupabaseLaterUserEnrollmentServerSource } from "../infrastructure/supabase/later-user-enrollment-server-source";
import {
  genericLaterUserEnrollmentDenial,
  type EstablishLaterUserEnrollmentIntentInput,
  type LaterUserEnrollmentIssueOutcome,
  type LaterUserEnrollmentIssueReason,
  type LaterUserEnrollmentIssueResult,
  type LaterUserEnrollmentMutationSourceFactory,
  type LaterUserEnrollmentServerSource,
  type LaterUserEnrollmentVerificationResult,
  type LaterUserVerificationCodeDelivery,
  type ResendLaterUserEnrollmentChallengeInput,
  type VerifyLaterUserEnrollmentChallengeInput,
} from "./later-user-enrollment";

type Row = Readonly<Record<string, unknown>>;

type Dependencies = Readonly<{
  createMutationSource?: LaterUserEnrollmentMutationSourceFactory;
  createServerSource?: () => LaterUserEnrollmentServerSource;
  trustedAppOrigin?: string;
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const ISSUE_OUTCOMES = new Set<LaterUserEnrollmentIssueOutcome>([
  "ALREADY_RECONCILED",
  "CONFLICT",
  "DENIED",
  "ESTABLISHED",
  "RESENT",
  "STALE_OR_CONFLICT",
]);

const ISSUE_REASONS = new Set<LaterUserEnrollmentIssueReason>([
  "ALREADY_RECONCILED",
  "AUTHORIZATION_DENIED",
  "ESTABLISHED",
  "HANDOFF_READY",
  "IDEMPOTENCY_CONFLICT",
  "INVALID_INPUT",
  "NOT_ELIGIBLE",
  "PRODUCT_DECISION_REQUIRED",
  "RESENT",
  "RESTART_REPLACE_UNDEFINED",
  "STALE_OR_CONFLICT",
]);

const ISSUE_KEYS = [
  "outcome",
  "changed",
  "intent_id",
  "challenge_id",
  "issued_at",
  "expires_at",
  "reason",
] as const;

function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_PATTERN.test(value);
}

function isEmail(value: unknown): value is string {
  return (
    typeof value === "string" &&
    value.length > 0 &&
    value.length <= 320 &&
    value === value.trim()
  );
}

function isCode(value: unknown): value is string {
  return typeof value === "string" && value.length > 0 && value.length <= 512;
}

function isTimestamp(value: unknown): value is string {
  return (
    typeof value === "string" &&
    value.length > 0 &&
    Number.isFinite(Date.parse(value))
  );
}

function hasExactKeys(row: Row, keys: readonly string[]): boolean {
  return (
    Object.keys(row).sort().join("\u0000") ===
    [...keys].sort().join("\u0000")
  );
}

function singleRow(value: unknown): Row | null {
  if (!Array.isArray(value) || value.length !== 1) {
    return null;
  }
  const row: unknown = value[0];
  return typeof row === "object" && row !== null && !Array.isArray(row)
    ? (row as Row)
    : null;
}

function parseIssueResult(value: unknown): LaterUserEnrollmentIssueResult {
  const row = singleRow(value);
  if (
    row === null ||
    !hasExactKeys(row, ISSUE_KEYS) ||
    typeof row.outcome !== "string" ||
    !ISSUE_OUTCOMES.has(row.outcome as LaterUserEnrollmentIssueOutcome) ||
    typeof row.reason !== "string" ||
    !ISSUE_REASONS.has(row.reason as LaterUserEnrollmentIssueReason) ||
    typeof row.changed !== "boolean"
  ) {
    throw genericLaterUserEnrollmentDenial();
  }

  const hasEmission =
    row.outcome === "ESTABLISHED" ||
    row.outcome === "RESENT" ||
    row.outcome === "ALREADY_RECONCILED";

  if (
    hasEmission &&
    (!isUuid(row.intent_id) ||
      !isUuid(row.challenge_id) ||
      !isTimestamp(row.issued_at) ||
      !isTimestamp(row.expires_at))
  ) {
    throw genericLaterUserEnrollmentDenial();
  }

  if (
    !hasEmission &&
    (row.intent_id !== null ||
      row.challenge_id !== null ||
      row.issued_at !== null ||
      row.expires_at !== null ||
      row.changed)
  ) {
    throw genericLaterUserEnrollmentDenial();
  }

  return Object.freeze({
    challengeId: hasEmission ? (row.challenge_id as string) : null,
    changed: row.changed,
    delivery: "NOT_ATTEMPTED" as const,
    expiresAt: hasEmission ? (row.expires_at as string) : null,
    intentId: hasEmission ? (row.intent_id as string) : null,
    issuedAt: hasEmission ? (row.issued_at as string) : null,
    outcome: row.outcome as LaterUserEnrollmentIssueOutcome,
    reason: row.reason as LaterUserEnrollmentIssueReason,
  });
}

function trustedVerificationUrl(originValue: string, intentId: string): string {
  const origin = new URL(originValue);
  if (
    !["http:", "https:"].includes(origin.protocol) ||
    origin.username !== "" ||
    origin.password !== "" ||
    origin.pathname !== "/" ||
    origin.search !== "" ||
    origin.hash !== ""
  ) {
    throw genericLaterUserEnrollmentDenial();
  }

  return new URL(
    `/later-user/verification/${encodeURIComponent(intentId)}`,
    origin.origin,
  ).toString();
}

function invalidIssue(): LaterUserEnrollmentIssueResult {
  return Object.freeze({
    challengeId: null,
    changed: false,
    delivery: "NOT_ATTEMPTED",
    expiresAt: null,
    intentId: null,
    issuedAt: null,
    outcome: "DENIED",
    reason: "INVALID_INPUT",
  });
}

export function createLaterUserEnrollmentService(
  delivery: LaterUserVerificationCodeDelivery,
  dependencies: Dependencies = {},
) {
  const createMutationSource =
    dependencies.createMutationSource ??
    createSupabaseLaterUserEnrollmentMutationSource;
  const createServerSource =
    dependencies.createServerSource ??
    createSupabaseLaterUserEnrollmentServerSource;

  async function deliverCommitted(
    result: LaterUserEnrollmentIssueResult,
    code: string,
  ): Promise<LaterUserEnrollmentIssueResult> {
    if (
      result.intentId === null ||
      result.challengeId === null ||
      result.expiresAt === null
    ) {
      return result;
    }

    try {
      const target = await createServerSource().getDeliveryTarget(
        result.intentId,
        result.challengeId,
      );
      const verificationUrl = trustedVerificationUrl(
        dependencies.trustedAppOrigin ?? getTrustedAppOrigin(),
        result.intentId,
      );
      await delivery.deliver({
        challengeId: result.challengeId,
        code,
        email: target.email,
        expiresAt: target.expiresAt,
        intentId: result.intentId,
        verificationUrl,
      });
      return Object.freeze({ ...result, delivery: "DELIVERED" });
    } catch {
      return Object.freeze({ ...result, delivery: "FAILED" });
    }
  }

  return Object.freeze({
    async establish(
      input: EstablishLaterUserEnrollmentIntentInput,
    ): Promise<LaterUserEnrollmentIssueResult> {
      if (
        !isUuid(input.intentId) ||
        !isUuid(input.challengeId) ||
        !isUuid(input.establishmentOperationId) ||
        !isUuid(input.issueOperationId) ||
        !isEmail(input.email) ||
        !isCode(input.code) ||
        (input.intendedRole !== "COMPANY_ADMIN" &&
          input.intendedRole !== "TECHNICIAN")
      ) {
        return invalidIssue();
      }

      const privateConfig = getPrivateAuthConfig();
      const verifier = createChallengeVerifier({
        challengeId: input.challengeId,
        code: input.code,
        keyMaterial: resolvePrivateKey(
          privateConfig.challengeHmacKeys,
          privateConfig.challengeHmacActiveVersion,
        ),
      });
      const rawResult = await (await createMutationSource()).establish({
        challengeId: input.challengeId,
        email: input.email,
        establishmentOperationId: input.establishmentOperationId,
        intendedRole: input.intendedRole,
        intentId: input.intentId,
        issueOperationId: input.issueOperationId,
        verifier,
        verifierKeyVersion: privateConfig.challengeHmacActiveVersion,
      });
      return deliverCommitted(parseIssueResult(rawResult), input.code);
    },

    async resend(
      input: ResendLaterUserEnrollmentChallengeInput,
    ): Promise<LaterUserEnrollmentIssueResult> {
      if (
        !isUuid(input.intentId) ||
        !isUuid(input.challengeId) ||
        !isUuid(input.issueOperationId) ||
        !isCode(input.code)
      ) {
        return invalidIssue();
      }

      const privateConfig = getPrivateAuthConfig();
      const verifier = createChallengeVerifier({
        challengeId: input.challengeId,
        code: input.code,
        keyMaterial: resolvePrivateKey(
          privateConfig.challengeHmacKeys,
          privateConfig.challengeHmacActiveVersion,
        ),
      });
      const rawResult = await (await createMutationSource()).resend({
        challengeId: input.challengeId,
        intentId: input.intentId,
        issueOperationId: input.issueOperationId,
        verifier,
        verifierKeyVersion: privateConfig.challengeHmacActiveVersion,
      });
      return deliverCommitted(parseIssueResult(rawResult), input.code);
    },

    async verify(
      input: VerifyLaterUserEnrollmentChallengeInput,
    ): Promise<LaterUserEnrollmentVerificationResult> {
      if (
        !isUuid(input.intentId) ||
        !isUuid(input.verificationOperationId) ||
        !isEmail(input.email) ||
        !isCode(input.code)
      ) {
        throw genericLaterUserEnrollmentDenial();
      }

      try {
        const privateConfig = getPrivateAuthConfig();
        const source = createServerSource();
        const material = await source.getChallengeMaterial(
          input.intentId,
          input.email,
          input.verificationOperationId,
        );
        const candidate = createChallengeVerifier({
          challengeId: material.challengeId,
          code: input.code,
          keyMaterial: resolvePrivateKey(
            privateConfig.challengeHmacKeys,
            material.verifierKeyVersion,
          ),
        });
        return await source.verifyTransition({
          challengeId: material.challengeId,
          email: input.email,
          intentId: input.intentId,
          matched: compareChallengeVerifiers(material.verifier, candidate),
          technicalPasswordKeyVersion:
            privateConfig.technicalPasswordActiveVersion,
          verificationOperationId: input.verificationOperationId,
        });
      } catch {
        throw genericLaterUserEnrollmentDenial();
      }
    },
  });
}
