import { createClient } from "@supabase/supabase-js";

import { getPrivateAuthConfig } from "@infrastructure/config/auth-private";
import { getSupabasePublicConfig } from "@infrastructure/config/supabase-public";

import {
  genericAuthBridgeDenial,
  type AuthProvisioningResult,
  type CreateAuthUserInput,
  type UpdateTechnicalPasswordInput,
} from "../../application/auth-session-bridge";

export function createSupabaseAuthAdminBoundary() {
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
    async createVerifiedEmailUser(
      input: CreateAuthUserInput,
    ): Promise<AuthProvisioningResult> {
      const response = await client.auth.admin.createUser({
        email: input.email,
        email_confirm: true,
        password: input.technicalPassword,
      });

      if (response.error || !response.data.user?.id) {
        throw genericAuthBridgeDenial();
      }

      return Object.freeze({ authUserId: response.data.user.id });
    },

    async updateTechnicalPassword(
      input: UpdateTechnicalPasswordInput,
    ): Promise<AuthProvisioningResult> {
      const response = await client.auth.admin.updateUserById(input.authUserId, {
        password: input.technicalPassword,
      });

      if (response.error || !response.data.user?.id) {
        throw genericAuthBridgeDenial();
      }

      return Object.freeze({ authUserId: response.data.user.id });
    },
  });
}
