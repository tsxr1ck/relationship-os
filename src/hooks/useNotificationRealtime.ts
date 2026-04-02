'use client';

import { useEffect, useState, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { getUnreadCount } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

export function useNotificationRealtime() {
  const [unreadCount, setUnreadCount] = useState(0);
  const [lastNotification, setLastNotification] = useState<{ title: string; body: string; createdAt: string } | null>(null);

  const fetchInitialCount = useCallback(async () => {
    const result = await getUnreadCount();
    setUnreadCount(result.count);
  }, []);

  useEffect(() => {
    fetchInitialCount();

    const supabase = createClient();
    const channel = supabase
      .channel('notifications-realtime')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
        },
        (payload: { new: Record<string, unknown> }) => {
          const newNotif = payload.new as Record<string, unknown>;
          setUnreadCount(prev => prev + 1);
          setLastNotification({
            title: (newNotif.title as string) || '',
            body: (newNotif.body as string) || '',
            createdAt: (newNotif.created_at as string) || '',
          });
          
          // Fire native Desktop/Mobile Push if backgrounded & permissions granted
          if (
            typeof Notification !== 'undefined' &&
            Notification.permission === 'granted'
          ) {
            new Notification((newNotif.title as string) || 'Relatinship OS', {
              body: (newNotif.body as string) || '',
            });
          }

          window.dispatchEvent(new StorageEvent('storage', { key: 'notification-update' }));
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'notifications',
          filter: 'is_read=eq.true',
        },
        () => {
          setUnreadCount(prev => Math.max(0, prev - 1));
          window.dispatchEvent(new StorageEvent('storage', { key: 'notification-update' }));
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [fetchInitialCount]);

  return { unreadCount, lastNotification };
}
