---
name: adaptive-memory-learning
version: 1.0.0
description: "Unified adaptive memory and prompt enhancement system. Provides persistent tiered memory (global → project → agent), automatic prompt optimization using learned preferences, and continuous learning from every interaction. Supersedes and unifies: gemini-enhancement-1.0.0, learning-adaptation-1.0.0, learning-assistant-1.0.0, self-improving-agent-1.0.2, prompt-engineering-expert-1.0.0. Use for: /learn, /enhance, /recall, /memory-sync commands."
tags: [memory, learning, prompt-engineering, adaptation, unified]
---

# Adaptive Memory & Learning System

**Version:** 1.0.0
**Agent:** aria-adaptive-memory (Aria)
**Status:** Active — Unified memory authority for this workspace

## System Architecture

This skill unifies all memory and learning capabilities into one cohesive system operated by Aria, the adaptive memory agent.

```
Global Layer:   C:\Users\Merriam\.claude\CLAUDE.md
Project Layer:  C:\D-drive-94828\Postwork\.claude\agent-memory\aria-adaptive-memory\MEMORY.md
Agent Layer:    C:\D-drive-94828\Postwork\.claude\agent-memory\{agent}\MEMORY.md (14 agents)
```

## 📋 Commands

### `/learn [fact or preference]`
Record an explicit preference, correction, or pattern.

**Usage:**
```
/learn I prefer TypeScript strict mode always on
/learn Always use Bun instead of npm/yarn in this project
/learn When writing components, keep them under 150 lines
/learn Avoid Redux — this project uses Zustand
```

**What happens:**
1. Aria classifies the learning (preference | correction | convention | architecture | anti-pattern)
2. Determines scope: global (style/tone) vs project (stack/tools) vs sub-project vs task-type
3. Checks for conflicts with existing entries — resolves if found
4. Appends to Aria's MEMORY.md under the appropriate section
5. Confirms: "Learned: [summary]. Scope: [scope]. Stored under [section]."

---

### `/enhance [prompt or task description]`
Optimize a prompt before executing it, using all stored patterns.

**Usage:**
```
/enhance create a user settings page
/enhance write tests for the auth module
/enhance review this API design
/enhance build a REST endpoint for order history
```

**What happens:**
1. Aria reads her MEMORY.md for relevant preferences (tech stack, style, conventions)
2. Reads the relevant specialist agent's MEMORY.md if the task maps to a known agent
3. Produces an enriched prompt with: explicit tech stack, style constraints, quality requirements, known patterns
4. Presents the enhanced prompt for confirmation before execution
5. Logs which patterns were applied (for future reinforcement or correction)

**Enhancement injects:**
- Stack preferences (framework, language, tooling)
- Code style (naming, file structure, patterns)
- Communication style (verbosity, explanation depth)
- Quality gates (test requirements, review agents to involve)
- Known anti-patterns to avoid

---

### `/recall [topic or question]`
Query stored memory across all layers.

**Usage:**
```
/recall what stack does this project use
/recall my preferences for React components
/recall what did we decide about authentication
/recall Koopprijs date field pattern
```

**What happens:**
1. Aria searches her MEMORY.md for the topic (semantic, not just keyword)
2. Also scans relevant specialist agent's MEMORY.md if applicable
3. Returns structured summary with source attribution and confidence level
4. If nothing found: "I have no stored knowledge about [topic]. Use /learn to add it."

---

### `/memory-sync`
Synthesize all agent memories into Aria's knowledge base — resolve conflicts, absorb new patterns, prune stale entries.

**Usage:**
```
/memory-sync
/memory-sync --agent joey-backend-architect
/memory-sync --scope global
```

**What happens:**
1. Aria reads all 14 agent MEMORY.md files
2. Extracts cross-cutting patterns confirmed by multiple agents
3. Identifies and resolves conflicts (most-recent + most-confirmed wins)
4. Writes synthesized patterns to her MEMORY.md under `## Synthesized from Agent Memories`
5. Reports: agents read, patterns absorbed, conflicts resolved

---

## 🔄 Automatic Learning Triggers

These fire without explicit commands — CLAUDE.md activates this behavior on every session:

| Signal | Action |
|--------|--------|
| "no", "actually", "wrong", "not quite", "I said", "I meant" | Log as correction with original + corrected approach |
| "perfect", "exactly", "yes", "great", "that's it", "keep doing that" | Reinforce the pattern used |
| "remember", "always", "never", "from now on", "I prefer", "stop doing" | Auto-route to `/learn` |
| Command fails unexpectedly | Log to error/anti-pattern category |
| User provides stack info unprompted | Capture as project context |
| Same question type asked 3+ times | Promote to standing preference |

---

## 🏛️ Memory Tiers

### Tier 1 — Global (applies everywhere)
Stored in: Aria's MEMORY.md → `## Global Preferences`
- Communication style (verbosity, tone, explanation depth)
- Universal code style (quotes, semicolons, async patterns)
- Workflow preferences (test before commit, lint, etc.)
- Universal anti-patterns

### Tier 2 — Project (applies to Postwork workspace)
Stored in: Aria's MEMORY.md → `## Project Knowledge`
- Tech stack per sub-project
- Architecture decisions
- Established naming conventions
- Known anti-patterns

### Tier 3 — Agent (applies when a specialist is active)
Stored in: Each agent's own MEMORY.md
- Agent-specific patterns and observations
- Synthesized by Aria during `/memory-sync`

---

## 🔗 Superseded Skills

The following skills remain installed but are now unified under this system. Their learnings flow to Aria as the central store:

- `gemini-enhancement-1.0.0` — memory/learning → flows to Aria
- `learning-adaptation-1.0.0` — preference learning → flows to Aria
- `learning-assistant-1.0.0` — remember/recall → routed through `/recall`
- `self-improving-agent-1.0.2` — corrections/errors → flows to Aria
- `prompt-engineering-expert-1.0.0` — prompt optimization → now `/enhance`

---

## 🤝 Integration with Existing Agents

All 27 agents can benefit from Aria's memory. Before executing any complex task:

```
1. /recall [task domain]    → Check what Aria knows
2. /enhance [planned task]  → Apply enriched prompt
3. After work completes     → /learn [new patterns discovered]
```

Aria is the only agent whose MEMORY.md is the authoritative cross-agent knowledge base. Specialist agent MEMORY.md files remain their own — Aria synthesizes from them, never replaces them.
