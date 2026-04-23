#!/bin/bash
# AI-Powered Fixes using RovoDev and Claude Code CLI

PROJECT_DIR="/home/shuakipie/Projects/koopprijs"
cd "$PROJECT_DIR" || exit 1

echo "🤖 AI-Powered Fixes with RovoDev + Claude Code"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. RovoDev Analysis & Fixes
echo "🧠 Step 1: RovoDev Agent Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Use RovoDev with agents for intelligent analysis
cat > /tmp/rovodev-commands.txt << 'EOF'
@planner analyze the codebase for bugs, code smells, and improvements
@developer identify and fix all ESLint errors
@developer optimize imports and remove unused code
@tester run all tests and fix any failures
@reviewer check code quality and suggest improvements
EOF

echo "Starting RovoDev with autonomous agent workflow..."

# Run RovoDev in non-interactive mode
cd "$PROJECT_DIR"
timeout 300 acli rovodev run @planner "analyze PLAN.md and codebase for issues to fix tonight" 2>&1 | tee /tmp/rovodev-analysis.log

echo ""
echo "✅ RovoDev analysis complete"
echo ""

# 2. Claude Code CLI for Smart Fixes
echo "🔮 Step 2: Claude Code CLI - AI-Powered Fixes"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Frontend fixes with Claude Code
if [ -d "realwork-frontend-master/src" ]; then
    echo "Analyzing frontend code with Claude Code..."
    
    # Use Claude Code to fix specific issues
    if command -v claude-code &> /dev/null; then
        # Fix ESLint errors
        claude-code fix --file "realwork-frontend-master/src/**/*.jsx" \
                        --instruction "Fix all ESLint errors and warnings" \
                        --auto-approve 2>&1 | tee -a /tmp/claude-fixes.log
        
        # Optimize React components
        claude-code improve --file "realwork-frontend-master/src/components/**/*.jsx" \
                           --instruction "Optimize React components for performance and best practices" \
                           --auto-approve 2>&1 | tee -a /tmp/claude-fixes.log
        
        # Fix TypeScript errors
        claude-code fix --file "realwork-frontend-master/src/**/*.tsx" \
                       --instruction "Fix all TypeScript type errors" \
                       --auto-approve 2>&1 | tee -a /tmp/claude-fixes.log
        
        echo "✅ Claude Code fixes applied to frontend"
    else
        echo "⚠️  Claude Code CLI not found, skipping AI fixes"
    fi
fi

# 3. RovoDev with specific agents for targeted fixes
echo ""
echo "🎯 Step 3: Agent-Specific Fixes"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Use @developer for code fixes
echo "Using @developer agent for code improvements..."
timeout 300 acli rovodev run @developer "fix all linting errors and format code properly" 2>&1 | tee -a /tmp/rovodev-developer.log

# Use @tester for test fixes
echo "Using @tester agent for test improvements..."
timeout 300 acli rovodev run @tester "run tests, fix failures, improve test coverage" 2>&1 | tee -a /tmp/rovodev-tester.log

# Use @reviewer for code quality
echo "Using @reviewer agent for code review..."
timeout 300 acli rovodev run @reviewer "review recent changes and suggest optimizations" 2>&1 | tee -a /tmp/rovodev-reviewer.log

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ AI-Powered fixes complete!"
echo "📊 Logs saved:"
echo "   - RovoDev: /tmp/rovodev-*.log"
echo "   - Claude Code: /tmp/claude-fixes.log"
echo ""
