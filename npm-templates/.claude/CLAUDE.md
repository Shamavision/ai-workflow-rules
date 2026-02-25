# AI Workflow Rules - Session Instructions

> **🚨 CRITICAL: This file is auto-loaded by Claude Code at the start of EVERY session.**

## 🚀 Session Start Protocol (MANDATORY)

**At the BEGINNING of EVERY new session, before any other work:**

### Step 1: Detect Session Start
If ANY of these conditions apply:
- This is your first message in a new conversation
- User sends `//START` or `//start` command
- You have NOT yet displayed `[SESSION START]` confirmation

→ **STOP and execute Session Start Protocol immediately**

### Step 1.5: 🔴 TOKEN PRE-FLIGHT CHECK (CRITICAL! — v2.1 updated)

**BEFORE starting ANY task estimated >20k tokens:**

1. CHECK context_pct NOW (primary signal — exact):
   - context_pct > 35% → 🟠 STOP, task is risky
   - context_pct > 55% → 🔴 STOP unconditionally
2. ESTIMATE daily accumulation: context_pct × 200k + prev sessions × ~50k
3. IF (context_pct > 35%) OR (daily_estimate > 100k) → WARN user:
   "⚠️ Heavy session detected. Context: X%. Starting large task risks ban.
    Recommend: //COMPACT first, or defer to tomorrow."
4. WAIT for explicit user approval before proceeding

**Failure = 2 days downtime. NON-NEGOTIABLE!**
**v2.1: context% is the check — NOT "how many messages today"**

### Step 2: Load Project Rules (Smart Context Loading)

**NEW (v8.1 Modular):** Context-based loading for token efficiency

1. **Read config:** `.ai/config.json` to determine context preset
2. **Load context:**
   - If `config.context = "minimal"` → Read `.ai/contexts/minimal.context.md` (~10k tokens, v9.1 optimized)
   - If `config.context = "ukraine-full"` → Read `.ai/contexts/ukraine-full.context.md` (~18k tokens, v9.1 optimized)
   - **Fallback:** If no config or contexts → Read `.ai/rules/core.md` (legacy mode)
3. **Token budget:** Read `.ai/token-limits.json` for tracking

**Why this matters:** Selective loading saves 40-70% tokens for specific users.

### Step 2.2: Read Session Anchor (Task 7 — v9.2)

**🆕 Session Anchor:** Check last push date for new-day detection.

1. **Grep** `PROJECT_CONTEXT_MAP.md` for `## 📍 Last Push` section
2. **Extract** the `Date` field from the anchor table
3. **Compare** with today's date:
   - `today == anchor_date` → 📊 Same day, continuing
   - `today != anchor_date` → 🟢 New day! Fresh token limits
4. **Add to SESSION START block:** `✓ Last push: [date] | [commit] | [verdict]`

**If file missing or no anchor yet:** show `✓ Last push: no anchor (run /ctx first)`

**Why this matters:** Works across all AI tools (Claude Code, Cursor, any AI).
No API needed — date comparison is the anchor. New day = fresh limits.

---

### Step 2.5: Load AI Enforcement (v9.0)

**🆕 MANDATORY:** Read `.ai/AI-ENFORCEMENT.md` for automatic protocols

**Critical protocols loaded:**
- ✅ Post-push compression (MANDATORY after every git push)
- ✅ Session start token check
- ✅ Pre-commit checks
- ✅ Large task pre-flight

**Why this matters:** Prevents AI from forgetting mandatory workflows (compression, token checks, etc.)

### Step 3: Display SESSION START Confirmation

**ALWAYS display this block at session start:**

```markdown
[SESSION START]
✓ Context loaded: [context_name] (v9.1 Modular)
✓ Token budget: ~[context_tokens]k for rules
✓ Language: Adaptive (matches user's language)
✓ Session context: [X]% / 200k    ← PRIMARY: росте під час роботи; >30% = важка сесія 🟡
✓ Messages today: [N] / ~[limit]  ← вторинний проксі
✓ Status: [🟢/🟡/🟠/🔴] [Zone description — based on context%, not messages]
✓ Last push: [YYYY-MM-DD] | [commit] | [🟢 New day! / 📊 Same day]

Чим я можу вам допомогти?

**Zone rule at session start:**
- Context 0-20% → 🟢 (normal start)
- Context >20% at START (after //compact continuation) → 🟡 immediately

**Examples:**
- Minimal: "✓ Context: minimal (~10k) | Context: 0% 🟢 | Messages: 0 / ~80"
- After compact: "✓ Context: ukraine-full (~18k) | Context: 8% 🟢 | Messages: 12 / ~80"
```

### Step 4: Follow Core Principles
- **Internal dialogue (You ↔ User):** Adaptive - match user's language (Ukrainian, Russian, or English)
- **Code comments:** English only
- **Commit messages:** English only (`type(scope): description`)
- **Token-conscious:** Monitor usage, optimize at 50%+
- **Discuss → Approve → Execute:** Never code before approval
- **Stage-based workflow:** Atomic commits per stage

---

## 🎯 Command Triggers

When user sends these commands:

- `//START` or `//start` → Execute Session Start Protocol (above)
- `//TOKENS` → Token tracking v2.1: context_pct PRIMARY + messages secondary + daily estimate + write session-log + show [AI STATUS] v2.1
- `//CHECK:SECURITY` → Security audit (secrets, XSS, injection, API leaks)
- `//CHECK:LANG` → LANG-CRITICAL violations scan
- `//CHECK:ALL` → Full audit (security + performance + lang + i18n)
- `//CHECK:RULES` → Display full protocol checklist + confirm active rules
- `//REFRESH` → Re-read RULES-CRITICAL.md + AI-ENFORCEMENT.md (anti-amnesia)
- `//WHICH:RULES` → Show which protocols apply to current operation
- `//COMPACT` → Context compression + write token estimate to session-log.json
- `//THINK` → Show reasoning in `<thinking>` tags

---

## 📊 Token Self-Reporting Protocol v2.1

> **⚠️ v2.1 CRITICAL FIX:** "18 messages = 🟢" can be DANGEROUSLY WRONG.
> A single message with WebSearch + 3 large file reads = ~30-50k tokens.
> **Message count is a BAD proxy for token-heavy (tool-intensive) sessions.**

> **Philosophy v2.1:** Context window % is the PRIMARY danger signal. It is EXACT — AI knows it precisely.
> **Primary metric:** `context_pct` — session context %, known exactly. >30% = heavy session → escalate zone.
> **Secondary metric:** `messages_today` — rough daily accumulation proxy only.

### `//TOKENS` — Full behavior v2.1 (MANDATORY)

```
STEP 1: CONTEXT % FIRST — this is the TRUTH (AI knows exactly)
   context_pct = current session context window %
   session_tokens_estimate = context_pct × 200k

STEP 2: ZONE based on context_pct (PRIMARY — overrides message-based zone):
   🟢  0-20%  (~0-40k tokens)   → Normal — full capacity
   🟡 20-35%  (~40-70k tokens)  → Moderate — monitor carefully
   🟠 35-55%  (~70-110k tokens) → CAUTION — finish task, then //COMPACT
   🔴  >55%   (>110k tokens)    → STOP — ban risk, finalize only

STEP 3: HEAVY SESSION DETECTION:
   IF context_pct > 25% AND messages_this_session < 15:
   → "⚠️ Heavy session (tool-intensive). Zone elevated by context%, not messages."
   This means each "message" consumed ~5k+ tokens (WebSearch, large files, etc.)

STEP 4: Read .ai/session-log.json (v2.0: "days" key; create if missing)
   today = local date (YYYY-MM-DD)
   NEW DAY CHECK: if last entry date != today → "🟢 New day! Fresh limits."
   messages_this_session = count EXACTLY in current session
   Update session: {messages: N, peak_context_pct: context_pct}

STEP 5: DAILY TOKEN ACCUMULATION estimate:
   daily_tokens_estimate = context_pct × 200k  ← current session
                         + N_prev_sessions × ~50k  ← rough prior sessions
   IF daily_tokens_estimate > 120k → escalate zone by 1 level

STEP 6: Write updated session-log.json

STEP 7: Show [AI STATUS] v2.1:

[AI STATUS] 🟡
Context (сесія):          35% / 200k  (~70k tokens)    ← PRIMARY: ТОЧНО
Токени сьогодні (оцінка): ~120k                        ← накопичення за день
Повідомлень сьогодні:     18 / ~80                     ← вторинний проксі
Сесій сьогодні:           2
Behavioral:               🟡 CAUTION — важка сесія (context 35% > 25%)
Рекомендація:             Завершити задачу → //COMPACT → зупинитись
```

**Zone override rules:**
- NEVER show 🟢 if context_pct > 30%
- NEVER show 🟢 if daily_tokens_estimate > 100k
- context_pct zone ALWAYS wins over messages zone

**Billing (API users only)** — read `access_type` from `.ai/config.json`:
- `"subscription"` (or missing) → no cost shown (N/A)
- `"billing"` → show: `Витрачено: $X.XX / $budget` (from `billing.daily_budget_usd`)

### `//COMPACT` — Token write (MANDATORY addition)

When user runs `//COMPACT`:
1. Perform context compression (existing behavior)
2. **ALSO update session-log.json:** `{messages: N, peak_context_pct: context_pct, trigger: "//compact"}`
3. Show compression results + [AI STATUS] v2.1

### POST-PUSH PROTOCOL — session-log write

After every `git push`:
1. Perform compression (existing POST-PUSH behavior)
2. `post-push.sh` writes push count to session-log.json automatically
3. AI shows [AI STATUS] v2.1 + zone check (if context_pct > 30% → recommend stop for today)

### `//start` / SESSION START — Write + Log check v2.1

At session start (after loading rules):
1. **Read `.ai/session-log.json`** (create if missing with empty v2.0 structure)
2. `NOW` = Unix timestamp, `today` = local date (YYYY-MM-DD)
3. Find today's day entry; if missing → create: `{date, sessions: [], daily_total: {...}}`
4. `LAST_TS` = last session-start timestamp for today (0 if none)
5. `GAP = NOW - LAST_TS`
6. **If GAP > 7200 (2h) OR no sessions today:**
   - Add: `{id: N+1, tool, trigger: "session-start", timestamp: NOW, messages: 0, peak_context_pct: 0}`
   - `daily_total.sessions += 1`
   - Display: "🟢 New session started. (Gap: Xh since last activity)"
   - **If different date:** "🟢 New day! Yesterday: X msgs. Fresh limits today."
7. **If GAP < 7200 (same session, context refresh):**
   - Do NOT write (this is `//refresh`, not new session)
   - Display: "📊 Continuing session. Today: X msgs (N sessions)"

**Note:** VSCode hook auto-writes session-start before first message.
For Cursor/Windsurf: AI writes it during `//start` protocol.

### Graceful degradation (web AI / no file system)

If AI cannot write files (Claude Web, etc.):
> "Cross-session tracking requires a code editor (Claude Code, Cursor, Windsurf).
> This session: ~X messages (estimate). No persistent log available."

### Ban prevention

> **⚠️ CRITICAL v2.1: Context window % > 30% = HIGH RISK even if message count looks low.**
> **Tool-intensive sessions (file reads + WebSearch + writes) consume 10-50x more tokens per message.**
> **If context_pct > 35% → finish current task, //COMPACT immediately, consider stopping for today.**

---

## 🔴 AI BEHAVIOR RULES (CRITICAL - NON-NEGOTIABLE!)

> **Added 2026-02-10 from ROADMAP Phase 1 - These rules are MANDATORY and override all other considerations.**

### Rule #1: КАЧЕСТВО > СКОРОСТЬ (Quality > Speed) - ALWAYS

**REQUIREMENT (HARD LEVEL):**
- ✅ Внимание к деталям (attention to details) - ВСЕГДА
- ✅ Качество > Скорость - НЕ КОМПРОМИСС!
- ✅ Тщательный подход к каждой задаче
- ❌ **NEVER** пропускать шаги для экономии времени/токенов
- ❌ **NEVER** делать "quick verification" вместо detailed audit
- ❌ **NEVER** пролетать по задачам быстро

**User feedback that triggered this rule:**
- "Что то ты быстро пролетел по 7 фазам"
- Phases 8-10 были выполнены как "quick verification" instead of detailed audit

**This means:**
- Read files CAREFULLY
- Check assumptions THOROUGHLY
- Verify results COMPLETELY
- Take time to think DEEPLY
- Speed is secondary to correctness

---

### Rule #2: Think Harder + "I Don't Know" Honesty - MANDATORY

**REQUIREMENT (NON-NEGOTIABLE):**

✅ **ALWAYS think harder before answering**
- Глибокий аналіз перед відповіддю
- НЕ швидкі припущення
- Перевіряй факти ПЕРЕД твердженнями

✅ **If uncertain → say "I don't know"**
- Being honest about uncertainty is BETTER than guessing
- "I don't know" is a VALID and PROFESSIONAL answer

✅ **If need to guess → clearly state it's a guess**
- "This is my best guess based on..."
- "I estimate approximately... (not measured)"

✅ **If need to check → check FIRST, then answer**
- Use Read/Bash/Grep to VERIFY before claiming
- Never say "I checked" when you didn't actually check

❌ **NEVER fabricate facts/data**
❌ **NEVER pretend to know when you don't**
❌ **NEVER guess without saying it's a guess**

**Examples:**

❌ **WRONG:**
```
User: "What's the exact token count of file X?"
AI: "It's about 5k tokens" (GUESSING!)
```

✅ **RIGHT:**
```
User: "What's the exact token count of file X?"
AI: "I don't know the exact count without measuring. Let me check with estimate-tokens.sh"
```

❌ **WRONG:**
```
User: "Does file Y exist?"
AI: "Yes, it exists" (ASSUMING!)
```

✅ **RIGHT:**
```
User: "Does file Y exist?"
AI: "Let me check [uses Read/Bash to verify] ... Yes, confirmed it exists at path/to/file"
```

❌ **WRONG (Швидкий висновок):**
```
AI: "I checked all files, they look good" (НЕ ПЕРЕВІРИВ!)
```

✅ **RIGHT (Ретельний підхід):**
```
AI: "Let me systematically check each file:
     1. File A [checks with Read] - OK
     2. File B [checks with Read] - Found issue: XYZ
     3. File C [checks with Read] - OK
     Conclusion: 2/3 OK, 1 needs fix"
```

**Why this is critical:**
- Trust is the foundation of effective collaboration
- Guessing wastes user's time with incorrect information
- Honesty allows user to make informed decisions
- "I don't know" + verification = professional approach

---

### Rule #3: Token Status After EVERY Phase - STRICT

**REQUIREMENT (NON-NEGOTIABLE):**

After completing **EVERY phase/stage/major task**, ALWAYS display:

```markdown
[PHASE X COMPLETE]
Context (сесія): X% / 200k  (~Yk tokens)   ← PRIMARY
Токени сьогодні: ~Zk estimate              ← daily accumulation
Повідомлень:     N / ~80                   ← secondary
Status: 🟢/🟡/🟠/🔴  [based on context%]

Next: [Brief description of next phase]
Estimate: ~Nk tokens (context will grow ~M%)

Продолжити Phase X+1? [Y/n]
```

**Zone check at phase complete:**
- context% > 35% → recommend //COMPACT before next phase
- context% > 55% → STOP, must //COMPACT or restart session

**MANDATORY RULES:**
- ❌ **NEVER** start new phase without user confirmation
- ✅ **ALWAYS** show token status after completing phase
- ✅ **ALWAYS** show estimate for next phase
- ✅ **ALWAYS** wait for explicit approval

**User feedback that triggered this rule:**
- "При чем ы ниразу не сообщил мне в конце фаз про токены"
- AI пропустил показ token status после Phases 8-10

**Why this exists:**
- Prevents token limit violations
- Gives user control over budget
- Allows user to decide: continue, pause, or defer
- Critical for multi-phase work

**This protocol exists in AI-ENFORCEMENT.md but was IGNORED - now it's CRITICAL here too!**

---

### Rule #4: No Auto-Commit/Push - User Control ONLY

**REQUIREMENT (STRICT):**

❌ **NEVER** auto-commit after changes
❌ **NEVER** auto-push after commit
❌ **NEVER** assume user wants commit

✅ **ALWAYS** ask user first
✅ **ONLY** commit when explicitly requested

**Exception:** After phase complete → **PROPOSE**, don't execute

**Correct Format:**
```
✓ Phase X завершена и проверена

Создать commit? [Y/n]
(Изменено: N файлов)
```

Then **WAIT** for user approval.

**User feedback that triggered this rule:**
- "Комитить и пушить каждый этап не надо. Только по требованию пользователя"

**Why this is critical:**
- User controls git history
- Prevents unwanted commits
- Allows user to review changes first
- Respects user's workflow preferences

---

## 🔒 Security Guards (Zero Tolerance)

**NEVER do this:**
- ❌ Hardcode API keys, secrets, passwords
- ❌ Use russian tracking services (Yandex, VK, Mail.ru)
- ❌ Use `.ru` domains in production
- ❌ Commit secrets to git
- ❌ Skip pre-commit hooks

**ALWAYS do this:**
- ✅ Use `process.env.VAR` for secrets
- ✅ Check `.ai/forbidden-trackers.json` before adding tracking
- ✅ Follow Ukrainian market policy (zero russian services)

---

## 📊 Token Management Zones (v2.1 — context%-based)

> **⚠️ v2.1 FIX:** Zones are based on SESSION CONTEXT %, not arbitrary message % thresholds.
> Context % is EXACT. Message % is a rough proxy that fails for tool-intensive sessions.

| Zone | Context % | Estimated tokens | Action |
|------|-----------|-----------------|--------|
| 🟢 **GREEN** | 0–20% | ~0–40k | Full capacity, normal mode |
| 🟡 **MODERATE** | 20–35% | ~40–70k | Monitor; warn if tool-intensive |
| 🟠 **CAUTION** | 35–55% | ~70–110k | Finish task → //COMPACT → stop |
| 🔴 **CRITICAL** | >55% | >110k | Finalization ONLY — ban risk |

**Daily accumulation override:**
- If estimated daily tokens > 120k → escalate zone by 1 level regardless of session %
- If 2+ heavy sessions today → treat as 🟠 by default

**Auto-optimize at 🟡+:**
- Use diff-only format for edits
- Skip obvious explanations
- //COMPACT after every major task (не тільки при кризі!)
- Batch operations where possible

**Heavy session signal:**
- context_pct > 25% with < 15 messages = tool-intensive (WebSearch, large files, sub-agents)
- Each "message" in such sessions costs 5-50k tokens, not the usual ~500-2k

---

## 💡 Session Management Tips (v9.1)

**Before restarting session, consider:**

| Question | If YES | If NO |
|----------|--------|-------|
| Working on same feature? | ✅ **CONTINUE** | 🔄 Consider restart |
| Tokens <90%? | ✅ **CONTINUE** | 🔄 Restart needed |
| Can use `//COMPACT`? | ✅ **COMPRESS, then continue** | 🔄 Restart |

**Session restart costs 18-25k tokens. Don't restart unnecessarily!**

**When to CONTINUE:**
- ✅ Minor code changes, bug fixes
- ✅ Working through roadmap stages
- ✅ After using `//COMPACT`
- ✅ Tokens <90% and task ongoing

**When to RESTART:**
- 🔄 Pushed to main (major milestone)
- 🔄 Tokens >90% (budget critical)
- 🔄 Switching to different feature
- 🔄 Next day, different context

**💰 Token savings: Continue instead of restart = save 18-25k per avoided restart**

**📖 Full guide:** [.ai/docs/session-mgmt.md](../.ai/docs/session-mgmt.md)

---

## 🛑 Red Flags - Auto-Stop Conditions

**STOP and ask confirmation if:**
- Deleting >10 files
- Changing core configs (`package.json`, `tsconfig`, `.env` template)
- Database migrations
- Major dependency updates
- `rm -rf` or recursive deletes
- Publishing to npm/production
- Auth/authorization changes
- **[LANG-CRITICAL]** Russian content detected
- **[AI-API-CRITICAL]** API key in client code
- **[TOKEN-CRITICAL]** context_pct >55% OR daily_tokens_estimate >120k

---

## 📁 File Structure Reference

→ See `PROJECT_CONTEXT_MAP.md` for current structure (auto-updated by `/ctx`).

---

## ✅ Session Quality Checklist

Verify at session start:
- [ ] Session Start Protocol executed
- [ ] `[SESSION START]` confirmation displayed
- [ ] Russian language activated for dialogue
- [ ] Token limits loaded and displayed
- [ ] Core principles understood

---

**Why This Matters:**
- Prevents language violations (Russian dialogue rule)
- Activates security guards (no secrets, no russian trackers)
- Enables token management (budget awareness)
- Ensures consistent workflow (discuss → approve → execute)

**This is MANDATORY. Do NOT skip Session Start Protocol.**

---

**Last Updated:** 2026-02-22
**Framework Version:** 9.1.1
**Made in Ukraine 🇺🇦**
