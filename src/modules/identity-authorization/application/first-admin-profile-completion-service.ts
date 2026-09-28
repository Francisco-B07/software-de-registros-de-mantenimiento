import { createSupabaseFirstAdminProfileCompletionSource } from "../infrastructure/supabase/first-admin-profile-completion-source";
import type {
  FirstAdminOnboardingState,
  FirstAdminProfileCompletionDeniedReason,
  FirstAdminProfileCompletionInput,
  FirstAdminProfileCompletionResult,
  FirstAdminProfileCompletionSourceFactory,
} from "./first-admin-profile-completion";

type Row = Readonly<Record<string, unknown>>;

type Dependencies = Readonly<{
  createSource?: FirstAdminProfileCompletionSourceFactory;
}>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const COMPLETION_RESULT_KEYS = [
  "company_membership_id",
  "completed_at",
  "outcome",
  "platform_user_id",
  "reason",
] as const;

const STATE_RESULT_KEYS = ["completed_at", "state"] as const;

function isRecord(value: unknown): value is Row {
  return typeof value === "object" && value !== null && !Array.isArray(value);
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

  return isRecord(value[0]) ? value[0] : null;
}

function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_PATTERN.test(value);
}

function isTimestamp(value: unknown): value is string {
  return (
    typeof value === "string" &&
    value.length > 0 &&
    Number.isFinite(Date.parse(value))
  );
}

function isDeniedReason(
  value: unknown,
): value is FirstAdminProfileCompletionDeniedReason {
  switch (value) {
    case "AUTHORIZATION_DENIED":
    case "IDENTITY_INCOMPATIBLE":
    case "INITIAL_MEMBERSHIP_CONFLICT":
    case "INVALID_INPUT":
    case "ONBOARDING_ALREADY_COMPLETED":
    case "SECURITY_CORRELATION_FAILURE":
      return true;
    default:
      return false;
  }
}

function invalidInput(): FirstAdminProfileCompletionResult {
  return Object.freeze({
    companyMembershipId: null,
    completedAt: null,
    outcome: "DENIED",
    platformUserId: null,
    reason: "INVALID_INPUT",
  });
}

function normalizeInput(
  input: FirstAdminProfileCompletionInput,
): FirstAdminProfileCompletionInput | null {
  if (
    !isRecord(input) ||
    !hasExactKeys(input, ["firstName", "lastName", "operationId"]) ||
    typeof input.firstName !== "string" ||
    typeof input.lastName !== "string" ||
    !isUuid(input.operationId)
  ) {
    return null;
  }

  const firstName = input.firstName.trim();
  const lastName = input.lastName.trim();
  if (firstName.length === 0 || lastName.length === 0) {
    return null;
  }

  return Object.freeze({
    firstName,
    lastName,
    operationId: input.operationId.toLowerCase(),
  });
}

function parseCompletionResult(
  value: unknown,
): FirstAdminProfileCompletionResult | null {
  const row = singleRow(value);
  if (row === null || !hasExactKeys(row, COMPLETION_RESULT_KEYS)) {
    return null;
  }

  if (
    (row.outcome === "COMPLETED" ||
      row.outcome === "ALREADY_COMPLETED") &&
    row.reason === row.outcome &&
    isUuid(row.platform_user_id) &&
    isUuid(row.company_membership_id) &&
    isTimestamp(row.completed_at)
  ) {
    if (row.outcome === "COMPLETED") {
      return Object.freeze({
        companyMembershipId: row.company_membership_id.toLowerCase(),
        completedAt: row.completed_at,
        outcome: "COMPLETED",
        platformUserId: row.platform_user_id.toLowerCase(),
        reason: "COMPLETED",
      });
    }

    return Object.freeze({
      companyMembershipId: row.company_membership_id.toLowerCase(),
      completedAt: row.completed_at,
      outcome: "ALREADY_COMPLETED",
      platformUserId: row.platform_user_id.toLowerCase(),
      reason: "ALREADY_COMPLETED",
    });
  }

  if (
    row.outcome === "DENIED" &&
    isDeniedReason(row.reason) &&
    row.platform_user_id === null &&
    row.company_membership_id === null &&
    row.completed_at === null
  ) {
    return Object.freeze({
      companyMembershipId: null,
      completedAt: null,
      outcome: "DENIED",
      platformUserId: null,
      reason: row.reason,
    });
  }

  return null;
}

function parseState(value: unknown): FirstAdminOnboardingState | null {
  const row = singleRow(value);
  if (row === null || !hasExactKeys(row, STATE_RESULT_KEYS)) {
    return null;
  }

  if (row.state === "COMPLETED" && isTimestamp(row.completed_at)) {
    return Object.freeze({
      completedAt: row.completed_at,
      state: "COMPLETED",
    });
  }

  if (
    (row.state === "PENDING_PROFILE" || row.state === "UNAVAILABLE") &&
    row.completed_at === null
  ) {
    return Object.freeze({
      completedAt: null,
      state: row.state,
    });
  }

  return null;
}

export function createFirstAdminProfileCompletionService(
  dependencies: Dependencies = {},
) {
  const createSource =
    dependencies.createSource ?? createSupabaseFirstAdminProfileCompletionSource;

  return Object.freeze({
    async complete(
      input: FirstAdminProfileCompletionInput,
    ): Promise<FirstAdminProfileCompletionResult> {
      const normalizedInput = normalizeInput(input);
      if (normalizedInput === null) {
        return invalidInput();
      }

      try {
        const source = await createSource();
        const result = parseCompletionResult(
          await source.complete(normalizedInput),
        );
        if (result === null) {
          throw new Error("Malformed completion result.");
        }
        return result;
      } catch {
        throw new Error("First-admin profile completion was not confirmed.");
      }
    },

    async resolveState(): Promise<FirstAdminOnboardingState> {
      try {
        const source = await createSource();
        const state = parseState(await source.resolveState());
        if (state === null) {
          throw new Error("Malformed onboarding-state result.");
        }
        return state;
      } catch {
        throw new Error("First-admin onboarding state could not be resolved.");
      }
    },
  });
}
