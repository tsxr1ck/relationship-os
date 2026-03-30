import type { Metadata, Viewport } from "next";
import { DM_Serif_Display, Inter } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/supabase/hooks";
import { Toaster } from 'sonner';

const dmSerif = DM_Serif_Display({
  weight: "400",
  variable: "--font-dm-serif",
  subsets: ["latin"],
  display: "swap",
});

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Relationship OS",
  description: "Descubre cómo se aman, dónde conectan, dónde chocan y cómo mejorar juntos.",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es-MX" className={`dark ${dmSerif.variable} ${inter.variable}`}>
      <body className="min-h-screen bg-base text-text-primary antialiased">
        <AuthProvider>
          {children}
        </AuthProvider>
        <Toaster position="bottom-center" toastOptions={{
          style: {
            background: 'var(--color-surface-2)',
            color: 'var(--color-text-primary)',
            border: '1px solid var(--color-border)',
          },
        }} />
      </body>
    </html>
  );
}
