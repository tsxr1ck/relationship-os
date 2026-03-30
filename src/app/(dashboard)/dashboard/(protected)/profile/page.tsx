'use client';

import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { useAuth } from '@/lib/supabase/hooks';
import {
  User, Settings, LogOut, Heart, Bell, Loader2, Share2,
  Users, Copy, Check, Pencil, X, ChevronRight, Link2, UserPlus,
  Camera, Trash2, Calendar, Sparkles, AlertCircle
} from 'lucide-react';
import Image from 'next/image';
import {
  getProfile, updateProfile, getProfileCoupleInfo,
  uploadAvatar, deleteAvatar, generateProfileCoaching,
  requestNicknameSharing, updateSharedNickname,
  type ProfileData, type CoupleInfo, type ProfileCoaching
} from './actions';

export default function ProfilePage() {
  const { user, signOut } = useAuth();
  const router = useRouter();

  // Data state
  const [profile, setProfile] = useState<ProfileData | null>(null);
  const [coupleInfo, setCoupleInfo] = useState<CoupleInfo | null>(null);
  const [coaching, setCoaching] = useState<ProfileCoaching | null>(null);

  // Loading state
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [coachingLoading, setCoachingLoading] = useState(false);

  // Editing state - Personal
  const [editingPersonal, setEditingPersonal] = useState(false);
  const [editForm, setEditForm] = useState({
    fullName: '',
    nickname: '',
    birthdate: '',
    gender: '',
    bio: ''
  });

  // Editing state - Couple
  const [editingCouple, setEditingCouple] = useState(false);
  const [editCoupleName, setEditCoupleName] = useState('');

  // Avatar upload
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploadingAvatar, setUploadingAvatar] = useState(false);

  // Misc UI
  const [copied, setCopied] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function loadData() {
    try {
      const [pData, cData] = await Promise.all([
        getProfile(),
        getProfileCoupleInfo()
      ]);
      setProfile(pData);
      setCoupleInfo(cData);

      if (pData) {
        setEditForm({
          fullName: pData.fullName,
          nickname: pData.nickname || '',
          birthdate: pData.birthdate || '',
          gender: pData.gender || '',
          bio: pData.bio || ''
        });
      }

      if (cData && cData.couple) {
        setEditCoupleName(cData.couple.sharedNickname || '');
      }

      // Load coaching in background
      loadCoaching(false);
    } catch (err) {
      console.error('Error loading profile:', err);
    } finally {
      setLoading(false);
    }
  }

  async function loadCoaching(force: boolean = false) {
    setCoachingLoading(true);
    try {
      const data = await generateProfileCoaching(force);
      setCoaching(data);
    } catch (err) {
      console.error(err);
    } finally {
      setCoachingLoading(false);
    }
  }

  const handleSignOut = async () => {
    await signOut();
    router.push('/login');
  };

  // ─── Actions: Avatar ──────────────────────────────────────────────────

  const handleAvatarClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploadingAvatar(true);
    try {
      const formData = new FormData();
      formData.append('avatar', file);
      const { avatarUrl } = await uploadAvatar(formData);
      setProfile(prev => prev ? { ...prev, avatarUrl } : null);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setUploadingAvatar(false);
      // Reset input
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleDeleteAvatar = async (e: React.MouseEvent) => {
    e.stopPropagation();
    if (!confirm('¿Seguro que quieres eliminar tu foto?')) return;
    try {
      await deleteAvatar();
      setProfile(prev => prev ? { ...prev, avatarUrl: null } : null);
    } catch (err: any) {
      alert(err.message);
    }
  };

  // ─── Actions: Personal Info ───────────────────────────────────────────

  const handleSavePersonal = async () => {
    if (!editForm.fullName.trim()) {
      setError('El nombre es obligatorio');
      return;
    }
    setError('');
    setSaving(true);
    try {
      await updateProfile(editForm);
      await loadData(); // Reload to get computed age etc
      setEditingPersonal(false);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  };

  // ─── Actions: Couple Nickname ─────────────────────────────────────────

  const handleToggleConsent = async () => {
    setSaving(true);
    try {
      const { bothConsented, myConsent } = await requestNicknameSharing();
      setCoupleInfo(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          myConsent,
          couple: prev.couple ? { ...prev.couple, bothConsented } : undefined
        };
      });
    } catch (err: any) {
      alert(err.message);
    } finally {
      setSaving(false);
    }
  };

  const handleSaveCoupleNickname = async () => {
    setSaving(true);
    try {
      await updateSharedNickname(editCoupleName.trim());
      setCoupleInfo(prev => {
        if (!prev || !prev.couple) return prev;
        return { ...prev, couple: { ...prev.couple, sharedNickname: editCoupleName.trim() } };
      });
      setEditingCouple(false);
    } catch (err: any) {
      alert(err.message);
    } finally {
      setSaving(false);
    }
  };

  // ─── Renderers ────────────────────────────────────────────────────────

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <Loader2 className="h-12 w-12 text-primary animate-spin" />
        </div>
      </AppShell>
    );
  }

  const hasCouple = coupleInfo?.hasCouple;
  const isLinked = hasCouple && coupleInfo?.isLinked;
  const bothConsented = coupleInfo?.couple?.bothConsented;

  return (
    <AppShell>
      <div className="space-y-8 max-w-2xl mx-auto pb-12">
        {/* ============ Header & Avatar ============ */}
        <div className="text-center pt-4">
          <div className="relative inline-block group">
            <div
              onClick={handleAvatarClick}
              className={`w-28 h-28 rounded-full flex items-center justify-center text-4xl font-bold shadow-lg overflow-hidden cursor-pointer relative transition-transform hover:scale-[1.02] ${profile?.avatarUrl ? 'bg-surface_container_low' : 'bg-linear-to-br from-primary to-primary_container text-white'
                }`}
            >
              {profile?.avatarUrl ? (
                <Image src={profile.avatarUrl} alt="Avatar" className="object-cover" // Keeps the image from stretching out of proportion
                  sizes="(max-width: 768px) 100vw, 128px" width={128} height={128} />
              ) : (
                (profile?.fullName || 'U').charAt(0).toUpperCase()
              )}

              {uploadingAvatar && (
                <div className="absolute inset-0 bg-black/40 flex items-center justify-center">
                  <Loader2 className="h-8 w-8 text-white animate-spin" />
                </div>
              )}

              {/* Hover overlay */}
              {!uploadingAvatar && (
                <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-colors flex items-center justify-center opacity-0 group-hover:opacity-100">
                  <Camera className="h-8 w-8 text-white/90" />
                </div>
              )}
            </div>

            {/* Hidden Input */}
            <input
              type="file"
              ref={fileInputRef}
              className="hidden"
              accept="image/jpeg, image/png, image/webp"
              onChange={handleFileChange}
            />

            {/* Trash badge */}
            {profile?.avatarUrl && !uploadingAvatar && (
              <button
                onClick={handleDeleteAvatar}
                className="absolute top-0 right-0 w-8 h-8 bg-red-500 rounded-full border-2 border-surface flex items-center justify-center hover:bg-red-600 transition-colors z-10"
              >
                <Trash2 className="h-4 w-4 text-white" />
              </button>
            )}

            {hasCouple && (
              <span className="absolute -bottom-1 -right-1 w-8 h-8 bg-cuidado rounded-full border-4 border-surface flex items-center justify-center z-10">
                <Heart className="h-3.5 w-3.5 text-white" />
              </span>
            )}
          </div>
        </div>

        {/* ============ Personal Info Section ============ */}
        <section>
          <Card className="overflow-hidden">
            <CardContent className="p-0">
              <div className="bg-surface_container_lowest p-5 border-b border-outline_variant/30 flex justify-between items-center">
                <h2 className="font-semibold flex items-center gap-2">
                  <User className="h-4 w-4 text-primary" /> Información Personal
                </h2>
                {!editingPersonal && (
                  <button onClick={() => setEditingPersonal(true)} className="p-1.5 hover:bg-surface_container_low rounded-lg transition-colors text-on_surface_variant">
                    <Pencil className="h-4 w-4" />
                  </button>
                )}
              </div>

              <div className="p-5 space-y-4">
                {editingPersonal ? (
                  <div className="space-y-4">
                    {error && (
                      <div className="p-3 bg-red-50 text-red-600 text-sm rounded-lg flex items-center gap-2">
                        <AlertCircle className="h-4 w-4" /> {error}
                      </div>
                    )}
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div className="space-y-1.5">
                        <label className="text-xs font-semibold text-on_surface_variant">Nombre completo</label>
                        <Input
                          value={editForm.fullName}
                          onChange={e => setEditForm(prev => ({ ...prev, fullName: e.target.value }))}
                          placeholder="Tu nombre"
                        />
                      </div>
                      <div className="space-y-1.5">
                        <label className="text-xs font-semibold text-on_surface_variant">Apodo personal <span className="text-on_surface_variant/50 font-normal">(Opcional)</span></label>
                        <Input
                          value={editForm.nickname}
                          onChange={e => setEditForm(prev => ({ ...prev, nickname: e.target.value }))}
                          placeholder="Ej. Chema, Paco"
                        />
                      </div>
                      <div className="space-y-1.5">
                        <label className="text-xs font-semibold text-on_surface_variant">Fecha de nacimiento</label>
                        <Input
                          type="date"
                          value={editForm.birthdate}
                          onChange={e => setEditForm(prev => ({ ...prev, birthdate: e.target.value }))}
                        />
                      </div>
                      <div className="space-y-1.5">
                        <label className="text-xs font-semibold text-on_surface_variant">Género</label>
                        <select
                          className="w-full px-3 py-2 bg-transparent border border-outline rounded-lg text-sm focus:outline-hidden focus:ring-1 focus:ring-primary focus:border-primary transition-all text-on_surface"
                          value={editForm.gender}
                          onChange={e => setEditForm(prev => ({ ...prev, gender: e.target.value }))}
                        >
                          <option value="">Selecciona...</option>
                          <option value="male">Hombre</option>
                          <option value="female">Mujer</option>
                        </select>
                      </div>
                    </div>

                    <div className="space-y-1.5">
                      <label className="text-xs font-semibold text-on_surface_variant">Biografía <span className="text-on_surface_variant/50 font-normal">(Opcional)</span></label>
                      <textarea
                        className="w-full px-3 py-2 bg-transparent border border-outline rounded-lg text-sm focus:outline-hidden focus:ring-1 focus:ring-primary focus:border-primary transition-all text-on_surface resize-none h-20"
                        value={editForm.bio}
                        onChange={e => setEditForm(prev => ({ ...prev, bio: e.target.value }))}
                        placeholder="Algo sobre ti (hasta 280 caracteres)"
                        maxLength={280}
                      />
                    </div>

                    <div className="flex justify-end gap-2 pt-2 border-t border-outline_variant/30">
                      <Button variant="ghost" onClick={() => setEditingPersonal(false)}>Cancelar</Button>
                      <Button onClick={handleSavePersonal} loading={saving}>Guardar Cambios</Button>
                    </div>
                  </div>
                ) : (
                  <div className="space-y-4">
                    <div className="flex items-center gap-3">
                      <h3 className="text-xl font-semibold">{profile?.fullName}</h3>
                      {profile?.age && (
                        <span className="px-2 py-0.5 bg-surface_container_low text-xs rounded-full font-medium">
                          {profile.age} años
                        </span>
                      )}
                      {profile?.nickname && (
                        <span className="px-2 py-0.5 bg-primary/10 text-primary text-xs rounded-full font-medium">
                          "{profile.nickname}"
                        </span>
                      )}
                    </div>

                    <p className="text-sm text-on_surface_variant flex items-center gap-2">
                      <User className="h-4 w-4" /> {user?.email}
                    </p>

                    {profile?.bio && (
                      <p className="text-sm text-on_surface bg-surface_container_lowest p-3 rounded-lg border border-outline_variant/30 italic">
                        "{profile.bio}"
                      </p>
                    )}

                    <div className="flex gap-4 text-xs text-on_surface_variant">
                      {profile?.gender && (
                        <span>{profile.gender === 'male' ? '👨 Hombre' : '👩 Mujer'}</span>
                      )}
                      {profile?.createdAt && (
                        <span className="flex items-center gap-1">
                          <Calendar className="h-3.5 w-3.5" /> Miembro desde {new Date(profile.createdAt).toLocaleDateString('es-MX', { year: 'numeric', month: 'long' })}
                        </span>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </CardContent>
          </Card>
        </section>

        {/* ============ Tu Coach Dice ============ */}
        {profile && (
          <section>
            <Card className="bg-linear-to-br from-primary/5 to-transparent border-primary/20">
              <CardContent className="p-5">
                <div className="flex justify-between items-start mb-3">
                  <h3 className="text-sm font-semibold text-primary flex items-center gap-2 uppercase tracking-wide">
                    <Sparkles className="h-4 w-4" /> Tu Coach Dice
                  </h3>
                  <button
                    onClick={() => loadCoaching(true)}
                    disabled={coachingLoading}
                    className="text-xs text-on_surface_variant hover:text-primary transition-colors disabled:opacity-50"
                  >
                    Actualizar
                  </button>
                </div>

                {coachingLoading && !coaching?.text ? (
                  <div className="animate-pulse space-y-2 mt-2">
                    <div className="h-4 bg-primary/10 rounded w-full"></div>
                    <div className="h-4 bg-primary/10 rounded w-5/6"></div>
                    <div className="h-4 bg-primary/10 rounded w-4/6"></div>
                  </div>
                ) : (
                  <p className="text-sm leading-relaxed text-on_surface">
                    {coaching?.text || 'Completa tu onboarding para recibir coaching personalizado.'}
                  </p>
                )}
              </CardContent>
            </Card>
          </section>
        )}

        {/* ============ Couple Section ============ */}
        <section>
          <h2 className="text-sm font-medium uppercase tracking-widest text-on_surface_variant px-1 mb-4">
            Mi Pareja
          </h2>

          {/* Linked Partner */}
          {hasCouple && isLinked && coupleInfo?.partner && (
            <Card className="border border-cuidado/20 overflow-hidden">
              <CardContent className="p-0">
                <div className="p-5 border-b border-outline_variant/30 flex items-center gap-4">
                  <div className="w-14 h-14 rounded-full bg-cuidado flex items-center justify-center text-white text-xl font-bold overflow-hidden relative">
                    {coupleInfo.partner.avatarUrl ? (
                      <Image src={coupleInfo.partner.avatarUrl} alt="Avatar" fill className="object-cover" />
                    ) : (
                      coupleInfo.partner.fullName.charAt(0).toUpperCase()
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <p className="font-semibold text-on_surface text-lg">{coupleInfo.partner.fullName}</p>
                      {coupleInfo.partner.nickname && (
                        <span className="px-2 py-0.5 bg-cuidado/10 text-cuidado text-xs rounded-full">
                          "{coupleInfo.partner.nickname}"
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-2 text-sm text-on_surface_variant">
                      <Link2 className="h-3.5 w-3.5" />
                      <span>{coupleInfo.couple?.durationText} juntos</span>
                    </div>
                  </div>
                  <Heart className="h-6 w-6 text-cuidado/50" />
                </div>

                {/* Nickname Sharing UI */}
                <div className="p-5 bg-surface_container_lowest">
                  {bothConsented ? (
                    <div className="space-y-3">
                      <div className="flex justify-between items-center">
                        <span className="text-xs font-semibold uppercase tracking-wider text-on_surface_variant">
                          Apodo de la pareja
                        </span>
                        {!editingCouple && (
                          <button onClick={() => setEditingCouple(true)} className="p-1 hover:bg-surface_container_low rounded transition-colors text-on_surface_variant">
                            <Pencil className="h-3.5 w-3.5" />
                          </button>
                        )}
                      </div>

                      {editingCouple ? (
                        <div className="flex gap-2">
                          <Input
                            value={editCoupleName}
                            onChange={e => setEditCoupleName(e.target.value)}
                            placeholder="Ej. Los Gómez, Team Caos"
                            className="h-9 text-sm"
                          />
                          <Button size="sm" onClick={handleSaveCoupleNickname} loading={saving}>Guardar</Button>
                          <Button size="sm" variant="ghost" onClick={() => { setEditingCouple(false); setEditCoupleName(coupleInfo.couple?.sharedNickname || ''); }}>X</Button>
                        </div>
                      ) : (
                        <p className="font-medium text-lg text-primary">
                          {coupleInfo.couple?.sharedNickname ? `✨ ${coupleInfo.couple.sharedNickname}` : 'Definan su apodo de pareja'}
                        </p>
                      )}
                    </div>
                  ) : (
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-sm font-medium">Compartir apodos de pareja</p>
                        <p className="text-xs text-on_surface_variant">Permite definir un nombre para nosotros.</p>
                      </div>
                      <Button
                        size="sm"
                        variant={coupleInfo.myConsent ? "outline" : "primary"}
                        onClick={handleToggleConsent}
                        loading={saving}
                      >
                        {coupleInfo.myConsent ? 'Esperando a ' + coupleInfo.partner.fullName : 'Habilitar'}
                      </Button>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Waiting for Partner */}
          {hasCouple && !isLinked && coupleInfo?.couple && (
            <Card className="border-2 border-dashed border-primary/30 bg-primary/5">
              <CardContent className="pt-6 space-y-5">
                <div className="text-center">
                  <div className="w-16 h-16 rounded-full bg-primary_container/20 mx-auto mb-3 flex items-center justify-center">
                    <UserPlus className="h-8 w-8 text-primary" />
                  </div>
                  <h3 className="font-semibold text-on_surface text-lg mb-1">
                    Esperando a tu pareja
                  </h3>
                  <p className="text-sm text-on_surface_variant">
                    Comparte este código para que tu pareja se una
                  </p>
                </div>

                <div className="bg-surface_container_lowest rounded-xl p-5 text-center">
                  <p className="text-xs text-on_surface_variant mb-2 uppercase tracking-wider font-medium">
                    Código de invitación
                  </p>
                  <p className="text-4xl font-mono font-bold tracking-[0.3em] text-primary mb-4">
                    {coupleInfo.couple.inviteCode}
                  </p>
                  <Button variant="outline" size="sm" onClick={() => {
                    navigator.clipboard.writeText(coupleInfo.couple!.inviteCode);
                    setCopied(true); setTimeout(() => setCopied(false), 2000);
                  }}>
                    {copied ? <><Check className="mr-2 h-4 w-4 text-cuidado" /> ¡Copiado!</> : <><Copy className="mr-2 h-4 w-4" /> Copiar código</>}
                  </Button>
                </div>

                <Button
                  variant="ghost"
                  size="sm"
                  className="w-full"
                  onClick={async () => {
                    const text = `¡Únete a Relationship OS conmigo! Usa este código: ${coupleInfo.couple!.inviteCode}`;
                    if (navigator.share) await navigator.share({ text });
                    else { navigator.clipboard.writeText(text); setCopied(true); setTimeout(() => setCopied(false), 2000); }
                  }}
                >
                  <Share2 className="mr-2 h-4 w-4" />
                  Compartir enlace
                </Button>
              </CardContent>
            </Card>
          )}

          {/* No Couple */}
          {!hasCouple && (
            <Card>
              <CardContent className="pt-6 text-center space-y-4">
                <div className="w-16 h-16 rounded-full bg-surface_container_low mx-auto flex items-center justify-center">
                  <Users className="h-8 w-8 text-on_surface_variant" />
                </div>
                <div>
                  <h3 className="font-semibold text-on_surface mb-1">Sin pareja vinculada</h3>
                  <p className="text-sm text-on_surface_variant">
                    Crea o únete a una pareja para desbloquear todas las funciones.
                  </p>
                </div>
                <div className="flex gap-3 justify-center">
                  <Button size="sm" onClick={() => router.push('/couple/create')}>
                    Crear pareja
                  </Button>
                  <Button size="sm" variant="outline" onClick={() => router.push('/couple/join')}>
                    Unirse
                  </Button>
                </div>
              </CardContent>
            </Card>
          )}
        </section>

        {/* ============ Settings Menu ============ */}
        <section>
          <div className="space-y-2">
            <Card className="cursor-pointer hover:shadow-md transition-shadow">
              <CardContent className="flex items-center gap-4 py-4">
                <Bell className="h-5 w-5 text-on_surface_variant" />
                <span className="flex-1">Notificaciones</span>
                <ChevronRight className="h-4 w-4 text-on_surface_variant" />
              </CardContent>
            </Card>

            <Card className="cursor-pointer hover:shadow-md transition-shadow">
              <CardContent className="flex items-center gap-4 py-4">
                <Settings className="h-5 w-5 text-on_surface_variant" />
                <span className="flex-1">Configuración del Sistema</span>
                <ChevronRight className="h-4 w-4 text-on_surface_variant" />
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Sign Out */}
        <Button
          variant="ghost"
          className="w-full text-red-500 hover:text-red-600 hover:bg-red-50"
          onClick={handleSignOut}
        >
          <LogOut className="mr-2 h-5 w-5" />
          Cerrar sesión
        </Button>
      </div>
    </AppShell>
  );
}
