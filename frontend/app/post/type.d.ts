type User = {
  user_id: number;
  username: string;
  email: string;
  created_at: Date;
  updated_at: Date;
}

type Post = {
  title: string;
  body: string;
  post_id: number;
  created_at: Date;
  updated_at: Date;
  user_id: number;
  user: User;
}

type PostResponse = {
  Post: Post;
  likes: number;
}