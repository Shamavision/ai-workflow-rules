# AI ENFORCEMENT - Automatic Reminders & Checks

> **Auto-loaded by AI assistants. Contains MANDATORY protocols that AI MUST follow.**

---

## 🔴 CRITICAL PROTOCOLS (Zero Tolerance)

### -1. AI BEHAVIOR FUNDAMENTALS (OVERRIDE EVERYTHING!)

**Added 2026-02-10 from ROADMAP Phase 1 - These rules take precedence over ALL other considerations, including token savings!**

**Rule: КАЧЕСТВО > СКОРОСТЬ (Quality > Speed)**

```
✅ Attention to details - ALWAYS
✅ Quality > Speed - NOT negotiable
✅ Thorough approach to every task
❌ NEVER skip steps to save time/tokens
❌ NEVER do "quick verification" instead of detailed work
❌ NEVER fly through tasks
```

**Rule: "I Don't Know" Honesty**

```
✅ Think HARDER before every answer
✅ If uncertain → say "I don't know"
✅ If guessing → clearly state it's a guess
✅ If need to check → check FIRST, then answer
❌ NEVER fabricate facts/data
❌ NEVER pretend to know
❌ NEVER guess silently
```

**Rule: No Auto-Commit**

```
❌ NEVER auto-commit
❌ NEVER auto-push
✅ ONLY when explicitly requested
✅ After phase → PROPOSE (don't execute)
```

**Why these are #-1 (before #0):**
- Quality trumps speed ALWAYS
- Honesty trumps quick answers ALWAYS
- User control trumps convenience ALWAYS
- These are MORE important than token management!

---

### 0. TOKEN PRE-FLIGHT CHECK (HIGHEST PRIORITY!)

**TRIGGER:** Task estimated >20k tokens

**MANDATORY STEPS:**
1. ASK: "How many tokens used TODAY?"
   - Accept answers like "мы только начали сегодня" = ~0-25k used
   - Don't repeat question if user already answered!
2. CALCULATE: remaining = daily_limit - daily_used
3. IF task > remaining → STOP + WARN + GET APPROVAL
4. NEVER proceed without explicit approval!

**IMPORTANT:** Understand user's answers!
- "мы только начали сегодня" = daily usage ~0-25k ✅
- "свежий день" = daily usage ~0k ✅
- Don't ask same question twice if already answered!

**Failure consequences:**
- Rate limit = 2 days downtime
- Incomplete work = worse than not starting
- Damaged trust = critical for complex product

---

### 0.5. PRE-PHASE RULE REFRESH (ANTI-AMNESIA)

**Added 2026-02-11 from ROADMAP Phase 5 - Prevents AI from forgetting protocols during long sessions**

**TRIGGER:** Before EVERY phase/stage/major task (user says "go", "давай", starts new work)

**REQUIRED ACTION:**

1. **Quick mental refresh** - recall active protocols:
   - ✅ Quality > Speed (Rule #-1)
   - ✅ "I Don't Know" honesty (Rule #-1)
   - ✅ Token status after phase (Protocol 2.5)
   - ✅ No auto-commit (Rule #-1)
   - ✅ Ukrainian language check if needed (Protocol 1.5)

2. **Check token budget** (if task >20k):
   - Daily usage check (Protocol 0)
   - Verify sufficient budget
   - Get approval if tight

3. **Optionally** (if session >50% tokens or after 15+ messages):
   - Re-read `.ai/RULES-CRITICAL.md` for full checklist
   - Display active protocols for current phase
   - Confirm readiness

**WHY MANDATORY:**
- Long sessions → AI forgets protocols (proven issue)
- 11+ critical protocols too many to remember
- Proactive refresh prevents violations
- ROI: ~1.5k per phase prevents 20-50k in fixes

**COST vs BENEFIT:**
- Cost: ~1.5k tokens per phase = ~4-6k per session
- Benefit: Prevents violations that cost 20-50k to fix
- Net savings: +15-45k tokens per session
- **POSITIVE ROI after first violation prevented!**

**User feedback that triggered this:**
- "ты просто забываешь про них" (you just forget about them)
- AI violated Protocol 2.5 (Phase Completion Token Status) multiple times
- AI violated Protocol 1 (Post-Push Compression) after git push

**FAILURE = VIOLATION:** If AI violates any protocol in Phase 5+, this refresh was insufficient.

---

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

### 1.1. SESSION-LOG WRITE PROTOCOL (Phase 11 - MANDATORY)

**Added 2026-02-19 — Universal token self-reporting, works for ALL AI tools**

**WHAT:** AI writes its own token estimates to `.ai/session-log.json`
**WHY:** No provider API → AI is the only source of truth → honest self-reporting

**TRIGGERS (write to session-log.json when ANY of these fires):**

| Trigger | Tokens written | Entry format |
|---------|---------------|--------------|
| `//start` / session start | 0 (marker) | `session-start` + timestamp |
| `//TOKENS` | current estimate | `//tokens` + timestamp |
| `//COMPACT` | estimate before compress | `//compact` + timestamp |
| `git push` | estimate | `git-push` + timestamp |
| Phase complete | estimate | `phase-complete` + timestamp |

**REQUIRED ACTION — Write entry to session-log.json:**

```json
{
  "date": "YYYY-MM-DD",
  "tokens": 45000,
  "tool": "claude-code",
  "trigger": "//tokens",
  "timestamp": 1740012345
}
```

**session-start entry (tokens = 0, marks session boundary):**
```json
{"date": "YYYY-MM-DD", "tokens": 0, "tool": "claude-code", "trigger": "session-start", "timestamp": 1740010000}
```

**Step by step (for `//TOKENS` and other estimate triggers):**
```
1. Read .ai/session-log.json (create if missing: {"_comment": "...", "sessions": []})
2. today = local date (YYYY-MM-DD), NOW = Unix timestamp
3. NEW DAY CHECK: last entry date != today?
   → Show: "🟢 New day! Yesterday: ~Xk. Fresh limits."
4. today_total = sum sessions[].tokens where date == today
5. Estimate current session tokens (rules_load + conversation ±30-50%)
6. Append: {date: today, tokens: estimate, tool: "...", trigger: "<trigger>", timestamp: NOW}
7. Write updated file back
8. Show session breakdown (group entries by session-start markers, gap >2h)
```

**Step by step (for `//start` — session boundary):**
```
1. Read .ai/session-log.json (or create)
2. NOW = Unix timestamp, LAST_TS = last entry's timestamp (0 if none)
3. GAP = NOW - LAST_TS
4. IF GAP > 7200 (2h) OR no entry today:
   → Append: {date, tokens: 0, tool, trigger: "session-start", timestamp: NOW}
   → Show: "🟢 New session started (gap: Xh)"
5. IF GAP < 7200: context refresh only — do NOT write entry
   → Show: "📊 Continuing session. Today: ~Xk (N entries)"
```

**SHOW [AI STATUS] after every write — 3-Layer Mental Model:**
```
[AI STATUS]
Provider: Claude Pro (subscription)

Context Layer:  ~Xk / 200k (Y%)     ← AI knows exactly
Rate Layer:     🟢 Normal           ← estimated from patterns
Billing Layer:  N/A (subscription)

Status: 🟢 GREEN
```

**IMPORTANT — Honesty rules:**
- ❌ NEVER show Billing Layer cost for subscription users (`N/A` is honest)
- ❌ NEVER fabricate daily limits or percentages
- ✅ Context Layer: session tokens / 200k → AI knows this exactly
- ✅ Rate Layer: 🟢 Normal by default, 🟠 Elevated if signs of throttling
- ✅ Billing Layer: `N/A (subscription)` for MODEL_3; cost data for API users
- ✅ "Progressive truth > fabricated precision"

**Graceful degradation (web AI, no file system):**
> "Cross-session tracking requires a code editor. This session: ~Xk (estimate only)."

**WHY MANDATORY:**
- Current state: `daily_usage = 0` in token-limits.json → total fiction
- This gives users REAL data (rough, but real)
- Time anchor (date) enables cross-session accumulation without any API

**FAILURE = VIOLATION:** If AI shows Billing Layer cost for subscription users, or fabricates daily limits. Use 3-layer [AI STATUS] format.

---

### 1.5. UKRAINIAN LANGUAGE QUALITY SELF-CHECK (PRE-COMMIT)

**Added 2026-02-11 from ROADMAP Phase 6 - Prevents казуси in Ukrainian text**

**TRIGGER:** Before every `git commit` with Ukrainian text

**PROTOCOL:**

1. **Identify Ukrainian content** in changes:
   - Documentation files (README, GUIDE, docs/)
   - i18n/locale files (uk.json, uk_UA.json)
   - Ukrainian comments (if any)
   - User-facing messages

2. **Self-check against patterns:**
   - ✅ **Surzhyk detection** - russian words/phrases in Ukrainian text
   - ✅ **Common grammar mistakes** - see reference patterns below
   - ✅ **Terminology consistency** - український (not украинский), тощо (not и т.д.)
   - ✅ **Punctuation** - Ukrainian standards (not russian)

3. **Action based on confidence:**
   ```
   IF 100% certain it's wrong → Auto-fix silently
   IF 80-99% certain → Fix + notify user ("Fixed: X → Y")
   IF <80% certain → Flag for user review:

   ⚠️ UKRAINIAN CHECK: Uncertain about line X:
   "[text]"
   Possible issue: [description]
   Keep as-is or change to "[suggestion]"?
   ```

4. **Reference patterns:** See `.ai/contexts/ukraine-full.context.md` section 7.3

**IMPORTANT:**
- This is SELF-CHECK, not external tool
- Uses AI's Ukrainian knowledge + reference patterns
- Zero dependencies, zero overhead
- Prevents embarrassing казуси in production

**WHY MANDATORY:**
- Project targets Ukrainian market
- Ukrainian language quality = brand reputation
- Surzhyk/russian leaks = unprofessional
- Better catch before commit than after deploy

---

### 2. SESSION START TOKEN CHECK (MANDATORY)

**TRIGGER:** Every new session start (`//START` or auto-load)

**REQUIRED ACTION:**

```markdown
[SESSION START]
✓ Context loaded: <context_name>
✓ Session: 0k/200k (0%)
✓ Daily usage: <from session-log.json if exists>
✓ Status: 🟢/🟡/🟠/🔴 <zone>
```

**MUST CHECK (Phase 11 update):**
1. Read `.ai/session-log.json` (if exists)
2. Compare last entry date vs today:
   - **Same date** → Show: "📊 Today so far: ~Xk tokens (from log)"
   - **Different date** → Show: "🟢 New day! Yesterday: ~Xk. Fresh limits today."
   - **File missing** → Show: "📊 No session log yet. Use //TOKENS to start tracking."
3. **NEVER** show fake daily % from token-limits.json (daily_usage is always 0 there)

---

### 2.5. PHASE COMPLETION TOKEN CHECK (MANDATORY - STRICT!)

**Added 2026-02-10 from ROADMAP [3] - This protocol existed but was IGNORED!**

**TRIGGER:** After completing ANY phase/stage/major task

**REQUIRED ACTION (NO EXCEPTIONS):**

```markdown
[PHASE X COMPLETE]
Session tokens: Xk/200k (Y%)
Daily tokens: Zk/150k (W%)
Remaining: ~Nk
Status: 🟢/🟡/🟠/🔴

Next: [Brief description of next phase]
Estimate: ~Nk tokens

Продолжить Phase X+1? [Y/n]
```

**MANDATORY RULES:**
- ✅ Show AFTER every phase completion
- ✅ Show estimate for NEXT phase
- ✅ Wait for user approval BEFORE continuing
- ❌ NEVER skip this display
- ❌ NEVER start next phase without confirmation
- ❌ NEVER show old/cached token data (use CURRENT!)

**User feedback that triggered this:**
- "При чем ы ниразу не сообщил мне в конце фаз про токены"
- AI completed Phases 8-10 without showing token status
- POST-PUSH showed OLD data (89k from previous session)

**Why this is CRITICAL:**
- Prevents token budget violations
- Gives user control over pacing
- Allows user to pause if needed
- Shows respect for user's budget

**This rule existed in AI-ENFORCEMENT.md but AI IGNORED it → Now it's STRICT!**

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
| 30% | Show `[AI STATUS]` automatically |
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

**Last Updated:** 2026-02-11
**Version:** 2.2 (v9.1.1 Rule Refresh & Anti-Amnesia)
**Critical Protocols:** 6 (added Protocol 0.5 Pre-Phase Refresh + Protocol 1.5 Ukrainian Language)
**Compression Levels:** 3 (Light/Aggressive/Maximum)
**Triggers:** 5 (git push, 50% tokens, task completion, new task, 15+ messages)
**Anti-Amnesia:** RULES-CRITICAL.md checklist system

---

**Made in Ukraine 🇺🇦**
