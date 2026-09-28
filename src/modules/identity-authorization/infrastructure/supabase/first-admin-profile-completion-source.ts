import { createSupabaseServerClient } from "../../../../infrastructure/supabase/server";

import type {
  FirstAdminProfileCompletionInput,
  FirstAdminProfileCompletionSource,
} from "../../application/first-admin-profile-completion";

export async function createSupabaseFirstAdminProfileCompletionSource(): Promise<FirstAdminProfileCompletionSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async complete(input: FirstAdminProfileCompletionInput) {
      const response = await supabase.rpc("complete_first_admin_onboarding", {
        p_first_name: input.firstName,
        p_last_name: input.lastName,
        p_operation_id: input.operationId,
      });

      if (response.error !== null) {
        throw new Error("First-admin profile completion RPC failed.");
      }

      return response.data;
    },

    async resolveState() {
      const response = await supabase.rpc(
        "resolve_current_first_admin_onboarding_state",
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding-state RPC failed.");
      }

      return response.data;
    },
  });
}
