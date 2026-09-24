import {
  existsSync,
  readFileSync,
  readdirSync,
} from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { createClientMock, rpcMock } = vi.hoisted(() => ({
  createClientMock: vi.fn(),
  rpcMock: vi.fn(),
}));

vi.mock("@supabase/supabase-js", () => ({
  createClient: createClientMock,
}));

import { createFirstAdminAuthHandoffService } from "../src/modules/identity-authorization/application/first-admin-onboarding-service";
import type {
  FirstAdminAuthHandoffSource,
  ResolveFirstAdminAuthHandoffInput,
} from "../src/modules/identity-authorization/application/first-admin-onboarding";
import { createSupabaseFirstAdminAuthHandoffSource } from "../src/modules/identity-authorization/infrastructure/supabase/first-admin-onboarding-server-source";

type Row = Record<string, unknown>;

const intentId = "01800000-0000-4000-8000-000000000001";
const companyId = "01800000-0000-4000-8000-000000000002";
const challengeId = "01800000-0000-4000-8000-000000000003";
const grantId = "01800000-0000-4000-8000-000000000004";
const credentialId = "01800000-0000-4000-8000-000000000005";
const authUserId = "01800000-0000-4000-8000-000000000006";
const otherAuthUserId = "01800000-0000-4000-8000-000000000007";
const authoritativeEmail = "first-admin@example.invalid";
const createdAt = "2026-09-20T03:03:27.000Z";
const expiresAt = "2026-09-20T03:08:27.000Z";

function validRow(overrides: Row = {}): Row {
  return {
    intent_id: intentId,
    maintenance_company_id: companyId,
    target_email: authoritativeEmail,
    current_challenge_id: challengeId,
    handoff_session_grant_id: grantId,
    handoff_ready_at: createdAt,
    challenge_consumed_at: createdAt,
    auth_bridge_credential_id: credentialId,
    bridge_auth_user_id: null,
    grant_auth_user_id: null,
    grant_purpose: "initial_session",
    grant_auth_method: "password",
    grant_created_at: createdAt,
    grant_expires_at: expiresAt,
    grant_consumed_at: null,
    grant_revoked_at: null,
    handoff_eligibility: "ELIGIBLE",
    identity_compatibility: "NO_APPLICATION_IDENTITY",
    ...overrides,
  };
}

function consumedRow(overrides: Row = {}): Row {
  return validRow({
    bridge_auth_user_id: authUserId,
    grant_auth_user_id: authUserId,
    grant_consumed_at: "2026-09-20T03:04:27.000Z",
    handoff_eligibility: "GRANT_CONSUMED",
    ...overrides,
  });
}

function failClosedRow(): Row {
  return Object.fromEntries(
    Object.keys(validRow()).map((key) => [
      key,
      key === "handoff_eligibility" || key === "identity_compatibility"
        ? "FAIL_CLOSED"
        : null,
    ]),
  );
}

function serviceFor(value: unknown) {
  const resolveAuthHandoff = vi.fn(async () => value);
  const source: FirstAdminAuthHandoffSource = Object.freeze({
    resolveAuthHandoff,
  });
  return {
    resolveAuthHandoff,
    service: createFirstAdminAuthHandoffService({
      createSource: () => source,
    }),
  };
}

function readCodeTree(path: string): string {
  if (!existsSync(path)) {
    return "";
  }

  return readdirSync(path, { withFileTypes: true })
    .flatMap((entry) => {
      const entryPath = join(path, entry.name);
      if (entry.isDirectory()) {
        return readCodeTree(entryPath);
      }
      return /\.[cm]?[jt]sx?$/.test(entry.name)
        ? readFileSync(entryPath, "utf8")
        : "";
    })
    .join("\n");
}

const contractPath = new URL(
  "../src/modules/identity-authorization/application/first-admin-onboarding.ts",
  import.meta.url,
);
const servicePath = new URL(
  "../src/modules/identity-authorization/application/first-admin-onboarding-service.ts",
  import.meta.url,
);
const adapterPath = new URL(
  "../src/modules/identity-authorization/infrastructure/supabase/first-admin-onboarding-server-source.ts",
  import.meta.url,
);
const serverBoundaryPath = new URL(
  "../src/modules/identity-authorization/server.ts",
  import.meta.url,
);

describe("TASK-018 Work Item A2 authoritative handoff boundary", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.stubEnv("AUTH_CHALLENGE_HMAC_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_CHALLENGE_HMAC_KEY_V1",
      "challenge-secret-material-32-bytes!!",
    );
    vi.stubEnv("AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_TECHNICAL_PASSWORD_KEY_V1",
      "technical-secret-material-32-bytes!!",
    );
    vi.stubEnv("SUPABASE_SECRET_KEY", "sb_secret_task018_fixture");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", "https://project.example.invalid");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY", "sb_publishable_fixture");
    createClientMock.mockReturnValue({ rpc: rpcMock });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("T018-A2-001 calls exactly the approved resolver RPC", async () => {
    rpcMock.mockResolvedValue({ data: [validRow()], error: null });
    const source = createSupabaseFirstAdminAuthHandoffSource();

    await expect(source.resolveAuthHandoff(intentId)).resolves.toEqual([
      validRow(),
    ]);
    expect(rpcMock).toHaveBeenCalledOnce();
    expect(rpcMock).toHaveBeenCalledWith(
      "resolve_first_admin_auth_handoff",
      { p_intent_id: intentId },
    );
  });

  it("T018-A2-002 sends only p_intent_id and exports one purpose-specific capability", async () => {
    rpcMock.mockResolvedValue({ data: [validRow()], error: null });
    const source = createSupabaseFirstAdminAuthHandoffSource();

    await source.resolveAuthHandoff(intentId);
    expect(Object.keys(source)).toEqual(["resolveAuthHandoff"]);
    expect(rpcMock.mock.calls[0]?.[1]).toEqual({ p_intent_id: intentId });
  });

  it("T018-A2-003 ignores a caller-selected email instead of treating it as authority", async () => {
    const { resolveAuthHandoff, service } = serviceFor([validRow()]);
    const input = {
      intentId,
      email: "attacker@example.invalid",
    } as ResolveFirstAdminAuthHandoffInput;

    await service.resolve(input);
    expect(resolveAuthHandoff).toHaveBeenCalledWith(intentId);
    expect(resolveAuthHandoff).not.toHaveBeenCalledWith(
      intentId,
      "attacker@example.invalid",
    );
  });

  it("T018-A2-004 ignores caller-selected tenant data", async () => {
    const { resolveAuthHandoff, service } = serviceFor([validRow()]);
    const input = {
      intentId,
      maintenanceCompanyId: otherAuthUserId,
    } as ResolveFirstAdminAuthHandoffInput;

    await service.resolve(input);
    expect(resolveAuthHandoff).toHaveBeenCalledWith(intentId);
  });

  it("T018-A2-005 ignores caller-selected role and authorization claims", async () => {
    const { resolveAuthHandoff, service } = serviceFor([validRow()]);
    const input = {
      intentId,
      isSuperAdmin: true,
      role: "OWNER",
    } as ResolveFirstAdminAuthHandoffInput;

    await service.resolve(input);
    expect(resolveAuthHandoff).toHaveBeenCalledWith(intentId);
  });

  it("T018-A2-006 maps an eligible unbound subject to the bounded continuation context", async () => {
    const { service } = serviceFor([validRow()]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      context: {
        authBridgeCredentialId: credentialId,
        boundAuthUserId: null,
        currentChallengeId: challengeId,
        handoffSessionGrantId: grantId,
        identityCompatibility: "NO_APPLICATION_IDENTITY",
        intentId,
        maintenanceCompanyId: companyId,
        targetEmail: authoritativeEmail,
      },
      outcome: "ELIGIBLE",
    });
  });

  it("T018-A2-007 maps an eligible compatible existing identity", async () => {
    const { service } = serviceFor([
      validRow({
        bridge_auth_user_id: authUserId,
        grant_auth_user_id: authUserId,
        identity_compatibility:
          "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toMatchObject({
      context: {
        boundAuthUserId: authUserId,
        identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      },
      outcome: "ELIGIBLE",
    });
  });

  it("T018-A2-008 maps INCOMPATIBLE_IDENTITY to a terminal bounded result", async () => {
    const { service } = serviceFor([
      validRow({
        bridge_auth_user_id: authUserId,
        grant_auth_user_id: authUserId,
        identity_compatibility: "INCOMPATIBLE_IDENTITY",
      }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "IDENTITY_INCOMPATIBLE",
    });
  });

  it("T018-A2-009 maps GRANT_EXPIRED without continuation context", async () => {
    const { service } = serviceFor([
      validRow({ handoff_eligibility: "GRANT_EXPIRED" }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      identityCompatibility: "NO_APPLICATION_IDENTITY",
      outcome: "GRANT_EXPIRED",
    });
  });

  it("T018-A2-010 maps GRANT_REVOKED without continuation context", async () => {
    const { service } = serviceFor([
      validRow({
        grant_revoked_at: "2026-09-20T03:04:27.000Z",
        handoff_eligibility: "GRANT_REVOKED",
      }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      identityCompatibility: "NO_APPLICATION_IDENTITY",
      outcome: "GRANT_REVOKED",
    });
  });

  it("T018-A2-011 maps GRANT_CONSUMED to reconciliation-required state", async () => {
    const { service } = serviceFor([
      validRow({
        grant_consumed_at: "2026-09-20T03:04:27.000Z",
        handoff_eligibility: "GRANT_CONSUMED",
      }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      identityCompatibility: "NO_APPLICATION_IDENTITY",
      outcome: "GRANT_CONSUMED",
    });
  });

  it("T018-A2-012 maps the fully redacted DB FAIL_CLOSED row to a security failure", async () => {
    const { service } = serviceFor([failClosedRow()]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-013 rejects an unknown eligibility classification", async () => {
    const { service } = serviceFor([
      validRow({ handoff_eligibility: "MAYBE" }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-014 rejects an unknown identity classification", async () => {
    const { service } = serviceFor([
      validRow({ identity_compatibility: "UNKNOWN_IDENTITY" }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-015 rejects zero result rows", async () => {
    const { service } = serviceFor([]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-016 rejects multiple result rows", async () => {
    const { service } = serviceFor([validRow(), validRow()]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-017 maps source/configuration failures to infrastructure failure", async () => {
    const sourceFailure = createFirstAdminAuthHandoffService({
      createSource: () => ({
        async resolveAuthHandoff() {
          throw new Error("provider details must not escape");
        },
      }),
    });
    const configurationFailure = createFirstAdminAuthHandoffService({
      createSource() {
        throw new Error("secret configuration details must not escape");
      },
    });

    await expect(sourceFailure.resolve({ intentId })).resolves.toEqual({
      outcome: "INFRASTRUCTURE_FAILURE",
    });
    await expect(configurationFailure.resolve({ intentId })).resolves.toEqual({
      outcome: "INFRASTRUCTURE_FAILURE",
    });
  });

  it("T018-A2-018 rejects missing or contradictory authoritative correlation fields", async () => {
    const missingTarget = validRow();
    delete missingTarget.target_email;
    const malformedRows = [
      missingTarget,
      validRow({ intent_id: otherAuthUserId }),
      validRow({ challenge_consumed_at: "2026-09-20T03:03:28.000Z" }),
      validRow({ grant_expires_at: "2026-09-20T03:09:27.000Z" }),
    ];

    for (const malformedRow of malformedRows) {
      const { service } = serviceFor([malformedRow]);
      await expect(service.resolve({ intentId })).resolves.toEqual({
        outcome: "SECURITY_CORRELATION_FAILURE",
      });
    }
  });

  it("T018-A2-019 rejects a purpose other than initial_session", async () => {
    const { service } = serviceFor([
      validRow({ grant_purpose: "password_reset" }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-020 rejects an auth method other than password", async () => {
    const { service } = serviceFor([
      validRow({ grant_auth_method: "magic_link" }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-021 rejects bridge/grant subject mismatch", async () => {
    const { service } = serviceFor([
      validRow({
        bridge_auth_user_id: authUserId,
        grant_auth_user_id: otherAuthUserId,
        identity_compatibility:
          "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      }),
    ]);

    await expect(service.resolve({ intentId })).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-A2-022 introduces no direct table access", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(/(?:client|supabase)\.from\s*\(/);
  });

  it("T018-A2-023 exports no raw privileged client or generic query capability", () => {
    const implementation = readFileSync(adapterPath, "utf8");
    const contract = readFileSync(contractPath, "utf8");
    const boundary = readFileSync(serverBoundaryPath, "utf8");

    expect(contract).toContain("resolveAuthHandoff(intentId: string)");
    expect(boundary).toContain("getFirstAdminAuthHandoffService");
    expect([implementation, contract, boundary].join("\n")).not.toMatch(
      /export\s+(?:const|function)\s+.*(?:raw|generic|admin).*client|arbitraryRpc|GenericRepository/i,
    );
  });

  it("T018-A2-024 keeps the privileged adapter out of current client-safe modules", () => {
    const appRoot = fileURLToPath(new URL("../app", import.meta.url));
    const browserSource = readFileSync(
      new URL("../src/infrastructure/supabase/browser.ts", import.meta.url),
      "utf8",
    );
    const clientSafeCode = `${readCodeTree(appRoot)}\n${browserSource}`;

    expect(clientSafeCode).not.toMatch(
      /first-admin-onboarding-server-source|FirstAdminAuthHandoff|getFirstAdminAuthHandoffService/,
    );
  });

  it("T018-A2-025 performs no database write", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(
      /(?:client|supabase)\.from\s*\(|\.insert\s*\(|\.update\s*\(|\.upsert\s*\(|\.delete\s*\(/,
    );
  });

  it("T018-A2-026 does not call Auth Admin", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(/auth\.admin|createUser|updateUserById/);
  });

  it("T018-A2-027 does not call signInWithPassword", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toContain("signInWithPassword");
  });

  it("T018-A2-028 does not consume or mutate a SessionGrant", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(/consume.*session.*grant|session.*grant.*consume/i);
  });

  it("T018-A2-029 does not create or mutate cookies or sessions", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(
      /cookies\s*\(|setCookie|setSession|exchangeCodeForSession|createSession/,
    );
  });

  it("T018-A2-030 creates no PlatformUser, CompanyMembership, or AuditEvent", () => {
    const implementation = [adapterPath, servicePath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");
    expect(implementation).not.toMatch(
      /createPlatformUser|createCompanyMembership|createAuditEvent|USER_CREATED/,
    );
  });

  it("T018-B2B-001 reuses the existing source with intentId as its only authoritative input", async () => {
    const { resolveAuthHandoff, service } = serviceFor([consumedRow()]);

    await service.resolvePostSignInAuthHandoffCorrelation(intentId);

    expect(resolveAuthHandoff).toHaveBeenCalledOnce();
    expect(resolveAuthHandoff).toHaveBeenCalledWith(intentId);
    expect(resolveAuthHandoff.mock.calls[0]).toHaveLength(1);
  });

  it("T018-B2B-002 returns the exact bounded correlation projection for a valid consumed row", async () => {
    const { service } = serviceFor([consumedRow()]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({
      authBridgeCredentialId: credentialId,
      bridgeAuthUserId: authUserId,
      currentChallengeId: challengeId,
      grantAuthUserId: authUserId,
      handoffSessionGrantId: grantId,
      identityCompatibility: "NO_APPLICATION_IDENTITY",
      intentId,
      maintenanceCompanyId: companyId,
      outcome: "CORRELATED_CONSUMED",
      targetEmail: authoritativeEmail,
    });
  });

  it("T018-B2B-003 preserves compatible existing-identity classification", async () => {
    const { service } = serviceFor([
      consumedRow({
        identity_compatibility:
          "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      }),
    ]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toMatchObject({
      bridgeAuthUserId: authUserId,
      grantAuthUserId: authUserId,
      identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      outcome: "CORRELATED_CONSUMED",
    });
  });

  it.each([
    [
      "mismatched subjects",
      consumedRow({ grant_auth_user_id: otherAuthUserId }),
    ],
    ["missing bridge subject", consumedRow({ bridge_auth_user_id: null })],
    ["missing grant subject", consumedRow({ grant_auth_user_id: null })],
    [
      "invalid bridge subject",
      consumedRow({
        bridge_auth_user_id: "not-a-uuid",
        grant_auth_user_id: "not-a-uuid",
      }),
    ],
  ])("T018-B2B-004 fails closed for %s", async (_label, row) => {
    const { service } = serviceFor([row]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
  });

  it("T018-B2B-005 fails closed when consumed classification lacks consumedAt", async () => {
    const { service } = serviceFor([
      consumedRow({ grant_consumed_at: null }),
    ]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
  });

  it.each([
    ["ELIGIBLE", validRow()],
    ["GRANT_EXPIRED", validRow({ handoff_eligibility: "GRANT_EXPIRED" })],
    [
      "GRANT_REVOKED",
      validRow({
        grant_revoked_at: "2026-09-20T03:04:27.000Z",
        handoff_eligibility: "GRANT_REVOKED",
      }),
    ],
  ])("T018-B2B-006 maps %s to bounded NOT_CONSUMED", async (_label, row) => {
    const { service } = serviceFor([row]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "NOT_CONSUMED" });
  });

  it("T018-B2B-007 preserves incompatible identity as bounded non-success", async () => {
    const { service } = serviceFor([
      consumedRow({ identity_compatibility: "INCOMPATIBLE_IDENTITY" }),
    ]);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "IDENTITY_INCOMPATIBLE" });
  });

  it.each([
    ["FAIL_CLOSED", [failClosedRow()]],
    ["unknown state", [validRow({ handoff_eligibility: "UNKNOWN" })]],
    ["zero rows", []],
    ["multiple rows", [consumedRow(), consumedRow()]],
    ["malformed row", [{ intent_id: intentId }]],
  ])("T018-B2B-008 fails closed for %s", async (_label, value) => {
    const { service } = serviceFor(value);

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
  });

  it("T018-B2B-009 maps source failure to bounded infrastructure failure", async () => {
    const source: FirstAdminAuthHandoffSource = Object.freeze({
      resolveAuthHandoff: vi.fn(async () => {
        throw new Error("redacted database failure");
      }),
    });
    const service = createFirstAdminAuthHandoffService({
      createSource: () => source,
    });

    await expect(
      service.resolvePostSignInAuthHandoffCorrelation(intentId),
    ).resolves.toEqual({ outcome: "INFRASTRUCTURE_FAILURE" });
  });

  it("T018-B2B-010 rejects caller-selected correlation data before source access", async () => {
    const { resolveAuthHandoff, service } = serviceFor([consumedRow()]);
    const invoke = service.resolvePostSignInAuthHandoffCorrelation as (
      input: unknown,
    ) => Promise<unknown>;

    await expect(
      invoke({
        authUserId: otherAuthUserId,
        intentId,
        maintenanceCompanyId: otherAuthUserId,
        role: "OWNER",
      }),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
    expect(resolveAuthHandoff).not.toHaveBeenCalled();
  });

  it("T018-B2B-011 exposes only the required correlation fields", async () => {
    const { service } = serviceFor([consumedRow()]);

    const result = await service.resolvePostSignInAuthHandoffCorrelation(
      intentId,
    );

    expect(Object.keys(result).sort()).toEqual(
      [
        "authBridgeCredentialId",
        "bridgeAuthUserId",
        "currentChallengeId",
        "grantAuthUserId",
        "handoffSessionGrantId",
        "identityCompatibility",
        "intentId",
        "maintenanceCompanyId",
        "outcome",
        "targetEmail",
      ].sort(),
    );
    expect(JSON.stringify(result)).not.toMatch(
      /(?:secret|token|password|keyVersion|grantCreatedAt|grantExpiresAt|grantRevokedAt|grantConsumedAt|purpose|authMethod|platformUser|membership|role)/i,
    );
  });

  it("T018-B2B-012 remains a read-only narrow server application capability", () => {
    const implementation = [adapterPath, servicePath, contractPath]
      .map((path) => readFileSync(path, "utf8"))
      .join("\n");

    expect(implementation).not.toMatch(/(?:client|supabase)\.from\s*\(/);
    expect(implementation).not.toMatch(
      /\.insert\s*\(|\.update\s*\(|\.upsert\s*\(|\.delete\s*\(/,
    );
    expect(implementation).not.toMatch(
      /auth\.admin|createUser|signInWithPassword|setSession|setCookie|cookies\s*\(/,
    );
    expect(readFileSync(adapterPath, "utf8")).not.toMatch(
      /export\s+(?:const|function)\s+.*(?:raw|generic|admin).*client|arbitraryRpc|GenericRepository/i,
    );
  });
});
