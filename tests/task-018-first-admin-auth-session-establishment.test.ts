import { readFileSync } from "node:fs";

import type { AuthSession } from "@supabase/supabase-js";
import { beforeEach, describe, expect, it, vi } from "vitest";

const { createSupabaseServerClientMock } = vi.hoisted(() => ({
  createSupabaseServerClientMock: vi.fn(),
}));

vi.mock("../src/infrastructure/supabase/server", () => ({
  createSupabaseServerClient: createSupabaseServerClientMock,
}));

import type { TechnicalSessionCandidate } from "../src/modules/identity-authorization/application/auth-session-bridge";
import type { FirstAdminAuthIdentityReconciliationResult } from "../src/modules/identity-authorization/application/first-admin-auth-identity-reconciliation-service";
import { createFirstAdminAuthSessionEstablishmentService } from "../src/modules/identity-authorization/application/first-admin-auth-session-establishment-service";
import type { FirstAdminPostSignInAuthHandoffCorrelationResult } from "../src/modules/identity-authorization/application/first-admin-onboarding";
import { createSupabaseFirstAdminAuthSessionDeliveryBoundary } from "../src/modules/identity-authorization/infrastructure/supabase/first-admin-auth-session-delivery";
import { preserveTechnicalSessionCandidate } from "../src/modules/identity-authorization/infrastructure/supabase/technical-session-candidate-server-vault";

const intentId = "10000000-0000-4000-8000-000000000001";
const authUserId = "20000000-0000-4000-8000-000000000002";
const otherAuthUserId = "30000000-0000-4000-8000-000000000003";
const companyId = "40000000-0000-4000-8000-000000000004";
const challengeId = "50000000-0000-4000-8000-000000000005";
const grantId = "60000000-0000-4000-8000-000000000006";
const credentialId = "70000000-0000-4000-8000-000000000007";

function opaqueCandidate(): TechnicalSessionCandidate {
  return Object.freeze({}) as TechnicalSessionCandidate;
}

function candidateResult(
  candidate = opaqueCandidate(),
): FirstAdminAuthIdentityReconciliationResult {
  return Object.freeze({
    authUserId,
    intentId,
    outcome: "SESSION_CANDIDATE",
    sessionCandidate: candidate,
  });
}

function correlated(
  overrides: Partial<
    Extract<
      FirstAdminPostSignInAuthHandoffCorrelationResult,
      { outcome: "CORRELATED_CONSUMED" }
    >
  > = {},
): FirstAdminPostSignInAuthHandoffCorrelationResult {
  return Object.freeze({
    authBridgeCredentialId: credentialId,
    bridgeAuthUserId: authUserId,
    currentChallengeId: challengeId,
    grantAuthUserId: authUserId,
    handoffSessionGrantId: grantId,
    identityCompatibility: "NO_APPLICATION_IDENTITY",
    intentId,
    maintenanceCompanyId: companyId,
    outcome: "CORRELATED_CONSUMED",
    targetEmail: "first-admin@example.invalid",
    ...overrides,
  });
}

const unusedCookieMethods = Object.freeze({
  getAll: vi.fn(() => []),
  setAll: vi.fn(),
});

function orchestrationHarness(
  options: Readonly<{
    candidateDelivery?:
      | "SESSION_ESTABLISHED"
      | "AUTH_SESSION_DELIVERY_FAILED"
      | "RETRYABLE_FAILURE"
      | "SECURITY_CORRELATION_FAILURE";
    commit?: "COMMITTED" | "FAILED";
    guard?: FirstAdminPostSignInAuthHandoffCorrelationResult;
    inspection?:
      | Readonly<{
          commit: () => Promise<"COMMITTED" | "FAILED">;
          outcome: "VALIDATED";
          subject: string;
        }>
      | Readonly<{ outcome: "NO_VALID_SESSION" }>
      | Readonly<{ outcome: "RETRYABLE_FAILURE" }>;
    reconciliation?: FirstAdminAuthIdentityReconciliationResult;
  }> = {},
) {
  const reconciliation =
    options.reconciliation ?? candidateResult();
  const guard = options.guard ?? correlated();
  const commit = vi.fn(async () => options.commit ?? "COMMITTED");
  const inspection =
    options.inspection ??
    Object.freeze({ outcome: "NO_VALID_SESSION" as const });
  const reconcile = vi.fn(async () => reconciliation);
  const resolvePostSignInAuthHandoffCorrelation = vi.fn(async () => guard);
  const establishCandidate = vi.fn(async () =>
    Object.freeze({ outcome: options.candidateDelivery ?? "SESSION_ESTABLISHED" }),
  );
  const inspectExistingSession = vi.fn(async () =>
    inspection.outcome === "VALIDATED"
      ? inspection
      : inspection,
  );
  const service = createFirstAdminAuthSessionEstablishmentService(
    unusedCookieMethods,
    {
      handoffService: { resolvePostSignInAuthHandoffCorrelation },
      reconciliationService: { reconcile },
      sessionDeliveryBoundary: {
        establishCandidate,
        inspectExistingSession,
      },
    },
  );

  return {
    commit,
    establishCandidate,
    inspectExistingSession,
    reconcile,
    resolvePostSignInAuthHandoffCorrelation,
    service,
  };
}

function existingInspection(subject = authUserId) {
  const commit = vi.fn(async () => "COMMITTED" as const);
  return {
    commit,
    inspection: Object.freeze({
      commit,
      outcome: "VALIDATED" as const,
      subject,
    }),
  };
}

function providerSession(
  overrides: Readonly<Record<string, unknown>> = {},
): AuthSession {
  return {
    access_token: "provider-access-token",
    expires_at: Math.floor(Date.now() / 1000) + 3600,
    expires_in: 3600,
    refresh_token: "provider-refresh-token",
    token_type: "bearer",
    user: { id: authUserId },
    ...overrides,
  } as AuthSession;
}

function deliveryHarness(
  options: Readonly<{
    adoptionError?: unknown;
    adoptionSessionSubject?: string;
    adoptionUserSubject?: string;
    claimsError?: unknown;
    claimsSubject?: string | null;
    emitClaimsCookies?: boolean;
    emitCookies?: boolean;
    setAllThrows?: boolean;
  }> = {},
) {
  const cookieOptions = Object.freeze({
    httpOnly: true,
    path: "/",
    sameSite: "lax" as const,
    secure: true,
  });
  const antiCacheHeaders = Object.freeze({
    "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
    Expires: "0",
    Pragma: "no-cache",
  });
  const committedSetAll = vi.fn(async () => {
    if (options.setAllThrows) {
      throw new Error("cookie sink failed with sensitive material");
    }
  });
  const requestCookies = Object.freeze({
    getAll: vi.fn(() => [{ name: "request-cookie", value: "request-value" }]),
    setAll: committedSetAll,
  });
  const setSession = vi.fn(async () => {
    const cookieMethods = createSupabaseServerClientMock.mock.calls.at(-1)?.[0];
    if (options.emitCookies !== false) {
      cookieMethods.setAll(
        [
          {
            name: "sb-auth-token",
            options: cookieOptions,
            value: "sdk-encoded-cookie",
          },
        ],
        antiCacheHeaders,
      );
    }
    if (options.adoptionError) {
      return {
        data: { session: null, user: null },
        error: options.adoptionError,
      };
    }
    const user = { id: options.adoptionUserSubject ?? authUserId };
    return {
      data: {
        session: {
          ...providerSession(),
          user: { id: options.adoptionSessionSubject ?? authUserId },
        },
        user,
      },
      error: null,
    };
  });
  const getClaims = vi.fn(async () => {
    if (options.emitClaimsCookies) {
      const cookieMethods = createSupabaseServerClientMock.mock.calls.at(-1)?.[0];
      cookieMethods.setAll(
        [
          {
            name: "sb-auth-token",
            options: cookieOptions,
            value: "sdk-encoded-cookie",
          },
        ],
        antiCacheHeaders,
      );
    }
    return {
      data:
        options.claimsSubject === null
          ? null
          : { claims: { sub: options.claimsSubject ?? authUserId } },
      error: options.claimsError ?? null,
    };
  });
  createSupabaseServerClientMock.mockResolvedValue({
    auth: { getClaims, setSession },
  });

  return {
    antiCacheHeaders,
    boundary: createSupabaseFirstAdminAuthSessionDeliveryBoundary(
      requestCookies,
    ),
    committedSetAll,
    cookieOptions,
    getClaims,
    requestCookies,
    setSession,
  };
}

describe("TASK-018 Work Item C orchestration", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("T018-C-001 delivers a B candidate only after the repeated final guard", async () => {
    const order: string[] = [];
    const reconciliation = vi.fn(async () => {
      order.push("B");
      return candidateResult();
    });
    const guard = vi.fn(async () => {
      order.push("GUARD");
      return correlated();
    });
    const delivery = vi.fn(async () => {
      order.push("DELIVERY");
      return { outcome: "SESSION_ESTABLISHED" as const };
    });
    const service = createFirstAdminAuthSessionEstablishmentService(
      unusedCookieMethods,
      {
        handoffService: { resolvePostSignInAuthHandoffCorrelation: guard },
        reconciliationService: { reconcile: reconciliation },
        sessionDeliveryBoundary: {
          establishCandidate: delivery,
          inspectExistingSession: vi.fn(),
        },
      },
    );

    await expect(service.establish(intentId)).resolves.toEqual({
      outcome: "SESSION_ESTABLISHED",
    });
    expect(order).toEqual(["B", "GUARD", "DELIVERY"]);
  });

  it("T018-C-002 never invokes existing-session inspection for a new candidate", async () => {
    const harness = orchestrationHarness();
    await harness.service.establish(intentId);
    expect(harness.inspectExistingSession).not.toHaveBeenCalled();
    expect(harness.establishCandidate).toHaveBeenCalledOnce();
  });

  it.each([
    ["NOT_CONSUMED", "SECURITY_CORRELATION_FAILURE"],
    ["IDENTITY_INCOMPATIBLE", "IDENTITY_INCOMPATIBLE"],
    ["SECURITY_CORRELATION_FAILURE", "SECURITY_CORRELATION_FAILURE"],
    ["INFRASTRUCTURE_FAILURE", "RETRYABLE_FAILURE"],
  ] as const)(
    "T018-C-003..006 maps final %s and performs zero delivery",
    async (guardOutcome, expected) => {
      const harness = orchestrationHarness({
        guard: { outcome: guardOutcome },
      });
      await expect(harness.service.establish(intentId)).resolves.toEqual({
        outcome: expected,
      });
      expect(harness.establishCandidate).not.toHaveBeenCalled();
    },
  );

  it.each([
    ["bridge", { bridgeAuthUserId: otherAuthUserId }],
    ["grant", { grantAuthUserId: otherAuthUserId }],
    ["intent", { intentId: "80000000-0000-4000-8000-000000000008" }],
  ] as const)(
    "T018-C-007..009 fails closed on final %s correlation drift",
    async (_name, overrides) => {
      const harness = orchestrationHarness({ guard: correlated(overrides) });
      await expect(harness.service.establish(intentId)).resolves.toEqual({
        outcome: "SECURITY_CORRELATION_FAILURE",
      });
      expect(harness.establishCandidate).not.toHaveBeenCalled();
    },
  );

  it.each([
    "AUTH_SESSION_DELIVERY_FAILED",
    "RETRYABLE_FAILURE",
    "SECURITY_CORRELATION_FAILURE",
  ] as const)("T018-C-010..012 preserves bounded delivery outcome %s", async (outcome) => {
    const harness = orchestrationHarness({ candidateDelivery: outcome });
    await expect(harness.service.establish(intentId)).resolves.toEqual({ outcome });
  });

  it("T018-C-013 reconciles an already delivered matching session idempotently", async () => {
    const { commit, inspection } = existingInspection();
    const harness = orchestrationHarness({
      inspection,
      reconciliation: { outcome: "NOT_ELIGIBLE" },
    });
    await expect(harness.service.establish(intentId)).resolves.toEqual({
      outcome: "SESSION_ALREADY_ESTABLISHED",
    });
    expect(commit).toHaveBeenCalledOnce();
    expect(harness.establishCandidate).not.toHaveBeenCalled();
  });

  it("T018-C-014 requires current correlation before committing an existing refresh", async () => {
    const order: string[] = [];
    const inspection = {
      commit: vi.fn(async () => {
        order.push("COMMIT");
        return "COMMITTED" as const;
      }),
      outcome: "VALIDATED" as const,
      subject: authUserId,
    };
    const guard = vi.fn(async () => {
      order.push("GUARD");
      return correlated();
    });
    const service = createFirstAdminAuthSessionEstablishmentService(
      unusedCookieMethods,
      {
        handoffService: { resolvePostSignInAuthHandoffCorrelation: guard },
        reconciliationService: {
          reconcile: vi.fn(async () => ({ outcome: "NOT_ELIGIBLE" as const })),
        },
        sessionDeliveryBoundary: {
          establishCandidate: vi.fn(),
          inspectExistingSession: vi.fn(async () => inspection),
        },
      },
    );
    await service.establish(intentId);
    expect(order).toEqual(["GUARD", "COMMIT"]);
  });

  it("T018-C-015 returns recovery-required for consumed handoff without a valid browser session", async () => {
    const harness = orchestrationHarness({
      inspection: { outcome: "NO_VALID_SESSION" },
      reconciliation: { outcome: "NOT_ELIGIBLE" },
    });
    await expect(harness.service.establish(intentId)).resolves.toEqual({
      outcome: "SESSION_RECOVERY_REQUIRED",
    });
    expect(harness.resolvePostSignInAuthHandoffCorrelation).not.toHaveBeenCalled();
  });

  it("T018-C-016 fails closed for an unrelated existing browser subject", async () => {
    const { commit, inspection } = existingInspection(otherAuthUserId);
    const harness = orchestrationHarness({
      inspection,
      reconciliation: { outcome: "NOT_ELIGIBLE" },
    });
    await expect(harness.service.establish(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(commit).not.toHaveBeenCalled();
  });

  it("T018-C-017 fails closed when existing-session validation is unavailable", async () => {
    const harness = orchestrationHarness({
      inspection: { outcome: "RETRYABLE_FAILURE" },
      reconciliation: { outcome: "NOT_ELIGIBLE" },
    });
    await expect(harness.service.establish(intentId)).resolves.toEqual({
      outcome: "RETRYABLE_FAILURE",
    });
  });

  it.each([
    ["NOT_CONSUMED", "SECURITY_CORRELATION_FAILURE"],
    ["IDENTITY_INCOMPATIBLE", "IDENTITY_INCOMPATIBLE"],
  ] as const)(
    "T018-C-018..019 rejects idempotent session when current guard is %s",
    async (guardOutcome, expected) => {
      const { commit, inspection } = existingInspection();
      const harness = orchestrationHarness({
        guard: { outcome: guardOutcome },
        inspection,
        reconciliation: { outcome: "NOT_ELIGIBLE" },
      });
      await expect(harness.service.establish(intentId)).resolves.toEqual({
        outcome: expected,
      });
      expect(commit).not.toHaveBeenCalled();
    },
  );

  it("T018-C-020 bounds an existing-session cookie commit failure", async () => {
    const inspection = Object.freeze({
      commit: vi.fn(async () => "FAILED" as const),
      outcome: "VALIDATED" as const,
      subject: authUserId,
    });
    const harness = orchestrationHarness({
      inspection,
      reconciliation: { outcome: "NOT_ELIGIBLE" },
    });
    await expect(harness.service.establish(intentId)).resolves.toEqual({
      outcome: "AUTH_SESSION_DELIVERY_FAILED",
    });
  });

  it.each([
    ["IDENTITY_INCOMPATIBLE", "IDENTITY_INCOMPATIBLE"],
    ["SECURITY_CORRELATION_FAILURE", "SECURITY_CORRELATION_FAILURE"],
    ["RETRYABLE_FAILURE", "RETRYABLE_FAILURE"],
    ["AUTH_DENIED_OR_UNAVAILABLE", "AUTH_SESSION_DELIVERY_FAILED"],
    ["REPAIR_REQUIRED", "AUTH_SESSION_DELIVERY_FAILED"],
  ] as const)("T018-C-021..025 maps B failure %s without session side effects", async (b, c) => {
    const harness = orchestrationHarness({ reconciliation: { outcome: b } });
    await expect(harness.service.establish(intentId)).resolves.toEqual({ outcome: c });
    expect(harness.establishCandidate).not.toHaveBeenCalled();
    expect(harness.inspectExistingSession).not.toHaveBeenCalled();
  });

  it("T018-C-026 rejects a malformed intent before B or cookie work", async () => {
    const harness = orchestrationHarness();
    await expect(harness.service.establish("not-an-intent")).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(harness.reconcile).not.toHaveBeenCalled();
    expect(harness.establishCandidate).not.toHaveBeenCalled();
  });
});

describe("TASK-018 Work Item C server-only SSR delivery boundary", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("T018-C-027 adopts the candidate with setSession and never signs in again", async () => {
    const harness = deliveryHarness();
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "SESSION_ESTABLISHED" });
    expect(harness.setSession).toHaveBeenCalledWith({
      access_token: "provider-access-token",
      refresh_token: "provider-refresh-token",
    });
    expect(harness.getClaims).toHaveBeenCalledOnce();
  });

  it("T018-C-028 rejects a forged candidate before SSR client creation", async () => {
    const harness = deliveryHarness();
    await expect(
      harness.boundary.establishCandidate(opaqueCandidate(), authUserId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
    expect(createSupabaseServerClientMock).not.toHaveBeenCalled();
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it.each([
    ["subject", providerSession({ user: { id: otherAuthUserId } })],
    ["access", providerSession({ access_token: "" })],
    ["refresh", providerSession({ refresh_token: "" })],
    ["token type", providerSession({ token_type: "unexpected" })],
  ])("T018-C-029..032 rejects invalid recovered session %s with zero cookie commit", async (_name, session) => {
    const harness = deliveryHarness();
    const candidate = preserveTechnicalSessionCandidate(session as AuthSession);
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it("T018-C-033 discards buffered cookies on adoption error", async () => {
    const harness = deliveryHarness({ adoptionError: new Error("denied") });
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "AUTH_SESSION_DELIVERY_FAILED" });
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it.each([
    ["returned user", { adoptionUserSubject: otherAuthUserId }],
    ["returned session", { adoptionSessionSubject: otherAuthUserId }],
    ["validated claims", { claimsSubject: otherAuthUserId }],
  ])("T018-C-034..036 discards buffered cookies on %s mismatch", async (_name, options) => {
    const harness = deliveryHarness(options);
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it("T018-C-037 commits SDK cookies once with exact options and anti-cache headers", async () => {
    const harness = deliveryHarness();
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await harness.boundary.establishCandidate(candidate, authUserId);
    expect(harness.committedSetAll).toHaveBeenCalledOnce();
    expect(harness.committedSetAll).toHaveBeenCalledWith(
      [
        {
          name: "sb-auth-token",
          options: harness.cookieOptions,
          value: "sdk-encoded-cookie",
        },
      ],
      harness.antiCacheHeaders,
    );
  });

  it("T018-C-038 fails closed if the SDK emits no delivery mutation", async () => {
    const harness = deliveryHarness({ emitCookies: false });
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "AUTH_SESSION_DELIVERY_FAILED" });
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it("T018-C-039 bounds actual cookie-sink failure without retrying commitment", async () => {
    const harness = deliveryHarness({ setAllThrows: true });
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    await expect(
      harness.boundary.establishCandidate(candidate, authUserId),
    ).resolves.toEqual({ outcome: "AUTH_SESSION_DELIVERY_FAILED" });
    expect(harness.committedSetAll).toHaveBeenCalledOnce();
  });

  it("T018-C-040 validates existing identity with getClaims and buffers normal refresh", async () => {
    const harness = deliveryHarness({ emitClaimsCookies: true });
    const inspection = await harness.boundary.inspectExistingSession();
    expect(inspection.outcome).toBe("VALIDATED");
    expect(harness.committedSetAll).not.toHaveBeenCalled();
    if (inspection.outcome === "VALIDATED") {
      await expect(inspection.commit()).resolves.toBe("COMMITTED");
    }
    expect(harness.committedSetAll).toHaveBeenCalledOnce();
  });

  it("T018-C-041 treats absent or invalid claims as no valid browser session", async () => {
    const harness = deliveryHarness({ claimsSubject: null });
    await expect(harness.boundary.inspectExistingSession()).resolves.toEqual({
      outcome: "NO_VALID_SESSION",
    });
    expect(harness.committedSetAll).not.toHaveBeenCalled();
  });

  it("T018-C-042 bounds thrown existing-session validation failures", async () => {
    createSupabaseServerClientMock.mockRejectedValue(new Error("unavailable"));
    const boundary = createSupabaseFirstAdminAuthSessionDeliveryBoundary({
      getAll: vi.fn(() => []),
      setAll: vi.fn(),
    });
    await expect(boundary.inspectExistingSession()).resolves.toEqual({
      outcome: "RETRYABLE_FAILURE",
    });
  });

  it("T018-C-043 keeps response/result surfaces bounded and free of session material", async () => {
    const harness = deliveryHarness();
    const candidate = preserveTechnicalSessionCandidate(providerSession());
    const delivered = await harness.boundary.establishCandidate(
      candidate,
      authUserId,
    );
    const serialized = JSON.stringify(delivered);
    expect(Object.keys(delivered)).toEqual(["outcome"]);
    expect(serialized).not.toMatch(/access|refresh|token|password|cookie|role|membership/i);
  });

  it("T018-C-044 confines raw session access to the dedicated server-only adapter", () => {
    const application = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-auth-session-establishment-service.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const adapter = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/first-admin-auth-session-delivery.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(application).not.toMatch(/access_token|refresh_token|\bAuthSession\b/);
    expect(adapter).toContain("readTechnicalSessionCandidate");
    expect(adapter).toContain("auth.setSession");
  });

  it("T018-C-045 trusts getClaims, never getSession, and creates no authority", () => {
    const files = [
      "../src/modules/identity-authorization/application/first-admin-auth-session-establishment-service.ts",
      "../src/modules/identity-authorization/infrastructure/supabase/first-admin-auth-session-delivery.ts",
    ];
    const source = files
      .map((file) => readFileSync(new URL(file, import.meta.url), "utf8"))
      .join("\n");
    expect(source).toContain("auth.getClaims()");
    expect(source).not.toMatch(/getSession\s*\(/);
    expect(source).not.toMatch(
      /signInWithPassword|createUser|updateUserById|auth\.admin|service[_-]?role/i,
    );
    expect(source).not.toMatch(
      /SessionGrant|PlatformUser|CompanyMembership|AuditEvent|\.rpc\s*\(|\.from\s*\(/,
    );
  });
});
