import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../../src/infrastructure/config/auth-private";
import { createLaterUserVerificationCode } from "../../../../src/modules/identity-authorization/infrastructure/crypto/later-user-verification-code";
import { createUnavailableLaterUserVerificationDelivery } from "../../../../src/modules/identity-authorization/infrastructure/delivery/later-user-verification-delivery";
import {
  getLaterUserEnrollmentService,
  type LaterUserEnrollmentIssueResult,
  type LaterUserIntendedRole,
} from "../../../../src/modules/identity-authorization/server";
import { type NextRequest, NextResponse } from "next/server";

type EstablishBody = Readonly<{
  action: "ESTABLISH";
  challengeId: string;
  email: string;
  establishmentOperationId: string;
  intendedRole: LaterUserIntendedRole;
  intentId: string;
  issueOperationId: string;
}>;

type ResendBody = Readonly<{
  action: "RESEND";
  challengeId: string;
  intentId: string;
  issueOperationId: string;
}>;

const PRIVATE_RESPONSE_HEADERS = Object.freeze({
  "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
  Expires: "0",
  Pragma: "no-cache",
});

function exactKeys(value: Record<string, unknown>, keys: readonly string[]) {
  return (
    Object.keys(value).sort().join("\u0000") ===
    [...keys].sort().join("\u0000")
  );
}

function parseBody(value: unknown): EstablishBody | ResendBody | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return null;
  }
  const row = value as Record<string, unknown>;
  const commonValid =
    typeof row.intentId === "string" &&
    row.intentId.length === 36 &&
    typeof row.challengeId === "string" &&
    row.challengeId.length === 36 &&
    typeof row.issueOperationId === "string" &&
    row.issueOperationId.length === 36;

  if (
    row.action === "ESTABLISH" &&
    commonValid &&
    exactKeys(row, [
      "action",
      "challengeId",
      "email",
      "establishmentOperationId",
      "intendedRole",
      "intentId",
      "issueOperationId",
    ]) &&
    typeof row.email === "string" &&
    row.email.length > 0 &&
    row.email.length <= 320 &&
    typeof row.establishmentOperationId === "string" &&
    row.establishmentOperationId.length === 36 &&
    (row.intendedRole === "COMPANY_ADMIN" || row.intendedRole === "TECHNICIAN")
  ) {
    return row as EstablishBody;
  }

  if (
    row.action === "RESEND" &&
    commonValid &&
    exactKeys(row, ["action", "challengeId", "intentId", "issueOperationId"])
  ) {
    return row as ResendBody;
  }

  return null;
}

function boundedResponse(result: LaterUserEnrollmentIssueResult, status = 200) {
  return NextResponse.json(
    {
      changed: result.changed,
      delivery: result.delivery,
      intentId: result.intentId,
      outcome: result.outcome,
      reason: result.reason,
    },
    { headers: PRIVATE_RESPONSE_HEADERS, status },
  );
}

function failure(status: number, reason = "INVALID_INPUT") {
  return NextResponse.json(
    {
      changed: false,
      delivery: "NOT_ATTEMPTED",
      intentId: null,
      outcome: "DENIED",
      reason,
    },
    { headers: PRIVATE_RESPONSE_HEADERS, status },
  );
}

export async function POST(request: NextRequest) {
  if (
    request.headers.get("origin") !== request.nextUrl.origin ||
    request.headers.get("content-type")?.split(";", 1)[0] !==
      "application/json"
  ) {
    return failure(400);
  }

  let body: EstablishBody | ResendBody | null = null;
  try {
    body = parseBody(await request.json());
  } catch {
    // The response remains bounded and non-enumerating.
  }
  if (body === null) {
    return failure(400);
  }

  try {
    const privateConfig = getPrivateAuthConfig();
    const code = createLaterUserVerificationCode({
      challengeId: body.challengeId,
      issueOperationId: body.issueOperationId,
      keyMaterial: resolvePrivateKey(
        privateConfig.challengeHmacKeys,
        privateConfig.challengeHmacActiveVersion,
      ),
    });
    const service = getLaterUserEnrollmentService(
      createUnavailableLaterUserVerificationDelivery(),
    );
    const result =
      body.action === "ESTABLISH"
        ? await service.establish({ ...body, code })
        : await service.resend({ ...body, code });

    const status =
      result.outcome === "CONFLICT" || result.outcome === "STALE_OR_CONFLICT"
        ? 409
        : result.outcome === "DENIED"
          ? 403
          : 200;
    return boundedResponse(result, status);
  } catch {
    return failure(503, "NOT_CONFIRMED");
  }
}
