import { createHash } from "node:crypto";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const migrationsDirectory = join(process.cwd(), "supabase", "migrations");
const migrationNames = readdirSync(migrationsDirectory).filter((name) =>
  name.endsWith("_corr_032_task_013_auth_bridge_prebound_hook_correction.sql"),
);
const historicalMigrationPath = join(
  migrationsDirectory,
  "20260830010000_task_013_verification_challenge_foundation.sql",
);

describe("CORR-032 TASK-013 Hook correction", () => {
  it("has exactly one forward-only migration and preserves the historical migration bytes", () => {
    expect(migrationNames).toHaveLength(1);

    const historicalBytes = readFileSync(historicalMigrationPath);
    expect(createHash("sha256").update(historicalBytes).digest("hex")).toBe(
      "1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf",
    );
  });

  it("replaces only the existing Hook under its original invoker boundary", () => {
    const migration = readFileSync(
      join(migrationsDirectory, migrationNames[0]),
      "utf8",
    );
    const normalized = migration.toLowerCase();

    expect(
      normalized.match(
        /create or replace function public\.task_013_custom_access_token_hook\(event jsonb\)/g,
      ),
    ).toHaveLength(1);
    expect(normalized).toContain("security invoker");
    expect(normalized).toContain("set search_path = ''");
    expect(normalized).not.toMatch(/security\s+definer/);
    expect(normalized).not.toMatch(
      /\b(create table|alter table|create index|create policy|alter policy|drop policy|grant|revoke)\b/,
    );
    expect(normalized).not.toMatch(
      /\b(maintenance_companies|platform_users|company_memberships|audit_events|service_role|technical_password)\b/,
    );
  });

  it("uses SessionGrant as the serialization point and updates a bridge only while unbound", () => {
    const migration = readFileSync(
      join(migrationsDirectory, migrationNames[0]),
      "utf8",
    );
    const normalized = migration.replace(/\r\n/g, "\n").toLowerCase();

    expect(normalized.match(/for update/g)).toHaveLength(2);
    expect(normalized).toMatch(/for update of session_grant;[\s\S]*select id, email, auth_user_id into strict v_bridge[\s\S]*where id = v_grant\.auth_bridge_credential_id;[\s\S]*if v_bridge\.auth_user_id is null then/);
    expect(normalized).toMatch(/if v_bridge\.auth_user_id is null then[\s\S]*for update;[\s\S]*update public\.auth_bridge_credentials/);
    expect(normalized).toMatch(/update public\.auth_session_grants[\s\S]*and consumed_at is null[\s\S]*and revoked_at is null/);
  });
});
