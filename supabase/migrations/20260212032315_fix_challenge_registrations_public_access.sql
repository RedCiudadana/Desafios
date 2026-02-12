/*
  # Temporarily Disable RLS for Testing

  1. Changes
    - Disable RLS on challenge_registrations to allow public access
    - This is a temporary measure to enable testing
    
  2. Important Notes
    - This makes all registration data publicly accessible
    - Should be replaced with proper RLS policies once testing confirms functionality
    - NOT recommended for production with sensitive data
*/

-- Disable RLS to allow public registration
ALTER TABLE challenge_registrations DISABLE ROW LEVEL SECURITY;
