import { readFileSync, readdirSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import {
  applyCompanyMembershipLifecycleWithSource,
  type CompanyMembershipLifecycleCommand,
  type CompanyMembershipLifecycleSource,
} from "../src/modules/identity-authorization/application/apply-company-membership-lifecycle";

const migrationsDirectory = new URL("../supabase/migrations/", import.meta.url);
const migrationFiles = readdirSync(migrationsDirectory).filter((file) =>
  /^\d{14}_task_015_company_membership_lifecycle_audit_event_atomic\.sql$/.test(
    file,
  ),
);

if (migrationFiles.length !== 1) {
  throw new Error(
    `Expected exactly one TASK-015 migration, found ${migrationFiles.length}.`,
  );
}

const migration = readFileSync(
  new URL(migrationFiles[0], migrationsDirectory),
  "utf8",
);
const normalizedMigration = migration.replace(/\s+/g, " ").trim();
const adapter = readFileSync(
  new URL(
    "../src/modules/identity-authorization/infrastructure/supabase/company-membership-lifecycle-source.ts",
    import.meta.url,
  ),
  "utf8",
);
const serverBoundary = readFileSync(
  new URL("../src/modules/identity-authorization/server.ts", import.meta.url),
  "utf8",
);
const supabaseConfig = readFileSync(
  new URL("../supabase/config.toml", import.meta.url),
  "utf8",
);

function source(
  data: unknown,
  capture?: (command: CompanyMembershipLifecycleCommand) => void,
): CompanyMembershipLifecycleSource {
  return Object.freeze({
    async apply(command: CompanyMembershipLifecycleCommand) {
      capture?.(command);
      return data;
    },
  });
}

function applyWith(data: unknown) {
  return applyCompanyMembershipLifecycleWithSource(
    {
      operation: "CHANGE_ROLE",
      requestedRole: "COMPANY_ADMIN",
      targetCompanyMembershipId: "15000000-0000-4000-8000-000000000001",
    },
    async () => source(data),
  );
}

describe("TASK-015 application boundary", () => {
  it("T015-APP-001 sends only the normalized business intent", async () => {
    const capture = vi.fn();

    await expect(
      applyCompanyMembershipLifecycleWithSource(
        {
          operation: "DISABLE",
          targetCompanyMembershipId: "15000000-ABCD-4000-8000-000000000001",
        },
        async () =>
          source(
            [{ changed: true, outcome: "APPLIED", reason: "APPLIED" }],
            capture,
          ),
      ),
    ).resolves.toEqual({ changed: true, outcome: "APPLIED", reason: "APPLIED" });
    expect(capture).toHaveBeenCalledWith({
      operation: "DISABLE",
      requestedRole: null,
      targetCompanyMembershipId: "15000000-abcd-4000-8000-000000000001",
    });
  });

  it("T015-APP-002 maps the three exact RPC outcomes", async () => {
    await expect(
      applyWith([{ changed: true, outcome: "APPLIED", reason: "APPLIED" }]),
    ).resolves.toEqual({ changed: true, outcome: "APPLIED", reason: "APPLIED" });
    await expect(
      applyWith([
        {
          changed: false,
          outcome: "ALREADY_SATISFIED",
          reason: "ALREADY_SATISFIED",
        },
      ]),
    ).resolves.toEqual({
      changed: false,
      outcome: "ALREADY_SATISFIED",
      reason: "ALREADY_SATISFIED",
    });
    await expect(
      applyWith([
        {
          changed: false,
          outcome: "DENIED",
          reason: "ADMIN_CONTINUITY_REQUIRED",
        },
      ]),
    ).resolves.toEqual({
      changed: false,
      outcome: "DENIED",
      reason: "ADMIN_CONTINUITY_REQUIRED",
    });
  });

  it("T015-APP-003 rejects malformed UUID, operation, and role before the RPC", async () => {
    const createSource = vi.fn(async () => source([]));

    await expect(
      applyCompanyMembershipLifecycleWithSource(
        {
          operation: "DISABLE",
          targetCompanyMembershipId: "not-a-uuid",
        },
        createSource,
      ),
    ).resolves.toEqual({
      changed: false,
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    await expect(
      applyCompanyMembershipLifecycleWithSource(
        {
          operation: "CHANGE_ROLE",
          requestedRole: "OWNER",
          targetCompanyMembershipId: "15000000-0000-4000-8000-000000000001",
        } as never,
        createSource,
      ),
    ).resolves.toEqual({
      changed: false,
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    expect(createSource).not.toHaveBeenCalled();
  });

  it("T015-APP-004 rejects forbidden role input on non-role operations", async () => {
    const createSource = vi.fn(async () => source([]));

    await expect(
      applyCompanyMembershipLifecycleWithSource(
        {
          operation: "REINSTATE",
          requestedRole: "TECHNICIAN",
          targetCompanyMembershipId: "15000000-0000-4000-8000-000000000001",
        } as never,
        createSource,
      ),
    ).resolves.toEqual({
      changed: false,
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    expect(createSource).not.toHaveBeenCalled();
  });

  it("T015-APP-005 fails closed on transport errors and malformed output", async () => {
    const input = {
      operation: "REINSTATE" as const,
      targetCompanyMembershipId: "15000000-0000-4000-8000-000000000001",
    };

    await expect(
      applyCompanyMembershipLifecycleWithSource(input, async () => ({
        async apply() {
          throw new Error("sensitive transport detail");
        },
      })),
    ).rejects.toThrow("operation was not confirmed");
    await expect(
      applyCompanyMembershipLifecycleWithSource(
        input,
        async () =>
          source([{ changed: true, outcome: "DENIED", reason: "hidden" }]),
      ),
    ).rejects.toThrow("operation was not confirmed");
    await expect(
      applyCompanyMembershipLifecycleWithSource(input, async () => source([])),
    ).rejects.toThrow("operation was not confirmed");
  });

  it("T015-APP-006 uses the caller-scoped Supabase client and exact RPC inputs", () => {
    expect(adapter).toContain("createSupabaseServerClient");
    expect(adapter).toContain('rpc("apply_company_membership_lifecycle", {');
    expect(adapter).toContain("p_target_company_membership_id:");
    expect(adapter).toContain("p_operation:");
    expect(adapter).toContain("p_requested_role:");
    expect(adapter).not.toMatch(/service[_-]?role|auth\.admin|SUPABASE_SERVICE/i);
    expect(serverBoundary).toContain("applyCompanyMembershipLifecycleWithSource");
  });
});

describe("TASK-015 privileged database boundary", () => {
  it("T015-DB-STATIC-001 creates one exact public wrapper and private implementation", () => {
    expect(migrationFiles).toHaveLength(1);
    expect(normalizedMigration).toContain(
      "create or replace function private.apply_company_membership_lifecycle( p_target_company_membership_id uuid, p_operation text, p_requested_role text )",
    );
    expect(normalizedMigration).toContain(
      "create or replace function public.apply_company_membership_lifecycle( p_target_company_membership_id uuid, p_operation text, p_requested_role text )",
    );
    expect(migration.match(/create or replace function/g)).toHaveLength(2);
    expect(migration).not.toMatch(/p_(?:tenant|company|actor|platform_user)_id/i);
  });

  it("T015-DB-STATIC-002 preserves the CORR-021 invoker-to-private-definer topology", () => {
    expect(normalizedMigration).toMatch(
      /function private\.apply_company_membership_lifecycle[\s\S]*security definer set search_path = ''/,
    );
    expect(normalizedMigration).toMatch(
      /function public\.apply_company_membership_lifecycle[\s\S]*security invoker set search_path = ''/,
    );
    expect(normalizedMigration).toContain(
      "from private.apply_company_membership_lifecycle(",
    );
    expect(normalizedMigration.match(/owner to postgres/g)).toHaveLength(2);
    expect(supabaseConfig).toContain('schemas = ["public", "graphql_public"]');
  });

  it("T015-DB-STATIC-003 grants only the minimum authenticated execution path", () => {
    expect(normalizedMigration).toContain(
      "revoke all on function private.apply_company_membership_lifecycle(uuid, text, text) from public, anon, authenticated, service_role, supabase_auth_admin",
    );
    expect(normalizedMigration).toContain(
      "revoke all on function public.apply_company_membership_lifecycle(uuid, text, text) from public, anon, authenticated, service_role, supabase_auth_admin",
    );
    expect(normalizedMigration).toContain("grant usage on schema private to authenticated");
    expect(normalizedMigration.match(/grant execute on function/g)).toHaveLength(2);
    expect(normalizedMigration).not.toMatch(
      /grant\s+(?:insert|update|delete|all).*public\.(?:company_memberships|audit_events)/i,
    );
    expect(normalizedMigration).not.toMatch(/create policy|alter policy/i);
  });

  it("T015-DB-STATIC-004 derives the actor exclusively from auth.uid and current rows", () => {
    expect(normalizedMigration.match(/:= auth\.uid\(\)/g)).toHaveLength(2);
    expect(normalizedMigration).toContain(
      "v_auth_subject_id <> v_preliminary_auth_subject_id",
    );
    expect(normalizedMigration.match(/from public\.platform_user_auth_subjects/g)).toHaveLength(2);
    expect(normalizedMigration.match(/join public\.platform_users/g) ?? []).toHaveLength(4);
    expect(normalizedMigration.match(/join public\.company_memberships/g)).toHaveLength(2);
    expect(normalizedMigration.match(/v_actor_role <> 'COMPANY_ADMIN'/g)).toHaveLength(2);
    expect(normalizedMigration).not.toMatch(/current_setting\([^)]*(?:role|tenant|actor)/i);
  });

  it("T015-DB-STATIC-005 serializes each tenant and revalidates actor authority after the lock", () => {
    const lockOffset = normalizedMigration.indexOf("from public.maintenance_companies as actor_company");
    const secondActorResolution = normalizedMigration.lastIndexOf(
      "from public.platform_user_auth_subjects as actor_subject",
    );

    expect(lockOffset).toBeGreaterThan(0);
    expect(normalizedMigration.slice(lockOffset)).toContain("for update");
    expect(secondActorResolution).toBeGreaterThan(lockOffset);
    expect(normalizedMigration).toContain(
      "for update of actor_subject, actor_user, actor_membership",
    );
    expect(normalizedMigration).toContain(
      "for update of target_membership, target_user",
    );
    expect(normalizedMigration).toContain("v_enabled_admin_count <= 1");
  });

  it("T015-DB-STATIC-006 enforces self-target checks before no-op evaluation", () => {
    const selfCheck = normalizedMigration.indexOf("SELF_TARGET_NOT_ALLOWED");
    const noOp = normalizedMigration.indexOf("ALREADY_SATISFIED");

    expect(selfCheck).toBeGreaterThan(0);
    expect(noOp).toBeGreaterThan(selfCheck);
    expect(normalizedMigration).toContain(
      "p_target_company_membership_id = v_actor_company_membership_id",
    );
    expect(normalizedMigration).toContain("p_operation in ('DISABLE', 'CHANGE_ROLE')");
  });

  it("T015-DB-STATIC-007 implements only the three approved mutations and exact audit actions", () => {
    expect(normalizedMigration).toContain("set is_enabled = false");
    expect(normalizedMigration).toContain("set is_enabled = true");
    expect(normalizedMigration).toContain("set role = p_requested_role");
    expect(normalizedMigration).toContain("v_action := 'USER_DISABLED_OR_REVOKED'");
    expect(normalizedMigration).toContain("v_action := 'USER_REINSTATED'");
    expect(normalizedMigration).toContain("v_action := 'USER_ROLE_CHANGED'");
    expect(normalizedMigration.match(/insert into public\.audit_events/g)).toHaveLength(1);
    expect(normalizedMigration).toContain("pg_catalog.gen_random_uuid()");
  });

  it("T015-DB-STATIC-008 contains no provider session mutation or generic privileged capability", () => {
    expect(migration).not.toMatch(/auth\.sessions|signOut|ban_duration|password|jwt|service[_-]?key/i);
    expect(migration).not.toMatch(/execute\s+format|execute\s+immediate/i);
    expect(migration).not.toMatch(/create\s+(?:or replace\s+)?function\s+(?!private\.apply|public\.apply)/i);
  });
});
