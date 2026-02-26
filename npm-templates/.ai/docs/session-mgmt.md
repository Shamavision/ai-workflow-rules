# Session Management Best Practices

> **Goal:** Save 50%+ tokens by continuing sessions instead of unnecessary restarts
> **Impact:** ~35-50k tokens saved per day for typical workflows

---

## 🎯 Quick Decision Guide

**Before restarting, ask yourself:**

| Situation | Action | Why |
|-----------|--------|-----|
| Just committed minor changes | ✅ **CONTINUE** | No need to restart |
| Working on same feature | ✅ **CONTINUE** | Context is relevant |
| Pushed to main (milestone) | 🔄 **CONSIDER RESTART** | Fresh start for new work |
| Tokens >90% used | 🔄 **RESTART** | Running out of budget |
| Next day, different feature | 🔄 **RESTART** | New context needed |
| After using `//COMPACT` | ✅ **CONTINUE** | Context already compressed |

---

## ✅ When to CONTINUE Session (Don't Restart)

### 1. Minor Code Changes
```
✓ Bug fixes
✓ Small refactors
✓ Documentation updates
✓ Adding comments
✓ Style adjustments
✓ Config tweaks
```

**Why:** AI already has context, restarting wastes 18-25k tokens loading same info.

### 2. Same Feature Work
```
✓ Working through roadmap stages
✓ Iterating on same component
✓ Fixing issues in current PR
✓ Adding tests for current feature
```

**Why:** Continuous context = better decisions, faster work.

### 3. After Compression
```
✓ Used //COMPACT command
✓ AI ran post-push compression
✓ Context already optimized
```

**Why:** Compression gives you fresh space without losing relevant context.

### 4. Token Budget Still Good
```
✓ 0-50% tokens used (🟢 GREEN)
✓ 50-70% tokens used (🟡 MODERATE)
✓ Even 70-90% if task small (🟠 CAUTION)
```

**Why:** Plenty of budget remaining, no need to restart.

---

## 🔄 When to RESTART Session

### 1. Major Milestone Completed
```
✓ Pushed feature to main
✓ Released version
✓ Completed large refactor
✓ Finished sprint/phase
```

**Why:** Clean slate for new work, prevents context mixing.

**Pattern:**
```
Work → Commit → Push → [POST-PUSH PROTOCOL] → Fresh session
```

### 2. Token Budget Critical
```
✓ >90% tokens used (🔴 CRITICAL)
✓ >150k of 200k daily limit
✓ AI in finalization mode
```

**Why:** Need full budget for next work session.

### 3. Switching Major Context
```
✓ Different feature/module
✓ Different project (monorepo)
✓ Different technology stack
```

**Why:** Old context irrelevant, wastes tokens.

### 4. Long Break (Next Day)
```
✓ End of work day
✓ Weekend break
✓ Multi-day pause
```

**Why:** Fresh perspective, clean start, updated context.

### 5. AI Behavior Issues
```
✓ AI seems confused
✓ Repeating mistakes
✓ Context seems corrupted
```

**Why:** Fresh session = fresh start, fixes issues.

---

## 💡 Token-Efficient Workflows

### Pattern 1: Feature Development

```mermaid
Session 1 (Fresh):
├─ Start: 0k/200k
├─ Load context: +18k (ukraine)
├─ Work on feature: +40k
├─ Stage 1 commit: +5k
├─ Stage 2 work: +30k
├─ Stage 3 work: +25k
├─ Total: 118k (59%) 🟡 MODERATE
└─ //COMPACT → saves 30k → 88k (44%) 🟢

Continue same session:
├─ After compression: 88k (44%) 🟢
├─ Final testing: +20k
├─ Documentation: +15k
├─ Total: 123k (61.5%) 🟡
└─ Push to main → NEW SESSION

Session 2 (Fresh):
└─ New feature with clean context
```

**Tokens saved:** Avoided 1 extra restart = 18k tokens saved

### Pattern 2: Bug Fixing Sprint

```
Session 1:
├─ Start: +18k (context)
├─ Fix bug #1: +15k
├─ Fix bug #2: +12k
├─ Fix bug #3: +10k
├─ Total: 55k (27.5%) 🟢
└─ All bugs fixed, commit, push → NEW SESSION
```

**No restart needed:** All bugs related, context useful for all

### Pattern 3: Multi-Day Project

```
Day 1:
├─ Session start: +18k
├─ Work: +80k
├─ At 80%: Create checkpoint (.ai/checkpoint-2026-02-07.md)
└─ End of day: Commit work, push

Day 2:
├─ New session: +18k (context)
├─ Resume from checkpoint: +5k (read checkpoint)
├─ Continue work: +70k
└─ Total: 93k vs 150k+ without checkpoint
```

**Checkpoint saves:** ~50k tokens by not rediscovering context

---

## 🛠️ How to Continue Session (Platform-Specific)

### Claude Code (VSCode Extension)

**Session persists automatically:**
```
✓ Same chat window = same session
✓ Use //COMPACT to compress if needed
✓ Close window = loses session (restart)
```

**Best practice:**
- Keep VSCode open during work
- Use `//COMPACT` instead of restarting
- Close only at day end or major milestone

### Cursor

**Session persists in Composer:**
```
✓ Ctrl+L opens Composer
✓ Same conversation = same session
✓ Context preserved between messages
```

**Best practice:**
- Continue in same Composer thread
- Use compression when >50% tokens
- New Composer only for new features

### Windsurf

**Session persists in AI panel:**
```
✓ AI panel conversation continues
✓ Use refresh if needed (preserves context)
✓ Clear chat = new session
```

**Best practice:**
- Stay in same chat thread
- Refresh only if UI issues
- New chat for major context switch

### Continue.dev

**Session management:**
```
✓ Depends on configuration
✓ Usually preserves context
✓ Check sidebar for session controls
```

---

## 📊 Token Savings Calculator

**Scenario: Typical work day**

### Inefficient (Multiple Restarts)
```
Session 1: 18k (load) + 40k (work) = 58k
Session 2: 18k (load) + 35k (work) = 53k
Session 3: 18k (load) + 30k (work) = 48k
Session 4: 18k (load) + 25k (work) = 43k
═══════════════════════════════════════
Total: 202k tokens (over daily limit!)
```

### Efficient (Continue + Compression)
```
Session 1: 18k (load) + 40k (work) = 58k
  //COMPACT: saves 20k → 38k
Continue: + 35k (work) = 73k
  //COMPACT: saves 25k → 48k
Continue: + 30k (work) = 78k
  Push → New session
Session 2: 18k (load) + 25k (work) = 43k
═══════════════════════════════════════
Total: 121k tokens (within budget!)

SAVED: 81k tokens (40%)
```

---

## 🎯 Compression vs Restart Decision

| Situation | Tokens Used | Action | Reason |
|-----------|-------------|--------|--------|
| Working, 40% used | 80k/200k | **Continue** | Plenty of budget |
| Working, 60% used | 120k/200k | **Compress** | Free up space |
| Milestone done, 60% | 120k/200k | **Restart** | New context needed |
| Same work, 85% used | 170k/200k | **Compress then continue** | Last push before milestone |
| Same work, 92% used | 184k/200k | **Finalize & restart** | Budget critical |

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Restarting After Every Commit
```
User commits → Restarts AI → Loads 18k context → Continues
═══════════════════════════════════════
Wasted: 18k tokens per commit
If 5 commits/day: 90k tokens wasted!
```

**Fix:** Continue session, restart only after push to main

### ❌ Mistake 2: "Feeling Fresh" Restarts
```
User: "Let me restart to feel fresh"
═══════════════════════════════════════
Wasted: 18k tokens for psychological reason
```

**Fix:** Use `//COMPACT` instead - same fresh feeling, 0 token cost

### ❌ Mistake 3: Ignoring Compression
```
Session: 120k tokens used (60%)
User: Continues without compression
Session: 180k tokens (90%) - now in CRITICAL
═══════════════════════════════════════
Problem: Could have compressed at 60%, saved 40-50k
```

**Fix:** Compress at 50-60%, continue working

### ❌ Mistake 4: Working Across Multiple Sessions
```
Session 1: Start feature → 50k tokens → Restart
Session 2: Continue feature → 18k context load + 40k work
═══════════════════════════════════════
Wasted: 18k for context reload (AI already knew this!)
```

**Fix:** Complete feature in one session, or use checkpoints

---

## 📝 Quick Commands Reference

| Command | When to Use | Effect |
|---------|-------------|--------|
| `//COMPACT` | 50%+ tokens | Compress context, save 40-60% |
| `//TOKENS` | Anytime | Show current token usage |
| `//CONTEXT` | Anytime | Show context size |
| New session | >90% tokens OR major milestone | Fresh start, 18-25k cost |

---

## 🎓 Pro Tips

**Tip 1: Batch Related Work**
```
✓ Fix all bugs in same session
✓ Complete all stages of feature
✓ Write tests + docs together
```

**Tip 2: Strategic Compression**
```
✓ Compress after completing stage
✓ Compress before starting new stage
✓ Compress at 50% tokens (preventive)
```

**Tip 3: Use Checkpoints for Multi-Day**
```
✓ At 80% tokens: create checkpoint
✓ Next day: resume from checkpoint
✓ Saves 30-50k tokens rediscovering context
```

**Tip 4: Communicate Intent**
```
✓ "Let's finish this feature in this session"
✓ "After this, I'll push and start fresh"
✓ AI can optimize for your workflow
```

---

## 📈 Expected Results

**Before Session Management:**
- 3-4 restarts per day
- 72-100k tokens on context loading
- 150-180k total daily usage
- Often hitting daily limit

**After Session Management:**
- 1-2 restarts per day (only at milestones)
- 18-36k tokens on context loading
- 100-130k total daily usage
- Comfortable within budget

**Savings:** 40-50k tokens/day (20-25%)

---

## 🤝 Remember

**Session restart is not free - it costs 18-25k tokens.**

Ask yourself:
1. Do I need fresh context? (different feature)
2. Am I out of tokens? (>90%)
3. Is this a major milestone? (push to main)

**If NO to all three → CONTINUE your session!**

Use `//COMPACT` when needed. It's free and effective.

---

**Last updated:** 2026-02-07
**Part of:** v9.1 Optimization (Session Management)
**Made in Ukraine 🇺🇦**
