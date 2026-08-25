import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { createBrowserClientMock, createServerClientMock, cookiesMock } = vi.hoisted(
  () => ({
    cookiesMock: vi.fn(),
    createBrowserClientMock: vi.fn(),
    createServerClientMock: vi.fn(),
  }),
);

vi.mock("@supabase/ssr", () => ({
  createBrowserClient: createBrowserClientMock,
  createServerClient: createServerClientMock,
}));

vi.mock("next/headers", () => ({
  cookies: cookiesMock,
}));

import { createSupabaseBrowserClient } from "../src/infrastructure/supabase/browser";
import { createSupabaseServerClient } from "../src/infrastructure/supabase/server";

const publicUrl = "https://project.example.invalid";
const publishableKey = "test-publishable-key";

describe("Supabase client factories", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_URL", publicUrl);
    vi.stubEnv("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY", publishableKey);
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  it("constructs the browser client with public configuration and no request", () => {
    const client = { boundary: "browser" };
    const fetchMock = vi.spyOn(globalThis, "fetch");
    createBrowserClientMock.mockReturnValue(client);

    expect(createSupabaseBrowserClient()).toBe(client);
    expect(createBrowserClientMock).toHaveBeenCalledWith(publicUrl, publishableKey);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it("constructs the non-privileged server client with read-only cookie plumbing", async () => {
    const client = { boundary: "server" };
    const cookieValues = [{ name: "test-cookie", value: "test-value" }];
    const cookieStore = { getAll: vi.fn(() => cookieValues) };
    const fetchMock = vi.spyOn(globalThis, "fetch");
    cookiesMock.mockResolvedValue(cookieStore);
    createServerClientMock.mockReturnValue(client);

    await expect(createSupabaseServerClient()).resolves.toBe(client);
    expect(createServerClientMock).toHaveBeenCalledWith(
      publicUrl,
      publishableKey,
      expect.objectContaining({
        cookies: expect.objectContaining({ getAll: expect.any(Function) }),
      }),
    );

    const options = createServerClientMock.mock.calls[0]?.[2];
    expect(options.cookies.getAll()).toEqual(cookieValues);
    expect(options.cookies).not.toHaveProperty("setAll");
    expect(fetchMock).not.toHaveBeenCalled();
  });
});
