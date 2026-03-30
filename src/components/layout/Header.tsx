'use client';

import { useState, useEffect, useRef } from 'react';
import { Bell, Heart, User, LogOut } from 'lucide-react';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/supabase/hooks';
import { getProfile, type ProfileData } from '@/app/(dashboard)/dashboard/(protected)/profile/actions';

export function Header() {
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

  const initial = (profile?.fullName || 'U').charAt(0).toUpperCase();

  return (
    <header className="fixed top-0 left-0 w-full lg:w-[calc(100%-18rem)] lg:left-72 h-16 lg:h-20 flex justify-between items-center px-5 lg:px-8 z-50 bg-white/90 backdrop-blur-xl border-b border-outline_variant/20 lg:border-none lg:shadow-sm">
      <div className="flex items-center gap-4">
        {/* Mobile: App Name or Logo. Desktop: empty for now */}
        <span className="lg:hidden font-bold text-primary tracking-tight text-lg">Relationship OS</span>
      </div>

      <div className="flex items-center gap-4 lg:gap-6 relative" ref={dropdownRef}>
        <button className="hidden lg:flex text-on_surface_variant hover:bg-surface_container_low p-2 rounded-full transition-colors">
          <Bell className="h-5 w-5" />
        </button>
        <button className="hidden lg:flex text-on_surface_variant hover:bg-surface_container_low p-2 rounded-full transition-colors">
          <Heart className="h-5 w-5" />
        </button>
        
        <button 
          onClick={() => setDropdownOpen(!dropdownOpen)}
          className="h-9 w-9 lg:h-10 lg:w-10 text-sm rounded-full overflow-hidden border-2 border-primary_container outline-none transition-transform hover:scale-105 active:scale-95 shrink-0"
        >
          {profile?.avatarUrl ? (
             <div className="relative w-full h-full">
               <Image src={profile.avatarUrl} alt="Avatar" fill className="object-cover" />
             </div>
          ) : (
            <div className="w-full h-full flex items-center justify-center font-semibold bg-linear-to-br from-primary to-primary_container text-white">
              {initial}
            </div>
          )}
        </button>

        {/* Dropdown Menu */}
        {dropdownOpen && (
          <div className="absolute top-12 lg:top-14 right-0 w-48 bg-white rounded-xl shadow-lg border border-outline_variant/20 py-1 flex flex-col z-50 animate-in fade-in slide-in-from-top-2">
            <div className="px-4 py-3 border-b border-outline_variant/20 mb-1">
              <p className="text-sm font-semibold truncate text-on_surface">{profile?.fullName || 'Usuario'}</p>
            </div>
            
            <Link 
              href="/dashboard/profile"
              onClick={() => setDropdownOpen(false)}
              className="px-4 py-2.5 text-sm text-on_surface hover:bg-surface_container_lowest hover:text-primary flex items-center gap-3 transition-colors"
            >
              <User className="h-4 w-4 text-on_surface_variant" /> Perfil
            </Link>
            
            <button 
              onClick={() => {
                 setDropdownOpen(false);
                 handleSignOut();
              }}
              className="px-4 py-2.5 text-sm text-red-600 hover:bg-red-50 flex items-center gap-3 text-left w-full transition-colors"
            >
              <LogOut className="h-4 w-4" /> Cerrar sesión
            </button>
          </div>
        )}
      </div>
    </header>
  );
}
