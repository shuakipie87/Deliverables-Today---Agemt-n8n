#!/bin/bash
# Debug Analyzer - Analyze and attempt to fix failures

PROJECT_DIR="/home/shuakipie/Projects/koopprijs"
cd "$PROJECT_DIR" || exit 1

echo "🐛 Debug Analyzer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ISSUES_FOUND=0
ISSUES_FIXED=0

# 1. Check for console errors in code
echo "🔍 Scanning for console errors..."
echo ""

if grep -r "console.error\|console.warn" realwork-frontend-master/src 2>/dev/null | head -10; then
    echo "⚠️  Found console warnings/errors in code"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# 2. Check for TODO/FIXME comments
echo ""
echo "📝 Checking for TODO/FIXME markers..."
echo ""

TODOS=$(grep -r "TODO\|FIXME" . --exclude-dir={node_modules,.git} | wc -l)
if [ "$TODOS" -gt 0 ]; then
    echo "Found $TODOS TODO/FIXME items"
    echo "Top 5:"
    grep -r "TODO\|FIXME" . --exclude-dir={node_modules,.git} | head -5
    ISSUES_FOUND=$((ISSUES_FOUND + TODOS))
fi

# 3. Check for common error patterns
echo ""
echo "🔎 Checking for common error patterns..."
echo ""

# Undefined variables
if grep -r "undefined is not" realwork-frontend-master/src 2>/dev/null; then
    echo "⚠️  Found undefined variable errors"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Missing imports
if grep -r "is not defined" realwork-frontend-master/src 2>/dev/null | head -5; then
    echo "⚠️  Found missing imports"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# 4. Check recent git commits for error keywords
echo ""
echo "📜 Analyzing recent changes for issues..."
echo ""

git log --oneline -10 | grep -i "fix\|bug\|error" && {
    echo "ℹ️  Recent commits mention fixes/bugs"
}

# 5. Check for failing tests output
if [ -f "/tmp/test-output.txt" ]; then
    echo ""
    echo "🧪 Analyzing test failures..."
    echo ""
    
    if grep -A 5 "FAIL" /tmp/test-output.txt | head -20; then
        echo ""
        echo "⚠️  Test failures detected"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
        
        # Attempt simple fixes
        echo "Attempting to fix..."
        # This is where AI/ML would analyze and fix
        # For now, log for human review
    fi
fi

# 6. Generate issues list for PLAN.md
echo ""
echo "📋 Updating PLAN.md with found issues..."
echo ""

if [ "$ISSUES_FOUND" -gt 0 ]; then
    # Append to PLAN.md
    echo "" >> agentrovo/PLAN.md
    echo "## 🤖 Auto-Detected Issues ($(date +%Y-%m-%d))" >> agentrovo/PLAN.md
    echo "" >> agentrovo/PLAN.md
    echo "- [ ] Review $TODOS TODO/FIXME items" >> agentrovo/PLAN.md
    echo "- [ ] Address test failures" >> agentrovo/PLAN.md
    echo "- [ ] Fix console errors/warnings" >> agentrovo/PLAN.md
    echo "">> agentrovo/PLAN.md
    
    echo "✅ Issues logged to PLAN.md"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Debug Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Issues found: $ISSUES_FOUND"
echo "Auto-fixed: $ISSUES_FIXED"
echo "Needs review: $((ISSUES_FOUND - ISSUES_FIXED))"
echo ""
