# EvalsToGo Data Engineer Memory

## Database Engine
- **Supabase** (hosted PostgreSQL) at `https://lhgtyojocwqekawnnkco.supabase.co`
- No ORM -- raw SQL via Supabase client (PostgREST API)

## Schema File Locations
- Master schema: `schema.sql` (root) -- idempotent, safe to re-run
- Migrations: `supabase/migrations/` (date-prefixed, e.g., `20260220_profile_tables.sql`)

## Schema Conventions
- **PK**: `id UUID PRIMARY KEY DEFAULT gen_random_uuid()` (newer tables). Older tables use `uuid_generate_v4()` but new work should use `gen_random_uuid()`.
- **Timestamps**: `TIMESTAMPTZ DEFAULT NOW()` for `created_at` / `updated_at`
- **Foreign keys**: Always `ON DELETE CASCADE`
- **Idempotent DDL**: `CREATE TABLE IF NOT EXISTS`, `ADD COLUMN IF NOT EXISTS`, `DROP POLICY IF EXISTS` before `CREATE POLICY`
- **Constraint safety**: Wrap `ADD CONSTRAINT` in `DO $$ BEGIN ... EXCEPTION WHEN duplicate_object THEN NULL; END $$;`
- **Schema cache**: End migrations with `NOTIFY pgrst, 'reload schema';`
- **Table numbering**: Tables are numbered sequentially in `schema.sql` comments (currently 1-21)

## RLS Pattern
- All tables have RLS enabled
- Existing operational tables: anon gets `FOR ALL USING (true)` + `FOR INSERT WITH CHECK (true)` (open access)
- Profile/config tables (added 2026-02-20): anon gets `SELECT` only. Service role bypasses RLS.
- Grant pattern: `GRANT SELECT ON TABLE public.X TO anon, authenticated; GRANT ALL ON TABLE public.X TO service_role;`

## Current Table Count: 27 (after 20260301 migration)
clients, sessions, assessments, assessment_area_details, contacts,
analytics_events, disclaimer_consents, goal_connections, report_generations,
screen_views, question_responses, admin_users, completed_reports,
evaluations, variations, assessment_profiles, profile_categories,
profile_steps, profile_step_options, profile_translations, profile_languages,
persons, person_emails, person_phones, events, lead_assignments,
lead_lifecycle, client_portal_users
-- View: current_lead_status (on lead_lifecycle)

## Key Relationships
- `clients.profile_id` -> `assessment_profiles.id` (nullable FK, no cascade)
- `clients.client_id` (TEXT) is the main business key, used as FK target by `variations`, `sessions`, etc.
- `clients.slug` + `variation_number` for multi-tenant routing
- `variations.client_id` -> `clients.client_id` ON DELETE CASCADE
- Profile tables form a hierarchy: `assessment_profiles` -> `profile_categories` / `profile_steps` -> `profile_step_options`
- `person_emails.person_id` / `person_phones.person_id` -> `persons.id` ON DELETE CASCADE
- `contacts.person_id` -> `persons.id` (nullable, backfill needed for existing rows)
- `events.profile_id` -> `assessment_profiles.id` (nullable)
- `lead_assignments.person_id` -> `persons.id` ON DELETE CASCADE; `.contact_id` -> `contacts.id`
- `lead_lifecycle.person_id` -> `persons.id` ON DELETE CASCADE; `.assignment_id` -> `lead_assignments.id`
- `client_portal_users.client_id` -> `clients.client_id` ON DELETE CASCADE

## Triggers
- `update_updated_at_column()` function exists -- reuse for any table with `updated_at`
- Applied on: `clients`, `assessment_profiles`, `profile_translations`, `persons`, `events`, `client_portal_users`

## Indexes
- Composite indexes on (parent_id, display_order) for ordered child tables
- Composite index on (profile_id, language_code, translation_key) for translation lookups
- Single-column indexes on commonly filtered columns (client_id, session_id, event_type, etc.)

## Seed Data
- `supabase/migrations/20260220_seed_pt_profile.sql` seeds the Physical Therapy profile
- Profile slug: `physical-therapy` (is_system_default=true)
- 5 categories: neck-upper-back, low-back-hips, shoulder-arm, knee-leg-foot, other
- 16 steps: 4 global + 2 shared per-category + 10 category-specific questions
- 52 step options total
- 2 languages: en, es (346 translation rows total, 173 per language)
- Idempotent: uses ON CONFLICT DO NOTHING on all inserts
- Uses DO $$ block with UUID variables for FK references
- Auto-assigns profile to clients with NULL profile_id
- `goalConnection.learn.high` key added for structural consistency (mirrors `learn.some` text)
