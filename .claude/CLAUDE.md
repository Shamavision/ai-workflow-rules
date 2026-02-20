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

### Step 1.5: 🔴 TOKEN PRE-FLIGHT CHECK (CRITICAL!)

**BEFORE starting ANY task estimated >20k tokens:**

1. ASK: "How many tokens used TODAY already?"
2. CALCULATE: remaining = daily_limit - daily_used
3. IF task > remaining → STOP + WARN + GET APPROVAL
4. NEVER start >20k work without this check!

**Failure = 2 days downtime. NON-NEGOTIABLE!**

### Step 2: Load Project Rules (Smart Context Loading)

**NEW (v8.1 Modular):** Context-based loading for token efficiency

1. **Read config:** `.ai/config.json` to determine context preset
2. **Load context:**
   - If `config.context = "minimal"` → Read `.ai/contexts/minimal.context.md` (~10k tokens, v9.1 optimized)
   - If `config.context = "standard"` → Read `.ai/contexts/standard.context.md` (~14k tokens, v9.1 optimized)
   - If `config.context = "ukraine-full"` → Read `.ai/contexts/ukraine-full.context.md` (~18k tokens, v9.1 optimized)
   - If `config.context = "enterprise"` → Read `.ai/contexts/enterprise.context.md` (~23k tokens, v9.1 optimized)
   - **Fallback:** If no config or contexts → Read `.ai/rules/core.md` (legacy mode)
3. **Token budget:** Read `.ai/token-limits.json` for tracking

**Why this matters:** Selective loading saves 40-70% tokens for specific users.

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
✓ Context loaded: [context_name] (v8.1 Modular)
✓ Token budget: ~[context_tokens]k for rules ([percentage]% of daily)
✓ Language: Adaptive (matches user's language)
✓ Token limit: [daily_limit] daily ([provider] [plan])
✓ Current usage: [X]k ([Y]%) | Remaining: ~[Z]k
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]

Чим я можу вам допомогти?

**Examples:**
- Minimal: "✓ Context: minimal (~10k, 5% of daily)"
- Standard: "✓ Context: standard (~14k, 7% of daily)"
- Ukraine-full: "✓ Context: ukraine-full (~18k, 9% of daily)"
- Enterprise: "✓ Context: enterprise (~23k, 11.5% of daily)"
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
- `//TOKENS` → Token tracking: read session-log + estimate + write + show status
- `//CHECK:SECURITY` → Security audit (secrets, XSS, injection, API leaks)
- `//CHECK:LANG` → LANG-CRITICAL violations scan
- `//CHECK:ALL` → Full audit (security + performance + lang + i18n)
- `//CHECK:RULES` → Display full protocol checklist + confirm active rules
- `//REFRESH` → Re-read RULES-CRITICAL.md + AI-ENFORCEMENT.md (anti-amnesia)
- `//WHICH:RULES` → Show which protocols apply to current operation
- `//COMPACT` → Context compression + write token estimate to session-log.json
- `//THINK` → Show reasoning in `<thinking>` tags

---

## 📊 Token Self-Reporting Protocol (Phase 11)

> **Principle:** AI is its own source of truth. Time is the anchor. No provider API needed.

### `//TOKENS` — Full behavior (MANDATORY)

```
1. Read .ai/session-log.json
   → If missing: lazy init (create with empty sessions: [])
2. today = local date (YYYY-MM-DD)
3. NEW DAY CHECK: if last entry date != today
   → Show: "🟢 New day! Yesterday: ~Xk tokens. Fresh limits today."
4. today_total = sum of sessions[].tokens where date == today
5. Estimate current session (rough ±30-50%):
   - Rules loaded: ~18k (ukraine-full) / ~14k (standard) / ~10k (minimal)
   - + conversation length estimate
6. Append to sessions[]: {date, tokens: estimate, tool: "claude-code", trigger: "//tokens", timestamp: UNIX_NOW}
7. Show [AI STATUS] — 3-Layer Mental Model:

[AI STATUS]
Provider: Claude Pro (subscription)

Context Layer:  ~Xk / 200k (Y%)     ← AI knows exactly
Rate Layer:     🟢 Normal           ← estimated from patterns
Billing Layer:  N/A (subscription)

Status: 🟢 GREEN
```

**Billing Layer** shows `N/A (subscription)` for Claude Pro/subscription plans. For API plans: shows cost from `.ai/config.json` billing data. NEVER fabricate limits or percentages.

### `//COMPACT` — Token write (MANDATORY addition)

When user runs `//COMPACT`:
1. Perform context compression (existing behavior)
2. **ALSO write to session-log.json:**
   - Estimate session tokens so far
   - Append: `{date, tokens: estimate, tool: "claude-code", trigger: "//compact"}`
3. Show compression results + token status

### POST-PUSH PROTOCOL — Token write (MANDATORY addition)

After every `git push`:
1. Perform compression (existing POST-PUSH behavior)
2. **ALSO write to session-log.json:**
   - Append: `{date, tokens: estimate, tool: "claude-code", trigger: "git-push"}`

### `//start` / SESSION START — Write + Log check (Phase 11.5)

At session start (after loading rules):
1. **Read `.ai/session-log.json`** (if exists)
2. Get `NOW` = current Unix timestamp, `LAST_TS` = last entry's timestamp (0 if none today)
3. `GAP = NOW - LAST_TS`
4. **If GAP > 7200 (2h) OR no entry today:**
   - Write: `{date, tokens: 0, tool: "claude-code", trigger: "session-start", timestamp: NOW}`
   - Display: "🟢 New session started. (Gap: Xh since last activity)"
   - **If different date:** "🟢 New day! Yesterday: ~Xk. Fresh limits today."
5. **If GAP < 7200 (same session, context refresh):**
   - Do NOT write new entry (this is `//refresh`, not new session)
   - Display: "📊 Continuing session. Today: ~Xk (from log, N entries)"
6. **If file missing:** "📊 No session log yet — creating on first //TOKENS"

**Note:** VSCode hook (`user-prompt-submit.sh`) auto-writes session-start before first message.
For Cursor/Windsurf: AI writes it during `//start` protocol.

### Graceful degradation (web AI / no file system)

If AI cannot write files (Claude Web, etc.):
> "Cross-session tracking requires a code editor (Claude Code, Cursor, Windsurf).
> This session: ~Xk tokens (estimate). No persistent log available."

### Ban prevention

> **If responses become slow or "overloaded" errors appear → approaching daily limits.**
> **Recommended: stop working for today, resume tomorrow.**

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
Session tokens: Xk/200k (Y%)
Daily tokens: Zk/150k (W%)
Remaining: ~Nk
Status: 🟢/🟡/🟠/🔴

Next: [Brief description of next phase]
Estimate: ~Nk tokens

Продолжить Phase X+1? [Y/n]
```

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

## 📊 Token Management Zones

- 🟢 **0-50% (GREEN):** Full capacity, normal mode
- 🟡 **50-70% (MODERATE):** Brief mode, optimizations active
- 🟠 **70-90% (CAUTION):** Silent mode, aggressive compression
- 🔴 **90-95% (CRITICAL):** Finalization only, commit + stop

**Auto-optimize at 50%+:**
- Use diff-only format for edits
- Skip obvious explanations
- Compress context after major commits
- Batch operations where possible

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
- **[TOKEN-CRITICAL]** >95% tokens used

---

## 📁 File Structure Reference

```
.
├── AGENTS.md              # Project overview (auto-loaded, entry point)
├── .ai/                   # AI Framework Hub (v9.1 restructured)
│   ├── contexts/          # Pre-bundled context files (v9.1 optimized)
│   │   ├── minimal.context.md (~10k tokens)
│   │   ├── standard.context.md (~14k tokens)
│   │   ├── ukraine-full.context.md (~18k tokens)
│   │   └── enterprise.context.md (~23k tokens)
│   ├── docs/              # 🆕 Documentation hub
│   │   ├── quickstart.md
│   │   ├── cheatsheet.md
│   │   ├── token-usage.md
│   │   ├── session-mgmt.md  # v9.1 Session best practices
│   │   ├── compatibility.md
│   │   ├── start.md
│   │   └── provider-comparison.md
│   ├── rules/             # 🆕 Rules hub
│   │   ├── core.md        # Full AI workflow rules (v8.0, source of truth)
│   │   └── product.md     # Ukrainian market specifics
│   ├── config.json        # Context selection (minimal/standard/ukraine-full/enterprise)
│   ├── registry.json      # Context & module metadata
│   ├── token-limits.json  # Token budget tracking
│   ├── locale-context.json
│   └── forbidden-trackers.json
├── .claude/
│   ├── CLAUDE.md          # ← YOU ARE HERE (auto-loaded)
│   └── hooks/
│       └── user-prompt-submit.sh  # CLI-only auto Session Start
└── scripts/
    ├── pre-commit         # Security checks
    └── seo-check.sh       # Pre-deploy validation
```

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

**Last Updated:** 2026-02-07
**Framework Version:** 9.1 (Optimization Release)
**Made in Ukraine 🇺🇦**

---

## 🆕 What's New in v9.1 Optimization

**Content Optimization (15-35% token reduction):**
- ✅ Minimal: 13k → 10k (-23%)
- ✅ Standard: 18k → 14k (-22%)
- ✅ Ukraine-full: 25k → 18k (-28%)
- ✅ Enterprise: Now self-contained (~23k)

**Session Management Best Practices:**
- ✅ New guide: [`.ai/docs/session-mgmt.md`](../.ai/docs/session-mgmt.md)
- ✅ Continue vs restart decision guide
- ✅ Platform-specific tips (VSCode, Cursor, Windsurf)
- ✅ Expected savings: 50% fewer restarts = ~35-50k tokens/day

**Philosophy:** Evolution, not revolution. Quality > Speed. No overengineering.

**Migration:** Automatic - contexts updated in place. Read [.ai/docs/session-mgmt.md](../.ai/docs/session-mgmt.md) for best practices.
