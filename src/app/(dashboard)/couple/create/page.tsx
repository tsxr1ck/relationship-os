'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Button } from '@/components/ui/Button';
import { Card, CardContent } from '@/components/ui/Card';
import { createCouple } from '@/app/actions';
import { Heart, Copy, Check } from 'lucide-react';

export default function CreateCouplePage() {
  const [loading, setLoading] = useState(false);
  const [coupleCreated, setCoupleCreated] = useState(false);
  const [inviteCode, setInviteCode] = useState('');
  const [error, setError] = useState('');
  const [copied, setCopied] = useState(false);
  const router = useRouter();

  const handleCreateCouple = async () => {
    setLoading(true);
    setError('');

    try {
      const result = await createCouple();
      setInviteCode(result.inviteCode);
      setCoupleCreated(true);
    } catch (err: any) {
      console.error('Error creating couple:', err);
      setError(err.message || 'Error al crear la pareja');
    } finally {
      setLoading(false);
    }
  };

  const copyInviteCode = async () => {
    await navigator.clipboard.writeText(inviteCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleContinue = () => {
    router.push('/dashboard');
  };

  if (coupleCreated) {
    return (
      <AppShell showNav={false}>
        <div className="flex min-h-screen flex-col items-center justify-center px-6">
          <Card className="w-full max-w-sm text-center">
            <CardContent className="pt-6">
              <div className="mb-4 flex justify-center">
                <div className="rounded-full bg-cuidado/20 p-4">
                  <Heart className="h-8 w-8 text-cuidado" />
                </div>
              </div>
              <h1 className="mb-2 text-2xl font-semibold text-on_surface">
                ¡Pareja creada!
              </h1>
              <p className="mb-6 text-on_surface_variant">
                Comparte este código con tu pareja para que pueda unirse
              </p>
              
              <div className="mb-6 rounded-xl bg-surface_container_low p-4">
                <p className="text-sm text-on_surface_variant">Código de invitación</p>
                <p className="mt-1 text-3xl font-mono font-bold tracking-widest text-primary">
                  {inviteCode}
                </p>
              </div>

              <Button
                variant="outline"
                className="w-full mb-4"
                onClick={copyInviteCode}
              >
                {copied ? (
                  <>
                    <Check className="mr-2 h-4 w-4" />
                    Copiado
                  </>
                ) : (
                  <>
                    <Copy className="mr-2 h-4 w-4" />
                    Copiar código
                  </>
                )}
              </Button>

              <Button className="w-full" onClick={handleContinue}>
                Continuar al dashboard
              </Button>
            </CardContent>
          </Card>
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="flex min-h-screen flex-col px-6 pt-12">
        <div className="mb-10 text-center">
          <div className="mb-4 flex justify-center">
            <div className="rounded-2xl bg-gradient-to-br from-primary to-primary_container p-4">
              <Heart className="h-8 w-8 text-white" />
            </div>
          </div>
          <h1 className="mb-2 text-2xl font-semibold text-on_surface">
            Crea tu pareja
          </h1>
          <p className="text-on_surface_variant">
            Genera un código de invitación para compartir con tu pareja
          </p>
        </div>

        <Card>
          <CardContent className="pt-6">
            <p className="mb-6 text-on_surface_variant">
              Al crear una pareja, se generará un código único que podrás compartir 
              con tu pareja para que se una a Relationship OS.
            </p>

            {error && (
              <p className="mb-4 text-sm text-red-500">{error}</p>
            )}

            <Button 
              className="w-full" 
              size="lg" 
              onClick={handleCreateCouple}
              loading={loading}
            >
              Crear pareja
            </Button>
          </CardContent>
        </Card>

        <p className="mt-8 text-center text-sm text-on_surface_variant">
          ¿Tu pareja ya tiene una cuenta?{' '}
          <button
            onClick={() => router.push('/couple/join')}
            className="font-medium text-primary hover:underline"
          >
            Únete a su pareja
          </button>
        </p>
      </div>
    </AppShell>
  );
}
