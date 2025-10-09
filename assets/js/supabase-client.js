import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

// Get config from window object (set by base template)
const supabaseUrl = window.SUPABASE_CONFIG?.url;
const supabaseAnonKey = window.SUPABASE_CONFIG?.anonKey;

if (!supabaseUrl || !supabaseAnonKey) {
    console.error('Supabase configuration is missing');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
