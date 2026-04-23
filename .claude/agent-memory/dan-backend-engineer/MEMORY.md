# Nova Backend Engineer - Project Memory

## Project: Koopprijs (Realwork Backend)

### Key Architecture
- Backend lives in `realwork-backend-master/`
- MongoDB-based, uses `database/connection.js` for DB access
- Express.js routes in `routes/`
- Logging via custom `utils/logger.js` (file-based, daily rotation, 30-day cleanup)
- Property status change tracking in `database/logging.js` (MongoDB collection `property_status_logs`)

### Date Field Pattern (CRITICAL)
Properties in the `properties` collection use **multiple date field names** under `financieel.overdracht`:
- `financieel.overdracht.datum` (primary in statusAggregation)
- `financieel.overdracht.transactie_datum` (secondary fallback)
- `financieel.overdracht.transportdatum` (tertiary / legacy)

Always use `$or` in match conditions and `$ifNull` fallback chains when querying dates.
Pattern established in `database/statusAggregation.js` and now also in `database/yearComparison.js`.

### Price Field Pattern
- Primary: `financieel.overdracht.transactieprijs`
- Fallback: `financieel.overdracht.koopprijs`
- Commission: `financieel.courtage.totaal` or parsed from `commission` string field

### Manager ID Field
- `statusAggregation.js` uses `aanbod.makelaar_id`
- `yearComparison.js` uses `managerId` (top-level field)
- These may refer to different data -- verify which is correct if issues arise

### Date Parsing in Aggregation Pipelines
MongoDB dates come in multiple formats: native Date objects, "YYYY-MM-DD" strings, "DD-MM-YYYY" strings, and ISO strings. Use `$switch` with `$type` check and `$regexMatch` branches, plus `$dateFromString` with `onError: null`.

## Project: EvalsToGo (Supabase Edge Functions)

- [ai-proxy generate-colors payload format](project_ai_proxy_payload.md) -- client sends pre-built Gemini `parts` array, not separate base64 fields
