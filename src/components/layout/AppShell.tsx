'use client';

import { ReactNode } from 'react';
import { FloatingNav } from './FloatingNav';
import { IconRail } from './IconRail';
import { TopHeader } from './TopHeader';

interface AppShellProps {
  children: ReactNode;
  showNav?: boolean;
}

export function AppShell({ children, showNav = true }: AppShellProps) {
  if (!showNav) {
    return (
      <div className="min-h-screen" style={{ background: 'var(--color-base)' }}>
        <main className="mx-auto w-full py-8 md:py-12">
          {children}
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen" style={{ background: 'var(--color-base)' }}>
      <TopHeader />
      <IconRail />
      <main className="pb-24 lg:pb-0 lg:ml-16 mx-auto max-w-md lg:max-w-7xl px-4 md:px-6 lg:px-12 pt-8 lg:pt-12">
        {children}
      </main>
      <FloatingNav />
    </div>
  );
}
