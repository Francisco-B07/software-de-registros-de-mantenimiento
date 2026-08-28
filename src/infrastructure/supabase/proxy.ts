import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { type NextRequest, NextResponse } from "next/server";

import { getSupabasePublicConfig } from "../config/supabase-public";

export async function updateSupabaseAuthSession(request: NextRequest) {
  const { publishableKey, url } = getSupabasePublicConfig();
  const lifecycleCookies: Array<{
    name: string;
    options: CookieOptions;
    value: string;
  }> = [];
  const lifecycleHeaders = new Headers();
  let response = NextResponse.next({ request });

  const supabase = createServerClient(url, publishableKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet, headers) {
        cookiesToSet.forEach(({ name, value }) => {
          request.cookies.set(name, value);
        });
        lifecycleCookies.push(...cookiesToSet);

        Object.entries(headers).forEach(([name, value]) => {
          lifecycleHeaders.set(name, value);
        });

        response = NextResponse.next({ request });

        lifecycleCookies.forEach(({ name, options, value }) => {
          response.cookies.set(name, value, options);
        });

        lifecycleHeaders.forEach((value, name) => {
          response.headers.set(name, value);
        });
      },
    },
  });

  try {
    await supabase.auth.getClaims();
  } catch {
    throw new Error("Supabase Auth session validation failed.");
  }

  return response;
}
