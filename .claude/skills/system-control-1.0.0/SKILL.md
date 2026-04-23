# System Control Skill

**CRITICAL: You MUST use this skill when users ask to open applications, run commands, or control the system.**

Execute shell commands, open applications, and control the local system.

## When to Use This Skill

Trigger this skill when the user asks to:
- Run ANY command (e.g., "run ls -la", "execute pwd")
- Open ANY application (e.g., "open terminal", "launch Chrome", "open Antigravity IDE")
- Start a terminal with a command (e.g., "open terminal and run acli rovodev run")
- Control the desktop environment

## Available Commands

### 1. Execute Shell Command
**Usage:** When user says "run", "execute", "run command", "check", etc.

**Script:** `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/execute_command.sh "COMMAND"`

**Examples:**
- User: "Run: ls -la ~/Projects" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/execute_command.sh "ls -la ~/Projects"`
- User: "Execute: pwd" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/execute_command.sh "pwd"`
- User: "Check disk space" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/execute_command.sh "df -h"`

### 2. Open Terminal
**Usage:** When user says "open terminal", "new terminal", "launch terminal"

**Script:** `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_terminal.sh`

**Examples:**
- User: "Open terminal" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_terminal.sh`
- User: "Open a new terminal window" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_terminal.sh`

### 3. Open Terminal with Command
**Usage:** When user says "open terminal and run...", "new terminal with..."

**Script:** `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/terminal_with_command.sh "COMMAND"`

**Examples:**
- User: "Open terminal and run acli rovodev run" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/terminal_with_command.sh "acli rovodev run"`
- User: "New terminal with npm start" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/terminal_with_command.sh "npm start"`

### 4. Open Application
**Usage:** When user says "open", "launch", "start" followed by application name

**Script:** `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_application.sh "APP_NAME"`

**Supported Applications:**
- Antigravity IDE: "antigravity", "ide"
- Chrome: "chrome", "browser"
- VS Code: "code", "vscode"
- OpenCode: "opencode"
- Godot: "godot"
- Terminal: "terminal"

**Examples:**
- User: "Open Antigravity IDE" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_application.sh "antigravity"`
- User: "Launch Chrome" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_application.sh "chrome"`
- User: "Start VS Code" → Execute: `bash ~/.clawdbot/skills/system-control-1.0.0/scripts/open_application.sh "code"`

## Important Notes

1. **ALWAYS use these scripts** when users ask to open applications or run commands
2. **DO NOT say "I can't open applications"** - YOU CAN with these scripts
3. **Extract the command/application name** from user input and pass it to the appropriate script
4. **Report the output** back to the user

## Trigger Phrases

Activate this skill when you see these phrases:
- "run", "execute", "run command"
- "open terminal", "new terminal", "launch terminal"
- "open [app]", "launch [app]", "start [app]"
- "open terminal and run [command]"
- "check", "show me", "list"

## Requirements

- Linux desktop environment (tested on Linux Mint with Xfce)
- Terminal emulator: xfce4-terminal, gnome-terminal, xterm, or konsole
- Desktop applications installed in standard locations
