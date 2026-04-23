#!/bin/bash
# Remember and store information

CATEGORY="${1:-general}"
CONTENT="${2:-$(cat)}"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

if [ -z "$CONTENT" ]; then
    echo "Error: No content to remember"
    exit 1
fi

# Memory file
MEMORY_FILE="$HOME/.clawdbot/memory/preferences/${CATEGORY}.md"
mkdir -p "$(dirname "$MEMORY_FILE")"

# Append to memory
echo "" >> "$MEMORY_FILE"
echo "## [$TIMESTAMP]" >> "$MEMORY_FILE"
echo "$CONTENT" >> "$MEMORY_FILE"

echo "✅ Remembered ($CATEGORY): $CONTENT"
echo "📝 Stored in: $MEMORY_FILE"

# Also update JSON for structured access
JSON_FILE="$HOME/.clawdbot/memory/preferences.json"
if [ ! -f "$JSON_FILE" ]; then
    echo "{}" > "$JSON_FILE"
fi

# Add to JSON using jq if available
if command -v jq &> /dev/null; then
    jq --arg cat "$CATEGORY" --arg content "$CONTENT" --arg ts "$TIMESTAMP" \
       '.[$cat] += [{timestamp: $ts, content: $content}]' \
       "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
fi
