export default function PendingProfilePage() {
  return (
    <main className="grid min-h-dvh place-items-center bg-slate-950 px-5 py-10 text-slate-50">
      <section className="w-full max-w-md space-y-3 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl">
        <p className="text-sm font-medium text-emerald-300">
          Sesión establecida
        </p>
        <h1 className="text-2xl font-semibold">Perfil pendiente</h1>
        <p className="text-sm leading-6 text-slate-300">
          Tu sesión de acceso está lista. La configuración del perfil de
          administrador inicial continúa pendiente.
        </p>
      </section>
    </main>
  );
}
