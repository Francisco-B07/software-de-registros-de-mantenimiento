import { createSupabaseServerClient } from "../../../../infrastructure/supabase/server";

import type { FirstAdminOnboardingMutationSource } from "../../application/first-admin-onboarding";

function bytea(value: Uint8Array): string {
  return `\\x${Buffer.from(value).toString("hex")}`;
}

export async function createSupabaseFirstAdminOnboardingMutationSource(): Promise<FirstAdminOnboardingMutationSource> {
  const supabase = await createSupabaseServerClient();

  const source: FirstAdminOnboardingMutationSource = {
    async establish(input) {
      const response = await supabase.rpc(
        "establish_first_admin_onboarding_intent",
        {
          p_challenge_id: input.challengeId,
          p_establishment_operation_id: input.establishmentOperationId,
          p_intent_id: input.intentId,
          p_issue_operation_id: input.issueOperationId,
          p_maintenance_company_id: input.maintenanceCompanyId,
          p_target_email: input.email,
          p_verifier: bytea(input.verifier),
          p_verifier_key_version: input.verifierKeyVersion,
        },
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding mutation was not confirmed.");
      }

      return response.data;
    },

    async resend(input) {
      const response = await supabase.rpc(
        "resend_first_admin_onboarding_challenge",
        {
          p_challenge_id: input.challengeId,
          p_intent_id: input.intentId,
          p_issue_operation_id: input.issueOperationId,
          p_verifier: bytea(input.verifier),
          p_verifier_key_version: input.verifierKeyVersion,
        },
      );

      if (response.error !== null) {
        throw new Error("First-admin onboarding mutation was not confirmed.");
      }

      return response.data;
    },
  };

  return Object.freeze(source);
}
