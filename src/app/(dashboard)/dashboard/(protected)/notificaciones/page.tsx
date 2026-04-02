'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  getNotifications,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotification,
  type NotificationItem,
} from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';
import { formatDistanceToNow } from 'date-fns';
import { es } from 'date-fns/locale';
import { Bell, Check, Trash2, ExternalLink, Loader2, ArrowLeft, Settings } from 'lucide-react';
import * as Icons from 'lucide-react';
import { motion } from 'framer-motion';

const containerVariants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.05 } },
};

const itemVariants: { hidden: { opacity: number; y: number }; show: { opacity: number; y: number; transition: { type: 'spring'; stiffness: number; damping: number } } } = {
  hidden: { opacity: 0, y: 12 },
  show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 280, damping: 22 } },
};

export default function NotificationsPage() {
  const router = useRouter();
  const [notifications, setNotifications] = useState<NotificationItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [processingId, setProcessingId] = useState<string | null>(null);

  const fetchNotifications = async () => {
    setLoading(true);
    const data = await getNotifications(50);
    setNotifications(data);
    setLoading(false);
  };

  useEffect(() => {
    fetchNotifications();
    markAllNotificationsAsRead();
  }, []);

  const handleMarkAsRead = async (notificationId: string) => {
    setProcessingId(notificationId);
    await markNotificationAsRead(notificationId);
    setProcessingId(null);
    setNotifications(prev =>
      prev.map(n => n.id === notificationId ? { ...n, isRead: true } : n)
    );
  };

  const handleMarkAllRead = async () => {
    await markAllNotificationsAsRead();
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
  };

  const handleDelete = async (notificationId: string) => {
    setProcessingId(notificationId);
    await deleteNotification(notificationId);
    setProcessingId(null);
    setNotifications(prev => prev.filter(n => n.id !== notificationId));
  };

  const handleNavigate = async (notification: NotificationItem) => {
    if (!notification.isRead) {
      await handleMarkAsRead(notification.id);
    }
    if (notification.actionUrl) {
      router.push(notification.actionUrl);
    }
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
    return <IconComponent className="w-5 h-5" />;
  };

  const formatTime = (dateString: string) => {
    try {
      return formatDistanceToNow(new Date(dateString), { addSuffix: true, locale: es });
    } catch {
      return '';
    }
  };

  const unreadCount = notifications.filter(n => !n.isRead).length;

  return (
    <div className="space-y-6 max-w-2xl mx-auto pb-12 p-5 pt-10">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => router.back()}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="font-display text-2xl md:text-3xl" style={{ color: 'var(--color-text-primary)' }}>
              Notificaciones
            </h1>
            {unreadCount > 0 && (
              <p className="text-sm mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
                {unreadCount} sin leer
              </p>
            )}
          </div>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => router.push('/dashboard/notificaciones/preferencias')}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            title="Preferencias"
            style={{ color: 'var(--color-text-tertiary)' }}
          >
            <Settings className="w-5 h-5" />
          </button>
          {unreadCount > 0 && (
            <button
              onClick={handleMarkAllRead}
              className="flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-xl transition-colors"
              style={{
                color: 'var(--color-ai)',
                background: 'var(--color-ai-dim)',
              }}
            >
              <Check className="w-4 h-4" />
              Marcar todo como leído
            </button>
          )}
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="w-6 h-6 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
        </div>
      ) : notifications.length === 0 ? (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="flex flex-col items-center justify-center py-20 text-center rounded-2xl p-8"
          style={{
            background: 'var(--color-surface-1)',
            border: '1px solid var(--color-border)',
          }}
        >
          <div
            className="w-16 h-16 rounded-full flex items-center justify-center mb-4"
            style={{ background: 'var(--color-surface-3)' }}
          >
            <Bell className="w-8 h-8" style={{ color: 'var(--color-text-tertiary)' }} />
          </div>
          <h3 className="text-lg font-semibold" style={{ color: 'var(--color-text-primary)' }}>
            No hay notificaciones
          </h3>
          <p className="text-sm mt-1 max-w-xs" style={{ color: 'var(--color-text-tertiary)' }}>
            Las actividades de tu pareja en la app aparecerán aquí
          </p>
        </motion.div>
      ) : (
        <motion.div
          variants={containerVariants}
          initial="hidden"
          animate="show"
          className="space-y-2"
        >
          {notifications.map(notification => (
            <motion.div
              key={notification.id}
              variants={itemVariants}
              className="rounded-2xl overflow-hidden transition-all duration-200"
              style={{
                background: 'var(--color-surface-1)',
                border: !notification.isRead
                  ? '1px solid var(--color-ai)'
                  : '1px solid var(--color-border)',
                boxShadow: !notification.isRead
                  ? '0 0 12px var(--color-ai-glow)'
                  : 'none',
              }}
            >
              <div className="p-4">
                <div className="flex items-start gap-3">
                  <div
                    className="mt-0.5 p-2 rounded-full flex-shrink-0"
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
                      <div>
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
                        <p
                          className="text-sm mt-0.5"
                          style={{ color: 'var(--color-text-tertiary)' }}
                        >
                          {notification.body}
                        </p>
                      </div>
                      {!notification.isRead && (
                        <span
                          className="w-2.5 h-2.5 rounded-full flex-shrink-0 mt-1.5"
                          style={{ background: 'var(--color-ai)' }}
                        />
                      )}
                    </div>

                    <div className="flex items-center justify-between mt-3">
                      <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                        {formatTime(notification.createdAt)}
                      </span>

                      <div className="flex items-center gap-1">
                        {notification.actionUrl && (
                          <button
                            onClick={() => handleNavigate(notification)}
                            className="flex items-center gap-1 px-2.5 py-1.5 text-xs font-medium rounded-lg transition-colors"
                            style={{
                              color: 'var(--color-ai)',
                            }}
                          >
                            <ExternalLink className="w-3 h-3" />
                            Ver
                          </button>
                        )}
                        {!notification.isRead && (
                          <button
                            onClick={() => handleMarkAsRead(notification.id)}
                            disabled={processingId === notification.id}
                            className="p-1.5 rounded-lg transition-colors"
                            style={{
                              color: 'var(--color-text-tertiary)',
                            }}
                            onMouseEnter={e => {
                              e.currentTarget.style.color = 'var(--color-success)';
                              e.currentTarget.style.background = 'var(--color-success-warm)';
                            }}
                            onMouseLeave={e => {
                              e.currentTarget.style.color = 'var(--color-text-tertiary)';
                              e.currentTarget.style.background = 'transparent';
                            }}
                            title="Marcar como leído"
                          >
                            <Check className="w-4 h-4" />
                          </button>
                        )}
                        <button
                          onClick={() => handleDelete(notification.id)}
                          disabled={processingId === notification.id}
                          className="p-1.5 rounded-lg transition-colors"
                          style={{
                            color: 'var(--color-text-tertiary)',
                          }}
                          onMouseEnter={e => {
                            e.currentTarget.style.color = 'var(--color-danger)';
                            e.currentTarget.style.background = 'rgba(207, 107, 107, 0.15)';
                          }}
                          onMouseLeave={e => {
                            e.currentTarget.style.color = 'var(--color-text-tertiary)';
                            e.currentTarget.style.background = 'transparent';
                          }}
                          title="Eliminar"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </motion.div>
      )}
    </div>
  );
}
