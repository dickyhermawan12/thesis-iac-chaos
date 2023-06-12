"use client";

import React, { useState } from "react";
import LoadingDots from "../loading-dots";
import toast from "react-hot-toast";
import { useRouter } from "next/navigation";
import { useSession } from "next-auth/react";
import { usePathname } from "next/navigation";
import { useEffect } from "react";

export default function PostForm({ type }: { type: "create" | "edit" }) {
  const { data: session } = useSession();
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const [post, setPost] = useState({
    title: "",
    body: "",
  });

  const id = usePathname().split("/")[2];

  useEffect(() => {
    if (type === "edit") {
      fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`)
        .then((res) => res.json())
        .then((data) => {
          setPost({
            title: data.Post.title,
            body: data.Post.body,
          });
        });
    }
  }, [id, type]);

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    if (type === "create") {
      fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${session?.accessToken}`,
        },
        body: JSON.stringify({
          title: e.currentTarget.postTitle.value,
          body: e.currentTarget.postBody.value,
        }),
      }).then(async (res) => {
        setLoading(false);
        if (res.status === 201) {
          toast.success(
            "Your post has been created! Redirecting to post page..."
          );
          const id = (await res.json()).post_id;
          setTimeout(() => {
            router.push(`/post/${id}`);
            router.refresh();
          }, 2000);
        } else {
          toast.error((await res.json()).detail[0].msg);
        }
      });
    } else {
      fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${session?.accessToken}`,
        },
        body: JSON.stringify({
          title: e.currentTarget.postTitle.value,
          body: e.currentTarget.postBody.value,
        }),
      }).then(async (res) => {
        setLoading(false);
        if (res.status === 200) {
          toast.success(
            "Your post has been edited! Redirecting to post page..."
          );
          const id = (await res.json()).post_id;
          setTimeout(() => {
            router.push(`/post/${id}`);
          }, 2000);
        } else {
          toast.error((await res.json()).detail[0].msg);
        }
      });
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-4 py-8 min-w-[600px]">
      <div>
        <label
          htmlFor="postTitle"
          className="block text-xs text-gray-600 uppercase dark:text-neutral-200"
        >
          Title
        </label>
        <input
          id="posttitle"
          name="postTitle"
          type="text"
          placeholder="somepost title"
          autoComplete="title"
          {...((type === "edit" && { defaultValue: post.title }) as any)}
          required
          className="mt-1 block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-black focus:outline-none focus:ring-black sm:text-sm enabled:dark:text-gray-800"
        />
      </div>
      <div>
        <label
          htmlFor="postBody"
          className="block text-xs text-gray-600 uppercase dark:text-neutral-200"
        >
          Write your post
        </label>
        <textarea
          id="postbody"
          name="postBody"
          placeholder="somepost body"
          autoComplete="body"
          rows={10}
          {...((type === "edit" && { defaultValue: post.body }) as any)}
          required
          className="mt-1 block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-black focus:outline-none focus:ring-black sm:text-sm enabled:dark:text-gray-800"
        />
      </div>
      <button
        id="submit"
        disabled={loading}
        className={`${
          loading
            ? "cursor-not-allowed border-gray-200 bg-gray-100"
            : "border-black bg-black dark:bg-gray-800 dark:border-gray-800 text-white hover:bg-white hover:text-black"
        } flex h-10 w-full items-center justify-center rounded-md border text-sm transition-all focus:outline-none`}
      >
        {loading ? (
          <LoadingDots color="#808080" />
        ) : (
          <p>{type === "create" ? "Create Post" : "Edit Post"}</p>
        )}
      </button>
    </form>
  );
}
