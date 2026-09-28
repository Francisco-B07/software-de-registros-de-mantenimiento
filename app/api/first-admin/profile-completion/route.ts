import {
  getFirstAdminProfileCompletionService,
  type FirstAdminProfileCompletionInput,
  type FirstAdminProfileCompletionResult,
} from "../../../../src/modules/identity-authorization/server";
import { type NextRequest, NextResponse } from "next/server";

type BrowserOutcome =
  | "ALREADY_COMPLETED"
  | "COMPLETED"
  | "CONFLICT"
  | "DENIED"
  | "INVALID_INPUT"
  | "RETRYABLE_FAILURE";

const PRIVATE_RESPONSE_HEADERS = Object.freeze({
  "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
  Expires: "0",
  Pragma: "no-cache",
});

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function boundedResponse(outcome: BrowserOutcome, status: number) {
  return NextResponse.json(
    { outcome },
    { headers: PRIVATE_RESPONSE_HEADERS, status },
  );
}

function hasJsonContentType(request: NextRequest): boolean {
  const mediaType = request.headers
    .get("content-type")
    ?.split(";", 1)[0]
    .trim()
    .toLowerCase();

  return mediaType === "application/json";
}

function parseRequestBody(
  value: unknown,
): FirstAdminProfileCompletionInput | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return null;
  }

  const record = value as Record<string, unknown>;
  if (
    Object.keys(record).sort().join("\u0000") !==
      ["firstName", "lastName", "operationId"].sort().join("\u0000") ||
    typeof record.firstName !== "string" ||
    record.firstName.trim().length === 0 ||
    typeof record.lastName !== "string" ||
    record.lastName.trim().length === 0 ||
    typeof record.operationId !== "string" ||
    !UUID_PATTERN.test(record.operationId)
  ) {
    return null;
  }

  return Object.freeze({
    firstName: record.firstName,
    lastName: record.lastName,
    operationId: record.operationId,
  });
}

function projectResult(result: FirstAdminProfileCompletionResult) {
  if (
    result.outcome === "COMPLETED" ||
    result.outcome === "ALREADY_COMPLETED"
  ) {
    return boundedResponse(result.outcome, 200);
  }

  switch (result.reason) {
    case "INVALID_INPUT":
      return boundedResponse("INVALID_INPUT", 400);
    case "AUTHORIZATION_DENIED":
    case "SECURITY_CORRELATION_FAILURE":
    case "IDENTITY_INCOMPATIBLE":
      return boundedResponse("DENIED", 403);
    case "INITIAL_MEMBERSHIP_CONFLICT":
    case "ONBOARDING_ALREADY_COMPLETED":
      return boundedResponse("CONFLICT", 409);
  }
}

export async function POST(request: NextRequest) {
  if (
    request.headers.get("origin") !== request.nextUrl.origin ||
    !hasJsonContentType(request)
  ) {
    return boundedResponse("INVALID_INPUT", 400);
  }

  let body: FirstAdminProfileCompletionInput | null = null;
  try {
    body = parseRequestBody(await request.json());
  } catch {
    // Malformed JSON remains a bounded, non-enumerating client error.
  }
  if (body === null) {
    return boundedResponse("INVALID_INPUT", 400);
  }

  try {
    const result = await getFirstAdminProfileCompletionService().complete(body);
    return projectResult(result);
  } catch {
    return boundedResponse("RETRYABLE_FAILURE", 503);
  }
}
