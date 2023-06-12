import type { NextAuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import jwt_decode from "jwt-decode";
import axios from "axios"

export const authOptions: NextAuthOptions = {
  jwt: {
    maxAge: 60 * 150, // 30 minutes
  },
  session: {
    strategy: "jwt",
    maxAge: 60 * 30, // 30 minutes
  },
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
            `${process.env.NEXT_PUBLIC_BACKEND_URL}/login`
            ,
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
    async jwt({ token, user }) {
      if (user) {
        token.accessToken = user.access_token;
        const decoded = jwt_decode(user.access_token);
        // @ts-ignore
        token.id = decoded.user_id;
      }
      return token;
    },
    async session({ session, token }) {
      session.accessToken = token.accessToken;
      session.user = {
        id: token.id,
      };
      return session;
    }
  },
  secret: process.env.NEXTAUTH_SECRET,
};
