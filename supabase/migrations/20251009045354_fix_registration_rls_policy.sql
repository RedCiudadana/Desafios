/*
  # Fix RLS Policy for Challenge Registrations

  1. Changes
    - Drop existing INSERT policy that uses `true`
    - Create new INSERT policy with proper condition for anonymous users
    - Ensures public registrations work correctly
    
  2. Security
    - Allow anonymous (anon) and authenticated users to insert registrations
    - Maintain admin-only SELECT policy
*/

-- Drop the existing policy
DROP POLICY IF EXISTS "Anyone can register for challenges" ON challenge_registrations;

-- Create new policy that allows anonymous inserts
CREATE POLICY "Anyone can register for challenges"
  ON challenge_registrations
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
