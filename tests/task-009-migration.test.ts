import { readFileSync } from "node:fs";

import { describe, expect, it } from "vitest";

const migration = readFileSync(
  new URL(
    "../supabase/migrations/20260825234939_task_009_identity_tenant_foundation.sql",
    import.meta.url,
  ),
  "utf8",
);

const normalizedMigration = migration.replace(/\s+/g, " ").trim();

function tableDefinition(table: string): string {
  const match = normalizedMigration.match(
    new RegExp(`create table public\\.${table} \\((.*?)\\);`),
  );

  if (!match?.[1]) {
    throw new Error(`Missing table definition: ${table}`);
  }

  return match[1].trim();
}

describe("TASK-009 identity and tenant foundation migration", () => {
  it("creates exactly the four approved public tables", () => {
    const tables = Array.from(
      migration.matchAll(/create table public\.(\w+)/g),
      ([, table]) => table,
    );

    expect(tables).toEqual([
      "maintenance_companies",
      "platform_users",
      "platform_user_auth_subjects",
      "company_memberships",
    ]);
  });

  it("keeps maintenance companies and platform users minimal", () => {
    expect(tableDefinition("maintenance_companies")).toBe("id uuid primary key");
    expect(tableDefinition("platform_users")).toBe("id uuid primary key");
  });

  it("maps each Auth subject to one PlatformUser without closing the inverse cardinality", () => {
    const definition = tableDefinition("platform_user_auth_subjects");

    expect(definition).toContain("auth_subject_id uuid primary key");
    expect(definition).toContain("platform_user_id uuid not null");
    expect(definition).toContain("references auth.users (id) on delete cascade");
    expect(definition).toContain(
      "references public.platform_users (id) on delete restrict",
    );
    expect(definition).not.toMatch(/unique\s*\(\s*platform_user_id\s*\)/);
    expect(definition).not.toMatch(/platform_user_id uuid[^,]*\bunique\b/);
  });

  it("enforces one enabled-or-disabled tenant membership and the two approved roles", () => {
    const definition = tableDefinition("company_memberships");

    expect(definition).toContain("id uuid primary key");
    expect(definition).toContain("platform_user_id uuid not null unique");
    expect(definition).toContain("maintenance_company_id uuid not null");
    expect(definition).toContain("role text not null");
    expect(definition).toContain("is_enabled boolean not null");
    expect(definition).toContain(
      "references public.platform_users (id) on delete restrict",
    );
    expect(definition).toContain(
      "references public.maintenance_companies (id) on delete restrict",
    );
    expect(definition).toContain(
      "check (role in ('COMPANY_ADMIN', 'TECHNICIAN'))",
    );
  });

  it("enables RLS on all four tables and exposes only SELECT to authenticated", () => {
    const tables = [
      "maintenance_companies",
      "platform_users",
      "platform_user_auth_subjects",
      "company_memberships",
    ];

    for (const table of tables) {
      expect(normalizedMigration).toContain(
        `alter table public.${table} enable row level security;`,
      );
      expect(normalizedMigration).toContain(
        `revoke all privileges on table public.${table} from anon, authenticated;`,
      );
      expect(normalizedMigration).toContain(
        `grant select on table public.${table} to authenticated;`,
      );
    }

    expect(normalizedMigration).not.toMatch(
      /grant\s+(?:insert|update|delete|all)/i,
    );
  });

  it("defines exactly four authenticated SELECT policies anchored only by auth.uid()", () => {
    const policies = Array.from(
      migration.matchAll(/create policy "([^"]+)"/g),
      ([, policy]) => policy,
    );

    expect(policies).toEqual([
      "task_009_read_own_auth_subject_mapping",
      "task_009_read_own_platform_user",
      "task_009_read_own_enabled_membership",
      "task_009_read_own_maintenance_company",
    ]);
    expect(migration.match(/for select/g)).toHaveLength(4);
    expect(migration.match(/to authenticated/g)).toHaveLength(8);
    expect(normalizedMigration).toContain("company_memberships.platform_user_id");
    expect(normalizedMigration).toContain("membership.is_enabled");
    expect(normalizedMigration).toContain(
      "membership.maintenance_company_id = maintenance_companies.id",
    );
    expect(normalizedMigration).not.toContain("auth.jwt(");
  });

  it("introduces no privileged or out-of-scope database mechanism", () => {
    expect(normalizedMigration).not.toMatch(/service[_-]role/i);
    expect(normalizedMigration).not.toMatch(/security definer/i);
    expect(normalizedMigration).not.toMatch(/create\s+(?:or\s+replace\s+)?function/i);
    expect(normalizedMigration).not.toMatch(/create\s+trigger/i);
    expect(normalizedMigration).not.toMatch(/create\s+(?:materialized\s+)?view/i);
    expect(normalizedMigration).not.toMatch(/\baudit_events?\b/i);
    expect(normalizedMigration).not.toMatch(/user_client_access/i);
    expect(normalizedMigration).not.toMatch(/support_access_grant/i);
  });
});
