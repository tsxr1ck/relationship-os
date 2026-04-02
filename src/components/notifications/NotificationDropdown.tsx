'use client';

import { useEffect, useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import {
  getNotifications,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  type NotificationItem,
} from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';
import { formatDistanceToNow } from 'date-fns';
import { es } from 'date-fns/locale';
import { Bell, ExternalLink, Loader2 } from 'lucide-react';
import * as Icons from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface NotificationDropdownProps {
  onClose: () => void;
  onNotificationAction: () => void;
}

export function NotificationDropdown({ onClose, onNotificationAction }: NotificationDropdownProps) {
  const router = useRouter();
  const [notifications, setNotifications] = useState<NotificationItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [processingId, setProcessingId] = useState<string | null>(null);

  const fetchNotifications = useCallback(async () => {
    setLoading(true);
    const data = await getNotifications(15);
    setNotifications(data);
    setLoading(false);
  }, []);

  useEffect(() => {
    fetchNotifications();
  }, [fetchNotifications]);

  const handleNotificationClick = async (notification: NotificationItem) => {
    if (!notification.isRead) {
      setProcessingId(notification.id);
      await markNotificationAsRead(notification.id);
      setProcessingId(null);
      setNotifications(prev =>
        prev.map(n => n.id === notification.id ? { ...n, isRead: true } : n)
      );
    }

    if (notification.actionUrl) {
      onClose();
      onNotificationAction();
      router.push(notification.actionUrl);
    }
  };

  const handleMarkAllRead = async () => {
    await markAllNotificationsAsRead();
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
    onNotificationAction();
  };

  const getIcon = (iconName: string) => {
    const iconMap: Record<string, React.ElementType> = {
      bell: Icons.Bell,
      heart: Icons.Heart,
      eye: Icons.Eye,
      smile: Icons.Smile,
      'check-circle': Icons.CheckCircle,
      calendar: Icons.Calendar,
      trophy: Icons.Trophy,
      zap: Icons.Zap,
      'book-open': Icons.BookOpen,
      sparkles: Icons.Sparkles,
      user: Icons.User,
      'clipboard-check': Icons.ClipboardCheck,
      users: Icons.Users,
      flag: Icons.Flag,
      'message-circle': Icons.MessageCircle,
    };
    const IconComponent = iconMap[iconName] || Icons.Bell;
    return <IconComponent className="w-4 h-4" />;
  };

  const formatTime = (dateString: string) => {
    try {
      return formatDistanceToNow(new Date(dateString), { addSuffix: true, locale: es });
    } catch {
      return '';
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: -10, scale: 0.95 }}
      animate={{ opacity: 1, y: 0, scale: 1 }}
      exit={{ opacity: 0, y: -10, scale: 0.95 }}
      transition={{ duration: 0.2 }}
      className="rounded-2xl shadow-xl overflow-hidden transform origin-top-right"
      style={{
        width: 380,
        background: 'var(--color-surface-1)',
        border: '1px solid var(--color-border)',
      }}
    >
      {/* Header */}
      <div
        className="px-4 py-3 flex items-center justify-between"
        style={{ borderBottom: '1px solid var(--color-border)' }}
      >
        <div className="flex items-center gap-2">
          <Bell className="w-4 h-4" style={{ color: 'var(--color-text-tertiary)' }} />
          <h3 className="font-semibold text-sm" style={{ color: 'var(--color-text-primary)' }}>
            Notificaciones
          </h3>
        </div>
        {notifications.some(n => !n.isRead) && (
          <button
            onClick={handleMarkAllRead}
            className="text-xs font-medium transition-colors"
            style={{ color: 'var(--color-ai)' }}
          >
            Marcar todo como leído
          </button>
        )}
      </div>

      {/* List */}
      <div className="max-h-[400px] overflow-y-auto">
        {loading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="w-5 h-5 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
          </div>
        ) : notifications.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-8 px-4 text-center">
            <Bell className="w-8 h-8 mb-2" style={{ color: 'var(--color-text-tertiary)', opacity: 0.4 }} />
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              No hay notificaciones
            </p>
            <p className="text-xs mt-1" style={{ color: 'var(--color-text-tertiary)' }}>
              Las actividades de tu pareja aparecerán aquí
            </p>
          </div>
        ) : (
          <div style={{ borderColor: 'var(--color-border)' }}>
            <AnimatePresence>
              {notifications.map(notification => (
                <motion.button
                  key={notification.id}
                  initial={{ opacity: 0, x: -8 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: -8 }}
                  transition={{ duration: 0.15 }}
                  onClick={() => handleNotificationClick(notification)}
                  disabled={processingId === notification.id}
                  className="w-full text-left px-4 py-3 transition-colors"
                  style={{
                    background: !notification.isRead
                      ? 'var(--color-ai-dim)'
                      : 'transparent',
                    borderBottom: '1px solid var(--color-border)',
                  }}
                  onMouseEnter={e => {
                    if (!notification.isRead) return;
                    e.currentTarget.style.background = 'var(--color-surface-2)';
                  }}
                  onMouseLeave={e => {
                    if (!notification.isRead) return;
                    e.currentTarget.style.background = 'transparent';
                  }}
                >
                  <div className="flex items-start gap-3">
                    <div
                      className="mt-0.5 p-1.5 rounded-full flex-shrink-0"
                      style={{
                        background: !notification.isRead
                          ? 'var(--color-ai-dim)'
                          : 'var(--color-surface-3)',
                        color: !notification.isRead
                          ? 'var(--color-ai)'
                          : 'var(--color-text-tertiary)',
                      }}
                    >
                      {getIcon(notification.icon)}
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2">
                        <p
                          className={`text-sm ${!notification.isRead ? 'font-semibold' : 'font-medium'}`}
                          style={{
                            color: !notification.isRead
                              ? 'var(--color-text-primary)'
                              : 'var(--color-text-secondary)',
                          }}
                        >
                          {notification.title}
                        </p>
                        {!notification.isRead && (
                          <span
                            className="w-2 h-2 rounded-full flex-shrink-0 mt-1.5"
                            style={{ background: 'var(--color-ai)' }}
                          />
                        )}
                      </div>
                      <p
                        className="text-xs mt-0.5 line-clamp-2"
                        style={{ color: 'var(--color-text-tertiary)' }}
                      >
                        {notification.body}
                      </p>
                      <div className="flex items-center gap-2 mt-1">
                        <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                          {formatTime(notification.createdAt)}
                        </span>
                        {notification.actionUrl && (
                          <ExternalLink className="w-3 h-3" style={{ color: 'var(--color-text-tertiary)' }} />
                        )}
                      </div>
                    </div>
                  </div>
                </motion.button>
              ))}
            </AnimatePresence>
          </div>
        )}
      </div>

      {/* Footer */}
      {notifications.length > 0 && (
        <div
          className="px-4 py-2.5"
          style={{ borderTop: '1px solid var(--color-border)' }}
        >
          <button
            onClick={() => {
              onClose();
              router.push('/dashboard/notificaciones');
            }}
            className="w-full text-center text-sm font-medium py-1 transition-colors rounded-lg"
            style={{ color: 'var(--color-ai)' }}
            onMouseEnter={e => {
              e.currentTarget.style.background = 'var(--color-ai-dim)';
            }}
            onMouseLeave={e => {
              e.currentTarget.style.background = 'transparent';
            }}
          >
            Ver todas las notificaciones
          </button>
        </div>
      )}
    </motion.div>
  );
}
