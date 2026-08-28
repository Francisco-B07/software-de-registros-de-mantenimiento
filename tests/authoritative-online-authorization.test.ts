import { readFileSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import type { ValidatedAuthIdentity } from "../src/modules/identity-authorization/application/authorization-context";
import {
  type CurrentAuthorizationSource,
  resolveCurrentAuthorizationContextWithSource,
} from "../src/modules/identity-authorization/application/resolve-current-authorization-context";

const authSubject = "00000000-0000-4000-8000-000000012001";
const platformUserId = "00000000-0000-4000-8000-000000012002";
const companyMembershipId = "00000000-0000-4000-8000-000000012003";
const maintenanceCompanyId = "00000000-0000-4000-8000-000000012004";
const foreignMaintenanceCompanyId = "00000000-0000-4000-8000-000000012999";

const identity: ValidatedAuthIdentity = Object.freeze({ subject: authSubject });

function createSource(
  overrides: Partial<CurrentAuthorizationSource> = {},
): CurrentAuthorizationSource {
  return Object.freeze({
    async findAuthSubjectMappings(subject: string) {
      return [
        {
          auth_subject_id: subject,
          platform_user_id: platformUserId,
        },
      ];
    },
    async findCompanyMemberships(requestedPlatformUserId: string) {
      return [
        {
          id: companyMembershipId,
          is_enabled: true,
          maintenance_company_id: maintenanceCompanyId,
          platform_user_id: requestedPlatformUserId,
          role: "COMPANY_ADMIN",
        },
      ];
    },
    async findMaintenanceCompanies(requestedMaintenanceCompanyId: string) {
      return [{ id: requestedMaintenanceCompanyId }];
    },
    async findPlatformUsers(requestedPlatformUserId: string) {
      return [{ id: requestedPlatformUserId }];
    },
    ...overrides,
  });
}

function resolveWith(
  currentIdentity: ValidatedAuthIdentity | null | undefined = identity,
  source: CurrentAuthorizationSource = createSource(),
) {
  return resolveCurrentAuthorizationContextWithSource(
    currentIdentity,
    async () => source,
  );
}

describe("TASK-012 authoritative online authorization foundation", () => {
  it("T012-001 returns unauthenticated without creating a source for an anonymous request", async () => {
    const createSourceMock = vi.fn(async () => createSource());

    await expect(
      resolveCurrentAuthorizationContextWithSource(null, createSourceMock),
    ).resolves.toEqual({ context: null, status: "UNAUTHENTICATED" });
    expect(createSourceMock).not.toHaveBeenCalled();
  });

  it("T012-002 resolves the exact current chain for a valid subject", async () => {
    const result = await resolveWith();

    expect(result).toEqual({
      context: {
        companyMembershipId,
        maintenanceCompanyId,
        platformUserId,
        role: "COMPANY_ADMIN",
      },
      status: "AUTHORIZED",
    });
    if (result.status !== "AUTHORIZED") {
      throw new Error("Expected an authorized result.");
    }
    expect(Object.isFrozen(result)).toBe(true);
    expect(Object.isFrozen(result.context)).toBe(true);
  });

  it("T012-003 denies a subject without a visible mapping", async () => {
    await expect(
      resolveWith(
        identity,
        createSource({ findAuthSubjectMappings: async () => [] }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-004 fails closed for an ambiguous mapping", async () => {
    const mapping = {
      auth_subject_id: authSubject,
      platform_user_id: platformUserId,
    };

    await expect(
      resolveWith(
        identity,
        createSource({
          findAuthSubjectMappings: async () => [mapping, mapping],
        }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHORIZATION_RESOLUTION_ERROR",
    });
  });

  it("T012-005 denies when PlatformUser is missing or not visible", async () => {
    await expect(
      resolveWith(
        identity,
        createSource({ findPlatformUsers: async () => [] }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-006 does not require or invent a PlatformUser enabled state", async () => {
    const source = createSource({
      findPlatformUsers: async () => [{ id: platformUserId }],
    });

    await expect(resolveWith(identity, source)).resolves.toMatchObject({
      status: "AUTHORIZED",
    });
  });

  it("T012-007 denies when no current membership is visible", async () => {
    await expect(
      resolveWith(
        identity,
        createSource({ findCompanyMemberships: async () => [] }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-008 authorizes an enabled exact membership", async () => {
    await expect(resolveWith()).resolves.toMatchObject({
      context: { companyMembershipId, maintenanceCompanyId },
      status: "AUTHORIZED",
    });
  });

  it("T012-009 denies a disabled or revoked membership", async () => {
    const source = createSource({
      findCompanyMemberships: async () => [
        {
          id: companyMembershipId,
          is_enabled: false,
          maintenance_company_id: maintenanceCompanyId,
          platform_user_id: platformUserId,
          role: "COMPANY_ADMIN",
        },
      ],
    });

    await expect(resolveWith(identity, source)).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-010 fails closed for an unexpectedly ambiguous membership", async () => {
    const membership = {
      id: companyMembershipId,
      is_enabled: true,
      maintenance_company_id: maintenanceCompanyId,
      platform_user_id: platformUserId,
      role: "COMPANY_ADMIN",
    };

    await expect(
      resolveWith(
        identity,
        createSource({
          findCompanyMemberships: async () => [membership, membership],
        }),
      ),
    ).resolves.toMatchObject({
      context: null,
      status: "AUTHORIZATION_RESOLUTION_ERROR",
    });
  });

  it("T012-011 derives the effective role from the current membership", async () => {
    const source = createSource({
      findCompanyMemberships: async () => [
        {
          id: companyMembershipId,
          is_enabled: true,
          maintenance_company_id: maintenanceCompanyId,
          platform_user_id: platformUserId,
          role: "TECHNICIAN",
        },
      ],
    });

    await expect(resolveWith(identity, source)).resolves.toMatchObject({
      context: { role: "TECHNICIAN" },
      status: "AUTHORIZED",
    });
  });

  it("T012-012 ignores a stale JWT role and uses the current membership role", async () => {
    const identityWithStaleRole = {
      roleClaim: "COMPANY_ADMIN",
      subject: authSubject,
    };
    const source = createSource({
      findCompanyMemberships: async () => [
        {
          id: companyMembershipId,
          is_enabled: true,
          maintenance_company_id: maintenanceCompanyId,
          platform_user_id: platformUserId,
          role: "TECHNICIAN",
        },
      ],
    });

    await expect(
      resolveWith(identityWithStaleRole, source),
    ).resolves.toMatchObject({
      context: { role: "TECHNICIAN" },
      status: "AUTHORIZED",
    });
  });

  it("T012-013 rejects an unknown role without casting it into authority", async () => {
    const source = createSource({
      findCompanyMemberships: async () => [
        {
          id: companyMembershipId,
          is_enabled: true,
          maintenance_company_id: maintenanceCompanyId,
          platform_user_id: platformUserId,
          role: "SUPER_ADMIN",
        },
      ],
    });

    await expect(resolveWith(identity, source)).resolves.toEqual({
      context: null,
      status: "AUTHORIZATION_RESOLUTION_ERROR",
    });
  });

  it("T012-014 ignores a stale tenant claim", async () => {
    const identityWithStaleTenant = {
      subject: authSubject,
      tenantClaim: foreignMaintenanceCompanyId,
    };

    await expect(resolveWith(identityWithStaleTenant)).resolves.toMatchObject({
      context: { maintenanceCompanyId },
      status: "AUTHORIZED",
    });
  });

  it("T012-015 ignores a forged tenant cookie", async () => {
    const identityWithForgedCookie = {
      subject: authSubject,
      tenantCookie: foreignMaintenanceCompanyId,
    };

    await expect(resolveWith(identityWithForgedCookie)).resolves.toMatchObject({
      context: { maintenanceCompanyId },
      status: "AUTHORIZED",
    });
  });

  it("T012-016 ignores a frontend tenant identifier", async () => {
    const identityWithFrontendTenant = {
      frontendTenantId: foreignMaintenanceCompanyId,
      subject: authSubject,
    };

    await expect(
      resolveWith(identityWithFrontendTenant),
    ).resolves.toMatchObject({
      context: { maintenanceCompanyId },
      status: "AUTHORIZED",
    });
  });

  it("T012-017 does not let a known foreign tenant UUID alter context", async () => {
    const identityWithForeignTenant = {
      requestedTenantId: foreignMaintenanceCompanyId,
      subject: authSubject,
    };

    const result = await resolveWith(identityWithForeignTenant);

    expect(result).toMatchObject({
      context: { maintenanceCompanyId },
      status: "AUTHORIZED",
    });
    if (result.status !== "AUTHORIZED") {
      throw new Error("Expected an authorized result.");
    }
    expect(result.context.maintenanceCompanyId).not.toBe(
      foreignMaintenanceCompanyId,
    );
  });

  it("T012-018 denies a missing or RLS-invisible MaintenanceCompany", async () => {
    await expect(
      resolveWith(
        identity,
        createSource({ findMaintenanceCompanies: async () => [] }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-019 denies a new request after membership revocation", async () => {
    let membershipEnabled = true;
    const source = createSource({
      findCompanyMemberships: async () =>
        membershipEnabled
          ? [
              {
                id: companyMembershipId,
                is_enabled: true,
                maintenance_company_id: maintenanceCompanyId,
                platform_user_id: platformUserId,
                role: "TECHNICIAN",
              },
            ]
          : [],
    });

    await expect(resolveWith(identity, source)).resolves.toMatchObject({
      status: "AUTHORIZED",
    });
    membershipEnabled = false;
    await expect(resolveWith(identity, source)).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-020 never lets a previous context restore authorization", async () => {
    const firstResult = await resolveWith();
    const identityWithPreviousContext = {
      previousContext:
        firstResult.status === "AUTHORIZED" ? firstResult.context : null,
      subject: authSubject,
    };

    await expect(
      resolveWith(
        identityWithPreviousContext,
        createSource({ findCompanyMemberships: async () => [] }),
      ),
    ).resolves.toEqual({
      context: null,
      status: "AUTHENTICATED_BUT_UNAUTHORIZED",
    });
  });

  it("T012-021 maps lookup failures to a sanitized resolution error", async () => {
    const source = createSource({
      findAuthSubjectMappings: async () => {
        throw new Error("sensitive database policy detail");
      },
    });

    await expect(resolveWith(identity, source)).resolves.toEqual({
      context: null,
      status: "AUTHORIZATION_RESOLUTION_ERROR",
    });
  });

  it("T012-022 rejects partial or inconsistent source data", async () => {
    const source = createSource({
      findCompanyMemberships: async () => [
        {
          id: companyMembershipId,
          is_enabled: true,
          platform_user_id: platformUserId,
          role: "TECHNICIAN",
        },
      ],
    });

    await expect(resolveWith(identity, source)).resolves.toEqual({
      context: null,
      status: "AUTHORIZATION_RESOLUTION_ERROR",
    });
  });

  it("T012-023 uses only the caller-scoped server client and no privileged mechanism", () => {
    const implementationFiles = [
      new URL(
        "../src/modules/identity-authorization/application/authorization-context.ts",
        import.meta.url,
      ),
      new URL(
        "../src/modules/identity-authorization/application/resolve-current-authorization-context.ts",
        import.meta.url,
      ),
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/current-authorization-source.ts",
        import.meta.url,
      ),
      new URL(
        "../src/modules/identity-authorization/server.ts",
        import.meta.url,
      ),
    ];
    const implementation = implementationFiles
      .map((file) => readFileSync(file, "utf8"))
      .join("\n");
    const sourceAdapter = readFileSync(implementationFiles[2], "utf8");

    expect(sourceAdapter).toContain("createSupabaseServerClient()");
    expect(sourceAdapter.match(/\.from\(/g)).toHaveLength(4);
    expect(implementation).not.toMatch(
      /service[_-]role|SUPABASE_SERVICE_ROLE_KEY|SUPABASE_SECRET_KEY|auth\.admin|SECURITY DEFINER|\.rpc\s*\(/i,
    );
    expect(implementation).not.toMatch(/getSession\s*\(/);
    expect(implementation).not.toMatch(/\bany\b/);
  });

  it("T012-024 keeps tenant A authoritative when tenant B is supplied", async () => {
    const tenantAIdentityWithTenantBInput = {
      body: { maintenanceCompanyId: foreignMaintenanceCompanyId },
      headerTenantId: foreignMaintenanceCompanyId,
      pathTenantId: foreignMaintenanceCompanyId,
      queryTenantId: foreignMaintenanceCompanyId,
      subject: authSubject,
    };

    await expect(
      resolveWith(tenantAIdentityWithTenantBInput),
    ).resolves.toMatchObject({
      context: { maintenanceCompanyId },
      status: "AUTHORIZED",
    });
  });

  it("T012-025 keeps strict TypeScript enabled", () => {
    const tsconfig = JSON.parse(
      readFileSync(new URL("../tsconfig.json", import.meta.url), "utf8"),
    );

    expect(tsconfig.compilerOptions.strict).toBe(true);
  });
});
