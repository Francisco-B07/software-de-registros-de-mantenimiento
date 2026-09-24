import {
  createServerClient,
  type CookieMethodsServer,
} from "@supabase/ssr";
import { cookies } from "next/headers";

import { getSupabasePublicConfig } from "../config/supabase-public";

function isServerComponentCookieWriteError(error: unknown): boolean {
  return (
    error instanceof Error &&
    error.message.includes(
      "Cookies can only be modified in a Server Action or Route Handler",
    )
  );
}

export type SupabaseServerCookieMethods = Readonly<{
  getAll: CookieMethodsServer["getAll"];
  setAll: NonNullable<CookieMethodsServer["setAll"]>;
}>;

export async function createSupabaseServerClient(
  requestCookies?: SupabaseServerCookieMethods,
) {
  const { publishableKey, url } = getSupabasePublicConfig();

  if (requestCookies) {
    return createServerClient(url, publishableKey, {
      cookies: requestCookies,
    });
  }

  const cookieStore = await cookies();

  return createServerClient(url, publishableKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, options, value }) => {
            cookieStore.set(name, value, options);
          });
        } catch (error) {
          if (!isServerComponentCookieWriteError(error)) {
            throw error;
          }
        }
      },
    },
  });
}
