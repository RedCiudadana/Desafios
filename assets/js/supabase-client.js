import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

const supabaseUrl = window.SUPABASE_CONFIG?.url || '';
const supabaseAnonKey = window.SUPABASE_CONFIG?.anonKey || '';

if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Supabase configuration is missing. Please check that SUPABASE_CONFIG is defined.');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
