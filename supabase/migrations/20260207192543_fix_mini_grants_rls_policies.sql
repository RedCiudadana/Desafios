/*
  # Fix mini_grants_applications security policies

  1. Security Changes
    - Remove overly permissive SELECT policy that allowed anyone to read all applications
    - Add restricted SELECT policy: only authenticated admin users can view applications
    - Keep INSERT policy for anonymous submissions (needed for public application form)

  2. Important Notes
    - The previous SELECT policy used USING(true), exposing personal data (emails, phones, names) to anyone
    - The new policy restricts reading to authenticated users with admin role in app_metadata
    - This matches the same pattern used for challenge_registrations
*/

DROP POLICY IF EXISTS "Public can view mini-grants applications" ON mini_grants_applications;

CREATE POLICY "Admins can view mini-grants applications"
  ON mini_grants_applications
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE users.id = auth.uid()
      AND (users.raw_app_meta_data ->> 'role') = 'admin'
    )
  );