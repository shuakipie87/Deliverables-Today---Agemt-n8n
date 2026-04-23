# Joey Backend Memory - EvalsToGo Multi-Vertical Platform

## Project Structure
- **Root**: `C:\D-drive-94828\MY PROJECTS\Jobs\SirDennis\working-evalstogo-with-subdomain\evalstogo-demo-working-backup - each client - analysis\`
- **Main entry**: `App.tsx` (React SPA)
- **Types**: `types.ts` (no legacy enums - all removed in Step 5)
- **Services**: `services/flowEngine.ts`, `services/geminiService.ts`, `services/supabaseService.ts`
- **Components**: `components/DynamicFlowEngine.tsx`, `components/ResultsChart.tsx`, `components/ConfiguredApp.tsx`

## Architecture Pattern (Post Step 5)
- **AssessmentResults** is the single data model for assessment completion (replaces legacy AssessmentState with enums)
- `DynamicFlowEngine.onComplete` returns `AssessmentResults` directly
- `generateEducationalInsight(results, language, t)` - gemini service
- `completeAssessmentRecord(assessmentId, results, insight, timeMs, imageUrl)` - supabase
- `computeEnrichmentData(results)` - supabase
- `computeScores(answers, categories, profile, t)` -> `{key, label, value}[]`
- `computeRiskLevel(flags, answers, categories, profile)` -> 'high'|'moderate'|'low'
- `evaluateGoalConnection(goalSlug, flagCount, limitationSlug, profile)` -> connection object
- `ResultsChart` accepts `scores: {key, label, value}[]` and `labels: {badge, disclaimer}`

## Key Decisions
- No hardcoded translations dictionary in App.tsx - all translations come from DB profile or fall back to raw key
- No legacy enum bridging - DynamicFlowEngine outputs AssessmentResults directly
- FlagSummaryBlock replaces MovementPatternsBlock (groups flags by category)
- GoalConnectionCallout uses evaluateGoalConnection from flowEngine
- Webhook payload uses universal structure with categories/flags/scores
