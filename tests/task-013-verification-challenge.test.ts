import { readFileSync } from "node:fs";

import { describe, expect, it, vi } from "vitest";

import {
  DEVELOPMENT_PASSWORD_POLICY,
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../src/infrastructure/config/auth-private";
import {
  assertAuthBridgeReadyForSignIn,
  genericAuthBridgeDenial,
} from "../src/modules/identity-authorization/application/auth-session-bridge";
import { genericVerificationDenial } from "../src/modules/identity-authorization/application/verification-challenge";
import {
  compareChallengeVerifiers,
  createChallengeVerifier,
} from "../src/modules/identity-authorization/infrastructure/crypto/challenge-verifier";
import {
  createTechnicalPasswordSeed,
  deriveTechnicalPassword,
  encodeTechnicalPassword,
} from "../src/modules/identity-authorization/infrastructure/crypto/technical-password";

const challengeId = "00000000-0000-4000-8000-000000013001";
const bridgeId = "00000000-0000-4000-8000-000000013101";
const challengeKey = Buffer.from("challenge-secret-material-32-bytes!!");
const technicalKey = Buffer.from("technical-secret-material-32-bytes!!");

function challenge(code = "opaque-code", keyMaterial = challengeKey) {
  return createChallengeVerifier({ challengeId, code, keyMaterial });
}

function technicalPassword(keyMaterial = technicalKey) {
  return deriveTechnicalPassword({
    authBridgeCredentialId: bridgeId,
    keyMaterial,
    policy: DEVELOPMENT_PASSWORD_POLICY,
  });
}

describe("TASK-013 verification challenge foundation", () => {
  it("T013-TS-001 produces the deterministic challenge HMAC vector", () => {
    expect(Buffer.from(challenge()).toString("hex")).toBe(
      "1fb2a6bf838d32e9eaa609f68343cdc8d410ceaece77fb996aabda49ead7d849",
    );
  });

  it("T013-TS-002 domain-separates challenge payloads", () => {
    expect(Buffer.from(challenge("opaque-code-v2")).toString("hex")).not.toBe(
      Buffer.from(challenge()).toString("hex"),
    );
  });

  it("T013-TS-003 resolves persisted versions to secret material", () => {
    const keys = new Map([
      ["v1", new Uint8Array(challengeKey)],
      ["v2", new Uint8Array(Buffer.from("second-challenge-secret-material-32!!"))],
    ]);

    expect(resolvePrivateKey(keys, "v1")).toEqual(new Uint8Array(challengeKey));
    expect(resolvePrivateKey(keys, "v2")).not.toEqual(Buffer.from("v2"));
  });

  it("T013-TS-004 fails closed for unknown or unavailable versions", () => {
    expect(() => resolvePrivateKey(new Map(), "v9")).toThrow(
      "Required private authentication key version is unavailable.",
    );
  });

  it("T013-TS-005 retains old challenge keys during rotation", () => {
    const keys = new Map([
      ["v1", new Uint8Array(challengeKey)],
      ["v2", new Uint8Array(Buffer.from("second-challenge-secret-material-32!!"))],
    ]);
    expect(resolvePrivateKey(keys, "v1")).toHaveLength(challengeKey.length);
  });

  it("T013-TS-006 stores a 32-byte SHA-256 digest", () => {
    expect(challenge()).toHaveLength(32);
  });

  it("T013-TS-007 creates a 32-byte candidate digest", () => {
    expect(challenge("candidate")).toHaveLength(32);
  });

  it("T013-TS-008 accepts equal fixed-length verifiers", () => {
    expect(compareChallengeVerifiers(challenge(), challenge())).toBe(true);
  });

  it("T013-TS-009 rejects different fixed-length verifiers", () => {
    expect(compareChallengeVerifiers(challenge(), challenge("wrong"))).toBe(false);
  });

  it("T013-TS-010 fails closed for corrupt verifier lengths", () => {
    expect(() => compareChallengeVerifiers(new Uint8Array(31), challenge())).toThrow(
      "Challenge verifier comparison denied.",
    );
  });

  it("T013-TS-011 uses the approved constant-time primitive", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/crypto/challenge-verifier.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).toContain("timingSafeEqual");
    expect(source).not.toMatch(/Buffer\.equals|storedVerifier\s*===/);
  });

  it("T013-TS-012 produces the deterministic technical-password seed vector", () => {
    const seed = createTechnicalPasswordSeed({
      authBridgeCredentialId: bridgeId,
      keyMaterial: technicalKey,
    });
    expect(Buffer.from(seed).toString("hex")).toBe(
      "f97c832ccab7db58691e11e99e4c08cc784c930fcd64d43fbf44b87080f5d913",
    );
  });

  it("T013-TS-013 encodes the verified Hosted policy contract", () => {
    expect(DEVELOPMENT_PASSWORD_POLICY).toEqual({
      minimumLength: 6,
      requiredDigits: false,
      requiredLowercase: false,
      requiredSymbols: false,
      requiredUppercase: false,
      verified: true,
    });
  });

  it("T013-TS-014 derives deterministic technical passwords", () => {
    expect(technicalPassword()).toBe(technicalPassword());
  });

  it("T013-TS-015 exceeds the canonical minimum length", () => {
    expect(technicalPassword().length).toBeGreaterThanOrEqual(6);
  });

  it("T013-TS-016 guarantees lowercase when a verified policy requires it", () => {
    const password = encodeTechnicalPassword(
      createTechnicalPasswordSeed({ authBridgeCredentialId: bridgeId, keyMaterial: technicalKey }),
      { ...DEVELOPMENT_PASSWORD_POLICY, requiredLowercase: true },
    );
    expect(password).toMatch(/[a-z]/);
  });

  it("T013-TS-017 guarantees uppercase when a verified policy requires it", () => {
    const password = encodeTechnicalPassword(
      createTechnicalPasswordSeed({ authBridgeCredentialId: bridgeId, keyMaterial: technicalKey }),
      { ...DEVELOPMENT_PASSWORD_POLICY, requiredUppercase: true },
    );
    expect(password).toMatch(/[A-Z]/);
  });

  it("T013-TS-018 guarantees digits when a verified policy requires them", () => {
    const password = encodeTechnicalPassword(
      createTechnicalPasswordSeed({ authBridgeCredentialId: bridgeId, keyMaterial: technicalKey }),
      { ...DEVELOPMENT_PASSWORD_POLICY, requiredDigits: true },
    );
    expect(password).toMatch(/[0-9]/);
  });

  it("T013-TS-019 guarantees symbols when a verified policy requires them", () => {
    const password = encodeTechnicalPassword(
      createTechnicalPasswordSeed({ authBridgeCredentialId: bridgeId, keyMaterial: technicalKey }),
      { ...DEVELOPMENT_PASSWORD_POLICY, requiredSymbols: true },
    );
    expect(password).toMatch(/[!@#$%^&*()_+\-=\[\]{};,.?]/);
  });

  it("T013-TS-020 rejects an unverifiable policy", () => {
    const seed = createTechnicalPasswordSeed({
      authBridgeCredentialId: bridgeId,
      keyMaterial: technicalKey,
    });
    expect(() =>
      Reflect.apply(encodeTechnicalPassword, null, [
        seed,
        { ...DEVELOPMENT_PASSWORD_POLICY, verified: false },
      ]),
    ).toThrow("Canonical password policy could not be verified.");
  });

  it("T013-TS-021 reproduces the same password for the same bridge and key", () => {
    expect(technicalPassword()).toEqual(technicalPassword());
  });

  it("T013-TS-022 separates challenge and technical-password keys", () => {
    const alternate = Buffer.from("different-technical-secret-material-32!");
    expect(technicalPassword(alternate)).not.toBe(technicalPassword());
    expect(Buffer.from(challenge()).toString("hex")).not.toBe(
      Buffer.from(createTechnicalPasswordSeed({ authBridgeCredentialId: bridgeId, keyMaterial: technicalKey })).toString("hex"),
    );
  });

  it("T013-TS-023 never logs technical-password output", () => {
    const log = vi.spyOn(console, "log").mockImplementation(() => undefined);
    technicalPassword();
    expect(log).not.toHaveBeenCalled();
    log.mockRestore();
  });

  it("T013-TS-024 never logs challenge codes", () => {
    const log = vi.spyOn(console, "log").mockImplementation(() => undefined);
    challenge("private-code");
    expect(log).not.toHaveBeenCalled();
    log.mockRestore();
  });

  it("T013-TS-025 sanitizes config errors without echoing secret values", () => {
    const secret = "short-secret-value";
    expect(() =>
      getPrivateAuthConfig({
        AUTH_CHALLENGE_HMAC_ACTIVE_VERSION: "v1",
        AUTH_CHALLENGE_HMAC_KEY_V1: secret,
        AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION: "v1",
        AUTH_TECHNICAL_PASSWORD_KEY_V1: "technical-key-material-at-least-32-bytes",
        SUPABASE_SECRET_KEY: "sb_secret_fixture",
      }),
    ).toThrowError(expect.not.objectContaining({ message: expect.stringContaining(secret) }));
  });

  it("T013-TS-026 keeps private config out of client-safe infrastructure", () => {
    const browserSource = readFileSync(
      new URL("../src/infrastructure/supabase/browser.ts", import.meta.url),
      "utf8",
    );
    expect(browserSource).not.toMatch(/auth-private|SUPABASE_SECRET_KEY/);
  });

  it("T013-TS-027 limits Auth Admin to createUser and updateUserById", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/auth-admin-boundary.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source).toContain("admin.createUser");
    expect(source).toContain("admin.updateUserById");
    expect(source).not.toMatch(/listUsers|deleteUser|generateLink/);
  });

  it("T013-TS-028 exports no generic privileged client", () => {
    const source = readFileSync(
      new URL("../src/modules/identity-authorization/server.ts", import.meta.url),
      "utf8",
    );
    expect(source).not.toMatch(/getAdminClient|createPrivilegedSupabaseClient|raw.*client/i);
  });

  it("T013-TS-029 technical sign-in uses publishable nonprivileged semantics", () => {
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

  it("T013-TS-030 requires operation IDs in challenge contracts", () => {
    const source = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/verification-challenge.ts",
        import.meta.url,
      ),
      "utf8",
    );
    expect(source.match(/operationId: string/g)).toHaveLength(2);
  });

  it("T013-TS-031 maps verification denials generically", () => {
    expect(genericVerificationDenial().message).toBe("Verification request denied.");
  });

  it("T013-TS-032 does not enumerate email or challenge state", () => {
    expect(genericVerificationDenial().message).not.toMatch(/email|missing|expired|attempt/i);
  });

  it("T013-TS-033 maps provider failures generically", () => {
    expect(genericAuthBridgeDenial().message).toBe(
      "Authentication bridge operation denied.",
    );
  });

  it("T013-TS-034 denies sign-in while rotation is pending", () => {
    expect(() => assertAuthBridgeReadyForSignIn("v2")).toThrow(
      "Authentication bridge operation denied.",
    );
    expect(() => assertAuthBridgeReadyForSignIn(null)).not.toThrow();
  });

  it("T013-TS-035 performs no network operation in the unit suite", () => {
    const source = readFileSync(new URL(import.meta.url), "utf8");
    expect(source).not.toMatch(/fetch\s*\(|createClient\s*\(/);
  });
});
