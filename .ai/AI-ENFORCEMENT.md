# AI ENFORCEMENT - Automatic Reminders & Checks

> **Auto-loaded by AI assistants. Contains MANDATORY protocols that AI MUST follow.**

---

## 🔴 CRITICAL PROTOCOLS (Zero Tolerance)

### 0. TOKEN PRE-FLIGHT CHECK (HIGHEST PRIORITY!)

**TRIGGER:** Task estimated >20k tokens

**MANDATORY STEPS:**
1. ASK: "How many tokens used TODAY?"
2. CALCULATE: remaining = daily_limit - daily_used
3. IF task > remaining → STOP + WARN + GET APPROVAL
4. NEVER proceed without explicit approval!

**Failure consequences:**
- Rate limit = 2 days downtime
- Incomplete work = worse than not starting
- Damaged trust = critical for complex product

### 1. POST-PUSH COMPRESSION (MANDATORY)

**TRIGGERS (any of these = MUST compress):**
1. ✅ After successful `git push origin <branch>` (ALWAYS)
2. ✅ After session reaches 50% tokens (100k/200k)
3. ✅ After completing major task (user says "done", "finished", "готово")
4. ✅ Before starting new major task (user says "now let's work on...", "тепер давай...")
5. ✅ After 15+ messages in current thread

**REQUIRED ACTION:** Display this block IMMEDIATELY:

```markdown
[COMPRESSION EXECUTED]
Previous context: ~Xk tokens
Compressed to: ~Yk tokens
Saved: ~Zk tokens (W%)
Compression level: [Light/Aggressive/Maximum]

Ready for next task with optimized context.
```

**MULTI-LEVEL COMPRESSION:**

**Level 1 - Light (50-70% tokens):**
```
Compress:
- ✅ Code snippets already in git
- ✅ Verbose implementation details
- ✅ Rejected alternative approaches

Preserve:
- ✅ Decisions and reasoning
- ✅ User preferences
- ✅ Active task context
- ✅ Critical warnings
```

**Level 2 - Aggressive (70-90% tokens):**
```
Compress:
- ✅ ALL code (git has it)
- ✅ Detailed discussions
- ✅ Implementation paths explored

Preserve:
- ✅ Key decisions only
- ✅ User preferences
- ✅ Next steps
- ✅ Blocking issues
```

**Level 3 - Maximum (90%+ tokens):**
```
Compress to executive summary:
- ✅ Active task description (1-2 sentences)
- ✅ User preferences (bullet list)
- ✅ Blocking issues (if any)
- ✅ Next immediate step

Everything else: REMOVED
```

**AUTO-SELECT LEVEL:**
```
Session tokens 50-70% → Level 1 (Light)
Session tokens 70-90% → Level 2 (Aggressive)
Session tokens 90%+   → Level 3 (Maximum)
```

**WHY MANDATORY:**
- Git preserves ALL details → context duplication wasteful
- Saves 40-70% tokens (level-dependent)
- Better focus on new tasks
- Prevents token bloat
- Extends session lifespan

**FAILURE = VIOLATION:** If AI does NOT compress when triggered, this is a protocol violation.

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

### 5. PRE-COMMIT LINT CHECK (OPTIONAL but recommended - v9.1)

**TRIGGER:** Before creating commit (after code changes)

**REQUIRED ACTION:**

```markdown
AI should suggest:

"💡 Run code quality check before commit?"

Options:
1. Yes → Run `npm run lint` (or appropriate linter)
2. Skip → Proceed without lint
3. Auto-fix → Run `npm run format` to fix issues
```

**What to check:**
- JavaScript/TypeScript: `npm run lint`, `npm run format --check`
- Python: `black --check .`, `flake8 .`
- Go: `gofmt -l .`, `go vet ./...`
- Shell: `shellcheck *.sh`

**If warnings found:**
```markdown
⚠️ Found X linting warnings:
- [Brief summary of issues]

These won't block your commit.
Proceed anyway? [YES/FIX/SKIP]
```

**AI behavior:**
- ✅ Suggest lint check before commit
- ✅ Show warnings if found
- ✅ Offer to auto-fix if possible
- ❌ Never block commit (warnings only)
- ❌ Don't run lint if user skips

**Why optional:**
- Linting adds time to commit process
- User may want to commit WIP code
- Auto-runs in pre-commit hook anyway
- AI should suggest, not force

**Documentation:** See [docs/code-quality.md](docs/code-quality.md)

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
| 50% | Activate optimizations + **suggest compression** |
| 70% | Aggressive compression + **proactive warning** |
| 90% | Finalization only + **mandatory warning** |
| 95% | STOP, commit + end session |

### Proactive Compression Suggestions:

**At 50k tokens (25% of session):**
```markdown
💡 **Token Checkpoint**

Session: 50k/200k (25%)

💡 Tip: Consider using `//COMPACT` after finishing current task
to save tokens for later work.
```

**At 100k tokens (50% of session):**
```markdown
⚠️ **Token Checkpoint: 50% Used**

Session: 100k/200k (50%)
Remaining: ~100k

📊 Recommendation: Compress context NOW to ensure budget for
remaining work.

Proceed with compression? [YES/LATER]
```

**At 140k tokens (70% of session):**
```markdown
🟠 **Caution Zone: 70% Tokens Used**

Session: 140k/200k (70%)
Remaining: ~60k

⚠️ I'm automatically switching to brief mode and will compress
after this task. Consider wrapping up current work soon.

Status: 🟠 CAUTION (aggressive optimization active)
```

**At 180k tokens (90% of session):**
```markdown
🔴 **Critical: 90% Tokens Used**

Session: 180k/200k (90%)
Remaining: ~20k (CRITICAL)

🚨 RECOMMENDATION: Finalize and commit current work, then start
fresh session with full budget tomorrow/later.

Continue? [FINALIZE/EMERGENCY-CONTINUE]
```

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
**Version:** 2.0 (v9.1 Enhanced Compression)
**Critical Protocols:** 4
**Compression Levels:** 3 (Light/Aggressive/Maximum)
**Triggers:** 5 (git push, 50% tokens, task completion, new task, 15+ messages)

---

**Made in Ukraine 🇺🇦**
