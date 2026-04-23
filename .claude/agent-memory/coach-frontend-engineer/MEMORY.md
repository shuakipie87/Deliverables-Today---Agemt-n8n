# EvalsToGo Frontend Patterns

## Project Structure
- Root: `c:\D-drive-94828\MY PROJECTS\Jobs\SirDennis\working-evalstogo-with-subdomain\evalstogo-demo-working-backup - each client`
- Components: `components/` (Button.tsx, ResultsChart.tsx, LoadingScreen.tsx, ConfiguredApp.tsx, Dynamic*.tsx)
- Services: `services/flowEngine.ts` (generateDynamicFlow, resolveFlags, categorySlugToBodyArea)
- Types: `types.ts` (LoadedProfile, LoadedStep, LoadedOption, DynamicFlowStep, configs)

## Styling Conventions
- **Brand CSS Variables**: `var(--brand-primary)`, `var(--brand-primary-hover)`, `var(--brand-light)`, `var(--brand-accent)`, `var(--brand-dark)`, `var(--brand-background)`
- **Neutral palette**: `var(--neutral-50)` through `var(--neutral-900)`
- **Info/Error**: `var(--info-bg)`, `var(--info-border)`, `var(--error-text)`, etc.
- **Tailwind + inline style**: Tailwind for layout/spacing, `style={}` for brand color variables
- **Rounded corners**: `rounded-xl` for cards/buttons, `rounded-2xl` for containers, `rounded-lg` for smaller elements
- **Borders**: `border-2` on interactive cards; use `hover-brand-border` custom class for hover
- **Transitions**: `transition-all duration-150` or `duration-200`; `hover:scale-[1.02] active:scale-[0.98]` on selectable cards
- **Shadows**: `shadow-md` on cards, `shadow-xl` on containers

## Animation Classes
- `animate-fadeIn` - entrance fade
- `animate-slideOutLeft` / `animate-slideInRight` - step transitions
- `animate-selectionPulse` - selection feedback
- `animate-shake` - error feedback on checkbox

## Component Patterns
- Button component uses `style={}` for brand colors, not Tailwind color classes
- Assessment option cards: `border-2` + brand border/bg when selected, neutral when not; include `ChevronRight` or `CheckCircle2` icons
- Slider: native `<input type="range">` with `accent-brand` class and `var(--neutral-200)` bg; value displayed in bordered pill
- Translation function `t(key, replacements?)` used throughout; keys like `step.{slug}.question`, `option.{slug}.{option}.label`

## Dynamic Profile System
- `LoadedProfile` drives the entire flow via `flow_sequence` and `category_loop_steps`
- `DynamicFlowStep` is the runtime step shape after flow generation
- Flow engine in `services/flowEngine.ts` handles step ordering, flag resolution, goal connection
- Three input types: `multi_select`, `slider`, `single_select` - each with its own config interface
