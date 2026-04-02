'use client';

import { motion } from 'framer-motion';

interface EmotionalHeaderProps {
  userName: string;
  partnerName: string | null;
  avatarUrl: string | null;
  partnerAvatarUrl: string | null;
  daysActive: number;
  durationText: string | null;
  hasCouple: boolean;
  onAvatarClick?: () => void;
  onPartnerAction?: () => void;
}

function getGreeting(): { greeting: string; emoji: string } {
  const hour = new Date().getHours();
  if (hour < 6) return { greeting: 'Buenas noches', emoji: '🌙' };
  if (hour < 12) return { greeting: 'Buenos días', emoji: '☀️' };
  if (hour < 18) return { greeting: 'Buenas tardes', emoji: '🌤️' };
  if (hour < 21) return { greeting: 'Buena noche', emoji: '🌅' };
  return { greeting: 'Buenas noches', emoji: '🌙' };
}

function getEmotionalContext(daysActive: number, hasPartner: boolean): string {
  if (!hasPartner) return 'Un espacio para crecer juntos te espera.';
  if (daysActive <= 3) return 'Están empezando algo bonito.';
  if (daysActive <= 14) return 'Cada día juntos cuenta.';
  if (daysActive <= 30) return 'Hoy es un buen día para reconectar.';
  if (daysActive <= 90) return 'Su historia sigue creciendo.';
  if (daysActive <= 365) return 'Cuánto han construido juntos.';
  return 'Un vínculo que se profundiza con el tiempo.';
}

export function EmotionalHeader({
  userName,
  partnerName,
  avatarUrl,
  partnerAvatarUrl,
  daysActive,
  durationText,
  hasCouple,
  onAvatarClick,
  onPartnerAction,
}: EmotionalHeaderProps) {
  const { greeting } = getGreeting();
  const firstName = userName.split(' ')[0];
  const contextLine = getEmotionalContext(daysActive, !!partnerName);

  return (
    <motion.section
      className="pt-2 pb-4"
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: 'easeOut' }}
    >
      {/* Avatar pair + greeting */}
      <div className="flex items-start gap-5">
        {/* Organic avatar cluster */}
        <div className="flex items-center shrink-0">
          <div
            className="w-14 h-14 rounded-full flex items-center justify-center text-lg font-semibold overflow-hidden cursor-pointer animate-glow-ring relative"
            style={{
              background: 'var(--color-surface-2)',
              color: 'var(--color-text-primary)',
              border: '2px solid var(--color-conexion)',
            }}
            onClick={onAvatarClick}
          >
            {avatarUrl ? (
              <img src={avatarUrl} alt={firstName} className="w-full h-full object-cover" />
            ) : (
              firstName.charAt(0).toUpperCase()
            )}
          </div>

          {hasCouple && partnerName ? (
            <div
              className="w-14 h-14 rounded-full flex items-center justify-center text-lg font-semibold overflow-hidden -ml-4 relative"
              style={{
                background: 'var(--color-surface-2)',
                color: 'var(--color-text-primary)',
                border: '2px solid var(--color-cuidado)',
                zIndex: 0,
              }}
            >
              {partnerAvatarUrl ? (
                <img src={partnerAvatarUrl} alt={partnerName} className="w-full h-full object-cover" />
              ) : (
                partnerName.charAt(0).toUpperCase()
              )}
            </div>
          ) : (
            <div
              className="w-14 h-14 rounded-full flex items-center justify-center -ml-4 cursor-pointer transition-colors"
              style={{
                background: 'var(--color-surface-3)',
                color: 'var(--color-text-tertiary)',
                border: '2px dashed var(--color-border)',
              }}
              onClick={onPartnerAction}
            >
              <span className="text-xl">+</span>
            </div>
          )}
        </div>

        {/* Text content */}
        <div className="flex-1 pt-1">
          <h1
            className="font-display text-2xl md:text-3xl leading-tight"
            style={{ color: 'var(--color-text-primary)' }}
          >
            {greeting}, {firstName}
          </h1>

          <motion.p
            className="text-sm mt-1.5 leading-relaxed"
            style={{ color: 'var(--color-text-secondary)' }}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.5 }}
          >
            {contextLine}
          </motion.p>

          {durationText && (
            <motion.div
              className="flex items-center gap-2 mt-3"
              initial={{ opacity: 0, x: -8 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.5, duration: 0.4 }}
            >
              <span
                className="px-3 py-1 rounded-full text-[11px] font-medium tracking-wide"
                style={{
                  background: 'var(--color-surface-2)',
                  color: 'var(--color-text-secondary)',
                  border: '1px solid var(--color-border)',
                }}
              >
                {durationText}
              </span>
            </motion.div>
          )}
        </div>
      </div>
    </motion.section>
  );
}
