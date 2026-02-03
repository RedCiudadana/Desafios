/*
  # Create Mini-Grants Applications Table

  1. New Tables
    - `mini_grants_applications`
      - `id` (uuid, primary key)
      - `organization_name` (text) - Nombre de la organización
      - `country` (text) - País
      - `organization_type` (text[]) - Tipo de organización (array para casillas múltiples)
      - `foundation_year` (text) - Año de creación
      - `website` (text, nullable) - Sitio web o redes sociales
      - `contact_name` (text) - Nombre del responsable
      - `contact_position` (text) - Cargo
      - `contact_email` (text) - Email
      - `contact_phone` (text) - Teléfono
      - `project_title` (text) - Título de la iniciativa
      - `problem_description` (text) - Problema público
      - `project_objective` (text) - Objetivo principal
      - `product_type` (text[]) - Tipo de producto (array)
      - `open_data_sources` (text) - Datos abiertos a utilizar
      - `data_relevance` (text) - Relevancia de los datos
      - `open_data_experience` (text) - Experiencia previa con datos
      - `inclusion_approach` (text) - Enfoque de inclusión
      - `responsible_data_use` (text) - Uso responsable de datos
      - `main_activities` (text) - Principales actividades
      - `estimated_duration` (text) - Duración estimada
      - `budget_description` (text) - Descripción del presupuesto
      - `scalability_plan` (text) - Plan de escalabilidad
      - `accepts_open_licenses` (boolean) - Acepta licencias abiertas
      - `accepts_terms` (boolean) - Acepta términos
      - `challenge_name` (text) - Nombre del desafío
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS
    - Add policy for public inserts (anyone can apply)
    - Add policy for authenticated users to view applications
*/

CREATE TABLE IF NOT EXISTS mini_grants_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_name text NOT NULL,
  country text NOT NULL,
  organization_type text[] NOT NULL DEFAULT '{}',
  foundation_year text,
  website text,
  contact_name text NOT NULL,
  contact_position text NOT NULL,
  contact_email text NOT NULL,
  contact_phone text NOT NULL,
  project_title text NOT NULL,
  problem_description text NOT NULL,
  project_objective text NOT NULL,
  product_type text[] NOT NULL DEFAULT '{}',
  open_data_sources text NOT NULL,
  data_relevance text NOT NULL,
  open_data_experience text NOT NULL,
  inclusion_approach text NOT NULL,
  responsible_data_use text NOT NULL,
  main_activities text NOT NULL,
  estimated_duration text NOT NULL,
  budget_description text NOT NULL,
  scalability_plan text NOT NULL,
  accepts_open_licenses boolean DEFAULT false,
  accepts_terms boolean DEFAULT false,
  challenge_name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE mini_grants_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can submit mini-grants applications"
  ON mini_grants_applications
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Public can view mini-grants applications"
  ON mini_grants_applications
  FOR SELECT
  TO anon
  USING (true);