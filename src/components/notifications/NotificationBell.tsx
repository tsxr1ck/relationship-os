'use client';

import { useAuth } from '@/lib/supabase/hooks';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getUnreadCount } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';
import { useNotificationRealtime } from '@/hooks/useNotificationRealtime';
import { Bell } from 'lucide-react';
import { NotificationDropdown } from './NotificationDropdown';
import { toast } from 'sonner';

function urlBase64ToUint8Array(base64String: string) {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

async function registerServiceWorker() {
  if (!('serviceWorker' in navigator)) {
    console.error('[Push] Service Worker not supported');
    return null;
  }

  const registration = await navigator.serviceWorker.register('/sw.js');
  console.log('[Push] Service Worker registered');
  return registration;
}

async function subscribeToPush(registration: ServiceWorkerRegistration) {
  const vapidPublicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;

  if (!vapidPublicKey) {
    console.error('[Push] VAPID public key not configured');
    return null;
  }

  const existingSubscription = await registration.pushManager.getSubscription();
  if (existingSubscription) {
    console.log('[Push] Already subscribed');
    return existingSubscription;
  }

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: urlBase64ToUint8Array(vapidPublicKey),
  });

  console.log('[Push] Subscribed to push');
  return subscription;
}

async function sendSubscriptionToServer(subscription: PushSubscription) {
  const response = await fetch('/api/push/subscribe', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ subscription }),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.error || 'Failed to save subscription');
  }

  return response.json();
}

export async function enablePushNotifications() {
  try {
    const permission = await Notification.requestPermission();
    if (permission !== 'granted') {
      toast.error('Notification permission denied');
      return false;
    }

    const registration = await registerServiceWorker();
    if (!registration) {
      toast.error('Service Worker not supported');
      return false;
    }

    const subscription = await subscribeToPush(registration);
    if (!subscription) {
      toast.error('Failed to subscribe to push');
      return false;
    }

    await sendSubscriptionToServer(subscription);
    toast.success('Push notifications enabled');
    return true;
  } catch (error) {
    console.error('[Push] Error enabling push:', error);
    toast.error('Failed to enable push notifications');
    return false;
  }
}

export async function testPushNotification() {
  try {
    const response = await fetch('/api/push/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Sintonía',
        body: 'Esta es una notificación de prueba. ¡Funciona!',
        icon: '/icon-192.png',
        actionUrl: '/dashboard/notificaciones',
        tag: 'test',
      }),
    });

    const result = await response.json();

    if (!response.ok) {
      toast.error(result.error || 'Failed to send test notification');
      return false;
    }

    toast.success(`Test notification sent (${result.sent} device(s))`);
    return true;
  } catch (error) {
    console.error('[Push] Error sending test:', error);
    toast.error('Failed to send test notification');
    return false;
  }
}

export function NotificationBell() {
  const { user } = useAuth();
  const router = useRouter();
  const [isOpen, setIsOpen] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  
  const { unreadCount } = useNotificationRealtime();

  useEffect(() => {
    const checkMobile = () => setIsMobile(window.innerWidth < 768);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  const handleClick = async () => {
    if (typeof Notification !== 'undefined' && Notification.permission === 'default') {
      await enablePushNotifications();
    }

    if (isMobile) {
      router.push('/dashboard/notificaciones');
    } else {
      setIsOpen(!isOpen);
    }
  };

  const handleTestPush = async (e: React.MouseEvent) => {
    e.stopPropagation();
    await testPushNotification();
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
            <div className="flex items-center justify-between px-3 py-2 border-b dark:border-gray-700">
              <span className="text-sm font-medium dark:text-gray-200">Notificaciones</span>
              <button
                onClick={handleTestPush}
                className="text-xs px-2 py-1 rounded bg-blue-500 text-white hover:bg-blue-600 transition-colors"
                aria-label="Test push notification"
              >
                Test Push
              </button>
            </div>
            <NotificationDropdown
              onClose={() => setIsOpen(false)}
              onNotificationAction={() => {
                setIsOpen(false);
              }}
            />
          </div>
        </>
      )}
    </div>
  );
}
