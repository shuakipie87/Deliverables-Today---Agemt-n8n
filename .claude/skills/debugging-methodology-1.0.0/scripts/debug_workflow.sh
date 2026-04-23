#!/bin/bash
# Debug Workflow Automation
# Guides through the systematic debugging process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Main debugging workflow
main() {
    print_header "🐛 DEBUGGING WORKFLOW - SYSTEMATIC APPROACH"
    
    # Get project context
    if [ -z "$1" ]; then
        echo "Usage: $0 <project-directory>"
        echo "Example: $0 /home/shuakipie/Projects/koopprijs"
        exit 1
    fi
    
    PROJECT_DIR="$1"
    PHASE="${2:-all}"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    
    cd "$PROJECT_DIR" || exit 1
    print_success "Working in: $PROJECT_DIR"
    
    # Create debug session log
    DEBUG_LOG="debug-session-$(date +%Y%m%d_%H%M%S).log"
    echo "Debug session started: $(date)" > "$DEBUG_LOG"
    
    # Run phases
    case $PHASE in
        "all")
            phase1_investigation
            phase2_analysis
            phase3_solution
            phase4_implementation
            phase5_verification
            phase6_documentation
            ;;
        "1"|"investigate")
            phase1_investigation
            ;;
        "2"|"analyze")
            phase2_analysis
            ;;
        "3"|"solution")
            phase3_solution
            ;;
        "4"|"implement")
            phase4_implementation
            ;;
        "5"|"verify")
            phase5_verification
            ;;
        "6"|"document")
            phase6_documentation
            ;;
        *)
            print_error "Unknown phase: $PHASE"
            echo "Available phases: all, 1-6, investigate, analyze, solution, implement, verify, document"
            exit 1
            ;;
    esac
    
    print_header "🎉 DEBUG WORKFLOW COMPLETE"
    print_success "Debug log saved to: $DEBUG_LOG"
}

# Phase 1: Investigation
phase1_investigation() {
    print_header "PHASE 1: PROBLEM IDENTIFICATION (5-10 min)"
    
    # 1.1: Gather information
    echo "Step 1.1: Gathering system information..."
    {
        echo "=== System Information ==="
        uname -a
        echo ""
        echo "=== Disk Space ==="
        df -h
        echo ""
        echo "=== Memory ==="
        free -h
        echo ""
        echo "=== Node Version ==="
        node --version 2>/dev/null || echo "Node not found"
        echo ""
        echo "=== NPM Version ==="
        npm --version 2>/dev/null || echo "NPM not found"
        echo ""
        echo "=== Python Version ==="
        python3 --version 2>/dev/null || echo "Python not found"
        echo ""
        echo "=== Git Status ==="
        git status 2>/dev/null || echo "Not a git repository"
        echo ""
        echo "=== Recent Git Commits ==="
        git log --oneline -10 2>/dev/null || echo "No git history"
    } | tee -a "$DEBUG_LOG"
    
    print_success "System information collected"
    
    # 1.2: Check for recent errors
    echo ""
    echo "Step 1.2: Checking for errors in logs..."
    
    # Check various log locations
    for log in "*.log" "logs/*.log" "npm-debug.log" "error.log"; do
        if ls $log 1> /dev/null 2>&1; then
            print_info "Found log: $log"
            echo "=== Recent errors in $log ===" | tee -a "$DEBUG_LOG"
            tail -50 $log | grep -i "error\|fail\|exception" | tail -10 | tee -a "$DEBUG_LOG" || print_info "No recent errors"
            echo ""
        fi
    done
    
    # 1.3: Check running processes
    echo ""
    echo "Step 1.3: Checking running processes..."
    if pgrep -f node > /dev/null; then
        print_info "Node processes running:"
        ps aux | grep node | grep -v grep | tee -a "$DEBUG_LOG"
    else
        print_warning "No Node processes found"
    fi
    
    if pgrep -f python > /dev/null; then
        print_info "Python processes running:"
        ps aux | grep python | grep -v grep | tee -a "$DEBUG_LOG"
    fi
    
    print_success "Phase 1 complete - Investigation done"
    
    # Prompt for issue description
    echo ""
    read -p "Do you want to describe the issue? (y/n): " describe
    if [ "$describe" = "y" ]; then
        read -p "Issue title: " issue_title
        read -p "Severity (critical/high/medium/low): " severity
        echo ""
        echo "## Issue: $issue_title" | tee -a "$DEBUG_LOG"
        echo "**Severity:** $severity" | tee -a "$DEBUG_LOG"
        echo "**First Observed:** $(date)" | tee -a "$DEBUG_LOG"
        echo "" | tee -a "$DEBUG_LOG"
        print_success "Issue documented"
    fi
}

# Phase 2: Root Cause Analysis
phase2_analysis() {
    print_header "PHASE 2: ROOT CAUSE ANALYSIS (15-30 min)"
    
    # 2.1: Reproduce issue
    echo "Step 2.1: Attempting to reproduce..."
    print_info "This is an interactive step - run your reproduction steps manually"
    
    # 2.2: Check dependencies
    echo ""
    echo "Step 2.2: Checking dependencies..."
    
    if [ -f "package.json" ]; then
        print_info "Node.js project detected"
        echo "=== Installed Packages ===" | tee -a "$DEBUG_LOG"
        npm list --depth=0 2>&1 | tee -a "$DEBUG_LOG"
        
        echo ""
        echo "=== Outdated Packages ===" | tee -a "$DEBUG_LOG"
        npm outdated 2>&1 | tee -a "$DEBUG_LOG" || print_info "All packages up to date"
        
        echo ""
        echo "=== Security Audit ===" | tee -a "$DEBUG_LOG"
        npm audit 2>&1 | head -20 | tee -a "$DEBUG_LOG"
    fi
    
    if [ -f "requirements.txt" ]; then
        print_info "Python project detected"
        echo "=== Installed Python Packages ===" | tee -a "$DEBUG_LOG"
        pip list 2>&1 | tee -a "$DEBUG_LOG"
        
        echo ""
        echo "=== Package Conflicts ===" | tee -a "$DEBUG_LOG"
        pip check 2>&1 | tee -a "$DEBUG_LOG"
    fi
    
    # 2.3: Analyze code patterns
    echo ""
    echo "Step 2.3: Analyzing code for common issues..."
    
    # Check for common anti-patterns
    print_info "Checking for console.log statements..."
    CONSOLE_LOGS=$(grep -r "console.log\|console.error" --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" . 2>/dev/null | wc -l)
    if [ "$CONSOLE_LOGS" -gt 0 ]; then
        print_warning "Found $CONSOLE_LOGS console log statements"
    else
        print_success "No console logs found"
    fi
    
    print_info "Checking for TODO/FIXME markers..."
    TODOS=$(grep -r "TODO\|FIXME" --exclude-dir={node_modules,.git} . 2>/dev/null | wc -l)
    if [ "$TODOS" -gt 0 ]; then
        print_warning "Found $TODOS TODO/FIXME items"
        echo "Top 5 TODOs:" | tee -a "$DEBUG_LOG"
        grep -r "TODO\|FIXME" --exclude-dir={node_modules,.git} . 2>/dev/null | head -5 | tee -a "$DEBUG_LOG"
    else
        print_success "No TODOs found"
    fi
    
    print_info "Checking for potential null/undefined issues..."
    NULL_CHECKS=$(grep -r "if.*null\|if.*undefined" --include="*.js" --include="*.jsx" . 2>/dev/null | wc -l)
    echo "Found $NULL_CHECKS null/undefined checks in code" | tee -a "$DEBUG_LOG"
    
    print_success "Phase 2 complete - Analysis done"
}

# Phase 3: Solution Design
phase3_solution() {
    print_header "PHASE 3: SOLUTION DESIGN (10-20 min)"
    
    echo "Step 3.1: Designing solution..."
    print_info "This phase requires human input - documenting current state"
    
    # Create a fix plan template
    FIX_PLAN="fix-plan-$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$FIX_PLAN" << 'EOF'
# Fix Plan

## Hypothesis
[What you think is wrong]

## Evidence Supporting
- [Point 1]
- [Point 2]
- [Point 3]

## Solution Strategy

### Changes Required
1. **File:** path/to/file
   - **Change:** What to modify
   - **Why:** Explanation
   - **Risk:** Low/Medium/High

### Testing Plan
1. [ ] Unit tests to add/modify
2. [ ] Integration tests
3. [ ] Manual verification steps

### Rollback Plan
- Git branch: bugfix/[issue-name]
- Backup files: [list]
- Rollback procedure: [steps]

## Timeline
- Investigation: [time]
- Implementation: [time]
- Testing: [time]
- Deployment: [time]

EOF
    
    print_success "Fix plan template created: $FIX_PLAN"
    print_info "Edit this file to document your solution strategy"
    
    # Create git branch for the fix
    read -p "Create a git branch for this fix? (y/n): " create_branch
    if [ "$create_branch" = "y" ]; then
        read -p "Branch name (e.g., bugfix/issue-description): " branch_name
        git checkout -b "$branch_name" && print_success "Branch created: $branch_name"
    fi
}

# Phase 4: Implementation
phase4_implementation() {
    print_header "PHASE 4: IMPLEMENTATION (20-60 min)"
    
    echo "Step 4.1: Preparing safe environment..."
    
    # Backup critical files
    print_info "Creating backups..."
    BACKUP_DIR="backups/backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup common config files
    for file in ".env" "config.json" "package.json" "package-lock.json" "docker-compose.yml"; do
        if [ -f "$file" ]; then
            cp "$file" "$BACKUP_DIR/" && print_success "Backed up: $file"
        fi
    done
    
    print_success "Backups created in: $BACKUP_DIR"
    
    echo ""
    echo "Step 4.2: Ready for implementation"
    print_info "Now implement your fix..."
    print_info "Remember to:"
    echo "  - Make changes incrementally"
    echo "  - Test after each change"
    echo "  - Commit frequently with clear messages"
    
    read -p "Press Enter when implementation is complete..."
    
    echo ""
    echo "Step 4.3: Reviewing changes..."
    git status
    echo ""
    git diff --stat
}

# Phase 5: Verification
phase5_verification() {
    print_header "PHASE 5: TESTING & VERIFICATION (30-45 min)"
    
    # 5.1: Run tests
    echo "Step 5.1: Running tests..."
    
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            print_info "Running npm tests..."
            npm test 2>&1 | tee -a "$DEBUG_LOG" && print_success "Tests passed" || print_error "Tests failed"
        else
            print_warning "No test script found in package.json"
        fi
    fi
    
    if [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
        print_info "Running pytest..."
        pytest 2>&1 | tee -a "$DEBUG_LOG" && print_success "Tests passed" || print_error "Tests failed"
    fi
    
    # 5.2: Lint check
    echo ""
    echo "Step 5.2: Running linters..."
    
    if [ -f "package.json" ] && grep -q '"lint"' package.json; then
        print_info "Running eslint..."
        npm run lint 2>&1 | tee -a "$DEBUG_LOG" && print_success "Linting passed" || print_warning "Linting issues found"
    fi
    
    # 5.3: Check for debug code
    echo ""
    echo "Step 5.3: Checking for debug code..."
    
    DEBUG_CODE=$(grep -r "console.log\|debugger\|pdb.set_trace()\|print(" --include="*.js" --include="*.jsx" --include="*.py" src/ 2>/dev/null | wc -l)
    if [ "$DEBUG_CODE" -gt 0 ]; then
        print_warning "Found $DEBUG_CODE debug statements - consider removing before commit"
        grep -r "console.log\|debugger\|pdb.set_trace()" --include="*.js" --include="*.jsx" --include="*.py" src/ 2>/dev/null | head -5
    else
        print_success "No debug code found"
    fi
    
    # 5.4: Build check
    echo ""
    echo "Step 5.4: Checking build..."
    
    if [ -f "package.json" ] && grep -q '"build"' package.json; then
        print_info "Running build..."
        npm run build 2>&1 | tail -20 | tee -a "$DEBUG_LOG" && print_success "Build successful" || print_error "Build failed"
    fi
    
    print_success "Phase 5 complete - Verification done"
}

# Phase 6: Documentation
phase6_documentation() {
    print_header "PHASE 6: DOCUMENTATION & CLEANUP (15-30 min)"
    
    echo "Step 6.1: Creating documentation..."
    
    # Generate fix documentation
    FIX_DOC="FIX_DOCUMENTATION_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$FIX_DOC" << 'EOF'
# Fix Documentation

## Issue Summary
[Brief description of the problem]

## Root Cause
[What actually caused the issue]

## Solution Implemented
[What was changed to fix it]

## Files Modified
- `path/to/file1` - [description of changes]
- `path/to/file2` - [description of changes]

## Testing Performed
- [ ] Unit tests passed
- [ ] Integration tests passed
- [ ] Manual verification complete
- [ ] Regression tests passed

## Deployment Notes
- [ ] Update environment variables
- [ ] Run migrations
- [ ] Clear cache
- [ ] Restart services

## Monitoring
Watch these metrics post-deployment:
- Error rate (should decrease)
- Response time (should stay same/improve)
- Memory usage (should stay stable)

## Rollback Plan
If issues arise:
1. `git revert [commit-hash]`
2. Restore from backup
3. Restart services
4. Monitor for 15 minutes

EOF
    
    print_success "Fix documentation template created: $FIX_DOC"
    
    # Update CHANGELOG if exists
    echo ""
    echo "Step 6.2: Updating CHANGELOG..."
    
    if [ -f "CHANGELOG.md" ]; then
        read -p "Add entry to CHANGELOG.md? (y/n): " update_changelog
        if [ "$update_changelog" = "y" ]; then
            read -p "Brief description of fix: " fix_description
            {
                echo ""
                echo "## [Unreleased] - $(date +%Y-%m-%d)"
                echo ""
                echo "### Fixed"
                echo "- $fix_description"
                echo ""
            } >> CHANGELOG.md
            print_success "CHANGELOG.md updated"
        fi
    else
        print_info "No CHANGELOG.md found - consider creating one"
    fi
    
    # Cleanup
    echo ""
    echo "Step 6.3: Cleanup..."
    
    print_info "Removing temporary files..."
    rm -f *.log.* *.backup.* test-output-*.txt 2>/dev/null && print_success "Temporary files removed"
    
    # Git commit helper
    echo ""
    echo "Step 6.4: Git workflow..."
    
    git status
    echo ""
    read -p "Ready to commit changes? (y/n): " ready_commit
    
    if [ "$ready_commit" = "y" ]; then
        read -p "Commit message: " commit_msg
        git add -A
        git commit -m "$commit_msg" && print_success "Changes committed"
        
        read -p "Push to remote? (y/n): " push_remote
        if [ "$push_remote" = "y" ]; then
            git push && print_success "Changes pushed to remote"
        fi
    fi
    
    print_success "Phase 6 complete - Documentation and cleanup done"
}

# Run main function
main "$@"
