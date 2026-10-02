import { randomUUID } from "node:crypto";

import {
  getPrivateAuthConfig,
  resolvePrivateKey,
} from "../../../../src/infrastructure/config/auth-private";
import {
  createLaterUserVerificationOperationToken,
  resolveLaterUserVerificationOperationToken,
} from "../../../../src/modules/identity-authorization/infrastructure/crypto/later-user-verification-operation";
import {
  getLaterUserEnrollmentVerificationService,
  type LaterUserEnrollmentVerificationResult,
} from "../../../../src/modules/identity-authorization/server";
import { type NextRequest, NextResponse } from "next/server";

type IssueOperationBody = Readonly<{
  action: "ISSUE_OPERATION";
}>;

type VerificationBody = Readonly<{
  action: "VERIFY";
  code: string;
  email: string;
  intentId: string;
  verificationOperationToken: string;
}>;

const PRIVATE_RESPONSE_HEADERS = Object.freeze({
  "Cache-Control": "private, no-cache, no-store, must-revalidate, max-age=0",
  Expires: "0",
  Pragma: "no-cache",
});

function parseBody(value: unknown): IssueOperationBody | VerificationBody | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    return null;
  }
  const row = value as Record<string, unknown>;
  if (
    row.action === "ISSUE_OPERATION" &&
    Object.keys(row).length === 1
  ) {
    return row as IssueOperationBody;
  }
  if (
    Object.keys(row).sort().join("\u0000") !==
      ["action", "code", "email", "intentId", "verificationOperationToken"]
        .sort()
        .join("\u0000") ||
    row.action !== "VERIFY" ||
    typeof row.code !== "string" ||
    row.code.length === 0 ||
    row.code.length > 512 ||
    typeof row.email !== "string" ||
    row.email.length === 0 ||
    row.email.length > 320 ||
    typeof row.intentId !== "string" ||
    row.intentId.length !== 36 ||
    typeof row.verificationOperationToken !== "string" ||
    row.verificationOperationToken.length === 0 ||
    row.verificationOperationToken.length > 256
  ) {
    return null;
  }
  return row as VerificationBody;
}

function response(
  result: LaterUserEnrollmentVerificationResult | null,
  status: number,
) {
  return NextResponse.json(
    result === null
      ? { handoffReady: false, outcome: "DENIED" }
      : {
          attemptNumber: result.attemptNumber,
          handoffReady: result.handoffReady,
          outcome: result.outcome,
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
    return response(null, 400);
  }

  let body: IssueOperationBody | VerificationBody | null = null;
  try {
    body = parseBody(await request.json());
  } catch {
    // The response remains bounded and non-enumerating.
  }
  if (body === null) {
    return response(null, 400);
  }

  if (body.action === "ISSUE_OPERATION") {
    const privateConfig = getPrivateAuthConfig();
    return NextResponse.json(
      {
        verificationOperationToken: createLaterUserVerificationOperationToken({
          keyMaterial: resolvePrivateKey(
            privateConfig.challengeHmacKeys,
            privateConfig.challengeHmacActiveVersion,
          ),
          keyVersion: privateConfig.challengeHmacActiveVersion,
          operationId: randomUUID(),
        }),
      },
      { headers: PRIVATE_RESPONSE_HEADERS, status: 200 },
    );
  }

  try {
    const privateConfig = getPrivateAuthConfig();
    const verificationOperationId =
      resolveLaterUserVerificationOperationToken({
        resolveKeyMaterial: (keyVersion) => {
          try {
            return resolvePrivateKey(
              privateConfig.challengeHmacKeys,
              keyVersion,
            );
          } catch {
            return null;
          }
        },
        token: body.verificationOperationToken,
      });
    if (verificationOperationId === null) {
      return response(null, 400);
    }
    const result = await getLaterUserEnrollmentVerificationService().verify(
      {
        code: body.code,
        email: body.email,
        intentId: body.intentId,
        verificationOperationId,
      },
    );
    return response(result, result.outcome === "CONSUMED" ? 200 : 400);
  } catch {
    return response(null, 503);
  }
}
