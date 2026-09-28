import { readFileSync } from "node:fs";

import { beforeEach, describe, expect, it, vi } from "vitest";

const {
  createSupabaseServerClientMock,
  getFirstAdminProfileCompletionServiceMock,
} = vi.hoisted(() => ({
  createSupabaseServerClientMock: vi.fn(),
  getFirstAdminProfileCompletionServiceMock: vi.fn(),
}));

vi.mock("../src/infrastructure/supabase/server", () => ({
  createSupabaseServerClient: createSupabaseServerClientMock,
}));

vi.mock("../src/modules/identity-authorization/server", () => ({
  getFirstAdminProfileCompletionService:
    getFirstAdminProfileCompletionServiceMock,
}));

import { NextRequest } from "next/server";

import { POST } from "../app/api/first-admin/profile-completion/route";
import type {
  FirstAdminProfileCompletionInput,
  FirstAdminProfileCompletionSource,
} from "../src/modules/identity-authorization/application/first-admin-profile-completion";
import { createFirstAdminProfileCompletionService } from "../src/modules/identity-authorization/application/first-admin-profile-completion-service";
import { createSupabaseFirstAdminProfileCompletionSource } from "../src/modules/identity-authorization/infrastructure/supabase/first-admin-profile-completion-source";

const operationId = "19000000-ABCD-4000-8000-000000000001";
const platformUserId = "19000000-0000-4000-8000-000000000002";
const companyMembershipId = "19000000-0000-4000-8000-000000000003";
const completedAt = "2026-09-26T20:00:00.000Z";

const validInput = Object.freeze({
  firstName: " Ada ",
  lastName: " Lovelace ",
  operationId,
});

function source(overrides: Partial<FirstAdminProfileCompletionSource> = {}) {
  return Object.freeze({
    async complete() {
      return [
        {
          company_membership_id: companyMembershipId,
          completed_at: completedAt,
          outcome: "COMPLETED",
          platform_user_id: platformUserId,
          reason: "COMPLETED",
        },
      ];
    },
    async resolveState() {
      return [{ completed_at: null, state: "PENDING_PROFILE" }];
    },
    ...overrides,
  }) satisfies FirstAdminProfileCompletionSource;
}

function service(overrides: Partial<FirstAdminProfileCompletionSource> = {}) {
  const implementation = source(overrides);
  const createSource = vi.fn(async () => implementation);
  return {
    createSource,
    implementation,
    service: createFirstAdminProfileCompletionService({ createSource }),
  };
}

function completionRow(
  outcome: "COMPLETED" | "ALREADY_COMPLETED" = "COMPLETED",
) {
  return [
    {
      company_membership_id: companyMembershipId,
      completed_at: completedAt,
      outcome,
      platform_user_id: platformUserId,
      reason: outcome,
    },
  ];
}

function routeRequest(
  body: BodyInit | object | null,
  options: Readonly<{
    contentType?: string | null;
    origin?: string | null;
  }> = {},
) {
  const headers = new Headers();
  const contentType =
    options.contentType === undefined
      ? "application/json"
      : options.contentType;
  const origin =
    options.origin === undefined
      ? "https://app.example.invalid"
      : options.origin;

  if (contentType !== null) {
    headers.set("content-type", contentType);
  }
  if (origin !== null) {
    headers.set("origin", origin);
  }

  return new NextRequest(
    "https://app.example.invalid/api/first-admin/profile-completion",
    {
      body:
        typeof body === "string" || body === null
          ? body
          : JSON.stringify(body),
      headers,
      method: "POST",
    },
  );
}

function expectPrivateResponse(response: Response) {
  expect(response.headers.get("cache-control")).toBe(
    "private, no-cache, no-store, must-revalidate, max-age=0",
  );
  expect(response.headers.get("pragma")).toBe("no-cache");
  expect(response.headers.get("expires")).toBe("0");
}

describe("TASK-019 Work Item C application boundary", () => {
  it("T019-C-001 enforces the strict caller input contract before creating a source", async () => {
    const fixture = service();

    await expect(
      fixture.service.complete({ ...validInput, operationId: "not-a-uuid" }),
    ).resolves.toEqual({
      companyMembershipId: null,
      completedAt: null,
      outcome: "DENIED",
      platformUserId: null,
      reason: "INVALID_INPUT",
    });
    await expect(
      fixture.service.complete({ ...validInput, firstName: "   " }),
    ).resolves.toMatchObject({ outcome: "DENIED", reason: "INVALID_INPUT" });
    expect(fixture.createSource).not.toHaveBeenCalled();
  });

  it.each([
    ["PENDING_PROFILE", null],
    ["COMPLETED", completedAt],
    ["UNAVAILABLE", null],
  ] as const)("T019-C-002 parses bounded resolver state %s", async (state, timestamp) => {
    const fixture = service({
      async resolveState() {
        return [{ completed_at: timestamp, state }];
      },
    });

    await expect(fixture.service.resolveState()).resolves.toEqual({
      completedAt: timestamp,
      state,
    });
  });

  it("T019-C-003 fails closed for an unknown resolver outcome", async () => {
    const fixture = service({
      async resolveState() {
        return [{ completed_at: null, state: "AUTHORIZED" }];
      },
    });

    await expect(fixture.service.resolveState()).rejects.toThrow(
      "could not be resolved",
    );
  });

  it.each([
    [{ completed_at: null, state: "PENDING_PROFILE" }],
    [[{ state: "PENDING_PROFILE" }]],
    [[{ completed_at: null, state: "PENDING_PROFILE" }, { completed_at: null, state: "UNAVAILABLE" }]],
  ])("T019-C-004 rejects malformed resolver payload %#", async (payload) => {
    const fixture = service({
      async resolveState() {
        return payload;
      },
    });

    await expect(fixture.service.resolveState()).rejects.toThrow(
      "could not be resolved",
    );
  });

  it.each(["COMPLETED", "ALREADY_COMPLETED"] as const)(
    "T019-C-005 parses bounded completion outcome %s",
    async (outcome) => {
      const complete = vi.fn(async () => completionRow(outcome));
      const fixture = service({ complete });

      await expect(fixture.service.complete(validInput)).resolves.toEqual({
        companyMembershipId,
        completedAt,
        outcome,
        platformUserId,
        reason: outcome,
      });
      expect(complete).toHaveBeenCalledWith({
        firstName: "Ada",
        lastName: "Lovelace",
        operationId: operationId.toLowerCase(),
      });
    },
  );

  it("T019-C-006 parses bounded denial without treating it as success", async () => {
    const fixture = service({
      async complete() {
        return [
          {
            company_membership_id: null,
            completed_at: null,
            outcome: "DENIED",
            platform_user_id: null,
            reason: "AUTHORIZATION_DENIED",
          },
        ];
      },
    });

    await expect(fixture.service.complete(validInput)).resolves.toEqual({
      companyMembershipId: null,
      completedAt: null,
      outcome: "DENIED",
      platformUserId: null,
      reason: "AUTHORIZATION_DENIED",
    });
  });

  it("T019-C-007 fails closed for an unknown completion outcome", async () => {
    const fixture = service({
      async complete() {
        return [
          {
            company_membership_id: companyMembershipId,
            completed_at: completedAt,
            outcome: "SUCCEEDED",
            platform_user_id: platformUserId,
            reason: "SUCCEEDED",
          },
        ];
      },
    });

    await expect(fixture.service.complete(validInput)).rejects.toThrow(
      "was not confirmed",
    );
  });

  it.each([
    { payload: [] },
    { payload: [{ outcome: "COMPLETED", reason: "COMPLETED" }] },
    {
      payload: [
        {
          company_membership_id: null,
          completed_at: completedAt,
          outcome: "COMPLETED",
          platform_user_id: platformUserId,
          reason: "COMPLETED",
        },
      ],
    },
  ])("T019-C-008 rejects malformed completion payload %#", async ({ payload }) => {
    const fixture = service({
      async complete() {
        return payload;
      },
    });

    await expect(fixture.service.complete(validInput)).rejects.toThrow(
      "was not confirmed",
    );
  });

  it("T019-C-009 rejects caller-selected authority fields at runtime", async () => {
    const fixture = service();
    const input = {
      ...validInput,
      maintenanceCompanyId: "19000000-0000-4000-8000-000000000099",
      role: "COMPANY_ADMIN",
    } as unknown as FirstAdminProfileCompletionInput;

    await expect(fixture.service.complete(input)).resolves.toMatchObject({
      outcome: "DENIED",
      reason: "INVALID_INPUT",
    });
    expect(fixture.createSource).not.toHaveBeenCalled();
  });

  it("T019-C-010 maps source and transport failures to generic retryable errors", async () => {
    const fixture = service({
      async complete() {
        throw new Error("raw database relation detail");
      },
      async resolveState() {
        throw new Error("raw PostgREST transport detail");
      },
    });

    await expect(fixture.service.complete(validInput)).rejects.toThrow(
      "First-admin profile completion was not confirmed.",
    );
    await expect(fixture.service.complete(validInput)).rejects.not.toThrow(
      /relation/i,
    );
    await expect(fixture.service.resolveState()).rejects.toThrow(
      "First-admin onboarding state could not be resolved.",
    );
    await expect(fixture.service.resolveState()).rejects.not.toThrow(
      /PostgREST/i,
    );
  });
});

describe("TASK-019 Work Item C authenticated Supabase source", () => {
  it("T019-C-011 invokes only the two purpose-specific RPCs with bounded arguments", async () => {
    const rpc = vi
      .fn()
      .mockResolvedValueOnce({ data: completionRow(), error: null })
      .mockResolvedValueOnce({
        data: [{ completed_at: null, state: "PENDING_PROFILE" }],
        error: null,
      });
    createSupabaseServerClientMock.mockResolvedValue({ rpc });
    const implementation = await createSupabaseFirstAdminProfileCompletionSource();

    await implementation.complete({
      firstName: "Ada",
      lastName: "Lovelace",
      operationId: operationId.toLowerCase(),
    });
    await implementation.resolveState();

    expect(createSupabaseServerClientMock).toHaveBeenCalledOnce();
    expect(rpc).toHaveBeenNthCalledWith(1, "complete_first_admin_onboarding", {
      p_first_name: "Ada",
      p_last_name: "Lovelace",
      p_operation_id: operationId.toLowerCase(),
    });
    expect(rpc).toHaveBeenNthCalledWith(
      2,
      "resolve_current_first_admin_onboarding_state",
    );
  });

  it("T019-C-012 rejects Supabase errors without leaking provider details", async () => {
    const rpc = vi.fn().mockResolvedValue({
      data: null,
      error: { message: "sensitive database detail" },
    });
    createSupabaseServerClientMock.mockResolvedValue({ rpc });
    const implementation = await createSupabaseFirstAdminProfileCompletionSource();

    await expect(implementation.resolveState()).rejects.toThrow(
      "First-admin onboarding-state RPC failed.",
    );
    await expect(implementation.resolveState()).rejects.not.toThrow(
      /sensitive/i,
    );
  });

  it("T019-C-013 keeps authority, privileged clients, direct writers, and offline completion absent", () => {
    const contract = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-profile-completion.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const application = readFileSync(
      new URL(
        "../src/modules/identity-authorization/application/first-admin-profile-completion-service.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const infrastructure = readFileSync(
      new URL(
        "../src/modules/identity-authorization/infrastructure/supabase/first-admin-profile-completion-source.ts",
        import.meta.url,
      ),
      "utf8",
    );
    const server = readFileSync(
      new URL("../src/modules/identity-authorization/server.ts", import.meta.url),
      "utf8",
    );
    const implementation = [contract, application, infrastructure].join("\n");
    const rpcNames = [...infrastructure.matchAll(/\.rpc\(\s*"([^"]+)"/g)].map(
      (match) => match[1],
    );

    expect(contract).not.toMatch(
      /tenantId|maintenanceCompanyId|companyId|intentId|role|membershipId|targetPlatformUserId|targetUserId|actorId|completionState|authorizationState/,
    );
    expect(rpcNames.sort()).toEqual(
      [
        "complete_first_admin_onboarding",
        "resolve_current_first_admin_onboarding_state",
      ].sort(),
    );
    expect(infrastructure).toContain("createSupabaseServerClient()");
    expect(implementation).not.toMatch(
      /supabaseSecretKey|SUPABASE_SECRET_KEY|service[_-]?role|auth\.admin|createClient\s*\(/i,
    );
    expect(implementation).not.toMatch(
      /\.from\s*\(|\.insert\s*\(|\.update\s*\(|\.delete\s*\(/,
    );
    expect(implementation).not.toMatch(
      /indexeddb|dexie|background.?sync|offline.?queue|outbox/i,
    );
    expect(server).toContain("getFirstAdminProfileCompletionService");
  });
});

describe("TASK-019 Work Item D HTTP completion route", () => {
  const completedResult = Object.freeze({
    companyMembershipId,
    completedAt,
    outcome: "COMPLETED" as const,
    platformUserId,
    reason: "COMPLETED" as const,
  });

  beforeEach(() => {
    getFirstAdminProfileCompletionServiceMock.mockReset();
    getFirstAdminProfileCompletionServiceMock.mockReturnValue({
      complete: vi.fn(async () => completedResult),
    });
  });

  it.each([
    ["wrong", "https://other.example.invalid"],
    ["missing", null],
  ])("T019-D-001 denies a %s origin before resolving the service", async (_case, origin) => {
    const response = await POST(routeRequest(validInput, { origin }));

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toEqual({ outcome: "INVALID_INPUT" });
    expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
    expectPrivateResponse(response);
  });

  it.each(["text/plain", "application/problem+json", null])(
    "T019-D-002 denies non-JSON content type %s before resolving the service",
    async (contentType) => {
      const response = await POST(routeRequest(validInput, { contentType }));

      expect(response.status).toBe(400);
      expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
      expectPrivateResponse(response);
    },
  );

  it("T019-D-003 accepts application/json with a standard charset parameter", async () => {
    const response = await POST(
      routeRequest(validInput, {
        contentType: "application/json; charset=utf-8",
      }),
    );

    expect(response.status).toBe(200);
    expect(getFirstAdminProfileCompletionServiceMock).toHaveBeenCalledOnce();
    expectPrivateResponse(response);
  });

  it("T019-D-004 denies malformed JSON without resolving the service", async () => {
    const response = await POST(routeRequest('{"firstName":'));

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toEqual({ outcome: "INVALID_INPUT" });
    expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
    expectPrivateResponse(response);
  });

  it.each([null, [], "Ada", 19, true])(
    "T019-D-005 denies non-object JSON %# before resolving the service",
    async (body) => {
      const response = await POST(routeRequest(JSON.stringify(body)));

      expect(response.status).toBe(400);
      expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
      expectPrivateResponse(response);
    },
  );

  it.each([
    ["missing", { firstName: "Ada", operationId }],
    ["extra", { ...validInput, harmless: "extra" }],
    ["authority", { ...validInput, maintenanceCompanyId: platformUserId }],
  ])("T019-D-006 denies an exact-key violation: %s", async (_case, body) => {
    const response = await POST(routeRequest(body));

    expect(response.status).toBe(400);
    expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
    expectPrivateResponse(response);
  });

  it.each([
    ["malformed operation", { ...validInput, operationId: "not-a-uuid" }],
    ["empty first name", { ...validInput, firstName: "   " }],
    ["empty last name", { ...validInput, lastName: "" }],
  ])("T019-D-007 denies invalid bounded input: %s", async (_case, body) => {
    const response = await POST(routeRequest(body));

    expect(response.status).toBe(400);
    expect(getFirstAdminProfileCompletionServiceMock).not.toHaveBeenCalled();
    expectPrivateResponse(response);
  });

  it.each(["COMPLETED", "ALREADY_COMPLETED"] as const)(
    "T019-D-008 maps %s to bounded HTTP 200 without internal IDs",
    async (outcome) => {
      const complete = vi.fn(async () => ({
        ...completedResult,
        outcome,
        reason: outcome,
      }));
      getFirstAdminProfileCompletionServiceMock.mockReturnValue({ complete });

      const response = await POST(routeRequest(validInput));
      const text = await response.text();

      expect(response.status).toBe(200);
      expect(JSON.parse(text)).toEqual({ outcome });
      expect(text).not.toMatch(/platformUserId|companyMembershipId|completedAt/);
      expect(complete).toHaveBeenCalledWith(validInput);
      expectPrivateResponse(response);
    },
  );

  it("T019-D-009 maps authoritative INVALID_INPUT to bounded HTTP 400", async () => {
    getFirstAdminProfileCompletionServiceMock.mockReturnValue({
      complete: vi.fn(async () => ({
        companyMembershipId: null,
        completedAt: null,
        outcome: "DENIED" as const,
        platformUserId: null,
        reason: "INVALID_INPUT" as const,
      })),
    });

    const response = await POST(routeRequest(validInput));

    expect(response.status).toBe(400);
    await expect(response.json()).resolves.toEqual({ outcome: "INVALID_INPUT" });
    expectPrivateResponse(response);
  });

  it.each([
    "AUTHORIZATION_DENIED",
    "SECURITY_CORRELATION_FAILURE",
    "IDENTITY_INCOMPATIBLE",
  ] as const)(
    "T019-D-010 maps %s to the same non-enumerating HTTP 403",
    async (reason) => {
      getFirstAdminProfileCompletionServiceMock.mockReturnValue({
        complete: vi.fn(async () => ({
          companyMembershipId: null,
          completedAt: null,
          outcome: "DENIED" as const,
          platformUserId: null,
          reason,
        })),
      });

      const response = await POST(routeRequest(validInput));

      expect(response.status).toBe(403);
      await expect(response.json()).resolves.toEqual({ outcome: "DENIED" });
      expectPrivateResponse(response);
    },
  );

  it.each([
    "INITIAL_MEMBERSHIP_CONFLICT",
    "ONBOARDING_ALREADY_COMPLETED",
  ] as const)("T019-D-011 maps %s to bounded HTTP 409", async (reason) => {
    getFirstAdminProfileCompletionServiceMock.mockReturnValue({
      complete: vi.fn(async () => ({
        companyMembershipId: null,
        completedAt: null,
        outcome: "DENIED" as const,
        platformUserId: null,
        reason,
      })),
    });

    const response = await POST(routeRequest(validInput));

    expect(response.status).toBe(409);
    await expect(response.json()).resolves.toEqual({ outcome: "CONFLICT" });
    expectPrivateResponse(response);
  });

  it("T019-D-012 maps service failures to bounded HTTP 503 without details", async () => {
    getFirstAdminProfileCompletionServiceMock.mockReturnValue({
      async complete() {
        throw new Error("sensitive PostgREST relation and RPC detail");
      },
    });

    const response = await POST(routeRequest(validInput));
    const text = await response.text();

    expect(response.status).toBe(503);
    expect(JSON.parse(text)).toEqual({ outcome: "RETRYABLE_FAILURE" });
    expect(text).not.toMatch(/sensitive|PostgREST|relation|RPC/i);
    expectPrivateResponse(response);
  });

  it("T019-D-013 keeps direct database, privileged Auth, and caller authority absent", () => {
    const route = readFileSync(
      new URL(
        "../app/api/first-admin/profile-completion/route.ts",
        import.meta.url,
      ),
      "utf8",
    );

    expect(route).toContain("getFirstAdminProfileCompletionService");
    expect(route).not.toMatch(
      /createSupabaseServerClient|\.rpc\s*\(|\.from\s*\(|\.insert\s*\(|\.update\s*\(|\.delete\s*\(/,
    );
    expect(route).not.toMatch(
      /supabaseSecretKey|SUPABASE_SECRET_KEY|service[_-]?role|auth\.admin/i,
    );
    expect(route).not.toMatch(
      /tenantId|companyId|maintenanceCompanyId|intentId|role|membershipId|actorId|targetUserId|authorizationState|completionState/,
    );
  });
});
