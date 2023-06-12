import Link from "next/link";
import { getServerSession } from "next-auth/next";
import { authOptions } from "@/lib/auth";
import DeleteButton from "../delete-button";

async function getPost(id: string) {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts/${id}`);
  const post = await res.json();
  return post;
}

function replaceWithBr(text: string) {
  return text.replace(/\n/g, "<br />");
}

async function getPosts() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/posts`);
  const posts = await res.json();
  return posts;
}

// export async function generateStaticParams() {
//   const posts = await getPosts();
//   return posts.map((post: PostResponse) => ({
//     params: { id: post.Post.post_id.toString() },
//   }));
// }

export default async function Post({ params }: { params: { id: string } }) {
  const session = await getServerSession(authOptions);
  const userId = session?.user?.id;
  const post = await getPost(params.id);

  return (
    <section>
      <h1 className="font-bold text-3xl font-serif max-w-[650px]">
        {post.Post.title}
      </h1>
      <div className="mt-4 mb-4 font-mono text-sm">
        <div className="bg-neutral-100 dark:bg-neutral-800 rounded-md px-2 py-1 tracking-tighter w-fit">
          Posted by {post.Post.user.username} on&nbsp;
          {new Date(post.Post.created_at).toLocaleDateString("en-US", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric",
          })}
          &nbsp;·&nbsp;edited on&nbsp;
          {new Date(post.Post.updated_at).toLocaleDateString("en-US", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric",
          })}
        </div>
      </div>
      {session && userId === post.Post.user_id && (
        <div className="flex gap-4">
          <Link
            id="edit-post"
            href={`/post/${post.Post.post_id}/edit`}
            className="my-4 border-black bg-black dark:bg-gray-800 dark:border-gray-800 text-white hover:bg-white hover:text-black flex h-8 w-44 items-center justify-center rounded-md border text-sm transition-all focus:outline-none"
          >
            Edit your post
          </Link>
          <DeleteButton id={post.Post.post_id} />
        </div>
      )}
      <div
        dangerouslySetInnerHTML={{ __html: replaceWithBr(post.Post.body) }}
        className="prose prose-quoteless prose-neutral dark:prose-invert max-"
      ></div>
    </section>
  );
}
