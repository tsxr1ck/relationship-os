'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { QuestionRenderer } from '@/components/questionnaire/QuestionRenderer';
import { QuestionnaireSection, Question } from '@/types/questionnaire';
import { ChevronLeft, ChevronRight, Sparkles, Loader2, BrainCircuit } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { startQuestionnaireSession, saveAnswer, completeQuestionnaire, getQuestionnaireData, checkAssessmentPreconditions, generateCustomAssessment } from './actions';

export default function QuestionnairePage() {
  const router = useRouter();
  const [currentSectionIndex, setCurrentSectionIndex] = useState(0);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [saving, setSaving] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [initializing, setInitializing] = useState(true);
  const [completed, setCompleted] = useState(false);
  const [sections, setSections] = useState<QuestionnaireSection[]>([]);
  const [questionsBySection, setQuestionsBySection] = useState<Record<string, Question[]>>({});
  const [loadingData, setLoadingData] = useState(true);

  // V2 Status
  const [assessmentStatus, setAssessmentStatus] = useState<'checking' | 'waiting_for_partner' | 'needs_generation' | 'ready' | 'error'>('checking');
  const [generating, setGenerating] = useState(false);
  const [generationStep, setGenerationStep] = useState(0);

  const loadingSteps = [
    'Analizando perfiles de ambos...',
    'Identificando fortalezas en Cuidado y Conexión...',
    'Evaluando áreas de Choque y Camino...',
    'Diseñando tus 28 preguntas únicas...'
  ];

  const currentSection = sections[currentSectionIndex];
  const sectionQuestions = currentSection ? questionsBySection[currentSection.id] || [] : [];
  const currentQuestion = sectionQuestions[currentQuestionIndex];

  const totalQuestions = sections.reduce(
    (acc, s) => acc + (questionsBySection[s.id]?.length || 0), 0
  );
  const currentTotal = sections.slice(0, currentSectionIndex).reduce(
    (acc, s) => acc + (questionsBySection[s.id]?.length || 0), 0
  ) + currentQuestionIndex + 1;
  const progress = totalQuestions > 0 ? (currentTotal / totalQuestions) * 100 : 0;

  useEffect(() => {
    async function checkPreconditions() {
      try {
        const { status, coupleId } = await checkAssessmentPreconditions();
        setAssessmentStatus(status as any);

        if (status === 'needs_generation' && coupleId) {
          setGenerating(true);
          const genResponse = await generateCustomAssessment(coupleId);
          if (genResponse.success) {
            setAssessmentStatus('ready');
          } else {
            console.error('Generation Error:', genResponse.error);
            setAssessmentStatus('error');
          }
          setGenerating(false);
        }
      } catch (err) {
        console.error('Precondition err:', err);
        setAssessmentStatus('error');
      }
    }
    checkPreconditions();
  }, []);

  // Cycle text while generating
  useEffect(() => {
    if (!generating) return;
    const interval = setInterval(() => {
      setGenerationStep(prev => (prev + 1) % loadingSteps.length);
    }, 2500);
    return () => clearInterval(interval);
  }, [generating]);

  // Load actual data only when ready
  useEffect(() => {
    if (assessmentStatus !== 'ready') return;
    async function loadQuestionnaire() {
      try {
        const data = await getQuestionnaireData();
        setSections(data.sections);
        setQuestionsBySection(data.questionsBySection);
      } catch (err) {
        console.error('Error loading questionnaire:', err);
      } finally {
        setLoadingData(false);
      }
    }
    loadQuestionnaire();
  }, [assessmentStatus]);

  // Initialize session AFTER sections are loaded so we can resume position
  useEffect(() => {
    if (loadingData || sections.length === 0 || assessmentStatus !== 'ready') return;

    async function init() {
      try {
        const result = await startQuestionnaireSession();

        if (result.session.status === 'completed') {
          setCompleted(true);
          return;
        }

        setSessionId(result.session.id);
        setAnswers(result.answers || {});

        if (result.session.current_section && result.session.current_question_index > 0) {
          const sectionIdx = sections.findIndex(
            (s) => s.id === result.session.current_section
          );
          if (sectionIdx >= 0) {
            setCurrentSectionIndex(sectionIdx);
            setCurrentQuestionIndex(result.session.current_question_index);
          }
        }
      } catch (err) {
        console.error('Error initializing questionnaire:', err);
      } finally {
        setInitializing(false);
      }
    }
    init();
  }, [loadingData, sections, assessmentStatus]);

  const handleAnswer = useCallback((value: any) => {
    if (currentQuestion) {
      setAnswers((prev) => ({
        ...prev,
        [currentQuestion.id]: value,
      }));
    }
  }, [currentQuestion]);

  const handleNext = async () => {
    if (!sessionId || !currentQuestion) return;
    setSaving(true);

    try {
      // Calculate the next position for session tracking
      let nextSectionIndex = currentSectionIndex;
      let nextQuestionIndex = currentQuestionIndex;

      const isLastQuestion = currentQuestionIndex >= sectionQuestions.length - 1;
      const isLastSection = currentSectionIndex >= sections.length - 1;

      if (!isLastQuestion) {
        nextQuestionIndex = currentQuestionIndex + 1;
      } else if (!isLastSection) {
        nextSectionIndex = currentSectionIndex + 1;
        nextQuestionIndex = 0;
      }

      const nextSection = sections[nextSectionIndex];
      const nextProgress = isLastQuestion && isLastSection
        ? 100
        : ((sections.slice(0, nextSectionIndex).reduce(
            (acc, s) => acc + (questionsBySection[s.id]?.length || 0), 0
          ) + nextQuestionIndex + 1) / totalQuestions) * 100;

      // Save the answer to Supabase
      await saveAnswer(
        sessionId,
        currentQuestion.id,
        answers[currentQuestion.id],
        nextSection?.id || currentSection.id,
        nextQuestionIndex,
        Math.round(nextProgress)
      );

      // Navigate
      if (isLastQuestion && isLastSection) {
        // Completed all questions
        await completeQuestionnaire(sessionId);
        setCompleted(true);
      } else if (isLastQuestion) {
        setCurrentSectionIndex((prev) => prev + 1);
        setCurrentQuestionIndex(0);
      } else {
        setCurrentQuestionIndex((prev) => prev + 1);
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
    } else if (currentSectionIndex > 0) {
      setCurrentSectionIndex((prev) => prev - 1);
      setCurrentQuestionIndex(
        (questionsBySection[sections[currentSectionIndex - 1].id]?.length || 1) - 1
      );
    }
  };

  const canProceed =
    currentQuestion &&
    (!currentQuestion.is_required || answers[currentQuestion.id] !== undefined);

  // Intercepting assessment gating
  if (assessmentStatus === 'checking') {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <Loader2 className="h-8 w-8 text-primary animate-spin" />
        </div>
      </AppShell>
    );
  }

  if (assessmentStatus === 'waiting_for_partner') {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center max-w-md p-8 bg-surface_container_low rounded-3xl border border-primary/10">
            <div className="w-16 h-16 rounded-2xl bg-primary/10 mx-auto flex items-center justify-center mb-6">
              <Sparkles className="h-8 w-8 text-primary" />
            </div>
            <h2 className="text-xl font-semibold mb-3">Esperando a tu pareja</h2>
            <p className="text-on_surface_variant">
              Ambos deben crear y completar su Perfil Personal antes de que la Inteligencia Artificial pueda generar su evaluación personalizada.
            </p>
            <Button variant="outline" className="mt-6 w-full" onClick={() => router.push('/dashboard')}>
              Volver al Inicio
            </Button>
          </div>
        </div>
      </AppShell>
    );
  }

  if (assessmentStatus === 'needs_generation' || generating) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center max-w-md w-full">
            <div className="relative w-24 h-24 mx-auto mb-8">
              <motion.div 
                className="absolute inset-0 rounded-full bg-linear-to-br from-primary to-conexion opacity-20"
                animate={{ scale: [1, 1.2, 1], opacity: [0.2, 0.5, 0.2] }}
                transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
              />
              <div className="absolute inset-0 flex items-center justify-center">
                <BrainCircuit className="h-10 w-10 text-primary" />
              </div>
            </div>
            
            <AnimatePresence mode="wait">
              <motion.div
                key={generationStep}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.5 }}
                className="h-16"
              >
                <h3 className="text-lg font-medium text-on_surface">
                  {loadingSteps[generationStep]}
                </h3>
                <p className="text-sm text-on_surface_variant mt-1">Generando evaluación por IA...</p>
              </motion.div>
            </AnimatePresence>
            
            <div className="mt-6 h-1 w-48 bg-surface_container_low mx-auto rounded-full overflow-hidden">
              <motion.div 
                className="h-full bg-primary"
                initial={{ width: "0%" }}
                animate={{ width: "100%" }}
                transition={{ duration: 10, ease: "linear" }}
              />
            </div>
          </div>
        </div>
      </AppShell>
    );
  }

  // Loading state
  if (initializing || loadingData) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center">
            <Loader2 className="h-12 w-12 text-primary mx-auto mb-4 animate-spin" />
            <p className="text-on_surface_variant">Preparando tu cuestionario...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  // Completion state — only show when explicitly completed, not when data is missing
  if (completed) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center max-w-md">
            <div className="w-24 h-24 rounded-full bg-linear-to-br from-conexion to-primary_container mx-auto mb-6 flex items-center justify-center">
              <Sparkles className="h-12 w-12 text-white" />
            </div>
            <h2 className="text-2xl font-semibold mb-2">¡Has completado el cuestionario!</h2>
            <p className="text-on_surface_variant mb-2">
              Gracias por responder todas las preguntas.
            </p>
            <p className="text-sm text-on_surface_variant mb-6">
              Tus respuestas se han guardado de forma segura y privada. 🔒
            </p>
            <Button size="lg" onClick={() => router.push('/dashboard')}>
              Ver tu dashboard
            </Button>
          </div>
        </div>
      </AppShell>
    );
  }

  // Edge case: data loaded but no questions found (DB issue)
  if (!currentSection || !currentQuestion) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center max-w-md">
            <p className="text-on_surface_variant mb-4">
              No se encontraron preguntas. Intenta recargar la página.
            </p>
            <Button variant="ghost" onClick={() => window.location.reload()}>
              Recargar
            </Button>
          </div>
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="max-w-2xl mx-auto">
        {/* Section header with transition */}
        <div className="mb-2">
          <span
            className="inline-block px-3 py-1 rounded-full text-xs font-medium"
            style={{
              backgroundColor: currentSection.id === 'section-a' ? 'var(--conexion)' :
                currentSection.id === 'section-b' ? 'var(--cuidado)' :
                currentSection.id === 'section-c' ? 'var(--choque)' : 'var(--camino)',
              color: 'white',
              opacity: 0.9,
            }}
          >
            {currentSection.name}
          </span>
        </div>

        {/* Progress */}
        <div className="mb-8">
          <div className="flex justify-between text-sm text-on_surface_variant mb-2">
            <span>Bloque {currentSectionIndex + 1} de {sections.length}</span>
            <span>{currentTotal} de {totalQuestions}</span>
          </div>
          <div className="h-2 bg-surface_container_low rounded-full overflow-hidden">
            <div
              className="h-full bg-primary transition-all duration-500 ease-out"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>

        {/* Question Card */}
        <Card className="mb-6">
          <CardContent className="pt-6">
            <div className="mb-2 text-sm text-on_surface_variant">
              Pregunta {currentQuestion.question_number}
            </div>
            <h2 className="text-xl font-semibold text-on_surface mb-8">
              {currentQuestion.question_text}
            </h2>

            <QuestionRenderer
              question={currentQuestion}
              value={answers[currentQuestion.id]}
              onChange={handleAnswer}
            />
          </CardContent>
        </Card>

        {/* Auto-save indicator */}
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
            disabled={currentSectionIndex === 0 && currentQuestionIndex === 0}
          >
            <ChevronLeft className="mr-2 h-5 w-5" />
            Anterior
          </Button>

          <Button
            onClick={handleNext}
            disabled={!canProceed || saving}
            loading={saving}
          >
            {currentSectionIndex === sections.length - 1 &&
             currentQuestionIndex === sectionQuestions.length - 1
              ? 'Finalizar'
              : 'Siguiente'}
            <ChevronRight className="ml-2 h-5 w-5" />
          </Button>
        </div>
      </div>
    </AppShell>
  );
}
