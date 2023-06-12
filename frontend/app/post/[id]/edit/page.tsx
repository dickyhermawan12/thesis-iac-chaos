import PostForm from "../../post-form";

export default function EditPost() {
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Edit Post</h1>
      <p className="text-sm text-gray-500">Edit your post here.</p>
      <PostForm type="edit" />
    </section>
  );
}
