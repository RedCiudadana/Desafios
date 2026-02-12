/*
  # Fix Public Access to Challenge Registrations

  1. Security Changes
    - Drop existing potentially conflicting policies
    - Create clean, simple policies for public registration
    - Allow anonymous (anon) users to insert registrations
    - Allow authenticated users to insert registrations
    - Restrict SELECT to admins only for data protection

  2. Important Notes
    - This enables public form submissions without authentication
    - Personal data remains protected (only admins can view)
    - The WITH CHECK clause is explicitly set to true for inserts
*/

-- Drop all existing policies to start fresh
DROP POLICY IF EXISTS "anon_can_insert" ON challenge_registrations;
DROP POLICY IF EXISTS "authenticated_can_insert" ON challenge_registrations;
DROP POLICY IF EXISTS "Admins can view all registrations" ON challenge_registrations;
DROP POLICY IF EXISTS "Enable insert for public" ON challenge_registrations;
DROP POLICY IF EXISTS "Allow public registrations" ON challenge_registrations;

-- Ensure RLS is enabled
ALTER TABLE challenge_registrations ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to insert registrations (for public forms)
CREATE POLICY "Allow anonymous registration inserts"
  ON challenge_registrations
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Allow authenticated users to insert registrations
CREATE POLICY "Allow authenticated registration inserts"
  ON challenge_registrations
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Only admins can view registrations (protect personal data)
CREATE POLICY "Only admins can view registrations"
  ON challenge_registrations
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE users.id = auth.uid()
      AND (users.raw_app_meta_data->>'role') = 'admin'
    )
  );
