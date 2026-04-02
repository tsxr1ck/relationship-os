/* eslint-disable no-restricted-globals */

const CACHE_NAME = 'sintonia-push-v1';

self.addEventListener('install', (event) => {
  console.log('[SW] Service Worker installed');
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('[SW] Service Worker activated');
  event.waitUntil(
    caches.keys().then((cacheNames) =>
      Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      )
    )
  );
  return self.clients.claim();
});

self.addEventListener('push', (event) => {
  console.log('[SW] Push received');

  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (e) {
    console.error('[SW] Failed to parse push data:', e);
  }

  const title = data.title || 'Sintonía';
  const body = data.body || 'Tienes una nueva notificación';
  const icon = data.icon || '/icon-192.png';
  const badge = data.badge || '/icon-96.png';
  const actionUrl = data.actionUrl || '/dashboard/notificaciones';

  const options = {
    body,
    icon,
    badge,
    data: { url: actionUrl },
    tag: data.tag || 'default',
    renotify: true,
    actions: data.actions || [
      { action: 'view', title: 'Ver', icon: '/icon-96.png' },
      { action: 'dismiss', title: 'Cerrar' }
    ],
  };

  event.waitUntil(
    self.registration.showNotification(title, options)
  );
});

self.addEventListener('notificationclick', (event) => {
  console.log('[SW] Notification clicked:', event.action);

  event.notification.close();

  if (event.action === 'dismiss') {
    return;
  }

  const urlToOpen = event.notification.data?.url || '/dashboard/notificaciones';

  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url.includes(urlToOpen) && 'focus' in client) {
          return client.focus();
        }
      }
      return self.clients.openWindow(urlToOpen);
    })
  );
});

self.addEventListener('pushsubscriptionchange', (event) => {
  console.log('[SW] Push subscription changed, re-subscribing...');
  event.waitUntil(
    self.registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(
        self.VAPID_PUBLIC_KEY || ''
      )
    }).then((subscription) => {
      return fetch('/api/push/subscribe', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ subscription })
      });
    })
  );
});

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}
