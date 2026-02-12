/*
  # Fix participant_type field constraint

  1. Changes
    - Make `participant_type` nullable with a default value
    - This field is no longer collected in the registration form but the database still requires it
  
  2. Security
    - No changes to RLS policies
*/

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'participant_type'
  ) THEN
    ALTER TABLE challenge_registrations 
    ALTER COLUMN participant_type DROP NOT NULL,
    ALTER COLUMN participant_type SET DEFAULT 'general';
  END IF;
END $$;