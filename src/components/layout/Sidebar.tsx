'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import { Home, Compass, Users, Calendar, Trophy, User } from 'lucide-react';

const navItems = [
  { href: '/dashboard', label: 'Inicio', icon: Home },
  { href: '/dashboard/descubrir', label: 'Descubrir', icon: Compass },
  { href: '/dashboard/nosotros', label: 'Nosotros', icon: Users },
  { href: '/dashboard/plan', label: 'Plan', icon: Calendar },
  { href: '/dashboard/retos', label: 'Retos', icon: Trophy },
  { href: '/dashboard/profile', label: 'Perfil', icon: User },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="hidden lg:flex flex-col fixed left-0 top-0 w-72 h-screen bg-linear-to-b from-surface to-primary/5 p-6 z-40">
      <div className="mb-10 mt-8 px-2">
        <h1 className="text-lg font-bold text-on_surface font-headline">
          Relationship OS
        </h1>
        <p className="text-sm font-medium text-on_surface_variant opacity-70">
          Tu mapa de relación
        </p>
      </div>

      <nav className="flex flex-col gap-2">
        {navItems.map((item) => {
          const isActive = item.href === '/dashboard'
            ? pathname === '/dashboard'
            : pathname.startsWith(item.href);
          const Icon = item.icon;

          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex items-center gap-4 p-4 rounded-2xl transition-all duration-300 hover:translate-x-1',
                isActive
                  ? 'bg-white text-primary shadow-sm'
                  : 'text-on_surface/70 hover:text-primary'
              )}
            >
              <Icon className="h-5 w-5" strokeWidth={isActive ? 2.5 : 2} />
              <span className="font-medium text-sm">{item.label}</span>
            </Link>
          );
        })}
      </nav>

      <div className="mt-auto p-4 bg-primary_container/20 rounded-3xl border border-primary_container/10">
        <p className="text-xs uppercase tracking-widest text-primary mb-2">
          Sesión
        </p>
        <Link
          href="/dashboard/questionnaire"
          className="w-full py-3 bg-primary text-white rounded-2xl font-semibold text-sm hover:opacity-90 transition-all active:scale-95 text-center block"
        >
          Evaluación
        </Link>
      </div>
    </aside>
  );
}
