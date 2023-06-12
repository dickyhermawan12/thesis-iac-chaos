import { getToken } from "next-auth/jwt";
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  const session = await getToken({
    req,
    secret: process.env.NEXTAUTH_SECRET,
  });
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/test?id=${session?.id}`, {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${session?.accessToken}`,
    },
  })
  const data = await res.json()

  return NextResponse.json({ data })
}