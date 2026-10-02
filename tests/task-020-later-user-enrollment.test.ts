import { readFileSync } from "node:fs";

import { beforeEach, describe, expect, it, vi } from "vitest";

import { getOrCreateResendRequestIds } from "../app/later-user-enrollment-form";
import { createLaterUserEnrollmentService } from "../src/modules/identity-authorization/application/later-user-enrollment-service";
import type {
  LaterUserEnrollmentMutationSource,
  LaterUserEnrollmentServerSource,
  LaterUserVerificationCodeDelivery,
} from "../src/modules/identity-authorization/application/later-user-enrollment";
import { createChallengeVerifier } from "../src/modules/identity-authorization/infrastructure/crypto/challenge-verifier";
import { createLaterUserVerificationCode } from "../src/modules/identity-authorization/infrastructure/crypto/later-user-verification-code";
import {
  createLaterUserVerificationOperationToken,
  resolveLaterUserVerificationOperationToken,
} from "../src/modules/identity-authorization/infrastructure/crypto/later-user-verification-operation";

const challengeKey = Buffer.from("task020-challenge-secret-material-32-bytes");
const intentId = "20000000-0000-4000-8000-000000000001";
const challengeId = "20000000-0000-4000-8100-000000000001";
const establishmentOperationId = "20000000-0000-4000-8200-000000000001";
const issueOperationId = "20000000-0000-4000-8300-000000000001";
const verificationOperationId = "20000000-0000-4000-8400-000000000001";
const email = "later-user@example.test";
const code = "task020-proof";
const issuedAt = "2026-10-01T12:00:00.000Z";
const expiresAt = "2026-10-01T20:00:00.000Z";

function issueRow(outcome: "ESTABLISHED" | "RESENT" | "ALREADY_RECONCILED" = "ESTABLISHED") {
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

function mutationSource(
  overrides: Partial<LaterUserEnrollmentMutationSource> = {},
): LaterUserEnrollmentMutationSource {
  return Object.freeze({
    async establish() {
      return issueRow();
    },
    async resend() {
      return issueRow("RESENT");
    },
    ...overrides,
  });
}

function serverSource(
  overrides: Partial<LaterUserEnrollmentServerSource> = {},
): LaterUserEnrollmentServerSource {
  return Object.freeze({
    async getChallengeMaterial() {
      return Object.freeze({
        challengeId,
        verifier: createChallengeVerifier({
          challengeId,
          code,
          keyMaterial: challengeKey,
        }),
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
  deliver: LaterUserVerificationCodeDelivery["deliver"] = async () =>
    undefined,
): LaterUserVerificationCodeDelivery {
  return Object.freeze({ deliver });
}

function dependencies(
  mutation = mutationSource(),
  server = serverSource(),
) {
  return Object.freeze({
    createMutationSource: async () => mutation,
    createServerSource: () => server,
    trustedAppOrigin: "https://app.example.test",
  });
}

const establishInput = Object.freeze({
  challengeId,
  code,
  email,
  establishmentOperationId,
  intendedRole: "TECHNICIAN" as const,
  intentId,
  issueOperationId,
});

describe("TASK-020 later-user enrollment application boundary", () => {
  beforeEach(() => {
    vi.stubEnv("AUTH_CHALLENGE_HMAC_ACTIVE_VERSION", "v1");
    vi.stubEnv("AUTH_CHALLENGE_HMAC_KEY_V1", challengeKey.toString("utf8"));
    vi.stubEnv("AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION", "v1");
    vi.stubEnv(
      "AUTH_TECHNICAL_PASSWORD_KEY_V1",
      "task020-technical-secret-material-32-bytes",
    );
    vi.stubEnv("SUPABASE_SECRET_KEY", "sb_secret_task020_fixture");
  });

  it("T020-D-APP-001 commits before delivery and builds a minimized trusted-origin URL", async () => {
    const events: string[] = [];
    const establish = vi.fn<LaterUserEnrollmentMutationSource["establish"]>(async () => {
      events.push("commit-confirmed");
      return issueRow();
    });
    const deliver = vi.fn<LaterUserVerificationCodeDelivery["deliver"]>(async () => {
      events.push("delivery");
    });
    const service = createLaterUserEnrollmentService(
      delivery(deliver),
      dependencies(mutationSource({ establish })),
    );

    await expect(service.establish(establishInput)).resolves.toMatchObject({
      delivery: "DELIVERED",
      outcome: "ESTABLISHED",
    });
    expect(events).toEqual(["commit-confirmed", "delivery"]);
    expect(deliver).toHaveBeenCalledWith({
      challengeId,
      code,
      email,
      expiresAt,
      intentId,
      verificationUrl: `https://app.example.test/later-user/verification/${intentId}`,
    });
    const url = deliver.mock.calls[0]?.[0].verificationUrl ?? "";
    expect(url).not.toContain(email);
    expect(url).not.toContain(code);
    expect(url).not.toMatch(/COMPANY_ADMIN|TECHNICIAN|grant|token|password/i);
  });

  it("T020-D-APP-002 sends tenant-free immutable bindings and a digest to the caller-scoped mutation", async () => {
    const establish = vi.fn<LaterUserEnrollmentMutationSource["establish"]>(
      async () => issueRow(),
    );
    const service = createLaterUserEnrollmentService(
      delivery(),
      dependencies(mutationSource({ establish })),
    );
    await service.establish(establishInput);

    expect(establish).toHaveBeenCalledWith({
      challengeId,
      email,
      establishmentOperationId,
      intendedRole: "TECHNICIAN",
      intentId,
      issueOperationId,
      verifier: expect.any(Uint8Array),
      verifierKeyVersion: "v1",
    });
    const sent = establish.mock.calls[0]?.[0];
    expect(sent?.verifier).toHaveLength(32);
    expect(JSON.stringify(sent)).not.toContain(code);
    expect(sent).not.toHaveProperty("maintenanceCompanyId");
    expect(sent).not.toHaveProperty("clientId");
  });

  it("T020-D-APP-003 validates inputs before DB or delivery", async () => {
    const createMutationSource = vi.fn(async () => mutationSource());
    const deliver = vi.fn(async () => undefined);
    const service = createLaterUserEnrollmentService(delivery(deliver), {
      createMutationSource,
      createServerSource: () => serverSource(),
      trustedAppOrigin: "https://app.example.test",
    });

    await expect(
      service.establish({ ...establishInput, intentId: "invalid" }),
    ).resolves.toMatchObject({ outcome: "DENIED", reason: "INVALID_INPUT" });
    expect(createMutationSource).not.toHaveBeenCalled();
    expect(deliver).not.toHaveBeenCalled();
  });

  it("T020-D-APP-004 delivery failure never rolls back or rewrites committed issuance", async () => {
    const service = createLaterUserEnrollmentService(
      delivery(async () => {
        throw new Error("provider detail");
      }),
      dependencies(),
    );
    await expect(service.establish(establishInput)).resolves.toMatchObject({
      changed: true,
      delivery: "FAILED",
      outcome: "ESTABLISHED",
    });
  });

  it("T020-D-APP-005 resend derives PII from committed state and cannot change tenant, email or role", async () => {
    const resend = vi.fn(async () => issueRow("RESENT"));
    const getDeliveryTarget = vi.fn(serverSource().getDeliveryTarget);
    const service = createLaterUserEnrollmentService(
      delivery(),
      dependencies(mutationSource({ resend }), serverSource({ getDeliveryTarget })),
    );
    await service.resend({ challengeId, code, intentId, issueOperationId });

    expect(resend).toHaveBeenCalledWith(
      expect.not.objectContaining({ email, intendedRole: "TECHNICIAN" }),
    );
    expect(getDeliveryTarget).toHaveBeenCalledWith(intentId, challengeId);
  });

  it("T020-D-APP-006 deterministic server code supports safe request replay and rotates by issue", () => {
    const first = createLaterUserVerificationCode({
      challengeId,
      issueOperationId,
      keyMaterial: challengeKey,
    });
    const retry = createLaterUserVerificationCode({
      challengeId,
      issueOperationId,
      keyMaterial: challengeKey,
    });
    const successor = createLaterUserVerificationCode({
      challengeId: "20000000-0000-4000-8100-000000000002",
      issueOperationId: "20000000-0000-4000-8300-000000000002",
      keyMaterial: challengeKey,
    });
    expect(first).toBe(retry);
    expect(successor).not.toBe(first);
    expect(first).toHaveLength(16);
  });

  it("T020-D-APP-007 verifies only the current server-resolved challenge with constant-time digest comparison", async () => {
    const verifyTransition = vi.fn(serverSource().verifyTransition);
    const service = createLaterUserEnrollmentService(
      delivery(),
      dependencies(mutationSource(), serverSource({ verifyTransition })),
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
  });

  it("T020-D-APP-008 wrong proof reaches the atomic DB transition only as matched=false", async () => {
    const verifyTransition = vi.fn(async () => ({
      attemptNumber: 1,
      handoffReady: false,
      outcome: "INVALID" as const,
    }));
    const service = createLaterUserEnrollmentService(
      delivery(),
      dependencies(mutationSource(), serverSource({ verifyTransition })),
    );
    await service.verify({
      code: "wrong-proof",
      email,
      intentId,
      verificationOperationId,
    });
    expect(verifyTransition).toHaveBeenCalledWith(
      expect.objectContaining({ matched: false }),
    );
  });

  it("T020-D-APP-009 material failures collapse to one non-enumerating denial", async () => {
    const service = createLaterUserEnrollmentService(
      delivery(),
      dependencies(
        mutationSource(),
        serverSource({
          async getChallengeMaterial() {
            throw new Error("other tenant detail");
          },
        }),
      ),
    );
    await expect(
      service.verify({ code, email, intentId, verificationOperationId }),
    ).rejects.toThrow("Later-user enrollment request denied.");
  });

  it("T020-D-SEC-001 keeps adapters purpose-specific and exports no generic privileged client", () => {
    const caller = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/later-user-enrollment-source.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const server = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/later-user-enrollment-server-source.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const boundary = readFileSync(
      new URL("../src/modules/identity-authorization/server.ts", import.meta.url),
      "utf8",
    );
    expect(caller).toContain("createSupabaseServerClient()");
    expect(caller).not.toMatch(
      /(?:supabase|client)\.from\(|auth\.admin|SUPABASE_SECRET_KEY/,
    );
    expect(server).toContain("get_later_user_enrollment_challenge_material");
    expect(server).toContain("verify_later_user_enrollment_challenge");
    expect(server).not.toMatch(
      /(?:supabase|client)\.from\(|auth\.admin|createUser|listUsers/,
    );
    expect(boundary).not.toMatch(
      /getAdminClient|createPrivilegedSupabaseClient|GenericRepository/i,
    );
  });

  it("T020-D-SEC-002 persists and logs neither plaintext code nor target PII", () => {
    const service = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/later-user-enrollment-service.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(service).not.toMatch(/console\.|logger\.|\.log\(/);
    expect(service).not.toMatch(/\.from\(|insert\(|update\(/);
  });

  it("T020-D-UI-001 admin UI has email and fixed role but no Client selector or completion claim", () => {
    const form = readFileSync(
      new URL("../app/later-user-enrollment-form.tsx", import.meta.url),
      "utf8",
    );
    expect(form).toContain('name="email"');
    expect(form).toContain('name="intendedRole"');
    expect(form).toContain('value="COMPANY_ADMIN"');
    expect(form).toContain('value="TECHNICIAN"');
    expect(form).not.toMatch(/clientId|UserClientAccess|usuario creado/i);
    expect(form).toContain("sólo online");
  });

  it("T020-D-UI-002 verification UI has no profile or tenant-access continuation", () => {
    const form = readFileSync(
      new URL("../app/later-user-verification-form.tsx", import.meta.url),
      "utf8",
    );
    expect(form).toContain('name="email"');
    expect(form).toContain('name="code"');
    expect(form).toContain("handoff está preparado");
    expect(form).not.toMatch(/firstName|lastName|profile|Client|pending-profile/);
  });

  it("T020-D-UI-003 admin browser never receives or supplies the plaintext code", () => {
    const adminForm = readFileSync(
      new URL("../app/later-user-enrollment-form.tsx", import.meta.url),
      "utf8",
    );
    const issueRoute = readFileSync(
      new URL("../app/api/later-user/enrollment/route.ts", import.meta.url),
      "utf8",
    );
    expect(adminForm).not.toMatch(/name="code"|formData\.get\("code"\)/);
    expect(issueRoute).toContain("createLaterUserVerificationCode");
    expect(issueRoute).not.toMatch(/console\.|logger\.|\.log\(/);
  });

  it("T020-D-UI-004 routes are online-only, same-origin, private-cache and expose no grant bearer", () => {
    const routes = [
      "../app/api/later-user/enrollment/route.ts",
      "../app/api/later-user/verification/route.ts",
    ]
      .map((path) => readFileSync(new URL(path, import.meta.url), "utf8"))
      .join("\n");
    expect(routes).toContain('request.headers.get("origin")');
    expect(routes).toContain('"Cache-Control"');
    expect(routes).not.toMatch(/sessionGrantId|session_grant_id|IndexedDB|Dexie|outbox/);
  });

  it("T020-D-IDEMP-001 retains one resend operation across ambiguity and rotates only after definitive settlement", () => {
    const ids = [
      "20000000-0000-4000-8100-000000000101",
      "20000000-0000-4000-8300-000000000101",
      "20000000-0000-4000-8100-000000000102",
      "20000000-0000-4000-8300-000000000102",
    ];
    const createId = vi.fn(() => {
      const value = ids.shift();
      if (value === undefined) {
        throw new Error("fixture exhausted");
      }
      return value;
    });

    const first = getOrCreateResendRequestIds(null, createId);
    const ambiguousRetry = getOrCreateResendRequestIds(first, createId);
    const nextDefinitiveResend = getOrCreateResendRequestIds(null, createId);

    expect(ambiguousRetry).toBe(first);
    expect(ambiguousRetry).toEqual({
      challengeId: "20000000-0000-4000-8100-000000000101",
      issueOperationId: "20000000-0000-4000-8300-000000000101",
    });
    expect(nextDefinitiveResend).toEqual({
      challengeId: "20000000-0000-4000-8100-000000000102",
      issueOperationId: "20000000-0000-4000-8300-000000000102",
    });
    expect(createId).toHaveBeenCalledTimes(4);

    const form = readFileSync(
      new URL("../app/later-user-enrollment-form.tsx", import.meta.url),
      "utf8",
    );
    const route = readFileSync(
      new URL("../app/api/later-user/enrollment/route.ts", import.meta.url),
      "utf8",
    );
    expect(form).toMatch(
      /getOrCreateResendRequestIds\(pendingResendOperation\)[\s\S]*await send\([\s\S]*setPendingResendOperation\(null\)/,
    );
    expect(route).toContain('failure(503, "NOT_CONFIRMED")');
  });

  it("T020-D-IDEMP-002 verification operation identity is server-issued and retained until an authoritative invalid attempt", () => {
    const form = readFileSync(
      new URL("../app/later-user-verification-form.tsx", import.meta.url),
      "utf8",
    );
    const route = readFileSync(
      new URL("../app/api/later-user/verification/route.ts", import.meta.url),
      "utf8",
    );

    const token = createLaterUserVerificationOperationToken({
      keyMaterial: challengeKey,
      keyVersion: "v1",
      operationId: verificationOperationId,
    });

    expect(token).not.toContain(challengeKey.toString("utf8"));
    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) =>
          keyVersion === "v1" ? challengeKey : null,
        token,
      }),
    ).toBe(verificationOperationId);
    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) =>
          keyVersion === "v1" ? challengeKey : null,
        token: token.replace(verificationOperationId, challengeId),
      }),
    ).toBeNull();

    expect(form).not.toContain("crypto.randomUUID");
    expect(form).toContain('action: "ISSUE_OPERATION"');
    expect(form).toContain('action: "VERIFY"');
    expect(form).toContain("setVerificationOperationToken(activeOperationToken)");
    expect(form).toMatch(
      /outcome === "INVALID"[\s\S]*setVerificationOperationToken\(null\)/,
    );
    expect(route).toContain('import { randomUUID } from "node:crypto"');
    expect(route).toContain('body.action === "ISSUE_OPERATION"');
    expect(route).toContain("createLaterUserVerificationOperationToken");
    expect(route).toContain("resolveLaterUserVerificationOperationToken");
    expect(route).toMatch(
      /resolveKeyMaterial: \(keyVersion\)[\s\S]*challengeHmacKeys,[\s\S]*keyVersion/,
    );
    expect(route).not.toContain("verificationOperationId: body.");
  });

  it("T020-D-IDEMP-003 resolves an ambiguous retry with the embedded version after active-key rotation", () => {
    const keyA = Buffer.from("task020-operation-key-A-material-32-bytes");
    const keyB = Buffer.from("task020-operation-key-B-material-32-bytes");
    const token = createLaterUserVerificationOperationToken({
      keyMaterial: keyA,
      keyVersion: "v1",
      operationId: verificationOperationId,
    });
    const keysAfterRotation = new Map<string, Uint8Array>([
      ["v1", keyA],
      ["v2", keyB],
    ]);
    const resolvedVersions: string[] = [];

    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) => {
          resolvedVersions.push(keyVersion);
          return keysAfterRotation.get(keyVersion) ?? null;
        },
        token,
      }),
    ).toBe(verificationOperationId);
    expect(resolvedVersions).toEqual(["v1"]);
  });

  it("T020-D-IDEMP-004 fails closed for an unknown embedded key version", () => {
    const token = createLaterUserVerificationOperationToken({
      keyMaterial: challengeKey,
      keyVersion: "v3",
      operationId: verificationOperationId,
    });

    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) =>
          keyVersion === "v1" ? challengeKey : null,
        token,
      }),
    ).toBeNull();
  });

  it("T020-D-IDEMP-005 fails closed for a wrong key or tampered key version", () => {
    const keyA = Buffer.from("task020-operation-key-A-material-32-bytes");
    const keyB = Buffer.from("task020-operation-key-B-material-32-bytes");
    const token = createLaterUserVerificationOperationToken({
      keyMaterial: keyA,
      keyVersion: "v1",
      operationId: verificationOperationId,
    });

    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: () => keyB,
        token,
      }),
    ).toBeNull();
    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) =>
          new Map<string, Uint8Array>([
            ["v1", keyA],
            ["v2", keyB],
          ]).get(keyVersion) ?? null,
        token: token.replace(/^v1\./, "v2."),
      }),
    ).toBeNull();
  });

  it("T020-D-IDEMP-006 never treats the non-secret version identifier as HMAC key material", () => {
    const token = createLaterUserVerificationOperationToken({
      keyMaterial: challengeKey,
      keyVersion: "v1",
      operationId: verificationOperationId,
    });

    expect(
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) =>
          Buffer.from(keyVersion.repeat(32), "utf8"),
        token,
      }),
    ).toBeNull();
  });
});
