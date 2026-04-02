'use client';

import { useEffect, useRef, useCallback } from 'react';
import { useAuth } from '@/lib/supabase/hooks';
import { logAppOpened } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

const HEARTBEAT_INTERVAL = 60 * 1000;
const NOTIFICATION_COOLDOWN = 30 * 60 * 1000;

export function AppPresenceTracker() {
  const { user } = useAuth();
  const lastNotifiedRef = useRef<number>(0);
  const activeRef = useRef(false);

  const firePresence = useCallback((notify: boolean) => {
    if (!user) return;
    logAppOpened(notify);
    if (notify) {
      lastNotifiedRef.current = Date.now();
    }
  }, [user]);

  useEffect(() => {
    if (!user) return;

    activeRef.current = true;
    const now = Date.now();
    const timeSinceLastNotify = now - lastNotifiedRef.current;

    if (timeSinceLastNotify > NOTIFICATION_COOLDOWN) {
      firePresence(true);
    } else {
      firePresence(false);
    }

    const heartbeat = setInterval(() => {
      if (!activeRef.current) return;

      const elapsed = Date.now() - lastNotifiedRef.current;
      if (elapsed > NOTIFICATION_COOLDOWN) {
        firePresence(true);
      } else {
        firePresence(false);
      }
    }, HEARTBEAT_INTERVAL);

    const handleVisibility = () => {
      if (document.visibilityState === 'visible') {
        activeRef.current = true;
        const elapsed = Date.now() - lastNotifiedRef.current;
        if (elapsed > NOTIFICATION_COOLDOWN) {
          firePresence(true);
        } else {
          firePresence(false);
        }
      } else {
        activeRef.current = false;
      }
    };

    document.addEventListener('visibilitychange', handleVisibility);

    return () => {
      activeRef.current = false;
      clearInterval(heartbeat);
      document.removeEventListener('visibilitychange', handleVisibility);
    };
  }, [user, firePresence]);

  return null;
}
