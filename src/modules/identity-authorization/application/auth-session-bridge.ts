export type AuthProvisioningResult = Readonly<{
  authUserId: string;
}>;

export type CreateAuthUserInput = Readonly<{
  email: string;
  technicalPassword: string;
}>;

export type UpdateTechnicalPasswordInput = Readonly<{
  authUserId: string;
  technicalPassword: string;
}>;

export type TechnicalSignInInput = Readonly<{
  email: string;
  technicalPassword: string;
}>;

declare const technicalSessionCandidateBrand: unique symbol;

/**
 * An opaque reference to a provider session held by server-only infrastructure.
 * The handle carries no provider session fields or session-reading capability.
 */
export type TechnicalSessionCandidate = Readonly<{
  [technicalSessionCandidateBrand]: true;
}>;

export type TechnicalSignInResult =
  | Readonly<{
      authUserId: string;
      outcome: "SESSION_CANDIDATE";
      sessionCandidate: TechnicalSessionCandidate;
    }>
  | Readonly<{ outcome: "DEFINITE_CREDENTIAL_FAILURE" }>
  | Readonly<{ outcome: "AUTH_DENIED_OR_UNAVAILABLE" }>
  | Readonly<{ outcome: "AMBIGUOUS_FAILURE" }>;

export function genericAuthBridgeDenial(): Error {
  return new Error("Authentication bridge operation denied.");
}

export function assertAuthBridgeReadyForSignIn(
  pendingKeyVersion: string | null,
): void {
  if (pendingKeyVersion !== null) {
    throw genericAuthBridgeDenial();
  }
}
