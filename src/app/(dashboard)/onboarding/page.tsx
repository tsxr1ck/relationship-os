'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { OnboardingQuestion } from '@/components/questionnaire/OnboardingQuestion';
import {
  Heart, Users, ArrowRight, Sparkles, Loader2, Clock, User,
  Check, ChevronLeft, ChevronRight, Brain, Copy, CheckCircle2
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

import { getCoupleStatus, getQuestionnaireStatus } from '@/app/(dashboard)/dashboard/questionnaire/actions';
import { getProfile, updateProfile } from '@/app/(dashboard)/dashboard/(protected)/profile/actions';
import { createCouple, joinCouple } from '@/app/actions';
import {
  getOnboardingStatus,
  startOnboardingSession,
  saveOnboardingAnswer,
  completeOnboarding,
} from './actions';
import { ONBOARDING_ITEMS, ONBOARDING_DIMENSIONS } from '@/data/onboarding-data';

type Step =
  | 'loading'
  | 'profile'
  | 'welcome'
  | 'personal_assessment'
  | 'profile_ready'
  | 'couple'
  | 'couple_create'
  | 'couple_join'
  | 'couple_done'
  | 'questionnaire';

export default function OnboardingPage() {
  const router = useRouter();
  const [step, setStep] = useState<Step>('loading');
  const [loading, setLoading] = useState(false);
  const [fullName, setFullName] = useState('');
  const [nameError, setNameError] = useState('');
  const [existingName, setExistingName] = useState('');

  // Personal assessment state
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [profileVectors, setProfileVectors] = useState<any[]>([]);

  // Couple state (inline)
  const [inviteCode, setInviteCode] = useState('');
  const [joinCode, setJoinCode] = useState('');
  const [coupleError, setCoupleError] = useState('');
  const [copied, setCopied] = useState(false);
  const [partnerName, setPartnerName] = useState<string | null>(null);

  const currentItem = ONBOARDING_ITEMS[currentQuestionIndex];
  const totalItems = ONBOARDING_ITEMS.length;
  const progress = totalItems > 0 ? ((currentQuestionIndex + 1) / totalItems) * 100 : 0;

  // ─── Check user state on mount ────────────────────────────
  useEffect(() => {
    async function checkState() {
      try {
        const [coupleStatus, questionnaireStatus, profile, onboardingStatus] = await Promise.all([
          getCoupleStatus(),
          getQuestionnaireStatus(),
          getProfile(),
          getOnboardingStatus(),
        ]);

        if (profile) {
          setExistingName(profile.fullName || '');
          setFullName(profile.fullName || '');
        }

        // Fully linked couple → dashboard (assessment is now voluntary/asynchronous)
        if (
          coupleStatus.hasCouple &&
          coupleStatus.memberCount! >= 2
        ) {
          router.replace('/dashboard');
          return;
        }

        // No name → collect name first
        if (!profile?.fullName) {
          setStep('profile');
          return;
        }

        // Onboarding not done → check status
        if (onboardingStatus.status === 'not_started') {
          setStep('welcome');
          return;
        }

        if (onboardingStatus.status === 'in_progress') {
          const result = await startOnboardingSession();
          setSessionId(result.session.id);
          setAnswers(result.answers);
          const lastIndex = result.session.current_question_index || 0;
          setCurrentQuestionIndex(lastIndex);
          setStep('personal_assessment');
          return;
        }

        // Onboarding complete → check couple status
        if (onboardingStatus.status === 'completed') {
          setProfileVectors(onboardingStatus.profileVectors);

          if (!coupleStatus.hasCouple) {
            setStep('couple');
            return;
          }

          // Has couple but partner not joined yet
          if (coupleStatus.hasCouple && coupleStatus.memberCount === 1) {
            // Show the invite code
            if (coupleStatus.couple?.invite_code) {
              setInviteCode(coupleStatus.couple.invite_code);
            }
            setStep('couple_create');
            return;
          }


        }

        setStep('welcome');
      } catch (err) {
        console.error('Error checking state:', err);
        setStep('profile');
      }
    }
    checkState();
  }, [router]);

  // ─── Handlers ─────────────────────────────────────────────

  const handleSaveProfile = async () => {
    const trimmed = fullName.trim();
    if (!trimmed || trimmed.length < 2) {
      setNameError('Ingresa tu nombre (mínimo 2 caracteres)');
      return;
    }
    setNameError('');
    setLoading(true);
    try {
      await updateProfile({ fullName: trimmed });
      setExistingName(trimmed);
      setStep('welcome');
    } catch (err: any) {
      setNameError(err.message || 'Error al guardar el perfil');
    } finally {
      setLoading(false);
    }
  };

  const handleStartAssessment = async () => {
    setLoading(true);
    try {
      const result = await startOnboardingSession();
      setSessionId(result.session.id);
      setAnswers(result.answers);
      if (result.session.current_question_index > 0) {
        setCurrentQuestionIndex(result.session.current_question_index);
      }
      setStep('personal_assessment');
    } catch (err) {
      console.error('Error starting assessment:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleAnswer = useCallback((value: any) => {
    if (currentItem) {
      setAnswers((prev) => ({
        ...prev,
        [currentItem.id]: value,
      }));
    }
  }, [currentItem]);

  const handleNext = async () => {
    if (!sessionId || !currentItem) return;
    setSaving(true);

    try {
      const isLast = currentQuestionIndex >= totalItems - 1;
      const nextIndex = isLast ? currentQuestionIndex : currentQuestionIndex + 1;
      const nextProgress = isLast ? 100 : Math.round(((nextIndex + 1) / totalItems) * 100);

      await saveOnboardingAnswer(
        sessionId,
        currentItem.id,
        answers[currentItem.id],
        nextIndex,
        nextProgress
      );

      if (isLast) {
        const result = await completeOnboarding(sessionId, answers);
        setProfileVectors(result.vectors);
        setStep('profile_ready');
      } else {
        setCurrentQuestionIndex(nextIndex);
      }
    } catch (err) {
      console.error('Error saving answer:', err);
    } finally {
      setSaving(false);
    }
  };

  const handleBack = () => {
    if (currentQuestionIndex > 0) {
      setCurrentQuestionIndex((prev) => prev - 1);
    }
  };

  // ─── Inline Couple Handlers ───────────────────────────────

  const handleCreateCouple = async () => {
    setLoading(true);
    setCoupleError('');
    try {
      const result = await createCouple();
      setInviteCode(result.inviteCode);
      setStep('couple_create');
    } catch (err: any) {
      setCoupleError(err.message || 'Error al crear la pareja');
    } finally {
      setLoading(false);
    }
  };

  const handleJoinCouple = async () => {
    const code = joinCode.trim();
    if (!code || code.length < 4) {
      setCoupleError('Ingresa un código válido');
      return;
    }
    setLoading(true);
    setCoupleError('');
    try {
      await joinCouple(code);
      setStep('couple_done');
    } catch (err: any) {
      setCoupleError(err.message || 'Código inválido');
    } finally {
      setLoading(false);
    }
  };

  const handleCopyCode = async () => {
    try {
      await navigator.clipboard.writeText(inviteCode);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      // Fallback
      const textArea = document.createElement('textarea');
      textArea.value = inviteCode;
      document.body.appendChild(textArea);
      textArea.select();
      document.execCommand('copy');
      document.body.removeChild(textArea);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const canProceed = currentItem && answers[currentItem.id] !== undefined;

  // ─── Loading ──────────────────────────────────────────────

  if (step === 'loading') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <div className="text-center">
            <Loader2 className="h-12 w-12 text-primary mx-auto mb-4 animate-spin" />
            <p className="text-on_surface_variant">Cargando tu estado...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  // ─── Profile Name Collection ──────────────────────────────

  if (step === 'profile') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md w-full"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="text-center mb-10">
              <div className="w-20 h-20 rounded-full bg-linear-to-br from-primary to-primary_container mx-auto mb-6 flex items-center justify-center shadow-lg">
                <User className="h-10 w-10 text-white" />
              </div>
              <h1 className="text-3xl font-bold text-on_surface mb-3">
                ¿Cómo te llamas?
              </h1>
              <p className="text-on_surface_variant text-lg">
                Tu nombre será visible para tu pareja dentro de la app.
              </p>
            </div>

            <div className="space-y-6">
              <Input
                id="fullName"
                label="Tu nombre completo"
                placeholder="Ej. María García"
                value={fullName}
                onChange={(e) => {
                  setFullName(e.target.value);
                  if (nameError) setNameError('');
                }}
                onKeyDown={(e) => e.key === 'Enter' && handleSaveProfile()}
                autoFocus
              />

              <Button
                size="lg"
                className="w-full"
                onClick={handleSaveProfile}
                loading={loading}
                disabled={!fullName.trim()}
              >
                Continuar
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
            </div>

            <p className="text-center text-xs text-on_surface_variant mt-8">
              🔒 Tu nombre solo es visible para tu pareja y dentro de tu perfil.
            </p>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Welcome — Explain the New Flow ───────────────────────

  if (step === 'welcome') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md text-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="mb-8">
              <div className="w-24 h-24 rounded-full bg-linear-to-br from-primary to-primary_container mx-auto mb-6 flex items-center justify-center shadow-lg">
                <Heart className="h-12 w-12 text-white" />
              </div>
              <h1 className="text-3xl font-bold text-on_surface mb-2">
                ¡Hola, {existingName || fullName}!
              </h1>
              <p className="text-on_surface_variant text-lg leading-relaxed">
                Vamos a conocerte mejor para personalizar tu experiencia.
              </p>
            </div>

            <div className="bg-surface_container_low rounded-2xl p-5 mb-8 text-left space-y-4">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-xl bg-conexion/20 flex items-center justify-center shrink-0 mt-0.5">
                  <Brain className="h-5 w-5 text-conexion" />
                </div>
                <div>
                  <span className="text-sm font-semibold text-on_surface block">15 preguntas rápidas sobre ti</span>
                  <span className="text-xs text-on_surface_variant">~3 minutos · Tu perfil personal</span>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-xl bg-cuidado/20 flex items-center justify-center shrink-0 mt-0.5">
                  <Users className="h-5 w-5 text-cuidado" />
                </div>
                <div>
                  <span className="text-sm font-semibold text-on_surface block">Conecta con tu pareja</span>
                  <span className="text-xs text-on_surface_variant">Invita o únete con un código</span>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-xl bg-camino/20 flex items-center justify-center shrink-0 mt-0.5">
                  <Sparkles className="h-5 w-5 text-camino" />
                </div>
                <div>
                  <span className="text-sm font-semibold text-on_surface block">Evaluación personalizada de pareja</span>
                  <span className="text-xs text-on_surface_variant">Construida a partir de ambos perfiles</span>
                </div>
              </div>
            </div>

            <Button size="lg" className="w-full" onClick={handleStartAssessment} loading={loading}>
              Comenzar mi perfil
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>

            <p className="text-xs text-on_surface_variant mt-6">
              🔒 Tus respuestas son completamente privadas
            </p>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Personal Assessment (15 Questions) ───────────────────

  if (step === 'personal_assessment') {
    const currentDimension = ONBOARDING_DIMENSIONS.find(
      (d) => d.slug === currentItem?.dimension_slug
    );

    return (
      <AppShell showNav={false}>
        <div className="max-w-2xl mx-auto">
          {/* Dimension badge */}
          <motion.div
            className="mb-2"
            key={currentItem?.dimension_slug}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.3 }}
          >
            <span
              className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium text-white"
              style={{ backgroundColor: currentDimension?.color || 'var(--primary)' }}
            >
              <span>{currentDimension?.icon}</span>
              {currentDimension?.label || currentItem?.dimension_slug}
            </span>
          </motion.div>

          {/* Progress bar */}
          <div className="mb-8">
            <div className="flex justify-between text-sm text-on_surface_variant mb-2">
              <span>Perfil personal</span>
              <span>{currentQuestionIndex + 1} de {totalItems}</span>
            </div>
            <div className="h-2 bg-surface_container_low rounded-full overflow-hidden">
              <motion.div
                className="h-full bg-primary rounded-full"
                animate={{ width: `${progress}%` }}
                transition={{ duration: 0.5, ease: 'easeOut' }}
              />
            </div>
            <p className="text-xs text-on_surface_variant mt-1">
              ⏱️ ~{Math.max(1, Math.ceil((totalItems - currentQuestionIndex) * 0.2))} min restantes
            </p>
          </div>

          {/* Question card */}
          <AnimatePresence mode="wait">
            <motion.div
              key={currentQuestionIndex}
              initial={{ opacity: 0, x: 30 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -30 }}
              transition={{ duration: 0.3 }}
            >
              <Card className="mb-6">
                <CardContent className="pt-6">
                  <h2 className="text-xl font-semibold text-on_surface mb-8 leading-relaxed">
                    {currentItem?.question_text}
                  </h2>

                  {currentItem && (
                    <OnboardingQuestion
                      item={currentItem}
                      value={answers[currentItem.id]}
                      onChange={handleAnswer}
                    />
                  )}
                </CardContent>
              </Card>
            </motion.div>
          </AnimatePresence>

          {/* Save indicator */}
          <div className="flex justify-center mb-4">
            <span className="text-xs text-on_surface_variant flex items-center gap-1">
              {saving ? (
                <>
                  <Loader2 className="h-3 w-3 animate-spin" />
                  Guardando...
                </>
              ) : sessionId ? (
                <>
                  <span className="w-2 h-2 rounded-full bg-cuidado inline-block" />
                  Respuestas guardadas automáticamente
                </>
              ) : null}
            </span>
          </div>

          {/* Navigation */}
          <div className="flex justify-between">
            <Button
              variant="ghost"
              onClick={handleBack}
              disabled={currentQuestionIndex === 0}
            >
              <ChevronLeft className="mr-2 h-5 w-5" />
              Anterior
            </Button>

            <Button
              onClick={handleNext}
              disabled={!canProceed || saving}
              loading={saving}
            >
              {currentQuestionIndex === totalItems - 1 ? 'Finalizar perfil' : 'Siguiente'}
              <ChevronRight className="ml-2 h-5 w-5" />
            </Button>
          </div>
        </div>
      </AppShell>
    );
  }

  // ─── Profile Ready — Show Results Snapshot ────────────────

  if (step === 'profile_ready') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md w-full text-center"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
          >
            <div className="mb-8">
              <motion.div
                className="w-24 h-24 rounded-full bg-linear-to-br from-cuidado to-conexion mx-auto mb-6 flex items-center justify-center shadow-lg"
                initial={{ scale: 0.5 }}
                animate={{ scale: 1 }}
                transition={{ type: 'spring', stiffness: 300, damping: 20 }}
              >
                <Sparkles className="h-12 w-12 text-white" />
              </motion.div>
              <h1 className="text-3xl font-bold text-on_surface mb-2">
                ¡Tu perfil está listo!
              </h1>
              <p className="text-on_surface_variant text-lg">
                {existingName}, hemos capturado tu estilo relacional.
              </p>
            </div>

            {/* Profile vector snapshot */}
            <div className="bg-surface_container_low rounded-2xl p-5 mb-8 text-left space-y-3">
              {ONBOARDING_DIMENSIONS.map((dim, i) => {
                const vector = profileVectors.find(
                  (v: any) => v.dimension_slug === dim.slug
                );
                const score = vector?.normalized_score || 0;

                return (
                  <motion.div
                    key={dim.slug}
                    className="flex items-center gap-3"
                    initial={{ opacity: 0, x: -10 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: i * 0.1 }}
                  >
                    <span className="text-lg shrink-0">{dim.icon}</span>
                    <div className="flex-1">
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-sm font-medium text-on_surface">{dim.label}</span>
                        <span className="text-xs text-on_surface_variant">{Math.round(score)}%</span>
                      </div>
                      <div className="h-2 bg-surface_container_lowest rounded-full overflow-hidden">
                        <motion.div
                          className="h-full rounded-full"
                          style={{ backgroundColor: dim.color }}
                          initial={{ width: 0 }}
                          animate={{ width: `${score}%` }}
                          transition={{ duration: 0.8, delay: i * 0.1 }}
                        />
                      </div>
                    </div>
                  </motion.div>
                );
              })}
            </div>

            <p className="text-sm text-on_surface_variant mb-6">
              Ahora conecta con tu pareja para una evaluación personalizada construida a partir de ambos perfiles.
            </p>

            <Button size="lg" className="w-full" onClick={() => setStep('couple')}>
              Conectar con mi pareja
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>

            <Button
              variant="ghost"
              className="w-full mt-3"
              onClick={() => router.push('/dashboard')}
            >
              Ir al dashboard
            </Button>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Couple — Choose Create or Join ───────────────────────

  if (step === 'couple') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md space-y-6 w-full"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="text-center mb-4">
              <div className="w-20 h-20 rounded-full bg-linear-to-br from-cuidado to-conexion mx-auto mb-5 flex items-center justify-center shadow-lg">
                <Users className="h-10 w-10 text-white" />
              </div>
              <h1 className="text-2xl font-bold text-on_surface mb-2">
                Conecta con tu pareja
              </h1>
              <p className="text-on_surface_variant">
                ¿Eres el primero en crear el espacio, o tu pareja ya lo hizo?
              </p>
            </div>

            {coupleError && (
              <div className="bg-red-50 text-red-600 rounded-xl p-3 text-sm text-center">
                {coupleError}
              </div>
            )}

            <Card
              className="cursor-pointer hover:shadow-md transition-all active:scale-[0.98]"
              onClick={handleCreateCouple}
            >
              <CardContent className="flex items-center gap-4 py-6">
                <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                  <Heart className="h-7 w-7 text-primary" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-semibold text-on_surface">Crear nueva pareja</h3>
                  <p className="text-sm text-on_surface_variant">
                    Genera un código para compartir con tu pareja
                  </p>
                </div>
                <ArrowRight className="h-5 w-5 text-on_surface_variant shrink-0" />
              </CardContent>
            </Card>

            <Card
              className="cursor-pointer hover:shadow-md transition-all active:scale-[0.98]"
              onClick={() => { setCoupleError(''); setStep('couple_join'); }}
            >
              <CardContent className="flex items-center gap-4 py-6">
                <div className="w-14 h-14 rounded-full bg-cuidado/10 flex items-center justify-center shrink-0">
                  <Users className="h-7 w-7 text-cuidado" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-semibold text-on_surface">Unirme a mi pareja</h3>
                  <p className="text-sm text-on_surface_variant">
                    Ingresa el código que te compartieron
                  </p>
                </div>
                <ArrowRight className="h-5 w-5 text-on_surface_variant shrink-0" />
              </CardContent>
            </Card>

            <Button
              variant="ghost"
              className="w-full"
              onClick={() => router.push('/dashboard')}
            >
              Saltar por ahora
            </Button>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Couple Created — Show Invite Code ────────────────────

  if (step === 'couple_create') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md w-full text-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="mb-8">
              <motion.div
                className="w-20 h-20 rounded-full bg-linear-to-br from-primary to-cuidado mx-auto mb-6 flex items-center justify-center shadow-lg"
                initial={{ scale: 0.5 }}
                animate={{ scale: 1 }}
                transition={{ type: 'spring', stiffness: 300, damping: 20 }}
              >
                <Heart className="h-10 w-10 text-white" />
              </motion.div>
              <h1 className="text-2xl font-bold text-on_surface mb-2">
                ¡Espacio creado!
              </h1>
              <p className="text-on_surface_variant">
                Comparte este código con tu pareja para que se una
              </p>
            </div>

            {/* Invite code display */}
            <div className="bg-surface_container_low rounded-2xl p-6 mb-6">
              <p className="text-xs text-on_surface_variant mb-3 uppercase tracking-wider font-medium">
                Código de invitación
              </p>
              <div className="flex items-center justify-center gap-3">
                <span className="text-4xl font-bold text-primary tracking-[0.2em] font-mono">
                  {inviteCode}
                </span>
              </div>
              <Button
                variant="outline"
                size="sm"
                className="mt-4"
                onClick={handleCopyCode}
              >
                {copied ? (
                  <>
                    <CheckCircle2 className="mr-2 h-4 w-4 text-cuidado" />
                    ¡Copiado!
                  </>
                ) : (
                  <>
                    <Copy className="mr-2 h-4 w-4" />
                    Copiar código
                  </>
                )}
              </Button>
            </div>

            <div className="bg-surface_container_low/50 rounded-xl p-4 mb-8 text-left">
              <p className="text-sm text-on_surface_variant">
                <Clock className="inline h-4 w-4 mr-1 -mt-0.5" />
                Mientras esperas, puedes continuar con la evaluación de pareja. Tu pareja puede unirse en cualquier momento.
              </p>
            </div>

            <div className="space-y-3">
              <Button size="lg" className="w-full" onClick={() => setStep('questionnaire')}>
                Continuar a la evaluación
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
              <Button variant="ghost" className="w-full" onClick={() => router.push('/dashboard')}>
                Ir al dashboard
              </Button>
            </div>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Join Couple — Enter Code ─────────────────────────────

  if (step === 'couple_join') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md w-full"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="text-center mb-8">
              <div className="w-20 h-20 rounded-full bg-linear-to-br from-cuidado to-conexion mx-auto mb-6 flex items-center justify-center shadow-lg">
                <Users className="h-10 w-10 text-white" />
              </div>
              <h1 className="text-2xl font-bold text-on_surface mb-2">
                Únete a tu pareja
              </h1>
              <p className="text-on_surface_variant">
                Ingresa el código de invitación que te compartieron
              </p>
            </div>

            <div className="space-y-6">
              <Input
                id="joinCode"
                label="Código de invitación"
                placeholder="Ej. A1B2C3D4"
                value={joinCode}
                onChange={(e) => {
                  setJoinCode(e.target.value.toUpperCase());
                  if (coupleError) setCoupleError('');
                }}
                onKeyDown={(e) => e.key === 'Enter' && handleJoinCouple()}
                autoFocus
                className="text-center text-xl tracking-[0.15em] font-mono"
              />

              <Button
                size="lg"
                className="w-full"
                onClick={handleJoinCouple}
                loading={loading}
                disabled={!joinCode.trim()}
              >
                Unirme
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>

              <Button
                variant="ghost"
                className="w-full"
                onClick={() => { setCoupleError(''); setStep('couple'); }}
              >
                <ChevronLeft className="mr-2 h-4 w-4" />
                Regresar
              </Button>
            </div>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Couple Done — Successfully Joined ────────────────────

  if (step === 'couple_done') {
    return (
      <AppShell showNav={false}>
        <div className="min-h-screen flex items-center justify-center px-6">
          <motion.div
            className="max-w-md w-full text-center"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
          >
            <motion.div
              className="w-24 h-24 rounded-full bg-linear-to-br from-cuidado to-conexion mx-auto mb-6 flex items-center justify-center shadow-lg"
              initial={{ scale: 0.5 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 300, damping: 20 }}
            >
              <CheckCircle2 className="h-12 w-12 text-white" />
            </motion.div>
            <h1 className="text-3xl font-bold text-on_surface mb-2">
              ¡Conectados! 🎉
            </h1>
            <p className="text-on_surface_variant text-lg mb-8">
              Ya forman un equipo. Ahora es turno de la evaluación de pareja.
            </p>

            <Button size="lg" className="w-full" onClick={() => setStep('questionnaire')}>
              Comenzar evaluación
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>

            <Button variant="ghost" className="w-full mt-3" onClick={() => router.push('/dashboard')}>
              Ir al dashboard
            </Button>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  // ─── Questionnaire CTA (Couple Assessment) ───────────────

  return (
    <AppShell showNav={false}>
      <div className="min-h-screen flex items-center justify-center px-6">
        <motion.div
          className="max-w-md text-center"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <div className="mb-8">
            <div className="w-24 h-24 rounded-full bg-linear-to-br from-conexion to-primary_container mx-auto mb-6 flex items-center justify-center">
              <Sparkles className="h-12 w-12 text-white" />
            </div>
            <h1 className="text-2xl font-bold text-on_surface mb-4">
              Evaluación de pareja
            </h1>
            <p className="text-on_surface_variant mb-2">
              Responde la evaluación personalizada construida a partir de tu perfil.
            </p>
            {partnerName && (
              <p className="text-sm text-primary font-medium mb-2">
                Conectado con {partnerName}
              </p>
            )}
            <p className="text-sm text-on_surface_variant mb-6">
              Cuando tu pareja también la complete, podrán ver sus resultados comparativos.
            </p>
            <div className="bg-surface_container_low rounded-xl p-4 mb-6 text-left">
              <p className="text-sm text-on_surface_variant mb-2">
                ⏱️ Toma entre 15-20 minutos
              </p>
              <p className="text-sm text-on_surface_variant mb-2">
                📱 Cada respuesta se guarda automáticamente
              </p>
              <p className="text-sm text-on_surface_variant">
                🔒 Tus respuestas son completamente privadas
              </p>
            </div>
          </div>

          <Button size="lg" className="w-full" onClick={() => router.push('/dashboard/questionnaire')}>
            Comenzar evaluación
          </Button>

          <Button
            variant="ghost"
            className="w-full mt-4"
            onClick={() => router.push('/dashboard')}
          >
            Más tarde
          </Button>
        </motion.div>
      </div>
    </AppShell>
  );
}
