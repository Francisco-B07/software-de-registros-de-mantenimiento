import { createSupabaseServerClient } from "@infrastructure/supabase/server";

import type { CurrentAuthorizationSource } from "../../application/resolve-current-authorization-context";

function dataOrThrow(response: {
  readonly data: unknown;
  readonly error: unknown;
}): unknown {
  if (response.error !== null) {
    throw new Error("Current authorization state could not be resolved.");
  }

  return response.data;
}

export async function createSupabaseCurrentAuthorizationSource(): Promise<CurrentAuthorizationSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async findAuthSubjectMappings(authSubject: string) {
      const response = await supabase
        .from("platform_user_auth_subjects")
        .select("auth_subject_id, platform_user_id")
        .eq("auth_subject_id", authSubject)
        .limit(2);

      return dataOrThrow(response);
    },

    async findPlatformUsers(platformUserId: string) {
      const response = await supabase
        .from("platform_users")
        .select("id")
        .eq("id", platformUserId)
        .limit(2);

      return dataOrThrow(response);
    },

    async findCompanyMemberships(platformUserId: string) {
      const response = await supabase
        .from("company_memberships")
        .select(
          "id, platform_user_id, maintenance_company_id, role, is_enabled",
        )
        .eq("platform_user_id", platformUserId)
        .limit(2);

      return dataOrThrow(response);
    },

    async findMaintenanceCompanies(maintenanceCompanyId: string) {
      const response = await supabase
        .from("maintenance_companies")
        .select("id")
        .eq("id", maintenanceCompanyId)
        .limit(2);

      return dataOrThrow(response);
    },
  });
}
