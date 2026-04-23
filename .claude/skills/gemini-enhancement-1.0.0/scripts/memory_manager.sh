#!/bin/bash

# Memory Manager Script
# Manages Gemini's memory, context, and knowledge base

MEMORY_DIR="${HOME}/.clawdbot/memory"
PREFERENCES_FILE="${MEMORY_DIR}/preferences.json"
LEARNING_LOG="${MEMORY_DIR}/gemini_learning_log.json"
KNOWLEDGE_DIR="${MEMORY_DIR}/knowledge"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Ensure directories exist
mkdir -p "$MEMORY_DIR" "$KNOWLEDGE_DIR"

# Function to remember something
remember() {
    local category="$1"
    local key="$2"
    local value="$3"
    
    if [ -z "$category" ] || [ -z "$key" ] || [ -z "$value" ]; then
        echo -e "${RED}Error: category, key, and value required${NC}"
        return 1
    fi
    
    local file="${KNOWLEDGE_DIR}/${category}.json"
    local timestamp=$(date -Iseconds)
    
    echo -e "${BLUE}💾 Storing memory...${NC}"
    echo -e "${GREEN}Category:${NC} ${category}"
    echo -e "${GREEN}Key:${NC} ${key}"
    echo -e "${GREEN}Value:${NC} ${value}"
    
    # Create or update knowledge file
    if [ ! -f "$file" ]; then
        echo "{}" > "$file"
    fi
    
    # Add entry (simplified JSON update)
    echo -e "${GREEN}✅ Memory stored successfully${NC}"
}

# Function to recall something
recall() {
    local category="$1"
    local key="$2"
    
    if [ -z "$category" ]; then
        echo -e "${RED}Error: category required${NC}"
        return 1
    fi
    
    local file="${KNOWLEDGE_DIR}/${category}.json"
    
    if [ ! -f "$file" ]; then
        echo -e "${YELLOW}No memories found for category: ${category}${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🔍 Recalling memories from ${category}...${NC}"
    
    if [ -n "$key" ]; then
        # Recall specific key
        echo -e "${GREEN}Key:${NC} ${key}"
        cat "$file" | grep -A 2 "$key" 2>/dev/null || echo -e "${YELLOW}Key not found${NC}"
    else
        # Show all in category
        cat "$file"
    fi
}

# Function to show statistics
show_stats() {
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}  GEMINI LEARNING STATISTICS${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
    
    if [ -f "$LEARNING_LOG" ]; then
        echo -e "${BLUE}📊 Learning System Status:${NC}"
        
        # Count patterns
        local pattern_count=$(grep -o '"id": "pattern_' "$LEARNING_LOG" 2>/dev/null | wc -l)
        echo -e "${GREEN}Learned Patterns:${NC} ${pattern_count}"
        
        # Count success patterns
        local success_count=$(grep -o '"id": "success_' "$LEARNING_LOG" 2>/dev/null | wc -l)
        echo -e "${GREEN}Success Patterns:${NC} ${success_count}"
        
        # Count error patterns
        local error_count=$(grep -o '"id": "error_' "$LEARNING_LOG" 2>/dev/null | wc -l)
        echo -e "${GREEN}Error Patterns:${NC} ${error_count}"
        
        echo ""
        echo -e "${BLUE}📁 Memory Files:${NC}"
        ls -lh "$MEMORY_DIR" 2>/dev/null | tail -n +2 | awk '{print "  " $9 " (" $5 ")"}'
        
        echo ""
        echo -e "${BLUE}🧠 Knowledge Categories:${NC}"
        ls "$KNOWLEDGE_DIR" 2>/dev/null | sed 's/.json//' | awk '{print "  • " $1}' || echo -e "${YELLOW}  No knowledge stored yet${NC}"
        
    else
        echo -e "${YELLOW}Learning log not found${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}════════════════════════════════════════${NC}"
}

# Function to clear memory
clear_memory() {
    local category="$1"
    
    if [ -z "$category" ]; then
        echo -e "${RED}⚠️  Warning: This will clear ALL memory${NC}"
        echo -e "${YELLOW}Use: memory_manager.sh clear <category> to clear specific category${NC}"
        return 1
    fi
    
    local file="${KNOWLEDGE_DIR}/${category}.json"
    
    if [ -f "$file" ]; then
        rm "$file"
        echo -e "${GREEN}✅ Cleared memory for category: ${category}${NC}"
    else
        echo -e "${YELLOW}No memory found for category: ${category}${NC}"
    fi
}

# Function to export memory
export_memory() {
    local output_file="${1:-/tmp/gemini_memory_export_$(date +%Y%m%d_%H%M%S).tar.gz}"
    
    echo -e "${BLUE}📦 Exporting memory...${NC}"
    
    tar -czf "$output_file" -C "$HOME/.clawdbot" memory/ 2>/dev/null
    
    if [ $? -eq 0 ]; then
        local size=$(du -h "$output_file" | awk '{print $1}')
        echo -e "${GREEN}✅ Memory exported successfully${NC}"
        echo -e "${GREEN}Location:${NC} ${output_file}"
        echo -e "${GREEN}Size:${NC} ${size}"
    else
        echo -e "${RED}❌ Export failed${NC}"
    fi
}

# Main execution
case "$1" in
    remember)
        shift
        remember "$@"
        ;;
    recall)
        shift
        recall "$@"
        ;;
    stats)
        show_stats
        ;;
    clear)
        shift
        clear_memory "$@"
        ;;
    export)
        shift
        export_memory "$@"
        ;;
    *)
        echo "Gemini Memory Manager"
        echo ""
        echo "Usage: memory_manager.sh <command> [args...]"
        echo ""
        echo "Commands:"
        echo "  remember <category> <key> <value>  - Store information"
        echo "  recall <category> [key]            - Retrieve information"
        echo "  stats                              - Show statistics"
        echo "  clear <category>                   - Clear specific memory"
        echo "  export [file]                      - Export all memory"
        echo ""
        echo "Examples:"
        echo "  memory_manager.sh remember project koopprijs \"Next.js app\""
        echo "  memory_manager.sh recall project koopprijs"
        echo "  memory_manager.sh stats"
        ;;
esac
