# Rhemson QA Automation - Agent Memory

## Project: EvalsToGo

### Architecture
- React + TypeScript + Vite SPA with Supabase backend
- Multi-tenant: URL pattern `/:businessSlug/:variationId`
- Dev server on port 3000 (Vite config)
- Entry point: `index.tsx` with `BrowserRouter`
- Routes: `/admin/*` -> AdminDashboard, `/:businessSlug/:variationId` -> ConfiguredApp, `/` -> ConfiguredApp
- Admin auth: sessionStorage key `evalstogo_admin` with `{ts, username}`, 24h expiry

### App Flow (Hardcoded Fallback - no profile_id)
1. LANGUAGE_SELECT -> 2. LANDING -> 3. ASSESSMENT -> 4. ANALYZING (3s transition) -> 5. RESULTS -> 6. THANK_YOU
- Language selection: English/Spanish buttons
- Landing: disclaimer checkbox required before Start button enabled
- Assessment: SELECT_AREAS -> PRIORITY (if 2 areas) -> [per-area: PAIN slider + 2 deep dives + DURATION] -> LIMITATION -> GOAL
- Contact form on Results page: name, email, phone, email/call checkboxes, marketing opt-in

### App Flow (Dynamic Profile - profile_id present)
- Uses `DynamicFlowEngine` component
- data-testid attributes: `flow-progress-bar`, `flow-back-button`, `multi-select-option-{slug}`, `multi-select-next`, `single-select-option-{slug}`, `slider-input`, `slider-value-display`, `slider-next`

### Admin Dashboard
- Login at `/admin` route
- Login: username + password -> Supabase `admin_users` table
- Session key: `evalstogo_admin_session` with `{ts, username, role, userId}`
- Sidebar tabs (actual labels): Dashboard, Analytics | Responses, Completed Reports, Sessions | Client Directory, Brand Editor | Assessment Templates | Leads, Events, Insights | [Data Tables] | Users, Portal, Billing, Security, Settings
- Routes: `/admin/config` (Brand Editor), `/admin/profiles` (Assessment Templates), `/admin/portal` (Portal Manager), `/admin/events`, `/admin/leads`
- Profiles tab shows `AdminProfileEditor` with sub-tabs: general, categories, steps, translations, clients
- Portal tab requires `manage_users` permission (super_admin or developer_admin roles)

### Portal
- Route: `/portal/*`
- Session key: `etg_portal_session` with `{userId, clientId, username, displayName, role, ts}`
- Tabs: Leads, Reports, Downloads, Insights, Account
- Portal login uses anon-query proxy (not admin-query)
- Downloads page: queries `clients` table for `client_download_config` field

### Test Infrastructure
- Playwright config at project root: `playwright.config.ts`
- testDir: `.` with testMatch: `['tests/**/*.spec.ts', 'e2e/**/*.spec.ts']`
- Tests in `tests/` directory (existing) and `e2e/` directory (ETG-0010+)
- Page objects in `tests/page-objects/`
- Fixtures in `tests/fixtures/`
- Admin session injection: must set sessionStorage BEFORE navigating to permission-gated routes
- Supabase proxy mocking: use `page.route()` on `SUPABASE_URL/functions/v1/anon-query` and `admin-query`
- API proxy architecture: admin-query (auth required, Bearer token), anon-query (no auth)

### Key Selectors
- Body area buttons: role button with area text (e.g., "Neck & Upper Back")
- Pain slider: `input[type="range"]` with min=1, max=10
- Contact form: `input[name="name"]`, `input[type="email"]`, `input[type="tel"]`
- Admin login: `input[placeholder="admin"]`, `input[type="password"]`
- Disclaimer: `input[type="checkbox"]` on landing page
