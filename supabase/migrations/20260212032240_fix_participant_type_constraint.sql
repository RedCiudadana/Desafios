/*
  # Fix participant_type constraint and RLS policies

  1. Changes
    - Remove any check constraints on participant_type that might be blocking inserts
    - Simplify RLS policies for public access
    - Ensure table grants are correct

  2. Security
    - Maintain data protection while allowing public registration
    - Only admins can view submissions
*/

-- First, check if there's a constraint on participant_type and drop it if exists
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'challenge_registrations_participant_type_check'
    AND conrelid = 'challenge_registrations'::regclass
  ) THEN
    ALTER TABLE challenge_registrations 
    DROP CONSTRAINT challenge_registrations_participant_type_check;
  END IF;
END $$;

-- Ensure the table has proper grants
GRANT INSERT ON challenge_registrations TO anon;
GRANT INSERT ON challenge_registrations TO authenticated;
GRANT SELECT ON challenge_registrations TO authenticated;

-- Make sure RLS is enabled
ALTER TABLE challenge_registrations ENABLE ROW LEVEL SECURITY;

-- Drop and recreate policies to ensure they're clean
DROP POLICY IF EXISTS "Allow anonymous registration inserts" ON challenge_registrations;
DROP POLICY IF EXISTS "Allow authenticated registration inserts" ON challenge_registrations;
DROP POLICY IF EXISTS "Only admins can view registrations" ON challenge_registrations;

-- Create simple, permissive INSERT policies
CREATE POLICY "Allow anonymous registration inserts"
  ON challenge_registrations
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Allow authenticated registration inserts"
  ON challenge_registrations
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Admin-only SELECT policy
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
