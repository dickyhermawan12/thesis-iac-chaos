import Form from "../form";

export default function Login() {
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Sign In</h1>
      <p className="text-sm text-gray-500">
        Use your email and password to sign in
      </p>
      <Form type="login" />
    </section>
  );
}
