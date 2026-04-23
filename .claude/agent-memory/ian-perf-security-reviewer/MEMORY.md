# Ian - Performance & Security Reviewer Memory

## Project: EvalsToGo Dynamic Profile System

### Architecture
- Vite + React SPA with Supabase backend
- Client-facing assessment flow served via subdomain/slug routing
- Admin dashboard at /admin with profile CRUD editor
- Dynamic profile system: profiles, categories, steps, options, languages, translations
- In-memory cache in `services/profileService.ts` with 5-min TTL (bounded to 50 entries after review fix)

### Key Files
- `services/profileService.ts` - Client-facing caching layer, parallel Supabase queries
- `services/flowEngine.ts` - Flow generation from profile data, flag resolution
- `components/DynamicFlowEngine.tsx` - React assessment flow UI
- `components/ConfiguredApp.tsx` - Profile loading orchestration on mount
- `admin/AdminProfileEditor.tsx` - 2007-line admin CRUD editor (monolith, not lazy loaded)
- `services/adminProfileService.ts` - Admin DB operations with batch patterns
- `services/googleTranslateService.ts` - Google Translate API integration
- `services/adminSupabaseClient.ts` - Service-role key client (CRITICAL: bundled client-side)
- `services/adminService.ts` - Client-side-only admin auth (SHA-256, sessionStorage)

### CRITICAL Security Findings (2026-02-25)
1. **Service-role key in client bundle** - `VITE_SUPABASE_SERVICE_ROLE_KEY` loaded via `import.meta.env` in adminSupabaseClient.ts. Bypasses ALL RLS. Must move admin ops server-side.
2. **Gemini + Google Translate API keys in client bundle** - via vite.config.ts define block. Financial abuse risk.
3. **Stored XSS** - 4x `dangerouslySetInnerHTML` in App.tsx (lines 470, 1322, 1326, 1334) with NO DOMPurify. Translation values from DB rendered as raw HTML.
4. **Admin auth is client-side only** - sessionStorage check, trivially bypassable. Combined with #1, any user = admin.
5. **SHA-256 password hashing** - No salt, no work factor, GPU-crackable in seconds.

### RLS Concerns
- `assessment_category_responses` table: INSERT WITH CHECK(true) + SELECT USING(true) = fully open
- Service-role key exposure makes ALL RLS moot until fixed

### Performance Findings (2026-02-20)
1. Cache was unbounded - FIXED: added MAX_CACHE_ENTRIES=50 with eviction
2. ConfiguredApp had sequential waterfall - FIXED: parallelized profile+languages
3. countFlags iterated array 4x - FIXED: single-pass loop
4. AdminProfileEditor (2007 lines) is statically imported, not lazy loaded
5. duplicateProfile in adminProfileService inserts categories one-by-one (N+1 pattern)
6. reorderCategories/reorderSteps/reorderOptions fire N individual UPDATE queries
7. No code splitting configured in vite.config.ts

### Performance Findings (2026-02-25)
8. importProfile: N+1 sequential inserts for categories and steps (needs returned IDs for mapping)
9. importProfile: No transaction wrapping - partial failures leave orphaned data
10. validateImportPayload: No array size limits, no string length limits, no slug format regex
11. saveCategoryResponses: GOOD - single batch insert

### DB Query Pattern
- `loadFullProfile()` fires 3 parallel Supabase queries (good)
- Steps query uses nested select `select('*, profile_step_options(*)')` (good)
- Admin `fetchProfileWithDetails()` fires 4 parallel queries (good)
- Translation queries select only needed columns (good)
- `saveCategoryResponses` uses single batch insert (good)

### Webhook
- Hardcoded ActivePieces URL in App.tsx line 19 (exposed in client bundle)
- Payload contains PII (name, email, phone) + health data - intentional for email automation
- No API keys leak in the payload itself
