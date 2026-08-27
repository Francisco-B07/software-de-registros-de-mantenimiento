import { createHash } from "node:crypto";
import { readFileSync, readdirSync } from "node:fs";

import { describe, expect, it } from "vitest";

const migrationsDirectory = new URL("../supabase/migrations/", import.meta.url);
const task010MigrationFiles = readdirSync(migrationsDirectory).filter((file) =>
  /^\d{14}_task_010_audit_event_foundation\.sql$/.test(file),
);

if (task010MigrationFiles.length !== 1) {
  throw new Error(
    `Expected exactly one TASK-010 migration, found ${task010MigrationFiles.length}.`,
  );
}

const migration = readFileSync(
  new URL(task010MigrationFiles[0], migrationsDirectory),
  "utf8",
);
const normalizedMigration = migration.replace(/\s+/g, " ").trim();

const task009Migration = readFileSync(
  new URL(
    "../supabase/migrations/20260825234939_task_009_identity_tenant_foundation.sql",
    import.meta.url,
  ),
);
const sqlTest = readFileSync(
  new URL(
    "../supabase/tests/database/task_010_audit_event_foundation.test.sql",
    import.meta.url,
  ),
  "utf8",
);

function tableDefinition(table: string): string {
  const match = normalizedMigration.match(
    new RegExp(`create table public\\.${table} \\((.*?)\\);`),
  );

  if (!match?.[1]) {
    throw new Error(`Missing table definition: ${table}`);
  }

  return match[1].trim();
}

function columnNames(definition: string): string[] {
  return Array.from(
    definition.matchAll(/(?:^|,)\s*([a-z][a-z0-9_]*)\s+[a-z]+/g),
    ([, column]) => column,
  ).filter((column) => column !== "constraint");
}

describe("TASK-010 AuditEvent foundation migration", () => {
  it("has exactly one TASK-010 migration and creates only audit_events", () => {
    expect(task010MigrationFiles).toHaveLength(1);

    const tables = Array.from(
      migration.matchAll(/create table public\.(\w+)/g),
      ([, table]) => table,
    );

    expect(tables).toEqual(["audit_events"]);
    expect(normalizedMigration).not.toMatch(
      /create\s+(?:materialized\s+)?view/i,
    );
  });

  it("defines exactly the approved columns and no generic payload", () => {
    const definition = tableDefinition("audit_events");

    expect(columnNames(definition)).toEqual([
      "id",
      "maintenance_company_id",
      "actor_kind",
      "actor_platform_user_id",
      "actor_internal_process_key",
      "action",
      "occurred_at",
      "scope_kind",
      "subject_platform_user_id",
      "role_before",
      "role_after",
    ]);

    expect(definition).not.toMatch(/\b(?:json|jsonb)\b/i);
    expect(definition).not.toMatch(
      /\b(?:created_at|updated_at|deleted_at|metadata|payload|details|ip|user_agent|request_id|trace_id|correlation_id|idempotency_key|reason|message|old_value|new_value)\b/i,
    );
  });

  it("enforces the exact PK and three RESTRICT foreign keys", () => {
    const definition = tableDefinition("audit_events");

    expect(definition).toContain("id uuid primary key");
    expect(definition).toContain("maintenance_company_id uuid not null");
    expect(definition).toContain("actor_platform_user_id uuid");
    expect(definition).toContain("subject_platform_user_id uuid not null");
    expect(definition).toContain(
      "foreign key (maintenance_company_id) references public.maintenance_companies (id) on delete restrict",
    );
    expect(definition).toContain(
      "foreign key (actor_platform_user_id) references public.platform_users (id) on delete restrict",
    );
    expect(definition).toContain(
      "foreign key (subject_platform_user_id) references public.platform_users (id) on delete restrict",
    );
    expect(definition.match(/foreign key/g)).toHaveLength(3);
    expect(definition.match(/on delete restrict/g)).toHaveLength(3);
    expect(definition).not.toMatch(/on delete (?:cascade|set null)/i);
    expect(definition).not.toMatch(/\bunique\b/i);
  });

  it("enforces the two actor kinds and exactly one valid actor representation", () => {
    const definition = tableDefinition("audit_events");

    expect(definition).toContain(
      "check (actor_kind in ('PLATFORM_USER', 'INTERNAL_PROCESS'))",
    );
    expect(definition).toContain("actor_kind = 'PLATFORM_USER'");
    expect(definition).toContain("actor_platform_user_id is not null");
    expect(definition).toContain("actor_internal_process_key is null");
    expect(definition).toContain("actor_kind = 'INTERNAL_PROCESS'");
    expect(definition).toContain("actor_platform_user_id is null");
    expect(definition).toContain("actor_internal_process_key is not null");
    expect(definition).toContain("btrim(actor_internal_process_key) <> ''");
  });

  it("limits action and scope to the exact TASK-010 catalog", () => {
    const approvedActions = [
      "USER_CREATED",
      "USER_DISABLED_OR_REVOKED",
      "USER_REINSTATED",
      "USER_ROLE_CHANGED",
    ];
    const futureActions = [
      "USER_CLIENT_ACCESS_CHANGED",
      "SUPPORT_ACCESS_GRANTED",
      "SUPPORT_ACCESS_SCOPE_CHANGED",
      "SUPPORT_ACCESS_REVOKED",
      "SUPPORT_ACCESS_USED",
    ];

    const actionCheck = normalizedMigration.match(
      /constraint audit_events_action_check check \( action in \( (.*?) \) \), constraint audit_events_scope_kind_check/,
    );
    const actionValues = Array.from(
      actionCheck?.[1].matchAll(/'([^']+)'/g) ?? [],
      ([, action]) => action,
    );

    expect(actionValues).toEqual(approvedActions);
    for (const action of futureActions) {
      expect(normalizedMigration).not.toContain(action);
    }

    expect(normalizedMigration).toContain("check (scope_kind = 'USER')");
    expect(normalizedMigration).toContain(
      "constraint audit_events_action_scope_check check ( action in",
    );
    expect(normalizedMigration).toContain("and scope_kind = 'USER'");
    expect(normalizedMigration).not.toMatch(
      /\b(?:USER_CLIENT_ACCESS|SUPPORT_GRANT|SUPPORT_ACCESS)\b/,
    );
  });

  it("requires a subject and preserves only valid role-change snapshots", () => {
    const definition = tableDefinition("audit_events");

    expect(definition).toContain("subject_platform_user_id uuid not null");
    expect(definition).toContain(
      "action = 'USER_ROLE_CHANGED' and role_before is not null and role_after is not null and role_before in ('COMPANY_ADMIN', 'TECHNICIAN') and role_after in ('COMPANY_ADMIN', 'TECHNICIAN') and role_before <> role_after",
    );
    expect(definition).toContain("role_before is null");
    expect(definition).toContain("role_after is null");
  });

  it("uses a PostgreSQL timestamptz default without privileged machinery", () => {
    const definition = tableDefinition("audit_events");

    expect(definition).toContain(
      "occurred_at timestamptz not null default now()",
    );
    expect(normalizedMigration).not.toMatch(/create\s+trigger/i);
    expect(normalizedMigration).not.toMatch(
      /create\s+(?:or\s+replace\s+)?function/i,
    );
    expect(normalizedMigration).not.toMatch(/security definer/i);
    expect(normalizedMigration).not.toMatch(/\b(?:rpc|service[_-]role)\b/i);
  });

  it("enables RLS with zero policies and revokes every table privilege", () => {
    expect(normalizedMigration).toContain(
      "alter table public.audit_events enable row level security;",
    );
    expect(normalizedMigration).toContain(
      "revoke all privileges on table public.audit_events from anon, authenticated;",
    );
    expect(normalizedMigration).not.toMatch(/create\s+policy/i);
    expect(normalizedMigration).not.toMatch(
      /grant\s+.+\s+on\s+table\s+public\.audit_events\s+to\s+(?:anon|authenticated)/i,
    );
    expect(normalizedMigration).not.toMatch(
      /revoke\s+(?:select|insert|update|delete)(?:\s*,|\s+on)/i,
    );

    for (const privilege of [
      "SELECT",
      "INSERT",
      "UPDATE",
      "DELETE",
      "TRUNCATE",
      "REFERENCES",
      "TRIGGER",
    ]) {
      expect(sqlTest).toContain(`'${privilege}'`);
    }
    expect(sqlTest).toContain("when insufficient_privilege then null");
    expect(sqlTest).toContain("truncate table public.audit_events");
  });

  it("adds no indexes, entities, or unrelated database mechanisms", () => {
    expect(normalizedMigration).not.toMatch(
      /create\s+(?:unique\s+)?index/i,
    );
    expect(normalizedMigration).not.toMatch(/create\s+sequence/i);
    expect(normalizedMigration).not.toMatch(/\b(?:serial|bigserial)\b/i);
    expect(normalizedMigration).not.toMatch(/user_client_access/i);
    expect(normalizedMigration).not.toMatch(/support_access_grant/i);
    expect(normalizedMigration).not.toMatch(/\bclient_id\b/i);
  });

  it("leaves the TASK-009 migration byte-for-byte unchanged", () => {
    const hash = createHash("sha256").update(task009Migration).digest("hex");

    expect(hash).toBe(
      "f567fa555c957313a0a3c8f39f7d7a13662941ed27d69f6e33616e7220be8aae",
    );
  });
});
