"use client";

import { type FormEvent, useState } from "react";

type VisibleState =
  | "IDLE"
  | "PENDING"
  | "INVALID"
  | "EXHAUSTED"
  | "HANDOFF_READY"
  | "DENIED"
  | "OFFLINE";

function message(state: VisibleState) {
  switch (state) {
    case "IDLE":
      return "Ingresa el correo y el código recibido para verificar esta solicitud.";
    case "PENDING":
      return "Verificando…";
    case "INVALID":
      return "La prueba no fue válida. Puedes usar otro intento mientras la emisión siga vigente.";
    case "EXHAUSTED":
      return "La emisión agotó sus intentos. Solicita un reenvío al administrador.";
    case "HANDOFF_READY":
      return "La prueba quedó verificada y el handoff está preparado. El alta del usuario todavía no está completa.";
    case "DENIED":
      return "La verificación no puede continuar con los datos provistos.";
    case "OFFLINE":
      return "La verificación es sólo online. Restablece la conexión y reintenta.";
  }
}

export function LaterUserVerificationForm({ intentId }: Readonly<{ intentId: string }>) {
  const [state, setState] = useState<VisibleState>("IDLE");
  const [verificationOperationToken, setVerificationOperationToken] = useState<
    string | null
  >(null);

  async function issueVerificationOperationToken(): Promise<string> {
    const response = await fetch("/api/later-user/verification", {
      body: JSON.stringify({ action: "ISSUE_OPERATION" }),
      cache: "no-store",
      headers: { "Content-Type": "application/json" },
      method: "POST",
    });
    if (!response.ok) {
      throw new Error("Verification operation could not be issued.");
    }
    const payload: unknown = await response.json();
    if (
      typeof payload !== "object" ||
      payload === null ||
      Array.isArray(payload) ||
      typeof (payload as { verificationOperationToken?: unknown })
        .verificationOperationToken !== "string"
    ) {
      throw new Error("Verification operation response is invalid.");
    }
    return (payload as { verificationOperationToken: string })
      .verificationOperationToken;
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (state === "PENDING" || state === "HANDOFF_READY") {
      return;
    }
    const formData = new FormData(event.currentTarget);
    setState("PENDING");
    try {
      let activeOperationToken = verificationOperationToken;
      if (activeOperationToken === null) {
        activeOperationToken = await issueVerificationOperationToken();
        setVerificationOperationToken(activeOperationToken);
      }
      const response = await fetch("/api/later-user/verification", {
        body: JSON.stringify({
          action: "VERIFY",
          code: formData.get("code"),
          email: formData.get("email"),
          intentId,
          verificationOperationToken: activeOperationToken,
        }),
        cache: "no-store",
        headers: { "Content-Type": "application/json" },
        method: "POST",
      });
      if (response.status >= 500) {
        throw new Error("Verification result is not confirmed.");
      }
      const payload: unknown = await response.json();
      if (typeof payload !== "object" || payload === null || Array.isArray(payload)) {
        setState("DENIED");
        return;
      }
      const outcome = (payload as { outcome?: unknown }).outcome;
      if (outcome === "CONSUMED") {
        setState("HANDOFF_READY");
      } else if (outcome === "INVALID") {
        setVerificationOperationToken(null);
        setState("INVALID");
      } else if (outcome === "EXHAUSTED") {
        setState("EXHAUSTED");
      } else {
        setState("DENIED");
      }
    } catch {
      setState("OFFLINE");
    }
  }

  const pending = state === "PENDING";
  return (
    <form
      className="w-full max-w-md space-y-5 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl"
      onSubmit={submit}
    >
      <div className="space-y-2">
        <p className="text-sm font-medium text-sky-300">Verificación de alta</p>
        <h1 className="text-2xl font-semibold">Verifica la solicitud</h1>
      </div>
      <label className="block space-y-2 text-sm">
        <span>Correo electrónico</span>
        <input
          autoComplete="email"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          maxLength={320}
          name="email"
          required
          type="email"
        />
      </label>
      <label className="block space-y-2 text-sm">
        <span>Código de verificación</span>
        <input
          autoComplete="one-time-code"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          maxLength={512}
          name="code"
          required
          type="text"
        />
      </label>
      <button
        className="w-full rounded-lg bg-sky-400 px-4 py-2.5 font-semibold text-slate-950 disabled:cursor-wait disabled:opacity-60"
        disabled={pending || state === "HANDOFF_READY"}
        type="submit"
      >
        {pending ? "Verificando…" : "Verificar"}
      </button>
      <p aria-live="polite" className="text-sm leading-6 text-slate-300">
        {message(state)}
      </p>
    </form>
  );
}
