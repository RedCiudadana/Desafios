/*
  # Fix challenge_registrations security

  1. Security Changes
    - Re-enable RLS on `challenge_registrations` table (was dangerously disabled)
    - Keep existing INSERT policies for anon and authenticated (needed for public forms)
    - Keep existing admin SELECT policy
    - Ensure personal data (emails, phones) is protected from unauthorized access

  2. Important Notes
    - RLS was disabled in a previous migration, exposing all registration data publicly
    - This migration re-enables it so the existing policies take effect again
    - Only authenticated admin users will be able to view registrations
    - Anonymous and authenticated users can still submit registrations
*/

ALTER TABLE challenge_registrations ENABLE ROW LEVEL SECURITY;