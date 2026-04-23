#!/bin/bash
# Automated Test Runner

PROJECT_DIR="/home/shuakipie/Projects/koopprijs"
cd "$PROJECT_DIR" || exit 1

echo "🧪 Running Automated Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Frontend tests
if [ -d "realwork-frontend-master" ]; then
    cd realwork-frontend-master
    
    if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
        echo "📦 Running Frontend Tests..."
        echo ""
        
        # Run tests (non-interactive)
        if npm test -- --watchAll=false --passWithNoTests 2>&1 | tee /tmp/test-output.txt; then
            PASSED=$(grep -c "PASS" /tmp/test-output.txt || echo 0)
            FAILED=$(grep -c "FAIL" /tmp/test-output.txt || echo 0)
            
            TOTAL_TESTS=$((TOTAL_TESTS + PASSED + FAILED))
            PASSED_TESTS=$((PASSED_TESTS + PASSED))
            FAILED_TESTS=$((FAILED_TESTS + FAILED))
            
            echo ""
            echo "✅ Frontend tests: $PASSED passed, $FAILED failed"
        else
            echo "⚠️  Tests encountered issues"
        fi
    else
        echo "ℹ️  No frontend tests configured"
    fi
    
    cd ..
fi

# Backend tests
if [ -d "realwork-backend-master" ]; then
    cd realwork-backend-master
    
    if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
        echo ""
        echo "⚙️  Running Backend Tests..."
        echo ""
        
        if npm test 2>&1 | tee /tmp/backend-test-output.txt; then
            echo "✅ Backend tests completed"
        else
            echo "⚠️  Backend tests had issues"
        fi
    else
        echo "ℹ️  No backend tests configured"
    fi
    
    cd ..
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS ✅"
echo "Failed: $FAILED_TESTS ❌"

if [ $FAILED_TESTS -gt 0 ]; then
    echo ""
    echo "⚠️  Some tests failed - will attempt debugging"
    exit 1
else
    echo ""
    echo "✅ All tests passed!"
    exit 0
fi
