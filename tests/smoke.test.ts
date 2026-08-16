import { describe, expect, it } from "vitest";

describe("tooling smoke test", () => {
  it("executes a TypeScript test in Node", () => {
    expect(1 + 1).toBe(2);
  });
});
