# Aria — Adaptive Memory Agent

**Role:** Unified memory authority for the Postwork workspace
**Last sync:** 2026-04-08 (initial seed — full /memory-sync not yet run)

---

## Global Preferences

### [PREFERENCE] — Response conciseness
**Scope:** global
**Confidence:** medium
**Source:** observation
**Date:** 2026-04-08

No verbose preamble. Get straight to the point. Short answers unless explanation is requested.

### [PREFERENCE] — Model preference
**Scope:** global
**Confidence:** high
**Source:** settings.json
**Date:** 2026-04-08

User's configured model: `sonnet` (set in C:\Users\Merriam\.claude\settings.json)

### [PREFERENCE] — Commit style
**Scope:** global
**Confidence:** medium
**Source:** agent instructions
**Date:** 2026-04-08

Conventional Commits format preferred. Never use --no-verify, --no-gpg-sign, or skip hooks unless explicitly asked.

### [PREFERENCE] — No trailing summaries
**Scope:** global
**Confidence:** medium
**Source:** observation
**Date:** 2026-04-08

Do not summarize what you just did at the end of responses. User can read the diff/output.

---

## Project Knowledge: Postwork Workspace

### [CONVENTION] — Agent roster (28 agents)
**Scope:** project
**Confidence:** high
**Source:** directory listing
**Date:** 2026-04-08

Orchestration: dendi-orchestrator (opus)
Backend: joey-backend-architect (opus), joey-fullstack-backend, dan-backend-engineer
Frontend: coach-frontend-engineer, yam-fullstack-frontend, jah-performance-animations, vincent-design-systems
QA: cypress-qa-engineer, rhemson-qa-automation
Security/Perf: shield-security-analyst, ian-perf-security-reviewer
Specialist: sage-technical-writer, realtime-systems-architect, data-engineer, ryzen-seo-engineer, hyacinth-marketing-strategist, shuakipie-microservices
Review: refactor-code-reviewer, integration-consistency-reviewer, agentspec-compliance-auditor
Infra: deployment-readiness-checker, schema-constraint-validator, typescript-pydantic-sync-checker, agentspec-parser, test-spec-coverage-mapper
Memory: aria-adaptive-memory (this agent, sonnet, global memory)

### [CONVENTION] — Sub-projects in this workspace
**Scope:** project
**Confidence:** high
**Source:** directory listing
**Date:** 2026-04-08

Active projects: PrecisionPDR, VitalVibe-Telehealth, FurstClassMobileGrooming, ApexAutoElectric, HeritageMasonry, StarfruitExpress-Challenge

### [ARCHITECTURE] — Koopprijs backend (absorbed from dan-backend-engineer memory)
**Scope:** sub-project:koopprijs
**Confidence:** high
**Source:** agent memory (dan-backend-engineer)
**Date:** 2026-04-08

Stack: MongoDB + Express.js in `realwork-backend-master/`
Date field pattern: ALWAYS use `$or` across `financieel.overdracht.datum`, `.transactie_datum`, `.transportdatum`
Price field: primary `financieel.overdracht.transactieprijs`, fallback `.koopprijs`
MongoDB dates come in multiple formats — use `$switch` with type check and `$dateFromString`
Logging: `utils/logger.js` (file-based, daily rotation, 30-day cleanup)

### [CONVENTION] — EvalsToGo frontend patterns (absorbed from coach-frontend-engineer memory)
**Scope:** sub-project:evalstogo
**Confidence:** high
**Source:** agent memory (coach-frontend-engineer)
**Date:** 2026-04-08

Brand CSS variables: `var(--brand-primary)`, `var(--brand-primary-hover)`, `var(--brand-light)`, `var(--brand-dark)`, `var(--brand-contrast)`
Styling: Tailwind for layout/spacing + `style={}` for brand color variables (not hardcoded hex)
Border radius: cards `rounded-xl`, containers `rounded-2xl`, smaller elements `rounded-lg`
Interactive cards: `border-2` with `hover-brand-border` class
Transitions: `transition-all duration-150/200`, `hover:scale-[1.02] active:scale-[0.98]`
Input types: `multi_select`, `slider`, `single_select`
i18n: `t(key, replacements?)` with keys like `step.{slug}.question`

---

## Agent Memory Index (for /memory-sync)

14 agents currently have MEMORY.md files:
- coach-frontend-engineer
- cypress-qa-engineer
- dan-backend-engineer
- data-engineer
- hyacinth-marketing-strategist
- ian-perf-security-reviewer
- joey-backend-architect
- joey-fullstack-backend
- refactor-code-reviewer
- rhemson-qa-automation
- sage-technical-writer
- shield-security-analyst
- vincent-design-systems
- yam-fullstack-frontend

All located at: `C:\D-drive-94828\Postwork\.claude\agent-memory\{agent-name}\MEMORY.md`

---

## Synthesized from Agent Memories

*(Empty — run /memory-sync to populate this section)*

---

## Known Anti-Patterns

### [ANTI-PATTERN] — Never skip git hooks
**Scope:** global
**Confidence:** high
**Source:** behavioral instruction
**Date:** 2026-04-08

Never use `--no-verify`, `--no-gpg-sign`, or `-c commit.gpgsign=false` unless user explicitly asks.

### [ANTI-PATTERN] — Never create commits without being asked
**Scope:** global
**Confidence:** high
**Source:** behavioral instruction
**Date:** 2026-04-08

Only create commits when the user explicitly requests it. Do not proactively commit.

### [ANTI-PATTERN] — Do not add unrequested features
**Scope:** global
**Confidence:** high
**Source:** behavioral instruction
**Date:** 2026-04-08

No speculative abstractions, no extra configurability, no "improvements" beyond what was asked.

---

## Make.com Blueprint Rules

### [ANTI-PATTERN] — Never trust sample JSON for Make.com module identifiers
**Scope:** project
**Confidence:** high
**Source:** correction
**Date:** 2026-04-20

Before writing any Make.com scenario blueprint JSON, verify every `module` identifier string (e.g. `google-sheets:xxx`, `slack:xxx`, `builtin:xxx`) against a real exported Make.com blueprint or a verified Make community forum post. Never treat sample/template JSON supplied in a user prompt as authoritative for module IDs or `version` fields.

**Why:** On 2026-04-20, a combined Field Ops blueprint (Current_Calm_Battery_Field_Ops_Combined_Blueprint.json) failed import with "Module Not Found" on 7 of 9 modules. The wrong strings — `google-sheets:watchRows`, `slack:createMessage`, `builtin:BasicIgnore` — were copied from user-provided sample JSON without cross-checking. Only `http:ActionSendData` and `builtin:BasicRouter` survived.

**How to apply:**
1. Use WebSearch to find the exact `module` string from Make community forum posts or GitHub-hosted real exports before writing any blueprint.
2. Confirm the `version` field — Make's module registry is version-sensitive.
3. If the user supplied sample JSON, treat all module IDs in it as SUSPECT and cross-check every one.
4. When uncertain, test with a single-module blueprint first before building a full scenario.

**Anti-pattern:** Copying `module` strings from user-provided sample/template JSON without independent verification.

---

### [REFERENCE] — Make.com verified module IDs (Current_Calm_Battery project)
**Scope:** project
**Confidence:** high
**Source:** multi-source research (4 independent blueprints + Make docs + community thread)
**Date:** 2026-04-20

Verified correct module strings for this project's scenario blueprint:

| Purpose | `module` string | `version` |
|---|---|---|
| Google Sheets — Watch New Rows trigger | `google-sheets:watchRows` | 2 |
| Slack — Create a Message action | `slack:CreateMessage` | 4 |
| Builtin — Ignore error directive | `builtin:Ignore` | 1 |
| Builtin — Router | `builtin:BasicRouter` | 1 |
| HTTP — Make a Request | `http:ActionSendData` | 3 |

Previously broken IDs and their fixes:
- `slack:createMessage` (lowercase c) — WRONG. Correct: `slack:CreateMessage` (capital C)
- `builtin:BasicIgnore` — WRONG. Correct: `builtin:Ignore` (no "Basic" prefix)
- `google-sheets:watchRows` version 4 — WRONG version. Correct: version 2

Evidence sources:
- github.com/okash1n/make-blueprints/blob/main/blueprint.json — `slack:CreateMessage` v4
- gist.github.com/helLf1nGer/ac8c7351411c65e660f700b575629947 — `google-sheets` v2, `builtin:BasicRouter` v1
- gist.github.com/heytxz/ef223634d9177bf43f6cd2bcda4448bc — `http:ActionSendData` v3, `builtin:BasicRouter` v1
- help.make.com/ignore-error-handler — directive naming (`Ignore`, not `BasicIgnore`)
- community.make.com/t/mapping-issue-between-google-sheets-watchrows-and-builtin-basicfeeder/65576 — `watchRows` casing

Make.com naming-convention pattern (use when guessing unknown IDs):
- Action modules (do something): PascalCase verb — `slack:CreateMessage`, `http:ActionSendData`, `google-sheets:AddRow`
- Trigger/watcher modules: camelCase verb — `google-sheets:watchRows`, `slack:searchMessages`
- Builtin flow-control modules: `Basic` prefix — `builtin:BasicRouter`, `builtin:BasicAggregator`, `builtin:BasicFeeder`
- Builtin error directives: NO `Basic` prefix, PascalCase — `builtin:Ignore`, `builtin:Break`, `builtin:Commit`, `builtin:Resume`, `builtin:Rollback`

**Anti-pattern:** The `Basic` prefix / no-prefix split between flow-control and error-directives is easy to miss. `builtin:BasicIgnore` does not exist.

---

### [CONVENTION] — Make.com blueprint import is zero-tolerance
**Scope:** project
**Confidence:** high
**Source:** observation
**Date:** 2026-04-20

The user imports Make.com blueprints by pasting/uploading JSON into the scenario editor. A wrong `module` ID produces a grey "Module Not Found" circle with a red exclamation mark — highly visible, no partial credit. There is no degraded-mode fallback. Every module ID in a delivered blueprint must be correct before handing off.

---

## Memory Management Notes

- This file is loaded into Aria's system prompt on every session (lines after 300 truncated)
- For detailed notes, create topic files: `project-stacks.md`, `corrections-log.md`, `style-patterns.md`
- Link topic files from here rather than expanding inline
- Run `/memory-sync` periodically (suggested: after each major feature or sprint)
- Mark entries older than 90 days as `[VERIFY]` on next access
