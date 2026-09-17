import { readFileSync, readdirSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import {
  createMaintenanceCompanyWithSource,
  type MaintenanceCompanyCreationSource,
} from "../src/modules/tenant-management/application/create-maintenance-company";

const migrationsDirectory = new URL("../supabase/migrations/", import.meta.url);
const migrationFiles = readdirSync(migrationsDirectory).filter((file) =>
  /^\d{14}_task_016_maintenance_company_global_authoritative_creation\.sql$/.test(
    file,
  ),
);

if (migrationFiles.length !== 1) {
  throw new Error(
    `Expected exactly one TASK-016 migration, found ${migrationFiles.length}.`,
  );
}

const migration = readFileSync(
  new URL(migrationFiles[0], migrationsDirectory),
  "utf8",
);
const normalizedMigration = migration.replace(/\s+/g, " ").trim();
const adapter = readFileSync(
  new URL(
    "../src/modules/tenant-management/infrastructure/supabase/maintenance-company-creation-source.ts",
    import.meta.url,
  ),
  "utf8",
);
const serverBoundary = readFileSync(
  new URL("../src/modules/tenant-management/server.ts", import.meta.url),
  "utf8",
);

const operationId = "16000000-ABCD-4000-8000-000000000001";
const companyId = "16000000-0000-4000-8000-000000000101";

function source(
  data: unknown,
  capture?: (receivedOperationId: string) => void,
): MaintenanceCompanyCreationSource {
  return Object.freeze({
    async create(receivedOperationId: string) {
      capture?.(receivedOperationId);
      return data;
    },
  });
}

describe("TASK-016 application boundary", () => {
  it("T016-APP-001 uses a caller-scoped Supabase client and sends only the normalized operation ID", async () => {
    const capture = vi.fn();

    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: operationId },
        async () =>
          source(
            [
              {
                changed: true,
                maintenance_company_id: companyId,
                outcome: "CREATED",
                reason: "CREATED",
              },
            ],
            capture,
          ),
      ),
    ).resolves.toEqual({
      changed: true,
      maintenanceCompanyId: companyId,
      outcome: "CREATED",
      reason: "CREATED",
    });
    expect(capture).toHaveBeenCalledWith(operationId.toLowerCase());
    expect(adapter).toContain("createSupabaseServerClient()");
    expect(adapter).toContain('.rpc("create_maintenance_company", {');
    expect(adapter).toContain("p_creation_operation_id: creationOperationId");
  });

  it("T016-APP-002 keeps a strict closed input and result contract", async () => {
    const createSource = vi.fn(async () => source([]));

    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: "not-a-uuid" },
        createSource,
      ),
    ).resolves.toEqual({
      changed: false,
      maintenanceCompanyId: null,
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    expect(createSource).not.toHaveBeenCalled();
  });

  it("T016-APP-003 invokes only the purpose-specific RPC and never inserts a table directly", () => {
    expect(adapter).toContain("create_maintenance_company");
    expect(adapter).not.toMatch(/\.from\(|\.insert\(|\.update\(|\.delete\(/);
    expect(adapter).not.toMatch(/service[_-]?role|auth\.admin|SUPABASE_SERVICE/i);
  });

  it("T016-APP-004 exposes only a purpose-specific server boundary", () => {
    expect(serverBoundary).toContain("createMaintenanceCompanyWithSource");
    expect(serverBoundary).not.toMatch(/AdminClient|PrivilegedClient|CommandBus/i);
  });

  it("T016-APP-005 maps closed outcomes and rejects ambiguous transport or payload results", async () => {
    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: operationId },
        async () =>
          source([
            {
              changed: false,
              maintenance_company_id: companyId,
              outcome: "ALREADY_CREATED",
              reason: "ALREADY_CREATED",
            },
          ]),
      ),
    ).resolves.toEqual({
      changed: false,
      maintenanceCompanyId: companyId,
      outcome: "ALREADY_CREATED",
      reason: "ALREADY_CREATED",
    });
    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: operationId },
        async () =>
          source([
            {
              changed: false,
              maintenance_company_id: null,
              outcome: "DENIED",
              reason: "AUTHORIZATION_DENIED",
            },
          ]),
      ),
    ).resolves.toEqual({
      changed: false,
      maintenanceCompanyId: null,
      outcome: "DENIED",
      reason: "AUTHORIZATION_DENIED",
    });
    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: operationId },
        async () => source([{ changed: true, outcome: "CREATED" }]),
      ),
    ).rejects.toThrow("was not confirmed");
    await expect(
      createMaintenanceCompanyWithSource(
        { creationOperationId: operationId },
        async () => ({
          async create() {
            throw new Error("sensitive transport detail");
          },
        }),
      ),
    ).rejects.toThrow("was not confirmed");
  });
});

describe("TASK-016 migration boundary", () => {
  it("materializes one nullable correlation column with non-null uniqueness", () => {
    expect(normalizedMigration).toContain(
      "alter table public.maintenance_companies add column creation_operation_id uuid",
    );
    expect(normalizedMigration).toContain(
      "create unique index maintenance_companies_creation_operation_id_key on public.maintenance_companies (creation_operation_id) where creation_operation_id is not null",
    );
  });

  it("implements the exact hardened SECURITY DEFINER RPC", () => {
    expect(normalizedMigration).toMatch(
      /create function public\.create_maintenance_company\( p_creation_operation_id uuid \)[\s\S]*security definer set search_path = ''/i,
    );
    expect(normalizedMigration).toContain("v_auth_subject_id := auth.uid()");
    expect(normalizedMigration).toContain(
      "for update of actor_subject, actor_user",
    );
    expect(normalizedMigration).toContain(
      "from public.company_memberships as actor_membership",
    );
    expect(normalizedMigration).not.toMatch(/execute\s+(format|immediate)/i);
  });

  it("applies exact least-privilege grants without tenant bypass or table writes", () => {
    expect(normalizedMigration).toContain(
      "revoke all on function public.create_maintenance_company(uuid) from public, anon, authenticated, service_role, supabase_auth_admin",
    );
    expect(normalizedMigration).toContain(
      "grant execute on function public.create_maintenance_company(uuid) to authenticated",
    );
    expect(normalizedMigration).not.toMatch(/create policy|alter policy/i);
    expect(normalizedMigration).not.toMatch(
      /grant\s+(?:insert|update|delete|all).*public\.maintenance_companies/i,
    );
  });

  it("T016-SEC-005..010 introduces no privileged client, secret, Auth Admin, hook, or dynamic SQL surface", () => {
    const implementation = [migration, adapter, serverBoundary].join("\n");
    expect(implementation).not.toMatch(
      /SUPABASE_SERVICE_ROLE_KEY|SUPABASE_SECRET_KEY|getAdminClient|createPrivilegedSupabaseClient|auth\.admin/i,
    );
    expect(migration).not.toMatch(/auth\.sessions|task_013_custom_access_token_hook/i);
    expect(migration).not.toMatch(/execute\s+(format|immediate)/i);
  });
});
