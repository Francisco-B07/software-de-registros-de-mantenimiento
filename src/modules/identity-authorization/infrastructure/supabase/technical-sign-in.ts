import { createClient } from "@supabase/supabase-js";

import { getSupabasePublicConfig } from "@infrastructure/config/supabase-public";

import {
  genericAuthBridgeDenial,
  type TechnicalSignInInput,
  type TechnicalSignInResult,
} from "../../application/auth-session-bridge";

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
      const response = await client.auth.signInWithPassword({
        email: input.email,
        password: input.technicalPassword,
      });

      if (response.error || !response.data.user?.id) {
        throw genericAuthBridgeDenial();
      }

      return Object.freeze({ authUserId: response.data.user.id });
    },
  });
}
