#!/bin/bash
# Quick Verification Script
# Fast checks before considering a fix "done"

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
        return 0
    else
        echo -e "${RED}❌ $2${NC}"
        return 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo "🔍 Quick Verification Checklist"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_TOTAL=0

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit 1

# Check 1: Git status clean or changes are intentional
echo "1. Git Status"
git status --short
if [ -z "$(git status --porcelain)" ]; then
    print_check 0 "No uncommitted changes"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    print_warning "Uncommitted changes present - is this intentional?"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 2: No debug code
echo "2. Debug Code Check"
DEBUG_COUNT=$(grep -r "console.log\|debugger\|pdb.set_trace()" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" --include="*.py" src/ 2>/dev/null | wc -l || echo 0)
if [ "$DEBUG_COUNT" -eq 0 ]; then
    print_check 0 "No debug statements found"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    print_check 1 "Found $DEBUG_COUNT debug statements"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 3: Tests exist and pass
echo "3. Tests Status"
if [ -f "package.json" ] && grep -q '"test"' package.json; then
    npm test -- --passWithNoTests --watchAll=false > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_check 0 "Tests passed"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        print_check 1 "Tests failed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
else
    print_warning "No tests configured"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 4: Linting passes
echo "4. Linting Status"
if [ -f "package.json" ] && grep -q '"lint"' package.json; then
    npm run lint > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_check 0 "Linting passed"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        print_check 1 "Linting failed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
else
    print_warning "No linting configured"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 5: Build succeeds
echo "5. Build Status"
if [ -f "package.json" ] && grep -q '"build"' package.json; then
    npm run build > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_check 0 "Build succeeded"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        print_check 1 "Build failed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
else
    print_warning "No build script configured"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 6: No sensitive data in code
echo "6. Security Check"
SENSITIVE_PATTERNS="password|api_key|secret|token|private_key"
SENSITIVE_COUNT=$(grep -r -i -E "$SENSITIVE_PATTERNS" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" --include="*.py" --exclude-dir={node_modules,.git,dist,build} . 2>/dev/null | grep -v "process.env" | wc -l || echo 0)
if [ "$SENSITIVE_COUNT" -eq 0 ]; then
    print_check 0 "No exposed sensitive data"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    print_check 1 "Found $SENSITIVE_COUNT potential sensitive data exposures"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 7: Dependencies are up to date
echo "7. Dependencies Check"
if [ -f "package.json" ]; then
    OUTDATED=$(npm outdated 2>/dev/null | wc -l)
    if [ "$OUTDATED" -le 1 ]; then
        print_check 0 "Dependencies are up to date"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        print_warning "Some dependencies are outdated ($((OUTDATED - 1)) packages)"
    fi
else
    print_warning "No package.json found"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Check 8: Documentation updated
echo "8. Documentation Check"
if [ -f "CHANGELOG.md" ]; then
    RECENT_CHANGELOG=$(git log -1 --pretty=%H CHANGELOG.md 2>/dev/null || echo "none")
    RECENT_CODE=$(git log -1 --pretty=%H src/ 2>/dev/null || echo "none")
    if [ "$RECENT_CHANGELOG" = "$RECENT_CODE" ] || git diff --cached --name-only | grep -q CHANGELOG.md; then
        print_check 0 "CHANGELOG.md appears updated"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        print_warning "CHANGELOG.md may need updating"
    fi
else
    print_warning "No CHANGELOG.md found"
fi
CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Verification Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total checks: $CHECKS_TOTAL"
echo -e "Passed: ${GREEN}$CHECKS_PASSED ✅${NC}"
echo -e "Failed: ${RED}$CHECKS_FAILED ❌${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed! Ready to deploy.${NC}"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please review before deploying.${NC}"
    exit 1
fi
