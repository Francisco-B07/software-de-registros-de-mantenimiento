import type { SupabaseServerCookieMethods } from "../../../../src/infrastructure/supabase/server";
import {
  getFirstAdminPostVerificationService,
  type FirstAdminPostVerificationResult,
} from "../../../../src/modules/identity-authorization/server";
import { type NextRequest, NextResponse } from "next/server";

type CookieMutation = Parameters<
  SupabaseServerCookieMethods["setAll"]
>[0][number];

type VerificationRequestBody = Readonly<{
  code: string;
  email: string;
  intentId: string;
  verificationOperationId: string;
}>;

const PRIVATE_RESPONSE_HEADERS = Object.freeze({
  "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
  Expires: "0",
  Pragma: "no-cache",
});

function boundedResponse(
  outcome: FirstAdminPostVerificationResult["outcome"],
  status: number,
) {
  return NextResponse.json(
    { outcome },
    { headers: PRIVATE_RESPONSE_HEADERS, status },
  );
}

function parseRequestBody(value: unknown): VerificationRequestBody | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return null;
  }

  const record = value as Record<string, unknown>;
  if (
    Object.keys(record).sort().join("\u0000") !==
      ["code", "email", "intentId", "verificationOperationId"]
        .sort()
        .join("\u0000") ||
    typeof record.code !== "string" ||
    record.code.length === 0 ||
    record.code.length > 512 ||
    typeof record.email !== "string" ||
    record.email.length === 0 ||
    record.email.length > 320 ||
    typeof record.intentId !== "string" ||
    record.intentId.length !== 36 ||
    typeof record.verificationOperationId !== "string" ||
    record.verificationOperationId.length !== 36
  ) {
    return null;
  }

  return Object.freeze({
    code: record.code,
    email: record.email,
    intentId: record.intentId,
    verificationOperationId: record.verificationOperationId,
  });
}

function createResponseCookieTransport(request: NextRequest) {
  const cookieMutations: CookieMutation[] = [];
  const responseHeaders = new Headers();
  const cookieMethods: SupabaseServerCookieMethods = Object.freeze({
    getAll() {
      return request.cookies.getAll();
    },
    setAll(cookiesToSet, headers) {
      cookieMutations.push(...cookiesToSet);
      Object.entries(headers).forEach(([name, value]) => {
        responseHeaders.set(name, value);
      });
    },
  });

  return Object.freeze({
    apply(response: NextResponse) {
      cookieMutations.forEach(({ name, options, value }) => {
        response.cookies.set(name, value, options);
      });
      responseHeaders.forEach((value, name) => {
        response.headers.set(name, value);
      });
      return response;
    },
    cookieMethods,
  });
}

function statusFor(outcome: FirstAdminPostVerificationResult["outcome"]) {
  switch (outcome) {
    case "SUCCESS":
      return 200;
    case "RETRYABLE_NEW_ATTEMPT":
    case "RETRYABLE_FAILURE":
      return 503;
    case "FRESH_PROOF_REQUIRED":
      return 409;
    case "TERMINAL_FAILURE":
      return 400;
  }
}

export async function POST(request: NextRequest) {
  if (
    request.headers.get("origin") !== request.nextUrl.origin ||
    request.headers.get("content-type")?.split(";", 1)[0] !==
      "application/json"
  ) {
    return boundedResponse("TERMINAL_FAILURE", 400);
  }

  let body: VerificationRequestBody | null = null;
  try {
    body = parseRequestBody(await request.json());
  } catch {
    // The response below deliberately keeps malformed input non-enumerating.
  }
  if (body === null) {
    return boundedResponse("TERMINAL_FAILURE", 400);
  }

  const transport = createResponseCookieTransport(request);
  let result: FirstAdminPostVerificationResult;
  try {
    result = await getFirstAdminPostVerificationService(
      transport.cookieMethods,
    ).complete(body);
  } catch {
    return boundedResponse("RETRYABLE_FAILURE", 503);
  }

  try {
    return transport.apply(
      boundedResponse(result.outcome, statusFor(result.outcome)),
    );
  } catch {
    return boundedResponse("RETRYABLE_FAILURE", 503);
  }
}
