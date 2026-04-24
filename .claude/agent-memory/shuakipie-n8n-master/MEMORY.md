# Shuakipie — Memory

> Loaded at session start. Updated at session end. Keep under 300 lines — overflow to topic files.

## Workspace Conventions

### [CONVENTION] — Platform in active use here is Make.com
**Platform:** make.com
**Scope:** workspace
**Confidence:** high
**Source:** observation
**Date:** 2026-04-21

The user has active Make.com scenarios (ApexRacquetClub AI-Performance-Summaries, Current & Calm Battery Slack Field Updates, Guest Roaster Quality Waste Sync, Thorne Immigration Urgent Case Intake). Default to Make.com unless the user explicitly says *n8n*, *workflow JSON*, *$json*, or *typeVersion*.

### [ANTI-PATTERN] — User mixes n8n terms into Make.com requests
**Platform:** both
**Scope:** workspace
**Confidence:** high
**Source:** aria-memory / correction log
**Date:** 2026-04-21

The user sometimes types n8n terms (`typeVersion`, `2.10.2`, `$json`) when asking about Make.com flows. Do **not** build n8n JSON when they mean Make.com. Clarify once, then build the correct platform. See `feedback_make_vs_n8n_terminology.md` in the auto-memory.

---

## Active Sub-Projects

### ApexRacquetClub — AI-Performance-Summaries
**Platform:** make.com
Polishes post-lesson coach feedback into parent-ready emails with AI. Scenario folder: `ApexRacquetClub-AI-Performance-Summaries/`.

### Current & Calm Battery — Slack Field Updates
**Platform:** make.com
Two flows: (1) Google Sheets field inspection → Slack alerts, (2) scheduled OpenWeatherMap safety advisory → Slack. Scenario folder: `Current_Calm_Battery_Slack_Field_Updates/`.

### Guest Roaster — Quality Waste Sync
**Platform:** make.com
Folder: `Guest_Roaster_Quality_Waste_Sync/` — inspect before modifying.

### Thorne Immigration — Urgent Case Intake
**Platform:** make.com
Folder: `Thorne-Immigration-Urgent-Case-Intake/` — inspect before modifying.

---

## n8n Facts I've Confirmed

### [workflow-shape] — HighNote Logistics Cargo Dispatch (2026-04-21)
**Platform:** n8n
**Scope:** project:HighNoteLogistics-CargoDispatch
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

12-node workflow. Entry: Webhook (v2) → Set/normalize (v3.4) → Switch fragility router (v3.2) → IF env check (v2.2) → dual Set branches (warning/safe) → Slack Block Kit (v2.3) → Gmail HTML (v2.1) → Google Sheets append (v4.5). Error workflow: errorTrigger (v1) → Gmail fallback to ops@. White Glove branch fires Specialist Slack alert in parallel from Switch output 1 before rejoining the IF node. Credential placeholders: REPLACE_ME_SLACK, REPLACE_ME_GMAIL, REPLACE_ME_GSHEETS, REPLACE_ME_SPREADSHEET_ID.

### [node-config] — Switch v3.2 rules-mode shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

Switch v3.2 with `mode: "rules"` uses `rules.rules[]` array. Each rule has a nested `conditions` object (same shape as IF v2.2: `options`, `conditions[]`, `combinator`) plus `renameOutput: true` and `outputKey`. Options `fallbackOutput: "none"` silently drops unmatched items.

### [node-config] — IF v2.2 OR combinator with four numeric conditions confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

IF v2.2 `combinator: "or"` with four conditions (humidity < 40, humidity > 60, temperature < 60, temperature > 75) is the correct pattern for env threshold checking. Each condition uses `leftValue: "={{ $json.field }}"`, `rightValue: number`, `operator: { type: "number", operation: "lt|gt" }`.

### [node-config] — Set v3.4 manual mode structure confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

Set v3.4 uses `mode: "manual"`, `assignments.assignments[]` array. Each assignment: `{ id, name, value, type }`. Inline ternary expressions in `value` field work for boolean flags and computed text. `type: "boolean"` with `value: "={{ true }}"` is valid.

### [node-config] — Gmail v2.1 HTML email send shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

Gmail v2.1 send: `resource: "message"`, `operation: "send"`, `sendTo`, `subject`, `emailType: "html"`, `message`. Credential key: `gmailOAuth2`. Long inline HTML built via JS string concatenation inside `={{ }}` expression works.

### [node-config] — Google Sheets v4.5 appendOrUpdate shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

Sheets v4.5: `resource: "sheet"`, `operation: "appendOrUpdate"`. `documentId` and `sheetName` both use `{ __rl: true, value, mode }` resource-locator format. `columns.mappingMode: "defineBelow"` with `columns.value` as a flat key-value object. `columns.schema[]` array defines column metadata. Credential key: `googleSheetsOAuth2Api`.

### [node-config] — Slack v2.3 Block Kit message shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-21

Slack v2.3: `resource: "message"`, `operation: "post"`, `select: "channel"`, `channelId: { __rl: true, value: "#channel-name", mode: "name" }`. For blocks: `messageType: "block"`, `blocksUi: "={{ JSON.stringify([...]) }}"`. For plain text: `messageType: "text"`, `text`. Credential key: `slackApi`.

## Make.com Facts I've Confirmed

### [module-config] — google-sheets:triggerWatchRows v4 shape confirmed
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

Top-level trigger module. Required parameters: `spreadsheetId`, `sheetId`, `__IMTCONN__`. Exposes row fields by column name (e.g. `{{1.`Guest Name`}}`). Row index available as `{{1.__IMTINDEX__}}`. Restore block holds human-readable labels for spreadsheet/sheet IDs.

### [module-config] — openai-gpt-3:CreateCompletion v1 with json_object response_format
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

Module id field: `openai-gpt-3:CreateCompletion` v1. `mapper.model` accepts `"gpt-4o"`. `mapper.messages` is an array of `{role, content}` objects. `mapper.response_format` set to `"json_object"` enforces JSON mode. Output accessed as `{{2.choices[].message.content}}` (array notation — first choice). Attach `onerror` array directly on the module object for per-module error handling.

### [module-config] — json:ParseJSON v1 after OpenAI
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

`json:ParseJSON` v1. `mapper.json` receives the raw string `{{2.choices[].message.content}}`. Downstream modules reference parsed fields as `{{3.sentiment}}`, `{{3.category}}`, `{{3.confidence}}`, `{{3.rationale}}`.

### [module-config] — builtin:BasicRouter v1 route filter syntax
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

Router routes live under `"routes"` array on the router module. Each route has a `"flow"` array and a `"filter"` object. Filter structure: `{ "name": "Label", "conditions": { "a": "{{3.field}}", "b": "ExpectedValue", "o": "text:equal:casesensitive" } }`. Case-sensitive text equality operator is `"text:equal:casesensitive"`.

### [module-config] — util:SetVariables2 v1 variables array
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

`util:SetVariables2` v1. `mapper.variables` is an array of `{name, value}` objects. Variables from this module referenced downstream as `{{moduleId.variableName}}` (e.g. `{{5.draft_response}}`). `{{now}}` is the Make.com built-in for current timestamp. Multiline text values with `\n` are supported in the value string.

### [module-config] — google-sheets:updateRow v4 by row number
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

`google-sheets:updateRow` v4. Required parameters: `spreadsheetId`, `sheetId`, `__IMTCONN__`. `mapper.rowNumber` takes `{{1.__IMTINDEX__}}` to target the exact triggered row. `mapper.values` is a flat object keyed by column header strings. Timestamp columns use `formatDate(moduleId.processed_at; "YYYY-MM-DDTHH:mm:ss.SSS[Z]"; "UTC")` pattern.

### [module-config] — onerror array with http:ActionSendData v3 + builtin:Break v1
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

Per-module error handling uses an `"onerror"` array on the module object (parallel to `"mapper"` and `"metadata"`). Modules inside `onerror` have the same shape as regular flow modules. `http:ActionSendData` v3 posts to Slack webhook with `bodyType: "raw"`, `contentType: "application/json"`, and a `body` string containing the JSON payload. `builtin:Break` v1 follows to halt execution for the failing bundle without killing the whole scenario run.

### [scenario-shape] — HearthAndVine Sentiment Response Drafter Make.com (2026-04-22)
**Platform:** make.com
**Scope:** project:HearthAndVine-Sentiment-Drafter-Make
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

12-module scenario. Flow: triggerWatchRows (id=1) → CreateCompletion (id=2, onerror: ActionSendData id=10 + Break id=11) → ParseJSON (id=3) → BasicRouter (id=4) with 3 routes filtered on `{{3.sentiment}}`. Route 1 (Positive): SetVariables2 (id=5) → updateRow (id=6). Route 2 (Neutral): SetVariables2 (id=7) → updateRow (id=8). Route 3 (Negative): SetVariables2 (id=9) → updateRow (id=12). Scheduling: indefinitely / 900s. 45 sampleBundle items embedded across 7 modules (15 on trigger, 4+4+7 on branch SetVariables, 4+4+7 on branch updateRow). Placeholders: REPLACE_ME_SPREADSHEET_ID, REPLACE_ME_SHEET_NAME, REPLACE_ME_GOOGLE_CONNECTION_ID, REPLACE_ME_OPENAI_CONNECTION_ID, REPLACE_ME_SLACK_WEBHOOK_URL. Delivered to: Brandon/Hearth-And-Vine-Sentiment-Response-Drafter-Make/scenario/.

---

## Skills I Use

- `n8n-workflow-patterns` — multi-node flow design
- `n8n-node-configuration` — exact node parameter specs
- `n8n-validation-expert` — pre-delivery JSON check
- `n8n-code-javascript` — Code node (JS)
- `n8n-code-python` — Code node (Py)
- `n8n-expression-syntax` — `$json`, `$node`, `$now`, etc.
- `n8n-mcp-tools-expert` — MCP-based node/credential lookup

Make.com has no equivalent skill packs yet. I lean on my own mastery surface (see agent definition) and the scenario blueprints already in this workspace for reference.

---

## Translation Notes

Quick n8n ↔ Make.com pointers I've used before:

| n8n | Make.com |
|---|---|
| Webhook trigger | Webhooks: Custom webhook |
| Schedule Trigger | Scenario-level scheduling |
| IF / Switch | Router + per-route filters |
| Loop Over Items | Iterator |
| Aggregate | Array / Text / Numeric Aggregator |
| Code (JS) node | ⚠ No direct equivalent — use Tools / structured modules |
| Set / Edit Fields | Tools → Set variable / Transformer |
| HTTP Request | HTTP module |
| Execute Workflow | Trigger another scenario via webhook |

When a mapping is lossy, flag it explicitly.

---

## Conflict Resolution Rule

When a new learning contradicts an existing entry: most recent + most explicit wins, and I note the resolution inline.

---

## Topic Files (spill)

Create and link from here when a section grows past ~30 lines:

- `nodes-learned.md` — n8n node-by-node confirmed configs
- `modules-learned.md` — Make.com module-by-module confirmed configs
- `translations.md` — extended n8n ↔ Make.com mapping log
- `anti-patterns.md` — full list of "don't do this" observations

_None yet._

---

### [workflow-shape] — HearthAndVine Sentiment Automation (2026-04-22, v2 rebuild)
**Platform:** n8n
**Scope:** project:HearthAndVine-Sentiment-Automation
**Confidence:** high
**Source:** explicit (full build + QA audit)
**Date:** 2026-04-22

16-node single-workflow build. Entry: googleSheetsTrigger v4 (`rowAdded`) → chainLlm v1.7 (`onError: continueErrorOutput`) + lmChatOpenAi v1 sub-node + outputParserStructured v1.2 sub-node → IF v2.2 (validate sentiment not empty) → Switch v3.2 (3-way: Positive/Neutral/Negative) → three Set v3.4 branches → Merge v3 (append, 3 inputs) → googleSheets v4.5 `update` by `row_number`. Error branch from chainLlm: Set v3.4 → httpRequest v4.2 (Slack) → stopAndError v1. IF false branch: Set v3.4 → httpRequest v4.2 (Slack). matchingColumns: `["row_number"]`. All 5 writable columns use `={{ $json['ColumnName'] }}` bracket notation. Credentials: `googleSheetsOAuth2Api`, `openAiApi`. Pinned data on all 11 testable nodes; 15-row CSV matches trigger pinData exactly. Delivered to Brandon folder: `Hearth-And-Vine-Sentiment-Response-Drafter/`.

### [node-config] — chainLlm v1.7 message shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

chainLlm (`@n8n/n8n-nodes-langchain.chainLlm`) v1.7 uses `messages.messageValues[]` array (NOT `prompt.messages[]`). System message goes in `options.systemMessage`. User message goes as a single item in `messageValues` with key `message`. Sub-nodes attach via `ai_languageModel` and `ai_outputParser` connection types.

### [node-config] — outputParserStructured v1.2 JSON schema shape confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

`@n8n/n8n-nodes-langchain.outputParserStructured` v1.2 uses `jsonSchema` as a JSON string containing the schema object. Enums specified as `"enum": ["val1", "val2"]` under the property. Required fields declared in `"required": []` array at schema root.

### [node-config] — httpRequest v4.2 JSON body with sendBody confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

httpRequest v4.2: `sendBody: true`, `contentType: "json"`, `body` as a direct object (no `specifyBody` key required). The `body` object takes key-value pairs where values can be `={{ }}` expressions. Slack webhooks: `{ text, username, icon_emoji }` pattern confirmed working. No `bodyParameters` or `specifyBody` needed for simple JSON POST.

### [anti-pattern] — CSV sample data vs workflow template draft response mismatch
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-22

When a workflow uses static Set-node templates for responses, a sample CSV that shows AI-personalized output per row will look richer than what the workflow actually produces. This is a documentation presentation gap, not a defect. Flag it in QA audits as an observation, not a failure — the brief requirement is met if the template includes the required phrases. Do not auto-fail on this.

### [workflow-shape] — HearthAndVine pinData full-sync enhancement (2026-04-22)
**Platform:** n8n
**Scope:** project:HearthAndVine-Sentiment-Automation
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-22

Expanded all 12 testable node pinData sets from 1-item stubs to full 15-row coverage. Pattern: AI Sentiment Analysis and pass-through nodes (Validate, Route) get all 15 items; branch Set nodes get only their subset (Positive=4, Neutral=4, Negative=7); Merge gets all 15 combined; Google Sheets update gets 15 rows with row-specific `updatedRange` values (`Sheet1!A<n>:G<n>`); error nodes (Prepare Error Payload, Notify Error via Slack) get 3 sample items; invalid-output nodes get 2. Sub-nodes (OpenAI Chat Model, JSON Output Parser, Stop And Error) stay at `[]`. Timestamps use `2026-04-22T10:12:0<row_number>.000Z` convention. All Set node `value` expressions confirmed dynamic (`$json.output.sentiment`, `$json.output.category`, `$json['Guest Name']`, `$json.row_number`). JSON validated via Python json.load before delivery.

### [anti-pattern] — pinData total count arithmetic error in scorecard (2026-04-22 QA)
**Platform:** n8n
**Scope:** project:HearthAndVine-Sentiment-Automation
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-22

During final QA sweep, scorecard D2 stated "121 pinned items" but per-node counts (15+15+15+15+4+4+7+15+15+3+3+2+2) sum to 115. Fix applied inline. Root cause: stale number from an earlier build iteration not updated after node restructuring. Always re-sum pinData totals programmatically before quoting aggregate figures in scorecards.

### [scenario-shape] — HearthAndVine Make.com blueprint QA pass (2026-04-22, final audit)
**Platform:** make.com
**Scope:** project:HearthAndVine-Sentiment-Drafter-Make
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-22

Final QA sweep confirmed blueprint imports cleanly (Python json.load passes). Top-level keys correct: name, flow, metadata, scheduling. 12 total modules (IDs 1-12, no gaps). Routes nested at top-level of BasicRouter module under `"routes"` key (not under `"parameters"`). sampleBundles on module 1 are nested under `metadata.designer.sampleBundles` (not `metadata.sampleBundles`); branch modules (5-9, 12) use `metadata.sampleBundles` directly. One minor audit-spec phrasing gap: spec says `{{1.\`Feedback\`}}` but the actual expression is `{{1.Feedback}}` (no backticks) — this is correct Make.com syntax because "Feedback" has no spaces. Placeholder raw counts: SPREADSHEET_ID=8, SHEET_NAME=8 (2 per module × 4 modules: parameters + restore labels), GOOGLE_CONNECTION=4 (1 per module), OPENAI_CONNECTION=1, SLACK_WEBHOOK=1. Scorecard arithmetic 15+4+4+4+4+7+7=45 confirmed correct. All 12 deliverable files on disk. Em-dash in Keiko Tanaka row is U+2014 consistently across CSV, expected outputs, and sampleBundles — terminal rendering artifact only, not a data defect.

### [convention] — Make.com placeholder raw-count vs module-count distinction
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-22

When a Google Sheets module has a placeholder in both `parameters.spreadsheetId` AND `metadata.restore.parameters.spreadsheetId.label`, the raw string count is 2× the module count. Always distinguish "N modules carry this placeholder" from "raw string occurrences" when writing audit specs or scorecard evidence. Report by module count (semantic) not raw string count to avoid confusion.

### [workflow-shape] — StarlightSpectacles Technical Rider Alert (2026-04-23)
**Platform:** n8n
**Scope:** project:StarlightSpectacles-TechnicalRiderAlert
**Confidence:** high
**Source:** explicit (full build + QA validation)
**Date:** 2026-04-23

14-node single-workflow build. Entry: googleSheetsTrigger v4 (`anyUpdate`, 5-min poll) → Set v3.4 (Normalize: daysUntilEvent via Luxon DateTime.fromISO().diff().days + Math.floor, isUrgent boolean) → IF v2.2 (lte 14) → TRUE: Set v3.4 (Build Urgent Payload, JSON.stringify Block Kit) → Slack v2.3 (Block Kit) + 2 disabled alternatives (discord v2, telegram v1.2) → googleSheets v4.5 update (matchingColumns: [Performer Name, Event Date]). FALSE: Set v3.4 (Build Routine Payload, HTML email body + subject) → Gmail v2.1 (html, sendTo=$json.productionCrewEmail) → googleSheets v4.5 update. Error sub-flow: errorTrigger v1 (disconnected) → Set v3.4 → Slack v2.3 (plain text to #ops-errors). 99 pinned items: 15 on trigger/normalize/IF, 6 on urgent branch, 9 on routine branch, 3 on error path. JSON valid (Python json.load). Boundary rows confirmed: Captain Stilts 14d=URGENT, Titan Spark 15d=ROUTINE. Placeholders: REPLACE_ME_SPREADSHEET_ID, REPLACE_ME_SHEET_NAME, REPLACE_ME_GSHEETS_CRED_ID, REPLACE_ME_SLACK_CRED_ID, REPLACE_ME_SLACK_CHANNEL, REPLACE_ME_GMAIL_CRED_ID, REPLACE_ME_GMAIL_REPLY_TO_ADDRESS, plus optional DISCORD/TELEGRAM. Delivered to: Brandon/Starlight-Spectacles-Technical-Rider-Alert/.

### [node-config] — daysUntilEvent Luxon expression (startOf day, Math.floor) confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

Correct expression for whole-day difference: `Math.floor(DateTime.fromISO($json['Event Date']).diff(DateTime.now().startOf('day'), 'days').days)`. Using `startOf('day')` ensures stability throughout the day. Using `Math.floor` converts fractional-day diffs to whole days. The IF node then uses `lte` operator against the integer 14. Do NOT omit `startOf('day')` or the comparison may be off by 1 across midnight.

### [node-config] — Slack v2.3 Block Kit via JSON.stringify in Set node confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

Pattern: Set v3.4 assignment with `value: "={{ JSON.stringify([...block-array...]) }}"`, type string. The `blocksUi` parameter on Slack v2.3 receives this string. All block fields are built with inline JS string concatenation inside the `JSON.stringify([])`. `messageType: "block"` must be set. This avoids bracket-escaping issues that appear when building Block Kit JSON as a raw string.

### [convention] — Disabled n8n nodes as documented alternatives (better than code comments)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

When a brief asks for "X as a fallback documented as alternative," implement as a disabled node (`"disabled": true`) wired into the same connection point as the primary node. Name format: `NodeName (Disabled - Alternative)`. This is superior to comments because: (1) the full config is visible, (2) it can be enabled with one toggle, (3) it shows up in the canvas for reviewers. Do not use pinData on disabled nodes — leave empty array.

### [anti-pattern] — n8n workflow JSON: per-node pinData vs top-level pinData key (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit (regression investigation)
**Date:** 2026-04-23

n8n exports pin data embedded inside each node as `node.pinData[]`. The top-level `"pinData": {}` key (keyed by node name) is the format used in n8n's UI memory and in some import specs, but the actual exported JSON file uses per-node arrays. Both formats coexist in a valid workflow: when a file has `wf.pinData` as a top-level key AND `node.pinData` inside nodes, n8n 2.x reads the top-level key. When only per-node pinData exists, that is what n8n uses. A client spec that says "pinData is empty" means `wf['pinData']` is `{}` even though `node.pinData` arrays are populated — fix by building the top-level `wf.pinData` dict from the per-node arrays and re-serializing. Always open workflow JSON with `encoding='utf-8'` (em-dashes and special chars break cp1252).

### [anti-pattern] — Python json.load codec error on workflow files with special chars (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-23

Always open n8n workflow JSON with `open(fpath, encoding='utf-8')`. Files containing em-dashes (U+2014), typographic quotes, or other non-ASCII characters fail with `UnicodeDecodeError: charmap` under Python's default cp1252 codec on Windows. The spec's verification command omits the encoding parameter — add it when running on Windows.

### [workflow-shape] — Mud & Mystery Inventory Low-Stock Alert (2026-04-23)
**Platform:** n8n
**Scope:** project:MudAndMystery-InventoryAlert
**Confidence:** high
**Source:** explicit (full build + all checks passing)
**Date:** 2026-04-23

7-node workflow. Entry: googleSheetsTrigger v1 (rowUpdate, 5-min poll) → filter v2.2 (Current Stock < 5 AND Status != Restocking, combinator=and) → [parallel] trello v1 (create card in Restock list) + slack v2.3 (block-kit to #kiln-alerts) → googleSheets v4.5 update (Status = Restocking, matchingColumns: [SKU]). Error branch: errorTrigger v1 → slack v2.3 (plain text to #automation-errors). Top-level pinData populated: 15 items on trigger, 6 on filter, 2 on trello/slack/sheets-update, 0 on error nodes. Trigger items: MM-001, MM-003, MM-006, MM-008, MM-010, MM-014. Skipped: MM-004, MM-012 (Status=Restocking). Delivered to: Brandon/Mud-and-Mystery-Inventory-Alert/deliverables/.

### [node-config] — trello v1 create card parameters confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

trello (`n8n-nodes-base.trello`) v1: `resource: "card"`, `operation: "create"`, `listId` (string, Trello list ID), `name` (string, supports `={{ }}` expressions), `additionalFields.description` (string). Latest available typeVersion is 1 — document this when the brief specifies "typeVersion 2+ where supported" since Trello does not yet have a v2. Credential key: `trelloApi`.

### [anti-pattern] — Python console UnicodeEncodeError on emoji in f-strings (Windows) (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-23

On Windows with cp1252 console, printing an f-string that contains emoji characters (e.g. U+1F525 fire emoji from a Trello card name) raises `UnicodeEncodeError: 'charmap' codec can't encode character`. Workaround: pipe stdout through `python3 -c "import sys; data=sys.stdin.buffer.read(); print(data.decode('utf-8','replace'))"` or set `PYTHONIOENCODING=utf-8`. The JSON file itself is valid UTF-8 — this is a terminal display issue only, not a data defect.

### [translation] — n8n googleSheets update (match by column) → Make.com two-module pattern (2026-04-23)
**Platform:** both
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

n8n's googleSheets v4.5 with `matchingColumns: [SKU]` performs a lookup-and-update in a single node. Make.com has no equivalent single module. The correct Make.com pattern is: `google-sheets:searchRows` (find row number by SKU) → `google-sheets:updateRow` (write new value using that row number). This doubles the Google Sheets API calls per item — flag this as a cost/rate-limit consideration when translating.

### [anti-pattern] — Make.com searchRows filter self-comparison bug (2026-04-23)
**Platform:** make.com
**Scope:** global
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-23

In `google-sheets:searchRows`, the filter `conditions[]` object uses `a` = column header name (string) and `b` = dynamic value to match. A common build error is setting both `a` and `b` to the same `{{bundle.field}}` expression (self-comparison = always true, returns all rows). Always verify `a` is a column name string (e.g. `"SKU"`) and `b` is the lookup value (e.g. `{{1.SKU}}`).

### [anti-pattern] — n8n in-workflow Error Trigger vs settings.errorWorkflow (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-23

Two distinct n8n error handling patterns: (1) In-workflow: Error Trigger node inside the same workflow — catches errors from sibling nodes. `settings.errorWorkflow` stays empty. (2) Separate error workflow: a dedicated workflow with its own Error Trigger; main workflow sets `settings.errorWorkflow` to that workflow's ID. Pattern 1 is simpler for single-workflow deliveries. Scorecard text must not say "separate workflow" if pattern 1 is used — they are distinct.

### [convention] — Build scripts belong in scripts/, not deliverables/ (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit (QA audit)
**Date:** 2026-04-23

Data-engineer tooling files (e.g. `_generate_sheet.py`) must not appear in the `deliverables/` folder, which is the founder-facing handoff folder. Always place build/generation scripts in a `scripts/` subfolder at the project root. Check for stray `.py`, `.sh`, or `.js` scripts in `deliverables/` as part of every QA pass.

### [workflow-shape] — Obsidian Roast Discovery Form Lead Router (2026-04-23)
**Platform:** n8n
**Scope:** project:ObsidianRoast-LeadRouter
**Confidence:** high
**Source:** explicit (full build + validation)
**Date:** 2026-04-23

11-node workflow. Entry: Webhook v2 (path=obsidian-roast-discovery, responseMode=responseNode) → Set v3.4 (13 assignments: title-case name via split/filter/map, E.164 phone via +1+replace(/\D/g,''), trim email, carry-through 10 fields) → Switch v3.2 (2 rules: Wholesale output 0, Workshop output 1, fallbackOutput=none) → Code v2 Wholesale (JS, base 30, volume/company/event/flavors bonuses, cap 100, tier Hot/Warm/Cold) → Airtable v2.1 Wholesale Leads → Slack v2.3 #obsidian-roast-leads. Parallel: Code v2 Workshop (JS, base 20, group/session-date/source/flavors bonuses, Luxon DateTime.fromISO within 14 days) → Airtable v2.1 Workshop Leads → Slack v2.3. Error sub-workflow: errorTrigger v1 (disconnected from main path) → Slack v2.3 #obsidian-roast-alerts. Top-level pinData on all 6 testable nodes. Delivered to: ObsidianRoast/workflow/ObsidianRoast-LeadRouter-Workflow.json.

### [node-config] — Airtable v2.1 create with defineBelow column mapping confirmed
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-23

Airtable v2.1: `operation: "create"`, `base: { __rl: true, value, mode: "id" }`, `table: { __rl: true, value: "Table Name", mode: "name" }`. `columns.mappingMode: "defineBelow"` with `columns.value` as flat key-value object (column name → expression). `columns.schema[]` array lists column metadata objects with `id`, `displayName`, `required`, `defaultMatch`, `canBeUsedToMatch`, `display`, `type`, `readOnly`, `removed`. Credential key: `airtableTokenApi`. Base ID can be sourced via `$env.AIRTABLE_BASE_ID` with fallback literal.

### [anti-pattern] — Workshop priority score pinData mismatch (spec label vs math) (2026-04-23)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-23

A brief can label a sample lead "WARM" for descriptive intent, but the actual scoring algorithm may produce a different tier when all bonuses are applied. For LEAD-1002 (group=5, session=10 days away, source=Website Form, 2 flavors): 20+20+15+10+10=75 = Hot, not Warm. Always run the scoring simulation before writing pinData. Do not trust spec tier labels — they are aspirational, not computed. The pinData must reflect what the Code node will actually output.

### [workflow-shape] — ClearwaterPediatrics Credentialing AI Assistant (2026-04-24)
**Platform:** n8n
**Scope:** project:ClearwaterPediatrics_Credentialing
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-24

17-node AI-triage workflow (+ 8 sticky notes = 25 total). Pattern: Gmail trigger → Code (FAQ embed) → OpenAI LLM → Code (parse+validate) → Switch (4 outputs) → branch preps → Gmail drafts → merge draft links → unified Google Sheets append. All branches converge at one Sheets node. typeVersions confirmed for n8n 2.17.1: gmailTrigger=1, gmail=2, code=2, switch=3, googleSheets=4, stickyNote=1, langchain.openAi=1. Folder: `ClearwaterPediatrics_Credentialing/`.

### [node-config] — openAi LangChain node for structured JSON classification (2026-04-24)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit
**Date:** 2026-04-24

`@n8n/n8n-nodes-langchain.openAi` typeVersion 1 used for direct LLM calls (not chainLlm). Messages configured under `messages.values[]` array with `role` and `content` fields. `options.responseFormat.type: "json_object"` enforces JSON-only output. Temperature 0.1 for classification tasks. LLM response comes back as `$json.content` string — must parse with `JSON.parse()` in a downstream Code node. This is the correct pattern when you need a quick LLM call without sub-node wiring.

### [convention] — Draft-not-send pattern for healthcare HR automations (2026-04-24)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-24

In healthcare HR workflows, all Gmail actions should use operation `createDraft` (NOT send). This ensures no automated email leaves without human review — critical for compliance. The draft link is captured from the response ID and stored in the audit log so the reviewer can open it in one click. Pattern: Gmail node (createDraft) → Code node (merge draft link = `https://mail.google.com/mail/#drafts/${id}`).

### [anti-pattern] — Counting functional nodes vs total nodes in scorecards (2026-04-24)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** observation
**Date:** 2026-04-24

Sticky notes are nodes in n8n JSON (`n8n-nodes-base.stickyNote`) and count toward `nodes[]` array length. When reporting "node count" to a client, clarify: "17 functional nodes + 8 sticky notes = 25 total." Always run a programmatic count (Python json.load + filter by type) before quoting node counts in scorecards or deliverables to avoid the arithmetic error seen in HearthAndVine.

### [anti-pattern] — Top-level pinData {} empty even when per-node pinData is populated (2026-04-24 QA)
**Platform:** n8n
**Scope:** global
**Confidence:** high
**Source:** explicit (QA audit — ClearwaterPediatrics Credentialing)
**Date:** 2026-04-24

A workflow can have correct per-node `pinData` arrays on every functional node yet still fail the top-level `wf['pinData']` check because the two locations are independent. n8n 2.x reads the top-level key for "execute from pin" in the editor. Fix: iterate `wf['nodes']`, collect each non-sticky node's `pinData` array, key by `node['name']`, write to `wf['pinData']`. Always run `assert [n for n in non_sticky_names if n not in wf['pinData']] == []` before delivery. This is a second occurrence after the StarlightSpectacles audit — treat it as a mandatory step in every n8n workflow QA checklist.

*Last synthesized by Aria: never. Created 2026-04-21. Updated 2026-04-24.*
