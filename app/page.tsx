export default function Home() {
  return (
    <main className="grid min-h-dvh place-items-center bg-slate-950 px-5 py-10 text-slate-50">
      <section className="w-full max-w-md space-y-3 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl">
        <h1 className="text-2xl font-semibold">Acceso inicial</h1>
        <p className="text-sm leading-6 text-slate-300">
          Utiliza el enlace de verificación recibido para continuar.
        </p>
      </section>
    </main>
  );
}
