import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "../../../../infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "../../../../infrastructure/config/supabase-public";

import type { FirstAdminAuthTechnicalPasswordStateSource } from "../../application/first-admin-onboarding";

export function createSupabaseFirstAdminAuthTechnicalPasswordStateSource(): FirstAdminAuthTechnicalPasswordStateSource {
  const { supabaseSecretKey } = getPrivateAuthConfig();
  const { url } = getSupabasePublicConfig();
  const client = createClient(url, supabaseSecretKey, {
    auth: {
      autoRefreshToken: false,
      detectSessionInUrl: false,
      persistSession: false,
    },
  });

  return Object.freeze({
    async resolveTechnicalPasswordState(authBridgeCredentialId: string) {
      const response = await client.rpc(
        "resolve_first_admin_auth_bridge_technical_password_state",
        {
          p_auth_bridge_credential_id: authBridgeCredentialId,
        },
      );

      if (response.error !== null) {
        throw new Error(
          "First-admin technical-password state resolution failed.",
        );
      }

      return response.data;
    },
  });
}
