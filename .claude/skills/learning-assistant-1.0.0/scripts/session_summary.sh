#!/bin/bash
# Summarize current session

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
SESSION_FILE="$HOME/.clawdbot/memory/sessions/session-$DATE.md"

echo "📊 Session Summary - $DATE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# If session file exists, show it
if [ -f "$SESSION_FILE" ]; then
    cat "$SESSION_FILE"
else
    echo "📝 New Session Started at $TIME"
    echo ""
    
    # Create session file
    cat > "$SESSION_FILE" << EOF
# Session: $DATE

## Activities
- Session started at $TIME

## Projects Worked On
- (will be updated as session progresses)

## Commands Executed
- (will be updated as session progresses)

## Notes
- (add any session notes here)
EOF
    
    echo "✅ Session log created: $SESSION_FILE"
fi

echo ""
echo "💡 Tips:"
echo "   - Session logs are saved in: ~/.clawdbot/memory/sessions/"
echo "   - Use 'Remember' to add notes to this session"
echo "   - Review past sessions to see your progress"
