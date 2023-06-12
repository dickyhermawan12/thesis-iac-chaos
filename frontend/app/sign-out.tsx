"use client";
import { signOut } from "next-auth/react";

export default function SignOut() {
  return (
    <button
      id="signout"
      className="my-4 border-black bg-black dark:bg-gray-800 dark:border-gray-800 text-white hover:bg-white hover:text-black flex h-8 w-44 items-center justify-center rounded-md border text-sm transition-all focus:outline-none"
      onClick={() => signOut()}
    >
      Sign Out
    </button>
  );
}
