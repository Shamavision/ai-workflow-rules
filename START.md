# 🤖 AI Assistant: Read This First

## Project Context

This project uses **AI Workflow Rules Framework v7.1 Universal** — a set of rules for safe and efficient AI-assisted development.

**✨ New in v7.1:** Universal AGENTS.md support for automatic rule loading across all AI tools!

---

## 🚀 Automatic Loading (Recommended)

**Most modern AI tools will load rules automatically from [`AGENTS.md`](AGENTS.md):**

✅ **Supported:**
- Claude Code (loads AGENTS.md)
- Cursor (loads AGENTS.md)
- Windsurf (loads AGENTS.md)
- Continue.dev (loads AGENTS.md)
- Aider (loads AGENTS.md)
- OpenAI Codex (loads AGENTS.md)
- Google Jules (loads AGENTS.md)
- Most AI coding assistants (AGENTS.md is the universal standard)

If your AI tool supports AGENTS.md, **you don't need to do anything** — rules will load automatically! 🎉

---

## 📖 Manual Loading (Fallback)

### For AI tools WITHOUT AGENTS.md support (ChatGPT Web, etc.):

## What You Need to Do

### 1. Read the Core Rules
**File:** [`RULES_CORE.md`](RULES_CORE.md)

This file contains:
- Session Start Protocol (mandatory!)
- Token Management system
- Security best practices
- Git workflow and commit rules
- Communication protocol (language rules)

### 2. Read the Product Rules
**File:** [`RULES_PRODUCT.md`](RULES_PRODUCT.md)

This file contains:
- i18n architecture (Ukrainian market focus)
- Device adaptation (themes, accessibility)
- Ukrainian market policy (zero tolerance for russian services)
- SEO/GEO strategy
- Forbidden tracking services (40+ patterns)

### 3. Check Token Limits
**File:** [`.ai/token-limits.json`](.ai/token-limits.json)

This file contains:
- Your provider and plan settings
- Daily and monthly limits
- PRESETS for all major AI providers (Anthropic, OpenAI, Google, Cursor, GitHub Copilot)
- Automatic tracking configuration

**Note:** If token tracking doesn't apply to you (e.g., ChatGPT web), you can skip this.

### 4. Follow the Rules
All rules are **mandatory** during this session:
- Use Russian for internal dialogue (communication with user)
- Use English for code, comments, commit messages
- Never hardcode secrets
- Never use russian tracking services (see `.ai/forbidden-trackers.json`)
- Always discuss before coding
- Create roadmaps for complex tasks

---

## Important Notes

### For AI Tools WITH Automatic Loading (Claude Code, Cursor, Windsurf, etc.)
✅ You already loaded RULES from `AGENTS.md` automatically — this file is optional reference.

**Auto-loaded file:**
- `AGENTS.md` (universal standard) ⭐

### For ChatGPT Web / Gemini Web / Other Manual AI
⚠️ You need to **manually read** RULES at the start of each session:

**How to use:**
1. Read [`AGENTS.md`](AGENTS.md) or [`RULES_CORE.md`](RULES_CORE.md)
2. Tell the AI: "Follow these rules throughout our conversation"
3. Start working

### For GitHub Copilot
⚠️ Limited context support. Focus on:
- Security rules (no secrets, no russian trackers)
- Code quality standards
- Basic workflow (discuss before changing)
- Check AGENTS.md periodically for guidance

---

## Critical Security Rules

### 🚨 NEVER Do This:
- ❌ Hardcode API keys, secrets, passwords in code
- ❌ Use russian tracking services (Yandex Metrika, VK Pixel, Mail.ru, etc.)
- ❌ Use `.ru` domains in production config
- ❌ Commit secrets to Git
- ❌ Skip pre-commit hooks (they protect you!)

### ✅ ALWAYS Do This:
- ✅ Use `process.env.VAR` for secrets
- ✅ Check [`.ai/forbidden-trackers.json`](.ai/forbidden-trackers.json) before adding any tracking service
- ✅ Run `./scripts/seo-check.sh` before deploying
- ✅ Follow Ukrainian market policy (if applicable to project)

---

## What If I Violate a Rule?

**STOP immediately and ask the user:**
```
[RULE VIOLATION DETECTED]
Rule: [which rule was violated]
Action: [what you were about to do]
Risk: [why it's dangerous]

Should I:
A) Skip this action
B) Find alternative approach
C) Proceed anyway (user override)
```

---

## File Structure Overview

```
project/
├── .ai/
│   ├── forbidden-trackers.json    # Blacklist of russian services
│   ├── locale-context.json        # Ukrainian market settings
│   └── token-limits.json          # AI budget tracking
│
├── scripts/
│   └── seo-check.sh               # Pre-deploy security check (9 audits)
│
├── RULES_CORE.md                  # Main AI workflow rules (YOU ARE HERE)
├── RULES_PRODUCT.md               # Product-specific rules (Ukrainian market)
├── START.md                       # This file
├── INSTALL.md                     # Installation guide
└── AI_COMPATIBILITY.md            # Which AI assistants are supported
```

---

## Quick Reference

| Rule | What to Do |
|------|-----------|
| **Language** | Russian for dialogue, English for code |
| **Secrets** | Always use env vars, never hardcode |
| **Russian services** | Zero tolerance, check `.ai/forbidden-trackers.json` |
| **Workflow** | Discuss → Approve → Code → Commit |
| **Tokens** | Check `.ai/token-limits.json`, optimize if running low |

---

## Ready to Start?

1. ✅ Read `RULES_CORE.md` (5 min)
2. ✅ Read `RULES_PRODUCT.md` (3 min)
3. ✅ Check `.ai/token-limits.json` (1 min)
4. ✅ Follow the rules

**Now you're ready to work safely and efficiently!** 🚀

---

<div align="center">

**AI Workflow Rules Framework v7.1 Universal**
*Made in Ukraine 🇺🇦 • Open Source (MIT License)*

**✨ New:** AGENTS.md support for universal AI compatibility

[GitHub](https://github.com/Shamavision/ai-workflow-rules) • [Issues](https://github.com/Shamavision/ai-workflow-rules/issues)

</div>
