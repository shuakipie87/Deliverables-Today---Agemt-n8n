# 🚀 Debugging Methodology - Quick Reference

One-page cheat sheet for fast debugging

---

## ⚡ Quick Commands

```bash
# Full debug workflow
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh [project-path]

# Quick verification only
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/quick_verify.sh [project-path]

# Specific phase
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh [project] [1-6]
```

---

## 🎯 The 7 Phases (Time Estimates)

1. **Investigation** (5-10 min) - What's wrong?
2. **Analysis** (15-30 min) - Why is it wrong?
3. **Solution** (10-20 min) - How to fix?
4. **Implementation** (20-60 min) - Apply fix
5. **Verification** (30-45 min) - Does it work?
6. **Documentation** (15-30 min) - Record it
7. **Deployment** (30-60 min) - Ship it

**Total: 2-4 hours for typical bug**

---

## 🔍 Quick Diagnostics

```bash
# System health
df -h && free -h && uptime

# Find errors in logs
tail -100 app.log | grep -i error

# Check running processes
ps aux | grep node
lsof -i :3000

# Git recent changes
git log --since="24 hours ago" --oneline

# Dependencies check
npm outdated
npm audit

# Test everything
npm test && npm run lint && npm run build
```

---

## 🐛 Common Error Patterns

| Error | Quick Fix | Success Rate |
|-------|-----------|--------------|
| Module not found | `rm -rf node_modules && npm ci` | 87% |
| undefined property | Add null check `?.` | 95% |
| Port already in use | `lsof -ti:3000 \| xargs kill` | 100% |
| CORS error | Check API CORS config | 80% |
| Out of memory | Find memory leak, add cleanup | 70% |
| Test timeout | Increase timeout or fix async | 90% |

---

## ✅ Pre-Commit Checklist

```bash
# Quick verify (automated)
bash quick_verify.sh

# Manual checks
□ Remove console.log/debugger
□ Run tests: npm test
□ Run linter: npm run lint
□ Build succeeds: npm run build
□ Git diff reviewed
□ Commit message clear
```

---

## 🚨 Emergency Protocol

```bash
# Production is down - FAST actions:

1. Check if site is up
curl -I https://production-url.com

2. Check logs for errors
tail -100 /var/log/app/error.log

3. Restart service (quick win?)
sudo systemctl restart app

4. Rollback if needed
git revert HEAD && deploy

5. Monitor for 5 minutes
watch -n 5 'curl -s https://url.com/health'
```

---

## 🎓 Debugging Decision Tree

```
Issue reported
  ├─ Can reproduce? 
  │   ├─ YES → Investigate systematically
  │   └─ NO → Gather more info
  │
  ├─ Severity?
  │   ├─ CRITICAL → Emergency protocol
  │   ├─ HIGH → Full debug workflow
  │   └─ LOW → Schedule for later
  │
  └─ Type?
      ├─ Build error → Check dependencies
      ├─ Runtime error → Check logs/data
      ├─ Performance → Profile & measure
      └─ UI bug → Check browser console
```

---

## 🤖 Clawdbot Commands

```
@clawdbot debug [project]
@clawdbot verify fix
@clawdbot run tests
@clawdbot check logs
@clawdbot deploy check
```

---

## 📊 Success Criteria

Fix is done when:
- ✅ Original issue resolved
- ✅ Tests pass (no regression)
- ✅ Code reviewed
- ✅ Documentation updated
- ✅ Deployed successfully
- ✅ Monitoring confirms

---

## 🔧 Essential Tools

```bash
# Code search
grep -r "pattern" src/

# Process debugging
htop
pm2 monit

# Network debugging
curl -v URL
tcpdump port 3000

# Database debugging
psql -c "EXPLAIN ANALYZE [query]"

# Memory profiling
node --inspect app.js
```

---

## 💾 Save This Location

```
Skill: ~/.clawdbot/skills/debugging-methodology-1.0.0/
Scripts: ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/
Patterns: ~/.clawdbot/memory/knowledge/debugging_patterns.json
```

---

**Print this and keep it handy! 🖨️**
