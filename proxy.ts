import type { NextRequest } from "next/server";

import { updateSupabaseAuthSession } from "./src/infrastructure/supabase/proxy";

export async function proxy(request: NextRequest) {
  return updateSupabaseAuthSession(request);
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
