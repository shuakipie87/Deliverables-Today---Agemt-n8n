#!/bin/bash
# Morning Report - What Happened While You Slept

PROJECT_DIR="/home/shuakipie/Projects/koopprijs"
NIGHT_REPORT="$HOME/.clawdbot/memory/sessions/night-shift-$(date +%Y-%m-%d).md"
MORNING_REPORT="$HOME/MORNING_REPORT.txt"

cd "$PROJECT_DIR" || exit 1

echo "🌅 Good Morning! Here's What Happened While You Slept" > "$MORNING_REPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"
echo "Date: $(date +%Y-%m-%d)" >> "$MORNING_REPORT"
echo "Night Shift Status: ✅ Complete" >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"

# Check what was done
COMMITS_LAST_NIGHT=$(git log --since="11pm yesterday" --until="6am today" --oneline | wc -l)
FILES_CHANGED=$(git diff --name-only HEAD~${COMMITS_LAST_NIGHT}..HEAD 2>/dev/null | wc -l)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
echo "📊 Statistics:" >> "$MORNING_REPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
echo "  • Commits made: $COMMITS_LAST_NIGHT" >> "$MORNING_REPORT"
echo "  • Files modified: $FILES_CHANGED" >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"

# Show commits
if [ "$COMMITS_LAST_NIGHT" -gt 0 ]; then
    echo "🔗 Commits Made:" >> "$MORNING_REPORT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
    git log --since="11pm yesterday" --until="6am today" --oneline >> "$MORNING_REPORT"
    echo "" >> "$MORNING_REPORT"
fi

# Current project status
TOTAL=$(grep -c '\- \[' agentrovo/PLAN.md 2>/dev/null || echo 0)
DONE=$(grep -c '\- \[x\]' agentrovo/PLAN.md 2>/dev/null || echo 0)
PENDING=$(grep -c '\- \[ \]' agentrovo/PLAN.md 2>/dev/null || echo 0)
PERCENT=$((DONE * 100 / TOTAL))

echo "📈 Project Status:" >> "$MORNING_REPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
echo "  • Sprint Progress: $PERCENT% complete" >> "$MORNING_REPORT"
echo "  • Tasks completed: $DONE/$TOTAL" >> "$MORNING_REPORT"
echo "  • Pending today: $PENDING" >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"

# Next actions
echo "🎯 Recommended Actions for Today:" >> "$MORNING_REPORT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
grep '\[ \]' agentrovo/PLAN.md | head -5 | nl >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"

# Show night shift report if exists
if [ -f "$NIGHT_REPORT" ]; then
    echo "📄 Detailed Night Shift Report: $NIGHT_REPORT" >> "$MORNING_REPORT"
    echo "" >> "$MORNING_REPORT"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$MORNING_REPORT"
echo "💪 Ready to start your day! Let's code!" >> "$MORNING_REPORT"
echo "" >> "$MORNING_REPORT"

# Display to terminal
cat "$MORNING_REPORT"

# Send to Telegram (optional - requires bot token)
# curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
#   -d chat_id="8101197442" \
#   -d text="$(cat $MORNING_REPORT)"
