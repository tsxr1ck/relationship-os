import { createClient as createSupabaseClient } from '@supabase/supabase-js';

/**
 * Admin Supabase client that bypasses Row Level Security.
 * Use ONLY for cross-user reads that the authenticated user is authorized
 * to see (e.g., checking if a linked partner completed the questionnaire).
 * Never expose this client to the browser.
 */
export function createAdminClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY or NEXT_PUBLIC_SUPABASE_URL');
  }

  return createSupabaseClient(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
