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

export type TechnicalSignInResult = Readonly<{
  authUserId: string;
}>;

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
