# Shield Security Analyst - Project Memory

## Project: EvalsToGo Assessment Platform
- Supabase-backed SPA (Vite + React + TypeScript)
- Supabase project URL: `https://lhgtyojocwqekawnnkco.supabase.co`
- Anon key hardcoded in `services/supabaseService.ts` (public by design, OK)
- Service-role key via `VITE_SUPABASE_SERVICE_ROLE_KEY` in `services/adminSupabaseClient.ts`

## Full Audit Report: 2026-02-27
- Report written to `SECURITY_AUDIT_REPORT.md` at project root
- **3 CRITICAL, 4 HIGH, 4 MEDIUM, 2 LOW** findings

## Critical Findings (Still Open)
- **CRITICAL: Service-role key in frontend bundle** - `adminSupabaseClient.ts:21` + `vite.config.ts:16`. Full RLS bypass.
- **CRITICAL: Gemini API key in frontend bundle** - `vite.config.ts:14-15`. Billing abuse risk.
- **CRITICAL: admin_users RLS `FOR ALL USING (true)`** - `20260212_admin_users.sql:13`. Any anon user can read/write/delete admin accounts including password hashes.

## High Findings (Still Open)
- SHA-256 unsalted password hashing (`adminService.ts:79-85`)
- Default admin credentials in migration comment (`20260212_admin_users.sql:15-18`)
- Client-side only auth (sessionStorage forgeable) (`adminService.ts:49-67`)
- Password hash sent as Supabase query filter (`adminService.ts:90-95`)

## Architecture Notes
- Admin auth is client-side sessionStorage-based, not Supabase Auth
- RLS policies on profile tables: SELECT-only for anon/authenticated, service_role has GRANT ALL
- `dangerouslySetInnerHTML` is used BUT properly sanitized with DOMPurify
- No source maps in production build (good)
- `.env.local` is gitignored (good)
- Feature B (webhook migration) creates `platform_settings` table for DB-driven config
- RBAC implemented (super_admin/admin/viewer) but enforced client-side only
- Cloudinary unsigned upload preset exposed (low risk, by design)

## Files Reviewed (2026-02-27 Audit)
- `vite.config.ts`, `services/geminiService.ts`, `services/translationService.ts`
- `services/adminSupabaseClient.ts`, `services/adminService.ts`
- `services/supabaseService.ts`, `services/adminProfileService.ts`
- `App.tsx`, `admin/AdminDashboard.tsx`, `admin/AdminConfigForm.tsx`
- `supabase/migrations/20260212_admin_users.sql`
- `supabase/migrations/20260226_admin_user_roles.sql`
- `supabase/migrations/20260227_platform_settings.sql`
- `dist/assets/index-B-9-5O07.js` (production build artifact)
- `.gitignore`, `.env.local`
