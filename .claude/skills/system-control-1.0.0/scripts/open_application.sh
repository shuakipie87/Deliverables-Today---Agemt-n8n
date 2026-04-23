#!/bin/bash
# Open applications by name

APP_NAME="${1:-$(cat)}"

if [ -z "$APP_NAME" ]; then
    echo "Error: No application name provided"
    exit 1
fi

# Convert to lowercase for matching
APP_LOWER=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')

echo "Attempting to open: $APP_NAME"

# Application mappings
case "$APP_LOWER" in
    *antigravity*|*ide*)
        if [ -f "$HOME/Applications/Antigravity" ]; then
            "$HOME/Applications/Antigravity" &
            echo "✅ Opened Antigravity IDE"
        elif command -v antigravity &> /dev/null; then
            antigravity &
            echo "✅ Opened Antigravity IDE"
        else
            echo "❌ Antigravity IDE not found"
            exit 1
        fi
        ;;
    *chrome*|*browser*)
        if command -v google-chrome &> /dev/null; then
            google-chrome &
            echo "✅ Opened Google Chrome"
        else
            echo "❌ Chrome not found"
            exit 1
        fi
        ;;
    *code*|*vscode*)
        if command -v code &> /dev/null; then
            code &
            echo "✅ Opened VS Code"
        else
            echo "❌ VS Code not found"
            exit 1
        fi
        ;;
    *opencode*)
        if command -v opencode &> /dev/null; then
            opencode &
            echo "✅ Opened OpenCode"
        else
            echo "❌ OpenCode not found"
            exit 1
        fi
        ;;
    *terminal*)
        bash "$HOME/.clawdbot/skills/system-control-1.0.0/scripts/open_terminal.sh"
        ;;
    *godot*)
        if [ -f "$HOME/Applications/Godot_v4.5.1-stable_linux.x86_64" ]; then
            "$HOME/Applications/Godot_v4.5.1-stable_linux.x86_64" &
            echo "✅ Opened Godot"
        else
            echo "❌ Godot not found"
            exit 1
        fi
        ;;
    *)
        # Try to launch as command
        if command -v "$APP_NAME" &> /dev/null; then
            "$APP_NAME" &
            echo "✅ Opened $APP_NAME"
        else
            echo "❌ Application not found: $APP_NAME"
            echo "Try one of: antigravity, chrome, code, opencode, terminal, godot"
            exit 1
        fi
        ;;
esac

exit 0
