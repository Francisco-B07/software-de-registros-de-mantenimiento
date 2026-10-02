import { createHmac, timingSafeEqual } from "node:crypto";

const OPERATION_DOMAIN = "task020-later-user-verification-operation:v1";
const KEY_VERSION_PATTERN = /^[A-Za-z0-9][A-Za-z0-9_-]{0,31}$/;
const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function signature(
  keyVersion: string,
  operationId: string,
  keyMaterial: Uint8Array,
): Buffer {
  return createHmac("sha256", keyMaterial)
    .update(OPERATION_DOMAIN, "utf8")
    .update("\u0000", "utf8")
    .update(keyVersion, "utf8")
    .update("\u0000", "utf8")
    .update(operationId, "utf8")
    .digest();
}

export function createLaterUserVerificationOperationToken(input: Readonly<{
  keyMaterial: Uint8Array;
  keyVersion: string;
  operationId: string;
}>): string {
  if (
    !UUID_PATTERN.test(input.operationId) ||
    !KEY_VERSION_PATTERN.test(input.keyVersion) ||
    input.keyMaterial.byteLength < 32
  ) {
    throw new Error("Later-user verification operation could not be issued.");
  }

  return [
    input.keyVersion,
    input.operationId.toLowerCase(),
    signature(
      input.keyVersion,
      input.operationId.toLowerCase(),
      input.keyMaterial,
    ).toString("base64url"),
  ].join(".");
}

export function resolveLaterUserVerificationOperationToken(input: Readonly<{
  resolveKeyMaterial: (keyVersion: string) => Uint8Array | null;
  token: string;
}>): string | null {
  const parts = input.token.split(".");
  if (
    parts.length !== 3 ||
    !KEY_VERSION_PATTERN.test(parts[0] ?? "") ||
    !UUID_PATTERN.test(parts[1] ?? "") ||
    !/^[A-Za-z0-9_-]{43}$/.test(parts[2] ?? "")
  ) {
    return null;
  }

  const keyVersion = parts[0] as string;
  const operationId = (parts[1] as string).toLowerCase();
  let keyMaterial: Uint8Array | null = null;
  try {
    keyMaterial = input.resolveKeyMaterial(keyVersion);
  } catch {
    return null;
  }
  if (keyMaterial === null || keyMaterial.byteLength < 32) {
    return null;
  }
  const received = Buffer.from(parts[2] as string, "base64url");
  const expected = signature(keyVersion, operationId, keyMaterial);

  return received.byteLength === expected.byteLength &&
    timingSafeEqual(received, expected)
    ? operationId
    : null;
}
