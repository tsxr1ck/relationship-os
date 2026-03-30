'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Heart, Eye, EyeOff, Check } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { useAuth } from '@/lib/supabase/hooks';

export default function SignupPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const { signUpWithPassword } = useAuth();
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    if (password !== confirmPassword) {
      setError('Las contraseñas no coinciden');
      setLoading(false);
      return;
    }

    if (password.length < 6) {
      setError('La contraseña debe tener al menos 6 caracteres');
      setLoading(false);
      return;
    }

    const { error } = await signUpWithPassword(email, password);
    
    if (error) {
      setError(error.message);
      setLoading(false);
    } else {
      setSuccess(true);
    }
  };

  if (success) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center px-6">
        <div className="w-full max-w-sm text-center">
          <div className="mb-6 flex justify-center">
            <div className="rounded-full bg-cuidado/30 p-4">
              <Check className="h-8 w-8 text-cuidado" />
            </div>
          </div>
          <h1 className="mb-2 text-2xl font-semibold text-on_surface">¡Cuenta creada!</h1>
          <p className="mb-4 text-on_surface_variant">
            Te enviamos un correo de confirmación a <strong>{email}</strong>
          </p>
          <p className="text-sm text-on_surface_variant">
            Revisa tu bandeja de entrada y sigue las instrucciones.
          </p>
          <Link href="/login" className="mt-6 inline-block">
            <Button>Iniciar sesión</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col px-6 pt-12">
      <div className="mb-10 text-center">
        <div className="mb-4 flex justify-center">
          <div className="rounded-2xl bg-gradient-to-br from-primary to-primary_container p-4">
            <Heart className="h-8 w-8 text-white" />
          </div>
        </div>
        <h1 className="mb-2 text-3xl font-semibold text-on_surface">Únete a Relationship OS</h1>
        <p className="text-on_surface_variant">
          Comienza a descubrir y fortalecer tu relación
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          id="email"
          type="email"
          label="Correo electrónico"
          placeholder="tu@email.com"
          value={email}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)}
          required
        />

        <div className="relative">
          <Input
            id="password"
            type={showPassword ? 'text' : 'password'}
            label="Contraseña"
            placeholder="Mínimo 6 caracteres"
            value={password}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => setPassword(e.target.value)}
            required
          />
          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            className="absolute right-3 top-9 text-on_surface_variant hover:text-on_surface"
          >
            {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
          </button>
        </div>

        <Input
          id="confirmPassword"
          type={showPassword ? 'text' : 'password'}
          label="Confirmar contraseña"
          placeholder="Repite tu contraseña"
          value={confirmPassword}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) => setConfirmPassword(e.target.value)}
          required
        />

        {error && <p className="text-sm text-red-500">{error}</p>}

        <Button type="submit" className="w-full" size="lg" loading={loading}>
          Crear cuenta
        </Button>
      </form>

      <p className="mt-8 text-center text-sm text-on_surface_variant">
        ¿Ya tienes cuenta?{' '}
        <Link href="/login" className="font-medium text-primary hover:underline">
          Inicia sesión
        </Link>
      </p>
    </div>
  );
}
