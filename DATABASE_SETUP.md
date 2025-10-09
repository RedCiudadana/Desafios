# Database Setup - Challenge Registrations

This document explains how the registration system works and how to access the data.

## Overview

The platform now stores all challenge registrations in a Supabase database. When users fill out the "Inscríbete al Desafío" form on any challenge page, their information is automatically saved to the database.

## Database Table Structure

**Table Name:** `challenge_registrations`

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Unique identifier (auto-generated) |
| name | TEXT | Participant's full name |
| email | TEXT | Contact email |
| phone | TEXT | Contact phone number |
| participant_type | TEXT | Type: estudiante, profesional, osc, ciudadano, otro |
| organization | TEXT | Organization/institution (optional) |
| location | TEXT | Municipality/Department |
| idea | TEXT | Brief description of their proposal |
| experience | TEXT | Previous relevant experience (optional) |
| challenge_name | TEXT | Name of the challenge they registered for |
| created_at | TIMESTAMP | Registration date/time |
| updated_at | TIMESTAMP | Last update date/time |

## Accessing Registration Data

### Option 1: Admin Dashboard (Recommended)

Visit `/admin/registrations/` to access the admin panel. This page provides:

- **Statistics Dashboard**: Total registrations, active challenges, daily and weekly counts
- **Filterable Table**: Filter by challenge, participant type, or search by name/email
- **Real-time Data**: Automatically loads all registrations from the database

**URL**: `https://your-domain.com/admin/registrations/`

### Option 2: Direct Database Query

You can query the database directly using the Supabase dashboard or SQL:

```sql
-- Get all registrations
SELECT * FROM challenge_registrations ORDER BY created_at DESC;

-- Get registrations for a specific challenge
SELECT * FROM challenge_registrations
WHERE challenge_name = 'Desafío 1: Contrataciones Abiertas'
ORDER BY created_at DESC;

-- Count registrations by challenge
SELECT challenge_name, COUNT(*) as total
FROM challenge_registrations
GROUP BY challenge_name;

-- Get recent registrations (last 7 days)
SELECT * FROM challenge_registrations
WHERE created_at >= NOW() - INTERVAL '7 days'
ORDER BY created_at DESC;
```

### Option 3: Export Data

To export registration data:

1. Access the Supabase dashboard
2. Navigate to the Table Editor
3. Select the `challenge_registrations` table
4. Click "Export" to download as CSV or JSON

## Security

The database is protected with Row Level Security (RLS):

- **Public users** can only INSERT their own registrations (cannot read or modify)
- **Admin users** with the appropriate role can read all registrations
- All data is encrypted in transit and at rest

## Environment Variables

The database connection uses these environment variables (already configured):

```
VITE_SUPABASE_URL=https://qxxxdiqextseywfnmixr.supabase.co
VITE_SUPABASE_ANON_KEY=[anon key]
```

## Form Submission Flow

1. User fills out the registration form on a challenge page
2. JavaScript validates the form data
3. Data is sent to Supabase via the client library
4. Supabase stores the data in `challenge_registrations` table
5. User sees success message
6. Admin can view the registration in the admin panel

## Troubleshooting

### Registration form not working?

1. Check browser console for JavaScript errors
2. Verify Supabase connection in browser DevTools
3. Ensure environment variables are properly set
4. Check that the table exists in Supabase

### Can't see registrations in admin panel?

1. Verify you're accessing `/admin/registrations/` URL
2. Check browser console for API errors
3. Ensure RLS policies are correctly configured
4. Verify the user has admin permissions if RLS is enforced for reads

## Technical Implementation

The registration system consists of:

1. **Database Migration**: `create_challenge_registrations_table` - Creates the table and RLS policies
2. **Supabase Client**: `/assets/js/supabase-client.js` - Initializes the Supabase connection
3. **Form Handler**: Inline JavaScript in `desafio.njk` layout - Handles form submission
4. **Admin Panel**: `/src/admin-registrations.njk` - Displays and filters registrations

## Future Enhancements

Potential improvements for the registration system:

- Email notifications to admins when new registrations are received
- Export functionality directly from admin panel
- Registration confirmation emails to participants
- Advanced analytics and reporting
- Bulk actions (approve, reject, contact participants)
