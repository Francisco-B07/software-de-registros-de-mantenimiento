export type VerifiedPasswordPolicy = Readonly<{
  minimumLength: number;
  requiredDigits: boolean;
  requiredLowercase: boolean;
  requiredSymbols: boolean;
  requiredUppercase: boolean;
  verified: true;
}>;

export type PrivateAuthConfig = Readonly<{
  challengeHmacActiveVersion: string;
  challengeHmacKeys: ReadonlyMap<string, Uint8Array>;
  passwordPolicy: VerifiedPasswordPolicy;
  supabaseSecretKey: string;
  technicalPasswordActiveVersion: string;
  technicalPasswordKeys: ReadonlyMap<string, Uint8Array>;
}>;

type PrivateAuthEnvironment = Readonly<{
  AUTH_CHALLENGE_HMAC_ACTIVE_VERSION?: string;
  AUTH_CHALLENGE_HMAC_KEY_V1?: string;
  AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION?: string;
  AUTH_TECHNICAL_PASSWORD_KEY_V1?: string;
  SUPABASE_SECRET_KEY?: string;
}>;

export const DEVELOPMENT_PASSWORD_POLICY: VerifiedPasswordPolicy =
  Object.freeze({
    minimumLength: 6,
    requiredDigits: false,
    requiredLowercase: false,
    requiredSymbols: false,
    requiredUppercase: false,
    verified: true,
  });

function requireValue(
  name: keyof PrivateAuthEnvironment,
  value: string | undefined,
): string {
  const normalized = value?.trim();

  if (!normalized) {
    throw new Error(`Missing required private authentication configuration: ${name}.`);
  }

  return normalized;
}

function requireKeyMaterial(
  name: keyof PrivateAuthEnvironment,
  value: string | undefined,
): Uint8Array {
  const normalized = requireValue(name, value);
  const material = Buffer.from(normalized, "utf8");

  if (material.byteLength < 32) {
    throw new Error(`Invalid private authentication key material: ${name}.`);
  }

  return new Uint8Array(material);
}

function requireKnownActiveVersion(
  name: keyof PrivateAuthEnvironment,
  value: string | undefined,
): string {
  const version = requireValue(name, value);

  if (version !== "v1") {
    throw new Error(`Unknown private authentication key version: ${name}.`);
  }

  return version;
}

export function getPrivateAuthConfig(
  environment: PrivateAuthEnvironment = {
    AUTH_CHALLENGE_HMAC_ACTIVE_VERSION:
      process.env.AUTH_CHALLENGE_HMAC_ACTIVE_VERSION,
    AUTH_CHALLENGE_HMAC_KEY_V1: process.env.AUTH_CHALLENGE_HMAC_KEY_V1,
    AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION:
      process.env.AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION,
    AUTH_TECHNICAL_PASSWORD_KEY_V1:
      process.env.AUTH_TECHNICAL_PASSWORD_KEY_V1,
    SUPABASE_SECRET_KEY: process.env.SUPABASE_SECRET_KEY,
  },
): PrivateAuthConfig {
  const challengeHmacActiveVersion = requireKnownActiveVersion(
    "AUTH_CHALLENGE_HMAC_ACTIVE_VERSION",
    environment.AUTH_CHALLENGE_HMAC_ACTIVE_VERSION,
  );
  const technicalPasswordActiveVersion = requireKnownActiveVersion(
    "AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION",
    environment.AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION,
  );

  return Object.freeze({
    challengeHmacActiveVersion,
    challengeHmacKeys: new Map([
      [
        "v1",
        requireKeyMaterial(
          "AUTH_CHALLENGE_HMAC_KEY_V1",
          environment.AUTH_CHALLENGE_HMAC_KEY_V1,
        ),
      ],
    ]),
    passwordPolicy: DEVELOPMENT_PASSWORD_POLICY,
    supabaseSecretKey: requireValue(
      "SUPABASE_SECRET_KEY",
      environment.SUPABASE_SECRET_KEY,
    ),
    technicalPasswordActiveVersion,
    technicalPasswordKeys: new Map([
      [
        "v1",
        requireKeyMaterial(
          "AUTH_TECHNICAL_PASSWORD_KEY_V1",
          environment.AUTH_TECHNICAL_PASSWORD_KEY_V1,
        ),
      ],
    ]),
  });
}

export function resolvePrivateKey(
  keys: ReadonlyMap<string, Uint8Array>,
  version: string,
): Uint8Array {
  const key = keys.get(version);

  if (!key) {
    throw new Error("Required private authentication key version is unavailable.");
  }

  return new Uint8Array(key);
}
