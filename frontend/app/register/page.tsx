import Form from "../form";

export default function Login() {
  return (
    <section>
      <h1 className="font-bold text-3xl font-serif">Register</h1>
      <p className="text-sm text-gray-500">
        Create an account with your email and password
      </p>
      <Form type="register" />
    </section>
  );
}
