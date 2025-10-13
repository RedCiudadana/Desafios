/*
  # Add New Fields to Challenge Registrations

  1. Changes to `challenge_registrations` Table
    - Add `sector` (text) - Sector/occupation of participant
    - Add `position` (text) - Position/role in organization
    - Add `age_range` (text) - Age range selection
    - Add `gender` (text) - Gender selection
    - Add `ethnicity` (text) - Ethnic identification
    - Add `has_disability` (boolean) - Whether participant has a disability
    - Rename `location` to `municipality` for clarity
    - Keep existing fields: name, email, phone, participant_type, organization, idea, experience, challenge_name

  2. Notes
    - All new fields are optional (nullable) except age_range, gender, and ethnicity which we'll make required
    - Boolean field `has_disability` defaults to false
    - Location field renamed to municipality to match the requirements
*/

-- Add new fields to challenge_registrations table
DO $$
BEGIN
  -- Add sector field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'sector'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN sector text;
  END IF;

  -- Add position field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'position'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN position text;
  END IF;

  -- Add age_range field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'age_range'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN age_range text NOT NULL DEFAULT '';
  END IF;

  -- Add gender field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'gender'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN gender text NOT NULL DEFAULT '';
  END IF;

  -- Add ethnicity field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'ethnicity'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN ethnicity text NOT NULL DEFAULT '';
  END IF;

  -- Add has_disability field if not exists
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'has_disability'
  ) THEN
    ALTER TABLE challenge_registrations ADD COLUMN has_disability boolean DEFAULT false;
  END IF;

  -- Rename location to municipality if location exists
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'location'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'challenge_registrations' AND column_name = 'municipality'
  ) THEN
    ALTER TABLE challenge_registrations RENAME COLUMN location TO municipality;
  END IF;
END $$;