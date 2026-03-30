'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Home, Compass, Users, Calendar, Trophy, User } from 'lucide-react';
import { cn } from '@/lib/utils';

const navItems = [
  { href: '/dashboard', label: 'Inicio', icon: Home },
  { href: '/dashboard/descubrir', label: 'Descubrir', icon: Compass },
  { href: '/dashboard/nosotros', label: 'Nosotros', icon: Users },
  { href: '/dashboard/plan', label: 'Plan', icon: Calendar },
  { href: '/dashboard/retos', label: 'Retos', icon: Trophy },
];

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 safe-area-bottom">
      <div className="mx-auto max-w-md">
        <div className="flex items-center justify-around border-t border-outline_variant bg-surface/80 px-2 py-2 backdrop-blur-xl">
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
                  'flex flex-col items-center gap-0.5 rounded-xl px-2.5 py-1.5 transition-all duration-200',
                  isActive
                    ? 'text-primary'
                    : 'text-on_surface_variant hover:text-on_surface'
                )}
              >
                <div
                  className={cn(
                    'rounded-xl p-1.5 transition-colors',
                    isActive && 'bg-primary_container/50'
                  )}
                >
                  <Icon className="h-5 w-5" strokeWidth={isActive ? 2.5 : 2} />
                </div>
                <span className="text-[10px] font-medium">{item.label}</span>
              </Link>
            );
          })}
        </div>
      </div>
    </nav>
  );
}
