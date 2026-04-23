---
name: project_testing_patterns
description: Playwright E2E conventions and UI patterns confirmed in the is.rehab Link Hub codebase
type: project
---

## Project: is.rehab Link Hub
React 19 + Vite + Supabase admin tool. Dev server on port 5299.

## E2E test file location and naming
- All Playwright tests live in `e2e/`
- Naming convention: `e2e/pkg{N}.spec.ts`
- Config: `playwright.config.ts` at repo root — uses `dotenv` to load `.env`, baseURL is `http://localhost:5299`
- `webServer` in config starts `npm run dev` and reuses existing server if running

## Credentials
- Env vars: `VITE_TEST_ADMIN_EMAIL`, `VITE_TEST_ADMIN_PASSWORD`
- Loaded via `process.env.VITE_TEST_ADMIN_EMAIL!` pattern at top of spec file

## Auth helper pattern
```typescript
async function signIn(page: import('@playwright/test').Page) {
  await page.goto('/login');
  await page.fill('input[type="email"]', ADMIN_EMAIL);
  await page.fill('input[type="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"]');
  await page.waitForURL('**/admin', { timeout: 15000 });
}
```
Each test that requires auth calls `signIn(page)` — no shared auth state files.

## Key UI selectors confirmed
- "Links" button in practice table: `getByRole('link', { name: 'Links' })` (it is an anchor, not a button)
- "Add Link" toggle: `getByRole('button', { name: /Add Link/i })`
- Add form submit: `getByRole('button', { name: 'Create Link' })`
- Add form label input: `input[placeholder="e.g. Book an Appointment"]`
- Add form URL input: `input[placeholder="https://..."]`
- Reorder buttons: `aria-label="Move up"` / `aria-label="Move down"` (ChevronUp/ChevronDown icons)
- "View Public Page": `getByRole('button', { name: /View Public Page/i })` — calls `window.open('/{slug}', '_blank')`
- Breadcrumb "Practices": `getByRole('link', { name: 'Practices' })`
- Links page heading: `h1` with text "Links for {practice.name}"
- Slug column in practice table: `td` nth(1), text format "is.rehab/{slug}"

## Public page structure
- 404 state: `<h1>404</h1>` + `<p>Page not found.</p>`
- Happy path: `<h1>` with practice name (font-display class), footer "Powered by is.rehab"
- No admin sidebar or login form elements on public page

## Route table
- `/login` — LoginPage (public, NOT caught by /:slug)
- `/admin` — DashboardPage (protected)
- `/admin/practices` — PracticesPage (protected)
- `/admin/practices/new` — PracticeEditPage (protected)
- `/admin/practices/:id` — PracticeEditPage (protected)
- `/admin/practices/:practiceId/links` — LinksPage (protected)
- `/:slug` — PublicPracticePage (public)
- `*` — redirects to /admin (ProtectedRoute handles auth)

## LinkDestinationType values
booking, website, assessment_app, social_instagram, social_facebook, social_tiktok, social_youtube, social_linkedin, reviews_google, reviews_yelp, reviews_healthgrades, portal, phone, directions, custom

## Why
Documented after writing pkg1.spec.ts and pkg2.spec.ts for this codebase.

## How to apply
Use these selectors and patterns for all future Playwright tests in this repo. Always read PracticeList.tsx / LinksPage.tsx before writing selectors — the "Links" action is an anchor link, not a button.
