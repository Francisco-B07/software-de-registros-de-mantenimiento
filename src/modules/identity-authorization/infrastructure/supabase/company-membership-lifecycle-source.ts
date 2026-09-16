import { createSupabaseServerClient } from "@infrastructure/supabase/server";

import type {
  CompanyMembershipLifecycleCommand,
  CompanyMembershipLifecycleSource,
} from "../../application/apply-company-membership-lifecycle";

export async function createSupabaseCompanyMembershipLifecycleSource(): Promise<CompanyMembershipLifecycleSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async apply(command: CompanyMembershipLifecycleCommand) {
      const response = await supabase.rpc("apply_company_membership_lifecycle", {
        p_operation: command.operation,
        p_requested_role: command.requestedRole,
        p_target_company_membership_id: command.targetCompanyMembershipId,
      });

      if (response.error !== null) {
        throw new Error("Company membership lifecycle operation failed.");
      }

      return response.data;
    },
  });
}
