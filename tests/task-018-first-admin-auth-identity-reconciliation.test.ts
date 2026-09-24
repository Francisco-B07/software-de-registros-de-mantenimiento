import { readFileSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import type {
  TechnicalSessionCandidate,
  TechnicalSignInResult,
} from "../src/modules/identity-authorization/application/auth-session-bridge";
import { createFirstAdminAuthIdentityReconciliationService } from "../src/modules/identity-authorization/application/first-admin-auth-identity-reconciliation-service";
import type {
  FirstAdminAuthHandoffContext,
  FirstAdminAuthHandoffResult,
  FirstAdminAuthProvisioningResult,
  FirstAdminPostSignInAuthHandoffCorrelationResult,
} from "../src/modules/identity-authorization/application/first-admin-onboarding";

const intentId = "01820000-0000-4000-8000-000000000001";
const companyId = "01820000-0000-4000-8000-000000000002";
const challengeId = "01820000-0000-4000-8000-000000000003";
const grantId = "01820000-0000-4000-8000-000000000004";
const credentialId = "01820000-0000-4000-8000-000000000005";
const authUserId = "01820000-0000-4000-8000-000000000006";
const otherAuthUserId = "01820000-0000-4000-8000-000000000007";
const otherId = "01820000-0000-4000-8000-000000000008";
const authoritativeEmail = "first-admin@example.invalid";
const technicalPassword = "server-derived-technical-password";

function candidate(): TechnicalSessionCandidate {
  return Object.freeze({}) as TechnicalSessionCandidate;
}

function context(
  overrides: Partial<FirstAdminAuthHandoffContext> = {},
): FirstAdminAuthHandoffContext {
  return Object.freeze({
    authBridgeCredentialId: credentialId,
    boundAuthUserId: null,
    currentChallengeId: challengeId,
    handoffSessionGrantId: grantId,
    identityCompatibility: "NO_APPLICATION_IDENTITY",
    intentId,
    maintenanceCompanyId: companyId,
    targetEmail: authoritativeEmail,
    ...overrides,
  });
}

function eligible(
  overrides: Partial<FirstAdminAuthHandoffContext> = {},
): FirstAdminAuthHandoffResult {
  return Object.freeze({ context: context(overrides), outcome: "ELIGIBLE" });
}

function session(
  authUserIdValue = authUserId,
  sessionCandidate = candidate(),
): TechnicalSignInResult {
  return Object.freeze({
    authUserId: authUserIdValue,
    outcome: "SESSION_CANDIDATE",
    sessionCandidate,
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
    targetEmail: authoritativeEmail,
    ...overrides,
  });
}

type HarnessOptions = Readonly<{
  handoffResults?: readonly FirstAdminAuthHandoffResult[];
  passwordResults?: readonly (
    | Readonly<{ outcome: "READY"; technicalPassword: string }>
    | Readonly<{ outcome: "UNAVAILABLE" }>
  )[];
  postResult?: FirstAdminPostSignInAuthHandoffCorrelationResult;
  provisioningResult?: FirstAdminAuthProvisioningResult;
  signInResults?: readonly TechnicalSignInResult[];
}>;

function harness(options: HarnessOptions = {}) {
  const handoffResults = options.handoffResults ?? [eligible()];
  const passwordResults = options.passwordResults ?? [
    { outcome: "READY", technicalPassword },
  ];
  const signInResults = options.signInResults ?? [session()];
  let handoffIndex = 0;
  let passwordIndex = 0;
  let signInIndex = 0;
  const resolve = vi.fn(async () =>
    handoffResults[Math.min(handoffIndex++, handoffResults.length - 1)],
  );
  const resolvePostSignInAuthHandoffCorrelation = vi.fn(
    async () => options.postResult ?? correlated(),
  );
  const resolveTechnicalPassword = vi.fn(async () =>
    passwordResults[Math.min(passwordIndex++, passwordResults.length - 1)],
  );
  const signIn = vi.fn(async () =>
    signInResults[Math.min(signInIndex++, signInResults.length - 1)],
  );
  const provision = vi.fn(
    async () =>
      options.provisioningResult ??
      ({ authUserId, outcome: "CREATED" } as const),
  );

  return {
    provision,
    resolve,
    resolvePostSignInAuthHandoffCorrelation,
    resolveTechnicalPassword,
    service: createFirstAdminAuthIdentityReconciliationService({
      handoffService: {
        resolve,
        resolvePostSignInAuthHandoffCorrelation,
      },
      provisioningService: { provision },
      signInBoundary: { signIn },
      technicalPasswordService: { resolve: resolveTechnicalPassword },
    }),
    signIn,
  };
}

describe("TASK-018 Work Item B2 reconciliation-first orchestration", () => {
  it("T018-B2-001 rejects non-UUID input before any capability call", async () => {
    const fixture = harness();

    await expect(fixture.service.reconcile("invalid")).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(fixture.resolve).not.toHaveBeenCalled();
    expect(fixture.signIn).not.toHaveBeenCalled();
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it.each([
    ["expired", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_EXPIRED" }],
    ["revoked", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_REVOKED" }],
    ["consumed", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_CONSUMED" }],
    ["incompatible", { outcome: "IDENTITY_INCOMPATIBLE" }],
    ["security failure", { outcome: "SECURITY_CORRELATION_FAILURE" }],
    ["infrastructure failure", { outcome: "INFRASTRUCTURE_FAILURE" }],
  ] as const)("T018-B2-002 only permits initial ELIGIBLE: %s", async (_label, result) => {
    const fixture = harness({ handoffResults: [result] });

    const actual = await fixture.service.reconcile(intentId);

    expect(actual.outcome).not.toBe("SESSION_CANDIDATE");
    expect(fixture.resolveTechnicalPassword).not.toHaveBeenCalled();
    expect(fixture.signIn).not.toHaveBeenCalled();
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it("T018-B2-003 never creates for a bound bridge and accepts its matching subject", async () => {
    const bound = eligible({
      boundAuthUserId: authUserId,
      identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
    });
    const fixture = harness({
      handoffResults: [bound],
      postResult: correlated({
        identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY",
      }),
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toMatchObject({
      authUserId,
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.provision).not.toHaveBeenCalled();
    expect(fixture.resolvePostSignInAuthHandoffCorrelation).toHaveBeenCalledWith(
      intentId,
    );
  });

  it("T018-B2-004 fails closed for a bound sign-in subject mismatch", async () => {
    const fixture = harness({
      handoffResults: [eligible({ boundAuthUserId: authUserId })],
      signInResults: [session(otherAuthUserId)],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(fixture.provision).not.toHaveBeenCalled();
    expect(fixture.resolvePostSignInAuthHandoffCorrelation).not.toHaveBeenCalled();
  });

  it.each([
    "DEFINITE_CREDENTIAL_FAILURE",
    "AUTH_DENIED_OR_UNAVAILABLE",
    "AMBIGUOUS_FAILURE",
  ] as const)("T018-B2-005 bound %s never creates", async (outcome) => {
    const fixture = harness({
      handoffResults: [eligible({ boundAuthUserId: authUserId })],
      signInResults: [{ outcome }],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.not.toMatchObject({
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it("T018-B2-006 signs in before provisioning an unbound bridge", async () => {
    const events: string[] = [];
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        session(),
      ],
    });
    fixture.signIn.mockImplementation(async () => {
      events.push("sign-in");
      return events.filter((event) => event === "sign-in").length === 1
        ? { outcome: "DEFINITE_CREDENTIAL_FAILURE" }
        : session();
    });
    fixture.provision.mockImplementation(async () => {
      events.push("create");
      return { authUserId, outcome: "CREATED" };
    });

    await fixture.service.reconcile(intentId);

    expect(events).toEqual(["sign-in", "create", "sign-in"]);
  });

  it("T018-B2-007 initial successful reconciliation performs zero creates", async () => {
    const fixture = harness();

    await expect(fixture.service.reconcile(intentId)).resolves.toMatchObject({
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it.each([
    "AMBIGUOUS_FAILURE",
    "AUTH_DENIED_OR_UNAVAILABLE",
  ] as const)("T018-B2-008 initial %s performs zero creates", async (outcome) => {
    const fixture = harness({ signInResults: [{ outcome }] });

    await expect(fixture.service.reconcile(intentId)).resolves.not.toMatchObject({
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.resolve).toHaveBeenCalledOnce();
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it("T018-B2-009 definite credential failure triggers a second A2 resolution before create", async () => {
    const events: string[] = [];
    let resolution = 0;
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        session(),
      ],
    });
    fixture.resolve.mockImplementation(async () => {
      events.push(`resolve-${++resolution}`);
      return eligible();
    });
    fixture.provision.mockImplementation(async () => {
      events.push("create");
      return { authUserId, outcome: "CREATED" };
    });

    await fixture.service.reconcile(intentId);

    expect(events).toEqual(["resolve-1", "resolve-2", "create"]);
  });

  it.each([
    ["expired", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_EXPIRED" }],
    ["revoked", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_REVOKED" }],
    ["consumed", { identityCompatibility: "NO_APPLICATION_IDENTITY", outcome: "GRANT_CONSUMED" }],
    ["incompatible", { outcome: "IDENTITY_INCOMPATIBLE" }],
    ["security failure", { outcome: "SECURITY_CORRELATION_FAILURE" }],
    ["infrastructure failure", { outcome: "INFRASTRUCTURE_FAILURE" }],
  ] as const)("T018-B2-010 current-state recheck %s prevents create", async (_label, current) => {
    const fixture = harness({
      handoffResults: [eligible(), current],
      signInResults: [{ outcome: "DEFINITE_CREDENTIAL_FAILURE" }],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.not.toMatchObject({
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.resolve).toHaveBeenCalledTimes(2);
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it.each([
    ["intent", { intentId: otherId }],
    ["company", { maintenanceCompanyId: otherId }],
    ["email", { targetEmail: "changed@example.invalid" }],
    ["challenge", { currentChallengeId: otherId }],
    ["grant", { handoffSessionGrantId: otherId }],
    ["bridge credential", { authBridgeCredentialId: otherId }],
    [
      "identity compatibility",
      { identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY" },
    ],
    ["new bound subject", { boundAuthUserId: authUserId }],
  ] as const)("T018-B2-011 second A2 %s mismatch prevents create", async (_label, overrides) => {
    const fixture = harness({
      handoffResults: [eligible(), eligible(overrides)],
      signInResults: [{ outcome: "DEFINITE_CREDENTIAL_FAILURE" }],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it("T018-B2-012 unavailable technical-password state prevents sign-in and create", async () => {
    const fixture = harness({ passwordResults: [{ outcome: "UNAVAILABLE" }] });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "REPAIR_REQUIRED",
    });
    expect(fixture.signIn).not.toHaveBeenCalled();
    expect(fixture.provision).not.toHaveBeenCalled();
  });

  it("T018-B2-013 CREATED performs exactly one post-create sign-in", async () => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { authUserId, outcome: "CREATED" },
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        session(),
      ],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toMatchObject({
      authUserId,
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.provision).toHaveBeenCalledOnce();
    expect(fixture.signIn).toHaveBeenCalledTimes(2);
    expect(fixture.resolvePostSignInAuthHandoffCorrelation).toHaveBeenCalledOnce();
  });

  it("T018-B2-014 CREATED requires the post-create subject to equal the created Auth ID", async () => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { authUserId, outcome: "CREATED" },
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        session(otherAuthUserId),
      ],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(fixture.resolvePostSignInAuthHandoffCorrelation).not.toHaveBeenCalled();
  });

  it.each([
    "DEFINITE_CREDENTIAL_FAILURE",
    "AUTH_DENIED_OR_UNAVAILABLE",
    "AMBIGUOUS_FAILURE",
  ] as const)("T018-B2-015 CREATED post-create %s fails closed", async (outcome) => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { authUserId, outcome: "CREATED" },
      signInResults: [{ outcome: "DEFINITE_CREDENTIAL_FAILURE" }, { outcome }],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
    expect(fixture.provision).toHaveBeenCalledOnce();
  });

  it("T018-B2-016 DUPLICATE performs exactly one reconciliation sign-in and can succeed", async () => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { outcome: "DUPLICATE_OR_CONFLICT" },
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        session(),
      ],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toMatchObject({
      outcome: "SESSION_CANDIDATE",
    });
    expect(fixture.provision).toHaveBeenCalledOnce();
    expect(fixture.signIn).toHaveBeenCalledTimes(2);
  });

  it.each([
    ["DEFINITE_CREDENTIAL_FAILURE", "REPAIR_REQUIRED"],
    ["AUTH_DENIED_OR_UNAVAILABLE", "AUTH_DENIED_OR_UNAVAILABLE"],
    ["AMBIGUOUS_FAILURE", "RETRYABLE_FAILURE"],
  ] as const)("T018-B2-017 DUPLICATE maps %s without create retry", async (signInOutcome, expected) => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { outcome: "DUPLICATE_OR_CONFLICT" },
      signInResults: [
        { outcome: "DEFINITE_CREDENTIAL_FAILURE" },
        { outcome: signInOutcome },
      ],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: expected,
    });
    expect(fixture.provision).toHaveBeenCalledOnce();
  });

  it.each([
    ["DEFINITE_FAILURE", "REPAIR_REQUIRED"],
    ["AMBIGUOUS_FAILURE", "RETRYABLE_FAILURE"],
  ] as const)("T018-B2-018 B1 %s performs zero repeats", async (provisioningOutcome, expected) => {
    const fixture = harness({
      handoffResults: [eligible(), eligible()],
      provisioningResult: { outcome: provisioningOutcome },
      signInResults: [{ outcome: "DEFINITE_CREDENTIAL_FAILURE" }],
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: expected,
    });
    expect(fixture.provision).toHaveBeenCalledOnce();
    expect(fixture.signIn).toHaveBeenCalledOnce();
  });

  it.each([
    ["NOT_CONSUMED", "SECURITY_CORRELATION_FAILURE"],
    ["IDENTITY_INCOMPATIBLE", "IDENTITY_INCOMPATIBLE"],
    ["SECURITY_CORRELATION_FAILURE", "SECURITY_CORRELATION_FAILURE"],
    ["INFRASTRUCTURE_FAILURE", "RETRYABLE_FAILURE"],
  ] as const)("T018-B2-019 post-sign-in %s cannot succeed", async (postOutcome, expected) => {
    const fixture = harness({
      postResult: { outcome: postOutcome },
    });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: expected,
    });
    expect(fixture.resolvePostSignInAuthHandoffCorrelation).toHaveBeenCalledWith(
      intentId,
    );
  });

  it.each([
    ["intent", { intentId: otherId }],
    ["company", { maintenanceCompanyId: otherId }],
    ["email", { targetEmail: "changed@example.invalid" }],
    ["challenge", { currentChallengeId: otherId }],
    ["grant", { handoffSessionGrantId: otherId }],
    ["bridge credential", { authBridgeCredentialId: otherId }],
    ["bridge subject", { bridgeAuthUserId: otherAuthUserId }],
    ["grant subject", { grantAuthUserId: otherAuthUserId }],
    [
      "identity compatibility",
      { identityCompatibility: "COMPATIBLE_EXISTING_APPLICATION_IDENTITY" },
    ],
  ] as const)("T018-B2-020 fails closed for post-correlation %s mismatch", async (_label, overrides) => {
    const fixture = harness({ postResult: correlated(overrides) });

    await expect(fixture.service.reconcile(intentId)).resolves.toEqual({
      outcome: "SECURITY_CORRELATION_FAILURE",
    });
  });

  it("T018-B2-021 preserves the exact opaque session candidate", async () => {
    const opaqueCandidate = candidate();
    const fixture = harness({ signInResults: [session(authUserId, opaqueCandidate)] });

    const result = await fixture.service.reconcile(intentId);

    expect(result.outcome).toBe("SESSION_CANDIDATE");
    if (result.outcome === "SESSION_CANDIDATE") {
      expect(result.sessionCandidate).toBe(opaqueCandidate);
      expect(Object.keys(result).sort()).toEqual(
        ["authUserId", "intentId", "outcome", "sessionCandidate"].sort(),
      );
    }
  });

  it("T018-B2-022 accepts intentId only and ignores no caller-selected authority", async () => {
    const fixture = harness();
    const invoke = fixture.service.reconcile as (input: unknown) => Promise<unknown>;

    await expect(
      invoke({
        authUserId: otherAuthUserId,
        intentId,
        maintenanceCompanyId: otherId,
        role: "OWNER",
      }),
    ).resolves.toEqual({ outcome: "SECURITY_CORRELATION_FAILURE" });
    expect(fixture.resolve).not.toHaveBeenCalled();
  });

  it("T018-B2-023 contains no vault, raw session, token, cookie, or forbidden Auth Admin operation", () => {
    const implementation = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-auth-identity-reconciliation-service.ts",
        import.meta.url,
      ),
      "utf8",
    );

    expect(implementation).not.toMatch(
      /readTechnicalSessionCandidate|technical-session-candidate-server-vault|\bAuthSession\b|access_token|refresh_token/,
    );
    expect(implementation).not.toMatch(
      /createServerClient|cookies\s*\(|setAll|listUsers|updateUserById|auth\.admin/,
    );
    expect(implementation).not.toMatch(
      /PlatformUser|CompanyMembership|AuditEvent|\.from\s*\(|\.rpc\s*\(/,
    );
  });

  it("T018-B2-024 returns no technical password or provider internals", async () => {
    const fixture = harness();
    const result = await fixture.service.reconcile(intentId);
    const serialized = JSON.stringify(result);

    expect(serialized).not.toContain(technicalPassword);
    expect(serialized).not.toMatch(/access.?token|refresh.?token|key.?version/i);
    expect(result).not.toHaveProperty("role");
    expect(result).not.toHaveProperty("membership");
  });

  it("T018-B2-025 stale concurrent loser rechecks current state and never blindly creates", async () => {
    let resolveCalls = 0;
    let initialSignIns = 0;
    let releaseInitialSignIns: (() => void) | undefined;
    const bothInitialSignInsStarted = new Promise<void>((resolveBarrier) => {
      releaseInitialSignIns = resolveBarrier;
    });
    const resolve = vi.fn(async () => {
      resolveCalls += 1;
      if (resolveCalls <= 3) {
        return eligible();
      }
      return {
        identityCompatibility: "NO_APPLICATION_IDENTITY",
        outcome: "GRANT_CONSUMED",
      } as const;
    });
    const signIn = vi.fn(async () => {
      initialSignIns += 1;
      if (initialSignIns <= 2) {
        if (initialSignIns === 2) {
          releaseInitialSignIns?.();
        }
        await bothInitialSignInsStarted;
        return { outcome: "DEFINITE_CREDENTIAL_FAILURE" } as const;
      }
      return session();
    });
    const provision = vi.fn(async () => ({ authUserId, outcome: "CREATED" } as const));
    const resolvePostSignInAuthHandoffCorrelation = vi.fn(async () => correlated());
    const service = createFirstAdminAuthIdentityReconciliationService({
      handoffService: { resolve, resolvePostSignInAuthHandoffCorrelation },
      provisioningService: { provision },
      signInBoundary: { signIn },
      technicalPasswordService: {
        resolve: vi.fn(async () => ({ outcome: "READY", technicalPassword } as const)),
      },
    });

    const [first, second] = await Promise.all([
      service.reconcile(intentId),
      service.reconcile(intentId),
    ]);

    expect([first.outcome, second.outcome].sort()).toEqual(
      ["NOT_ELIGIBLE", "SESSION_CANDIDATE"].sort(),
    );
    expect(provision).toHaveBeenCalledOnce();
    expect(resolvePostSignInAuthHandoffCorrelation).toHaveBeenCalledOnce();
  });
});
