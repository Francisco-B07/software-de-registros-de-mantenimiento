import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../infrastructure/config/auth-private";

import {
  compareChallengeVerifiers,
  createChallengeVerifier,
} from "../infrastructure/crypto/challenge-verifier";
import { createSupabaseFirstAdminOnboardingMutationSource } from "../infrastructure/supabase/first-admin-onboarding-source";
import { createSupabaseFirstAdminOnboardingServerSource } from "../infrastructure/supabase/first-admin-onboarding-server-source";
import {
  genericFirstAdminOnboardingDenial,
  type EstablishFirstAdminOnboardingIntentInput,
  type FirstAdminOnboardingIssueOutcome,
  type FirstAdminOnboardingIssueReason,
  type FirstAdminOnboardingIssueResult,
  type FirstAdminOnboardingMutationSourceFactory,
  type FirstAdminOnboardingServerSource,
  type FirstAdminVerificationCodeDelivery,
  type ResendFirstAdminOnboardingChallengeInput,
  type VerifyFirstAdminOnboardingChallengeInput,
} from "./first-admin-onboarding";

type Row = Readonly<Record<string, unknown>>;

type Dependencies = Readonly<{
  createMutationSource?: FirstAdminOnboardingMutationSourceFactory;
  createServerSource?: () => FirstAdminOnboardingServerSource;
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const ISSUE_OUTCOMES = new Set<FirstAdminOnboardingIssueOutcome>([
  "ALREADY_RECONCILED",
  "CONFLICT",
  "DENIED",
  "ESTABLISHED",
  "RESENT",
  "STALE_OR_CONFLICT",
]);

const ISSUE_REASONS = new Set<FirstAdminOnboardingIssueReason>([
  "ALREADY_RECONCILED",
  "AUTHORIZATION_DENIED",
  "COMPETING_INTENT",
  "ESTABLISHED",
  "HANDOFF_READY",
  "IDEMPOTENCY_CONFLICT",
  "INCONSISTENT_AUTHORITY",
  "INVALID_INPUT",
  "NOT_ELIGIBLE",
  "RESENT",
  "STALE_OR_CONFLICT",
]);

function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_PATTERN.test(value);
}

function isEmailLocator(value: unknown): value is string {
  return (
    typeof value === "string" && value.length > 0 && value === value.trim()
  );
}

function isCode(value: unknown): value is string {
  return typeof value === "string" && value.length > 0;
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

function parseIssueResult(value: unknown): FirstAdminOnboardingIssueResult | null {
  const row = singleRow(value);
  if (row === null) {
    return null;
  }

  if (
    Object.keys(row).sort().join("\u0000") !==
    [
      "challenge_id",
      "changed",
      "expires_at",
      "intent_id",
      "issued_at",
      "outcome",
      "reason",
    ]
      .sort()
      .join("\u0000") ||
    typeof row.changed !== "boolean" ||
    typeof row.outcome !== "string" ||
    !ISSUE_OUTCOMES.has(row.outcome as FirstAdminOnboardingIssueOutcome) ||
    typeof row.reason !== "string" ||
    !ISSUE_REASONS.has(row.reason as FirstAdminOnboardingIssueReason)
  ) {
    return null;
  }

  const positive =
    row.outcome === "ESTABLISHED" ||
    row.outcome === "RESENT" ||
    row.outcome === "ALREADY_RECONCILED";

  if (
    positive &&
    isUuid(row.intent_id) &&
    isUuid(row.challenge_id) &&
    typeof row.issued_at === "string" &&
    row.issued_at.length > 0 &&
    typeof row.expires_at === "string" &&
    row.expires_at.length > 0 &&
    row.changed === (row.outcome !== "ALREADY_RECONCILED")
  ) {
    return Object.freeze({
      challengeId: row.challenge_id.toLowerCase(),
      changed: row.changed,
      delivery: "NOT_ATTEMPTED",
      expiresAt: row.expires_at,
      intentId: row.intent_id.toLowerCase(),
      issuedAt: row.issued_at,
      outcome: row.outcome as FirstAdminOnboardingIssueOutcome,
      reason: row.reason as FirstAdminOnboardingIssueReason,
    });
  }

  if (
    !positive &&
    row.changed === false &&
    row.intent_id === null &&
    row.challenge_id === null &&
    row.issued_at === null &&
    row.expires_at === null
  ) {
    return Object.freeze({
      challengeId: null,
      changed: false,
      delivery: "NOT_ATTEMPTED",
      expiresAt: null,
      intentId: null,
      issuedAt: null,
      outcome: row.outcome as FirstAdminOnboardingIssueOutcome,
      reason: row.reason as FirstAdminOnboardingIssueReason,
    });
  }

  return null;
}

function invalidIssueResult(): FirstAdminOnboardingIssueResult {
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

function verifier(
  challengeId: string,
  code: string,
  version: string,
  keys: ReadonlyMap<string, Uint8Array>,
): Uint8Array {
  return createChallengeVerifier({
    challengeId,
    code,
    keyMaterial: resolvePrivateKey(keys, version),
  });
}

async function deliver(
  delivery: FirstAdminVerificationCodeDelivery,
  input: Readonly<{
    challengeId: string;
    code: string;
    email: string;
    expiresAt: string;
    intentId: string;
  }>,
): Promise<"DELIVERED" | "FAILED"> {
  try {
    await delivery.deliver(input);
    return "DELIVERED";
  } catch {
    return "FAILED";
  }
}

function withDelivery(
  result: FirstAdminOnboardingIssueResult,
  delivery: "DELIVERED" | "FAILED",
): FirstAdminOnboardingIssueResult {
  return Object.freeze({ ...result, delivery });
}

export function createFirstAdminOnboardingService(
  deliveryPort: FirstAdminVerificationCodeDelivery,
  dependencies: Dependencies = {},
) {
  const createMutationSource =
    dependencies.createMutationSource ??
    createSupabaseFirstAdminOnboardingMutationSource;
  const createServerSource =
    dependencies.createServerSource ??
    createSupabaseFirstAdminOnboardingServerSource;

  return Object.freeze({
    async establish(
      input: EstablishFirstAdminOnboardingIntentInput,
    ): Promise<FirstAdminOnboardingIssueResult> {
      if (
        !isUuid(input.intentId) ||
        !isUuid(input.maintenanceCompanyId) ||
        !isEmailLocator(input.email) ||
        !isUuid(input.establishmentOperationId) ||
        !isUuid(input.challengeId) ||
        !isUuid(input.issueOperationId) ||
        !isCode(input.code)
      ) {
        return invalidIssueResult();
      }

      try {
        const config = getPrivateAuthConfig();
        const source = await createMutationSource();
        const challengeId = input.challengeId.toLowerCase();
        const result = parseIssueResult(
          await source.establish({
            challengeId,
            email: input.email,
            establishmentOperationId:
              input.establishmentOperationId.toLowerCase(),
            intentId: input.intentId.toLowerCase(),
            issueOperationId: input.issueOperationId.toLowerCase(),
            maintenanceCompanyId: input.maintenanceCompanyId.toLowerCase(),
            verifier: verifier(
              challengeId,
              input.code,
              config.challengeHmacActiveVersion,
              config.challengeHmacKeys,
            ),
            verifierKeyVersion: config.challengeHmacActiveVersion,
          }),
        );

        if (result === null) {
          throw new Error("Malformed first-admin onboarding result.");
        }

        if (
          result.intentId === null ||
          result.challengeId === null ||
          result.expiresAt === null
        ) {
          return result;
        }

        return withDelivery(
          result,
          await deliver(deliveryPort, {
            challengeId: result.challengeId,
            code: input.code,
            email: input.email,
            expiresAt: result.expiresAt,
            intentId: result.intentId,
          }),
        );
      } catch (error) {
        if (error instanceof Error && error.message === "Malformed first-admin onboarding result.") {
          throw genericFirstAdminOnboardingDenial();
        }
        throw genericFirstAdminOnboardingDenial();
      }
    },

    async resend(
      input: ResendFirstAdminOnboardingChallengeInput,
    ): Promise<FirstAdminOnboardingIssueResult> {
      if (
        !isUuid(input.intentId) ||
        !isUuid(input.challengeId) ||
        !isUuid(input.issueOperationId) ||
        !isCode(input.code)
      ) {
        return invalidIssueResult();
      }

      try {
        const config = getPrivateAuthConfig();
        const source = await createMutationSource();
        const challengeId = input.challengeId.toLowerCase();
        const intentId = input.intentId.toLowerCase();
        const result = parseIssueResult(
          await source.resend({
            challengeId,
            intentId,
            issueOperationId: input.issueOperationId.toLowerCase(),
            verifier: verifier(
              challengeId,
              input.code,
              config.challengeHmacActiveVersion,
              config.challengeHmacKeys,
            ),
            verifierKeyVersion: config.challengeHmacActiveVersion,
          }),
        );

        if (result === null) {
          throw new Error("Malformed first-admin onboarding result.");
        }

        if (
          result.intentId === null ||
          result.challengeId === null ||
          result.expiresAt === null
        ) {
          return result;
        }

        let target: Readonly<{ email: string; expiresAt: string }>;
        try {
          target = await createServerSource().getDeliveryTarget(
            result.intentId,
            result.challengeId,
          );
        } catch {
          return withDelivery(result, "FAILED");
        }

        if (target.expiresAt !== result.expiresAt) {
          return withDelivery(result, "FAILED");
        }

        return withDelivery(
          result,
          await deliver(deliveryPort, {
            challengeId: result.challengeId,
            code: input.code,
            email: target.email,
            expiresAt: target.expiresAt,
            intentId: result.intentId,
          }),
        );
      } catch {
        throw genericFirstAdminOnboardingDenial();
      }
    },

    async verify(input: VerifyFirstAdminOnboardingChallengeInput) {
      if (
        !isUuid(input.intentId) ||
        !isEmailLocator(input.email) ||
        !isUuid(input.verificationOperationId) ||
        !isCode(input.code)
      ) {
        throw genericFirstAdminOnboardingDenial();
      }

      try {
        const config = getPrivateAuthConfig();
        const source = createServerSource();
        const intentId = input.intentId.toLowerCase();
        const material = await source.getChallengeMaterial(
          intentId,
          input.email,
          input.verificationOperationId.toLowerCase(),
        );
        const candidate = verifier(
          material.challengeId,
          input.code,
          material.verifierKeyVersion,
          config.challengeHmacKeys,
        );

        return await source.verifyTransition({
          challengeId: material.challengeId,
          email: input.email,
          intentId,
          matched: compareChallengeVerifiers(material.verifier, candidate),
          technicalPasswordKeyVersion:
            config.technicalPasswordActiveVersion,
          verificationOperationId:
            input.verificationOperationId.toLowerCase(),
        });
      } catch {
        throw genericFirstAdminOnboardingDenial();
      }
    },
  });
}
