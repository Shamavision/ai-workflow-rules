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

> **Status:** ✅ COMPLETE — implemented 2026-02-19
> **Priority:** #1 — implemented before Phase 10, 12, 13
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

**Current state — broken (confirmed 2026-02-19):**
- `token-status.sh` reads `daily_usage` from `token-limits.json` → always 0 → **total fiction**
- `session-log.json` does not exist (confirmed by file search)
- Every `npm run token-status` shows "Used: 0 tokens (0%)" — completely useless

### Architecture: "Time-Anchored AI Self-Reporting" (confirmed 2026-02-19)

**Core principle:**
```
Anchor: Local date (date +%Y-%m-%d) — universal constant, no provider API needed
Log:    .ai/session-log.json — simple append-only file
Writer: AI itself (at explicit triggers — NOT bash hooks)
Reader: AI at session start + token-status.sh script
```

**Support tiers:**
```
FULL    → Claude Code CLI/VSCode, Cursor, Windsurf  (AI + file system write)
SESSION → Claude Web, any web AI                    (session estimate only, no persistence)
```

**`session-log.json` — minimal schema:**
```json
{
  "_note": "AI self-reported token usage. Written at //TOKENS, //COMPACT, git push.",
  "sessions": [
    {"date": "2026-02-19", "tokens": 45000, "tool": "claude-code", "trigger": "//tokens"},
    {"date": "2026-02-19", "tokens": 20000, "tool": "cursor",      "trigger": "//compact"}
  ]
}
```

**Daily total** = `sessions.filter(date == today).sum(tokens)` — no separate `daily` object needed.

**`session-log.json` → `.gitignore`: YES** — personal usage data, privacy-first default.

**Universal `//TOKENS` protocol (same logic in ALL rule files):**
```
1. Read .ai/session-log.json (lazy init if missing)
2. today = local date (YYYY-MM-DD)
3. If last entry date != today → "🟢 New day! Yesterday: Xk. Fresh limits."
4. today_total = sum sessions where date == today
5. Estimate current session tokens (rules_load + conversation_length, ±30%)
6. Append: {date, tokens: estimate, tool: "tool-name", trigger: "//tokens"}
7. Show [TOKEN STATUS]
```

**Trigger points:**
| Trigger | Where defined | Action |
|---------|--------------|--------|
| `//TOKENS` | All rule files | read + estimate + write + show |
| `//COMPACT` | All rule files | compress + write |
| `git push` | CLAUDE.md only | POST-PUSH PROTOCOL + write |
| Phase complete | All rule files | show status + write |

**Graceful degradation (web AI):**
> "Cross-session tracking requires a code editor. This session: ~Xk tokens (estimate)."

**What we are NOT changing:**
- ❌ `user-prompt-submit.sh` — hook is CLI-only, adds complexity without universal benefit
- ❌ Monthly tracking — session/daily is sufficient
- ❌ Complex states, session IDs — YAGNI
- ❌ External dependencies — only `jq` (already required)

**Honest limitations:**
- Accuracy depends on trigger frequency (more triggers = better accuracy)
- Token estimates: ±30-50% (rough but honest — better than static 0%)
- No exact provider reset time → use local midnight as day boundary
- **Progressive truth > fabricated precision (always)**

### Implementation Sub-Phases

**Phase 11.1 — Schema + gitignore ✅ DONE**
- NEW: `npm-templates/.ai/session-log.json` (initial empty template)
- MOD: `.gitignore` — add `.ai/session-log.json`

**Phase 11.2 — AI Protocol ✅ DONE (8 files)**
Files (dev + npm-templates pairs = 8 files):
- `.claude/CLAUDE.md` + `npm-templates/.claude/CLAUDE.md` — `//TOKENS` protocol + write behavior
- `.ai/AI-ENFORCEMENT.md` + `npm-templates/.ai/AI-ENFORCEMENT.md` — formalize write triggers
- `.cursorrules` + `npm-templates/.cursorrules` — add `//TOKENS` section
- `.windsurfrules` + `npm-templates/.windsurfrules` — add `//TOKENS` section

**Phase 11.3 — token-status.sh v2.0 ✅ DONE**
- `scripts/token-status.sh` + `npm-templates/scripts/token-status.sh`:
  - Reads `session-log.json` for real daily totals (MODEL_3)
  - Overrides DAILY_USED with session-log data when available
  - Honest "📅 Daily Tracking" section replaces fake "Daily Usage"
  - "NEVER show fake daily %" rule enforced

**Phase 11.4 — Verify + Commit ✅ DONE**
- Verified symmetric changes (same diff stats dev↔npm-templates)
- All 8 rule files contain `//TOKENS` protocol + fake daily % fix
- `token-status.sh` v2.0 reads `session-log.json` for MODEL_3
- Phase 11 complete 2026-02-19

**Phase 11.5 — Time-Anchored Session Tracking ✅ DONE (2026-02-19)**

> **Motivation:** session-log.json entries lacked time anchor → couldn't detect session boundaries → //TOKENS showed merged daily total without per-session breakdown → confusing output.

**11.5.1 — session-log.json schema v1.1 ✅ DONE**
- Added `timestamp` field (Unix seconds) to schema
- Added `_session_logic` doc block: gap >7200s = new session
- Added `trigger: "session-start"` with `tokens: 0` as session boundary marker

**11.5.2 — user-prompt-submit.sh v2.0 ✅ DONE**
- Changed from "file-exists check" to gap-based detection (gap >7200s = new session)
- SESSION_MARKER now stores Unix timestamp (not just existence flag)
- Auto-writes `session-start` entry to `session-log.json` on new session (best-effort, `2>/dev/null || true`)

**11.5.3 — All 8 rule files updated ✅ DONE**
- `.claude/CLAUDE.md` + `npm-templates/.claude/CLAUDE.md`: timestamp in //TOKENS step 5, session breakdown in display, new `//start` gap-check section
- `.ai/AI-ENFORCEMENT.md` + `npm-templates/.ai/AI-ENFORCEMENT.md`: trigger table now has `session-start` row + timestamp column; JSON entry has `timestamp`; added `//start` step-by-step; [TOKEN STATUS] shows session breakdown
- `.cursorrules` + `npm-templates/.cursorrules`: timestamp in entry, session breakdown display, `//start` boundary section
- `.windsurfrules` + `npm-templates/.windsurfrules`: same as cursorrules (windsurf tool)

**11.5.4 — ROADMAP update + commit**
- Updated ROADMAP with Phase 11.5 details
- Commit: `feat(phase-11.5): time-anchored session tracking via timestamp in session-log.json`

**Updated session-log.json schema (v1.1):**
```json
{
  "_version": "1.1",
  "_schema": {"timestamp": "integer (Unix seconds — required for session boundary detection)"},
  "_session_logic": {
    "new_session": "gap > 7200 seconds (2h) since last entry = new session boundary",
    "context_refresh": "gap < 7200 = same session, //refresh only — no new log entry"
  },
  "sessions": [
    {"date": "2026-02-19", "tokens": 0,     "tool": "claude-code", "trigger": "session-start", "timestamp": 1740010000},
    {"date": "2026-02-19", "tokens": 45000, "tool": "claude-code", "trigger": "//tokens",       "timestamp": 1740012345}
  ]
}
```

### Key Principle

> Simple honest self-reporting > complex fake precision.
> "I don't know exact limit, but I know I used ~181k today — be careful."

---

## 🧪 Phase 12: Cross-AI Validation

> **Status:** 🔴 PLANNED — after Phase 11 implementation

### Goal
Verify that session-log.json tracking + `//TOKENS` command works correctly across ALL supported AI tools.

### Test Matrix

| AI Tool | Entry Point | Hook support | `//TOKENS` | New day detection | Status |
|---------|-------------|-------------|-----------|------------------|--------|
| Claude Code CLI | `.claude/CLAUDE.md` | ✅ `user-prompt-submit.sh` | ❓ TBD | ❓ TBD | 🔴 Not tested |
| Claude Code VSCode | `.claude/CLAUDE.md` | ❌ hooks CLI-only | ❓ TBD | ❓ TBD | 🔴 Not tested |
| Cursor | `.cursorrules` | ❓ Unknown | ❓ TBD | ❓ TBD | 🔴 Not tested |
| Windsurf | `.windsurfrules` | ❓ Unknown | ❓ TBD | ❓ TBD | 🔴 Not tested |
| Continue.dev | `.continuerules` | ❓ Unknown | ❓ TBD | ❓ TBD | 🔴 Not tested |
| Claude Web / Any AI | `AGENTS.md` | ❌ No hooks | ❓ TBD | ❓ TBD | 🔴 Not tested |

### Key Questions
- Do hooks work in Cursor/Windsurf at all?
- Does each AI correctly read/write `session-log.json`?
- Is `//TOKENS` behavior consistent across different rule file formats?

### Also in Phase 12: README + AGENTS.md Commands Audit

**Problem:** New commands appeared but README/AGENTS.md not updated.

Current README "AI Commands" table has: `//START`, `//TOKENS`, `//CHECK:*`, `//COMPACT`, `//THINK`

Commands that appeared or will appear — need audit:
- `//REFRESH` — reload rules (in CLAUDE.md, but is it in README?)
- `//UPDATE` — framework update (Phase 13, new)
- `//TOKENS` — verify format matches Phase 11 implementation
- `//WHICH:RULES`, `//CHECK:RULES` — in CLAUDE.md but not README?

**Task:** Compare ALL commands in `CLAUDE.md` + `AGENTS.md` vs README table → sync them.

### Also in Phase 12: README Token Monitoring Documentation

**Problem:** Users don't understand how token tracking works (especially MODEL_3 providers with unknown limits).

**Task:** Add dedicated section to README on GitHub explaining:
- Why token limits are "estimates" for Claude Pro / Cursor / Windsurf (MODEL_3)
- How session-log.json self-reporting works
- How AI uses time (new calendar day = fresh daily budget)
- What triggers token count writes (git push, //COMPACT, //TOKENS)
- How to read `//TOKENS` output correctly
- Practical advice: how to do quality monitoring as a user

**Format:** Simple, non-technical explanation. Analogies welcome.
**Location:** README.md → new section "Token Monitoring" OR expand existing "AI Commands" section.
**Goal:** User reads → immediately understands their daily budget picture.

---

## 🔄 Phase 13: Update Mechanism

> **Status:** 🔴 PLANNED — after Phase 10 (кролик has updates to receive)
> **Trigger:** кролик already installed v9.1.1, Phase 10 fixes are critical

### Problem

User installed the framework. Framework has critical updates. How do they update?

**Current state:**
- `sync-rules.sh` — regenerates tool files FROM contexts (not update mechanism)
- Re-running installer — skips existing files (`copy_file` checks if exists)
- No update mechanism exists at all

### What must be updated vs preserved

| Category | Files | Action on update |
|----------|-------|-----------------|
| **Framework files** | `.claude/CLAUDE.md`, `.ai/contexts/`, `AI-ENFORCEMENT.md`, `scripts/pre-commit`, `sync-rules.sh`, `token-status.sh` | ✅ Always update |
| **User config** | `.ai/config.json`, `.ai/token-limits.json` | ❌ Never overwrite |
| **User content** | `.ai/rules/product.md`, `AGENTS.md` | ⚠️ Ask user |

### Solution: Extend `sync-rules.sh` with `--update` flag (DECISION MADE)

**Key insight:** GitHub is already our source (install.sh clones from it). `sync-rules.sh` is already in user's project. Just add `--update` mode — no new scripts, no new dependencies.

```bash
bash scripts/sync-rules.sh           # existing: regenerate tool files from contexts
bash scripts/sync-rules.sh --update  # NEW: update framework files from GitHub
```

**Update mini-wizard:**
```
🔄 Checking for updates...
Current: v9.1.1  →  Latest: v9.2.0

Will UPDATE (framework):   Will PRESERVE (your config):
  ✅ .claude/CLAUDE.md       🔒 .ai/config.json
  ✅ .ai/contexts/ (all 4)   🔒 .ai/token-limits.json
  ✅ scripts/pre-commit       🔒 .ai/rules/product.md
  ✅ scripts/token-status.sh

Proceed? [Y/n]
```

**`//UPDATE` command** → AI runs `bash scripts/sync-rules.sh --update`

**Version check at `//START`** → compare `config.json` version vs GitHub → warn if outdated:
`"Update available: v9.2.0. Run bash scripts/sync-rules.sh --update"`

**Implementation:**
- `sync-rules.sh`: add `--update` mode (git clone → copy framework files → preserve config)
- `CLAUDE.md`: add `//UPDATE` trigger
- `package.json`: add `"update": "bash scripts/sync-rules.sh --update"` script

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
