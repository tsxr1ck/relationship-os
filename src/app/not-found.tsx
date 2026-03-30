import Link from 'next/link';
import { Home, Heart } from 'lucide-react';
import { Button } from '@/components/ui/Button';

export default function NotFound() {
  return (
    <div className="min-h-screen bg-surface flex flex-col items-center justify-center px-6">
      <div className="text-center">
        <div className="mb-8 flex justify-center">
          <div className="relative">
            <div className="w-32 h-32 rounded-full bg-primary_container/20 flex items-center justify-center">
              <span className="text-6xl font-bold text-primary">404</span>
            </div>
            <div className="absolute -bottom-2 -right-2 w-12 h-12 rounded-full bg-choque/20 flex items-center justify-center">
              <Heart className="h-6 w-6 text-choque" />
            </div>
          </div>
        </div>
        
        <h1 className="text-3xl font-semibold text-on_surface mb-3">
          Ups, esta página se perdió
        </h1>
        <p className="text-on_surface_variant mb-8 max-w-sm mx-auto">
          Lo que buscas no está aquí. Quizás el amor los guíe a otro lugar.
        </p>
        
        <Link href="/dashboard">
          <Button size="lg">
            <Home className="mr-2 h-5 w-5" />
            Volver al inicio
          </Button>
        </Link>
      </div>
    </div>
  );
}
