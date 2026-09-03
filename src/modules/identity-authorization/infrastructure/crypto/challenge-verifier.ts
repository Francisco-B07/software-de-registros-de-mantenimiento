import { createHmac, timingSafeEqual } from "node:crypto";

const CHALLENGE_DOMAIN = "verification-challenge:v1";
const SHA_256_BYTES = 32;

function serialize(parts: readonly string[]): Buffer {
  const encodedParts = parts.map((part) => Buffer.from(part, "utf8"));
  const buffers: Buffer[] = [];

  for (const part of encodedParts) {
    const length = Buffer.allocUnsafe(4);
    length.writeUInt32BE(part.byteLength);
    buffers.push(length, part);
  }

  return Buffer.concat(buffers);
}

export function createChallengeVerifier(input: Readonly<{
  challengeId: string;
  code: string;
  keyMaterial: Uint8Array;
}>): Uint8Array {
  if (!input.challengeId || !input.code || input.keyMaterial.byteLength < 32) {
    throw new Error("Challenge verifier could not be created.");
  }

  return new Uint8Array(
    createHmac("sha256", input.keyMaterial)
      .update(serialize([CHALLENGE_DOMAIN, input.challengeId, input.code]))
      .digest(),
  );
}

export function compareChallengeVerifiers(
  storedVerifier: Uint8Array,
  candidateVerifier: Uint8Array,
): boolean {
  if (
    storedVerifier.byteLength !== SHA_256_BYTES ||
    candidateVerifier.byteLength !== SHA_256_BYTES
  ) {
    throw new Error("Challenge verifier comparison denied.");
  }

  return timingSafeEqual(
    Buffer.from(storedVerifier),
    Buffer.from(candidateVerifier),
  );
}
