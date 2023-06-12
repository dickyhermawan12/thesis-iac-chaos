"use client";

import { usePathname } from "next/navigation";
import { useSession } from "next-auth/react";
import Link from "next/link";
import Image from "next/image";
import clsx from "clsx";
import { useState, useEffect } from "react";

const navAuth = {
  "/": {
    name: "home",
  },
  "/post": {
    name: "post",
  },
  "/profile": {
    name: "profile",
  },
};

const navUnauth = {
  "/": {
    name: "home",
  },
  "/post": {
    name: "post",
  },
  "/login": {
    name: "login",
  },
  "/register": {
    name: "register",
  },
};

export default function Sidebar() {
  const { data: session, status } = useSession();
  const [like, setLike] = useState(0);
  const [dir, setDir] = useState(0);

  let navItems = status === "authenticated" ? navAuth : navUnauth;

  let pathname = usePathname() || "/";

  // get initial like count and dir
  useEffect(() => {
    if (/^\/post\/\d+(?!\/edit)$/.test(pathname)) {
      const id = pathname.split("/")[2];
      fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`)
        .then((res) => res.json())
        .then((data) => {
          setLike(data.likes);

          fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/like/${id}`, {
            headers: {
              Authorization: `Bearer ${session?.accessToken}`,
            },
          })
            .then((res) => res.json())
            .then((data) => {
              setDir(data.dir);
            });
        });
    }
  }, [pathname, session?.accessToken]);

  const handleLike = async () => {
    const id = pathname.split("/")[2];
    const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/like`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${session?.accessToken}`,
      },
      body: JSON.stringify({
        post_id: id,
        dir: dir === 1 ? 0 : 1,
      }),
    });
    const post = await res.json();
    setLike(like + post.dir - dir);
    setDir(post.dir);
  };

  return (
    <aside className="md:w-[150px] md:flex-shrink-0 -mx-4 md:mx-0 md:px-0">
      <div className="lg:sticky lg:top-20">
        <div className="ml-2 md:ml-[12px] mb-2 px-4 md:px-0 md:mb-8 space-y-10">
          <Link href="/">
            <Image
              src="/logo.svg"
              alt="logo"
              width={100}
              height={100}
              className="cursor-pointer hover:opacity-80 transition-all duration-200 ease-in-out dark:invert"
            />
          </Link>
        </div>
        <div>
          <nav
            className="flex flex-row md:flex-col items-start relative px-4 md:px-0 pb-0 fade md:overflow-auto scroll-pr-6 md:relative"
            id="nav"
          >
            <div className="flex flex-row md:flex-col space-x-0 pr-10 mb-2 mt-2 md:mt-0">
              {Object.entries(navItems).map(([path, { name }]) => {
                const isActive = path === pathname;
                return (
                  <Link
                    key={path}
                    href={path}
                    className={clsx(
                      "transition-all hover:text-neutral-800 dark:hover:text-neutral-200 flex align-middle",
                      {
                        "text-neutral-500": !isActive,
                        "font-bold": isActive,
                      }
                    )}
                  >
                    <span className="relative py-[5px] px-[10px] ">
                      {name}
                      {path === pathname ? (
                        <span
                          className="absolute bottom-0 left-0 right-0 h-[2px] bg-neutral-800 dark:bg-neutral-200"
                          aria-hidden="true"
                        />
                      ) : null}
                    </span>
                  </Link>
                );
              })}
            </div>
          </nav>
        </div>
        {
          // check if pathname in /post/:id add like button using icon
          session !== null && /^\/post\/\d+(?!\/edit)$/.test(pathname) ? (
            <div className="flex pt-4">
              <div className="cursor-pointer">
                <button
                  className={`${
                    dir === 1
                      ? "text-red-400 hover:text-gray-400 bg-rose-50 hover:bg-gray-700"
                      : "text-gray-400 hover:text-red-400 bg-gray-700 hover:bg-rose-50"
                  } flex justify-around h-min w-20 space-x-1 items-center rounded-full py-1 px-2 font-medium`}
                  onClick={handleLike}
                  id="like-btn"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 fill-current transition-all duration-200 ease-in-out"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
                    />
                  </svg>
                  <p id="like-count" className="font-semibold text-sm">
                    {like}
                  </p>
                </button>
              </div>
            </div>
          ) : null
        }
      </div>
    </aside>
  );
}
