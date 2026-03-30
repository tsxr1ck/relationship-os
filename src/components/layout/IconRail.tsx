'use client';

import { useState, useEffect, useRef } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { usePathname, useRouter } from 'next/navigation';
import { cn } from '@/lib/utils';
import { Home, Compass, Heart, Calendar, Trophy, ClipboardList, Gamepad2 } from 'lucide-react';

const navItems = [
  { href: '/dashboard', label: 'Inicio', icon: Home, color: 'var(--color-ai)' },
  { href: '/dashboard/descubrir', label: 'Descubrir', icon: Compass, color: 'var(--color-ai)' },
  { href: '/dashboard/nosotros', label: 'Nosotros', icon: Heart, color: 'var(--color-conexion)' },
  { href: '/dashboard/plan', label: 'Plan', icon: Calendar, color: 'var(--color-cuidado)' },
  { href: '/dashboard/retos', label: 'Retos', icon: Trophy, color: 'var(--color-camino)' },
  { href: '/dashboard/evaluaciones', label: 'Quizzes', icon: Gamepad2, color: 'var(--color-ai)' },
];

export function IconRail() {
  const pathname = usePathname();
  const router = useRouter();
  const [hoveredIdx, setHoveredIdx] = useState<number | null>(null);

  return (
    <aside className="hidden lg:flex flex-col items-center fixed left-0 top-0 w-16 h-screen z-40"
      style={{ background: 'var(--color-surface-1)', borderRight: '1px solid var(--color-border)' }}
    >
      {/* Logo */}
      <div className="mt-5 mb-8 w-10 h-10 rounded-xl flex items-center justify-center animate-ai-pulse cursor-pointer"
        style={{ background: 'var(--color-ai-dim)', border: '1px solid rgba(139, 159, 232, 0.25)' }}
        onClick={() => router.push('/dashboard')}
      >
        <Heart className="h-5 w-5" style={{ color: 'var(--color-ai)' }} />
      </div>

      {/* Nav items */}
      <nav className="flex flex-col items-center gap-1.5 flex-1">
        {navItems.map((item, idx) => {
          const isActive = item.href === '/dashboard'
            ? pathname === '/dashboard'
            : pathname.startsWith(item.href);
          const Icon = item.icon;

          return (
            <div key={item.href} className="relative" onMouseEnter={() => setHoveredIdx(idx)} onMouseLeave={() => setHoveredIdx(null)}>
              <Link
                href={item.href}
                className={cn(
                  'w-10 h-10 rounded-xl flex items-center justify-center transition-all duration-200',
                  isActive
                    ? 'text-text-primary'
                    : 'text-text-tertiary hover:text-text-secondary'
                )}
                style={isActive ? {
                  background: `color-mix(in srgb, ${item.color} 15%, transparent)`,
                  border: `1px solid color-mix(in srgb, ${item.color} 40%, transparent)`,
                } : undefined}
              >
                <Icon className="h-5 w-5" strokeWidth={isActive ? 2 : 1.5} />
              </Link>

              {/* Tooltip */}
              <div
                className={cn(
                  'absolute left-[56px] top-1/2 -translate-y-1/2 px-3 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap transition-all duration-150 pointer-events-none z-50',
                  hoveredIdx === idx ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-2'
                )}
                style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)', border: '1px solid var(--color-border)' }}
              >
                {item.label}
              </div>
            </div>
          );
        })}
      </nav>
    </aside>
  );
}
