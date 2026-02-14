# 🤖 AI Assistant: Read This First

## 🔴 TOKEN PRE-FLIGHT CHECK (CRITICAL!)

**BEFORE ANY task >20k tokens, you MUST:**
1. ASK me: "How many tokens used TODAY?"
2. CALCULATE: remaining = daily_limit - daily_used
3. IF task > remaining → STOP + WARN + GET MY APPROVAL
4. NEVER start >20k work without this!

**Failure = 2 days downtime. NON-NEGOTIABLE!**

## 🔴 AI BEHAVIOR RULES (CRITICAL - NON-NEGOTIABLE!)

> **Added 2026-02-10 from ROADMAP Phase 1 - These rules override ALL other considerations!**

### Rule #1: КАЧЕСТВО > СКОРОСТЬ (Quality > Speed) - ALWAYS

**REQUIREMENT:**
- ✅ Attention to details - ВСЕГДА (ALWAYS)
- ✅ Quality > Speed - НЕ КОМПРОМИСС (NOT negotiable)
- ✅ Thorough approach to every task
- ❌ **NEVER** skip steps to save time/tokens
- ❌ **NEVER** do "quick verification" instead of detailed audit
- ❌ **NEVER** fly through tasks quickly

**This means:** Read files CAREFULLY, check assumptions THOROUGHLY, verify results COMPLETELY.

---

### Rule #2: Think Harder + "I Don't Know" Honesty - MANDATORY

**REQUIREMENT:**

✅ **ALWAYS think harder before answering**
- Deep analysis before responding
- NO quick assumptions
- Verify facts BEFORE stating them

✅ **If uncertain → say "I don't know"**
- Honesty about uncertainty is BETTER than guessing
- "I don't know" is a VALID and PROFESSIONAL answer

✅ **If need to guess → clearly state it's a guess**
- "This is my best guess based on..."
- "I estimate approximately... (not measured)"

✅ **If need to check → check FIRST, then answer**
- Use tools to VERIFY before claiming
- Never say "I checked" when you didn't actually check

❌ **NEVER fabricate facts/data**
❌ **NEVER pretend to know when you don't**
❌ **NEVER guess without saying it's a guess**

**Examples:**

❌ WRONG: "It's about 5k tokens" (guessing!)
✅ RIGHT: "I don't know exact count without measuring. Let me check..."

❌ WRONG: "Yes, file exists" (assuming!)
✅ RIGHT: "Let me check... Yes, confirmed it exists at [path]"

**Why critical:** Trust is the foundation. Guessing wastes time with wrong info.

---

### Rule #3: Token Status After EVERY Phase - STRICT

**REQUIREMENT:** After completing **EVERY phase/stage/major task**, ALWAYS display:

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
- ❌ NEVER start new phase without user confirmation
- ✅ ALWAYS show token status after completing phase
- ✅ ALWAYS show estimate for next phase
- ✅ ALWAYS wait for explicit approval

**Why this exists:** Prevents token limit violations, gives user budget control.

---

### Rule #4: No Auto-Commit/Push - User Control ONLY

**REQUIREMENT:**

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

**Why critical:** User controls git history, prevents unwanted commits.

---

**These 4 rules are MORE important than token savings or speed!**

---

## Project Context

This project uses **AI Workflow Rules Framework v7.1 Universal** — a set of rules for safe and efficient AI-assisted development.

**✨ New in v7.1:** Universal ../../AGENTS.md support for automatic rule loading across all AI tools!

---

## 🚀 Quick Start (Universal)

**⚡ Fastest way to start any AI session:**

Just type `//START` in your first message and the AI will:
1. Read ../../AGENTS.md automatically
2. Execute Session Start Protocol
3. Display `[SESSION START]` confirmation
4. Start working with full context

**✅ Works everywhere:** Claude Code CLI, VSCode Extension, Cursor, ChatGPT Web, Gemini, any AI tool!

---

## 📖 Automatic Loading (CLI/Cursor)

**Some AI tools load rules automatically from [`../../AGENTS.md`](../../AGENTS.md):**

✅ **Full auto-load (CLI only):**
- Claude Code CLI (loads ../../AGENTS.md + hooks work)
- Cursor (loads ../../AGENTS.md)
- Windsurf (loads ../../AGENTS.md)
- Continue.dev (loads ../../AGENTS.md)
- Aider (loads ../../AGENTS.md)

⚠️ **Partial support (../../AGENTS.md not auto-loaded, but CLAUDE.md works):**
- Claude Code VSCode Extension ✅ (Use `//START` - works via CLAUDE.md Layer 0!)
- OpenAI Codex (../../AGENTS.md support varies)
- Google Jules (../../AGENTS.md support varies)

💡 **Recommendation:** Use `//START` command to guarantee Session Start across all tools!
✨ **NEW:** VSCode Extension now fully supported via `.claude/CLAUDE.md` auto-loading!

---

## 📖 Manual Loading (Fallback)

### For AI tools WITHOUT ../../AGENTS.md support (ChatGPT Web, etc.):

## What You Need to Do

### 1. Read the Core Rules
**File:** [`../rules/core.md`](../rules/core.md)

This file contains:
- Session Start Protocol (mandatory!)
- Token Management system
- Security best practices
- Git workflow and commit rules
- Communication protocol (language rules)

### 2. Read the Product Rules
**File:** [`../rules/product.md`](../rules/product.md)

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
✅ You already loaded RULES from `../../AGENTS.md` automatically — this file is optional reference.

**Auto-loaded file:**
- `../../AGENTS.md` (universal standard) ⭐

### For ChatGPT Web / Gemini Web / Other Manual AI
⚠️ You need to **manually read** RULES at the start of each session:

**How to use:**
1. Read [`../../AGENTS.md`](../../AGENTS.md)
   **OR** read [`../rules/core.md`](../rules/core.md)
2. Tell the AI: "Follow these rules throughout our conversation"
3. Start working

### For GitHub Copilot
⚠️ Limited context support. Focus on:
- Security rules (no secrets, no russian trackers)
- Code quality standards
- Basic workflow (discuss before changing)
- Check ../../AGENTS.md periodically for guidance

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
├── .ai/                           # Framework hub (v9.1)
│   ├── contexts/                  # 4 context presets
│   ├── docs/                      # Documentation
│   │   ├── start.md              # This file
│   │   ├── compatibility.md       # AI assistants support
│   │   ├── quickstart.md          # 5-minute setup
│   │   └── ...                    # Other guides
│   └── rules/                     # Full rules
│       ├── core.md               # Main workflow rules
│       └── product.md            # Ukrainian market specifics
├── .claude/CLAUDE.md              # Session instructions
└── ../../AGENTS.md                      # Navigation hub
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

1. ✅ Read `../rules/core.md` (5 min)
2. ✅ Read `../rules/product.md` (3 min)
3. ✅ Check `.ai/token-limits.json` (1 min)
4. ✅ Follow the rules

**Now you're ready to work safely and efficiently!** 🚀

---

<div align="center">

**AI Workflow Rules Framework v7.1 Universal**
*Made in Ukraine 🇺🇦 • Open Source (MIT License)*

**✨ New:** ../../AGENTS.md support for universal AI compatibility

[GitHub](https://github.com/Shamavision/ai-workflow-rules) • [Issues](https://github.com/Shamavision/ai-workflow-rules/issues)

</div>
