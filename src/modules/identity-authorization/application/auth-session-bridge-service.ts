import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "@infrastructure/config/auth-private";

import { deriveTechnicalPassword } from "../infrastructure/crypto/technical-password";
import { createSupabaseAuthAdminBoundary } from "../infrastructure/supabase/auth-admin-boundary";
import { createSupabaseTechnicalSignInBoundary } from "../infrastructure/supabase/technical-sign-in";
import {
  assertAuthBridgeReadyForSignIn,
  genericAuthBridgeDenial,
  type AuthProvisioningResult,
} from "./auth-session-bridge";

type AdminBoundary = ReturnType<typeof createSupabaseAuthAdminBoundary>;
type SignInBoundary = ReturnType<typeof createSupabaseTechnicalSignInBoundary>;

export type EstablishTechnicalIdentityInput = Readonly<{
  authBridgeCredentialId: string;
  authUserId: string | null;
  email: string;
  pendingKeyVersion: string | null;
  technicalPasswordKeyVersion: string;
}>;

export function createAuthSessionBridgeService(
  adminBoundary: AdminBoundary = createSupabaseAuthAdminBoundary(),
  signInBoundary: SignInBoundary = createSupabaseTechnicalSignInBoundary(),
) {
  return Object.freeze({
    async establishTechnicalIdentity(
      input: EstablishTechnicalIdentityInput,
    ): Promise<AuthProvisioningResult> {
      try {
        assertAuthBridgeReadyForSignIn(input.pendingKeyVersion);
        const config = getPrivateAuthConfig();
        const technicalPassword = deriveTechnicalPassword({
          authBridgeCredentialId: input.authBridgeCredentialId,
          keyMaterial: resolvePrivateKey(
            config.technicalPasswordKeys,
            input.technicalPasswordKeyVersion,
          ),
          policy: config.passwordPolicy,
        });

        if (input.authUserId !== null) {
          const signedIn = await signInBoundary.signIn({
            email: input.email,
            technicalPassword,
          });

          if (signedIn.authUserId !== input.authUserId) {
            throw genericAuthBridgeDenial();
          }

          return signedIn;
        }

        try {
          return await signInBoundary.signIn({
            email: input.email,
            technicalPassword,
          });
        } catch {
          const created = await adminBoundary.createVerifiedEmailUser({
            email: input.email,
            technicalPassword,
          });
          const signedIn = await signInBoundary.signIn({
            email: input.email,
            technicalPassword,
          });

          if (signedIn.authUserId !== created.authUserId) {
            throw genericAuthBridgeDenial();
          }

          return signedIn;
        }
      } catch {
        throw genericAuthBridgeDenial();
      }
    },
  });
}
