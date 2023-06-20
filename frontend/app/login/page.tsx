import Form from "../form";

export default function Login() {
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Log In</h1>
      <p className="text-sm text-gray-500">
        Use your email and password to log in
      </p>
      <Form type="login" />
    </section>
  );
}
