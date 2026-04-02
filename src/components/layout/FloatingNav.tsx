'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Sun, Heart, Calendar, User } from 'lucide-react';
import { cn } from '@/lib/utils';
import { motion } from 'framer-motion';

const navItems = [
  { href: '/dashboard', label: 'Hoy', icon: Sun, color: 'var(--color-ai)' },
  { href: '/dashboard/nosotros', label: 'Nosotros', icon: Heart, color: 'var(--color-conexion)' },
  { href: '/dashboard/plan', label: 'Plan', icon: Calendar, color: 'var(--color-cuidado)' },
  { href: '/dashboard/profile', label: 'Perfil', icon: User, color: 'var(--color-text-secondary)' },
];

export function FloatingNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-4 left-1/2 -translate-x-1/2 z-50 lg:hidden" style={{ width: 'calc(100% - 32px)', maxWidth: '340px' }}>
      <div
        className="flex items-center justify-around px-4 py-3 rounded-[28px]"
        style={{
          background: 'rgba(21, 20, 17, 0.92)',
          backdropFilter: 'blur(24px)',
          WebkitBackdropFilter: 'blur(24px)',
          boxShadow: '0 8px 32px rgba(0,0,0,0.4), 0 0 0 1px rgba(52, 46, 40, 0.5)',
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
                'relative flex flex-col items-center gap-1.5 rounded-2xl px-4 py-2 transition-all duration-300',
                isActive
                  ? 'text-text-primary'
                  : 'text-text-tertiary'
              )}
            >
              <div className="relative">
                <Icon
                  className="h-[22px] w-[22px] transition-all duration-300"
                  strokeWidth={isActive ? 2 : 1.5}
                  style={{ color: isActive ? item.color : undefined }}
                />
              </div>
              <span
                className="text-[10px] font-medium tracking-wide transition-colors duration-300"
                style={{ color: isActive ? 'var(--color-text-primary)' : 'var(--color-text-tertiary)' }}
              >
                {item.label}
              </span>
              {/* Warm active indicator dot */}
              {isActive && (
                <motion.div
                  layoutId="nav-indicator"
                  className="absolute -bottom-0.5 w-1 h-1 rounded-full"
                  style={{ background: item.color }}
                  transition={{ type: 'spring', stiffness: 300, damping: 30 }}
                />
              )}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
