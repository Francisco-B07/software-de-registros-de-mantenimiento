import { createClient } from "@supabase/supabase-js";

import { getSupabasePublicConfig } from "../../../../infrastructure/config/supabase-public";

import type {
  TechnicalSignInInput,
  TechnicalSignInResult,
} from "../../application/auth-session-bridge";
import { preserveTechnicalSessionCandidate } from "./technical-session-candidate-server-vault";

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const AUTH_DENIED_OR_UNAVAILABLE_CODES = new Set([
  "captcha_failed",
  "email_not_confirmed",
  "email_provider_disabled",
  "hook_payload_invalid_content_type",
  "hook_payload_over_size_limit",
  "over_request_rate_limit",
  "provider_disabled",
  "user_banned",
]);

function boundedResult(
  outcome:
    | "DEFINITE_CREDENTIAL_FAILURE"
    | "AUTH_DENIED_OR_UNAVAILABLE"
    | "AMBIGUOUS_FAILURE",
): TechnicalSignInResult {
  return Object.freeze({ outcome });
}

function classifyAuthError(error: unknown): TechnicalSignInResult {
  if (typeof error !== "object" || error === null) {
    return boundedResult("AMBIGUOUS_FAILURE");
  }

  const code = Reflect.get(error, "code");
  if (code === "invalid_credentials") {
    return boundedResult("DEFINITE_CREDENTIAL_FAILURE");
  }

  if (
    typeof code === "string" &&
    AUTH_DENIED_OR_UNAVAILABLE_CODES.has(code)
  ) {
    return boundedResult("AUTH_DENIED_OR_UNAVAILABLE");
  }

  return boundedResult("AMBIGUOUS_FAILURE");
}

function isNonEmptyString(value: unknown): value is string {
  return (
    typeof value === "string" && value.length > 0 && value.trim() === value
  );
}

export function createSupabaseTechnicalSignInBoundary() {
  const { publishableKey, url } = getSupabasePublicConfig();
  const client = createClient(url, publishableKey, {
    auth: {
      autoRefreshToken: false,
      detectSessionInUrl: false,
      persistSession: false,
    },
  });

  return Object.freeze({
    async signIn(input: TechnicalSignInInput): Promise<TechnicalSignInResult> {
      try {
        const response = await client.auth.signInWithPassword({
          email: input.email,
          password: input.technicalPassword,
        });

        if (response.error) {
          return classifyAuthError(response.error);
        }

        const user = response.data?.user;
        const session = response.data?.session;
        if (
          !UUID_PATTERN.test(user?.id ?? "") ||
          session === null ||
          session === undefined ||
          !UUID_PATTERN.test(session.user?.id ?? "") ||
          user?.id.toLowerCase() !== session.user.id.toLowerCase() ||
          !isNonEmptyString(session.access_token) ||
          !isNonEmptyString(session.refresh_token) ||
          session.token_type !== "bearer" ||
          typeof session.expires_in !== "number" ||
          !Number.isFinite(session.expires_in) ||
          session.expires_in <= 0
        ) {
          return boundedResult("AMBIGUOUS_FAILURE");
        }

        return Object.freeze({
          authUserId: user.id.toLowerCase(),
          outcome: "SESSION_CANDIDATE",
          sessionCandidate: preserveTechnicalSessionCandidate(session),
        });
      } catch {
        return boundedResult("AMBIGUOUS_FAILURE");
      }
    },
  });
}
