'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';

export async function createCouple() {
  const supabase = await createClient();
  
  const { data: { user } } = await supabase.auth.getUser();
  
  if (!user) {
    throw new Error('User not authenticated');
  }
  
  const inviteCode = crypto.randomUUID().replace(/-/g, '').slice(0, 8).toUpperCase();
  const admin = createAdminClient();
  
  const { data: couple, error } = await admin
    .from('couples')
    .insert({
      invite_code: inviteCode,
      status: 'active',
      created_by: user.id,
    })
    .select()
    .single();
  
  if (error) {
    console.log('create couple result', { couple, error });
    throw new Error(error.message);
  }
  
  const { error: memberError } = await admin
    .from('couple_members')
    .insert({
      couple_id: couple.id,
      user_id: user.id,
      role: 'self',
    });
  
  if (memberError) {
    console.log('create member result', { error: memberError });
    throw new Error(memberError.message);
  }
  
  revalidatePath('/dashboard');
  
  return { couple, inviteCode };
}

export async function joinCouple(inviteCode: string) {
  const supabase = await createClient();
  
  const { data: { user } } = await supabase.auth.getUser();
  
  if (!user) {
    throw new Error('User not authenticated');
  }
  const admin = createAdminClient();
  
  const { data: couple, error: coupleError } = await admin
    .from('couples')
    .select('*')
    .eq('invite_code', inviteCode.toUpperCase())
    .single();
  
  if (coupleError || !couple) {
    throw new Error('Código de invitación inválido');
  }
  
  const { error: memberError } = await admin
    .from('couple_members')
    .insert({
      couple_id: couple.id,
      user_id: user.id,
      role: 'partner',
    });
  
  if (memberError) {
    if (memberError.code === '23505') {
      throw new Error('Ya eres parte de esta pareja');
    }
    throw new Error(memberError.message);
  }
  
  revalidatePath('/dashboard');
  
  return { success: true };
}
