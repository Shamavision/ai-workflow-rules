# AI Workflow Rules Framework

> **🚨 AI ASSISTANT: READ THIS FIRST!**
>
> **MANDATORY SESSION START CHECK:**
> - If this is your **FIRST message** in this session
> - AND you have NOT yet displayed `[SESSION START]` confirmation
> - **STOP immediately** and execute Session Start Protocol (Section 🚀 below)
>
> **USER COMMAND TRIGGER:**
> - If user sends `//START` command → execute Session Start Protocol immediately
> - This is the universal session initialization trigger
>
> **DO NOT skip this step.** Session Start Protocol is MANDATORY before any other work.

---

> **Universal AI Agent Configuration**
> This file is automatically loaded by Claude Code, Cursor, Windsurf, Aider, Continue.dev, and other AI coding assistants supporting the AGENTS.md standard.

---

## 🚀 Session Start Protocol (MANDATORY)

**BEFORE any work in this session, AI MUST:**

1. **Load project rules (Smart Context Loading v8.1):**

   **NEW: Context-based loading for token efficiency**

   a. Read `.ai/config.json` to determine context preset
   b. Load context based on config:
      - `"minimal"` → Read `.ai/contexts/minimal.context.md` (~13k tokens)
      - `"standard"` → Read `.ai/contexts/standard.context.md` (~18k tokens)
      - `"ukraine-full"` → Read `.ai/contexts/ukraine-full.context.md` (~25k tokens)
      - `"enterprise"` → Read `.ai/contexts/enterprise.context.md` (~30k tokens)
      - **Fallback:** If no config → Read `RULES_CORE.md` (legacy mode)
   c. Read `.ai/token-limits.json` for budget tracking

   **Why:** Selective loading saves 40-70% tokens for specific users.

2. **Display SESSION START confirmation:**

```
[SESSION START]
✓ Context loaded: [context_name] (v8.1 Modular)
✓ Token budget: ~[context_tokens]k for rules ([percentage]% of daily)
✓ Language: Adaptive (matches user's language)
✓ Token limit: [daily_limit] daily ([provider] [plan])
✓ Current usage: [X]k ([Y]%) | Remaining: ~[Z]k
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]

Чим я можу вам допомогти?
```

**Examples:**
- Minimal: "✓ Context: minimal (~13k, 6.5% of daily)"
- Ukraine-full: "✓ Context: ukraine-full (~25k, 12.5% of daily)"

### 🧅 4-Layer Session Start Protection (ONION)

This protocol is enforced through **4 redundant layers** to guarantee execution:

**Layer 0: CLAUDE.md** (`.claude/CLAUDE.md`) ✨ **NEW: Universal VSCode/CLI Solution**
- Auto-loaded by Claude Code in EVERY session (CLI + VSCode Extension)
- Contains Session Start Protocol instructions
- Recognizes `//START` and `//start` commands
- **✅ WORKS EVERYWHERE:** CLI, VSCode Extension, and future Claude Code versions
- **Recommended approach** for maximum compatibility

**Layer 1: AGENTS.md Directive** (This file, lines 3-10)
- Prominent warning at top of AGENTS.md
- **✅ CLI/Cursor/Windsurf:** Auto-loaded via AGENTS.md standard
- **⚠️ VSCode Extension:** AGENTS.md not auto-loaded yet (use Layer 0 instead)

**Layer 2: User Prompt Hook** (`.claude/hooks/user-prompt-submit.sh`)
- Automatically injects Session Start instruction on first message
- Creates `.ai/.session-started` marker after execution
- **✅ CLI ONLY:** Works in Claude Code CLI
- **⚠️ VSCode Extension:** Hooks not supported yet ([bug #16114](https://github.com/anthropics/claude-code/issues/16114))

**Layer 3: Manual Fallback** (`scripts/session-init.sh`)
- Generate Session Start message manually
- Universal solution for ChatGPT Web, Gemini, and other AI tools
- Usage: `./scripts/session-init.sh | clip` (copy to clipboard)

**🎯 VSCode Extension Users (UPDATED):**
1. ✅ **Best:** Just type `//START` or `//start` in new chat (Layer 0 handles it automatically!)
2. Or: Type `//start` → Tab (snippet expands with details)
3. Or: Run `./scripts/session-init.sh | clip` → paste into chat
4. **Note:** Layer 0 (CLAUDE.md) solves the VSCode limitation!

**Why 4 layers?**
- Guarantees Session Start across all AI tools (CLI, VSCode, web, future)
- Layer 0 (CLAUDE.md) provides universal baseline for Claude Code
- No single point of failure
- Graceful degradation: if one layer fails, others activate
- Follows project's ONION security philosophy

3. **Follow core principles:**
   - Internal dialogue: **Adaptive** - match user's language (Ukrainian, Russian, or English) | Code comments/commits: English
   - Token-conscious: Monitor usage, optimize at 50%+
   - Discuss → Approve → Execute (never code before approval)
   - Stage-based workflow with atomic commits

---

## 📁 Project Structure

```
.
├── AGENTS.md              ← You are here (universal config)
├── RULES_CORE.md          ← Full AI workflow rules (v8.0, source of truth)
├── RULES_PRODUCT.md       ← Ukrainian market specifics
├── .ai/
│   ├── config.json        ← 🆕 Context selection (minimal/standard/ukraine-full/enterprise)
│   ├── registry.json      ← 🆕 Context & module metadata
│   ├── contexts/          ← 🆕 Pre-bundled context files
│   │   ├── minimal.context.md (~13k tokens)
│   │   ├── standard.context.md (~18k tokens)
│   │   ├── ukraine-full.context.md (~25k tokens)
│   │   └── enterprise.context.md (~30k tokens)
│   ├── token-limits.json  ← Token budget tracking
│   ├── locale-context.json
│   ├── forbidden-trackers.json
│   └── .session-started   ← Session marker (auto-generated, gitignored)
├── .claude/
│   ├── CLAUDE.md          ← ✨ Layer 0: Universal Session Start
│   ├── settings.json      ← Claude Code settings
│   └── hooks/
│       └── user-prompt-submit.sh  ← Layer 2: Auto Session Start (CLI only)
├── scripts/
│   ├── pre-commit         ← Security checks (secrets, trackers)
│   ├── seo-check.sh       ← Pre-deploy validation
│   └── session-init.sh    ← Layer 3: Manual Session Start
└── examples/              ← Production code examples
```

---

## 🎯 Core Principles

### 1. Token Management v2.0
- **Track usage** - Show status at 30%+ consumption
- **Auto-optimize** at 50%+ (diff-only, brief mode)
- **Compress context** after major commits (saves 40-60%)
- **Emergency mode** at 90%+ (commit only, hard stop)

**Token Status Zones:**
- 🟢 **0-50% (GREEN):** Full capacity, normal mode
- 🟡 **50-70% (MODERATE):** Brief mode, optimizations active
- 🟠 **70-90% (CAUTION):** Silent mode, aggressive compression
- 🔴 **90-95% (CRITICAL):** Finalization only, commit + stop

### 2. Language Rules
- **Internal dialogue (You ↔ AI):** Russian
- **Code comments:** English only
- **Commit messages:** English only (`type(scope): description`)
- **Variable/function names:** English, camelCase/PascalCase

### 3. Workflow Triggers
- `//START` - Execute Session Start Protocol (first message in new session)
- `//TOKENS` - Show current token status
- `//CHECK:SECURITY` - Security audit (secrets, XSS, injection)
- `//CHECK:LANG` - LANG-CRITICAL violations scan
- `//CHECK:ALL` - Full audit (security + performance + lang + i18n)
- `//COMPACT` - Manual context compression
- `//THINK` - Show reasoning in `<thinking>` tags

### 4. Git Discipline
- **One stage = one commit** (atomic)
- **Format:** `type(scope): description`
  - Types: `feat`, `fix`, `refactor`, `docs`, `security`, `i18n`, `rules`
- **AI suggests → I approve** - Never auto-commit
- **Post-push compression** - Mandatory after successful push

### 5. Security Guards
- ❌ Never hardcode secrets (use `process.env.VAR`)
- ❌ Never commit `.env`, `credentials.json`, private keys
- ❌ Never use russian tracking services (Yandex, VK, Mail.ru)
- ✅ Pre-commit hook scans for secrets/trackers automatically

---

## 📖 Detailed Documentation

**Full rules:**
- [RULES_CORE.md](RULES_CORE.md) - Complete workflow, token management, iterative process
- [RULES_PRODUCT.md](RULES_PRODUCT.md) - Ukrainian market, i18n, SEO, compliance

**Quick guides:**
- [QUICKSTART.md](QUICKSTART.md) - 5-minute setup
- [CHEATSHEET.md](CHEATSHEET.md) - One-page reference
- [TOKEN_USAGE.md](TOKEN_USAGE.md) - Token cost transparency

**Compatibility:**
- [AI_COMPATIBILITY.md](AI_COMPATIBILITY.md) - Tested AI assistants matrix
- [START.md](START.md) - Onboarding for new AI sessions

---

## 🔧 Project-Specific Notes

**Ukrainian Market Focus:**
- Zero tolerance for russian services (legal + security risk)
- GDPR-compliant by default
- i18n-ready architecture (uk-UA primary, multi-language support)

**Testing & Validation:**
- Pre-commit hooks: `scripts/pre-commit` (secrets, trackers, LANG-CRITICAL)
- Pre-deploy: `scripts/seo-check.sh` (9 automated checks)
- Git hooks installed: `.git/hooks/pre-commit`

**Tech Stack:**
- Node.js / React / Next.js (typical projects)
- TypeScript preferred
- Bash scripts for automation

---

## ⚠️ Red Flags - Auto-Stop Conditions

**STOP and ask confirmation if:**
- Deleting >10 files
- Changing core configs (`package.json`, `tsconfig`)
- Database migrations
- Major dependency updates
- `rm -rf` or recursive deletes
- Publishing to npm/production
- Auth/authorization changes
- **[LANG-CRITICAL]** Russian content detected
- **[AI-API-CRITICAL]** API key in client code
- **[TOKEN-CRITICAL]** >95% tokens used

---

## 📊 Success Metrics

**Session quality indicators:**
- ✅ Session Start Protocol executed
- ✅ Token status displayed at 30%+ usage
- ✅ Russian used for dialogue (English for code)
- ✅ Atomic commits with clear messages
- ✅ No secrets/trackers committed
- ✅ Context compressed after pushes

---

## 🆘 Emergency Commands

```bash
# Reset to safe state
git reset --soft HEAD~1

# Check what's staged
git status
git diff --cached

# Bypass hooks (emergency only!)
git commit --no-verify

# Check token usage
# AI should display automatically at 30%+

# Compress context manually
# Use: //COMPACT command
```

---

## 📝 Version History

- **v8.1** [2026-02-04] - **MODULAR CONTEXTS: UNIVERSAL TOKEN EFFICIENCY**. Smart context loading system with 4 pre-bundled contexts (minimal/standard/ukraine-full/enterprise). Config-based selection via `.ai/config.json`. Token savings: 40-70% for international users (13k vs 25k). Universal compatibility (Claude Code, Cursor, Windsurf, Aider, Continue, etc.). Progressive enhancement architecture. Zero vendor lock-in. See `.ai/contexts/` and `.ai/registry.json`.
- **v8.0** [2026-02-03] - **TOKEN CONTROL v3.0: INTELLIGENT BUDGET MANAGEMENT**. Major upgrade from reactive monitoring to proactive control. Pre-flight token approval, confidence-based estimation (HIGH/MEDIUM/LOW ±%), learning engine with variance tracking, emergency reserve protection (10-15%), smart batch detection, deferred execution queue, self-calibrating thresholds. Philosophy: "Control without dictatorship — inform, don't restrict." Target: 10-15% token savings without quality loss. See [RULES_CORE.md](RULES_CORE.md) Sections 2.14-2.18.
- **v7.2.1** [2026-02-02] - Repository made public. GitHub branch protection configured (onion_protect ruleset).
- **v7.2** [2026-02-02] - Added Layer 0: CLAUDE.md for universal VSCode Extension support. Now 4-layer protection system. Solves VSCode auto-load limitation.
- **v7.1** [2026-02-02] - Universal AGENTS.md support added
- **v7.0** [2026-02-01] - Production release with 3-layer protection
- **v6.1** [2026-02-01] - Post-push compression, focus optimization
- **v6.0** [2026-01-31] - Token Management v2.0, Session Start Protocol

---

## 🤝 Contributing

This is an open-source framework. See [README.md](README.md) for contribution guidelines.

**Made with ❤️ in Ukraine 🇺🇦**
**License:** MIT
**Website:** [wellme.ua](https://wellme.ua)

---

**Last Updated:** 2026-02-04
**Framework Version:** 8.1 (Modular Contexts v1.0)

---

## 🆕 What's New in v8.1 Modular

**Token Efficiency via Selective Loading:**
- ✅ 4 pre-bundled contexts (minimal/standard/ukraine-full/enterprise)
- ✅ Smart context selection via `.ai/config.json`
- ✅ Token savings: 40-70% for international users (13k vs 25k)
- ✅ **Universal compatibility:** Works in Claude Code, Cursor, Windsurf, Aider, Continue, etc.
- ✅ Progressive enhancement: start minimal, upgrade as needed
- ✅ Zero vendor lock-in: source RULES_CORE.md always available

**How It Works:**
1. AI reads `.ai/config.json` at session start
2. Loads appropriate context based on `config.context` value
3. Displays: "✓ Context loaded: [name] (~Xk tokens)"
4. **Fallback:** If no config → loads full RULES_CORE.md (legacy mode)

**Migration:** Existing projects work unchanged. New projects use npx installer with preset wizard.
