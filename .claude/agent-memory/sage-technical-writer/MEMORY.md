# Sage Technical Writer - Agent Memory

## Project: EvalsToGo

### Stack
- React + TypeScript SPA (Vite)
- Supabase (PostgreSQL with RLS)
- Tailwind CSS with CSS custom properties for brand colors

### Key Architecture Patterns
- **Dynamic Profile System:** 6 profile tables replace hardcoded content. See `docs/DYNAMIC_PROFILE_SYSTEM.md`.
- **Two Supabase clients:** anon key for public reads (`services/supabaseService.ts`), service-role key for admin writes (`services/adminSupabaseClient.ts`).
- **Translation fallback chain:** client custom_translations > profile_translations[lang] > raw key.
- **Flow engine is pure functions:** `services/flowEngine.ts` has no DB calls; operates on in-memory `LoadedProfile`.
- **Backward compatibility:** `buildHardcodedProfile()` for clients without `profile_id`.

### File Locations
- Types: `types.ts` (root)
- Migrations: `supabase/migrations/`
- Services: `services/` (profileService, flowEngine, adminProfileService, adminSupabaseClient, googleTranslateService, adminService)
- Components: `components/` (DynamicFlowEngine, DynamicMultiSelect, DynamicSlider, DynamicSingleSelect, ConfiguredApp)
- Admin UI: `admin/` (AdminProfileEditor, AdminDashboard, AdminLayout)
- Documentation: `docs/` (DYNAMIC_PROFILE_SYSTEM.md)

### Naming Conventions
- Database: snake_case (profile_categories, step_slug)
- TypeScript interfaces: PascalCase (LoadedProfile, DynamicFlowStep)
- Translation keys: dotted namespace (step.pain_slider.question, option.category_select.neck-upper-back.label)
- Category/option identifiers: kebab-case slugs (neck-upper-back, low-back-hips)
- Legacy enums: SCREAMING_SNAKE (NECK_UPPER_BACK) -- deprecated

### Documentation Standards
- Mermaid diagrams for architecture and data flow
- Tables for structured data (columns, parameters, functions)
- Code snippets with realistic data from the PT profile seed
- Active voice throughout
