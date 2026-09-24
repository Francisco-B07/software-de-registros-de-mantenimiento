import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

import type { AuthSession } from "@supabase/supabase-js";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { createClientMock, signInWithPasswordMock } = vi.hoisted(() => ({
  createClientMock: vi.fn(),
  signInWithPasswordMock: vi.fn(),
}));

vi.mock("@supabase/supabase-js", () => ({
  createClient: createClientMock,
}));

import { createAuthSessionBridgeService } from "../src/modules/identity-authorization/application/auth-session-bridge-service";
import type { TechnicalSignInResult } from "../src/modules/identity-authorization/application/auth-session-bridge";
import { createSupabaseTechnicalSignInBoundary } from "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in";
import {
  preserveTechnicalSessionCandidate,
  readTechnicalSessionCandidate,
} from "../src/modules/identity-authorization/infrastructure/supabase/technical-session-candidate-server-vault";

const authUserId = "01800000-0000-4000-8000-000000000201";
const otherAuthUserId = "01800000-0000-4000-8000-000000000202";
const bridgeId = "01800000-0000-4000-8000-000000000203";
const email = "first-admin@example.invalid";
const technicalPassword = "synthetic-technical-password";
const accessToken = "synthetic-access-token";
const refreshToken = "synthetic-refresh-token";

function validSession(overrides: Record<string, unknown> = {}): AuthSession {
  return {
    access_token: accessToken,
    expires_at: 1_800_000_000,
    expires_in: 3600,
    refresh_token: refreshToken,
    token_type: "bearer",
    user: {
      app_metadata: {},
      aud: "authenticated",
      created_at: "2026-09-20T00:00:00.000Z",
      id: authUserId,
      user_metadata: {},
    },
    ...overrides,
  } as AuthSession;
}

function successfulResponse(session = validSession()) {
  return {
    data: { session, user: session.user },
    error: null,
  };
}

function authError(code: string | undefined, message: string) {
  return {
    data: { session: null, user: null },
    error: { code, message, name: "AuthApiError", status: 400 },
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

async function signInWith(response: unknown): Promise<TechnicalSignInResult> {
  signInWithPasswordMock.mockResolvedValueOnce(response);
  return createSupabaseTechnicalSignInBoundary().signIn({
    email,
    technicalPassword,
  });
}

function sessionResult(id = authUserId): TechnicalSignInResult {
  return Object.freeze({
    authUserId: id,
    outcome: "SESSION_CANDIDATE" as const,
    sessionCandidate: preserveTechnicalSessionCandidate(
      validSession({ user: { ...validSession().user, id } }),
    ),
  });
}

function legacyInput(authUserIdValue: string | null) {
  return {
    authBridgeCredentialId: bridgeId,
    authUserId: authUserIdValue,
    email,
    pendingKeyVersion: null,
    technicalPasswordKeyVersion: "v1",
  };
}

describe("TASK-018 Work Item B2a technical sign-in boundary", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", "https://project.example.invalid");
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY", "sb_publishable_fixture");
    vi.stubEnv("AUTH_CHALLENGE_HMAC_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_CHALLENGE_HMAC_KEY_V1",
      "challenge-secret-material-at-least-32-bytes",
    );
    vi.stubEnv("AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_TECHNICAL_PASSWORD_KEY_V1",
      "technical-secret-material-at-least-32-bytes",
    );
    vi.stubEnv("SUPABASE_SECRET_KEY", "sb_secret_test_fixture");
    createClientMock.mockReturnValue({
      auth: { signInWithPassword: signInWithPasswordMock },
    });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  it("T018-B2A-001 returns SESSION_CANDIDATE for a coherent response", async () => {
    await expect(signInWith(successfulResponse())).resolves.toMatchObject({
      authUserId,
      outcome: "SESSION_CANDIDATE",
    });
  });

  it("T018-B2A-002 obtains authUserId from the provider user subject", async () => {
    const result = await signInWith(successfulResponse());
    expect(result.outcome === "SESSION_CANDIDATE" && result.authUserId).toBe(
      authUserId,
    );
  });

  it("T018-B2A-003 preserves the exact provider session internally", async () => {
    const providerSession = validSession();
    const result = await signInWith(successfulResponse(providerSession));
    expect(result.outcome).toBe("SESSION_CANDIDATE");
    if (result.outcome === "SESSION_CANDIDATE") {
      expect(readTechnicalSessionCandidate(result.sessionCandidate)).toBe(
        providerSession,
      );
    }
  });

  it("T018-B2A-004 does not reduce success to authUserId only", async () => {
    const result = await signInWith(successfulResponse());
    expect(result).toHaveProperty("sessionCandidate");
  });

  it("T018-B2A-005 maps invalid_credentials to definite credential failure", async () => {
    await expect(
      signInWith(authError("invalid_credentials", "sanitized fixture")),
    ).resolves.toEqual({ outcome: "DEFINITE_CREDENTIAL_FAILURE" });
  });

  it("T018-B2A-006 does not infer user absence from invalid_credentials", async () => {
    const result = await signInWith(
      authError("invalid_credentials", "account may or may not exist"),
    );
    expect(result).toEqual({ outcome: "DEFINITE_CREDENTIAL_FAILURE" });
    expect(result).not.toHaveProperty("userAbsent");
  });

  it("T018-B2A-007 emits no create instruction for invalid_credentials", async () => {
    const result = await signInWith(
      authError("invalid_credentials", "wrong credential fixture"),
    );
    expect(result).not.toHaveProperty("createUser");
    expect(result).not.toHaveProperty("createRequired");
  });

  it("T018-B2A-008 maps a documented non-credential denial separately", async () => {
    await expect(
      signInWith(authError("email_not_confirmed", "provider fixture")),
    ).resolves.toEqual({ outcome: "AUTH_DENIED_OR_UNAVAILABLE" });
  });

  it("T018-B2A-009 maps an unknown Auth code conservatively", async () => {
    await expect(
      signInWith(authError("future_unknown_code", "provider fixture")),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-010 keeps unexpected_failure ambiguous", async () => {
    await expect(
      signInWith(authError("unexpected_failure", "hook or provider fixture")),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-011 ignores raw error messages during classification", async () => {
    const first = await signInWith(
      authError("invalid_credentials", "first arbitrary message"),
    );
    const second = await signInWith(
      authError("invalid_credentials", "contradictory arbitrary message"),
    );
    expect(first).toEqual(second);
  });

  it("T018-B2A-012 maps a thrown network exception to ambiguity", async () => {
    signInWithPasswordMock.mockRejectedValueOnce(new Error("network fixture"));
    await expect(
      createSupabaseTechnicalSignInBoundary().signIn({
        email,
        technicalPassword,
      }),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-013 maps a missing error code to ambiguity", async () => {
    await expect(
      signInWith(authError(undefined, "provider fixture")),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-014 rejects success without a user", async () => {
    await expect(
      signInWith({ data: { session: validSession(), user: null }, error: null }),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-015 rejects success without a session", async () => {
    await expect(
      signInWith({ data: { session: null, user: validSession().user }, error: null }),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-016 rejects an invalid provider user UUID", async () => {
    const session = validSession();
    await expect(
      signInWith({
        data: { session, user: { ...session.user, id: "not-a-uuid" } },
        error: null,
      }),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-017 rejects incoherent response/session subjects", async () => {
    const session = validSession({
      user: { ...validSession().user, id: otherAuthUserId },
    });
    await expect(
      signInWith({ data: { session, user: validSession().user }, error: null }),
    ).resolves.toEqual({ outcome: "AMBIGUOUS_FAILURE" });
  });

  it("T018-B2A-018 contains raw Auth errors", async () => {
    const result = await signInWith(
      authError("email_not_confirmed", "sensitive provider detail"),
    );
    expect(result).not.toHaveProperty("error");
    expect(result).not.toHaveProperty("message");
  });

  it("T018-B2A-019 does not expose provider messages", async () => {
    const result = await signInWith(
      authError("unexpected_failure", "sensitive hook detail"),
    );
    expect(JSON.stringify(result)).not.toContain("sensitive hook detail");
  });

  it("T018-B2A-020 keeps session tokens out of JSON serialization", async () => {
    const result = await signInWith(successfulResponse());
    const serialized = JSON.stringify(result);
    expect(serialized).not.toContain(accessToken);
    expect(serialized).not.toContain(refreshToken);
  });

  it("T018-B2A-021 does not log session or technical-password material", async () => {
    const log = vi.spyOn(console, "log").mockImplementation(() => undefined);
    const error = vi.spyOn(console, "error").mockImplementation(() => undefined);
    const warn = vi.spyOn(console, "warn").mockImplementation(() => undefined);
    await signInWith(successfulResponse());
    expect(log).not.toHaveBeenCalled();
    expect(error).not.toHaveBeenCalled();
    expect(warn).not.toHaveBeenCalled();
  });

  it("T018-B2A-022 configures no cookie-backed session persistence", async () => {
    await signInWith(successfulResponse());
    expect(createClientMock).toHaveBeenCalledWith(
      "https://project.example.invalid",
      "sb_publishable_fixture",
      {
        auth: {
          autoRefreshToken: false,
          detectSessionInUrl: false,
          persistSession: false,
        },
      },
    );
  });

  it("T018-B2A-023 keeps provider session storage out of the application contract", () => {
    const applicationSource = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/auth-session-bridge.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const serverSource = readFileSync(
      new URL("../src/modules/identity-authorization/server.ts", import.meta.url),
      "utf8",
    );

    expect(applicationSource).not.toMatch(
      /\bAuthSession\b|\bWeakMap\b|preserveTechnicalSessionCandidate|readTechnicalSessionCandidate/,
    );
    expect(serverSource).not.toContain("TechnicalSessionCandidate");
  });

  it("T018-B2A-024 uses the existing publishable nonprivileged client", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).toContain("publishableKey");
    expect(source).toContain("signInWithPassword");
    expect(source).not.toMatch(/SUPABASE_SECRET_KEY|auth\.admin/);
  });

  it("T018-B2A-025 does not use the TASK-011 cookie client", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).not.toMatch(/@supabase\/ssr|createServerClient|cookies\(|setAll/);
  });

  it("T018-B2A-026 performs no Auth Admin operation", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).not.toMatch(/auth\.admin|service[_-]?role|secret[_-]?key/i);
  });

  it("T018-B2A-027 performs no create/list/update operation", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).not.toMatch(/createUser|listUsers|updateUserById/);
  });

  it("T018-B2A-028 performs no DB/domain mutation", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/technical-sign-in.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).not.toMatch(
      /SessionGrant|PlatformUser|CompanyMembership|AuditEvent|\.rpc\(|\.from\(/,
    );
  });

  it("T018-B2A-029 treats hook timeouts as ambiguous", async () => {
    for (const code of ["hook_timeout", "hook_timeout_after_retry"]) {
      await expect(signInWith(authError(code, "hook timeout fixture"))).resolves.toEqual({
        outcome: "AMBIGUOUS_FAILURE",
      });
    }
  });

  it("T018-B2A-030 rejects missing required token material", async () => {
    for (const session of [
      validSession({ access_token: "" }),
      validSession({ access_token: " " }),
      validSession({ refresh_token: "" }),
      validSession({ expires_in: 0 }),
      validSession({ token_type: "unexpected" }),
    ]) {
      await expect(signInWith(successfulResponse(session))).resolves.toEqual({
        outcome: "AMBIGUOUS_FAILURE",
      });
    }
  });

  it("T018-B2A-031 keeps a valid opaque candidate non-enumerable", async () => {
    const result = await signInWith(successfulResponse());
    expect(result.outcome).toBe("SESSION_CANDIDATE");
    if (result.outcome === "SESSION_CANDIDATE") {
      expect(Object.keys(result.sessionCandidate)).toEqual([]);
      expect(JSON.stringify(result.sessionCandidate)).toBe("{}");
    }
  });

  it("T018-B2A-032 rejects forged session-candidate handles", () => {
    expect(() =>
      readTechnicalSessionCandidate(
        Object.freeze({}) as Parameters<typeof readTechnicalSessionCandidate>[0],
      ),
    ).toThrow("Authentication bridge operation denied.");
  });

  it("T018-B2A-033 preserves legacy bound-caller success semantics", async () => {
    const createVerifiedEmailUser = vi.fn();
    const service = createAuthSessionBridgeService(
      {
        createVerifiedEmailUser,
        updateTechnicalPassword: vi.fn(),
      },
      { signIn: vi.fn(async () => sessionResult()) },
    );

    await expect(
      service.establishTechnicalIdentity(legacyInput(authUserId)),
    ).resolves.toEqual({ authUserId });
    expect(createVerifiedEmailUser).not.toHaveBeenCalled();
  });

  it("T018-B2A-034 preserves legacy unbound reconciliation success semantics", async () => {
    const createVerifiedEmailUser = vi.fn();
    const service = createAuthSessionBridgeService(
      {
        createVerifiedEmailUser,
        updateTechnicalPassword: vi.fn(),
      },
      { signIn: vi.fn(async () => sessionResult()) },
    );

    await expect(
      service.establishTechnicalIdentity(legacyInput(null)),
    ).resolves.toEqual({ authUserId });
    expect(createVerifiedEmailUser).not.toHaveBeenCalled();
  });

  it("T018-B2A-035 permits the legacy create path only after definite credential failure", async () => {
    const createVerifiedEmailUser = vi.fn(async () => ({ authUserId }));
    const signIn = vi
      .fn()
      .mockResolvedValueOnce({ outcome: "DEFINITE_CREDENTIAL_FAILURE" })
      .mockResolvedValueOnce(sessionResult());
    const service = createAuthSessionBridgeService(
      { createVerifiedEmailUser, updateTechnicalPassword: vi.fn() },
      { signIn },
    );

    await expect(
      service.establishTechnicalIdentity(legacyInput(null)),
    ).resolves.toEqual({ authUserId });
    expect(createVerifiedEmailUser).toHaveBeenCalledOnce();
    expect(signIn).toHaveBeenCalledTimes(2);
  });

  it("T018-B2A-036 prevents legacy create on ambiguous or denied outcomes", async () => {
    for (const outcome of [
      "AMBIGUOUS_FAILURE",
      "AUTH_DENIED_OR_UNAVAILABLE",
    ] as const) {
      const createVerifiedEmailUser = vi.fn();
      const service = createAuthSessionBridgeService(
        { createVerifiedEmailUser, updateTechnicalPassword: vi.fn() },
        { signIn: vi.fn(async () => ({ outcome })) },
      );

      await expect(
        service.establishTechnicalIdentity(legacyInput(null)),
      ).rejects.toThrow("Authentication bridge operation denied.");
      expect(createVerifiedEmailUser).not.toHaveBeenCalled();
    }
  });

  it("T018-B2A-037 prohibits the session vault from client-safe imports", () => {
    const appRoot = fileURLToPath(new URL("../app", import.meta.url));
    const browserSource = readFileSync(
      new URL("../src/infrastructure/supabase/browser.ts", import.meta.url),
      "utf8",
    );
    const clientSafeCode = `${readCodeTree(appRoot)}\n${browserSource}`;

    expect(clientSafeCode).not.toMatch(
      /technical-session-candidate-server-vault|readTechnicalSessionCandidate|preserveTechnicalSessionCandidate|\bAuthSession\b|\bWeakMap\b/,
    );
  });
});
