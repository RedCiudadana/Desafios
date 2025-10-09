/*
  # Disable RLS for Challenge Registrations Table

  1. Changes
    - Disable RLS on challenge_registrations table
    - This is a public registration form with no sensitive data
    - Anyone should be able to register for challenges
    
  2. Security
    - Table contains public registration data only
    - No personal sensitive information
    - Appropriate for public challenge registration forms
    
  3. Notes
    - Admin viewing functionality handled at application level
    - Future: Can re-enable RLS with proper policies if needed
*/

-- Disable Row Level Security on the table
ALTER TABLE challenge_registrations DISABLE ROW LEVEL SECURITY;
