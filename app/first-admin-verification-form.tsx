"use client";

import { useRouter } from "next/navigation";
import { type FormEvent, useState } from "react";

type VisibleState =
  | "IDLE"
  | "PENDING"
  | "RETRYABLE"
  | "FRESH_PROOF_REQUIRED"
  | "TERMINAL_FAILURE";

type BoundedResponse = Readonly<{
  outcome:
    | "SUCCESS"
    | "RETRYABLE_NEW_ATTEMPT"
    | "RETRYABLE_FAILURE"
    | "FRESH_PROOF_REQUIRED"
    | "TERMINAL_FAILURE";
}>;

function isBoundedResponse(value: unknown): value is BoundedResponse {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return false;
  }
  const outcome = (value as { outcome?: unknown }).outcome;
  return (
    outcome === "SUCCESS" ||
    outcome === "RETRYABLE_NEW_ATTEMPT" ||
    outcome === "RETRYABLE_FAILURE" ||
    outcome === "FRESH_PROOF_REQUIRED" ||
    outcome === "TERMINAL_FAILURE"
  );
}

function statusMessage(state: VisibleState) {
  switch (state) {
    case "IDLE":
      return "Ingresa la prueba de verificación para continuar.";
    case "PENDING":
      return "Estableciendo acceso…";
    case "RETRYABLE":
      return "No se pudo completar la conexión. Puedes reintentar de forma segura.";
    case "FRESH_PROOF_REQUIRED":
      return "La verificación ya no puede continuar. Inicia una verificación nueva cuando esté disponible.";
    case "TERMINAL_FAILURE":
      return "No se pudo completar el acceso. Intenta nuevamente desde una verificación válida.";
  }
}

type FirstAdminVerificationFormProps = Readonly<{
  intentId: string;
}>;

export function FirstAdminVerificationForm({
  intentId,
}: FirstAdminVerificationFormProps) {
  const router = useRouter();
  const [state, setState] = useState<VisibleState>("IDLE");
  const [verificationOperationId, setVerificationOperationId] = useState(() =>
    crypto.randomUUID(),
  );

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (state === "PENDING" || verificationOperationId.length === 0) {
      return;
    }

    const form = event.currentTarget;
    const formData = new FormData(form);
    setState("PENDING");

    try {
      const response = await fetch("/api/first-admin/verification", {
        body: JSON.stringify({
          code: formData.get("code"),
          email: formData.get("email"),
          intentId,
          verificationOperationId,
        }),
        cache: "no-store",
        headers: { "Content-Type": "application/json" },
        method: "POST",
      });
      const payload: unknown = await response.json();
      if (!isBoundedResponse(payload)) {
        setState("TERMINAL_FAILURE");
        return;
      }

      switch (payload.outcome) {
        case "SUCCESS":
          router.replace("/pending-profile");
          return;
        case "RETRYABLE_NEW_ATTEMPT":
          setVerificationOperationId(crypto.randomUUID());
          setState("RETRYABLE");
          return;
        case "RETRYABLE_FAILURE":
          setState("RETRYABLE");
          return;
        case "FRESH_PROOF_REQUIRED":
          setState("FRESH_PROOF_REQUIRED");
          return;
        case "TERMINAL_FAILURE":
          setState("TERMINAL_FAILURE");
          return;
      }
    } catch {
      setState("RETRYABLE");
    }
  }

  const pending = state === "PENDING";
  const canSubmit = !pending && verificationOperationId.length > 0;

  return (
    <form
      className="w-full max-w-md space-y-5 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl"
      onSubmit={submit}
    >
      <div className="space-y-2">
        <p className="text-sm font-medium text-sky-300">Acceso inicial</p>
        <h1 className="text-2xl font-semibold">Verifica tu acceso</h1>
        <p className="text-sm leading-6 text-slate-300">
          Completa la prueba recibida para establecer una sesión segura.
        </p>
      </div>

      <label className="block space-y-2 text-sm">
        <span>Correo electrónico</span>
        <input
          autoComplete="email"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
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
          name="code"
          required
          type="text"
        />
      </label>

      <button
        className="w-full rounded-lg bg-sky-400 px-4 py-2.5 font-semibold text-slate-950 disabled:cursor-wait disabled:opacity-60"
        disabled={!canSubmit}
        type="submit"
      >
        {pending ? "Estableciendo acceso…" : "Continuar"}
      </button>

      <p aria-live="polite" className="text-sm leading-6 text-slate-300">
        {statusMessage(state)}
      </p>
    </form>
  );
}
