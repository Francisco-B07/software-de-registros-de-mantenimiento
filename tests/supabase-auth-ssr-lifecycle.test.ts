import { readFileSync } from "node:fs";

import { NextRequest } from "next/server";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { createServerClientMock, getClaimsMock } = vi.hoisted(() => ({
  createServerClientMock: vi.fn(),
  getClaimsMock: vi.fn(),
}));

vi.mock("@supabase/ssr", () => ({
  createServerClient: createServerClientMock,
}));

import { updateSupabaseAuthSession } from "../src/infrastructure/supabase/proxy";

const publicUrl = "https://project.example.invalid";
const publishableKey = "test-publishable-key";

describe("TASK-011 Supabase Auth SSR lifecycle foundation", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", publicUrl);
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY", publishableKey);
    getClaimsMock.mockResolvedValue({ data: null, error: null });
    createServerClientMock.mockReturnValue({
      auth: { getClaims: getClaimsMock },
    });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("creates a caller-scoped client and validates claims without a real request", async () => {
    const firstRequest = new NextRequest("https://app.example.invalid/first");
    const secondRequest = new NextRequest("https://app.example.invalid/second");

    const firstResponse = await updateSupabaseAuthSession(firstRequest);
    const secondResponse = await updateSupabaseAuthSession(secondRequest);

    expect(firstResponse.status).toBe(200);
    expect(secondResponse.status).toBe(200);
    expect(createServerClientMock).toHaveBeenCalledTimes(2);
    expect(createServerClientMock).toHaveBeenNthCalledWith(
      1,
      publicUrl,
      publishableKey,
      expect.any(Object),
    );
    expect(getClaimsMock).toHaveBeenCalledTimes(2);
  });

  it("reads request cookies and propagates refreshed cookies and headers", async () => {
    const request = new NextRequest("https://app.example.invalid/private", {
      headers: { cookie: "existing-cookie=existing-value" },
    });
    const cookieOptions = {
      httpOnly: true,
      path: "/",
      sameSite: "lax" as const,
      secure: true,
    };
    const antiCacheHeaders = {
      "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
      Expires: "0",
      Pragma: "no-cache",
    };

    createServerClientMock.mockImplementation((_url, _key, options) => ({
      auth: {
        getClaims: vi.fn(async () => {
          expect(options.cookies.getAll()).toEqual([
            { name: "existing-cookie", value: "existing-value" },
          ]);
          options.cookies.setAll(
            [
              {
                name: "refreshed-cookie",
                options: cookieOptions,
                value: "refreshed-value",
              },
            ],
            antiCacheHeaders,
          );
          return { data: null, error: null };
        }),
      },
    }));

    const response = await updateSupabaseAuthSession(request);

    expect(request.cookies.get("refreshed-cookie")?.value).toBe(
      "refreshed-value",
    );
    expect(response.cookies.get("refreshed-cookie")).toEqual(
      expect.objectContaining({
        httpOnly: true,
        name: "refreshed-cookie",
        path: "/",
        sameSite: "lax",
        secure: true,
        value: "refreshed-value",
      }),
    );
    for (const [name, value] of Object.entries(antiCacheHeaders)) {
      expect(response.headers.get(name)).toBe(value);
    }
  });

  it("preserves cookies and headers across multiple setAll batches", async () => {
    const request = new NextRequest("https://app.example.invalid/refresh");
    const cookieOptions = {
      httpOnly: true,
      path: "/",
      sameSite: "lax" as const,
      secure: true,
    };

    createServerClientMock.mockImplementation((_url, _key, options) => ({
      auth: {
        getClaims: vi.fn(async () => {
          options.cookies.setAll(
            [
              {
                name: "cookie-a",
                options: cookieOptions,
                value: "value-a",
              },
            ],
            {
              "X-Batch-A": "value-a",
              "X-Shared": "first-value",
            },
          );
          options.cookies.setAll(
            [
              {
                name: "cookie-b",
                options: cookieOptions,
                value: "value-b",
              },
            ],
            {
              "X-Batch-B": "value-b",
              "X-Shared": "second-value",
            },
          );
          return { data: null, error: null };
        }),
      },
    }));

    const response = await updateSupabaseAuthSession(request);

    expect(request.cookies.get("cookie-a")?.value).toBe("value-a");
    expect(request.cookies.get("cookie-b")?.value).toBe("value-b");
    expect(response.cookies.get("cookie-a")?.value).toBe("value-a");
    expect(response.cookies.get("cookie-b")?.value).toBe("value-b");
    expect(response.headers.get("X-Batch-A")).toBe("value-a");
    expect(response.headers.get("X-Batch-B")).toBe("value-b");
    expect(response.headers.get("X-Shared")).toBe("second-value");
    expect(response.status).toBe(200);
    expect(response.headers.get("location")).toBeNull();
  });

  it("continues anonymous callers without redirects or inferred authorization", async () => {
    const request = new NextRequest("https://app.example.invalid/public");

    const response = await updateSupabaseAuthSession(request);
    const options = createServerClientMock.mock.calls[0]?.[2];

    expect(options.cookies.getAll()).toEqual([]);
    expect(response.status).toBe(200);
    expect(response.headers.get("location")).toBeNull();
  });

  it("fails with a sanitized error when identity validation throws", async () => {
    getClaimsMock.mockRejectedValue(
      new Error("sensitive-access-token sensitive-refresh-token"),
    );

    await expect(
      updateSupabaseAuthSession(
        new NextRequest("https://app.example.invalid/failure"),
      ),
    ).rejects.toThrow("Supabase Auth session validation failed.");
  });

  it("keeps the root Proxy thin and the implementation free of product authority", () => {
    const implementationFiles = [
      new URL("../proxy.ts", import.meta.url),
      new URL("../src/infrastructure/supabase/proxy.ts", import.meta.url),
      new URL("../src/infrastructure/supabase/server.ts", import.meta.url),
    ];
    const implementation = implementationFiles
      .map((file) => readFileSync(file, "utf8"))
      .join("\n");
    const rootProxy = readFileSync(implementationFiles[0], "utf8");

    expect(rootProxy).toContain("updateSupabaseAuthSession(request)");
    expect(rootProxy).toContain("_next/static");
    expect(rootProxy).toContain("_next/image");
    expect(rootProxy).not.toMatch(/redirect|\/login|pathname/);
    expect(implementation).toContain("auth.getClaims()");
    expect(implementation).not.toMatch(/getSession\s*\(/);
    expect(implementation).not.toMatch(
      /service[_-]role|SUPABASE_SERVICE_ROLE_KEY|SUPABASE_SECRET_KEY|auth\.admin|admin\.createUser/i,
    );
    expect(implementation).not.toMatch(
      /\.from\s*\(|\.rpc\s*\(|storage\.|channel\s*\(|signIn|signUp|signOut|verifyOtp|exchangeCodeForSession/,
    );
    expect(implementation).not.toMatch(
      /maintenance_company|company_membership|user_client_access|support_access_grant/i,
    );
  });
});
