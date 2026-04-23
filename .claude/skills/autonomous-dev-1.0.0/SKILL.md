# Autonomous Development Skill - Sleep Mode

**Let Clawdbot work autonomously while you sleep: fix bugs, edit code, debug issues**

## Vision

You sleep 😴 → Clawdbot works 🤖 → You wake up to fixed code ✅

---

## Autonomous Workflow

### Night Shift (11 PM - 6 AM)

**What Clawdbot does while you sleep:**

1. **Analyze PLAN.md** - Find pending tasks
2. **Identify Issues** - Scan code for bugs, TODOs, errors
3. **Auto-Fix Simple Issues** - Fix linting, formatting, simple bugs
4. **Run Tests** - Execute test suites, catch failures
5. **Debug Failures** - Analyze errors, attempt fixes
6. **Git Commit** - Save progress with descriptive messages
7. **Generate Report** - Morning report of what was fixed

---

## Capabilities

### Level 1: Safe Automation ✅
- Fix linting errors
- Format code
- Update dependencies
- Run tests
- Fix simple bugs
- Commit changes

### Level 2: Smart Fixes 🧠
- Analyze error logs
- Fix common patterns
- Refactor code smells
- Optimize performance
- Update documentation

### Level 3: Advanced (Requires Review) ⚠️
- Implement new features
- Major refactoring
- Architecture changes
- Database migrations

---

## Safety Features

**Before making changes:**
- ✅ Create backup branch
- ✅ Run tests first
- ✅ Only fix with >90% confidence
- ✅ Mark uncertain changes for review
- ✅ Never delete data
- ✅ Always git commit with details

**If uncertain:**
- 📝 Create issue in PLAN.md
- 🏷️ Tag for human review
- 📊 Log analysis for morning

---

## Scripts

### 1. `night_shift.sh` - Main Night Automation
Runs from 11 PM - 6 AM, orchestrates all autonomous work

### 2. `auto_fix.sh` - Automatic Code Fixes
Fixes linting, formatting, simple bugs

### 3. `debug_analyzer.sh` - Debug Failures
Analyzes errors, suggests fixes, attempts resolution

### 4. `test_runner.sh` - Automated Testing
Runs all tests, reports failures, attempts fixes

### 5. `morning_report.sh` - What Happened While You Slept
Generates detailed report of autonomous work

---

## Trigger Phrases

- "Enable night shift mode"
- "Start autonomous development"
- "Work while I sleep"
- "Auto-fix bugs tonight"
- "Debug overnight"

---

## Autonomous Task Examples

**Clawdbot can handle overnight:**

✅ Fix ESLint errors
✅ Format with Prettier
✅ Update npm packages
✅ Fix TypeScript errors
✅ Run and fix failing tests
✅ Fix simple logic bugs
✅ Update documentation
✅ Optimize imports
✅ Remove unused code
✅ Fix console warnings

⚠️ Needs review:
- New feature implementation
- API changes
- Database schema changes
- Major refactoring

---

## Integration with RovoDev Agents

**Night shift uses agents:**

- **@developer** - Implements fixes
- **@tester** - Runs tests, verifies fixes
- **@reviewer** - Reviews changes before commit
- **@debugger** - Analyzes errors and failures

---

## Morning Report Format

```
🌅 Good Morning! Here's what happened overnight:

✅ Fixed Issues (8):
  - Fixed ESLint errors in PropertyCard.jsx
  - Resolved TypeScript warning in EmployeeStats
  - Updated 3 dependencies
  - Fixed test failure in auth.test.js
  - Optimized database query performance
  - Removed 5 unused imports
  - Updated README with latest changes
  - Fixed formatting in 12 files

⚠️ Needs Your Review (3):
  - Complex bug in login flow (attempted fix in branch: fix/login-bug)
  - Performance optimization suggestion for API calls
  - Potential refactoring opportunity in user module

❌ Could Not Fix (1):
  - Database connection issue (requires configuration)

📊 Statistics:
  - Files modified: 23
  - Tests passed: 187/190 (3 need attention)
  - Code quality: +12% improvement
  - Test coverage: 78% → 81%
  - Build time: Reduced by 8 seconds

🔗 Commits:
  - abc123: Fix ESLint errors in components
  - def456: Update dependencies to latest
  - ghi789: Fix failing auth tests
  - jkl012: Optimize database queries

📋 Next Actions:
  1. Review fix/login-bug branch
  2. Check 3 failing tests
  3. Update database configuration
```

---

**This skill enables true autonomous development while you sleep!**
