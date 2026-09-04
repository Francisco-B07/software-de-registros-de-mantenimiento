import { createSupabaseServerClient } from "@infrastructure/supabase/server";

import type { CurrentGlobalAuthorizationSource } from "../../application/resolve-current-global-authorization";

export async function createSupabaseCurrentGlobalAuthorizationSource(): Promise<CurrentGlobalAuthorizationSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async resolveCurrentGlobalAuthority() {
      const response = await supabase.rpc("resolve_current_global_authority");

      if (response.error !== null) {
        throw new Error("Current global authority could not be resolved.");
      }

      return response.data;
    },
  });
}
