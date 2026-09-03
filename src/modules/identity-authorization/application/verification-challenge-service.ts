import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "@infrastructure/config/auth-private";

import {
  compareChallengeVerifiers,
  createChallengeVerifier,
} from "../infrastructure/crypto/challenge-verifier";
import { createSupabaseVerificationChallengeStore } from "../infrastructure/supabase/verification-challenge-store";
import {
  genericVerificationDenial,
  type IssueVerificationChallengeInput,
  type ResendVerificationChallengeInput,
  type VerificationAttemptOutcome,
  type VerifyVerificationChallengeInput,
} from "./verification-challenge";

type ChallengeStore = ReturnType<
  typeof createSupabaseVerificationChallengeStore
>;

function createVerifier(
  challengeId: string,
  code: string,
  version: string,
  keys: ReadonlyMap<string, Uint8Array>,
): Uint8Array {
  return createChallengeVerifier({
    challengeId,
    code,
    keyMaterial: resolvePrivateKey(keys, version),
  });
}

export function createVerificationChallengeService(
  store: ChallengeStore = createSupabaseVerificationChallengeStore(),
) {
  return Object.freeze({
    async issue(input: IssueVerificationChallengeInput) {
      try {
        const config = getPrivateAuthConfig();
        const verifier = createVerifier(
          input.challengeId,
          input.code,
          config.challengeHmacActiveVersion,
          config.challengeHmacKeys,
        );

        return await store.issue({
          challengeId: input.challengeId,
          email: input.email,
          operationId: input.operationId,
          verifier,
          verifierKeyVersion: config.challengeHmacActiveVersion,
        });
      } catch {
        throw genericVerificationDenial();
      }
    },

    async resend(input: ResendVerificationChallengeInput) {
      try {
        const config = getPrivateAuthConfig();
        const verifier = createVerifier(
          input.challengeId,
          input.code,
          config.challengeHmacActiveVersion,
          config.challengeHmacKeys,
        );

        return await store.resend({
          challengeId: input.challengeId,
          email: input.email,
          operationId: input.operationId,
          predecessorChallengeId: input.predecessorChallengeId,
          verifier,
          verifierKeyVersion: config.challengeHmacActiveVersion,
        });
      } catch {
        throw genericVerificationDenial();
      }
    },

    async verify(
      input: VerifyVerificationChallengeInput,
    ): Promise<VerificationAttemptOutcome> {
      try {
        const config = getPrivateAuthConfig();
        const material = await store.getMaterial(input.challengeId, input.email);
        const candidate = createVerifier(
          input.challengeId,
          input.code,
          material.verifierKeyVersion,
          config.challengeHmacKeys,
        );
        const matched = compareChallengeVerifiers(
          material.verifier,
          candidate,
        );

        return await store.verifyTransition({
          challengeId: input.challengeId,
          email: input.email,
          matched,
          operationId: input.operationId,
          technicalPasswordKeyVersion:
            config.technicalPasswordActiveVersion,
        });
      } catch {
        throw genericVerificationDenial();
      }
    },
  });
}
