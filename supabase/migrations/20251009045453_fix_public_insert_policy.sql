/*
  # Fix Public Insert Policy for Challenge Registrations

  1. Changes
    - Drop existing restrictive INSERT policy
    - Create explicit policies for anon and authenticated roles
    - Ensure public registrations work correctly
    
  2. Security
    - Allow anyone to insert registrations (public form)
    - Maintain admin-only SELECT policy
*/

-- Drop the existing policy
DROP POLICY IF EXISTS "Enable insert for all users" ON challenge_registrations;

-- Create separate policies for anon and authenticated users
CREATE POLICY "anon_can_insert"
  ON challenge_registrations
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "authenticated_can_insert"
  ON challenge_registrations
  FOR INSERT
  TO authenticated
  WITH CHECK (true);
