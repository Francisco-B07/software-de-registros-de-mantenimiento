import { createHmac } from "node:crypto";

import type { VerifiedPasswordPolicy } from "@infrastructure/config/auth-private";

const TECHNICAL_PASSWORD_DOMAIN = "auth-technical-password:v1";
const BASE_OUTPUT_LENGTH = 43;
const CHARSETS = Object.freeze({
  digit: "0123456789",
  lowercase: "abcdefghijklmnopqrstuvwxyz",
  symbol: "!@#$%^&*()_+-=[]{};,.?",
  uppercase: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
});

function deterministicCharacter(
  seed: Uint8Array,
  offset: number,
  charset: string,
): string {
  return charset[seed[offset % seed.byteLength] % charset.length] ?? charset[0];
}

export function createTechnicalPasswordSeed(input: Readonly<{
  authBridgeCredentialId: string;
  keyMaterial: Uint8Array;
}>): Uint8Array {
  if (!input.authBridgeCredentialId || input.keyMaterial.byteLength < 32) {
    throw new Error("Technical password seed could not be created.");
  }

  const payload = JSON.stringify([
    TECHNICAL_PASSWORD_DOMAIN,
    input.authBridgeCredentialId,
  ]);

  return new Uint8Array(
    createHmac("sha256", input.keyMaterial).update(payload, "utf8").digest(),
  );
}

export function encodeTechnicalPassword(
  seed: Uint8Array,
  policy: VerifiedPasswordPolicy,
): string {
  if (
    !policy.verified ||
    !Number.isInteger(policy.minimumLength) ||
    policy.minimumLength < 6 ||
    seed.byteLength !== 32
  ) {
    throw new Error("Canonical password policy could not be verified.");
  }

  let output = Buffer.from(seed).toString("base64url");
  let expansionCounter = 0;

  while (output.length < Math.max(BASE_OUTPUT_LENGTH, policy.minimumLength)) {
    const expansion = createHmac("sha256", seed)
      .update(`technical-password-expansion:${expansionCounter}`, "utf8")
      .digest("base64url");
    output += expansion;
    expansionCounter += 1;
  }

  const characters = output.slice(0, Math.max(BASE_OUTPUT_LENGTH, policy.minimumLength)).split("");
  const required = [
    [policy.requiredLowercase, CHARSETS.lowercase],
    [policy.requiredUppercase, CHARSETS.uppercase],
    [policy.requiredDigits, CHARSETS.digit],
    [policy.requiredSymbols, CHARSETS.symbol],
  ] as const;
  let offset = 0;

  for (const [isRequired, charset] of required) {
    if (isRequired) {
      characters[offset] = deterministicCharacter(seed, offset, charset);
      offset += 1;
    }
  }

  return characters.join("");
}

export function deriveTechnicalPassword(input: Readonly<{
  authBridgeCredentialId: string;
  keyMaterial: Uint8Array;
  policy: VerifiedPasswordPolicy;
}>): string {
  return encodeTechnicalPassword(
    createTechnicalPasswordSeed(input),
    input.policy,
  );
}
