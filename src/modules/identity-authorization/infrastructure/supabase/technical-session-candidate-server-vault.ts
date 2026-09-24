import type { AuthSession } from "@supabase/supabase-js";

import {
  genericAuthBridgeDenial,
  type TechnicalSessionCandidate,
} from "../../application/auth-session-bridge";

/**
 * Server-only, in-process storage for the provider session candidate.
 *
 * This narrow module follows the repository's private server-adapter boundary:
 * it is not re-exported through a client-safe surface, and static boundary tests
 * prohibit imports from the repository-classified client-safe source trees.
 */
const technicalSessionCandidates = new WeakMap<
  TechnicalSessionCandidate,
  AuthSession
>();

export function preserveTechnicalSessionCandidate(
  providerSession: AuthSession,
): TechnicalSessionCandidate {
  const candidate = Object.freeze(
    Object.create(null) as TechnicalSessionCandidate,
  );
  technicalSessionCandidates.set(candidate, providerSession);
  return candidate;
}

export function readTechnicalSessionCandidate(
  candidate: TechnicalSessionCandidate,
): AuthSession {
  const providerSession = technicalSessionCandidates.get(candidate);
  if (!providerSession) {
    throw genericAuthBridgeDenial();
  }

  return providerSession;
}
