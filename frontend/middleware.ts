import { getToken } from "next-auth/jwt";
import { getSession } from "next-auth/react"
import { NextRequest, NextResponse } from "next/server";

export default async function middleware(req: NextRequest) {
  // Get the pathname of the request (e.g. /, /protected)
  const path = req.nextUrl.pathname;

  // array of paths that need authentication
  const authenticatedPaths = ["/profile", "/post/create"];

  // If it's the root path or starts with /post/[id] (and not /post/create or /post/[id]/edit), return NextResponse.next()
  if (path === "/" ||
    /^\/post\/\d+(?!\/edit)$/.test(path)
  ) {
    return NextResponse.next();
  }

  const session = await getToken({
    req,
    secret: process.env.NEXTAUTH_SECRET,
  });
  // block access to /profile, /post/create, /post/[id]/edit that the path starts with and redirect to /login
  if (!session && (authenticatedPaths.some((p) => path.startsWith(p)) || /^\/post\/\d+\/edit$/.test(path))) {
    return NextResponse.redirect(new URL("/login", req.url));
  } else if (session) {
    if (path === "/login" || path === "/register") {
      return NextResponse.redirect(new URL("/", req.url));
    } else {
      // If it's /post/[id]/edit, check if the user is the author of the post
      const userId = session?.id;
      if (/^\/post\/\d+\/edit$/.test(path)) {
        const id = path.split("/")[2];
        const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`);
        const post = await res.json();
        if (post.Post.user_id !== userId) {
          return NextResponse.redirect(new URL(`/post/${id}`, req.url));
        }
      }
    }
  } else {
    return NextResponse.next();
  }
}
