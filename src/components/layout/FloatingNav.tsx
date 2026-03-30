'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Home, Compass, Heart, Calendar, Trophy, ClipboardList, Gamepad2 } from 'lucide-react';
import { cn } from '@/lib/utils';

const navItems = [
  { href: '/dashboard', label: 'Inicio', icon: Home, color: 'var(--color-ai)' },
  { href: '/dashboard/descubrir', label: 'Descubrir', icon: Compass, color: 'var(--color-ai)' },
  { href: '/dashboard/nosotros', label: 'Nosotros', icon: Heart, color: 'var(--color-conexion)' },
  { href: '/dashboard/plan', label: 'Plan', icon: Calendar, color: 'var(--color-cuidado)' },
  { href: '/dashboard/retos', label: 'Retos', icon: Trophy, color: 'var(--color-camino)' },
  { href: '/dashboard/evaluaciones', label: 'Quizzes', icon: Gamepad2, color: 'var(--color-ai)' },
];

export function FloatingNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-4 left-1/2 -translate-x-1/2 z-50 lg:hidden" style={{ width: 'calc(100% - 32px)', maxWidth: '380px' }}>
      <div
        className="flex items-center justify-around px-3 py-2.5 rounded-3xl"
        style={{
          background: 'rgba(21, 18, 26, 0.85)',
          backdropFilter: 'blur(20px)',
          WebkitBackdropFilter: 'blur(20px)',
          border: '1px solid var(--color-border)',
        }}
      >
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
                'flex flex-col items-center gap-1 rounded-2xl px-3 py-1.5 transition-all duration-200',
                isActive
                  ? 'text-text-primary'
                  : 'text-text-tertiary'
              )}
            >
              <Icon className="h-5 w-5" strokeWidth={isActive ? 2 : 1.5} />
              <span className="text-[10px] font-medium" style={{ color: isActive ? 'var(--color-text-primary)' : 'var(--color-text-tertiary)' }}>
                {item.label}
              </span>
              {/* Active dot indicator */}
              {isActive && (
                <div
                  className="w-1 h-1 rounded-full -mt-0.5"
                  style={{ background: item.color }}
                />
              )}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
