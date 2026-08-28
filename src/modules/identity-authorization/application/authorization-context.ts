export const TENANT_ROLES = ["COMPANY_ADMIN", "TECHNICIAN"] as const;

export type TenantRole = (typeof TENANT_ROLES)[number];

export interface ValidatedAuthIdentity {
  readonly subject: string;
}

export interface CurrentAuthorizationContext {
  readonly platformUserId: string;
  readonly companyMembershipId: string;
  readonly maintenanceCompanyId: string;
  readonly role: TenantRole;
}

export type CurrentAuthorizationResult =
  | Readonly<{
      status: "AUTHORIZED";
      context: Readonly<CurrentAuthorizationContext>;
    }>
  | Readonly<{
      status: "UNAUTHENTICATED";
      context: null;
    }>
  | Readonly<{
      status: "AUTHENTICATED_BUT_UNAUTHORIZED";
      context: null;
    }>
  | Readonly<{
      status: "AUTHORIZATION_RESOLUTION_ERROR";
      context: null;
    }>;

export function isTenantRole(value: unknown): value is TenantRole {
  return TENANT_ROLES.some((role) => role === value);
}
