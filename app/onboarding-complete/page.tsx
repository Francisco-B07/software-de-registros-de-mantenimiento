import { redirect } from "next/navigation";

import { getFirstAdminProfileCompletionService } from "../../src/modules/identity-authorization/server";

export const dynamic = "force-dynamic";
export const fetchCache = "force-no-store";
export const revalidate = 0;

const SAFE_ENTRY_PATH = "/";

async function resolveCurrentState() {
  try {
    return await getFirstAdminProfileCompletionService().resolveState();
  } catch {
    redirect(SAFE_ENTRY_PATH);
  }
}

export default async function OnboardingCompletePage() {
  const state = await resolveCurrentState();

  if (state.state === "PENDING_PROFILE") {
    redirect("/pending-profile");
  }
  if (state.state === "UNAVAILABLE") {
    redirect(SAFE_ENTRY_PATH);
  }

  return (
    <main className="grid min-h-dvh place-items-center bg-slate-950 px-5 py-10 text-slate-50">
      <section className="w-full max-w-md space-y-3 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl">
        <p className="text-sm font-medium text-emerald-300">
          Proceso finalizado
        </p>
        <h1 className="text-2xl font-semibold">Perfil completado</h1>
        <p className="text-sm leading-6 text-slate-300">
          Tu cuenta ya está habilitada para administrar la empresa.
        </p>
      </section>
    </main>
  );
}
