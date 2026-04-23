# Learning Assistant Skill

**Help Clawdbot learn, remember, and improve over time**

## Purpose

This skill enables Clawdbot to:
- Remember user preferences and patterns
- Learn from interactions
- Store context about projects
- Track what works and what doesn't
- Build knowledge over time

## When to Use

Activate when:
- User asks Clawdbot to "remember" something
- User wants to "save" information for later
- User asks "what did we work on last time?"
- User wants to review past sessions
- User asks Clawdbot to "learn" from something

## Available Commands

### 1. Remember Information
**Trigger:** "remember", "save this", "store this"

**Script:** `bash ~/.clawdbot/skills/learning-assistant-1.0.0/scripts/remember.sh "CATEGORY" "CONTENT"`

**Examples:**
- User: "Remember that I prefer using Antigravity IDE"
- User: "Save this: my koopprijs project uses Next.js"
- User: "Store my YouTube posting schedule: Tuesdays and Thursdays"

### 2. Recall Information
**Trigger:** "what do you know about", "recall", "what did I tell you"

**Script:** `bash ~/.clawdbot/skills/learning-assistant-1.0.0/scripts/recall.sh "TOPIC"`

**Examples:**
- User: "What do you know about my projects?"
- User: "Recall my preferences"
- User: "What did we work on yesterday?"

### 3. Session Summary
**Trigger:** "summarize our session", "what did we do today"

**Script:** `bash ~/.clawdbot/skills/learning-assistant-1.0.0/scripts/session_summary.sh`

**Examples:**
- User: "Summarize what we did today"
- User: "Review our session"

### 4. Project Context
**Trigger:** "what do you know about [project]", "project context"

**Script:** `bash ~/.clawdbot/skills/learning-assistant-1.0.0/scripts/project_context.sh "PROJECT_NAME"`

**Examples:**
- User: "What do you know about koopprijs?"
- User: "Tell me about the anime-shuakipie project"

### 5. Learning Log
**Trigger:** "show learning log", "what have you learned"

**Script:** `bash ~/.clawdbot/skills/learning-assistant-1.0.0/scripts/learning_log.sh`

**Examples:**
- User: "What have you learned about me?"
- User: "Show me your learning log"

## Memory Storage

All learned information is stored in:
- `~/.clawdbot/memory/preferences.json` - User preferences
- `~/.clawdbot/memory/projects/*.json` - Project contexts
- `~/.clawdbot/memory/sessions/*.md` - Session logs
- `~/.clawdbot/memory/knowledge/*.md` - General knowledge

## Important Notes

1. **Always remember user preferences** when mentioned
2. **Update project context** after working on projects
3. **Log sessions** for future reference
4. **Learn from corrections** when user fixes mistakes
5. **Build knowledge** incrementally over time

## Self-Improvement

Clawdbot should:
- Track what commands work well
- Note when user is frustrated or satisfied
- Remember successful workflows
- Learn keyboard shortcuts and preferences
- Adapt to user's coding style

## Examples

**User:** "Remember that I work on YouTube content on Tuesdays and Thursdays"
**Bot:** Executes: `remember.sh "schedule" "YouTube content: Tuesdays and Thursdays"`
**Response:** "✅ Remembered: YouTube schedule"

**User:** "What do you know about my work schedule?"
**Bot:** Executes: `recall.sh "schedule"`
**Response:** Shows saved schedule information

**User:** "Summarize today's session"
**Bot:** Executes: `session_summary.sh`
**Response:** Lists all activities, commands, and achievements
