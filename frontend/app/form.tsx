"use client";

import React, { useState } from "react";
import { signIn } from "next-auth/react";
import LoadingDots from "./loading-dots";
import toast from "react-hot-toast";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function Form({ type }: { type: "login" | "register" }) {
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    if (type === "login") {
      signIn("credentials", {
        redirect: false,
        email: e.currentTarget.email.value,
        password: e.currentTarget.password.value,
        // @ts-ignore
      }).then(({ ok, error }) => {
        setLoading(false);
        if (ok && error === null) {
          router.refresh();
        } else {
          toast.error(error);
        }
      });
    } else {
      fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/users`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          username: e.currentTarget.username.value,
          email: e.currentTarget.email.value,
          password: e.currentTarget.password.value,
        }),
      }).then(async (res) => {
        setLoading(false);
        if (res.status === 201) {
          toast.success("Account created! Redirecting to login...");
          setTimeout(() => {
            router.push("/login");
          }, 2000);
        } else {
          toast.error((await res.json()).detail);
        }
      });
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-4 py-8">
      {type === "register" ? (
        <div>
          <label
            htmlFor="username"
            className="block text-xs text-gray-600 uppercase dark:text-neutral-200"
          >
            Username
          </label>
          <input
            id="username"
            name="username"
            type="text"
            placeholder="someusername"
            autoComplete="username"
            required
            className="mt-1 block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-black focus:outline-none focus:ring-black sm:text-sm enabled:dark:text-gray-800"
          />
        </div>
      ) : null}
      <div>
        <label
          htmlFor="email"
          className="block text-xs text-gray-600 uppercase dark:text-neutral-200"
        >
          Email Address
        </label>
        <input
          id="email"
          name="email"
          type="email"
          placeholder="someemail@mail.com"
          autoComplete="email"
          required
          className="mt-1 block w-full appearance-none rounded-md border border-gray-300 px-3 py-2 placeholder-gray-400 shadow-sm focus:border-black focus:outline-none focus:ring-black sm:text-sm enabled:dark:text-gray-800"
        />
      </div>
      <div>
        <label
          htmlFor="password"
          className="block text-xs text-gray-600 uppercase dark:text-neutral-200"
        >
          Password
        </label>
        <input
          id="password"
          name="password"
          type="password"
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
          <p>{type === "login" ? "Log In" : "Register"}</p>
        )}
      </button>
      {type === "login" ? (
        <p className="text-center text-sm text-gray-600 dark:text-neutral-200">
          Don&apos;t have an account?{" "}
          <Link
            href="/register"
            className="font-semibold text-gray-800 dark:text-gray-100 hover:underline"
          >
            Sign up
          </Link>{" "}
          for free.
        </p>
      ) : (
        <p className="text-center text-sm text-gray-600 dark:text-neutral-200">
          Already have an account?{" "}
          <Link
            href="/login"
            className="font-semibold text-gray-800 dark:text-gray-100 hover:underline"
          >
            Log In
          </Link>{" "}
          instead.
        </p>
      )}
    </form>
  );
}
