import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { createClientMock, createUserMock, rpcMock } = vi.hoisted(() => ({
  createClientMock: vi.fn(),
  createUserMock: vi.fn(),
  rpcMock: vi.fn(),
}));

vi.mock("@supabase/supabase-js", () => ({
  createClient: createClientMock,
}));

import {
  createFirstAdminAuthProvisioningService,
  resolveFirstAdminTechnicalPassword,
} from "../src/modules/identity-authorization/application/first-admin-auth-provisioning-service";
import type {
  FirstAdminAuthHandoffContext,
  FirstAdminAuthProvisioningResult,
  FirstAdminAuthProvisioningSource,
  FirstAdminAuthTechnicalPasswordStateSource,
} from "../src/modules/identity-authorization/application/first-admin-onboarding";
import { createSupabaseFirstAdminAuthProvisioningSource } from "../src/modules/identity-authorization/infrastructure/supabase/auth-admin-boundary";
import { createSupabaseFirstAdminAuthTechnicalPasswordStateSource } from "../src/modules/identity-authorization/infrastructure/supabase/first-admin-auth-technical-password-state-source";
import { DEVELOPMENT_PASSWORD_POLICY } from "../src/infrastructure/config/auth-private";

const intentId = "01810000-0000-4000-8000-000000000001";
const companyId = "01810000-0000-4000-8000-000000000002";
const challengeId = "01810000-0000-4000-8000-000000000003";
const grantId = "01810000-0000-4000-8000-000000000004";
const credentialId = "01810000-0000-4000-8000-000000000005";
const otherCredentialId = "01810000-0000-4000-8000-000000000006";
const authUserId = "01810000-0000-4000-8000-000000000007";
const authoritativeEmail = "first-admin@example.invalid";
const technicalPassword = "server-derived-technical-password";
const keyA = new Uint8Array(Buffer.from("technical-secret-material-key-A-32!!"));
const keyB = new Uint8Array(Buffer.from("technical-secret-material-key-B-32!!"));

const handoffContext: FirstAdminAuthHandoffContext = Object.freeze({
  authBridgeCredentialId: credentialId,
  boundAuthUserId: null,
  currentChallengeId: challengeId,
  handoffSessionGrantId: grantId,
  identityCompatibility: "NO_APPLICATION_IDENTITY",
  intentId,
  maintenanceCompanyId: companyId,
  targetEmail: authoritativeEmail,
});

function sourceFor(result: FirstAdminAuthProvisioningResult) {
  const provisionVerifiedFirstAdminIdentity = vi.fn(async () => result);
  const source: FirstAdminAuthProvisioningSource = Object.freeze({
    provisionVerifiedFirstAdminIdentity,
  });

  return { provisionVerifiedFirstAdminIdentity, source };
}

function readyState(
  technicalPasswordKeyVersion = "v1",
  authBridgeCredentialId = credentialId,
) {
  return [
    {
      auth_bridge_credential_id: authBridgeCredentialId,
      rotation_state: "READY",
      technical_password_key_version: technicalPasswordKeyVersion,
    },
  ];
}

function technicalPasswordStateSourceFor(result: unknown) {
  const resolveTechnicalPasswordState = vi.fn(async () => result);
  const source: FirstAdminAuthTechnicalPasswordStateSource = Object.freeze({
    resolveTechnicalPasswordState,
  });

  return { resolveTechnicalPasswordState, source };
}

function passwordConfig(activeVersion: "v2" | "v3") {
  return {
    passwordPolicy: DEVELOPMENT_PASSWORD_POLICY,
    technicalPasswordActiveVersion: activeVersion,
    technicalPasswordKeys: new Map([
      ["v1", keyA],
      ["v2", keyB],
      ["v3", keyB],
    ]),
  } as const;
}

function serviceFor(
  result: FirstAdminAuthProvisioningResult,
  technicalPasswordState: unknown = readyState(),
) {
  const { provisionVerifiedFirstAdminIdentity, source } = sourceFor(result);
  const { resolveTechnicalPasswordState, source: technicalPasswordStateSource } =
    technicalPasswordStateSourceFor(technicalPasswordState);
  const resolveTechnicalPassword = vi.fn(() => technicalPassword);
  return {
    provisionVerifiedFirstAdminIdentity,
    resolveTechnicalPassword,
    resolveTechnicalPasswordState,
    service: createFirstAdminAuthProvisioningService({
      createProvisioningSource: () => source,
      createTechnicalPasswordStateSource: () => technicalPasswordStateSource,
      resolveTechnicalPassword,
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

const servicePath = new URL(
  "../src/modules/identity-authorization/application/first-admin-auth-provisioning-service.ts",
  import.meta.url,
);
const adapterPath = new URL(
  "../src/modules/identity-authorization/infrastructure/supabase/auth-admin-boundary.ts",
  import.meta.url,
);
const stateSourcePath = new URL(
  "../src/modules/identity-authorization/infrastructure/supabase/first-admin-auth-technical-password-state-source.ts",
  import.meta.url,
);
const serverPath = new URL(
  "../src/modules/identity-authorization/server.ts",
  import.meta.url,
);

function b1AdapterImplementation(): string {
  const source = readFileSync(adapterPath, "utf8");
  return source.slice(
    source.indexOf(
      "export function createSupabaseFirstAdminAuthProvisioningSource",
    ),
  );
}

describe("TASK-018 Work Item B1 first-admin Auth provisioning", () => {
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
    createClientMock.mockReturnValue({
      auth: { admin: { createUser: createUserMock } },
      rpc: rpcMock,
    });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("T018-B1-001 derives the technical password only from bridge identity and server config", () => {
    const config = passwordConfig("v2");
    const first = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v1",
      config,
    );
    const repeat = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v1",
      config,
    );
    const other = resolveFirstAdminTechnicalPassword(
      otherCredentialId,
      "v1",
      config,
    );

    expect(first).toBe(repeat);
    expect(first).not.toBe(other);
    expect(first.length).toBeGreaterThanOrEqual(6);
  });

  it("T018-B1-002 ignores caller-supplied technical password material", async () => {
    const { provisionVerifiedFirstAdminIdentity, service } = serviceFor({
      authUserId,
      outcome: "CREATED",
    });
    const input = {
      ...handoffContext,
      technicalPassword: "caller-password",
    } as FirstAdminAuthHandoffContext;

    await service.provision(input);
    expect(provisionVerifiedFirstAdminIdentity).toHaveBeenCalledWith({
      authoritativeEmail,
      technicalPassword,
    });
  });

  it("T018-B1-003 accepts no caller-selected technical key version", async () => {
    const { resolveTechnicalPassword, service } = serviceFor({
      authUserId,
      outcome: "CREATED",
    });
    const input = {
      ...handoffContext,
      technicalPasswordKeyVersion: "caller-v999",
    } as FirstAdminAuthHandoffContext;

    await service.provision(input);
    expect(resolveTechnicalPassword).toHaveBeenCalledWith(credentialId, "v1");
    expect(resolveTechnicalPassword).toHaveBeenCalledOnce();
  });

  it("T018-B1b-001 uses persisted v1 while application active version is v2", () => {
    const config = passwordConfig("v2");
    const persistedV1 = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v1",
      config,
    );
    const explicitV2 = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v2",
      config,
    );

    expect(persistedV1).not.toBe(explicitV2);
  });

  it("T018-B1b-002 changing only active version cannot change persisted-v1 reproduction", () => {
    const activeV2 = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v1",
      passwordConfig("v2"),
    );
    const activeV3 = resolveFirstAdminTechnicalPassword(
      credentialId,
      "v1",
      passwordConfig("v3"),
    );

    expect(activeV2).toBe(activeV3);
  });

  it("T018-B1b-003 derives the deterministic expected password from persisted v1", () => {
    expect(
      resolveFirstAdminTechnicalPassword(
        credentialId,
        "v1",
        passwordConfig("v2"),
      ),
    ).toBe("h9lMtGGfLIu96sj93u4eRqV7cCYT9Y114ptMnFTM9_g");
  });

  it("T018-B1b-004 different persisted versions select their respective key material", () => {
    const config = passwordConfig("v2");

    expect(
      resolveFirstAdminTechnicalPassword(credentialId, "v1", config),
    ).not.toBe(
      resolveFirstAdminTechnicalPassword(credentialId, "v2", config),
    );
  });

  it("T018-B1b-005 invokes only the approved B1a RPC with the bridge credential ID", async () => {
    rpcMock.mockResolvedValue({ data: readyState(), error: null });
    const source = createSupabaseFirstAdminAuthTechnicalPasswordStateSource();

    await expect(
      source.resolveTechnicalPasswordState(credentialId),
    ).resolves.toEqual(readyState());
    expect(rpcMock).toHaveBeenCalledOnce();
    expect(rpcMock).toHaveBeenCalledWith(
      "resolve_first_admin_auth_bridge_technical_password_state",
      { p_auth_bridge_credential_id: credentialId },
    );
    expect(Object.keys(source)).toEqual(["resolveTechnicalPasswordState"]);
  });

  it("T018-B1b-006 passes only the normalized bridge credential ID to its state source", async () => {
    const upperCredentialId = credentialId.toUpperCase();
    const { resolveTechnicalPasswordState, service } = serviceFor(
      { authUserId, outcome: "CREATED" },
      readyState("v1", upperCredentialId),
    );

    await service.provision({
      ...handoffContext,
      authBridgeCredentialId: upperCredentialId,
    });

    expect(resolveTechnicalPasswordState).toHaveBeenCalledOnce();
    expect(resolveTechnicalPasswordState).toHaveBeenCalledWith(credentialId);
  });

  it.each([
    ["zero rows", []],
    ["multiple rows", [...readyState(), ...readyState()]],
    ["non-array response", readyState()[0]],
    ["non-object row", [null]],
    ["unexpected field", [{ ...readyState()[0], unexpected: true }]],
    [
      "credential mismatch",
      readyState("v1", otherCredentialId),
    ],
    [
      "unknown rotation state",
      [
        {
          ...readyState()[0],
          rotation_state: "UNKNOWN",
        },
      ],
    ],
    [
      "READY with null version",
      [
        {
          ...readyState()[0],
          technical_password_key_version: null,
        },
      ],
    ],
    [
      "READY with malformed version",
      [
        {
          ...readyState()[0],
          technical_password_key_version: "bad version",
        },
      ],
    ],
    [
      "PENDING_ROTATION with non-null version",
      [
        {
          ...readyState()[0],
          rotation_state: "PENDING_ROTATION",
        },
      ],
    ],
    [
      "FAIL_CLOSED with non-null version",
      [
        {
          ...readyState()[0],
          rotation_state: "FAIL_CLOSED",
        },
      ],
    ],
  ])("T018-B1b-007 fails closed for malformed state: %s", async (_name, state) => {
    const { provisionVerifiedFirstAdminIdentity, resolveTechnicalPassword, service } =
      serviceFor({ authUserId, outcome: "CREATED" }, state);

    await expect(service.provision(handoffContext)).resolves.toEqual({
      outcome: "DEFINITE_FAILURE",
    });
    expect(resolveTechnicalPassword).not.toHaveBeenCalled();
    expect(provisionVerifiedFirstAdminIdentity).not.toHaveBeenCalled();
  });

  it.each(["PENDING_ROTATION", "FAIL_CLOSED"] as const)(
    "T018-B1b-008 fails closed for %s without deriving or creating",
    async (rotationState) => {
      const state = [
        {
          auth_bridge_credential_id: credentialId,
          rotation_state: rotationState,
          technical_password_key_version: null,
        },
      ];
      const {
        provisionVerifiedFirstAdminIdentity,
        resolveTechnicalPassword,
        service,
      } = serviceFor({ authUserId, outcome: "CREATED" }, state);

      await expect(service.provision(handoffContext)).resolves.toEqual({
        outcome: "DEFINITE_FAILURE",
      });
      expect(resolveTechnicalPassword).not.toHaveBeenCalled();
      expect(provisionVerifiedFirstAdminIdentity).not.toHaveBeenCalled();
    },
  );

  it("T018-B1b-009 fails closed on a technical-password state RPC error", async () => {
    const { provisionVerifiedFirstAdminIdentity, source } = sourceFor({
      authUserId,
      outcome: "CREATED",
    });
    const technicalPasswordStateSource: FirstAdminAuthTechnicalPasswordStateSource =
      Object.freeze({
        resolveTechnicalPasswordState: vi.fn(async () => {
          throw new Error("sensitive database detail");
        }),
      });
    const service = createFirstAdminAuthProvisioningService({
      createProvisioningSource: () => source,
      createTechnicalPasswordStateSource: () => technicalPasswordStateSource,
    });

    await expect(service.provision(handoffContext)).resolves.toEqual({
      outcome: "DEFINITE_FAILURE",
    });
    expect(provisionVerifiedFirstAdminIdentity).not.toHaveBeenCalled();
  });

  it("T018-B1b-010 fails closed when the persisted key version is unavailable", async () => {
    const { provisionVerifiedFirstAdminIdentity, source } = sourceFor({
      authUserId,
      outcome: "CREATED",
    });
    const { source: technicalPasswordStateSource } =
      technicalPasswordStateSourceFor(readyState("v999"));
    const service = createFirstAdminAuthProvisioningService({
      createProvisioningSource: () => source,
      createTechnicalPasswordStateSource: () => technicalPasswordStateSource,
    });

    await expect(service.provision(handoffContext)).resolves.toEqual({
      outcome: "DEFINITE_FAILURE",
    });
    expect(provisionVerifiedFirstAdminIdentity).not.toHaveBeenCalled();
  });

  it("T018-B1b-011 removes active-version selection and fallback from B1", () => {
    const implementation = readFileSync(servicePath, "utf8");

    expect(implementation).not.toContain("technicalPasswordActiveVersion");
    expect(implementation).toContain(
      "technicalPasswordState.technicalPasswordKeyVersion",
    );
  });

  it("T018-B1b-012 exposes no generic database or service-role capability", () => {
    const implementation = readFileSync(stateSourcePath, "utf8");

    expect(implementation).not.toMatch(/\.from\s*\(/);
    expect(implementation).not.toMatch(
      /export\s+(?:const|let|var)\s+(?:client|supabase)|export\s*\{[^}]*\b(?:client|supabase)\b|return\s+(?:client|supabase)\s*;/i,
    );
    expect(implementation.match(/client\.rpc\s*\(/g)).toHaveLength(1);
    expect(implementation).toContain(
      '"resolve_first_admin_auth_bridge_technical_password_state"',
    );
  });

  it("T018-B1b-013 does not log or return technical-password state internals", async () => {
    const implementation = `${readFileSync(servicePath, "utf8")}\n${readFileSync(
      stateSourcePath,
      "utf8",
    )}`;
    const { service } = serviceFor({ authUserId, outcome: "CREATED" });
    const result = await service.provision(handoffContext);

    expect(implementation).not.toMatch(/console\.|logger\.|\.log\s*\(/);
    expect(result).not.toHaveProperty("technicalPasswordKeyVersion");
    expect(result).not.toHaveProperty("rotationState");
    expect(JSON.stringify(result)).not.toContain(technicalPassword);
  });

  it("T018-B1-004 never returns the technical password", async () => {
    const { service } = serviceFor({ authUserId, outcome: "CREATED" });
    const result = await service.provision(handoffContext);

    expect(result).toEqual({ authUserId, outcome: "CREATED" });
    expect(JSON.stringify(result)).not.toContain(technicalPassword);
    expect(result).not.toHaveProperty("technicalPassword");
  });

  it("T018-B1-005 passes only the authoritative A2 target email to provisioning", async () => {
    const { provisionVerifiedFirstAdminIdentity, service } = serviceFor({
      authUserId,
      outcome: "CREATED",
    });

    await service.provision(handoffContext);
    expect(provisionVerifiedFirstAdminIdentity).toHaveBeenCalledWith({
      authoritativeEmail,
      technicalPassword,
    });
  });

  it("T018-B1-006 ignores an extra caller/browser email field", async () => {
    const { provisionVerifiedFirstAdminIdentity, service } = serviceFor({
      authUserId,
      outcome: "CREATED",
    });
    const input = {
      ...handoffContext,
      email: "attacker@example.invalid",
    } as FirstAdminAuthHandoffContext;

    await service.provision(input);
    expect(provisionVerifiedFirstAdminIdentity).toHaveBeenCalledWith(
      expect.objectContaining({ authoritativeEmail }),
    );
  });

  it("T018-B1-007 sends no tenant ID as Auth metadata", async () => {
    createUserMock.mockResolvedValue({
      data: { user: { id: authUserId } },
      error: null,
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty(
      "maintenance_company_id",
    );
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty("app_metadata");
  });

  it("T018-B1-008 sends no role as Auth metadata", async () => {
    createUserMock.mockResolvedValue({
      data: { user: { id: authUserId } },
      error: null,
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty("role");
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty("user_metadata");
  });

  it("T018-B1-009 sends no membership as Auth metadata", async () => {
    createUserMock.mockResolvedValue({
      data: { user: { id: authUserId } },
      error: null,
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty("membership");
    expect(createUserMock.mock.calls[0]?.[0]).not.toHaveProperty("metadata");
  });

  it("T018-B1-010 uses confirmed-email semantics and exact provider inputs", async () => {
    createUserMock.mockResolvedValue({
      data: { user: { id: authUserId } },
      error: null,
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });
    expect(createUserMock).toHaveBeenCalledWith({
      email: authoritativeEmail,
      email_confirm: true,
      password: technicalPassword,
    });
  });

  it("T018-B1-011 exports one semantic provisioning capability and no raw client", () => {
    const source = createSupabaseFirstAdminAuthProvisioningSource();
    expect(Object.keys(source)).toEqual(["provisionVerifiedFirstAdminIdentity"]);
    expect(source).not.toHaveProperty("auth");
    expect(source).not.toHaveProperty("client");
  });

  it("T018-B1-012 does not use listUsers", () => {
    expect(b1AdapterImplementation()).not.toContain("listUsers");
  });

  it("T018-B1-013 does not use updateUserById in the B1 capability", () => {
    expect(b1AdapterImplementation()).not.toContain("updateUserById");
  });

  it("T018-B1-014 uses no password reset, magic link, or OTP recovery", () => {
    const implementation = `${b1AdapterImplementation()}\n${readFileSync(servicePath, "utf8")}`;
    expect(implementation).not.toMatch(
      /resetPassword|magicLink|signInWithOtp|verifyOtp|generateLink|recovery/i,
    );
  });

  it("T018-B1-015 maps a confirmed create result to CREATED", async () => {
    createUserMock.mockResolvedValue({
      data: { user: { id: authUserId.toUpperCase() } },
      error: null,
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await expect(
      source.provisionVerifiedFirstAdminIdentity({
        authoritativeEmail,
        technicalPassword,
      }),
    ).resolves.toEqual({ authUserId, outcome: "CREATED" });
  });

  it("T018-B1-016 maps only stable duplicate codes to DUPLICATE_OR_CONFLICT", async () => {
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    for (const code of ["email_exists", "user_already_exists"]) {
      createUserMock.mockResolvedValueOnce({
        data: { user: null },
        error: { code, message: "sensitive provider detail", status: 422 },
      });
      await expect(
        source.provisionVerifiedFirstAdminIdentity({
          authoritativeEmail,
          technicalPassword,
        }),
      ).resolves.toEqual({ outcome: "DUPLICATE_OR_CONFLICT" });
    }
  });

  it("T018-B1-017 maps a known definite non-duplicate rejection to DEFINITE_FAILURE", async () => {
    createUserMock.mockResolvedValue({
      data: { user: null },
      error: {
        code: "validation_failed",
        message: "sensitive validation detail",
        status: 422,
      },
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    await expect(
      source.provisionVerifiedFirstAdminIdentity({
        authoritativeEmail,
        technicalPassword,
      }),
    ).resolves.toEqual({ outcome: "DEFINITE_FAILURE" });
  });

  it("T018-B1-018 treats thrown timeout/network failures as ambiguous", async () => {
    createUserMock.mockRejectedValue(
      new Error("timeout with sensitive provider endpoint"),
    );
    const source = createSupabaseFirstAdminAuthProvisioningSource();

    const result = await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });
    expect(result).toEqual({ outcome: "AMBIGUOUS_FAILURE" });
    expect(result.outcome).not.toMatch(/CREATED|DUPLICATE/);
  });

  it("T018-B1-019 maps unknown, server, and malformed provider results to ambiguity", async () => {
    const source = createSupabaseFirstAdminAuthProvisioningSource();
    const responses = [
      {
        data: { user: null },
        error: { code: "unexpected_failure", message: "detail", status: 500 },
      },
      { data: { user: null }, error: { message: "detail" } },
      { data: { user: null }, error: null },
    ];

    for (const response of responses) {
      createUserMock.mockResolvedValueOnce(response);
      await expect(
        source.provisionVerifiedFirstAdminIdentity({
          authoritativeEmail,
          technicalPassword,
        }),
      ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
    }
  });

  it("T018-B1-020 does not expose raw provider error details", async () => {
    const secretDetail = "provider-user-already-exists-for-secret@example.test";
    createUserMock.mockResolvedValue({
      data: { user: null },
      error: {
        code: "user_already_exists",
        message: secretDetail,
        status: 422,
      },
    });
    const source = createSupabaseFirstAdminAuthProvisioningSource();
    const result = await source.provisionVerifiedFirstAdminIdentity({
      authoritativeEmail,
      technicalPassword,
    });

    expect(JSON.stringify(result)).not.toContain(secretDetail);
    expect(result).toEqual({ outcome: "DUPLICATE_OR_CONFLICT" });
  });

  it("T018-B1-021 introduces no Auth metadata authority", () => {
    const implementation = b1AdapterImplementation();
    expect(implementation).not.toMatch(
      /app_metadata|user_metadata|maintenance_company|tenant|membership|client_scope|support_scope|commercial/i,
    );
  });

  it("T018-B1-022 introduces no direct table access", () => {
    const implementation = `${b1AdapterImplementation()}\n${readFileSync(servicePath, "utf8")}`;
    expect(implementation).not.toMatch(/(?:client|supabase)\.from\s*\(/);
  });

  it("T018-B1-023 does not consume or mutate SessionGrant", () => {
    const implementation = `${b1AdapterImplementation()}\n${readFileSync(servicePath, "utf8")}`;
    expect(implementation).not.toMatch(/session.?grant|consume.?grant/i);
  });

  it("T018-B1-024 does not orchestrate signInWithPassword", () => {
    const implementation = `${b1AdapterImplementation()}\n${readFileSync(servicePath, "utf8")}`;
    expect(implementation).not.toContain("signInWithPassword");
  });

  it("T018-B1-025 mutates no PlatformUser, CompanyMembership, or AuditEvent", () => {
    const implementation = `${b1AdapterImplementation()}\n${readFileSync(servicePath, "utf8")}`;
    expect(implementation).not.toMatch(
      /PlatformUser|CompanyMembership|AuditEvent|USER_CREATED/,
    );
  });

  it("T018-B1-026 keeps the privileged adapter out of client-safe modules", () => {
    const appRoot = fileURLToPath(new URL("../app", import.meta.url));
    const browserSource = readFileSync(
      new URL("../src/infrastructure/supabase/browser.ts", import.meta.url),
      "utf8",
    );
    const clientSafeCode = `${readCodeTree(appRoot)}\n${browserSource}`;

    expect(clientSafeCode).not.toMatch(
      /FirstAdminAuthProvisioning|first-admin-auth-provisioning|AuthProvisioningService|FirstAdminAuthTechnicalPasswordState|first-admin-auth-technical-password-state/,
    );
  });

  it("T018-B1-027 refuses createUser when the authoritative bridge is already bound", async () => {
    const { provisionVerifiedFirstAdminIdentity, service } = serviceFor({
      authUserId,
      outcome: "CREATED",
    });

    await expect(
      service.provision({ ...handoffContext, boundAuthUserId: authUserId }),
    ).resolves.toEqual({ outcome: "DEFINITE_FAILURE" });
    expect(provisionVerifiedFirstAdminIdentity).not.toHaveBeenCalled();
  });

  it("T018-B1-028 exports only the server service, not its secret-bearing source input", () => {
    const serverBoundary = readFileSync(serverPath, "utf8");
    expect(serverBoundary).toContain("getFirstAdminAuthProvisioningService");
    expect(serverBoundary).not.toContain(
      "FirstAdminAuthProvisioningSourceInput",
    );
    expect(serverBoundary).not.toContain(
      "createSupabaseFirstAdminAuthProvisioningSource",
    );
  });
});
