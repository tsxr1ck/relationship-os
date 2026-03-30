'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Card, CardContent } from '@/components/ui/Card';
import { joinCouple } from '@/app/actions';
import { Users } from 'lucide-react';

export default function JoinCouplePage() {
  const [inviteCode, setInviteCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();

  const handleJoin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      await joinCouple(inviteCode);
      router.push('/dashboard');
    } catch (err: any) {
      console.error('Error joining couple:', err);
      setError(err.message || 'Error al unirse a la pareja');
    } finally {
      setLoading(false);
    }
  };

  return (
    <AppShell showNav={false}>
      <div className="flex min-h-screen flex-col px-6 pt-12">
        <div className="mb-10 text-center">
          <div className="mb-4 flex justify-center">
            <div className="rounded-2xl bg-gradient-to-br from-primary to-primary_container p-4">
              <Users className="h-8 w-8 text-white" />
            </div>
          </div>
          <h1 className="mb-2 text-2xl font-semibold text-on_surface">
            Únete a tu pareja
          </h1>
          <p className="text-on_surface_variant">
            Ingresa el código de invitación que te compartió tu pareja
          </p>
        </div>

        <form onSubmit={handleJoin}>
          <Card>
            <CardContent className="pt-6">
              <Input
                id="inviteCode"
                label="Código de invitación"
                placeholder="ABCD1234"
                value={inviteCode}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => 
                  setInviteCode(e.target.value.toUpperCase())
                }
                maxLength={8}
                className="text-center text-2xl font-mono tracking-widest"
              />

              {error && (
                <p className="mt-2 text-sm text-red-500">{error}</p>
              )}

              <Button 
                type="submit" 
                className="w-full mt-6" 
                size="lg"
                loading={loading}
                disabled={inviteCode.length < 8}
              >
                Unirse a la pareja
              </Button>
            </CardContent>
          </Card>
        </form>

        <p className="mt-8 text-center text-sm text-on_surface_variant">
          ¿No tienes un código?{' '}
          <button
            onClick={() => router.push('/couple/create')}
            className="font-medium text-primary hover:underline"
          >
            Crea una pareja
          </button>
        </p>
      </div>
    </AppShell>
  );
}
