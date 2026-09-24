import type { Metadata } from "next";

import { FirstAdminVerificationForm } from "../../../first-admin-verification-form";

export const dynamic = "force-dynamic";
export const fetchCache = "force-no-store";
export const revalidate = 0;

export const metadata: Metadata = {
  referrer: "no-referrer",
};

type FirstAdminVerificationPageProps = Readonly<{
  params: Promise<Readonly<{ intentId: string }>>;
}>;

export default async function FirstAdminVerificationPage({
  params,
}: FirstAdminVerificationPageProps) {
  const { intentId } = await params;

  return (
    <main className="grid min-h-dvh place-items-center bg-slate-950 px-5 py-10 text-slate-50">
      <FirstAdminVerificationForm intentId={intentId} />
    </main>
  );
}
