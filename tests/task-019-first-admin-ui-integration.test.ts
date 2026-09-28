import { readFileSync } from "node:fs";

import { createElement } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { beforeEach, describe, expect, it, vi } from "vitest";

const { redirectMock, replaceMock, resolveStateMock } = vi.hoisted(() => ({
  redirectMock: vi.fn(),
  replaceMock: vi.fn(),
  resolveStateMock: vi.fn(),
}));

vi.mock("next/navigation", () => ({
  redirect: redirectMock,
  useRouter: () => ({ replace: replaceMock }),
}));

vi.mock("../src/modules/identity-authorization/server", () => ({
  getFirstAdminProfileCompletionService: () => ({
    resolveState: resolveStateMock,
  }),
}));

import {
  createFirstAdminProfileCompletionFlow,
  FirstAdminProfileForm,
} from "../app/first-admin-profile-form";
import OnboardingCompletePage from "../app/onboarding-complete/page";
import PendingProfilePage from "../app/pending-profile/page";

const operationId1 = "19000000-0000-4000-8000-000000000101";
const operationId2 = "19000000-0000-4000-8000-000000000102";

function boundedResponse(outcome: string, status: number) {
  return new Response(JSON.stringify({ outcome }), {
    headers: { "Content-Type": "application/json" },
    status,
  });
}

function createFlow(
  fetchImplementation: () => Promise<Response>,
  operationIds: string[] = [operationId1, operationId2],
) {
  const fetchMock = vi.fn(fetchImplementation);
  const navigate = vi.fn();
  const randomUUID = vi.fn(() => {
    const operationId = operationIds.shift();
    if (operationId === undefined) {
      throw new Error("No operation ID fixture remains.");
    }
    return operationId;
  });
  return {
    fetchMock,
    flow: createFirstAdminProfileCompletionFlow({
      fetch: fetchMock,
      navigate,
      randomUUID,
    }),
    navigate,
    randomUUID,
  };
}

function requestBodies(fetchMock: ReturnType<typeof vi.fn>) {
  return fetchMock.mock.calls.map(([, init]) =>
    JSON.parse(String((init as RequestInit).body)),
  );
}

describe("TASK-019 Work Item E authoritative server gates", () => {
  beforeEach(() => {
    redirectMock.mockReset();
    redirectMock.mockImplementation((path: string) => {
      throw new Error(`REDIRECT:${path}`);
    });
    replaceMock.mockReset();
    resolveStateMock.mockReset();
  });

  it("T019-E-001 renders the profile form only for authoritative PENDING_PROFILE", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: null,
      state: "PENDING_PROFILE",
    });

    const html = renderToStaticMarkup(await PendingProfilePage());

    expect(html).toContain("Completa tu perfil");
    expect(html).toContain('name="firstName"');
    expect(html).toContain('name="lastName"');
    expect(resolveStateMock).toHaveBeenCalledOnce();
  });

  it("T019-E-002 redirects completed pending-profile visits to the completion gate", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: "2026-09-27T01:00:00.000Z",
      state: "COMPLETED",
    });

    await expect(PendingProfilePage()).rejects.toThrow(
      "REDIRECT:/onboarding-complete",
    );
  });

  it("T019-E-003 redirects unavailable pending-profile visits to the existing safe entry", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: null,
      state: "UNAVAILABLE",
    });

    await expect(PendingProfilePage()).rejects.toThrow("REDIRECT:/");
  });

  it("T019-E-004 renders the minimum shell only for authoritative COMPLETED", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: "2026-09-27T01:00:00.000Z",
      state: "COMPLETED",
    });

    const html = renderToStaticMarkup(await OnboardingCompletePage());

    expect(html).toContain("Perfil completado");
    expect(html).toContain(
      "Tu cuenta ya está habilitada para administrar la empresa.",
    );
    expect(html).not.toMatch(
      /dashboard|acceso completo|todos los recursos|UserClientAccess|SupportAccessGrant|Fase 2/i,
    );
  });

  it("T019-E-005 redirects pending completion-page visits to the form gate", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: null,
      state: "PENDING_PROFILE",
    });

    await expect(OnboardingCompletePage()).rejects.toThrow(
      "REDIRECT:/pending-profile",
    );
  });

  it("T019-E-006 denies completion claims for unavailable direct pathname visits", async () => {
    resolveStateMock.mockResolvedValue({
      completedAt: null,
      state: "UNAVAILABLE",
    });

    await expect(OnboardingCompletePage()).rejects.toThrow("REDIRECT:/");
    expect(resolveStateMock).toHaveBeenCalledOnce();
  });

  it.each([PendingProfilePage, OnboardingCompletePage])(
    "T019-E-007 fails closed to the safe entry when authoritative resolution throws",
    async (page) => {
      resolveStateMock.mockRejectedValue(new Error("sensitive RPC detail"));

      await expect(page()).rejects.toThrow("REDIRECT:/");
    },
  );
});

describe("TASK-019 Work Item E client profile form", () => {
  beforeEach(() => {
    replaceMock.mockReset();
  });

  it("T019-E-008 renders exactly the two editable profile fields", () => {
    const html = renderToStaticMarkup(createElement(FirstAdminProfileForm));
    const source = readFileSync(
      new URL("../app/first-admin-profile-form.tsx", import.meta.url),
      "utf8",
    );

    expect(html).toContain('name="firstName"');
    expect(html).toContain('name="lastName"');
    expect(html.match(/<input/g)).toHaveLength(2);
    expect(html).not.toMatch(
      /name="(?:email|tenant|company|role|intent|membership|actor|targetUser|operationId|authorizationState|completionState)"/,
    );
    expect(html).not.toContain("maxLength");
    expect(source).toContain("disabled={pending}");
  });

  it.each([
    { firstName: "", lastName: "Lovelace" },
    { firstName: "Ada", lastName: "" },
    { firstName: "   ", lastName: " \t " },
  ])("T019-E-009 rejects blank or trim-only names before fetch %#", async (fields) => {
    const fixture = createFlow(async () => boundedResponse("COMPLETED", 200));

    await expect(fixture.flow.submit(fields)).resolves.toEqual({
      operationId: null,
      state: "INVALID_INPUT",
    });
    expect(fixture.fetchMock).not.toHaveBeenCalled();
    expect(fixture.randomUUID).not.toHaveBeenCalled();
    expect(fixture.navigate).not.toHaveBeenCalled();
  });

  it.each(["COMPLETED", "ALREADY_COMPLETED"])(
    "T019-E-010 generates one operation ID and navigates only after authoritative %s",
    async (outcome) => {
      const fixture = createFlow(async () => boundedResponse(outcome, 200));

      await expect(
        fixture.flow.submit({ firstName: " Ada ", lastName: " Lovelace " }),
      ).resolves.toEqual({ operationId: operationId1, state: "SUCCESS" });

      expect(fixture.randomUUID).toHaveBeenCalledOnce();
      expect(requestBodies(fixture.fetchMock)).toEqual([
        {
          firstName: "Ada",
          lastName: "Lovelace",
          operationId: operationId1,
        },
      ]);
      expect(fixture.navigate).toHaveBeenCalledExactlyOnceWith(
        "/onboarding-complete",
      );
    },
  );

  it("T019-E-011 preserves the unresolved attempt across a network-failure retry after local field changes", async () => {
    const fixture = createFlow(
      vi
        .fn()
        .mockRejectedValueOnce(new Error("network unavailable"))
        .mockResolvedValueOnce(boundedResponse("COMPLETED", 200)),
    );
    const originalFields = { firstName: "Ada", lastName: "Lovelace" };
    const editedFields = { firstName: "Grace", lastName: "Hopper" };

    await expect(fixture.flow.submit(originalFields)).resolves.toEqual({
      operationId: operationId1,
      state: "RETRYABLE",
    });
    expect(fixture.navigate).not.toHaveBeenCalled();
    await expect(fixture.flow.submit(editedFields)).resolves.toEqual({
      operationId: operationId1,
      state: "SUCCESS",
    });

    expect(requestBodies(fixture.fetchMock)).toEqual([
      { ...originalFields, operationId: operationId1 },
      { ...originalFields, operationId: operationId1 },
    ]);
    expect(fixture.randomUUID).toHaveBeenCalledOnce();
  });

  it("T019-E-012 preserves the unresolved attempt across a bounded 503 retry after local field changes", async () => {
    const fixture = createFlow(
      vi
        .fn()
        .mockResolvedValueOnce(boundedResponse("RETRYABLE_FAILURE", 503))
        .mockResolvedValueOnce(boundedResponse("ALREADY_COMPLETED", 200)),
    );
    const originalFields = { firstName: "Ada", lastName: "Lovelace" };
    const editedFields = { firstName: "Grace", lastName: "Hopper" };

    await expect(fixture.flow.submit(originalFields)).resolves.toMatchObject({
      operationId: operationId1,
      state: "RETRYABLE",
    });
    expect(fixture.navigate).not.toHaveBeenCalled();
    await expect(fixture.flow.submit(editedFields)).resolves.toMatchObject({
      operationId: operationId1,
      state: "SUCCESS",
    });

    expect(requestBodies(fixture.fetchMock)).toEqual([
      { ...originalFields, operationId: operationId1 },
      { ...originalFields, operationId: operationId1 },
    ]);
    expect(fixture.randomUUID).toHaveBeenCalledOnce();
  });

  it("T019-E-013 creates a new logical operation after deterministic error and field correction", async () => {
    const fixture = createFlow(
      vi
        .fn()
        .mockResolvedValueOnce(boundedResponse("INVALID_INPUT", 400))
        .mockResolvedValueOnce(boundedResponse("COMPLETED", 200)),
    );

    await fixture.flow.submit({ firstName: "Ada", lastName: "Lovelace" });
    await fixture.flow.submit({ firstName: "Grace", lastName: "Hopper" });

    expect(requestBodies(fixture.fetchMock)).toEqual([
      {
        firstName: "Ada",
        lastName: "Lovelace",
        operationId: operationId1,
      },
      {
        firstName: "Grace",
        lastName: "Hopper",
        operationId: operationId2,
      },
    ]);
    expect(fixture.randomUUID).toHaveBeenCalledTimes(2);
  });

  it.each([
    ["INVALID_INPUT", 400, "INVALID_INPUT"],
    ["DENIED", 403, "DENIED"],
    ["CONFLICT", 409, "CONFLICT"],
    ["RETRYABLE_FAILURE", 503, "RETRYABLE"],
    ["UNKNOWN", 200, "RETRYABLE"],
  ])(
    "T019-E-014 does not navigate for bounded/unknown non-success %s",
    async (outcome, status, expectedState) => {
      const fixture = createFlow(async () => boundedResponse(outcome, status));

      await expect(
        fixture.flow.submit({ firstName: "Ada", lastName: "Lovelace" }),
      ).resolves.toMatchObject({ state: expectedState });
      expect(fixture.navigate).not.toHaveBeenCalled();
    },
  );

  it("T019-E-015 preserves the unresolved attempt after malformed transport and local field changes", async () => {
    const fixture = createFlow(
      vi
        .fn()
        .mockResolvedValueOnce(new Response("not-json", { status: 200 }))
        .mockResolvedValueOnce(boundedResponse("COMPLETED", 200)),
    );
    const originalFields = { firstName: "Ada", lastName: "Lovelace" };
    const editedFields = { firstName: "Grace", lastName: "Hopper" };

    await expect(fixture.flow.submit(originalFields)).resolves.toEqual({
      operationId: operationId1,
      state: "RETRYABLE",
    });
    expect(fixture.navigate).not.toHaveBeenCalled();
    await expect(fixture.flow.submit(editedFields)).resolves.toEqual({
      operationId: operationId1,
      state: "SUCCESS",
    });

    expect(requestBodies(fixture.fetchMock)).toEqual([
      { ...originalFields, operationId: operationId1 },
      { ...originalFields, operationId: operationId1 },
    ]);
    expect(fixture.randomUUID).toHaveBeenCalledOnce();
  });

  it("T019-E-016 deduplicates submit while one request is pending", async () => {
    let resolveResponse: ((response: Response) => void) | undefined;
    const deferred = new Promise<Response>((resolve) => {
      resolveResponse = resolve;
    });
    const fixture = createFlow(() => deferred);
    const fields = { firstName: "Ada", lastName: "Lovelace" };

    const first = fixture.flow.submit(fields);
    expect(fixture.flow.isPending()).toBe(true);
    await expect(fixture.flow.submit(fields)).resolves.toEqual({
      operationId: operationId1,
      state: "PENDING",
    });
    expect(fixture.fetchMock).toHaveBeenCalledOnce();

    resolveResponse?.(boundedResponse("COMPLETED", 200));
    await expect(first).resolves.toMatchObject({ state: "SUCCESS" });
    expect(fixture.flow.isPending()).toBe(false);
  });

  it("T019-E-017 keeps privileged/offline authority and direct Supabase access absent", () => {
    const paths = [
      "../app/pending-profile/page.tsx",
      "../app/first-admin-profile-form.tsx",
      "../app/onboarding-complete/page.tsx",
    ];
    const implementation = paths
      .map((path) => readFileSync(new URL(path, import.meta.url), "utf8"))
      .join("\n");
    const client = readFileSync(
      new URL("../app/first-admin-profile-form.tsx", import.meta.url),
      "utf8",
    );

    expect(implementation).not.toMatch(
      /createSupabaseClient|createSupabaseServerClient|\.rpc\s*\(|\.from\s*\(|service[_-]?role|SUPABASE_SERVICE_ROLE|auth\.admin/i,
    );
    expect(client).not.toMatch(
      /indexedDB|Dexie|serviceWorker|background.?replay|offline.?outbox|localStorage|sessionStorage/i,
    );
    expect(client).toContain('"/api/first-admin/profile-completion"');
    expect(client).not.toMatch(/@supabase|identity-authorization/);
  });
});
