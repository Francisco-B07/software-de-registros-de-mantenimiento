import { describe, expect, it } from "vitest";

import { getSupabasePublicConfig } from "../src/infrastructure/config/supabase-public";

const validEnvironment = {
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
  NEXT_PUBLIC_SUPABASE_URL: "https://project.example.invalid",
};

describe("Supabase public configuration", () => {
  it("does not validate configuration until the boundary is invoked", () => {
    expect(getSupabasePublicConfig).toBeTypeOf("function");
  });

  it("accepts controlled public test values", () => {
    expect(getSupabasePublicConfig(validEnvironment)).toEqual({
      publishableKey: "test-publishable-key",
      url: "https://project.example.invalid",
    });
  });

  it("fails explicitly when the URL is absent", () => {
    expect(() =>
      getSupabasePublicConfig({
        NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY:
          validEnvironment.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
      }),
    ).toThrowError("NEXT_PUBLIC_SUPABASE_URL");
  });

  it("fails explicitly when the publishable key is absent", () => {
    expect(() =>
      getSupabasePublicConfig({
        NEXT_PUBLIC_SUPABASE_URL: validEnvironment.NEXT_PUBLIC_SUPABASE_URL,
      }),
    ).toThrowError("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY");
  });

  it("rejects an invalid URL without including its value in the error", () => {
    const invalidValue = "not-a-project-url";

    expect(() =>
      getSupabasePublicConfig({
        ...validEnvironment,
        NEXT_PUBLIC_SUPABASE_URL: invalidValue,
      }),
    ).toThrowError("NEXT_PUBLIC_SUPABASE_URL");

    try {
      getSupabasePublicConfig({
        ...validEnvironment,
        NEXT_PUBLIC_SUPABASE_URL: invalidValue,
      });
    } catch (error) {
      expect(error).toBeInstanceOf(Error);
      expect((error as Error).message).not.toContain(invalidValue);
    }
  });
});
