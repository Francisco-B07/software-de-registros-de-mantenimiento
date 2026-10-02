type AppOriginEnvironment = Readonly<{
  APP_ORIGIN?: string;
}>;

export function getTrustedAppOrigin(
  environment: AppOriginEnvironment = { APP_ORIGIN: process.env.APP_ORIGIN },
): string {
  const value = environment.APP_ORIGIN?.trim();
  if (!value) {
    throw new Error("Missing required trusted application origin.");
  }

  const parsed = new URL(value);
  if (
    !["http:", "https:"].includes(parsed.protocol) ||
    parsed.username !== "" ||
    parsed.password !== "" ||
    parsed.pathname !== "/" ||
    parsed.search !== "" ||
    parsed.hash !== ""
  ) {
    throw new Error("Invalid trusted application origin.");
  }
  return parsed.origin;
}
