'use client';

import { useAuth } from '@/lib/supabase/hooks';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getUnreadCount } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';
import { Bell } from 'lucide-react';
import { NotificationDropdown } from './NotificationDropdown';

export function NotificationBell() {
  const { user } = useAuth();
  const router = useRouter();
  const [unreadCount, setUnreadCount] = useState(0);
  const [isOpen, setIsOpen] = useState(false);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    if (!user) return;
    const fetchCount = async () => {
      const result = await getUnreadCount();
      setUnreadCount(result.count);
    };
    fetchCount();
  }, [user]);

  useEffect(() => {
    const handleStorage = (e: StorageEvent) => {
      if (e.key === 'notification-update') {
        getUnreadCount().then(r => setUnreadCount(r.count));
      }
    };
    window.addEventListener('storage', handleStorage);
    return () => window.removeEventListener('storage', handleStorage);
  }, []);

  useEffect(() => {
    const checkMobile = () => setIsMobile(window.innerWidth < 768);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  const handleClick = () => {
    if (isMobile) {
      router.push('/dashboard/notificaciones');
    } else {
      setIsOpen(!isOpen);
    }
  };

  return (
    <div className="relative">
      <button
        onClick={handleClick}
        className="relative p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        aria-label="Notificaciones"
      >
        <Bell className="w-5 h-5" />
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 min-w-[18px] h-[18px] flex items-center justify-center bg-red-500 text-white text-xs font-bold rounded-full px-1">
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </button>

      {!isMobile && isOpen && (
        <>
          <div
            className="fixed inset-0 z-40"
            onClick={() => setIsOpen(false)}
          />
          <div className="absolute right-0 top-full mt-2 z-50 w-[380px]">
            <NotificationDropdown
              onClose={() => setIsOpen(false)}
              onNotificationAction={() => {
                setIsOpen(false);
                getUnreadCount().then(r => setUnreadCount(r.count));
              }}
            />
          </div>
        </>
      )}
    </div>
  );
}
