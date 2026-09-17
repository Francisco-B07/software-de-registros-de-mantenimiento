export type CreationOperationId = string;

export type CreateMaintenanceCompanyInput = Readonly<{
  creationOperationId: CreationOperationId;
}>;

export type CreateMaintenanceCompanyResult = Readonly<{
  changed: boolean;
  maintenanceCompanyId: string | null;
  outcome: "CREATED" | "ALREADY_CREATED" | "DENIED";
  reason:
    | "CREATED"
    | "ALREADY_CREATED"
    | "INVALID_INPUT"
    | "AUTHORIZATION_DENIED"
    | "INCONSISTENT_AUTHORITY";
}>;

export interface MaintenanceCompanyCreationSource {
  create(creationOperationId: CreationOperationId): Promise<unknown>;
}

export type MaintenanceCompanyCreationSourceFactory =
  () => Promise<MaintenanceCompanyCreationSource>;

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const DENIED_REASONS = new Set<CreateMaintenanceCompanyResult["reason"]>([
  "INVALID_INPUT",
  "AUTHORIZATION_DENIED",
  "INCONSISTENT_AUTHORITY",
]);

function deniedInvalidInput(): CreateMaintenanceCompanyResult {
  return Object.freeze({
    changed: false,
    maintenanceCompanyId: null,
    outcome: "DENIED",
    reason: "INVALID_INPUT",
  });
}

function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_PATTERN.test(value);
}

function parseSingleResult(value: unknown): CreateMaintenanceCompanyResult | null {
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
    ["changed", "maintenance_company_id", "outcome", "reason"]
      .sort()
      .join("\u0000")
  ) {
    return null;
  }

  if (
    record.outcome === "CREATED" &&
    record.changed === true &&
    isUuid(record.maintenance_company_id) &&
    record.reason === "CREATED"
  ) {
    return Object.freeze({
      changed: true,
      maintenanceCompanyId: record.maintenance_company_id.toLowerCase(),
      outcome: "CREATED",
      reason: "CREATED",
    });
  }

  if (
    record.outcome === "ALREADY_CREATED" &&
    record.changed === false &&
    isUuid(record.maintenance_company_id) &&
    record.reason === "ALREADY_CREATED"
  ) {
    return Object.freeze({
      changed: false,
      maintenanceCompanyId: record.maintenance_company_id.toLowerCase(),
      outcome: "ALREADY_CREATED",
      reason: "ALREADY_CREATED",
    });
  }

  if (
    record.outcome === "DENIED" &&
    record.changed === false &&
    record.maintenance_company_id === null &&
    typeof record.reason === "string" &&
    DENIED_REASONS.has(record.reason as CreateMaintenanceCompanyResult["reason"])
  ) {
    return Object.freeze({
      changed: false,
      maintenanceCompanyId: null,
      outcome: "DENIED",
      reason: record.reason as CreateMaintenanceCompanyResult["reason"],
    });
  }

  return null;
}

export async function createMaintenanceCompanyWithSource(
  input: CreateMaintenanceCompanyInput,
  createSource: MaintenanceCompanyCreationSourceFactory,
): Promise<CreateMaintenanceCompanyResult> {
  if (
    typeof input !== "object" ||
    input === null ||
    !isUuid(input.creationOperationId)
  ) {
    return deniedInvalidInput();
  }

  try {
    const source = await createSource();
    const result = parseSingleResult(
      await source.create(input.creationOperationId.toLowerCase()),
    );

    if (result === null) {
      throw new Error("Malformed maintenance company creation result.");
    }

    return result;
  } catch {
    throw new Error("Maintenance company creation was not confirmed.");
  }
}
