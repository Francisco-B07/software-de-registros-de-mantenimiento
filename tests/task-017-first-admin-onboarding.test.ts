import { readFileSync } from "node:fs";

import { beforeEach, describe, expect, it, vi } from "vitest";

import type {
  FirstAdminOnboardingMutationSource,
  FirstAdminOnboardingServerSource,
  FirstAdminVerificationCodeDelivery,
} from "../src/modules/identity-authorization/application/first-admin-onboarding";
import { genericFirstAdminOnboardingDenial } from "../src/modules/identity-authorization/application/first-admin-onboarding";
import { createFirstAdminOnboardingService } from "../src/modules/identity-authorization/application/first-admin-onboarding-service";
import { createChallengeVerifier } from "../src/modules/identity-authorization/infrastructure/crypto/challenge-verifier";

const intentId = "17700000-0000-4000-8000-000000000001";
const companyId = "17700000-0000-4000-8000-000000000002";
const challengeId = "17700000-0000-4000-8000-000000000003";
const establishmentOperationId = "17700000-0000-4000-8000-000000000004";
const issueOperationId = "17700000-0000-4000-8000-000000000005";
const verificationOperationId = "17700000-0000-4000-8000-000000000006";
const email = "first-admin@example.test";
const code = "transient-proof-code";
const issuedAt = "2026-09-19T16:00:00.000Z";
const expiresAt = "2026-09-20T00:00:00.000Z";
const challengeKey = Buffer.from("challenge-secret-material-32-bytes!!");

function issueRow(
  outcome: "ALREADY_RECONCILED" | "ESTABLISHED" | "RESENT" = "ESTABLISHED",
) {
  return [
    {
      challenge_id: challengeId,
      changed: outcome !== "ALREADY_RECONCILED",
      expires_at: expiresAt,
      intent_id: intentId,
      issued_at: issuedAt,
      outcome,
      reason: outcome,
    },
  ];
}

function deniedRow() {
  return [
    {
      challenge_id: null,
      changed: false,
      expires_at: null,
      intent_id: null,
      issued_at: null,
      outcome: "DENIED",
      reason: "AUTHORIZATION_DENIED",
    },
  ];
}

function mutationSource(overrides: Partial<FirstAdminOnboardingMutationSource> = {}) {
  return Object.freeze({
    async establish() {
      return issueRow();
    },
    async resend() {
      return issueRow("RESENT");
    },
    ...overrides,
  }) satisfies FirstAdminOnboardingMutationSource;
}

function serverSource(
  overrides: Partial<FirstAdminOnboardingServerSource> = {},
): FirstAdminOnboardingServerSource {
  const verifier = createChallengeVerifier({
    challengeId,
    code,
    keyMaterial: challengeKey,
  });

  return Object.freeze({
    async getChallengeMaterial() {
      return Object.freeze({
        challengeId,
        verifier,
        verifierKeyVersion: "v1",
      });
    },
    async getDeliveryTarget() {
      return Object.freeze({ email, expiresAt });
    },
    async verifyTransition() {
      return Object.freeze({
        attemptNumber: 1,
        handoffReady: true,
        outcome: "CONSUMED" as const,
      });
    },
    ...overrides,
  });
}

function delivery(
  implementation: FirstAdminVerificationCodeDelivery["deliver"] = async () =>
    undefined,
): FirstAdminVerificationCodeDelivery {
  return Object.freeze({ deliver: implementation });
}

function dependencies(
  mutation: FirstAdminOnboardingMutationSource,
  server: FirstAdminOnboardingServerSource = serverSource(),
) {
  return Object.freeze({
    createMutationSource: async () => mutation,
    createServerSource: () => server,
  });
}

const establishInput = Object.freeze({
  challengeId,
  code,
  email,
  establishmentOperationId,
  intentId,
  issueOperationId,
  maintenanceCompanyId: companyId,
});

describe("TASK-017 first-admin onboarding application boundary", () => {
  beforeEach(() => {
    vi.stubEnv("AUTH_CHALLENGE_HMAC_ACTIVE_VERSION", "v1");
    vi.stubEnv("AUTH_CHALLENGE_HMAC_KEY_V1", challengeKey.toString("utf8"));
    vi.stubEnv("AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_TECHNICAL_PASSWORD_KEY_V1",
      "technical-secret-material-32-bytes!!",
    );
    vi.stubEnv("SUPABASE_SECRET_KEY", "sb_secret_task017_fixture");
  });

  it("T017-APP-001 delivers transient material only after authoritative establishment returns", async () => {
    const events: string[] = [];
    const establish = vi.fn(async () => {
      events.push("database-commit-confirmed");
      return issueRow();
    });
    const deliver = vi.fn(async () => {
      events.push("delivery");
    });
    const service = createFirstAdminOnboardingService(
      delivery(deliver),
      dependencies(mutationSource({ establish })),
    );

    await expect(service.establish(establishInput)).resolves.toMatchObject({
      challengeId,
      delivery: "DELIVERED",
      intentId,
      outcome: "ESTABLISHED",
    });
    expect(events).toEqual(["database-commit-confirmed", "delivery"]);
    expect(deliver).toHaveBeenCalledWith({
      challengeId,
      code,
      email,
      expiresAt,
      intentId,
    });
  });

  it("T017-APP-002 sends only closed correlations and a digest to the mutation source", async () => {
    let sent: Parameters<FirstAdminOnboardingMutationSource["establish"]>[0] | null =
      null;
    const establish: FirstAdminOnboardingMutationSource["establish"] = async (
      input,
    ) => {
      sent = input;
      return issueRow();
    };
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(mutationSource({ establish })),
    );

    await service.establish(establishInput);
    expect(sent).toEqual({
      challengeId,
      email,
      establishmentOperationId,
      intentId,
      issueOperationId,
      maintenanceCompanyId: companyId,
      verifier: expect.any(Uint8Array),
      verifierKeyVersion: "v1",
    });
    const captured = sent as unknown as Parameters<
      FirstAdminOnboardingMutationSource["establish"]
    >[0];
    expect(captured.verifier).toHaveLength(32);
    expect(JSON.stringify(sent)).not.toContain(code);
    expect(sent).not.toHaveProperty("role");
    expect(sent).not.toHaveProperty("actorId");
  });

  it("T017-APP-003 rejects malformed input before DB or delivery", async () => {
    const createMutationSource = vi.fn(async () => mutationSource());
    const deliver = vi.fn(async () => undefined);
    const service = createFirstAdminOnboardingService(delivery(deliver), {
      createMutationSource,
      createServerSource: () => serverSource(),
    });

    await expect(
      service.establish({ ...establishInput, intentId: "not-a-uuid" }),
    ).resolves.toMatchObject({
      delivery: "NOT_ATTEMPTED",
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    expect(createMutationSource).not.toHaveBeenCalled();
    expect(deliver).not.toHaveBeenCalled();
  });

  it("T017-APP-004 never attempts delivery for denied authority", async () => {
    const deliver = vi.fn(async () => undefined);
    const service = createFirstAdminOnboardingService(
      delivery(deliver),
      dependencies(
        mutationSource({
          async establish() {
            return deniedRow();
          },
        }),
      ),
    );

    await expect(service.establish(establishInput)).resolves.toMatchObject({
      delivery: "NOT_ATTEMPTED",
      outcome: "DENIED",
      reason: "AUTHORIZATION_DENIED",
    });
    expect(deliver).not.toHaveBeenCalled();
  });

  it("T017-APP-005 delivery failure does not rewrite the committed issuance result", async () => {
    const service = createFirstAdminOnboardingService(
      delivery(async () => {
        throw new Error("provider detail");
      }),
      dependencies(mutationSource()),
    );

    await expect(service.establish(establishInput)).resolves.toMatchObject({
      changed: true,
      delivery: "FAILED",
      outcome: "ESTABLISHED",
    });
  });

  it("T017-APP-006 same-operation reconciliation remains one business emission", async () => {
    let calls = 0;
    const establish = vi.fn(async () => {
      calls += 1;
      return issueRow(calls === 1 ? "ESTABLISHED" : "ALREADY_RECONCILED");
    });
    const deliver = vi.fn(async () => undefined);
    const service = createFirstAdminOnboardingService(
      delivery(deliver),
      dependencies(mutationSource({ establish })),
    );

    const first = await service.establish(establishInput);
    const retry = await service.establish(establishInput);
    expect(first).toMatchObject({ changed: true, outcome: "ESTABLISHED" });
    expect(retry).toMatchObject({
      changed: false,
      outcome: "ALREADY_RECONCILED",
    });
    expect(establish).toHaveBeenCalledTimes(2);
    expect(deliver).toHaveBeenCalledTimes(2);
  });

  it("T017-APP-007 resend derives delivery email from committed intent state", async () => {
    const deliver = vi.fn(async () => undefined);
    const getDeliveryTarget = vi.fn(async () => ({ email, expiresAt }));
    const service = createFirstAdminOnboardingService(
      delivery(deliver),
      dependencies(mutationSource(), serverSource({ getDeliveryTarget })),
    );

    await expect(
      service.resend({ challengeId, code, intentId, issueOperationId }),
    ).resolves.toMatchObject({ delivery: "DELIVERED", outcome: "RESENT" });
    expect(getDeliveryTarget).toHaveBeenCalledWith(intentId, challengeId);
    expect(deliver).toHaveBeenCalledWith(
      expect.objectContaining({ email, code, intentId, challengeId }),
    );
  });

  it("T017-APP-008 resend target-resolution failure preserves issuance and reports delivery failure", async () => {
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({
          async getDeliveryTarget() {
            throw new Error("sensitive detail");
          },
        }),
      ),
    );

    await expect(
      service.resend({ challengeId, code, intentId, issueOperationId }),
    ).resolves.toMatchObject({
      changed: true,
      delivery: "FAILED",
      outcome: "RESENT",
    });
  });

  it("T017-APP-009 verifies with TASK-013 HMAC and binds the expected current challenge", async () => {
    const getChallengeMaterial = vi.fn(async () => ({
      challengeId,
      verifier: createChallengeVerifier({
        challengeId,
        code,
        keyMaterial: challengeKey,
      }),
      verifierKeyVersion: "v1",
    }));
    const verifyTransition = vi.fn(async () => ({
      attemptNumber: 1,
      handoffReady: true,
      outcome: "CONSUMED" as const,
    }));
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({ getChallengeMaterial, verifyTransition }),
      ),
    );

    await expect(
      service.verify({ code, email, intentId, verificationOperationId }),
    ).resolves.toEqual({
      attemptNumber: 1,
      handoffReady: true,
      outcome: "CONSUMED",
    });
    expect(verifyTransition).toHaveBeenCalledWith({
      challengeId,
      email,
      intentId,
      matched: true,
      technicalPasswordKeyVersion: "v1",
      verificationOperationId,
    });
    expect(getChallengeMaterial).toHaveBeenCalledWith(
      intentId,
      email,
      verificationOperationId,
    );
  });

  it("T017-APP-010 wrong proof reaches the atomic transition only as matched=false", async () => {
    const verifyTransition = vi.fn(async () => ({
      attemptNumber: 1,
      handoffReady: false,
      outcome: "INVALID" as const,
    }));
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(mutationSource(), serverSource({ verifyTransition })),
    );

    await service.verify({
      code: "wrong-code",
      email,
      intentId,
      verificationOperationId,
    });
    expect(verifyTransition).toHaveBeenCalledWith(
      expect.objectContaining({ challengeId, matched: false }),
    );
  });

  it("T017-APP-011 maps material and transition failures to one non-enumerating error", async () => {
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({
          async getChallengeMaterial() {
            throw new Error("email missing for another tenant");
          },
        }),
      ),
    );

    await expect(
      service.verify({ code, email, intentId, verificationOperationId }),
    ).rejects.toThrow("First-admin onboarding request denied.");
    await expect(
      service.verify({ code, email, intentId, verificationOperationId }),
    ).rejects.not.toThrow(/email|tenant|missing/i);
  });

  it("T017-APP-012 rejects malformed DB results instead of guessing success", async () => {
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource({
          async establish() {
            return [{ outcome: "ESTABLISHED", changed: true }];
          },
        }),
      ),
    );

    await expect(service.establish(establishInput)).rejects.toThrow(
      "First-admin onboarding request denied.",
    );
  });

  it("T017-APP-013 exposes no SessionGrant bearer in application result types", () => {
    const contract = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-onboarding.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(contract).not.toMatch(/sessionGrantId|session_grant_id/);
    expect(contract).toContain("handoffReady");
  });

  it("T017-APP-014 keeps caller and server adapters purpose-specific", () => {
    const caller = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/first-admin-onboarding-source.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const server = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/first-admin-onboarding-server-source.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(caller).toContain("createSupabaseServerClient()");
    expect(caller).not.toMatch(
      /(?:supabase|client)\.from\(|auth\.admin|SUPABASE_SECRET_KEY/,
    );
    expect(server).toContain("get_first_admin_onboarding_challenge_material");
    expect(server).toContain("p_verification_operation_id");
    expect(server).toContain("get_first_admin_onboarding_delivery_target");
    expect(server).toContain("verify_first_admin_onboarding_challenge");
    expect(server).not.toMatch(
      /(?:supabase|client)\.from\(|auth\.admin|listUsers|createUser/,
    );
  });

  it("T017-APP-015 exports no raw privileged client or generic repository", () => {
    const boundary = readFileSync(
      new URL(
        "../src/modules/identity-authorization/server.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(boundary).toContain("getFirstAdminOnboardingService");
    expect(boundary).not.toMatch(
      /getAdminClient|createPrivilegedSupabaseClient|raw.*client|GenericRepository/i,
    );
  });

  it("T017-APP-016 defines a provider-neutral port with no production adapter", () => {
    const contract = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-onboarding.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const service = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-onboarding-service.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(contract).toContain("FirstAdminVerificationCodeDelivery");
    expect([contract, service].join("\n")).not.toMatch(
      /resend\.com|sendgrid|mailgun|nodemailer|smtp|providerRetry|backoff/i,
    );
  });

  it("T017-APP-017 persists or logs neither plaintext proof nor target PII", () => {
    const implementation = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-onboarding-service.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(implementation).not.toMatch(/console\.|logger\.|\.log\(/);
    expect(implementation).not.toMatch(/insert\(|update\(|\.from\(/);
  });

  it("T017-APP-018 uses one bounded denial without secret or PII echo", () => {
    expect(genericFirstAdminOnboardingDenial().message).toBe(
      "First-admin onboarding request denied.",
    );
    expect(genericFirstAdminOnboardingDenial().message).not.toMatch(
      /email|code|secret|tenant|challenge/i,
    );
  });

  it("T017-APP-019 performs no network operation in the unit suite", () => {
    const source = readFileSync(new URL(import.meta.url), "utf8");
    expect(source).not.toMatch(/fetch\s*\(|createClient\s*\(/);
  });

  it("T017-APP-020 T017-REV-001-A retries a lost successful response through the same operation", async () => {
    const getChallengeMaterial = vi.fn(async () => ({
      challengeId,
      verifier: createChallengeVerifier({
        challengeId,
        code,
        keyMaterial: challengeKey,
      }),
      verifierKeyVersion: "v1",
    }));
    const verifyTransition = vi.fn(async () => ({
      attemptNumber: 1,
      handoffReady: true,
      outcome: "CONSUMED" as const,
    }));
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({ getChallengeMaterial, verifyTransition }),
      ),
    );
    const input = { code, email, intentId, verificationOperationId };

    const first = await service.verify(input);
    const retry = await service.verify(input);

    expect(first).toEqual({
      attemptNumber: 1,
      handoffReady: true,
      outcome: "CONSUMED",
    });
    expect(retry).toEqual(first);
    expect(getChallengeMaterial).toHaveBeenNthCalledWith(
      2,
      intentId,
      email,
      verificationOperationId,
    );
    expect(verifyTransition).toHaveBeenCalledTimes(2);
  });

  it("T017-APP-021 T017-REV-001-B preserves incompatible proof denial on successful retry", async () => {
    const verifyTransition = vi.fn(async (input) => {
      expect(input.matched).toBe(false);
      throw new Error("terminal proof mismatch");
    });
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(mutationSource(), serverSource({ verifyTransition })),
    );

    await expect(
      service.verify({
        code: "incompatible-proof",
        email,
        intentId,
        verificationOperationId,
      }),
    ).rejects.toThrow("First-admin onboarding request denied.");
    expect(verifyTransition).toHaveBeenCalledWith(
      expect.objectContaining({
        matched: false,
        verificationOperationId,
      }),
    );
  });

  it("T017-APP-022 T017-REV-001-D returns the reconciled exhausted terminal result", async () => {
    const getChallengeMaterial = vi.fn(
      serverSource().getChallengeMaterial,
    );
    const verifyTransition = vi.fn(async () => ({
      attemptNumber: 3,
      handoffReady: false,
      outcome: "EXHAUSTED" as const,
    }));
    const service = createFirstAdminOnboardingService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({ getChallengeMaterial, verifyTransition }),
      ),
    );

    await expect(
      service.verify({
        code: "same-terminal-wrong-proof",
        email,
        intentId,
        verificationOperationId,
      }),
    ).resolves.toEqual({
      attemptNumber: 3,
      handoffReady: false,
      outcome: "EXHAUSTED",
    });
    expect(getChallengeMaterial).toHaveBeenCalledWith(
      intentId,
      email,
      verificationOperationId,
    );
  });
});
