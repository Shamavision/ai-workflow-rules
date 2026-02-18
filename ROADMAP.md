# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1 | **Status:** ✅ Production Ready
> **Last Updated:** 2026-02-18
> **Archive:** Full audit log → `ai-logs/ROADMAP-audit-2026-02-complete.md`

---

## ✅ Current Status: ALL AUDIT PHASES COMPLETE

**Comprehensive Framework Audit (2026-02-13 → 2026-02-17, Days 1-5)**

| Phase | Description | Status |
|-------|-------------|--------|
| Phase 1 | npm-templates sync | ✅ COMPLETE |
| Phase 2 | .gitignore security | ✅ COMPLETE |
| Phase 3 | Paths & references | ✅ COMPLETE |
| Phase 4 | Version consistency | ✅ COMPLETE |
| Phase 5 | Context files audit | ✅ COMPLETE |
| Phase 6 | Documentation review | ✅ COMPLETE |
| Phase 7 | Rules validation | ✅ COMPLETE |
| Phase 8.5 | sync-rules.sh v2.0 redesign | ✅ COMPLETE |
| Phase 8.6 | TOKEN_PRESETS sync | ✅ COMPLETE |
| Phase 8.7.1-8.7.6 | Token System 2026 (VARIANT B) | ✅ COMPLETE |
| Phase 8 | Distribution Package Audit | ✅ COMPLETE |

**Key achievements:**
- ✅ `verify-templates`: 22/22 files in sync (every phase)
- ✅ VARIANT B: 13 MODEL_3 plans with numeric ESTIMATE values
- ✅ `token-status.sh` v1.1: SESSION MODE for MODEL_3 providers
- ✅ `bin/cli.js`: 6 critical bugs fixed (contexts, MODEL_3 fields, missing copies)
- ✅ `npm pack`: 35 files, 164.9kB, no sensitive data
- ✅ `pre-commit` hook: fixed `set -e` + post-increment bug

---

## ✅ Phase 9: Installer Parity (COMPLETE)

> **Status:** ✅ COMPLETE — 2026-02-18
> **Commit:** e98070c

### Problem

Both `npx @shamavision/ai-workflow-rules` and `bash install.sh` should produce **identical results**.
Currently they do NOT — different source files, different file sets, different wizard behavior.

### Missing from BOTH installers (critical):

| File | npx (cli.js) | install.sh | Impact |
|------|-------------|------------|--------|
| `.ai/config.json` | ❌ NOT created | ⚠️ Dev version | CLAUDE.md → legacy mode! |
| `.claude/settings.json` | ❌ | ✅ | Claude Code settings missing |
| `.claude/hooks/user-prompt-submit.sh` | ❌ | ✅ | Auto-session start broken |
| `scripts/sync-rules.sh` | ❌ | ⚠️ Dev version | User can't update rules |
| `scripts/token-status.sh` | ❌ | ⚠️ Dev version | `npm run token-status` broken |

### install.sh additional bugs:

- Copies from dev repo root (NOT from `npm-templates/`) → wrong file set
- `${CYAN}` and `${GRAY}` undefined → garbled output
- "Daily %" in context table → should be "Session %"
- OpenAI in provider list → not in TOKEN_PRESETS (inconsistency)
- Copies ALL 20 dev scripts → only pre-commit + token-status + sync-rules needed
- `token-limits.json`: patches dev PRESETS file → should generate clean user config
- No MODEL_3 fields in generated token-limits.json

### Phase 9 Plan:

**Phase 9.1: Fix `bin/cli.js`** (~12-15k)
- Create `.ai/config.json` with selected context (CRITICAL)
- Copy `.claude/settings.json`
- Copy `.claude/hooks/user-prompt-submit.sh`
- Copy `scripts/sync-rules.sh`
- Copy `scripts/token-status.sh`
- (Provider list, token-limits stay as-is — already fixed in Phase 8)

**Phase 9.2: Rewrite `install.sh`** (~20-25k)
- Source: use `$TEMP_DIR/npm-templates/` (not dev root)
- Same wizard as cli.js: 9 providers, 4 contexts, hooks, gitignore, product rules
- Generate `.ai/config.json` with selected context (bash)
- Generate clean `token-limits.json` with MODEL_3 fields (bash version of createTokenLimitsConfig)
- Fix colors: add `CYAN` definition, replace `${GRAY}` with `${NC}`
- Fix "Daily %" → "Session %" in table
- Remove OpenAI (not in TOKEN_PRESETS), keep same 10 providers as cli.js
- Copy only user-facing scripts (pre-commit, token-status.sh, sync-rules.sh)
- Generate .cursorrules + .windsurfrules from selected context

**Phase 9.3: Verification** (~5k)
- Run both installers in temp dirs
- Diff outputs — must be identical
- Update verify-templates if needed
- Bump to v9.1.2, commit + push

### "Кролик" test checklist (AFTER Phase 9):

**Both install paths must pass:**
- [ ] Wizard runs without errors (colors display correctly)
- [ ] All 9 providers available with correct plans
- [ ] Context wizard: 3 questions → recommendation
- [ ] `.ai/config.json` created with selected context ← CRITICAL
- [ ] `.claude/CLAUDE.md` present (session start protocol works)
- [ ] `.claude/settings.json` present
- [ ] `.claude/hooks/user-prompt-submit.sh` present (auto-start)
- [ ] `.ai/AI-ENFORCEMENT.md` present
- [ ] `.ai/contexts/` all 4 files present
- [ ] `.ai/token-limits.json` has MODEL_3 fields for Claude Pro
- [ ] `.cursorrules` and `.windsurfrules` generated from selected context
- [ ] `scripts/sync-rules.sh` present (user can update rules)
- [ ] `scripts/token-status.sh` present (`bash scripts/token-status.sh` works)
- [ ] Pre-commit hook installed and executable
- [ ] `//START` command in Claude Code shows session start with correct context
- [ ] Ukrainian market: `ukraine-full` context loads language rules + product.md option

---

## 🐇 Phase 10: "Кролик" Fixes (from real-world test 2026-02-18)

> **Status:** 🔴 PLANNED — based on first кролик test (bash install, STUDIO project)

### Confirmed Issue #1: //start fails in existing conversation

**Root cause:** Claude Code loads `.claude/CLAUDE.md` ONCE at conversation start.
If user installs framework while conversation is already open → CLAUDE.md not loaded.
User types `//start` → AI doesn't recognize it (no project rules loaded).

**Evidence:** AI responded "//start не совпал ни с одним из скиллов" — no CLAUDE.md in context.

**Fix options:**
- **Option A (install.sh):** Update "Next steps" message → add "Open a **NEW conversation** in Claude Code after installation"
- **Option B (CLAUDE.md):** Add note about reloading
- **Option C (user-prompt-submit.sh):** Ensure hook works in VSCode extension (currently CLI-only)

**Priority:** 🔴 Critical UX — first impression of the framework.

### Confirmed Issue #2: Language question in wizard — DECISION MADE ✅

**Problem:** Wizard asks "Primary language for your project?" with options: en-US, uk-UA, ru-RU.

**Decision (2026-02-18):**
1. **Code comments** → always English (existing rule, no change needed)
2. **Chat language** → AI starts in Ukrainian + English translation, then adapts to user's language
3. **Wizard** → remove language question entirely, always set `"adaptive"`

**Files to change:**
- `install.sh`: remove language question + set `"adaptive"` in generated config.json
- `bin/cli.js`: remove language question + set `"adaptive"` in createAiConfig()
- `npm-templates/.claude/CLAUDE.md`: Step 3 — first response must be in Ukrainian + English
- `npm-templates/.ai/AI-ENFORCEMENT.md`: same startup language behavior

### Confirmed Issue #3: "Token budget priority?" question is confusing

**Problem:** Wizard asks "Token budget priority? High/Medium/Low" — framework jargon, not user-friendly.
Users don't know what "minimize usage" vs "full features" means in practice.

**What it does:** Sets `auto_approve_thresholds` in config.json (when AI warns about token usage).

**Decision (2026-02-18): Improve with human-friendly labels** — user should have a choice.

**New wording:**
```
How cautious should AI be with tokens?
  1) Careful   — warns early, fewer long tasks (recommended for Pro/subscription plans)
  2) Balanced  — standard warnings (recommended for most users)
  3) Relaxed   — minimal interruptions (good for API/pay-per-token plans)
```

**Files to change:** `install.sh`, `bin/cli.js`

### Confirmed Issue #4: "Ряд замечаний" — TBD

**Status:** User mentioned multiple additional bash install issues, details pending.
Will be documented after user provides full feedback.

### Fix Plan:

| Task | Priority | Status |
|------|----------|--------|
| Update "Next steps" in install.sh: "Open NEW conversation" | 🔴 Critical | ✅ DONE (docs updated) |
| Remove language question from wizard (decision: Option A) | 🔴 Critical | 🔴 PLANNED |
| Update CLAUDE.md + AI-ENFORCEMENT: start in Ukrainian+EN | 🔴 Critical | 🔴 PLANNED |
| Update "Next steps" in bin/cli.js: same message | 🔴 Critical | 🔴 PLANNED |
| Improve "Token budget priority?" with human-friendly labels | 🟠 High | 🔴 PLANNED |
| Collect full кролик feedback (bash install issues #4) | 🔴 Critical | ⏳ Awaiting user |
| Fix all bash install issues from feedback | 🔴 Critical | 🔴 PLANNED |
| Re-test кролик after fixes | 🟠 High | 🔴 PLANNED |

---

## 📊 Phase 11: Token Monitoring Rethink

> **Status:** 🔴 PLANNED — research required before implementation
> **Trigger:** кролик test revealed "~500k/day" is our own estimate, not Anthropic's real limit

### The Problem

Current framework claims to track daily token usage but cannot do so accurately for MODEL_3.

**Fundamental constraint (cannot be solved):**
- MODEL_3 providers (Claude Pro, Gemini Advanced, Cursor, Windsurf) do NOT expose daily usage APIs
- Anthropic does NOT disclose the real daily limit for Pro subscribers
- Cross-session tracking is impossible without provider API access

**What we CAN track (accurately):**
- SESSION tokens: AI sees its own context → accurate
- API-based providers (MODEL_1): Anthropic API has `/v1/usage` endpoint → accurate

**What we CANNOT track (honestly):**
- Daily usage across multiple conversations/tabs (MODEL_3)
- Real daily limit (MODEL_3 — intentionally undisclosed)

### Solution: "Honest Self-Reporting" (no provider API needed)

**Core idea:** AI writes its own token count to a log file. Progressive accumulation across sessions.

**Workflow:**
```
Session 1: start 09:00 → //TOKENS → AI writes 36k to log → closed
Session 2: start 11:30 → //TOKENS → reads log (36k) + writes 145k → closed
Session 3: start 15:00 → //TOKENS → sees "Today: 181k used, ~19k est. remaining" → STOP
```

**`session-log.json` format:**
```json
{
  "sessions": [
    {"date": "2026-02-18", "start": "09:00", "tokens": 36000, "status": "closed"},
    {"date": "2026-02-18", "start": "15:00", "tokens": 12000, "status": "active"}
  ]
}
```

**Honest limitations:**
- Accuracy depends on user running `//TOKENS` — more = better log
- If user never runs `//TOKENS`, log has only session starts (no token counts)
- Still better than fake numbers: "I don't know" > fabricated data

**Why this works universally:**
- No provider API needed → works for Claude Pro, Gemini, Cursor, Windsurf, API
- Simple bash + JSON → no dependencies
- AI itself is the source of truth for its own session

### Implementation Plan

| Task | Priority | What |
|------|----------|------|
| `user-prompt-submit.sh`: log session start to `session-log.json` | 🟠 High | +5 lines bash |
| `token-status.sh`: read `session-log.json` + show daily aggregate | 🟠 High | +20 lines bash |
| `//TOKENS` in CLAUDE.md: AI reads log + writes current count + reports | 🔴 Critical | AI behavior update |
| AI behavior: update log at `//COMPACT`, `//TOKENS`, phase completion | 🔴 Critical | CLAUDE.md rule |
| Ban prevention: "Slow responses = limit reached. Stop today." | 🔴 Critical | CLAUDE.md + token-status |
| MODEL_1 (API): add real `/v1/usage` checker for accurate tracking | 🟡 Medium | Future iteration |

### Key Principle

> Simple honest self-reporting > complex fake precision.
> "I don't know exact limit, but I know I used 181k today — be careful."

---

## 🔮 Future: v9.2 Ideas

> **Policy:** Only after Phase 10 (кролик fixes) complete.

| Idea | Priority | Notes |
|------|----------|-------|
| **install.ps1 parity** (Windows PowerShell) | 🔴 High | Same rewrite as Phase 9 for install.sh — uses dev root, wrong file set |
| `.continuerules` generation | 🟠 Medium | Both installers generate .cursorrules + .windsurfrules but NOT .continuerules — gap vs README |
| GitHub Actions CI for verify-templates | 🟡 Medium | Prevent drift in PRs |
| `//TOKENS` real-time dashboard | 🟡 Medium | Show actual session usage |
| Auto-context selector (AI detects project type) | 🔵 Low | v9.2 feature |
| v10.0: TypeScript rewrite of CLI | 🔵 Very Low | Breaking change |

---

## 📦 Package Info

```
Name:    @shamavision/ai-workflow-rules
Version: 9.1.1
Files:   35 (164.9kB packed, 497.4kB unpacked)
CLI:     npx @shamavision/ai-workflow-rules
```

**Architecture Models (2026):**
- `MODEL_1`: Hard Token Billing — Anthropic API, Mistral, DeepSeek, Google API
- `MODEL_2`: Request Quota — GitHub Copilot (300/month)
- `MODEL_3`: Fair Use Dynamic — Claude Pro, Gemini Advanced, Cursor, Windsurf

**Made in Ukraine 🇺🇦**
