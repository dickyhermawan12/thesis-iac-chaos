import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import axios from "axios";

export default NextAuth({
  providers: [
    CredentialsProvider({
      credentials: {},
      // @ts-ignore
      async authorize(credentials, _) {
        const { email, password } = credentials as {
          email: string;
          password: string;
        };

        try {
          const res = await axios.post(
            "http://localhost:8080/login",
            {
              email,
              password,
            },
            {
              headers: {
                "Content-Type": "application/json",
              },
            }
          );
          return res.data;
        } catch (e) {
          throw new Error("Invalid username or password");
        }
      },
    }),
  ],
  callbacks: {
    async jwt({token, user}) {
      if (user) {
        token.accessToken = user.access_token;
      }
      return token;
    },
    async session({session, token}) {
      session.accessToken = token.accessToken;
      return session;
    }
  },
  secret: process.env.NEXTAUTH_SECRET,
});
