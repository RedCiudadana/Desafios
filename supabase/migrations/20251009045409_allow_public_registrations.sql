/*
  # Allow Public Challenge Registrations

  1. Changes
    - Drop existing INSERT policy
    - Create new permissive policy for INSERT operations
    - Allow both anonymous and authenticated users to register
    
  2. Security
    - Public can insert their own registrations
    - Admins can view all registrations (existing policy)
*/

-- Drop the existing policy
DROP POLICY IF EXISTS "Anyone can register for challenges" ON challenge_registrations;

-- Create a more permissive INSERT policy
CREATE POLICY "Enable insert for all users"
  ON challenge_registrations
  FOR INSERT
  WITH CHECK (true);
