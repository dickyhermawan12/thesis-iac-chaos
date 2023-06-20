"use client";
import { signOut } from "next-auth/react";
import toast from "react-hot-toast";
import { useRouter } from "next/navigation";

export default function SignOut() {
  const router = useRouter();
  return (
    <button
      id="signout"
      className="my-4 border-black bg-black dark:bg-gray-800 dark:border-gray-800 text-white hover:bg-white hover:text-black flex h-8 w-44 items-center justify-center rounded-md border text-sm transition-all focus:outline-none"
      onClick={() =>
        signOut({
          redirect: false,
        }).then(() => {
          router.refresh();
        })
      }
    >
      Log Out
    </button>
  );
}
