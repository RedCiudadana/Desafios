/*
  # Create Challenge Registrations Table

  ## Summary
  This migration creates a table to store registration data from users who sign up for innovation challenges on the platform.

  ## New Tables
  - `challenge_registrations`
    - `id` (uuid, primary key): Unique identifier for each registration
    - `name` (text): Full name of the participant
    - `email` (text): Email address for contact
    - `phone` (text): Phone number for contact
    - `participant_type` (text): Type of participant (student, professional, OSC, citizen, other)
    - `organization` (text, nullable): Organization or institution name (optional)
    - `location` (text): Municipality/Department location
    - `idea` (text): Brief description of their proposal
    - `experience` (text, nullable): Previous relevant experience (optional)
    - `challenge_name` (text): Name of the challenge they're registering for
    - `created_at` (timestamptz): Timestamp of registration
    - `updated_at` (timestamptz): Timestamp of last update

  ## Security
  - Enable RLS on `challenge_registrations` table
  - Add policy for inserting new registrations (public can register)
  - Add policy for admins to read all registrations

  ## Important Notes
  - This table is designed to capture all registration data from the challenge forms
  - RLS ensures public users can only insert their own registrations
  - Email is stored but not enforced as unique to allow multiple registrations from same person for different challenges
*/

-- Create the challenge_registrations table
CREATE TABLE IF NOT EXISTS challenge_registrations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  participant_type text NOT NULL,
  organization text,
  location text NOT NULL,
  idea text NOT NULL,
  experience text,
  challenge_name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE challenge_registrations ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can insert their registration
CREATE POLICY "Anyone can register for challenges"
  ON challenge_registrations
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Policy: Authenticated users with admin role can view all registrations
CREATE POLICY "Admins can view all registrations"
  ON challenge_registrations
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE auth.users.id = auth.uid()
      AND (auth.users.raw_app_meta_data->>'role' = 'admin')
    )
  );

-- Create index for faster queries by challenge
CREATE INDEX IF NOT EXISTS idx_challenge_registrations_challenge_name 
  ON challenge_registrations(challenge_name);

-- Create index for faster queries by email
CREATE INDEX IF NOT EXISTS idx_challenge_registrations_email 
  ON challenge_registrations(email);

-- Create index for faster queries by created_at
CREATE INDEX IF NOT EXISTS idx_challenge_registrations_created_at 
  ON challenge_registrations(created_at DESC);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_challenge_registrations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_challenge_registrations_updated_at
  BEFORE UPDATE ON challenge_registrations
  FOR EACH ROW
  EXECUTE FUNCTION update_challenge_registrations_updated_at();
