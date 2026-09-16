import type { TenantRole } from "./authorization-context";

export type CompanyMembershipLifecycleInput =
  | Readonly<{
      operation: "DISABLE" | "REINSTATE";
      targetCompanyMembershipId: string;
    }>
  | Readonly<{
      operation: "CHANGE_ROLE";
      requestedRole: TenantRole;
      targetCompanyMembershipId: string;
    }>;

export type CompanyMembershipLifecycleResult = Readonly<{
  changed: boolean;
  outcome: "APPLIED" | "ALREADY_SATISFIED" | "DENIED";
  reason:
    | "APPLIED"
    | "ALREADY_SATISFIED"
    | "INVALID_INPUT"
    | "AUTHORIZATION_DENIED"
    | "TARGET_UNAVAILABLE"
    | "SELF_TARGET_NOT_ALLOWED"
    | "ADMIN_CONTINUITY_REQUIRED";
}>;

export type CompanyMembershipLifecycleCommand = Readonly<{
  operation: "DISABLE" | "REINSTATE" | "CHANGE_ROLE";
  requestedRole: TenantRole | null;
  targetCompanyMembershipId: string;
}>;

export interface CompanyMembershipLifecycleSource {
  apply(command: CompanyMembershipLifecycleCommand): Promise<unknown>;
}

export type CompanyMembershipLifecycleSourceFactory =
  () => Promise<CompanyMembershipLifecycleSource>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const DENIED_REASONS = new Set<CompanyMembershipLifecycleResult["reason"]>([
  "INVALID_INPUT",
  "AUTHORIZATION_DENIED",
  "TARGET_UNAVAILABLE",
  "SELF_TARGET_NOT_ALLOWED",
  "ADMIN_CONTINUITY_REQUIRED",
]);

function invalidInput(): CompanyMembershipLifecycleResult {
  return Object.freeze({
    changed: false,
    outcome: "DENIED",
    reason: "INVALID_INPUT",
  });
}

function parseSingleResult(value: unknown): CompanyMembershipLifecycleResult | null {
  if (!Array.isArray(value) || value.length !== 1) {
    return null;
  }

  const row: unknown = value[0];
  if (typeof row !== "object" || row === null || Array.isArray(row)) {
    return null;
  }

  const record = row as Readonly<Record<string, unknown>>;
  if (
    Object.keys(record).sort().join("\u0000") !==
    ["changed", "outcome", "reason"].join("\u0000")
  ) {
    return null;
  }

  if (
    record.outcome === "APPLIED" &&
    record.changed === true &&
    record.reason === "APPLIED"
  ) {
    return Object.freeze({
      changed: true,
      outcome: "APPLIED",
      reason: "APPLIED",
    });
  }

  if (
    record.outcome === "ALREADY_SATISFIED" &&
    record.changed === false &&
    record.reason === "ALREADY_SATISFIED"
  ) {
    return Object.freeze({
      changed: false,
      outcome: "ALREADY_SATISFIED",
      reason: "ALREADY_SATISFIED",
    });
  }

  if (
    record.outcome === "DENIED" &&
    record.changed === false &&
    typeof record.reason === "string" &&
    DENIED_REASONS.has(record.reason as CompanyMembershipLifecycleResult["reason"])
  ) {
    return Object.freeze({
      changed: false,
      outcome: "DENIED",
      reason: record.reason as CompanyMembershipLifecycleResult["reason"],
    });
  }

  return null;
}

function normalizeInput(
  input: CompanyMembershipLifecycleInput,
): CompanyMembershipLifecycleCommand | null {
  if (
    typeof input !== "object" ||
    input === null ||
    typeof input.targetCompanyMembershipId !== "string" ||
    !UUID_PATTERN.test(input.targetCompanyMembershipId)
  ) {
    return null;
  }

  if (input.operation === "DISABLE" || input.operation === "REINSTATE") {
    if ("requestedRole" in input) {
      return null;
    }

    return Object.freeze({
      operation: input.operation,
      requestedRole: null,
      targetCompanyMembershipId: input.targetCompanyMembershipId.toLowerCase(),
    });
  }

  if (
    input.operation === "CHANGE_ROLE" &&
    (input.requestedRole === "COMPANY_ADMIN" ||
      input.requestedRole === "TECHNICIAN")
  ) {
    return Object.freeze({
      operation: input.operation,
      requestedRole: input.requestedRole,
      targetCompanyMembershipId: input.targetCompanyMembershipId.toLowerCase(),
    });
  }

  return null;
}

export async function applyCompanyMembershipLifecycleWithSource(
  input: CompanyMembershipLifecycleInput,
  createSource: CompanyMembershipLifecycleSourceFactory,
): Promise<CompanyMembershipLifecycleResult> {
  const command = normalizeInput(input);
  if (command === null) {
    return invalidInput();
  }

  try {
    const source = await createSource();
    const result = parseSingleResult(await source.apply(command));

    if (result === null) {
      throw new Error("Malformed membership lifecycle result.");
    }

    return result;
  } catch {
    throw new Error("Company membership lifecycle operation was not confirmed.");
  }
}
