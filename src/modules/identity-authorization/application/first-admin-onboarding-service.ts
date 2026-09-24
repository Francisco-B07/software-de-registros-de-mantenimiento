import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../infrastructure/config/auth-private";

import {
  compareChallengeVerifiers,
  createChallengeVerifier,
} from "../infrastructure/crypto/challenge-verifier";
import { createSupabaseFirstAdminOnboardingMutationSource } from "../infrastructure/supabase/first-admin-onboarding-source";
import {
  createSupabaseFirstAdminAuthHandoffSource,
  createSupabaseFirstAdminOnboardingServerSource,
} from "../infrastructure/supabase/first-admin-onboarding-server-source";
import {
  genericFirstAdminOnboardingDenial,
  type EstablishFirstAdminOnboardingIntentInput,
  type FirstAdminAuthHandoffIdentityCompatibility,
  type FirstAdminAuthHandoffResult,
  type FirstAdminAuthHandoffSource,
  type FirstAdminPostSignInAuthHandoffCorrelationResult,
  type FirstAdminOnboardingIssueOutcome,
  type FirstAdminOnboardingIssueReason,
  type FirstAdminOnboardingIssueResult,
  type FirstAdminOnboardingMutationSourceFactory,
  type FirstAdminOnboardingServerSource,
  type FirstAdminVerificationCodeDelivery,
  type ResendFirstAdminOnboardingChallengeInput,
  type ResolveFirstAdminAuthHandoffInput,
  type VerifyFirstAdminOnboardingChallengeInput,
} from "./first-admin-onboarding";

type Row = Readonly<Record<string, unknown>>;

type AuthHandoffEligibility =
  | "ELIGIBLE"
  | "GRANT_EXPIRED"
  | "GRANT_REVOKED"
  | "GRANT_CONSUMED";

type ParsedAuthHandoff =
  | Readonly<{ kind: "FAIL_CLOSED" }>
  | Readonly<{
      authBridgeCredentialId: string;
      bridgeAuthUserId: string | null;
      currentChallengeId: string;
      grantAuthUserId: string | null;
      grantConsumedAt: string | null;
      handoffEligibility: AuthHandoffEligibility;
      handoffSessionGrantId: string;
      identityCompatibility: FirstAdminAuthHandoffIdentityCompatibility;
      intentId: string;
      kind: "AUTHORITATIVE";
      maintenanceCompanyId: string;
      targetEmail: string;
    }>;

type ParsedAuthHandoffResolution =
  | Readonly<{ outcome: "PARSED"; value: ParsedAuthHandoff }>
  | Readonly<{ outcome: "SECURITY_CORRELATION_FAILURE" }>
  | Readonly<{ outcome: "INFRASTRUCTURE_FAILURE" }>;

type Dependencies = Readonly<{
  createMutationSource?: FirstAdminOnboardingMutationSourceFactory;
  createServerSource?: () => FirstAdminOnboardingServerSource;
}>;

type AuthHandoffDependencies = Readonly<{
  createSource?: () => FirstAdminAuthHandoffSource;
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

const AUTH_HANDOFF_KEYS = [
  "intent_id",
  "maintenance_company_id",
  "target_email",
  "current_challenge_id",
  "handoff_session_grant_id",
  "handoff_ready_at",
  "challenge_consumed_at",
  "auth_bridge_credential_id",
  "bridge_auth_user_id",
  "grant_auth_user_id",
  "grant_purpose",
  "grant_auth_method",
  "grant_created_at",
  "grant_expires_at",
  "grant_consumed_at",
  "grant_revoked_at",
  "handoff_eligibility",
  "identity_compatibility",
] as const;

const AUTH_HANDOFF_ELIGIBILITIES = new Set([
  "ELIGIBLE",
  "GRANT_EXPIRED",
  "GRANT_REVOKED",
  "GRANT_CONSUMED",
  "FAIL_CLOSED",
]);

const AUTH_HANDOFF_IDENTITIES = new Set([
  "NO_APPLICATION_IDENTITY",
  "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
  "INCOMPATIBLE_IDENTITY",
  "FAIL_CLOSED",
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

function hasExactKeys(row: Row, keys: readonly string[]): boolean {
  return (
    Object.keys(row).sort().join("\u0000") ===
    [...keys].sort().join("\u0000")
  );
}

function isTimestamp(value: unknown): value is string {
  return (
    typeof value === "string" &&
    value.length > 0 &&
    Number.isFinite(Date.parse(value))
  );
}

function isNullableTimestamp(value: unknown): value is string | null {
  return value === null || isTimestamp(value);
}

function isNullableUuid(value: unknown): value is string | null {
  return value === null || isUuid(value);
}

function securityCorrelationFailure(): Readonly<{
  outcome: "SECURITY_CORRELATION_FAILURE";
}> {
  return Object.freeze({ outcome: "SECURITY_CORRELATION_FAILURE" });
}

function infrastructureFailure(): Readonly<{
  outcome: "INFRASTRUCTURE_FAILURE";
}> {
  return Object.freeze({ outcome: "INFRASTRUCTURE_FAILURE" });
}

function parseAuthHandoff(
  value: unknown,
  expectedIntentId: string,
): ParsedAuthHandoff | null {
  const row = singleRow(value);
  if (
    row === null ||
    !hasExactKeys(row, AUTH_HANDOFF_KEYS) ||
    typeof row.handoff_eligibility !== "string" ||
    !AUTH_HANDOFF_ELIGIBILITIES.has(row.handoff_eligibility) ||
    typeof row.identity_compatibility !== "string" ||
    !AUTH_HANDOFF_IDENTITIES.has(row.identity_compatibility)
  ) {
    return null;
  }

  if (
    row.handoff_eligibility === "FAIL_CLOSED" ||
    row.identity_compatibility === "FAIL_CLOSED"
  ) {
    const classificationsFailClosed =
      row.handoff_eligibility === "FAIL_CLOSED" &&
      row.identity_compatibility === "FAIL_CLOSED";
    const payloadIsRedacted = AUTH_HANDOFF_KEYS.slice(0, -2).every(
      (key) => row[key] === null,
    );
    return classificationsFailClosed && payloadIsRedacted
      ? Object.freeze({ kind: "FAIL_CLOSED" })
      : null;
  }

  if (
    !isUuid(row.intent_id) ||
    row.intent_id.toLowerCase() !== expectedIntentId ||
    !isUuid(row.maintenance_company_id) ||
    typeof row.target_email !== "string" ||
    row.target_email.length === 0 ||
    row.target_email !== row.target_email.trim() ||
    !isUuid(row.current_challenge_id) ||
    !isUuid(row.handoff_session_grant_id) ||
    !isTimestamp(row.handoff_ready_at) ||
    !isTimestamp(row.challenge_consumed_at) ||
    !isUuid(row.auth_bridge_credential_id) ||
    !isNullableUuid(row.bridge_auth_user_id) ||
    !isNullableUuid(row.grant_auth_user_id) ||
    row.bridge_auth_user_id !== row.grant_auth_user_id ||
    row.grant_purpose !== "initial_session" ||
    row.grant_auth_method !== "password" ||
    !isTimestamp(row.grant_created_at) ||
    !isTimestamp(row.grant_expires_at) ||
    !isNullableTimestamp(row.grant_consumed_at) ||
    !isNullableTimestamp(row.grant_revoked_at)
  ) {
    return null;
  }

  if (
    row.handoff_ready_at !== row.challenge_consumed_at ||
    row.handoff_ready_at !== row.grant_created_at ||
    Date.parse(row.grant_expires_at) - Date.parse(row.grant_created_at) !==
      5 * 60 * 1000
  ) {
    return null;
  }

  const identityCompatibility =
    row.identity_compatibility as FirstAdminAuthHandoffIdentityCompatibility;
  const boundAuthUserId = row.bridge_auth_user_id;

  if (
    identityCompatibility !== "NO_APPLICATION_IDENTITY" &&
    boundAuthUserId === null
  ) {
    return null;
  }

  if (
    row.handoff_eligibility === "ELIGIBLE" &&
    (row.grant_consumed_at !== null || row.grant_revoked_at !== null)
  ) {
    return null;
  }

  if (
    row.handoff_eligibility === "GRANT_EXPIRED" &&
    (row.grant_consumed_at !== null || row.grant_revoked_at !== null)
  ) {
    return null;
  }

  if (
    row.handoff_eligibility === "GRANT_REVOKED" &&
    (row.grant_revoked_at === null || row.grant_consumed_at !== null)
  ) {
    return null;
  }

  if (
    row.handoff_eligibility === "GRANT_CONSUMED" &&
    (row.grant_consumed_at === null || row.grant_revoked_at !== null)
  ) {
    return null;
  }

  return Object.freeze({
    authBridgeCredentialId: row.auth_bridge_credential_id.toLowerCase(),
    bridgeAuthUserId: boundAuthUserId?.toLowerCase() ?? null,
    currentChallengeId: row.current_challenge_id.toLowerCase(),
    grantAuthUserId: row.grant_auth_user_id?.toLowerCase() ?? null,
    grantConsumedAt: row.grant_consumed_at,
    handoffEligibility: row.handoff_eligibility as AuthHandoffEligibility,
    handoffSessionGrantId: row.handoff_session_grant_id.toLowerCase(),
    identityCompatibility,
    intentId: row.intent_id.toLowerCase(),
    kind: "AUTHORITATIVE",
    maintenanceCompanyId: row.maintenance_company_id.toLowerCase(),
    targetEmail: row.target_email,
  });
}

function projectPreSignInAuthHandoff(
  parsed: ParsedAuthHandoff,
): FirstAdminAuthHandoffResult {
  if (parsed.kind === "FAIL_CLOSED") {
    return securityCorrelationFailure();
  }

  if (parsed.identityCompatibility === "INCOMPATIBLE_IDENTITY") {
    return Object.freeze({ outcome: "IDENTITY_INCOMPATIBLE" });
  }

  if (parsed.handoffEligibility !== "ELIGIBLE") {
    return Object.freeze({
      identityCompatibility: parsed.identityCompatibility,
      outcome: parsed.handoffEligibility,
    });
  }

  return Object.freeze({
    context: Object.freeze({
      authBridgeCredentialId: parsed.authBridgeCredentialId,
      boundAuthUserId: parsed.bridgeAuthUserId,
      currentChallengeId: parsed.currentChallengeId,
      handoffSessionGrantId: parsed.handoffSessionGrantId,
      identityCompatibility: parsed.identityCompatibility,
      intentId: parsed.intentId,
      maintenanceCompanyId: parsed.maintenanceCompanyId,
      targetEmail: parsed.targetEmail,
    }),
    outcome: "ELIGIBLE",
  });
}

function projectPostSignInAuthHandoffCorrelation(
  parsed: ParsedAuthHandoff,
): FirstAdminPostSignInAuthHandoffCorrelationResult {
  if (parsed.kind === "FAIL_CLOSED") {
    return securityCorrelationFailure();
  }

  if (parsed.identityCompatibility === "INCOMPATIBLE_IDENTITY") {
    return Object.freeze({ outcome: "IDENTITY_INCOMPATIBLE" });
  }

  if (parsed.handoffEligibility !== "GRANT_CONSUMED") {
    return Object.freeze({ outcome: "NOT_CONSUMED" });
  }

  if (
    parsed.grantConsumedAt === null ||
    parsed.bridgeAuthUserId === null ||
    parsed.grantAuthUserId === null ||
    parsed.bridgeAuthUserId !== parsed.grantAuthUserId
  ) {
    return securityCorrelationFailure();
  }

  return Object.freeze({
    authBridgeCredentialId: parsed.authBridgeCredentialId,
    bridgeAuthUserId: parsed.bridgeAuthUserId,
    currentChallengeId: parsed.currentChallengeId,
    grantAuthUserId: parsed.grantAuthUserId,
    handoffSessionGrantId: parsed.handoffSessionGrantId,
    identityCompatibility: parsed.identityCompatibility,
    intentId: parsed.intentId,
    maintenanceCompanyId: parsed.maintenanceCompanyId,
    outcome: "CORRELATED_CONSUMED",
    targetEmail: parsed.targetEmail,
  });
}

async function resolveParsedAuthHandoff(
  createSource: () => FirstAdminAuthHandoffSource,
  intentId: string,
): Promise<ParsedAuthHandoffResolution> {
  let rawResult: unknown;
  try {
    rawResult = await createSource().resolveAuthHandoff(intentId);
  } catch {
    return infrastructureFailure();
  }

  const parsed = parseAuthHandoff(rawResult, intentId);
  return parsed === null
    ? securityCorrelationFailure()
    : Object.freeze({ outcome: "PARSED", value: parsed });
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

export function createFirstAdminAuthHandoffService(
  dependencies: AuthHandoffDependencies = {},
) {
  const createSource =
    dependencies.createSource ?? createSupabaseFirstAdminAuthHandoffSource;

  return Object.freeze({
    async resolve(
      input: ResolveFirstAdminAuthHandoffInput,
    ): Promise<FirstAdminAuthHandoffResult> {
      if (!isUuid(input.intentId)) {
        return securityCorrelationFailure();
      }

      const resolution = await resolveParsedAuthHandoff(
        createSource,
        input.intentId.toLowerCase(),
      );
      if (resolution.outcome !== "PARSED") {
        return resolution;
      }

      return projectPreSignInAuthHandoff(resolution.value);
    },

    async resolvePostSignInAuthHandoffCorrelation(
      intentId: string,
    ): Promise<FirstAdminPostSignInAuthHandoffCorrelationResult> {
      if (!isUuid(intentId)) {
        return securityCorrelationFailure();
      }

      const resolution = await resolveParsedAuthHandoff(
        createSource,
        intentId.toLowerCase(),
      );
      if (resolution.outcome !== "PARSED") {
        return resolution;
      }

      return projectPostSignInAuthHandoffCorrelation(resolution.value);
    },
  });
}
