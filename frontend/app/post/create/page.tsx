import PostForm from "../post-form";

export default function CreatePost() {
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Create Post</h1>
      <p className="text-sm text-gray-500">Create a post to share</p>
      <PostForm type="create" />
    </section>
  );
}
