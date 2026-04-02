'use client';

import { useState, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowLeft, Loader2, Save, Upload, X, BookOpen, Camera, Calendar, Quote } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { createMemory } from '../actions';
import { createClient } from '@/lib/supabase/client';

const dimensions = [
  { id: 'conexion', label: 'Conexión', color: 'var(--color-conexion)' },
  { id: 'cuidado', label: 'Cuidado', color: 'var(--color-cuidado)' },
  { id: 'camino', label: 'Camino', color: 'var(--color-camino)' },
  { id: 'general', label: 'General', color: 'var(--color-text-tertiary)' },
];

const contentTypes = [
  { id: 'text', label: 'Nota', icon: BookOpen, desc: 'Un pensamiento o anécdota.' },
  { id: 'photo', label: 'Foto', icon: Camera, desc: 'Un recuerdo visual especial.' },
  { id: 'quote', label: 'Frase', icon: Quote, desc: 'Algo memorable que se dijeron.' },
  { id: 'milestone', label: 'Hito', icon: Calendar, desc: 'Una fecha importante en su historia.' },
];

export default function NewMemoryPage() {
  const router = useRouter();
  const [step, setStep] = useState<1 | 2>(1);
  const [contentType, setContentType] = useState('text');

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [dimension, setDimension] = useState('general');
  const [occurredAt, setOccurredAt] = useState(new Date().toISOString().split('T')[0]);
  
  const [photoFile, setPhotoFile] = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const supabase = createClient();

  const handlePhotoSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setPhotoFile(file);
      setPhotoPreview(URL.createObjectURL(file));
    }
  };

  const removePhoto = () => {
    setPhotoFile(null);
    setPhotoPreview(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const handleSave = async () => {
    if (!title.trim() || submitting) return;
    setSubmitting(true);
    setError('');

    let mediaUrl = undefined;

    if (contentType === 'photo' && photoFile) {
      const fileExt = photoFile.name.split('.').pop();
      const fileName = `${Math.random().toString(36).substring(2)}_${Date.now()}.${fileExt}`;
      
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('historia')
        .upload(`memories/${fileName}`, photoFile);
        
      if (uploadError) {
        console.error('Upload fail:', uploadError);
        // We'll proceed without breaking if the storage bucket isn't set up yet
        // but log to console.
      } else if (uploadData) {
        const { data: { publicUrl } } = supabase.storage
          .from('historia')
          .getPublicUrl(uploadData.path);
        mediaUrl = publicUrl;
      }
    }

    const payload = {
      title,
      description,
      dimension: dimension === 'general' ? undefined : dimension,
      contentType,
      occurredAt: occurredAt ? new Date(occurredAt).toISOString() : undefined,
      mediaUrl,
    };

    const res = await createMemory(payload);

    if (res.success) {
      router.push('/dashboard/jugar/historia');
      router.refresh();
    } else {
      setError(res.error || 'Error al guardar');
      setSubmitting(false);
    }
  };

  const isFormValid = () => {
    if (!title.trim()) return false;
    if (contentType === 'photo' && !photoFile && !photoPreview) return false;
    return true;
  };

  const typeData = contentTypes.find(t => t.id === contentType) || contentTypes[0];

  return (
    <AppShell showNav={false}>
      <div className="max-w-md mx-auto px-5 pt-8 pb-12 flex flex-col min-h-[80vh]">
        <button
          onClick={() => {
            if (step === 2) {
              setStep(1);
            } else {
              router.back();
            }
          }}
          className="flex items-center gap-2 mb-8 text-sm transition-colors"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> {step === 2 ? 'Cambiar tipo' : 'Volver'}
        </button>

        <AnimatePresence mode="wait">
          {step === 1 ? (
            <motion.div
              key="step1"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="flex-1 flex flex-col justify-center"
            >
              <div className="text-center mb-10">
                <p className="text-[11px] font-bold uppercase tracking-[0.16em] mb-4" style={{ color: 'var(--color-accent-rose)' }}>
                  Paso 1 de 2
                </p>
                <h1 className="font-display text-3xl mb-3" style={{ color: 'var(--color-text-primary)' }}>
                  ¿Qué quieres guardar?
                </h1>
                <p className="text-sm px-6" style={{ color: 'var(--color-text-secondary)' }}>
                  Las memorias son los ladrillos de su historia. Escoge el formato de hoy.
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                {contentTypes.map((type) => {
                  const Icon = type.icon;
                  return (
                    <button
                      key={type.id}
                      onClick={() => {
                        setContentType(type.id);
                        if (type.id === 'quote') {
                          setTitle('');
                          setDescription('');
                        } else if (type.id === 'milestone') {
                          setTitle('');
                          setDescription('');
                        } else {
                          setTitle('');
                          setDescription('');
                        }
                        setStep(2);
                      }}
                      className="group flex flex-col items-center justify-center p-6 rounded-[2rem] text-center transition-all active:scale-95"
                      style={{ 
                        background: 'var(--color-surface-1)', 
                        border: '1px solid var(--color-border)',
                      }}
                    >
                      <div 
                        className="w-12 h-12 rounded-full flex items-center justify-center mb-4 transition-transform group-hover:scale-110"
                        style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)' }}
                      >
                        <Icon className="h-5 w-5" />
                      </div>
                      <h3 className="font-bold text-base mb-1" style={{ color: 'var(--color-text-primary)' }}>{type.label}</h3>
                      <p className="text-[10px] opacity-70 px-1 leading-tight" style={{ color: 'var(--color-text-secondary)' }}>{type.desc}</p>
                    </button>
                  );
                })}
              </div>
            </motion.div>
          ) : (
            <motion.div
              key="step2"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              className="flex-1"
            >
              <div className="flex items-center gap-4 mb-8">
                <div 
                  className="w-12 h-12 rounded-full flex items-center justify-center shrink-0"
                  style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)' }}
                >
                  <typeData.icon className="h-5 w-5" />
                </div>
                <div>
                  <p className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-accent-rose)' }}>
                    Paso 2 de 2
                  </p>
                  <h1 className="font-display text-2xl" style={{ color: 'var(--color-text-primary)' }}>
                    Nueva {typeData.label}
                  </h1>
                </div>
              </div>

              <div className="space-y-6">
                
                {/* PHOTO UPLOAD */}
                {contentType === 'photo' && (
                  <div>
                    {photoPreview ? (
                      <div className="relative rounded-[2rem] overflow-hidden border" style={{ borderColor: 'var(--color-border)' }}>
                        <img src={photoPreview} alt="Preview" className="w-full h-64 object-cover" />
                        <button
                          onClick={removePhoto}
                          type="button"
                          className="absolute top-4 right-4 p-2 rounded-full backdrop-blur-md"
                          style={{ background: 'rgba(0,0,0,0.5)', color: 'white' }}
                        >
                          <X className="h-5 w-5" />
                        </button>
                      </div>
                    ) : (
                      <div
                        onClick={() => fileInputRef.current?.click()}
                        className="h-64 border-2 border-dashed rounded-[2rem] flex flex-col items-center justify-center cursor-pointer transition-all active:scale-95"
                        style={{ borderColor: 'var(--color-border)', background: 'var(--color-surface-1)' }}
                      >
                        <div className="w-14 h-14 rounded-full flex items-center justify-center mb-4" style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-secondary)' }}>
                          <Camera className="h-6 w-6" />
                        </div>
                        <p className="text-sm font-bold" style={{ color: 'var(--color-text-primary)' }}>
                          Toca para añadir foto
                        </p>
                      </div>
                    )}
                    <input
                      ref={fileInputRef}
                      type="file"
                      accept="image/*"
                      onChange={handlePhotoSelect}
                      className="hidden"
                    />
                  </div>
                )}

                {/* TITLE FIELD (Varies depending on context) */}
                <div>
                  <label className="block text-xs uppercase tracking-wide font-bold mb-2 ml-1 cursor-text" style={{ color: 'var(--color-text-secondary)' }}>
                    {contentType === 'quote' ? 'Frase' : contentType === 'milestone' ? 'Nombre del hito' : 'Título'}
                  </label>
                  {contentType === 'quote' ? (
                    <textarea
                      value={title}
                      onChange={e => setTitle(e.target.value)}
                      rows={3}
                      className="w-full rounded-[2rem] p-5 text-xl font-display outline-none resize-none leading-relaxed"
                      style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)', color: 'var(--color-text-primary)' }}
                      placeholder='"El amor de mi vida..."'
                      autoFocus
                    />
                  ) : (
                    <input
                      type="text"
                      value={title}
                      onChange={e => setTitle(e.target.value)}
                      className="w-full bg-transparent border-b text-xl font-display outline-none py-2 transition-all px-1"
                      style={{ borderColor: 'var(--color-border)', color: 'var(--color-text-primary)' }}
                      placeholder={
                        contentType === 'photo' ? 'Un atardecer inolvidable' :
                        contentType === 'milestone' ? 'Ej. Nos mudamos juntos' :
                        'Ej. Aquel café en la lluvia...'
                      }
                      autoFocus={contentType !== 'photo'}
                    />
                  )}
                </div>

                {/* DESCRIPTION / CONTEXT FIELD */}
                <div>
                  <label className="block text-xs uppercase tracking-wide font-bold mb-2 ml-1" style={{ color: 'var(--color-text-secondary)' }}>
                    {contentType === 'quote' ? 'Contexto / Autor' : contentType === 'photo' ? 'Historia detrás de la foto' : 'Detalles'}
                  </label>
                  <textarea
                    value={description}
                    onChange={e => setDescription(e.target.value)}
                    rows={contentType === 'quote' ? 2 : 4}
                    className="w-full rounded-[2rem] p-5 text-sm outline-none resize-none leading-relaxed"
                    style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)', color: 'var(--color-text-primary)' }}
                    placeholder={
                      contentType === 'quote' ? '¿Cuándo o por qué se dijo?' :
                      'Cuenta más sobre este recuerdo...'
                    }
                  />
                </div>

                {/* DATE FIELD (Always available but emphasized for milestones) */}
                {(contentType === 'milestone' || contentType === 'photo' || contentType === 'text' || contentType === 'quote') && (
                  <div>
                    <label className="block text-xs uppercase tracking-wide font-bold mb-2 ml-1" style={{ color: 'var(--color-text-secondary)' }}>
                      Fecha
                    </label>
                    <input
                      type="date"
                      value={occurredAt}
                      onChange={e => setOccurredAt(e.target.value)}
                      className="w-full rounded-[1.5rem] px-5 py-4 text-sm outline-none transition-all"
                      style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)', color: 'var(--color-text-primary)' }}
                    />
                  </div>
                )}

                {/* DIMENSION FIELD */}
                <div>
                  <label className="block text-xs uppercase tracking-wide font-bold mb-3 ml-1" style={{ color: 'var(--color-text-secondary)' }}>
                    Pilar asociado
                  </label>
                  <div className="flex flex-wrap gap-2">
                    {dimensions.map(dim => (
                      <button
                        key={dim.id}
                        onClick={() => setDimension(dim.id)}
                        className={`px-4 py-2.5 rounded-full text-[13px] font-bold transition-all flex items-center gap-1.5 ${dimension === dim.id ? '' : 'opacity-60 saturate-50'}`}
                        style={{
                          background: dimension === dim.id ? 'var(--color-surface-1)' : 'transparent',
                          color: dimension === dim.id ? dim.color : 'var(--color-text-secondary)',
                          border: `1px solid ${dimension === dim.id ? dim.color : 'var(--color-border)'}`,
                          boxShadow: dimension === dim.id ? `0 0 16px ${dim.color}20` : 'none',
                        }}
                      >
                        {dim.label}
                      </button>
                    ))}
                  </div>
                </div>

                {error && <p className="text-sm px-1 mt-2 text-center" style={{ color: 'var(--color-danger)' }}>{error}</p>}
              </div>

              <div className="mt-10 mb-8">
                <button
                  onClick={handleSave}
                  disabled={!isFormValid() || submitting}
                  className="w-full py-4 rounded-[2rem] text-[15px] font-bold flex items-center justify-center gap-2 transition-all disabled:opacity-50 disabled:scale-100 active:scale-[0.98]"
                  style={{ background: 'var(--color-accent-rose)', color: 'var(--color-base)' }}
                >
                  {submitting ? <Loader2 className="h-5 w-5 animate-spin" /> : <><Save className="h-5 w-5" /> Guardar Memoria</>}
                </button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </AppShell>
  );
}