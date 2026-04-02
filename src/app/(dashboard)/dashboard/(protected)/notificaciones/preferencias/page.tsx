'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import {
  getNotificationPreferences,
  updateNotificationPreference,
  type NotificationPreferenceItem,
} from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';
import { ArrowLeft, Loader2, Check, X } from 'lucide-react';
import { motion } from 'framer-motion';

const containerVariants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.05 } },
};

const itemVariants: { hidden: { opacity: number; y: number }; show: { opacity: number; y: number; transition: { type: 'spring'; stiffness: number; damping: number } } } = {
  hidden: { opacity: 0, y: 12 },
  show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 280, damping: 22 } },
};

const CATEGORY_GROUPS: Record<string, { label: string; description: string; eventTypes: string[] }> = {
  conocernos: {
    label: 'Conocernos',
    description: 'Preguntas diarias y reacciones',
    eventTypes: ['conocernos.answered', 'conocernos.revealed', 'conocernos.reacted'],
  },
  plan: {
    label: 'Plan Semanal',
    description: 'Actividades y planes',
    eventTypes: ['plan.completed', 'plan.created'],
  },
  retos: {
    label: 'Retos',
    description: 'Desafíos de pareja',
    eventTypes: ['challenge.completed', 'challenge.started'],
  },
  historia: {
    label: 'Historia',
    description: 'Recuerdos compartidos',
    eventTypes: ['historia.created', 'historia.revealed'],
  },
  perfil: {
    label: 'Perfil y Pareja',
    description: 'Cambios de perfil y apodos',
    eventTypes: ['profile.updated', 'nickname.requested', 'nickname.accepted'],
  },
  evaluaciones: {
    label: 'Evaluaciones',
    description: 'Cuestionarios completados',
    eventTypes: ['questionnaire.completed'],
  },
  hitos: {
    label: 'Hitos',
    description: 'Fechas importantes',
    eventTypes: ['milestone.created', 'couple.joined'],
  },
};

export default function NotificationPreferencesPage() {
  const router = useRouter();
  const [preferences, setPreferences] = useState<NotificationPreferenceItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState<string | null>(null);

  useEffect(() => {
    const load = async () => {
      const data = await getNotificationPreferences();
      setPreferences(data);
      setLoading(false);
    };
    load();
  }, []);

  const handleToggle = async (eventType: string, currentEnabled: boolean) => {
    setSaving(eventType);
    const success = await updateNotificationPreference(eventType, !currentEnabled);
    if (success) {
      setPreferences(prev =>
        prev.map(p =>
          p.eventType === eventType ? { ...p, enabled: !p.enabled } : p
        )
      );
    }
    setSaving(null);
  };

  const handleEnableAll = async () => {
    for (const pref of preferences) {
      if (!pref.enabled) {
        await updateNotificationPreference(pref.eventType, true);
      }
    }
    setPreferences(prev => prev.map(p => ({ ...p, enabled: true })));
  };

  const handleDisableAll = async () => {
    for (const pref of preferences) {
      if (pref.enabled) {
        await updateNotificationPreference(pref.eventType, false);
      }
    }
    setPreferences(prev => prev.map(p => ({ ...p, enabled: false })));
  };

  const prefMap = new Map(preferences.map(p => [p.eventType, p]));

  return (
    <div className="space-y-6 max-w-2xl mx-auto pb-12">
      {/* Header */}
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
            Preferencias de Notificaciones
          </h1>
          <p className="text-sm mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
            Elige qué actividades de tu pareja quieres ver
          </p>
        </div>
      </div>

      {/* Quick actions */}
      <div className="flex items-center gap-2">
        <button
          onClick={handleEnableAll}
          className="text-xs px-3 py-1.5 rounded-xl font-medium transition-colors"
          style={{
            color: 'var(--color-success)',
            background: 'rgba(127, 163, 106, 0.15)',
          }}
        >
          Activar todas
        </button>
        <button
          onClick={handleDisableAll}
          className="text-xs px-3 py-1.5 rounded-xl font-medium transition-colors"
          style={{
            color: 'var(--color-danger)',
            background: 'rgba(207, 107, 107, 0.15)',
          }}
        >
          Desactivar todas
        </button>
      </div>

      {/* Content */}
      {loading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="w-6 h-6 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
        </div>
      ) : (
        <motion.div
          variants={containerVariants}
          initial="hidden"
          animate="show"
          className="space-y-4"
        >
          {Object.entries(CATEGORY_GROUPS).map(([key, category]) => (
            <motion.div
              key={key}
              variants={itemVariants}
              className="rounded-2xl overflow-hidden"
              style={{
                background: 'var(--color-surface-1)',
                border: '1px solid var(--color-border)',
              }}
            >
              {/* Category header */}
              <div
                className="px-4 py-3 border-b"
                style={{ borderColor: 'var(--color-border)' }}
              >
                <h3 className="font-semibold text-sm" style={{ color: 'var(--color-text-primary)' }}>
                  {category.label}
                </h3>
                <p className="text-xs mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
                  {category.description}
                </p>
              </div>

              {/* Toggle items */}
              <div className="divide-y" style={{ borderColor: 'var(--color-border)' }}>
                {category.eventTypes.map(eventType => {
                  const pref = prefMap.get(eventType);
                  if (!pref) return null;

                  const label = pref.label.split(' - ')[1] || pref.label;

                  return (
                    <div
                      key={eventType}
                      className="flex items-center justify-between px-4 py-3"
                    >
                      <span className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                        {label}
                      </span>
                      <button
                        onClick={() => handleToggle(eventType, pref.enabled)}
                        disabled={saving === eventType}
                        className="relative w-11 h-6 rounded-full transition-colors duration-200"
                        style={{
                          background: pref.enabled
                            ? 'var(--color-ai)'
                            : 'var(--color-surface-3)',
                          opacity: saving === eventType ? 0.5 : 1,
                        }}
                      >
                        <span
                          className="absolute top-0.5 left-0.5 w-5 h-5 rounded-full shadow transition-transform duration-200"
                          style={{
                            background: 'var(--color-base)',
                            transform: pref.enabled ? 'translateX(20px)' : 'translateX(0)',
                          }}
                        />
                      </button>
                    </div>
                  );
                })}
              </div>
            </motion.div>
          ))}
        </motion.div>
      )}
    </div>
  );
}
