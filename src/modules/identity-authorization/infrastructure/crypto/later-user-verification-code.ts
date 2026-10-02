import { createHmac } from "node:crypto";

const CODE_DOMAIN = "later-user-verification-code:v1";

function encodePart(value: string): Buffer {
  const bytes = Buffer.from(value, "utf8");
  const length = Buffer.allocUnsafe(4);
  length.writeUInt32BE(bytes.byteLength);
  return Buffer.concat([length, bytes]);
}

export function createLaterUserVerificationCode(input: Readonly<{
  challengeId: string;
  issueOperationId: string;
  keyMaterial: Uint8Array;
}>): string {
  if (
    input.challengeId.length === 0 ||
    input.issueOperationId.length === 0 ||
    input.keyMaterial.byteLength < 32
  ) {
    throw new Error("Later-user verification code could not be created.");
  }

  return createHmac("sha256", input.keyMaterial)
    .update(encodePart(CODE_DOMAIN))
    .update(encodePart(input.challengeId))
    .update(encodePart(input.issueOperationId))
    .digest("base64url")
    .slice(0, 16);
}
