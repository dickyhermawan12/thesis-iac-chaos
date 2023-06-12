"use client";

import toast from "react-hot-toast";
import { useRouter } from "next/navigation";
import { useSession } from "next-auth/react";

export default function DeleteButton({ id }: { id: string }) {
  const { data: session } = useSession();
  const router = useRouter();

  return (
    <button
      id="delete-post"
      onClick={async () => {
        const res = await fetch(
          `${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`,
          {
            method: "DELETE",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${session?.accessToken}`,
            },
          }
        );
        if (res.ok) {
          toast.success(
            "Your post has been deleted! Redirecting to post page..."
          );
          setTimeout(() => {
            router.push(`/post`);
            router.refresh();
          }, 2000);
        } else {
          toast.error(
            "There is an error deleting your post. Please try again later."
          );
        }
      }}
      className="my-4 border-red-600 bg-red-600 text-white hover:bg-white hover:text-red-600 flex h-8 w-44 items-center justify-center rounded-md border text-sm transition-all focus:outline-none"
    >
      Delete post
    </button>
  );
}
