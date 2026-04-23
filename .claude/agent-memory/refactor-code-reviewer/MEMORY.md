# EvalsToGo Project - Code Review Memory

## Project Overview
- Multi-tenant assessment platform (physical therapy focus, expanding to other verticals)
- React + TypeScript + Supabase + Vite frontend
- Files live at project root, NOT in src/ directory (flat structure: `types.ts`, `App.tsx`, `index.tsx`)
- Services in `services/` folder, components in `components/`, admin in `admin/`

## Architecture Patterns
- Supabase client: two instances (anon key in `supabaseService.ts`, service-role in `adminSupabaseClient.ts`)
- Hardcoded Supabase URL: `https://lhgtyojocwqekawnnkco.supabase.co`
- Anon key is hardcoded inline (not from env); service-role key from `VITE_SUPABASE_SERVICE_ROLE_KEY`
- Admin auth: `isAdminAuthenticated()` uses sessionStorage, SHA-256 hash, 24h expiry
- Cache pattern: module-level Map with TTL in `profileService.ts`; module-level variable for webhook URL cache
- Translation pattern: key-value lookup via `t(key)` function returning key itself when missing
- Platform settings: key-value table (`platform_settings`) with anon read RLS policy
- Webhook URL: fetched dynamically via `getWebhookUrl()` from `platform_settings` (was hardcoded before)

## Type Patterns
- Legacy enums (`BodyArea`, `Duration`, `Limitation`, `Goal`) still in use alongside new `Loaded*` types
- New Dynamic Profile System uses `LoadedProfile`, `LoadedStep`, `LoadedOption`, `LoadedCategory`, `LoadedLanguage`
- `DynamicFlowStep` is the runtime representation for flow rendering
- Heavy use of `any` in admin CRUD service parameters (typed loosely for Supabase pass-through)
- Permission type union in `adminService.ts` includes: manage_settings, manage_profiles, manage_config, etc.

## Key Issues Found & Fixed (2026-02-20 Review)
- **SECURITY**: Service-role key exposed to client bundle via `import.meta.env.VITE_*` in `adminSupabaseClient.ts`
- **SECURITY**: Google Translate API key exposed similarly via `VITE_GOOGLE_TRANSLATE_API_KEY`
- **BUG-FIXED**: Slide animation class identical for both directions in `DynamicFlowEngine.tsx` line 273
- **BUG-FIXED**: Stale closure in `handleAnswer` reading stale `answers` state on flow completion -- added answersRef
- **BUG-FIXED**: `DynamicSlider` crash on empty/undefined `config.labels` array in `.reduce()` initial value
- **BUG-FIXED**: Dead code (`getColor`/`percentage`) removed from `DynamicSlider.tsx`
- **BUG-FIXED**: Missing cache invalidation for `updateOption`, `deleteOption`, `reorderOptions`, `updateLanguage`
- **PATTERN**: `adminProfileService.ts` `duplicateProfile()` uses sequential DB inserts (N+1 for categories/steps)

## Key Issues Found & Fixed (2026-02-27 Review)
- **BUG-FIXED**: `getWebhookUrl()` was using `supabaseAdmin` (service-role) but called from end-user App.tsx; changed to anon `supabase` client since platform_settings has public SELECT RLS
- **BUG-FIXED**: Double `loadImportHistory()` call on replace success in AdminProfileEditor.tsx (handleSelectProfile already calls it internally)
- **PATTERN**: `replaceProfile()` stores two history records per replace: old snapshot + new payload
- **PATTERN**: `replaceProfile()` delete ordering is correct for FK constraints: translations -> languages -> options -> steps -> categories

## Key Issues Found (2026-03-03 Review)
- **BUG**: `tests/page-objects/AdminPage.ts` line 3 has local `AdminRole` type that shadows canonical type from `adminService.ts` -- must be updated when roles change
- **PATTERN**: `developer_admin` role added with identical permissions to `super_admin`; indigo badge color; DB constraint already supports it
- **PATTERN**: `fetchAllTableCounts()` now fetches `incomplete_assessments` count (assessments where completed_at IS NULL) for Responses sidebar badge
- **MISSING-TESTS**: No RBAC test coverage for `developer_admin` in `admin-rbac.spec.ts` or `admin-rbac-v2.spec.ts`

## Coding Style Conventions
- Explicit `React.ChangeEvent<HTMLInputElement>` types on all admin form handlers
- `useCallback` used consistently for handlers passed as props
- CSS uses CSS custom properties (`var(--brand-primary)`) for theming
- Tailwind for utility classes, inline `style` for dynamic brand colors
- Translation keys follow `namespace.entity.property` pattern (e.g., `step.pain_slider.question`)
- Animation classes defined in `index.html`: `animate-slideInRight`, `animate-slideOutLeft`, `animate-fadeIn`
- No `animate-slideInLeft` or `animate-slideOutRight` keyframes exist -- only forward/backward variants
- Admin modals pattern: fixed inset-0 z-50 overlay with centered card, X close button, action buttons at bottom
