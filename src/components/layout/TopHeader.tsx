'use client';

import { useState, useEffect, useRef } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { User, LogOut, ChevronDown } from 'lucide-react';
import { useAuth } from '@/lib/supabase/hooks';
import { getProfile, type ProfileData } from '@/app/(dashboard)/dashboard/(protected)/profile/actions';
import { cn } from '@/lib/utils';
import { motion, AnimatePresence } from 'framer-motion';
import { NotificationBell } from '@/components/notifications/NotificationBell';

export function TopHeader() {
  const [profile, setProfile] = useState<ProfileData | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const { signOut } = useAuth();
  const router = useRouter();

  useEffect(() => {
    getProfile().then(data => {
      if (data) setProfile(data);
    });
  }, []);

  // click outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setDropdownOpen(false);
      }
    };
    if (dropdownOpen) document.addEventListener('mousedown', handleClickOutside);
    else document.removeEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [dropdownOpen]);

  const handleSignOut = async () => {
    await signOut();
    router.push('/login');
  };

  const nameParts = (profile?.fullName || 'Usuario').split(' ');
  const firstName = nameParts[0];
  const initial = firstName.charAt(0).toUpperCase();

  return (
    <header className="fixed top-4 right-4 md:top-6 md:right-8 z-50">
      <div className="relative flex items-center gap-2 pl-4 pr-1.5 py-1.5 rounded-full transition-all duration-200 outline-none active:scale-95" ref={dropdownRef}
        style={{
          background: 'rgba(21, 19, 17, 0.88)',
          backdropFilter: 'blur(20px)',
          WebkitBackdropFilter: 'blur(20px)',
          border: dropdownOpen ? '1px solid var(--color-ai)' : '1px solid var(--color-border)',
          boxShadow: dropdownOpen ? '0 0 15px var(--color-ai-glow)' : '0 4px 20px rgba(0,0,0,0.3)'
        }}>

        <NotificationBell />

        {/* The Pill Box Header — warm tone */}
        <button
          onClick={() => setDropdownOpen(!dropdownOpen)}
          className="flex items-center gap-2 pl-4 pr-1.5 py-1.5 rounded-full transition-all duration-200 outline-none active:scale-95"

        >
          {/* User Name & Caret */}
          <div className="flex items-center gap-1.5">
            <span className="text-sm font-medium tracking-wide" style={{ color: 'var(--color-text-primary)' }}>
              {firstName}
            </span>
            <ChevronDown
              className={cn("h-4 w-4 transition-transform duration-200", dropdownOpen && "rotate-180")}
              style={{ color: 'var(--color-text-tertiary)' }}
            />
          </div>

          {/* Avatar */}
          <div className="h-8 w-8 md:h-9 md:w-9 rounded-full overflow-hidden shrink-0 relative flex items-center justify-center ml-1" style={{ border: '2px solid var(--color-surface-3)', background: 'var(--color-surface-2)' }}>
            {profile?.avatarUrl ? (
              <Image src={profile.avatarUrl} alt="Avatar" fill className="object-cover" />
            ) : (
              <span className="font-semibold text-sm" style={{ color: 'var(--color-text-primary)' }}>
                {initial}
              </span>
            )}
          </div>
        </button>

        {/* Dropdown Menu */}
        <AnimatePresence>
          {dropdownOpen && (
            <motion.div
              initial={{ opacity: 0, y: -10, scale: 0.95 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: -10, scale: 0.95 }}
              transition={{ duration: 0.2 }}
              className="absolute top-14 md:top-16 right-0 w-56 rounded-xl shadow-xl py-1 flex flex-col z-50 overflow-hidden transform origin-top-right"
              style={{
                background: 'rgba(29, 26, 24, 0.95)',
                border: '1px solid var(--color-border)',
                backdropFilter: 'blur(20px)',
                WebkitBackdropFilter: 'blur(20px)',
              }}
            >
              <div className="px-4 py-3 mb-1" style={{ borderBottom: '1px solid var(--color-border)' }}>
                <p className="text-sm font-semibold truncate" style={{ color: 'var(--color-text-primary)' }}>{profile?.fullName || 'Usuario'}</p>
                <p className="text-xs truncate mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>Cuenta activa</p>
              </div>

              <Link
                href="/dashboard/profile"
                onClick={() => setDropdownOpen(false)}
                className="px-4 py-3 text-sm flex items-center gap-3 transition-colors"
                style={{ color: 'var(--color-text-secondary)' }}
                onMouseEnter={(e) => e.currentTarget.style.background = 'var(--color-surface-3)'}
                onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
              >
                <User className="h-4 w-4" style={{ color: 'var(--color-text-tertiary)' }} /> Perfil
              </Link>

              <button
                onClick={() => {
                  setDropdownOpen(false);
                  handleSignOut();
                }}
                className="px-4 py-3 text-sm flex items-center gap-3 text-left w-full transition-colors"
                style={{ color: 'var(--color-danger)' }}
                onMouseEnter={(e) => e.currentTarget.style.background = 'var(--color-surface-3)'}
                onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
              >
                <LogOut className="h-4 w-4" /> Cerrar sesión
              </button>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </header>
  );
}
