import type {
  CurrentAuthorizationResult,
  ValidatedAuthIdentity,
} from "./application/authorization-context";
import { resolveCurrentAuthorizationContextWithSource } from "./application/resolve-current-authorization-context";
import { createSupabaseCurrentAuthorizationSource } from "./infrastructure/supabase/current-authorization-source";

export type {
  CurrentAuthorizationContext,
  CurrentAuthorizationResult,
  TenantRole,
  ValidatedAuthIdentity,
} from "./application/authorization-context";

export function resolveCurrentAuthorizationContext(
  identity: ValidatedAuthIdentity | null | undefined,
): Promise<CurrentAuthorizationResult> {
  return resolveCurrentAuthorizationContextWithSource(
    identity,
    createSupabaseCurrentAuthorizationSource,
  );
}
