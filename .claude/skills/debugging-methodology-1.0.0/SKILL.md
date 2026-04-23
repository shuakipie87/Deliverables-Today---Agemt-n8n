# 🐛 Debugging Methodology Skill

**Version:** 1.0.0  
**Created:** 2026-01-31  
**Owner:** Joshua Dingcong (shuakipie)  
**Purpose:** Learn and apply systematic debugging and verification methodology

---

## 📋 Overview

This skill teaches Clawdbot the systematic approach to debugging, fixing issues, and verifying solutions - step by step, just like Joshua does it.

---

## 🎯 Core Philosophy

**"Debug Methodically, Fix Precisely, Verify Thoroughly"**

### The Three Pillars

1. **🔍 Investigation** - Understand the problem completely
2. **🔧 Resolution** - Apply targeted fixes
3. **✅ Verification** - Confirm the solution works

---

## 🔄 The Complete Debugging Cycle

### Phase 1: Problem Identification (5-10 min)

#### Step 1.1: Gather Initial Information
```bash
# What to collect:
- Error messages (exact text)
- Stack traces (full output)
- User reports or observed behavior
- Environment details (OS, versions, etc.)
```

**Questions to Ask:**
- What exactly broke?
- When did it start failing?
- What changed recently?
- Can I reproduce it?

#### Step 1.2: Document the Problem
```markdown
## Issue: [Brief Title]

**Severity:** Critical / High / Medium / Low
**Impact:** Who/what is affected?
**First Observed:** Date and time
**Reproducible:** Yes/No/Sometimes

### Symptoms:
- List all observed symptoms
- Include error messages
- Note any patterns

### Context:
- What was happening when it failed?
- Recent changes (code, config, env)
- Related systems affected
```

#### Step 1.3: Quick Environment Check
```bash
# System health check
echo "=== Quick Environment Check ==="

# 1. Check system resources
df -h                    # Disk space
free -h                  # Memory
top -bn1 | head -20     # CPU/processes

# 2. Check service status
systemctl status [service] || service [service] status

# 3. Check logs for errors
tail -100 /var/log/syslog | grep -i error
journalctl -xe --no-pager | tail -50

# 4. Check network (if relevant)
ping -c 3 google.com
curl -I https://api.endpoint.com
```

---

### Phase 2: Root Cause Analysis (15-30 min)

#### Step 2.1: Reproduce the Issue
```bash
# Create a minimal reproduction
echo "=== Reproducing Issue ==="

# For web apps:
curl -X POST https://endpoint/api \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' \
  -v

# For code:
node reproduce-bug.js
python test_issue.py

# Document:
# - Exact steps to reproduce
# - Expected behavior
# - Actual behavior
```

#### Step 2.2: Isolate the Problem
```bash
# Binary search approach:
# 1. Which component is failing?
# 2. Which function/module?
# 3. Which line of code?

# Enable debug logging
export DEBUG=*
export LOG_LEVEL=debug

# Run with verbose output
npm run dev --verbose
python manage.py runserver --verbosity 3

# Use debugging tools
node --inspect app.js
python -m pdb script.py
```

#### Step 2.3: Analyze Logs and Traces
```bash
# Systematic log analysis
echo "=== Log Analysis ==="

# 1. Application logs
tail -1000 app.log | grep -E "(ERROR|FATAL|Exception)"

# 2. Group by error type
grep "Error:" app.log | sort | uniq -c | sort -rn

# 3. Timeline analysis
grep "2026-01-31 20:" app.log | grep -i error

# 4. Correlation with other events
grep -B 5 -A 5 "ERROR" app.log > error-context.txt
```

#### Step 2.4: Check Dependencies and Versions
```bash
# Verify all dependencies
echo "=== Dependency Check ==="

# Node.js
npm list --depth=0
npm outdated

# Python
pip list
pip check

# System packages
dpkg -l | grep [package]
apt list --installed | grep [package]

# Environment variables
printenv | grep -E "(PATH|NODE|PYTHON|API)"
```

---

### Phase 3: Solution Design (10-20 min)

#### Step 3.1: Research Similar Issues
```bash
# Search strategies:
# 1. Exact error message
# 2. Library/framework + error keywords
# 3. Version-specific issues

# Resources to check:
- GitHub Issues
- Stack Overflow
- Official documentation
- Change logs
```

#### Step 3.2: Develop Hypothesis
```markdown
## Hypothesis: [What you think is wrong]

### Evidence Supporting:
- [Point 1]
- [Point 2]
- [Point 3]

### Alternative Explanations:
- [Alternative 1]
- [Alternative 2]

### Test Plan:
1. [How to test hypothesis]
2. [Expected result if correct]
3. [What to do if wrong]
```

#### Step 3.3: Plan the Fix
```markdown
## Fix Strategy

### Approach: [Quick description]

### Changes Required:
1. **File:** path/to/file.js
   - **Change:** What to modify
   - **Why:** Explanation
   - **Risk:** Low/Medium/High

2. **File:** path/to/another.py
   - **Change:** What to modify
   - **Why:** Explanation
   - **Risk:** Low/Medium/High

### Backup Plan:
- Git branch: bugfix/issue-name
- Backup config: config.backup
- Rollback procedure: [steps]

### Testing Plan:
1. Unit tests to add/modify
2. Integration tests
3. Manual verification steps
```

---

### Phase 4: Implementation (20-60 min)

#### Step 4.1: Prepare Safe Environment
```bash
# Safety first!
echo "=== Preparing for Fix ==="

# 1. Create git branch
git checkout -b bugfix/issue-description
git status

# 2. Backup critical files
cp config.json config.json.backup.$(date +%Y%m%d_%H%M%S)
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)

# 3. Document current state
git diff > before-fix.patch
npm list > packages-before.txt
ps aux > processes-before.txt
```

#### Step 4.2: Apply the Fix
```bash
# Methodical fixing process
echo "=== Applying Fix ==="

# 1. Make changes incrementally
# 2. Test after each change
# 3. Commit frequently

# Example workflow:
git add file1.js
git commit -m "Fix: Update error handling in file1"

git add file2.js  
git commit -m "Fix: Add null check in file2"

# Keep commits atomic and descriptive
```

#### Step 4.3: Handle Dependencies
```bash
# If dependencies need updating
echo "=== Updating Dependencies ==="

# Node.js
npm install package@version --save
npm update package
npm dedupe

# Python
pip install --upgrade package
pip install -r requirements.txt

# Verify compatibility
npm audit
pip check
```

---

### Phase 5: Testing & Verification (30-45 min)

#### Step 5.1: Unit Testing
```bash
# Run existing tests first
echo "=== Unit Tests ==="

# Node.js
npm test
npm run test:unit

# Python
pytest tests/
python -m unittest discover

# Check coverage
npm run test:coverage
pytest --cov=app tests/

# Document results:
# - Tests passed: X/Y
# - Coverage: Z%
# - New failures: [list]
```

#### Step 5.2: Integration Testing
```bash
# Test with real/realistic data
echo "=== Integration Tests ==="

# 1. Start services
docker-compose up -d
npm run dev &

# 2. Run integration suite
npm run test:integration
pytest tests/integration/

# 3. Manual API testing
curl -X GET http://localhost:3000/api/health
curl -X POST http://localhost:3000/api/test \
  -H "Content-Type: application/json" \
  -d @test-data.json

# 4. Check logs during tests
tail -f app.log | grep -i "error\|warn"
```

#### Step 5.3: Reproduction Verification
```bash
# Verify the ORIGINAL issue is fixed
echo "=== Reproduction Test ==="

# 1. Reproduce original bug steps
# 2. Confirm it no longer fails
# 3. Document the result

# Example:
node reproduce-original-bug.js
echo "Exit code: $?"  # Should be 0 now

# Take screenshots/logs as proof
```

#### Step 5.4: Regression Testing
```bash
# Make sure nothing else broke
echo "=== Regression Testing ==="

# 1. Run full test suite
npm run test:all
pytest tests/ --verbose

# 2. Test critical user flows
# - User login
# - Data creation
# - Data retrieval
# - Data updates
# - Error handling

# 3. Performance check
npm run test:performance
ab -n 1000 -c 10 http://localhost:3000/

# 4. Memory leak check
node --inspect --expose-gc app.js
# Monitor memory usage over time
```

#### Step 5.5: Cross-Environment Testing
```bash
# Test in multiple environments
echo "=== Cross-Environment Tests ==="

# 1. Development
NODE_ENV=development npm start

# 2. Staging
NODE_ENV=staging npm start

# 3. Production-like
NODE_ENV=production npm start

# Check environment-specific issues:
# - API keys working?
# - Database connections?
# - External services?
# - CORS/security settings?
```

---

### Phase 6: Documentation & Cleanup (15-30 min)

#### Step 6.1: Document the Fix
```markdown
## Fix Documentation

### Issue Summary
[Brief description of the problem]

### Root Cause
[What actually caused the issue]

### Solution Implemented
[What was changed to fix it]

### Files Modified
- `path/to/file1.js` - [description of changes]
- `path/to/file2.py` - [description of changes]
- `config/settings.json` - [description of changes]

### Testing Performed
- [x] Unit tests passed (45/45)
- [x] Integration tests passed (12/12)
- [x] Manual verification complete
- [x] Regression tests passed
- [x] Production smoke test passed

### Deployment Notes
- [ ] Update environment variables
- [ ] Run migrations
- [ ] Clear cache
- [ ] Restart services

### Monitoring
Watch these metrics post-deployment:
- Error rate (should decrease)
- Response time (should stay same/improve)
- Memory usage (should stay stable)

### Rollback Plan
If issues arise:
1. `git revert [commit-hash]`
2. `npm install` (restore packages)
3. Restart services
4. Monitor for 15 minutes
```

#### Step 6.2: Update Related Documentation
```bash
# Update all relevant docs
echo "=== Updating Documentation ==="

# 1. README.md (if setup changed)
# 2. API docs (if endpoints changed)
# 3. CHANGELOG.md
# 4. Troubleshooting guide

# Example CHANGELOG entry:
cat >> CHANGELOG.md << EOF

## [1.2.3] - $(date +%Y-%m-%d)

### Fixed
- Fixed [issue description] by [solution summary]
- Resolved [another issue] affecting [component]

### Changed
- Updated [dependency] from X.X to Y.Y for security fix

EOF
```

#### Step 6.3: Clean Up
```bash
# Remove temporary files and artifacts
echo "=== Cleanup ==="

# 1. Remove debug code
grep -r "console.log\|debugger\|pdb.set_trace()" src/ && \
  echo "⚠️  Remove debug statements before committing"

# 2. Remove temp files
rm -f *.backup.*
rm -f /tmp/debug-*
rm -f test-output-*.txt

# 3. Format code
npm run format
black .
prettier --write "src/**/*.{js,jsx,ts,tsx}"

# 4. Lint check
npm run lint
flake8 .
eslint src/

# 5. Optimize imports
# Remove unused imports (use IDE or tools)
```

#### Step 6.4: Commit & Push
```bash
# Proper git workflow
echo "=== Git Workflow ==="

# 1. Review all changes
git status
git diff

# 2. Stage files logically
git add src/fixed-file.js
git add tests/test-fix.js

# 3. Commit with clear message
git commit -m "Fix: [Brief description]

- Root cause: [explanation]
- Solution: [what was done]
- Testing: [verification performed]

Fixes #123"

# 4. Push to remote
git push origin bugfix/issue-description

# 5. Create Pull Request
# Include:
# - Problem description
# - Solution explanation
# - Testing evidence
# - Screenshots/logs
# - Reviewer checklist
```

---

### Phase 7: Deployment & Monitoring (30-60 min)

#### Step 7.1: Pre-Deployment Checklist
```bash
# Final checks before deployment
echo "=== Pre-Deployment Checklist ==="

# [ ] All tests passing
npm test && echo "✅ Tests pass" || echo "❌ Tests failing"

# [ ] Code reviewed and approved
# [ ] Documentation updated
# [ ] Environment variables configured
# [ ] Database migrations ready
# [ ] Rollback plan documented

# [ ] Staging deployment successful
git checkout staging
git merge bugfix/issue-description
npm run deploy:staging

# Test in staging for 1-2 hours
```

#### Step 7.2: Deploy to Production
```bash
# Careful production deployment
echo "=== Production Deployment ==="

# 1. Announce maintenance (if needed)
# Send notification to users

# 2. Create production backup
pg_dump database > backup-$(date +%Y%m%d_%H%M%S).sql
tar -czf files-backup-$(date +%Y%m%d_%H%M%S).tar.gz /var/www/app/

# 3. Deploy
git checkout production
git merge bugfix/issue-description
npm run deploy:production

# 4. Run migrations
npm run migrate
python manage.py migrate

# 5. Restart services
sudo systemctl restart app
docker-compose restart
pm2 restart all

# 6. Wait 2-3 minutes for stabilization
sleep 180
```

#### Step 7.3: Post-Deployment Monitoring
```bash
# Watch for issues after deployment
echo "=== Monitoring (first 30 minutes critical) ==="

# 1. Check logs continuously
tail -f /var/log/app/error.log | grep -i "error\|fatal\|exception"

# 2. Monitor error rates
watch -n 10 'curl -s http://localhost:9090/metrics | grep error_rate'

# 3. Check response times
ab -n 100 -c 10 https://production-url.com/api/health

# 4. Monitor system resources
htop
docker stats
pm2 monit

# 5. User feedback
# Check support channels
# Monitor error tracking (Sentry, etc.)
```

#### Step 7.4: Verification in Production
```bash
# Verify the fix in production
echo "=== Production Verification ==="

# 1. Reproduce original issue
# (Should NOT be able to reproduce now)

# 2. Test main user flows
curl -X POST https://api.prod.com/critical-endpoint \
  -H "Authorization: Bearer $TOKEN" \
  -d @test-case.json

# 3. Check metrics dashboard
# - Error rate: Should drop
# - Success rate: Should increase
# - Response time: Should be stable
# - User satisfaction: Should improve

# 4. Smoke test all features
# Run automated smoke tests
npm run test:smoke:production
```

---

## 🛠️ Essential Debugging Tools

### Code Investigation
```bash
# Find files containing specific code
grep -r "function_name" src/

# Find files modified recently
find . -name "*.js" -mtime -7

# Count lines of code
cloc src/

# Find large files
find . -type f -size +1M

# Check file permissions
ls -la path/to/file
```

### Process Management
```bash
# Find process by port
lsof -i :3000
netstat -tulpn | grep 3000

# Kill stuck processes
pkill -f node
killall python

# Check process resources
ps aux | grep node
top -p $(pgrep node)
```

### Network Debugging
```bash
# Test API endpoint
curl -v https://api.example.com/endpoint

# Check DNS resolution
dig example.com
nslookup example.com

# Test connection
telnet api.example.com 443
nc -zv api.example.com 443

# Monitor network traffic
tcpdump -i any port 3000
wireshark (GUI)
```

### Database Debugging
```bash
# PostgreSQL
psql -U user -d database -c "SELECT * FROM logs ORDER BY created_at DESC LIMIT 10;"

# MySQL
mysql -u user -p database -e "SHOW PROCESSLIST;"

# MongoDB
mongo
> use mydb
> db.collection.find().sort({created: -1}).limit(10)

# Redis
redis-cli
> MONITOR
```

---

## 📊 Debugging Decision Tree

```
Issue Reported
    │
    ├─→ Can reproduce? 
    │   ├─→ YES: Go to Phase 2 (Root Cause Analysis)
    │   └─→ NO: Gather more info from Phase 1
    │
    ├─→ Is it urgent?
    │   ├─→ CRITICAL: Quick fix + proper fix later
    │   └─→ NOT CRITICAL: Follow full process
    │
    ├─→ Type of issue?
    │   ├─→ BUG: Debug + Fix + Test
    │   ├─→ PERFORMANCE: Profile + Optimize + Benchmark
    │   ├─→ SECURITY: Assess + Patch + Audit
    │   └─→ UX: Understand + Redesign + User Test
    │
    └─→ Impact?
        ├─→ All users: Emergency deploy
        ├─→ Some users: Targeted fix
        └─→ Edge case: Document + low priority
```

---

## 🎓 Common Debugging Patterns

### Pattern 1: "It Works on My Machine"
```bash
# Check environment differences
diff .env.local .env.production
diff package.json package-lock.json

# Verify versions
node --version
npm --version
python --version

# Check OS-specific issues
uname -a
cat /etc/os-release
```

### Pattern 2: "It Was Working Yesterday"
```bash
# What changed?
git log --since="yesterday" --oneline
git diff HEAD@{yesterday}

# Check recent deployments
git log --all --graph --oneline --since="24 hours ago"

# Review recent package updates
git diff HEAD@{yesterday} package.json
```

### Pattern 3: "Intermittent Failure"
```bash
# Race condition? Run multiple times
for i in {1..100}; do
  npm test || echo "Failed on iteration $i"
done

# Timing issue? Add delays
sleep 2 && run_test

# Memory leak? Monitor over time
watch -n 5 'ps aux | grep node'
```

### Pattern 4: "Works in Dev, Fails in Prod"
```bash
# Check environment variables
diff <(set | sort) <(production-ssh set | sort)

# Check file permissions
ls -la /var/www/app

# Check network/firewall
telnet db-prod.example.com 5432

# Check resource limits
ulimit -a
```

---

## ✅ Verification Checklist

Use this before marking ANY fix as "done":

### Code Quality
- [ ] All tests passing (unit + integration)
- [ ] No new linting errors
- [ ] Code formatted consistently
- [ ] No debug statements left in code
- [ ] No commented-out code blocks
- [ ] Error handling is comprehensive
- [ ] Logging is appropriate (not too verbose)

### Functionality
- [ ] Original issue resolved
- [ ] No regression in existing features
- [ ] Edge cases handled
- [ ] Error messages are user-friendly
- [ ] Performance is acceptable
- [ ] Works across supported browsers/platforms

### Documentation
- [ ] Code comments added where needed
- [ ] README updated if needed
- [ ] CHANGELOG updated
- [ ] API docs updated if endpoints changed
- [ ] Deployment notes documented

### Security & Safety
- [ ] No sensitive data in logs
- [ ] No security vulnerabilities introduced
- [ ] Input validation implemented
- [ ] SQL injection prevented
- [ ] XSS prevention in place
- [ ] Proper authentication/authorization

### Deployment
- [ ] Environment variables documented
- [ ] Database migrations tested
- [ ] Rollback plan exists
- [ ] Monitoring alerts configured
- [ ] Load testing performed (if relevant)

---

## 🚨 Emergency Debugging Protocol

When something is on fire and users are affected:

### First 5 Minutes
```bash
# 1. ASSESS THE DAMAGE
curl -I https://production-url.com  # Is site up?
tail -100 /var/log/app/error.log    # Recent errors?
df -h                                # Disk full?
free -h                              # Out of memory?

# 2. QUICK WINS
# Clear cache?
redis-cli FLUSHALL

# Restart service?
sudo systemctl restart app

# Rollback?
git revert HEAD
npm run deploy:production

# 3. COMMUNICATE
# Post in #incidents Slack
# Update status page
# Notify stakeholders
```

### Next 15 Minutes
```bash
# Deeper investigation
journalctl -u app --since "10 minutes ago"
docker logs --tail 500 container_name
npm run logs:production | grep ERROR

# Apply hotfix if root cause found
git checkout -b hotfix/critical-issue
# Make minimal change
git commit -m "Hotfix: Critical production issue"
git push
npm run deploy:production
```

### Next 30 Minutes
```bash
# Verify fix
# Monitor metrics
# Collect postmortem data
# Schedule proper fix
```

---

## 📚 Learning & Improvement

### After Every Fix, Document:

1. **What went wrong?**
2. **Why did it happen?**
3. **How did you find it?**
4. **How did you fix it?**
5. **How can we prevent it?**

### Create Postmortem Template:
```markdown
## Incident Postmortem

**Date:** [When]
**Duration:** [How long]
**Impact:** [Who was affected]
**Severity:** [1-5]

### Timeline
- HH:MM - Issue first detected
- HH:MM - Team notified
- HH:MM - Root cause identified
- HH:MM - Fix deployed
- HH:MM - Incident resolved

### Root Cause
[Technical explanation]

### Resolution
[What we did]

### Action Items
- [ ] Prevent: [How to prevent recurrence]
- [ ] Detect: [How to catch earlier]
- [ ] Respond: [How to respond faster]

### Lessons Learned
[What we learned]
```

---

## 🤖 Clawdbot Integration

### Commands to Use

```
@clawdbot debug [project-name]
@clawdbot analyze error "[error message]"
@clawdbot test [component]
@clawdbot verify fix
@clawdbot deploy check
```

### Memory Patterns

Clawdbot will remember:
- Common error patterns in your projects
- Successful debugging strategies
- Your preferred debugging tools
- Project-specific quirks
- Deployment procedures

---

## 🎯 Success Metrics

A fix is successful when:

✅ Original issue is resolved  
✅ No new issues introduced  
✅ All tests pass  
✅ Code is documented  
✅ Fix is deployed  
✅ Metrics confirm improvement  
✅ Users are happy  

---

## 📞 Support Resources

- **Stack Overflow:** Specific technical questions
- **GitHub Issues:** Library/framework bugs
- **Documentation:** Official docs first
- **Community:** Discord/Slack channels
- **Clawdbot:** For pattern matching and automation

---

**Remember:** Debugging is a skill that improves with practice. Every bug you fix makes you a better developer. Stay methodical, stay patient, and document your learnings!

---

*This methodology has been refined through hundreds of debugging sessions. Follow it, adapt it, make it your own.*
