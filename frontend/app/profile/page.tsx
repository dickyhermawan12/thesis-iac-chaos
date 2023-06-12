import SignOut from "../sign-out";
import { getServerSession } from "next-auth/next";
import { authOptions } from "@/lib/auth";

async function getUser(id: number | undefined) {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/users/${id}`);
  const user = await res.json();
  return user;
}

export default async function Profile() {
  const session = await getServerSession(authOptions);
  const user = await getUser(session?.user.id);
  return (
    <section className="text-neutral-800 dark:text-neutral-200">
      <h1 className="font-bold text-3xl font-serif">About Me</h1>
      <p className="my-5">
        Hi, my name is <b>{user.username}</b>!
      </p>
      <p className="my-5">
        My email is <b>{user.email}</b>.
      </p>
      <p className="my-5">
        I joined on{" "}
        <b>
          {new Date(user.created_at).toLocaleDateString("en-US", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric",
          })}
        </b>
        .
      </p>
      {session && <SignOut />}
    </section>
  );
}
