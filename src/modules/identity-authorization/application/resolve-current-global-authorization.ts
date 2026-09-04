import type { ValidatedAuthIdentity } from "./authorization-context";

export type CurrentGlobalAuthorizationResult = Readonly<{
  status:
    | "AUTHORIZED_GLOBAL_SUPER_ADMIN"
    | "NOT_GLOBAL_SUPER_ADMIN"
    | "INCONSISTENT_GLOBAL_AND_TENANT_IDENTITY"
    | "UNRESOLVABLE_IDENTITY";
}>;

export interface CurrentGlobalAuthorizationSource {
  resolveCurrentGlobalAuthority(): Promise<unknown>;
}

export type CurrentGlobalAuthorizationSourceFactory =
  () => Promise<CurrentGlobalAuthorizationSource>;

const EXPECTED_FIELDS = [
  "has_company_membership",
  "identity_resolved",
  "is_super_admin",
] as const;

type GlobalAuthorityRow = Readonly<{
  has_company_membership: boolean;
  identity_resolved: boolean;
  is_super_admin: boolean;
}>;

function result(
  status: CurrentGlobalAuthorizationResult["status"],
): CurrentGlobalAuthorizationResult {
  return Object.freeze({ status });
}

function nonEmptySubject(identity: ValidatedAuthIdentity | null | undefined) {
  return (
    typeof identity?.subject === "string" &&
    identity.subject.trim().length > 0
  );
}

function parseSingleRow(value: unknown): GlobalAuthorityRow | null {
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
      EXPECTED_FIELDS.join("\u0000") ||
    typeof record.identity_resolved !== "boolean" ||
    typeof record.is_super_admin !== "boolean" ||
    typeof record.has_company_membership !== "boolean"
  ) {
    return null;
  }

  return {
    has_company_membership: record.has_company_membership,
    identity_resolved: record.identity_resolved,
    is_super_admin: record.is_super_admin,
  };
}

export async function resolveCurrentGlobalAuthorizationWithSource(
  identity: ValidatedAuthIdentity | null | undefined,
  createSource: CurrentGlobalAuthorizationSourceFactory,
): Promise<CurrentGlobalAuthorizationResult> {
  if (!nonEmptySubject(identity)) {
    return result("UNRESOLVABLE_IDENTITY");
  }

  try {
    const source = await createSource();
    const authority = parseSingleRow(
      await source.resolveCurrentGlobalAuthority(),
    );

    if (
      authority === null ||
      (!authority.identity_resolved &&
        (authority.is_super_admin || authority.has_company_membership))
    ) {
      return result("UNRESOLVABLE_IDENTITY");
    }

    if (!authority.identity_resolved) {
      return result("UNRESOLVABLE_IDENTITY");
    }

    if (!authority.is_super_admin) {
      return result("NOT_GLOBAL_SUPER_ADMIN");
    }

    if (authority.has_company_membership) {
      return result("INCONSISTENT_GLOBAL_AND_TENANT_IDENTITY");
    }

    return result("AUTHORIZED_GLOBAL_SUPER_ADMIN");
  } catch {
    return result("UNRESOLVABLE_IDENTITY");
  }
}
