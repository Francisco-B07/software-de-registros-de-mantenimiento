import { createSupabaseServerClient } from "../../../../infrastructure/supabase/server";

import type { LaterUserEnrollmentMutationSource } from "../../application/later-user-enrollment";

function bytea(value: Uint8Array): string {
  return `\\x${Buffer.from(value).toString("hex")}`;
}

export async function createSupabaseLaterUserEnrollmentMutationSource(): Promise<LaterUserEnrollmentMutationSource> {
  const supabase = await createSupabaseServerClient();

  return Object.freeze({
    async establish(
      input: Parameters<LaterUserEnrollmentMutationSource["establish"]>[0],
    ) {
      const response = await supabase.rpc(
        "establish_later_user_enrollment_intent",
        {
          p_challenge_id: input.challengeId,
          p_establishment_operation_id: input.establishmentOperationId,
          p_intended_role: input.intendedRole,
          p_intent_id: input.intentId,
          p_issue_operation_id: input.issueOperationId,
          p_target_email: input.email,
          p_verifier: bytea(input.verifier),
          p_verifier_key_version: input.verifierKeyVersion,
        },
      );

      if (response.error !== null) {
        throw new Error("Later-user enrollment mutation was not confirmed.");
      }
      return response.data;
    },

    async resend(
      input: Parameters<LaterUserEnrollmentMutationSource["resend"]>[0],
    ) {
      const response = await supabase.rpc(
        "resend_later_user_enrollment_challenge",
        {
          p_challenge_id: input.challengeId,
          p_intent_id: input.intentId,
          p_issue_operation_id: input.issueOperationId,
          p_verifier: bytea(input.verifier),
          p_verifier_key_version: input.verifierKeyVersion,
        },
      );

      if (response.error !== null) {
        throw new Error("Later-user enrollment mutation was not confirmed.");
      }
      return response.data;
    },
  });
}
