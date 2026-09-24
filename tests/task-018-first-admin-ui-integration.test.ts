import { readFileSync } from "node:fs";

import { NextRequest } from "next/server";
import { describe, expect, it, vi } from "vitest";

const { getFirstAdminPostVerificationServiceMock } = vi.hoisted(() => ({
  getFirstAdminPostVerificationServiceMock: vi.fn(),
}));

vi.mock("../src/modules/identity-authorization/server", () => ({
  getFirstAdminPostVerificationService:
    getFirstAdminPostVerificationServiceMock,
}));

import { POST } from "../app/api/first-admin/verification/route";
import { createFirstAdminPostVerificationService } from "../src/modules/identity-authorization/application/first-admin-post-verification-service";

const input = Object.freeze({
  code: "opaque-proof",
  email: "first-admin@example.invalid",
  intentId: "11111111-1111-4111-8111-111111111111",
  verificationOperationId: "22222222-2222-4222-8222-222222222222",
});

function services(
  sessionOutcome:
    | "SESSION_ESTABLISHED"
    | "SESSION_ALREADY_ESTABLISHED"
    | "SESSION_RECOVERY_REQUIRED"
    | "IDENTITY_INCOMPATIBLE"
    | "AUTH_SESSION_DELIVERY_FAILED"
    | "RETRYABLE_FAILURE"
    | "SECURITY_CORRELATION_FAILURE" = "SESSION_ESTABLISHED",
  verificationOutcome:
    | "CONSUMED"
    | "EXHAUSTED"
    | "INVALID" = "CONSUMED",
  handoffReady = true,
) {
  const establish = vi.fn(async () => ({ outcome: sessionOutcome }));
  const verify = vi.fn(async () => ({
    attemptNumber: 1,
    handoffReady,
    outcome: verificationOutcome,
  }));

  return {
    establish,
    service: createFirstAdminPostVerificationService({
      sessionEstablishmentService: { establish },
      verificationService: { verify },
    }),
    verify,
  };
}

describe("TASK-018 Work Item D minimal UI integration", () => {
  it.each(["SESSION_ESTABLISHED", "SESSION_ALREADY_ESTABLISHED"] as const)(
    "maps %s to the same bounded browser success",
    async (sessionOutcome) => {
      const { establish, service, verify } = services(sessionOutcome);

      await expect(service.complete(input)).resolves.toEqual({
        outcome: "SUCCESS",
      });
      expect(verify).toHaveBeenCalledWith(input);
      expect(establish).toHaveBeenCalledWith(input.intentId);
    },
  );

  it("keeps the verified handoff inside one server orchestration", async () => {
    const { establish, service, verify } = services();

    await service.complete(input);

    expect(verify.mock.invocationCallOrder[0]).toBeLessThan(
      establish.mock.invocationCallOrder[0],
    );
    expect(establish).toHaveBeenCalledTimes(1);
  });

  it.each([
    ["INVALID", true, "RETRYABLE_NEW_ATTEMPT"],
    ["EXHAUSTED", true, "FRESH_PROOF_REQUIRED"],
    ["CONSUMED", false, "TERMINAL_FAILURE"],
  ] as const)(
    "bounds verification outcome %s without invoking session establishment",
    async (verificationOutcome, handoffReady, expected) => {
      const { establish, service } = services(
        "SESSION_ESTABLISHED",
        verificationOutcome,
        handoffReady,
      );

      await expect(service.complete(input)).resolves.toEqual({
        outcome: expected,
      });
      expect(establish).not.toHaveBeenCalled();
    },
  );

  it.each([
    ["RETRYABLE_FAILURE", "RETRYABLE_FAILURE"],
    ["SESSION_RECOVERY_REQUIRED", "FRESH_PROOF_REQUIRED"],
    ["IDENTITY_INCOMPATIBLE", "TERMINAL_FAILURE"],
    ["AUTH_SESSION_DELIVERY_FAILED", "TERMINAL_FAILURE"],
    ["SECURITY_CORRELATION_FAILURE", "TERMINAL_FAILURE"],
  ] as const)(
    "maps session outcome %s to safe outcome %s",
    async (sessionOutcome, expected) => {
      const { service } = services(sessionOutcome);

      await expect(service.complete(input)).resolves.toEqual({
        outcome: expected,
      });
    },
  );

  it("implements pending, UX-only duplicate suppression, bounded retry, and online-only behavior", () => {
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );

    expect(client).toContain('type VisibleState =');
    expect(client).toContain('"PENDING"');
    expect(client).toContain('"RETRYABLE"');
    expect(client).toContain('disabled={!canSubmit}');
    expect(client).toContain('fetch("/api/first-admin/verification"');
    expect(client).toContain('cache: "no-store"');
    expect(client).toContain('router.replace("/pending-profile")');
    expect(client).not.toMatch(
      /localStorage|sessionStorage|indexedDB|Dexie|serviceWorker|navigator\.serviceWorker|outbox/i,
    );
  });

  it("keeps the browser response bounded and preserves the TASK-011 cookie/header path", () => {
    const route = readFileSync(
      new URL(
        "../app/api/first-admin/verification/route.ts",
        import.meta.url,
      ),
      "utf8",
    );

    expect(route).toContain("getFirstAdminPostVerificationService");
    expect(route).toContain("transport.cookieMethods");
    expect(route).toContain("response.cookies.set");
    expect(route).toContain("response.headers.set");
    expect(route).toContain("PRIVATE_RESPONSE_HEADERS");
    expect(route).not.toMatch(/access_token|refresh_token|technicalPassword/);
    expect(route).not.toMatch(/maintenanceCompanyId|tenant|role|membership/i);
  });

  it("commits Work Item C cookies and anti-cache headers on the bounded response", async () => {
    getFirstAdminPostVerificationServiceMock.mockImplementation(
      (cookieMethods) => ({
        async complete(received: unknown) {
          expect(received).toEqual(input);
          expect(cookieMethods.getAll()).toEqual([
            { name: "existing-cookie", value: "existing-value" },
          ]);
          cookieMethods.setAll(
            [
              {
                name: "session-cookie",
                options: {
                  httpOnly: true,
                  path: "/",
                  sameSite: "lax",
                  secure: true,
                },
                value: "opaque-cookie-value",
              },
            ],
            {
              "Cache-Control":
                "private, no-cache, no-store, must-revalidate, max-age=0",
              Expires: "0",
              Pragma: "no-cache",
            },
          );
          return { outcome: "SUCCESS" as const };
        },
      }),
    );
    const request = new NextRequest(
      "https://app.example.invalid/api/first-admin/verification",
      {
        body: JSON.stringify(input),
        headers: {
          "content-type": "application/json",
          cookie: "existing-cookie=existing-value",
          origin: "https://app.example.invalid",
        },
        method: "POST",
      },
    );

    const response = await POST(request);

    await expect(response.json()).resolves.toEqual({ outcome: "SUCCESS" });
    expect(response.status).toBe(200);
    expect(response.cookies.get("session-cookie")).toEqual(
      expect.objectContaining({
        httpOnly: true,
        name: "session-cookie",
        path: "/",
        sameSite: "lax",
        secure: true,
        value: "opaque-cookie-value",
      }),
    );
    expect(response.headers.get("cache-control")).toContain("no-store");
    expect(response.headers.get("expires")).toBe("0");
    expect(response.headers.get("pragma")).toBe("no-cache");
  });

  it("rejects cross-origin or malformed requests without invoking the trusted flow", async () => {
    getFirstAdminPostVerificationServiceMock.mockClear();
    const request = new NextRequest(
      "https://app.example.invalid/api/first-admin/verification",
      {
        body: JSON.stringify(input),
        headers: {
          "content-type": "application/json",
          origin: "https://other.example.invalid",
        },
        method: "POST",
      },
    );

    const response = await POST(request);

    await expect(response.json()).resolves.toEqual({
      outcome: "TERMINAL_FAILURE",
    });
    expect(response.status).toBe(400);
    expect(getFirstAdminPostVerificationServiceMock).not.toHaveBeenCalled();
  });

  it("maps unexpected server failures to one retryable response without details", async () => {
    getFirstAdminPostVerificationServiceMock.mockImplementationOnce(() => {
      throw new Error("sensitive provider identity state");
    });
    const request = new NextRequest(
      "https://app.example.invalid/api/first-admin/verification",
      {
        body: JSON.stringify(input),
        headers: {
          "content-type": "application/json",
          origin: "https://app.example.invalid",
        },
        method: "POST",
      },
    );

    const response = await POST(request);
    const body = await response.text();

    expect(response.status).toBe(503);
    expect(JSON.parse(body)).toEqual({ outcome: "RETRYABLE_FAILURE" });
    expect(body).not.toMatch(/sensitive|provider|identity/i);
  });

  it("renders only the minimal pending-profile shell", () => {
    const shell = readFileSync(
      new URL("../app/pending-profile/page.tsx", import.meta.url),
      "utf8",
    );

    expect(shell).toContain("Sesión establecida");
    expect(shell).toContain("Perfil pendiente");
    expect(shell).not.toMatch(/<form|<input|dashboard|membership|tenant|from\(|rpc\(/i);
  });

  it("does not transport authority material in the success destination", () => {
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );
    const destination = client.match(/router\.replace\("([^"]+)"\)/)?.[1];

    expect(destination).toBe("/pending-profile");
    expect(destination).not.toMatch(/[?#]/);
    expect(destination).not.toMatch(
      /intent|email|company|tenant|role|user|membership|grant|challenge|token|provider|reconciliation/i,
    );
  });

  it("keeps visible failures generic and non-enumerating", () => {
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );
    const messages = client.match(/return "[^"]+";/g)?.join("\n") ?? "";

    expect(messages).not.toMatch(
      /account|cuenta|tenant|empresa|membership|membresía|provider|subject|grant|challenge/i,
    );
  });
});

describe("TASK-018 Work Item D canonical route/locator security tests 26..34", () => {
  it("26 renders the dedicated route with the route-supplied opaque locator", () => {
    const page = readFileSync(
      new URL(
        "../app/first-admin/verification/[intentId]/page.tsx",
        import.meta.url,
      ),
      "utf8",
    );

    expect(page).toContain("params: Promise<Readonly<{ intentId: string }>>");
    expect(page).toContain("const { intentId } = await params");
    expect(page).toContain("<FirstAdminVerificationForm intentId={intentId} />");
  });

  it("27 exposes exactly email + code as editable proof inputs and no manual locator", () => {
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );
    const inputNames = [...client.matchAll(/name="([^"]+)"/g)].map(
      (match) => match[1],
    );

    expect(inputNames).toEqual(["email", "code"]);
    expect(client).not.toContain('name="intentId"');
    expect(client).not.toContain("Referencia de acceso");
  });

  it("28 derives body.intentId from the readonly route prop, not editable form data", () => {
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );

    expect(client).toContain("type FirstAdminVerificationFormProps = Readonly<{");
    expect(client).toContain("intentId: string;");
    expect(client).toMatch(/JSON\.stringify\(\{[\s\S]*intentId,[\s\S]*verificationOperationId/);
    expect(client).not.toContain('formData.get("intentId")');
  });

  it("29 gives an invalid or cross-intent locator no handoff/session authority", async () => {
    const { establish, service, verify } = services(
      "SESSION_ESTABLISHED",
      "INVALID",
      false,
    );
    const foreignLocatorInput = {
      ...input,
      intentId: "33333333-3333-4333-8333-333333333333",
    };

    await expect(service.complete(foreignLocatorInput)).resolves.toEqual({
      outcome: "RETRYABLE_NEW_ATTEMPT",
    });
    expect(verify).toHaveBeenCalledWith(foreignLocatorInput);
    expect(establish).not.toHaveBeenCalled();
  });

  it("30 does not let a correct locator bypass TASK-017 proof verification", async () => {
    const { establish, service, verify } = services(
      "SESSION_ESTABLISHED",
      "INVALID",
      true,
    );

    await expect(service.complete(input)).resolves.toEqual({
      outcome: "RETRYABLE_NEW_ATTEMPT",
    });
    expect(verify).toHaveBeenCalledWith(input);
    expect(establish).not.toHaveBeenCalled();
  });

  it("31 establishes only after authoritative handoffReady in the same orchestration", async () => {
    const { establish, service, verify } = services(
      "SESSION_ESTABLISHED",
      "CONSUMED",
      true,
    );

    await expect(service.complete(input)).resolves.toEqual({ outcome: "SUCCESS" });
    expect(verify.mock.invocationCallOrder[0]).toBeLessThan(
      establish.mock.invocationCallOrder[0],
    );
    expect(establish).toHaveBeenCalledWith(input.intentId);
  });

  it("32 keeps the pre-auth verification route free of proof or authority material", () => {
    const page = readFileSync(
      new URL(
        "../app/first-admin/verification/[intentId]/page.tsx",
        import.meta.url,
      ),
      "utf8",
    );

    expect(page).toContain("params: Promise<Readonly<{ intentId: string }>>");
    expect(page).not.toMatch(
      /searchParams|email|code|maintenanceCompanyId|tenant|role|challengeId|grantId|authUserId|accessToken|refreshToken|technicalPassword/,
    );
  });

  it("33 enforces route privacy/referrer hygiene, neutral root, and exact replacement success navigation", () => {
    const page = readFileSync(
      new URL(
        "../app/first-admin/verification/[intentId]/page.tsx",
        import.meta.url,
      ),
      "utf8",
    );
    const root = readFileSync(new URL("../app/page.tsx", import.meta.url), "utf8");
    const client = readFileSync(
      new URL("../app/first-admin-verification-form.tsx", import.meta.url),
      "utf8",
    );

    expect(page).toContain('export const dynamic = "force-dynamic"');
    expect(page).toContain('export const fetchCache = "force-no-store"');
    expect(page).toContain("export const revalidate = 0");
    expect(page).toContain('referrer: "no-referrer"');
    expect(root).not.toContain("FirstAdminVerificationForm");
    expect(client).toContain('router.replace("/pending-profile")');
    expect(client).not.toMatch(/router\.(push|replace)\([^)]*[?#]/);
  });

  it("34 rejects email-only intent selection when the route locator is absent", async () => {
    getFirstAdminPostVerificationServiceMock.mockClear();
    const request = new NextRequest(
      "https://app.example.invalid/api/first-admin/verification",
      {
        body: JSON.stringify({
          code: input.code,
          email: input.email,
          verificationOperationId: input.verificationOperationId,
        }),
        headers: {
          "content-type": "application/json",
          origin: "https://app.example.invalid",
        },
        method: "POST",
      },
    );

    const response = await POST(request);

    await expect(response.json()).resolves.toEqual({
      outcome: "TERMINAL_FAILURE",
    });
    expect(response.status).toBe(400);
    expect(getFirstAdminPostVerificationServiceMock).not.toHaveBeenCalled();
  });

  it("keeps the locator out of browser persistence and avoids deliberate full-URL telemetry", () => {
    const sources = [
      "../app/first-admin-verification-form.tsx",
      "../app/first-admin/verification/[intentId]/page.tsx",
      "../app/api/first-admin/verification/route.ts",
    ]
      .map((relativePath) =>
        readFileSync(new URL(relativePath, import.meta.url), "utf8"),
      )
      .join("\n");

    expect(sources).not.toMatch(
      /localStorage|sessionStorage|indexedDB|IndexedDB|Dexie/,
    );
    expect(sources).not.toMatch(/console\.|logger\.|telemetry|analytics/i);
  });
});
