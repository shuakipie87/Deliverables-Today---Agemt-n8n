#!/bin/bash
# Recall stored information

TOPIC="${1:-general}"

echo "🧠 Recalling information about: $TOPIC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check memory files
MEMORY_DIR="$HOME/.clawdbot/memory"
FOUND=0

# Search in preferences
if [ -f "$MEMORY_DIR/preferences/${TOPIC}.md" ]; then
    echo "📝 From Preferences:"
    cat "$MEMORY_DIR/preferences/${TOPIC}.md"
    echo ""
    FOUND=1
fi

# Search in all preference files if not found
if [ $FOUND -eq 0 ]; then
    echo "🔍 Searching all memories..."
    grep -r "$TOPIC" "$MEMORY_DIR/preferences/" 2>/dev/null | head -20
    echo ""
fi

# Search in projects
if [ -d "$MEMORY_DIR/projects" ]; then
    PROJECT_INFO=$(grep -l "$TOPIC" "$MEMORY_DIR/projects"/*.json 2>/dev/null)
    if [ -n "$PROJECT_INFO" ]; then
        echo "📦 Related Projects:"
        echo "$PROJECT_INFO"
        echo ""
        FOUND=1
    fi
fi

if [ $FOUND -eq 0 ]; then
    echo "❌ No specific memories found about: $TOPIC"
    echo ""
    echo "💡 Try:"
    echo "   - 'Show learning log' to see all memories"
    echo "   - 'Remember [info]' to store new information"
fi
