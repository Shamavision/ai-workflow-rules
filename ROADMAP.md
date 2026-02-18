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

## 🔮 Future: v9.2 Ideas

> **Policy:** Only after Phase 9 + "кролик" feedback.

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
