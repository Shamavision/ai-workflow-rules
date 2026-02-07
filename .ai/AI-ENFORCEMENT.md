# AI ENFORCEMENT - Automatic Reminders & Checks

> **Auto-loaded by AI assistants. Contains MANDATORY protocols that AI MUST follow.**

---

## 🔴 CRITICAL PROTOCOLS (Zero Tolerance)

### 1. POST-PUSH COMPRESSION (MANDATORY)

**TRIGGER:** Every successful `git push origin <branch>`

**REQUIRED ACTION:** Display this block IMMEDIATELY after push:

```markdown
[POST-PUSH PROTOCOL]
✓ Changes pushed to remote (commit <hash>)
→ Running context compression...

Previous context: ~Xk tokens
Compressed to: ~Yk tokens
Saved: ~Zk tokens (W%)

Ready for next task with fresh context.
```

**IMPLEMENTATION:**

```
AFTER git push succeeds:
1. Calculate current context size
2. Compress context:
   - Remove code snippets (already in git)
   - Remove implementation details
   - Keep only summary + decisions
3. Show savings
4. Clear for next task
```

**WHY MANDATORY:**
- Git preserves ALL details → context duplication wasteful
- Saves 40-60% tokens
- Better focus on new tasks
- Prevents token bloat

**FAILURE = VIOLATION:** If AI does NOT compress after push, this is a protocol violation.

---

### 2. SESSION START TOKEN CHECK (MANDATORY)

**TRIGGER:** Every new session start (`//START` or auto-load)

**REQUIRED ACTION:**

```markdown
[SESSION START]
✓ Context loaded: <context_name>
✓ Session: 0k/200k (0%)
✓ Daily usage: <check .ai/token-limits.json or ask user>
✓ Remaining today: ~Xk
✓ Status: 🟢/🟡/🟠/🔴 <zone>
```

**MUST CHECK:**
- Daily usage (from token-limits.json or user)
- Calculate remaining budget
- Warn if >60% used

---

### 3. PRE-COMMIT CHECKS (MANDATORY)

**TRIGGER:** Before every `git commit`

**REQUIRED CHECKS:**

```
1. git status - see all changes
2. git diff - review changes
3. Draft commit message (why, not what)
4. Add relevant files
5. Create commit
6. Run git status after to verify
```

**NEVER:**
- ❌ Auto-commit without approval
- ❌ Skip hooks (--no-verify) unless user asks
- ❌ Force push to main/master
- ❌ Amend commits after hook failure (creates NEW commit instead)

---

### 4. LARGE TASK PRE-FLIGHT (MANDATORY for >50k tasks)

**TRIGGER:** Task estimated >50k tokens

**REQUIRED CHECKS:**

```
[ ] Daily usage checked
[ ] Task estimate calculated
[ ] Remaining budget verified
[ ] User warned if insufficient
[ ] Explicit approval received
```

**IF insufficient budget:**
```
⚠️ DAILY LIMIT WARNING

Task estimate: ~Xk tokens
Daily remaining: ~Yk tokens
VERDICT: INSUFFICIENT

Options:
1. Split work (Part 1 today, Part 2 tomorrow)
2. Postpone entire task
3. Risk it (may hit limit mid-task)

Your choice?
```

---

## 📋 AUTOMATIC REMINDERS

### After git operations:

| Operation | Reminder |
|-----------|----------|
| `git push` | **POST-PUSH COMPRESSION** (mandatory) |
| `git commit` | Show token status if >30% |
| `git merge` | Check for conflicts, review carefully |

### At token thresholds:

| Threshold | Action |
|-----------|--------|
| 30% | Show `[TOKEN STATUS]` automatically |
| 50% | Activate optimizations (brief mode, diff-only) |
| 70% | Aggressive compression, silent mode |
| 90% | Finalization only, warn user |
| 95% | STOP, commit + end session |

---

## 🛡️ ENFORCEMENT MECHANISM

**How this works:**

1. **File auto-loaded** - AI reads this at session start
2. **Protocols become active** - AI MUST follow them
3. **User can verify** - Violations are visible
4. **Self-correcting** - AI learns from violations

**Violation Handling:**

```
IF AI violates protocol:
1. User points out violation
2. AI acknowledges
3. AI updates MEMORY.md with lesson learned
4. AI executes correct action
5. Pattern prevented in future
```

---

## 📝 PROTOCOL CHECKLIST (AI Self-Check)

**After each operation, verify:**

✅ **After git push:**
- [ ] Displayed [POST-PUSH PROTOCOL]
- [ ] Compressed context
- [ ] Showed token savings

✅ **After git commit:**
- [ ] Reviewed changes (git diff)
- [ ] Drafted message (why, not what)
- [ ] Got user approval
- [ ] Verified success (git status)

✅ **At 50%+ tokens:**
- [ ] Activated optimizations
- [ ] Brief mode active
- [ ] Diff-only format

✅ **Before large task:**
- [ ] Checked daily budget
- [ ] Warned if insufficient
- [ ] Got explicit approval

---

## 🎯 USER BENEFIT

**With enforcement:**
- ✅ Consistent behavior across sessions
- ✅ No wasted tokens
- ✅ Predictable workflow
- ✅ Budget protection
- ✅ Quality assurance

**Without enforcement:**
- ❌ AI may forget protocols
- ❌ Token waste
- ❌ Inconsistent behavior
- ❌ Budget overruns
- ❌ User has to remind AI

---

## 🔄 CONTINUOUS IMPROVEMENT

**This file evolves:**
- Add new protocols as patterns emerge
- Remove protocols that prove unnecessary
- Refine triggers based on experience

**Last Updated:** 2026-02-07
**Version:** 1.0
**Critical Protocols:** 4

---

**Made in Ukraine 🇺🇦**
