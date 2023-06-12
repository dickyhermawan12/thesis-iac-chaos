import "./globals.css";
import { Inter } from "next/font/google";
import Sidebar from "./sidebar";
import { Toaster } from "react-hot-toast";
import { NextAuthProvider } from "./providers";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Microblog App",
  description: "A microblogging app built with Next.js, FastAPI, and MySQL.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body
        className={`antialiased max-w-4xl mb-40 flex flex-col md:flex-row mx-4 mt-8 md:mt-20 lg:mt-32 lg:mx-auto ${inter.className} dark:bg-neutral-900 dark:text-neutral-200`}
      >
        <Toaster />
        <NextAuthProvider>
          <Sidebar />
          <main className="max-w-2xl">{children}</main>
        </NextAuthProvider>
      </body>
    </html>
  );
}
