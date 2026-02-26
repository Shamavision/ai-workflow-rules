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

### 1.1. SESSION-LOG WRITE PROTOCOL v2.0 (MANDATORY)

**Added 2026-02-19 (v1.x) — Redesigned 2026-02-24 (v2.0)**
**Universal token monitoring: message count = primary metric. Works for ALL AI tools.**

**Core truth:** AI counts messages EXACTLY. Token estimates had ±50% error.
Message frequency = what actually triggers rate limiting. This is the ground truth.

**TRIGGERS:**

| Trigger | Action | Key fields |
|---------|--------|------------|
| `//start` / session start | New session entry | `messages: 0`, `id: N+1` |
| `//TOKENS` | Update current session | `messages: N` (exact count) |
| `//COMPACT` | Save snapshot | `trigger: "compact"`, `messages: N` |
| `git push` | Increment pushes | handled by `post-push.sh` |
| Phase complete | Checkpoint | `trigger: "phase-complete"`, `messages: N` |

**session-log.json v2.0 schema (day-based):**

```json
{
  "_version": "2.0",
  "_philosophy": "Count events, not tokens. Day is truth.",
  "days": [
    {
      "date": "2026-02-24",
      "sessions": [
        {
          "id": 1,
          "tool": "claude-code",
          "trigger": "session-start",
          "timestamp": 1772002800,
          "messages": 0
        }
      ],
      "daily_total": {
        "sessions": 1,
        "messages": 0,
        "pushes": 0
      }
    }
  ]
}
```

- `messages` — REQUIRED for ALL AI (Level 1, exact count — not estimate)
- `bonus_tokens` — OPTIONAL (Level 2, Claude Code only, from .jsonl)
- v1.x files (with `"sessions"` root key) — ignored gracefully (backward compat)

**Step-by-step (for `//start`):**
```
1. Read .ai/session-log.json (create if missing with empty v2.0 structure)
2. NOW = Unix timestamp, today = local date (YYYY-MM-DD)
3. Find today's day entry; if missing → create:
   {date, sessions: [], daily_total: {sessions: 0, messages: 0, pushes: 0}}
4. LAST_TS = last session-start timestamp for today (0 if none)
5. GAP = NOW - LAST_TS
6. IF GAP > 7200 (2h) OR no sessions today:
   → Add: {id: N+1, tool, trigger: "session-start", timestamp: NOW, messages: 0}
   → daily_total.sessions += 1
   → Show: "🟢 New session started. (Gap: Xh since last activity)"
7. IF GAP < 7200: context refresh — NO write
   → Show: "📊 Continuing session. Today: X msgs (N sessions)"
8. IF different date: "🟢 New day! Yesterday: X msgs. Fresh limits today."
```

**Step-by-step (for `//TOKENS`):**
```
1. Read .ai/session-log.json
2. today = local date, find today's day entry
3. messages_this_session = count messages in current session (AI counts EXACTLY)
4. Update current session entry: messages = N
5. Update daily_total.messages = sum of sessions[].messages for today
6. Read presets.json → daily_message_soft_limit / hard_limit for this plan
7. OPTIONAL Level 2 (Claude Code only, graceful degradation):
   Parse ~/.claude/projects/*/*.jsonl → bonus_tokens {input, output, cache_reads}
8. Write updated session-log.json
9. Show [AI STATUS] v2.0 (format below)
```

**Level 2 bonus (Claude Code — skip gracefully if .jsonl unavailable):**
```bash
SESSION=$(ls -t "$HOME/.claude/projects/"*/*.jsonl 2>/dev/null | head -1)
if [ -n "$SESSION" ]; then
  input=$(grep -o '"input_tokens":[0-9]*' "$SESSION" | awk -F: '{s+=$2} END{print s}')
  output=$(grep -o '"output_tokens":[0-9]*' "$SESSION" | awk -F: '{s+=$2} END{print s}')
  cache=$(grep -o '"cache_read_input_tokens":[0-9]*' "$SESSION" | awk -F: '{s+=$2} END{print s}')
fi
```

**[AI STATUS] v2.0 — formats by tool type:**

*Universal (Level 1 — всі AI):*
```
[AI STATUS] 🟢
Context (сесія):       22% / 200k
Повідомлень сьогодні:  71 / ~120     ← ГОЛОВНИЙ ПОКАЗНИК
Сесій сьогодні:        2
Behavioral:            🟢 Normal
New day:               ✅ 2026-02-24
```

*Claude Code (Level 1 + Level 2 bonus):*
```
[AI STATUS] 🟢
Context (сесія):       22% / 200k
Повідомлень сьогодні:  71 / ~120
+ Токени (bonus):      45k input · 12k output · 782k cache
Сесій сьогодні:        2
Behavioral:            🟢 Normal
New day:               ✅ 2026-02-24
```

*Claude API (billing mode):*
```
[AI STATUS] 🟢
Context (сесія):       22% / 200k
Витрачено сьогодні:    $0.43 / $5.00 budget
Повідомлень:           71
New day:               ✅ 2026-02-24
```

**Behavioral status:**
- 🟢 Normal: `messages_today < daily_message_soft_limit`
- 🟡 Elevated: `messages_today >= soft_limit` (mention at next natural checkpoint)
- 🟠 High load: `messages_today >= hard_limit` OR 3+ sessions with context > 60%
- 🔴 Approaching limits: "overloaded" error seen → mention immediately

**HONESTY RULES (NON-NEGOTIABLE):**
- ✅ `messages`: AI counts EXACTLY — show as fact, not estimate
- ✅ `context %`: session tokens / context_window → AI knows exactly
- ❌ NEVER show "200k/day" as fact — it's context window, not daily limit
- ❌ NEVER fabricate daily token percentages (daily_limit = null = UNKNOWN)
- ✅ Billing: `access_type` in config.json → "subscription" = N/A; "billing" = show cost
- ✅ "Progressive truth > fabricated precision"

**Graceful degradation (web AI, no file system):**
> "Cross-session tracking requires a code editor. This session: ~X messages (estimate)."

**WHY v2.0 (diagnosis from 2026-02-23):**
- "daily_limit: 200k" was fiction — 200k = ONE session context window, not daily ❌
- AI token estimates ±50% error → unreliable for decisions ❌
- Message frequency = actual rate-limit metric ✅
- AI counts messages EXACTLY → single source of truth ✅

**FAILURE = VIOLATION:** Showing fake daily token percentages. Use message count as primary.

---

### 1.2. QUIET HELPER (SILENT GUARDIAN v2.0)

**Added 2026-02-24 — Behavioral monitoring that doesn't interrupt work**

**Philosophy:** Stay silent. Speak only when important. Never interrupt mid-task.

**Thresholds (based on `daily_message_soft_limit` from presets.json):**

| Messages today | When to speak | What to say |
|----------------|---------------|-------------|
| 0–60% of soft_limit | 🤫 SILENT | Nothing |
| 60–80% of soft_limit | At next git push only | "Сьогодні X повідомлень (~Y% soft limit)" |
| 80–90% of soft_limit | At push + //TOKENS | "⚠️ X/Y повідомлень — розглянь паузу після задачі" |
| 90%+ of soft_limit | At any natural moment | "🔴 X/Y — рекомендую зупинитись сьогодні" |
| >= hard_limit | IMMEDIATELY | "🔴 X/Y — HARD LIMIT. Пауза необхідна." |
| "overloaded" error | IMMEDIATELY | "Rate limit hit — пауза необхідна" |

**Natural moments to speak (ONLY these):**
- `git push` (shown after compression block)
- `//TOKENS` (shown in [AI STATUS] Behavioral line)
- `//COMPACT` (shown after summary)
- Phase complete checkpoint

**Rules:**
- ❌ NEVER interrupt mid-task with warnings
- ❌ NEVER show warning below 60% threshold
- ✅ One message per checkpoint (not repeated)
- ✅ Silent mode is the DEFAULT (speak only when threshold crossed)

**Example (80% threshold, shown at push):**
```
✓ Changes pushed to remote
⚠️ Сьогодні 97/120 повідомлень (81%) — наближаємось до soft limit.
Розглянь паузу після поточної задачі.
```

**Example (silent mode — 0–60%):**
```
✓ Changes pushed to remote
→ Compressing context...
[No message limit warning — operating in silent mode]
```

---

### 1.3. WEEKLY ACTIVITY BONUS (Optional — тільки при //TOKENS)

**Added 2026-02-24 — Pattern recognition for subscription planning**

**CONDITION:** Show ONLY if session-log.json has **7+ days** of data in `days[]`.
**TRIGGER:** `//TOKENS` command only.

**Format:**
```
[WEEKLY] 2026-02-17 → 2026-02-24
Пн: 47 повід · 1 push  🟢
Вт: 89 повід · 3 pushes 🟡 Активний
Ср: 12 повід · 0 pushes 🟢
Чт: 134 повід · 5 pushes 🟠 Важкий
Пт: 71 повід · 2 pushes 🟢
────────────────────────────────────
Всього: 353 повідомлення
Важких днів: 1/5
Порада: 🟢 Claude Pro достатньо для вашого ритму
```

**Day classification (relative to daily_message_soft_limit):**
- 🟢 Normal: messages < 60% soft_limit
- 🟡 Активний: 60–90% soft_limit
- 🟠 Важкий: ≥ 90% soft_limit (or "overloaded" error in that day)

**Advice logic:**
```
Важких 0–1/7 → "🟢 Claude Pro достатньо для вашого ритму"
Важких 2–3/7 → "🟡 Середнє навантаження. Поточний план підходить"
Важких 4+/7  → "🟠 Розгляньте Claude Team — часто наближаєтесь до лімітів"
```

**Rules:**
- ❌ DO NOT show if < 7 days of data in session-log.json
- ❌ DO NOT show if days are sparse (< 5 messages average)
- ✅ Show only at //TOKENS (not at every push)
- ✅ Data source: session-log.json `days[].daily_total`

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

4. **Reference patterns:** See `.ai/contexts/ukraine.context.md` section 7.3

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
✓ Language: Ukrainian + English (first response), then adaptive

Чим я можу вам допомогти? | What can I help you with?
```

**Language rule:** First response ALWAYS in Ukrainian + English. After user responds, match their language.

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

**Last Updated:** 2026-02-24
**Version:** 3.0 (v2.0 Token Monitoring — message-count ground truth, quiet helper, weekly bonus)
**Critical Protocols:** 8 (added 1.1 v2.0, 1.2 Quiet Helper, 1.3 Weekly Bonus)
**Compression Levels:** 3 (Light/Aggressive/Maximum)
**Triggers:** 5 (git push, 50% tokens, task completion, new task, 15+ messages)
**Primary Metric:** messages_today (exact) — replaces token estimates (±50% error)

---

**Made in Ukraine 🇺🇦**
