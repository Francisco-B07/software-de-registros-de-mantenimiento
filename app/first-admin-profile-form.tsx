"use client";

import { useRouter } from "next/navigation";
import { type FormEvent, useState } from "react";

type ProfileFields = Readonly<{
  firstName: string;
  lastName: string;
}>;

type ActiveAttempt = Readonly<ProfileFields & { operationId: string }>;

type ActiveAttemptResolution = "DETERMINISTIC" | "UNRESOLVED";

export type ProfileCompletionVisibleState =
  | "IDLE"
  | "PENDING"
  | "SUCCESS"
  | "INVALID_INPUT"
  | "DENIED"
  | "CONFLICT"
  | "RETRYABLE";

type BrowserOutcome =
  | "ALREADY_COMPLETED"
  | "COMPLETED"
  | "CONFLICT"
  | "DENIED"
  | "INVALID_INPUT"
  | "RETRYABLE_FAILURE";

type CompletionFlowResult = Readonly<{
  operationId: string | null;
  state: ProfileCompletionVisibleState;
}>;

type CompletionFlowDependencies = Readonly<{
  fetch: (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>;
  navigate: (path: string) => void;
  randomUUID: () => string;
}>;

function parseBrowserOutcome(value: unknown): BrowserOutcome | null {
  if (
    typeof value !== "object" ||
    value === null ||
    Array.isArray(value) ||
    Object.keys(value).join("\u0000") !== "outcome"
  ) {
    return null;
  }

  const outcome = (value as { outcome?: unknown }).outcome;
  return outcome === "ALREADY_COMPLETED" ||
    outcome === "COMPLETED" ||
    outcome === "CONFLICT" ||
    outcome === "DENIED" ||
    outcome === "INVALID_INPUT" ||
    outcome === "RETRYABLE_FAILURE"
    ? outcome
    : null;
}

function sameFields(attempt: ActiveAttempt, fields: ProfileFields) {
  return (
    attempt.firstName === fields.firstName &&
    attempt.lastName === fields.lastName
  );
}

export function createFirstAdminProfileCompletionFlow(
  dependencies: CompletionFlowDependencies,
) {
  let activeAttempt: ActiveAttempt | null = null;
  let activeAttemptResolution: ActiveAttemptResolution | null = null;
  let pending = false;

  async function submit(input: ProfileFields): Promise<CompletionFlowResult> {
    if (pending) {
      return Object.freeze({
        operationId: activeAttempt?.operationId ?? null,
        state: "PENDING",
      });
    }

    const fields = Object.freeze({
      firstName: input.firstName.trim(),
      lastName: input.lastName.trim(),
    });
    if (fields.firstName.length === 0 || fields.lastName.length === 0) {
      return Object.freeze({
        operationId: activeAttempt?.operationId ?? null,
        state: "INVALID_INPUT",
      });
    }

    const attempt =
      activeAttempt !== null &&
      (activeAttemptResolution === "UNRESOLVED" ||
        sameFields(activeAttempt, fields))
        ? activeAttempt
        : Object.freeze({
            ...fields,
            operationId: dependencies.randomUUID(),
          });
    activeAttempt = attempt;
    activeAttemptResolution = "UNRESOLVED";
    pending = true;

    try {
      const response = await dependencies.fetch(
        "/api/first-admin/profile-completion",
        {
          body: JSON.stringify(attempt),
          cache: "no-store",
          headers: { "Content-Type": "application/json" },
          method: "POST",
        },
      );
      const outcome = parseBrowserOutcome(await response.json());

      if (
        response.status === 200 &&
        (outcome === "COMPLETED" || outcome === "ALREADY_COMPLETED")
      ) {
        dependencies.navigate("/onboarding-complete");
        return Object.freeze({
          operationId: attempt.operationId,
          state: "SUCCESS",
        });
      }
      if (response.status === 400 && outcome === "INVALID_INPUT") {
        activeAttemptResolution = "DETERMINISTIC";
        return Object.freeze({
          operationId: attempt.operationId,
          state: "INVALID_INPUT",
        });
      }
      if (response.status === 403 && outcome === "DENIED") {
        activeAttemptResolution = "DETERMINISTIC";
        return Object.freeze({
          operationId: attempt.operationId,
          state: "DENIED",
        });
      }
      if (response.status === 409 && outcome === "CONFLICT") {
        activeAttemptResolution = "DETERMINISTIC";
        return Object.freeze({
          operationId: attempt.operationId,
          state: "CONFLICT",
        });
      }

      return Object.freeze({
        operationId: attempt.operationId,
        state: "RETRYABLE",
      });
    } catch {
      return Object.freeze({
        operationId: attempt.operationId,
        state: "RETRYABLE",
      });
    } finally {
      pending = false;
    }
  }

  return Object.freeze({
    getActiveOperationId() {
      return activeAttempt?.operationId ?? null;
    },
    isPending() {
      return pending;
    },
    submit,
  });
}

function statusMessage(state: ProfileCompletionVisibleState) {
  switch (state) {
    case "IDLE":
      return "Completa tu nombre y apellido para continuar.";
    case "PENDING":
      return "Confirmando el perfil…";
    case "SUCCESS":
      return "Redirigiendo…";
    case "INVALID_INPUT":
      return "Revisa el nombre y el apellido antes de continuar.";
    case "DENIED":
      return "No se pudo autorizar esta finalización de perfil.";
    case "CONFLICT":
      return "El proceso no puede completarse con el estado actual.";
    case "RETRYABLE":
      return "No se pudo confirmar el resultado. Reintenta de forma segura.";
  }
}

export function FirstAdminProfileForm() {
  const router = useRouter();
  const [state, setState] = useState<ProfileCompletionVisibleState>("IDLE");
  const [flow] = useState(() =>
    createFirstAdminProfileCompletionFlow({
      fetch: (input, init) => fetch(input, init),
      navigate: (path) => router.replace(path),
      randomUUID: () => crypto.randomUUID(),
    }),
  );

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (flow.isPending()) {
      return;
    }

    const formData = new FormData(event.currentTarget);
    setState("PENDING");
    const result = await flow.submit({
      firstName: String(formData.get("firstName") ?? ""),
      lastName: String(formData.get("lastName") ?? ""),
    });
    setState(result.state);
  }

  const pending = state === "PENDING";

  return (
    <form
      aria-busy={pending}
      className="w-full max-w-md space-y-5 rounded-2xl border border-slate-800 bg-slate-900 p-7 shadow-2xl"
      onSubmit={submit}
    >
      <div className="space-y-2">
        <p className="text-sm font-medium text-emerald-300">
          Sesión establecida
        </p>
        <h1 className="text-2xl font-semibold">Completa tu perfil</h1>
        <p className="text-sm leading-6 text-slate-300">
          Ingresa tu nombre y apellido para finalizar el acceso inicial.
        </p>
      </div>

      <label className="block space-y-2 text-sm">
        <span>Nombre</span>
        <input
          autoComplete="given-name"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          name="firstName"
          required
          type="text"
        />
      </label>

      <label className="block space-y-2 text-sm">
        <span>Apellido</span>
        <input
          autoComplete="family-name"
          className="w-full rounded-lg border border-slate-700 bg-slate-950 px-3 py-2"
          name="lastName"
          required
          type="text"
        />
      </label>

      <button
        className="w-full rounded-lg bg-emerald-400 px-4 py-2.5 font-semibold text-slate-950 disabled:cursor-wait disabled:opacity-60"
        disabled={pending}
        type="submit"
      >
        {pending ? "Confirmando…" : "Completar perfil"}
      </button>

      <p aria-live="polite" className="text-sm leading-6 text-slate-300">
        {statusMessage(state)}
      </p>
    </form>
  );
}
