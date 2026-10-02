import { notFound } from "next/navigation";

import { LaterUserVerificationForm } from "../../../later-user-verification-form";

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export default async function LaterUserVerificationPage({
  params,
}: Readonly<{ params: Promise<{ intentId: string }> }>) {
  const { intentId } = await params;
  if (!UUID_PATTERN.test(intentId)) {
    notFound();
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-950 px-6 py-12 text-slate-100">
      <LaterUserVerificationForm intentId={intentId} />
    </main>
  );
}
