# AI Workflow Rules Framework

> **🚪 Entry point for all AI assistants**
> **Framework:** v9.1.1 | **Made in Ukraine 🇺🇦**

---

## 🚀 Quick Start

**New to this project?** → Read `PROJECT_IDEOLOGY.md` first (soul doc — WHY/WHO/PRODUCT/VISION, ~3k).

**Understand current state:** → Read `PROJECT_CONTEXT_MAP.md` (architecture snapshot, ~3k).

**Session Start Protocol:** → See [.claude/CLAUDE.md](.claude/CLAUDE.md)

---

## 🚨 AI ASSISTANT: SESSION START PROTOCOL

**MANDATORY before any work:**

1. **Load context:** Read `.ai/config.json` → Load appropriate `.ai/contexts/[context].context.md`
2. **Read session anchor:** Search `PROJECT_CONTEXT_MAP.md` for `## 📍 Last Push` section.
   Extract date → compare with today → `today != anchor_date` → 🟢 New day! / `today == anchor_date` → 📊 Same day.
3. **Load enforcement:** Read `.ai/AI-ENFORCEMENT.md` for mandatory protocols
4. **Display confirmation:**

```markdown
[SESSION START]
✓ Context loaded: [context_name] (~Xk tokens, v9.1 optimized)
✓ Token budget: ~Xk for rules
✓ Language: Adaptive (matches user's language)
✓ Session context: X% / 200k
✓ Messages today: N / ~limit    ← повідомлень (primary metric)
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]
✓ Last push: [YYYY-MM-DD] | [commit] | [🟢 New day! / 📊 Same day]

Чим я можу вам допомогти?
```

5. **Follow core principles:** Discuss → Approve → Execute | Token-conscious | Atomic commits

**User command trigger:** `//START` or `//start` → Execute this protocol immediately

> **Note:** Always type `//START` in a **new conversation**. Claude Code loads `.claude/CLAUDE.md` at conversation start — typing it in an existing conversation won't load the rules.

**Session anchor auto-update:** `scripts/post-push.sh` updates `## 📍 Last Push` in `PROJECT_CONTEXT_MAP.md` after every `git push`. New-day detection requires no API — just date comparison.

---

## 🔺 Skills Triangle (Claude Code)

The framework includes 3 skills that form a sequential analysis pipeline:

```
/ctx (Reality) → /sculptor (Clarity) → /arbiter (Order + Safety)
```

| Skill | Command | Output | Purpose |
|-------|---------|--------|---------|
| **Context** | `/ctx` | `PROJECT_CONTEXT_MAP.md` + `PROJECT_IDEOLOGY.md` | Full project scan — current state + ideology capture |
| **Sculptor** | `/sculptor` | `PROPOSALS.md` | 5-lens architectural analysis + mandatory WebSearch |
| **Arbiter** | `/arbiter` | `ARBITER_REPORT.md` | Execution order + risk scoring + ideology conflict detection |

**Typical run:** `/ctx update` → `/sculptor all` → `/arbiter all` → implement from ARBITER_REPORT.md

---

## 🎯 Key Commands

```bash
# Session management
//START    - Session start protocol (mandatory first command)
//TOKENS   - Show AI Status v2.0 (messages today / limit — primary metric)
//COMPACT  - Compress context (save 40-60% tokens)
//THINK    - Show AI reasoning
//REFRESH  - Re-read rules (anti-amnesia)

# Security checks
//CHECK:SECURITY  - Scan for vulnerabilities, secrets, API leaks
//CHECK:LANG      - Language compliance check (LANG-CRITICAL)
//CHECK:ALL       - Full audit (security + performance + lang + i18n)
```

---

## 🏗️ Framework Structure

```
.ai/                          # AI Framework Hub (v9.1)
├── contexts/                 # Context presets (loaded at session start)
│   ├── minimal.context.md    # ~10k tokens (startups, MVP)
│   └── ukraine-full.context.md  # ~18k tokens (Ukrainian market)
├── docs/                     # Documentation
├── rules/                    # Full rules reference
│   ├── core.md               # Complete workflow rules
│   └── product.md            # Ukrainian market rules
├── config.json               # Your configuration
├── AI-ENFORCEMENT.md         # Mandatory protocols for AI
├── presets.json              # Tool/plan token presets (source of truth)
└── forbidden-trackers.json   # Blocked tracking services
```

**Tool-specific files** (`.claude/CLAUDE.md`, `.cursorrules`, `.cursor/rules/ai-workflow.mdc`, `AGENTS.md`) are distributed to users via the installer and must be kept in sync with `npm-templates/`.

---

## 📊 Context Presets (v9.1)

| Context | Tokens | Best For |
|---------|--------|----------|
| **Minimal** | ~10k | Startups, MVP, simple projects |
| **Ukraine-Full** | ~18k | Ukrainian market compliance (default) |

**Change context:** Edit `.ai/config.json` → Set `"context": "minimal"` (or `"ukraine-full"`) → restart AI session.

---

## 💡 Core Principles

**Philosophy:** Quality > Speed | No Overengineering | Token-Conscious

- **Discuss → Approve → Execute** — Never code before approval
- **One stage = one commit** — Atomic commits
- **Security-first** — No secrets, no russian trackers
- **Token zones** — 🟢 Green → 🟡 Moderate → 🟠 Caution → 🔴 Critical

---

## 🔒 Security & Compliance

**Zero tolerance:**
- ❌ Hardcoded secrets (API keys, passwords)
- ❌ Russian tracking services (Yandex, VK, Mail.ru)
- ❌ `.ru` domains in production
- ❌ Committing `.env`, credentials, private keys

**Automatic protection:**
- ✅ Pre-commit hook: secrets, Russian trackers, prompt injection, PII detection
- ✅ Post-push hook: session anchor update in `PROJECT_CONTEXT_MAP.md`
- ✅ Token budget zones: 🟢→🟡→🟠→🔴

**Check compliance:** Run `//CHECK:ALL`

---

## ⚠️ Red Flags — Auto-Stop Conditions

**AI MUST stop and ask confirmation before:**

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

## 📁 Project Structure Reference

```
.
├── AGENTS.md              # ← YOU ARE HERE (entry point)
├── PROJECT_IDEOLOGY.md    # Soul doc — WHY/WHO/PRODUCT/VISION
├── PROJECT_CONTEXT_MAP.md # Auto-generated architecture snapshot
├── PROPOSALS.md           # Generated by /sculptor
├── ARBITER_REPORT.md      # Generated by /arbiter
├── .ai/                   # AI Framework Hub
│   ├── contexts/          # Context presets
│   ├── docs/              # Documentation
│   ├── rules/             # Full rules reference
│   └── *.json             # Configuration files
├── .claude/               # Claude Code configuration
│   ├── CLAUDE.md          # Session protocol (auto-loaded)
│   └── commands/          # Skills: /ctx, /sculptor, /arbiter
├── .cursor/rules/         # Cursor ≥0.45 rules (.mdc format)
├── .cursorrules           # Cursor <0.45 legacy rules
└── scripts/
    ├── pre-commit         # Security checks (auto-installed as hook)
    ├── post-push.sh       # Session anchor update (auto-installed as hook)
    └── sync-rules.sh      # Sync dev ↔ npm-templates pairs
```

---

## 🆘 Need Help?

- **Full vision:** `PROJECT_IDEOLOGY.md` (send this to AI for instant project context)
- **Current state:** `PROJECT_CONTEXT_MAP.md` (architecture snapshot, always fresh)
- **Issues/Support:** [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
- **Full docs:** See `.ai/docs/` directory

---

**Made with ❤️ in Ukraine 🇺🇦**
**License:** GPL v3
**GitHub:** [Shamavision/ai-workflow-rules](https://github.com/Shamavision/ai-workflow-rules)

---

**Last Updated:** 2026-02-23
**Framework Version:** 9.1.1
