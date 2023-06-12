import { getServerSession } from "next-auth/next";
import { authOptions } from "@/lib/auth";
import Link from "next/link";

export default async function Home() {
  const session = await getServerSession(authOptions);
  return (
    <section className="text-neutral-800 dark:text-neutral-200">
      <h1 className="font-bold text-3xl font-serif">Microblogging App</h1>
      <p className="my-5">
        This is a microblogging app built with Next.js, FastAPI, and MySQL.
      </p>
      <p className="my-5">
        This app is intended to be a demo of a fullstack application for three
        tier architecture.
      </p>
      <p className="my-5">
        Backend URL: &nbsp;
        <Link
          href={`${process.env.NEXT_PUBLIC_BACKEND_URL}`}
          className="hover:underline inline"
        >
          {process.env.NEXT_PUBLIC_BACKEND_URL}
        </Link>
      </p>
    </section>
  );
}
