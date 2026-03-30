import { redirect } from 'next/navigation';

export default function HomePage() {
  // Middleware handles auth redirects. This is a fallback.
  redirect('/login');
}
