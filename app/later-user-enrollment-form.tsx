"use client";

import { type FormEvent, useState } from "react";

type IssueRequestIds = Readonly<{
  challengeId: string;
  establishmentOperationId: string;
  intentId: string;
  issueOperationId: string;
}>;

export type ResendRequestIds = Readonly<{
  challengeId: string;
  issueOperationId: string;
}>;

type VisibleState =
  | "IDLE"
  | "PENDING"
  | "ESTABLISHED"
  | "DELIVERY_FAILED"
  | "DENIED"
  | "CONFLICT"
  | "OFFLINE";

type BoundedResponse = Readonly<{
  changed: boolean;
  delivery: "DELIVERED" | "FAILED" | "NOT_ATTEMPTED";
  intentId: string | null;
  outcome:
    | "ALREADY_RECONCILED"
    | "CONFLICT"
    | "DENIED"
    | "ESTABLISHED"
    | "RESENT"
    | "STALE_OR_CONFLICT";
  reason: string;
}>;

function newIssueRequestIds(): IssueRequestIds {
  return Object.freeze({
    challengeId: crypto.randomUUID(),
    establishmentOperationId: crypto.randomUUID(),
    intentId: crypto.randomUUID(),
    issueOperationId: crypto.randomUUID(),
  });
}

export function getOrCreateResendRequestIds(
  pending: ResendRequestIds | null,
  createId: () => string = () => crypto.randomUUID(),
): ResendRequestIds {
  return (
    pending ??
    Object.freeze({
      challengeId: createId(),
      issueOperationId: createId(),
    })
  );
}

function isBoundedResponse(value: unknown): value is BoundedResponse {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return false;
  }
  const row = value as Record<string, unknown>;
  return (
    typeof row.changed === "boolean" &&
    ["DELIVERED", "FAILED", "NOT_ATTEMPTED"].includes(
      row.delivery as string,
    ) &&
    (row.intentId === null || typeof row.intentId === "string") &&
    [
      "ALREADY_RECONCILED",
      "CONFLICT",
      "DENIED",
      "ESTABLISHED",
      "RESENT",
      "STALE_OR_CONFLICT",
    ].includes(row.outcome as string) &&
    typeof row.reason === "string"
  );
}

function message(state: VisibleState) {
  switch (state) {
    case "IDLE":
      return "Registra el correo y el rol previsto. No se asignarán clientes ni se completará el alta en este paso.";
    case "PENDING":
      return "Registrando la verificación autoritativa…";
    case "ESTABLISHED":
      return "La verificación fue registrada y entregada. El alta del usuario todavía no está completa.";
    case "DELIVERY_FAILED":
      return "La verificación quedó registrada, pero la entrega no está disponible. Puedes reintentar la entrega de forma segura.";
    case "DENIED":
      return "La operación no fue autorizada por el estado actual.";
    case "CONFLICT":
      return "La operación no puede continuar sin resolver el estado existente.";
    case "OFFLINE":
      return "Esta operación es sólo online. Restablece la conexión y reintenta con la misma solicitud.";
  }
}

export function LaterUserEnrollmentForm() {
  const [requestIds] = useState(newIssueRequestIds);
  const [intentId, setIntentId] = useState<string | null>(null);
  const [pendingResendOperation, setPendingResendOperation] =
    useState<ResendRequestIds | null>(null);
  const [state, setState] = useState<VisibleState>("IDLE");

  async function send(body: Record<string, string>): Promise<BoundedResponse> {
    const response = await fetch("/api/later-user/enrollment", {
      body: JSON.stringify(body),
      cache: "no-store",
      headers: { "Content-Type": "application/json" },
      method: "POST",
    });
    if (response.status >= 500) {
      throw new Error("Later-user enrollment result is not confirmed.");
    }
    const payload: unknown = await response.json();
    if (!isBoundedResponse(payload)) {
      throw new Error("Later-user enrollment response is not confirmed.");
    }

    if (payload.outcome === "CONFLICT" || payload.outcome === "STALE_OR_CONFLICT") {
      setState("CONFLICT");
      return payload;
    }
    if (payload.outcome === "DENIED") {
      setState("DENIED");
      return payload;
    }

    setIntentId(payload.intentId);
    setState(payload.delivery === "DELIVERED" ? "ESTABLISHED" : "DELIVERY_FAILED");
    return payload;
  }

  async function establish(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (state === "PENDING") {
      return;
    }
    const formData = new FormData(event.currentTarget);
    setState("PENDING");
    try {
      await send({
        action: "ESTABLISH",
        challengeId: requestIds.challengeId,
        email: String(formData.get("email") ?? ""),
        establishmentOperationId: requestIds.establishmentOperationId,
        intendedRole: String(formData.get("intendedRole") ?? ""),
        intentId: requestIds.intentId,
        issueOperationId: requestIds.issueOperationId,
      });
    } catch {
      setState("OFFLINE");
    }
  }

  async function resend() {
    if (state === "PENDING" || intentId === null) {
      return;
    }
    const operation = getOrCreateResendRequestIds(pendingResendOperation);
    setPendingResendOperation(operation);
    setState("PENDING");
    try {
      await send({
        action: "RESEND",
        challengeId: operation.challengeId,
        intentId,
        issueOperationId: operation.issueOperationId,
      });
      setPendingResendOperation(null);
    } catch {
      setState("OFFLINE");
    }
  }

  const pending = state === "PENDING";
  return (
    <form
      className="w-full max-w-lg space-y-5 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl"
      onSubmit={establish}
    >
      <div className="space-y-2">
        <p className="text-sm font-medium text-sky-300">Alta posterior</p>
        <h1 className="text-2xl font-semibold">Iniciar verificación</h1>
      </div>

      <label className="block space-y-2 text-sm">
        <span>Correo electrónico</span>
        <input
          autoComplete="email"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          disabled={intentId !== null}
          maxLength={320}
          name="email"
          required
          type="email"
        />
      </label>

      <label className="block space-y-2 text-sm">
        <span>Rol previsto</span>
        <select
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          disabled={intentId !== null}
          name="intendedRole"
          required
        >
          <option value="TECHNICIAN">Técnico</option>
          <option value="COMPANY_ADMIN">Administrador de empresa</option>
        </select>
      </label>

      {intentId === null ? (
        <button
          className="w-full rounded-lg bg-sky-400 px-4 py-2.5 font-semibold text-slate-950 disabled:cursor-wait disabled:opacity-60"
          disabled={pending}
          type="submit"
        >
          {pending ? "Registrando…" : "Registrar verificación"}
        </button>
      ) : (
        <button
          className="w-full rounded-lg border border-sky-400 px-4 py-2.5 font-semibold text-sky-300 disabled:cursor-wait disabled:opacity-60"
          disabled={pending}
          onClick={resend}
          type="button"
        >
          {pending ? "Reenviando…" : "Reenviar verificación"}
        </button>
      )}

      <p aria-live="polite" className="text-sm leading-6 text-slate-300">
        {message(state)}
      </p>
    </form>
  );
}
