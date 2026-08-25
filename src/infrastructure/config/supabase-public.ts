export type SupabasePublicConfig = Readonly<{
  publishableKey: string;
  url: string;
}>;

type SupabasePublicEnvironment = Readonly<{
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY?: string;
  NEXT_PUBLIC_SUPABASE_URL?: string;
}>;

function requirePublicValue(
  name: keyof SupabasePublicEnvironment,
  value: string | undefined,
): string {
  const normalizedValue = value?.trim();

  if (!normalizedValue) {
    throw new Error(`Missing required public application configuration: ${name}.`);
  }

  return normalizedValue;
}

function requireHttpUrl(name: "NEXT_PUBLIC_SUPABASE_URL", value: string): string {
  let parsedUrl: URL;

  try {
    parsedUrl = new URL(value);
  } catch {
    throw new Error(`Invalid URL in public application configuration: ${name}.`);
  }

  if (parsedUrl.protocol !== "http:" && parsedUrl.protocol !== "https:") {
    throw new Error(`Invalid URL in public application configuration: ${name}.`);
  }

  return value;
}

export function getSupabasePublicConfig(
  environment: SupabasePublicEnvironment = {
    NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY:
      process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  },
): SupabasePublicConfig {
  const url = requirePublicValue(
    "NEXT_PUBLIC_SUPABASE_URL",
    environment.NEXT_PUBLIC_SUPABASE_URL,
  );
  const publishableKey = requirePublicValue(
    "NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY",
    environment.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
  );

  return {
    publishableKey,
    url: requireHttpUrl("NEXT_PUBLIC_SUPABASE_URL", url),
  };
}
