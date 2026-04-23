#!/bin/bash
# Get or create project context

PROJECT_NAME="${1:-$(basename $(pwd))}"
PROJECT_DIR="$HOME/Projects/$PROJECT_NAME"
CONTEXT_FILE="$HOME/.clawdbot/memory/projects/${PROJECT_NAME}.json"

echo "📦 Project Context: $PROJECT_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if project exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "⚠️  Project directory not found: $PROJECT_DIR"
    echo ""
    # Search for similar projects
    echo "🔍 Similar projects:"
    ls ~/Projects | grep -i "$PROJECT_NAME" | head -5
    exit 1
fi

# If context file exists, show it
if [ -f "$CONTEXT_FILE" ]; then
    echo "📄 Existing Context:"
    cat "$CONTEXT_FILE" | jq '.' 2>/dev/null || cat "$CONTEXT_FILE"
else
    echo "🆕 Creating new context..."
    
    # Analyze project
    cd "$PROJECT_DIR"
    
    # Detect project type
    PROJECT_TYPE="unknown"
    if [ -f "package.json" ]; then
        PROJECT_TYPE="node"
    elif [ -f "requirements.txt" ]; then
        PROJECT_TYPE="python"
    elif [ -f "composer.json" ]; then
        PROJECT_TYPE="php"
    fi
    
    # Create context
    cat > "$CONTEXT_FILE" << EOF
{
  "name": "$PROJECT_NAME",
  "path": "$PROJECT_DIR",
  "type": "$PROJECT_TYPE",
  "created": "$(date -I)",
  "lastAccessed": "$(date -I)",
  "description": "",
  "technologies": [],
  "notes": [],
  "todos": []
}
EOF
    
    echo "✅ Context created: $CONTEXT_FILE"
    cat "$CONTEXT_FILE" | jq '.' 2>/dev/null || cat "$CONTEXT_FILE"
fi

echo ""
echo "📂 Project Structure:"
tree -L 2 -I 'node_modules|.git' "$PROJECT_DIR" 2>/dev/null | head -20

echo ""
echo "💡 Update context with:"
echo "   Remember 'koopprijs uses Next.js and TypeScript'"
echo "   Remember 'koopprijs TODO: Add authentication'"
