import { readFileSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import type { ValidatedAuthIdentity } from "../src/modules/identity-authorization/application/authorization-context";
import {
  type CurrentGlobalAuthorizationSource,
  resolveCurrentGlobalAuthorizationWithSource,
} from "../src/modules/identity-authorization/application/resolve-current-global-authorization";

const identity: ValidatedAuthIdentity = Object.freeze({
  subject: "94000000-0000-4000-8000-000000000001",
});

function source(data: unknown): CurrentGlobalAuthorizationSource {
  return Object.freeze({
    async resolveCurrentGlobalAuthority() {
      return data;
    },
  });
}

function row(
  identityResolved: boolean,
  isSuperAdmin: boolean,
  hasCompanyMembership: boolean,
) {
  return [
    {
      has_company_membership: hasCompanyMembership,
      identity_resolved: identityResolved,
      is_super_admin: isSuperAdmin,
    },
  ];
}

function resolveWith(
  data: unknown,
  currentIdentity: ValidatedAuthIdentity | null | undefined = identity,
) {
  return resolveCurrentGlobalAuthorizationWithSource(
    currentIdentity,
    async () => source(data),
  );
}

describe("TASK-014 global identity and authorization foundation", () => {
  it("T014-TS-001 denies an absent validated identity without creating a source", async () => {
    const createSource = vi.fn(async () => source(row(true, true, false)));

    await expect(
      resolveCurrentGlobalAuthorizationWithSource(null, createSource),
    ).resolves.toEqual({ status: "UNRESOLVABLE_IDENTITY" });
    expect(createSource).not.toHaveBeenCalled();
  });

  it("T014-TS-002 authorizes a resolved global identity without membership", async () => {
    await expect(resolveWith(row(true, true, false))).resolves.toEqual({
      status: "AUTHORIZED_GLOBAL_SUPER_ADMIN",
    });
  });

  it("T014-TS-003 denies an enabled-membership conflict as inconsistent", async () => {
    await expect(resolveWith(row(true, true, true))).resolves.toEqual({
      status: "INCONSISTENT_GLOBAL_AND_TENANT_IDENTITY",
    });
  });

  it("T014-TS-004 denies a disabled-membership conflict detected by the RPC", async () => {
    await expect(resolveWith(row(true, true, true))).resolves.toEqual({
      status: "INCONSISTENT_GLOBAL_AND_TENANT_IDENTITY",
    });
  });

  it("T014-TS-005 classifies a tenant member without global authority as not global", async () => {
    await expect(resolveWith(row(true, false, true))).resolves.toEqual({
      status: "NOT_GLOBAL_SUPER_ADMIN",
    });
  });

  it("T014-TS-006 does not infer global authority from membership absence", async () => {
    await expect(resolveWith(row(true, false, false))).resolves.toEqual({
      status: "NOT_GLOBAL_SUPER_ADMIN",
    });
  });

  it("T014-TS-007 denies an unresolved RPC identity", async () => {
    await expect(resolveWith(row(false, false, false))).resolves.toEqual({
      status: "UNRESOLVABLE_IDENTITY",
    });
  });

  it("T014-TS-008 maps RPC errors to a fail-closed result", async () => {
    const failingSource: CurrentGlobalAuthorizationSource = Object.freeze({
      async resolveCurrentGlobalAuthority() {
        throw new Error("sensitive database detail");
      },
    });

    await expect(
      resolveCurrentGlobalAuthorizationWithSource(
        identity,
        async () => failingSource,
      ),
    ).resolves.toEqual({ status: "UNRESOLVABLE_IDENTITY" });
  });

  it("T014-TS-009 rejects malformed output", async () => {
    await expect(
      resolveWith([{ identity_resolved: true, is_super_admin: true }]),
    ).resolves.toEqual({ status: "UNRESOLVABLE_IDENTITY" });
  });

  it("T014-TS-010 rejects null and non-singleton output", async () => {
    await expect(resolveWith(null)).resolves.toEqual({
      status: "UNRESOLVABLE_IDENTITY",
    });
    await expect(resolveWith([])).resolves.toEqual({
      status: "UNRESOLVABLE_IDENTITY",
    });
    await expect(
      resolveWith([...row(true, true, false), ...row(true, false, true)]),
    ).resolves.toEqual({ status: "UNRESOLVABLE_IDENTITY" });
  });

  it("T014-TS-011 rejects unexpected fields and impossible unresolved authority", async () => {
    await expect(
      resolveWith([
        {
          ...row(true, true, false)[0],
          maintenance_company_id: "caller-selected-tenant",
        },
      ]),
    ).resolves.toEqual({ status: "UNRESOLVABLE_IDENTITY" });
    await expect(resolveWith(row(false, true, false))).resolves.toEqual({
      status: "UNRESOLVABLE_IDENTITY",
    });
  });

  it("T014-TS-012 ignores a stale SUPER_ADMIN claim when the RPC denies", async () => {
    const staleClaimIdentity = {
      roleClaim: "SUPER_ADMIN",
      subject: identity.subject,
    };

    await expect(
      resolveWith(row(true, false, false), staleClaimIdentity),
    ).resolves.toEqual({ status: "NOT_GLOBAL_SUPER_ADMIN" });
  });

  it("T014-TS-013 allows RPC authority without a role claim", async () => {
    await expect(resolveWith(row(true, true, false), identity)).resolves.toEqual({
      status: "AUTHORIZED_GLOBAL_SUPER_ADMIN",
    });
  });

  it("T014-TS-014 caller-supplied IDs and state cannot alter the RPC result", async () => {
    const hostileInput = {
      isSuperAdmin: true,
      maintenanceCompanyId: "00000000-0000-4000-8000-000000014999",
      platformUserId: "00000000-0000-4000-8000-000000014998",
      subject: identity.subject,
    };

    await expect(
      resolveWith(row(true, false, false), hostileInput),
    ).resolves.toEqual({ status: "NOT_GLOBAL_SUPER_ADMIN" });
  });

  it("T014-TS-015 keeps authority request-scoped without a cross-request cache", async () => {
    let current = row(true, true, false);
    const dynamicSource: CurrentGlobalAuthorizationSource = Object.freeze({
      async resolveCurrentGlobalAuthority() {
        return current;
      },
    });
    const createSource = vi.fn(async () => dynamicSource);

    await expect(
      resolveCurrentGlobalAuthorizationWithSource(identity, createSource),
    ).resolves.toEqual({ status: "AUTHORIZED_GLOBAL_SUPER_ADMIN" });
    current = row(true, false, false);
    await expect(
      resolveCurrentGlobalAuthorizationWithSource(identity, createSource),
    ).resolves.toEqual({ status: "NOT_GLOBAL_SUPER_ADMIN" });
    expect(createSource).toHaveBeenCalledTimes(2);
  });

  it("T014-TS-016 freezes every semantic outcome", async () => {
    const resolved = await resolveWith(row(true, true, false));
    expect(Object.isFrozen(resolved)).toBe(true);
  });

  it("T014-TS-017 uses the existing caller-scoped server client and a zero-argument RPC", () => {
    const adapter = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/current-global-authorization-source.ts",
        import.meta.url,
      ),
      "utf8",
    );

    expect(adapter).toContain("createSupabaseServerClient()");
    expect(adapter).toContain('.rpc("resolve_current_global_authority")');
    expect(adapter).not.toMatch(/\.rpc\([^\n]+,\s*\{/);
  });

  it("T014-TS-018 introduces no service-role, Admin Auth, or generic privileged client path", () => {
    const implementation = [
      "../src/modules/identity-authorization/application/resolve-current-global-authorization.ts",
      "../src/modules/identity-authorization/infrastructure/supabase/current-global-authorization-source.ts",
      "../src/modules/identity-authorization/server.ts",
    ]
      .map((path) => readFileSync(new URL(path, import.meta.url), "utf8"))
      .join("\n");

    expect(implementation).not.toMatch(
      /service[_-]role|SUPABASE_SERVICE_ROLE_KEY|SUPABASE_SECRET_KEY|auth\.admin|getAdminClient|createPrivilegedSupabaseClient/i,
    );
  });

  it("T014-TS-019 keeps the migration to one column, one read-only RPC, and exact privileges", () => {
    const migration = readFileSync(
      new URL(
        "../supabase/migrations/20260904004013_task_014_global_identity_authorization_foundation.sql",
        import.meta.url,
      ),
      "utf8",
    );

    expect(migration.match(/create function/gi)).toHaveLength(1);
    expect(migration).toMatch(
      /add column is_super_admin boolean not null default false/i,
    );
    expect(migration).toMatch(/security definer[\s\S]*set search_path = ''/i);
    expect(migration).toMatch(/auth\.uid\(\)/);
    expect(migration).toMatch(
      /revoke execute[\s\S]*from public, anon, authenticated, service_role, supabase_auth_admin/i,
    );
    expect(migration).toMatch(/grant execute[\s\S]*to authenticated/i);
    expect(migration).not.toMatch(/\b(update|insert|delete)\s+public\./i);
    expect(migration).not.toMatch(/create policy|alter policy|drop policy/i);
  });

  it("T014-TS-020 exports only the purpose-specific resolver from the server boundary", () => {
    const server = readFileSync(
      new URL(
        "../src/modules/identity-authorization/server.ts",
        import.meta.url,
      ),
      "utf8",
    );

    expect(server).toContain("resolveCurrentGlobalAuthorization");
    expect(server).not.toMatch(/getGlobal.*Client|global.*Admin/i);
  });
});
