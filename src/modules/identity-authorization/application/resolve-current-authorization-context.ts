import {
  isTenantRole,
  type CurrentAuthorizationContext,
  type CurrentAuthorizationResult,
  type ValidatedAuthIdentity,
} from "./authorization-context";

export interface CurrentAuthorizationSource {
  findAuthSubjectMappings(authSubject: string): Promise<unknown>;
  findPlatformUsers(platformUserId: string): Promise<unknown>;
  findCompanyMemberships(platformUserId: string): Promise<unknown>;
  findMaintenanceCompanies(maintenanceCompanyId: string): Promise<unknown>;
}

export type CurrentAuthorizationSourceFactory = () => Promise<CurrentAuthorizationSource>;

type ExactOneResult =
  | Readonly<{ status: "NONE" }>
  | Readonly<{ status: "ONE"; row: Readonly<Record<string, unknown>> }>
  | Readonly<{ status: "INVALID" }>;

function isRecord(value: unknown): value is Readonly<Record<string, unknown>> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function exactOne(value: unknown): ExactOneResult {
  if (!Array.isArray(value)) {
    return { status: "INVALID" };
  }

  if (value.length === 0) {
    return { status: "NONE" };
  }

  if (value.length !== 1 || !isRecord(value[0])) {
    return { status: "INVALID" };
  }

  return { row: value[0], status: "ONE" };
}

function nonEmptyString(value: unknown): string | null {
  return typeof value === "string" && value.trim().length > 0 ? value : null;
}

function unauthenticated(): CurrentAuthorizationResult {
  return Object.freeze({ context: null, status: "UNAUTHENTICATED" });
}

function unauthorized(): CurrentAuthorizationResult {
  return Object.freeze({
    context: null,
    status: "AUTHENTICATED_BUT_UNAUTHORIZED",
  });
}

function resolutionError(): CurrentAuthorizationResult {
  return Object.freeze({
    context: null,
    status: "AUTHORIZATION_RESOLUTION_ERROR",
  });
}

function authorized(
  context: CurrentAuthorizationContext,
): CurrentAuthorizationResult {
  return Object.freeze({
    context: Object.freeze(context),
    status: "AUTHORIZED",
  });
}

export async function resolveCurrentAuthorizationContextWithSource(
  identity: ValidatedAuthIdentity | null | undefined,
  createSource: CurrentAuthorizationSourceFactory,
): Promise<CurrentAuthorizationResult> {
  const authSubject = nonEmptyString(identity?.subject);

  if (authSubject === null) {
    return unauthenticated();
  }

  try {
    const source = await createSource();
    const mapping = exactOne(
      await source.findAuthSubjectMappings(authSubject),
    );

    if (mapping.status === "NONE") {
      return unauthorized();
    }
    if (mapping.status === "INVALID") {
      return resolutionError();
    }

    const mappedSubject = nonEmptyString(mapping.row.auth_subject_id);
    const platformUserId = nonEmptyString(mapping.row.platform_user_id);
    if (mappedSubject !== authSubject || platformUserId === null) {
      return resolutionError();
    }

    const platformUser = exactOne(
      await source.findPlatformUsers(platformUserId),
    );
    if (platformUser.status === "NONE") {
      return unauthorized();
    }
    if (
      platformUser.status === "INVALID" ||
      nonEmptyString(platformUser.row.id) !== platformUserId
    ) {
      return resolutionError();
    }

    const membership = exactOne(
      await source.findCompanyMemberships(platformUserId),
    );
    if (membership.status === "NONE") {
      return unauthorized();
    }
    if (membership.status === "INVALID") {
      return resolutionError();
    }
    if (membership.row.is_enabled === false) {
      return unauthorized();
    }
    if (membership.row.is_enabled !== true) {
      return resolutionError();
    }

    const companyMembershipId = nonEmptyString(membership.row.id);
    const membershipPlatformUserId = nonEmptyString(
      membership.row.platform_user_id,
    );
    const maintenanceCompanyId = nonEmptyString(
      membership.row.maintenance_company_id,
    );
    const role = membership.row.role;
    if (
      companyMembershipId === null ||
      membershipPlatformUserId !== platformUserId ||
      maintenanceCompanyId === null ||
      !isTenantRole(role)
    ) {
      return resolutionError();
    }

    const maintenanceCompany = exactOne(
      await source.findMaintenanceCompanies(maintenanceCompanyId),
    );
    if (maintenanceCompany.status === "NONE") {
      return unauthorized();
    }
    if (
      maintenanceCompany.status === "INVALID" ||
      nonEmptyString(maintenanceCompany.row.id) !== maintenanceCompanyId
    ) {
      return resolutionError();
    }

    return authorized({
      companyMembershipId,
      maintenanceCompanyId,
      platformUserId,
      role,
    });
  } catch {
    return resolutionError();
  }
}
