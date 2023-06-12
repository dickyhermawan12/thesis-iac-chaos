import Link from "next/link";
import { getServerSession } from "next-auth/next";
import { authOptions } from "@/lib/auth";

async function getPost() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts`);
  const posts = await res.json();
  return posts;
}

export default async function Post() {
  const session = await getServerSession(authOptions);
  const posts = await getPost();
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Post</h1>
      {session && (
        <Link
          id="create-post"
          href="/post/create"
          className="my-4 border-black bg-black dark:bg-gray-800 dark:border-gray-800 text-white hover:bg-white hover:text-black flex h-8 w-44 items-center justify-center rounded-md border text-sm transition-all focus:outline-none"
        >
          Create New Post
        </Link>
      )}

      <div className="mt-4">
        {posts
          .sort((a: PostResponse, b: PostResponse) => {
            return (
              new Date(b.Post.created_at).getTime() -
              new Date(a.Post.created_at).getTime()
            );
          })
          .map((post: PostResponse) => (
            <Link
              key={post.Post.post_id}
              href={`/post/${post.Post.post_id}`}
              className="flex flex-col space-y-1 mb-4 post-title"
            >
              <div key={post.Post.post_id}>
                <h2 className="text-xl font-bold hover:underline">
                  {post.Post.title}
                </h2>
                <p>
                  {post.Post.body.length > 100
                    ? post.Post.body.substring(0, 100) + "..."
                    : post.Post.body}
                </p>
                <p className="text-sm text-neutral-500 dark:text-neutral-400">
                  {new Date(post.Post.created_at).toLocaleDateString("en-US", {
                    weekday: "long",
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </p>
              </div>
            </Link>
          ))}
      </div>
    </section>
  );
}
