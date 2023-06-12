import { Session } from "next-auth";
import { JWT } from "next-auth/jwt";

declare module "next-auth" {
  interface Session {
    accessToken: string;
    user: {
      id: number;
    };
  }

  interface User {
    access_token: string;
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    accessToken: string;
    id: number;
  }
}
