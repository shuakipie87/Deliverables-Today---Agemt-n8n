# 🐛 Debugging Methodology Skill

A comprehensive skill that teaches Clawdbot the systematic approach to debugging, fixing issues, and verifying solutions.

## 📦 Contents

- **SKILL.md** - Complete debugging methodology guide (7 phases)
- **scripts/debug_workflow.sh** - Interactive debugging workflow automation
- **scripts/quick_verify.sh** - Fast verification checklist before deployment
- **Memory Integration** - Pattern learning and continuous improvement

## 🚀 Quick Start

### Run Full Debug Workflow
```bash
bash .clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh /path/to/project
```

### Run Quick Verification Only
```bash
bash .clawdbot/skills/debugging-methodology-1.0.0/scripts/quick_verify.sh /path/to/project
```

### Run Specific Phase
```bash
# Phase 1: Investigation
bash .clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh /path/to/project 1

# Phase 5: Verification
bash .clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh /path/to/project 5
```

## 📚 The 7 Phases

1. **Investigation** (5-10 min) - Understand the problem
2. **Analysis** (15-30 min) - Find the root cause
3. **Solution Design** (10-20 min) - Plan the fix
4. **Implementation** (20-60 min) - Apply the fix
5. **Verification** (30-45 min) - Test thoroughly
6. **Documentation** (15-30 min) - Document and cleanup
7. **Deployment & Monitoring** (30-60 min) - Deploy safely

## 🎯 Key Features

- **Systematic approach** - Never skip steps
- **Safety first** - Automatic backups, git branches
- **Comprehensive testing** - Unit, integration, regression
- **Full documentation** - Auto-generates fix docs
- **Learning integration** - Patterns saved to Clawdbot memory

## 🧠 Learning System

Clawdbot learns from every debugging session:
- Common error patterns recognized automatically
- Successful strategies remembered
- Project-specific quirks tracked
- Continuous improvement over time

See: `.clawdbot/memory/knowledge/debugging_patterns.json`

## 📖 Documentation

- **SKILL.md** - Full methodology guide
- **debugging_learning_guide.md** - How Clawdbot learns
- **debugging_patterns.json** - Known error patterns database

## 🔧 Usage Examples

### Example 1: Quick Bug Fix
```bash
cd ~/Projects/koopprijs
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/quick_verify.sh
```

### Example 2: Full Debugging Session
```bash
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh ~/Projects/koopprijs all
```

### Example 3: Just Verification Phase
```bash
bash ~/.clawdbot/skills/debugging-methodology-1.0.0/scripts/debug_workflow.sh ~/Projects/koopprijs verify
```

## ✅ Verification Checklist

The quick_verify.sh script checks:
- ✅ Git status (clean or intentional changes)
- ✅ No debug code left in source
- ✅ All tests passing
- ✅ Linting passes
- ✅ Build succeeds
- ✅ No exposed secrets
- ✅ Dependencies up to date
- ✅ Documentation updated

## 🤖 Clawdbot Commands

```
@clawdbot debug [project-name]
@clawdbot analyze error "[error message]"
@clawdbot verify fix
@clawdbot run tests
@clawdbot deploy check
```

## 📊 Success Metrics

A fix is successful when:
- ✅ Original issue resolved
- ✅ No new issues introduced
- ✅ All tests pass
- ✅ Code documented
- ✅ Deployed successfully
- ✅ Metrics confirm improvement

## 🎓 Learning Resources

- Full methodology: `SKILL.md`
- Learning guide: `.clawdbot/memory/knowledge/debugging_learning_guide.md`
- Pattern database: `.clawdbot/memory/knowledge/debugging_patterns.json`

## 📞 Support

For questions or improvements, document in the learning system or update the patterns database.

---

**Version:** 1.0.0  
**Created:** 2026-01-31  
**Author:** Joshua Dingcong (shuakipie)
