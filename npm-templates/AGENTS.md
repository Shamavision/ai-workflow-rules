# AI Workflow Rules Framework

> **🚪 Entry point for all AI assistants**
> **Framework:** v9.1 Optimization | **Made in Ukraine 🇺🇦**

---

## 🚀 Quick Start

**New to the framework?** → [Quick Start Guide](.ai/docs/quickstart.md)

**Your AI will automatically load:**
- Context from: `.ai/contexts/[your-selection].context.md`
- Current selection: Check `.ai/config.json`
- Session Start Protocol: See [.claude/CLAUDE.md](.claude/CLAUDE.md)

---

## 🚨 AI ASSISTANT: SESSION START PROTOCOL

**MANDATORY before any work:**

1. **Load context:** Read `.ai/config.json` → Load appropriate `.ai/contexts/[context].context.md`
2. **Load enforcement:** Read `.ai/AI-ENFORCEMENT.md` for mandatory protocols
3. **Display confirmation:**

```markdown
[SESSION START]
✓ Context loaded: [context_name] (~Xk tokens, v9.1 optimized)
✓ Token budget: ~Xk for rules (Y% of daily)
✓ Language: Adaptive (matches user's language)
✓ Token limit: Zk daily ([provider] [plan])
✓ Current usage: Ak (B%) | Remaining: ~Ck
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]

Чім я можу вам допомогти?
```

4. **Follow core principles:** Discuss → Approve → Execute | Token-conscious | Atomic commits

**User command trigger:** `//START` or `//start` → Execute this protocol immediately

**Details:** See [.claude/CLAUDE.md](.claude/CLAUDE.md) Section "Session Start Protocol"

---

## 📚 Documentation

| Guide | Description | Tokens |
|-------|-------------|--------|
| [Quick Start](.ai/docs/quickstart.md) | Get started in 5 minutes | ~2k |
| [Cheatsheet](.ai/docs/cheatsheet.md) | Commands & shortcuts reference | ~3k |
| [Token Usage](.ai/docs/token-usage.md) | Understanding token costs | ~3k |
| [Session Management](.ai/docs/session-mgmt.md) | When to restart vs continue | ~4k |
| [Compatibility](.ai/docs/compatibility.md) | Supported AI tools & models | ~3k |
| [Getting Started](.ai/docs/start.md) | Onboarding guide | ~2k |
| [Provider Comparison](.ai/docs/provider-comparison.md) | AI provider comparison | ~3k |

---

## 📖 Full Rules

| Document | Description | Size |
|----------|-------------|------|
| [Core Rules](.ai/rules/core.md) | Complete workflow rules (v8.0) | ~56k |
| [Product Rules](.ai/rules/product.md) | Ukrainian market specifics | ~76k |

**Note:** AI loads context files (`.ai/contexts/*.context.md`) at session start, not these full rules. Full rules are reference documentation.

---

## 🎯 Key Commands

```bash
# Session management
//START    - Session start protocol (mandatory first command)
//TOKENS   - Show token usage status
//COMPACT  - Compress context (save 40-60% tokens)
//THINK    - Show AI reasoning

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
│   ├── standard.context.md   # ~14k tokens (most projects)
│   ├── ukraine-full.context.md  # ~18k tokens (Ukrainian market)
│   └── enterprise.context.md    # ~23k tokens (large teams)
├── docs/                     # Documentation
│   ├── quickstart.md
│   ├── cheatsheet.md
│   ├── token-usage.md
│   ├── session-mgmt.md
│   ├── compatibility.md
│   ├── start.md
│   └── provider-comparison.md
├── rules/                    # Full rules reference
│   ├── core.md               # Complete workflow rules
│   └── product.md            # Ukrainian market rules
├── config.json               # Your configuration
├── token-limits.json         # Token budget tracking
├── AI-ENFORCEMENT.md         # Mandatory protocols for AI
└── forbidden-trackers.json   # Blocked tracking services
```

**Tool-specific files** (`.claude/CLAUDE.md`, `.cursorrules`, `.windsurfrules`) are **auto-generated** from your selected context.

**Don't edit them directly.** Use `npm run sync-rules` to regenerate.

---

## 💡 Core Principles

**Philosophy:** Quality > Speed | No Overengineering | Token-Conscious

- **Discuss → Approve → Execute** - Never code before approval
- **One stage = one commit** - Atomic commits
- **Security-first** - No secrets, no russian trackers
- **Token zones** - 🟢 Green → 🟡 Moderate → 🟠 Caution → 🔴 Critical

---

## 📊 Context Comparison (v9.1 Optimized)

| Context | Tokens | Daily % | Best For | Includes |
|---------|--------|---------|----------|----------|
| **Minimal** | ~10k | 5% | Startups, MVP, simple projects | Core workflow, basic security |
| **Standard** | ~14k | 7% | Most projects (recommended) | + Git discipline, token management |
| **Ukraine-Full** | ~18k | 9% | Ukrainian market compliance | + Language rules, market policy, i18n |
| **Enterprise** | ~23k | 11.5% | Large teams, complex workflows | + Advanced patterns, enterprise features |

**Token savings (v9.1 optimization):**
- minimal: -23% (13k → 10k)
- standard: -22% (18k → 14k)
- ukraine-full: -28% (25k → 18k)
- enterprise: -23% (30k → 23k)

**Change context:**
1. Edit `.ai/config.json` → Set `"context": "standard"` (or minimal/ukraine-full/enterprise)
2. Run `npm run sync-rules` to regenerate tool files
3. Restart AI session

---

## 🔒 Security & Compliance

**Zero tolerance:**
- ❌ Hardcoded secrets (API keys, passwords)
- ❌ Russian tracking services (Yandex, VK, Mail.ru)
- ❌ `.ru` domains in production
- ❌ Committing `.env`, credentials, private keys

**Automatic protection:**
- ✅ Pre-commit hook scans for secrets/trackers
- ✅ AI Protection checks prompts for injection/PII
- ✅ Token budget monitoring prevents overuse

**Check compliance:** Run `//CHECK:ALL` command

---

## 🆘 Need Help?

- **Quick reference:** [Cheatsheet](.ai/docs/cheatsheet.md)
- **Getting started:** [Quick Start](.ai/docs/quickstart.md)
- **Token efficiency:** [Session Management](.ai/docs/session-mgmt.md)
- **Issues/Support:** [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
- **Updates:** Run `npm run sync-rules` to regenerate tool files

---

## 📁 Project Structure Reference

```
.
├── AGENTS.md              # ← YOU ARE HERE (entry point)
├── .ai/                   # AI Framework Hub
│   ├── contexts/          # Context presets
│   ├── docs/              # Documentation
│   ├── rules/             # Full rules reference
│   └── *.json            # Configuration files
├── .claude/               # Claude Code configuration
│   ├── CLAUDE.md          # Auto-generated (from .ai/contexts/)
│   └── hooks/             # CLI hooks
├── .cursorrules           # Auto-generated (Cursor IDE)
├── .windsurfrules         # Auto-generated (Windsurf IDE)
├── scripts/
│   ├── pre-commit         # Security checks
│   └── sync-rules.sh      # Regenerate tool files
└── examples/              # Production code examples
```

---

## ⚠️ Red Flags - Auto-Stop Conditions

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

## 📝 Version History

- **v9.1** [2026-02-08] - **OPTIMIZATION RELEASE**. Phase 7: .ai/ hub restructure. Clean root directory (only AGENTS.md). All docs → .ai/docs/, rules → .ai/rules/. Token optimization: 20-30% smaller contexts. Session management best practices. Enhanced compression. Zero feature loss.
- **v9.0** [2026-02-05] - **AI ENFORCEMENT**. Mandatory protocols auto-loaded. Post-push compression. Multi-level compression (Light/Aggressive/Maximum). Proactive token suggestions.
- **v8.1** [2026-02-04] - **MODULAR CONTEXTS**. Smart context loading system (minimal/standard/ukraine-full/enterprise). Token savings: 40-70% for international users.
- **v8.0** [2026-02-03] - **TOKEN CONTROL v3.0**. Intelligent budget management. Pre-flight approval, variance learning, emergency reserves.
- **v7.2** [2026-02-02] - Layer 0: CLAUDE.md for universal VSCode support. 4-layer protection system.

---

## 🎉 What's New in v9.1 Optimization

**Token Optimization (30-40% savings):**
- ✅ Optimized contexts: 20-28% smaller, same features
- ✅ Session management best practices (50% fewer restarts)
- ✅ Smart context selection wizard
- ✅ Enhanced auto-compression (3 levels)
- ✅ Token usage dashboard

**Clean Repository Structure:**
- ✅ Root: Only AGENTS.md (entry point)
- ✅ All documentation: .ai/docs/
- ✅ All rules: .ai/rules/
- ✅ Tool files: Auto-generated from contexts

**Migration:** Existing users run `scripts/migrate-to-hub.sh`

**Philosophy:** Evolution, not revolution. Quality > Speed. No overengineering.

---

**Made with ❤️ in Ukraine 🇺🇦**
**License:** MIT
**Website:** [wellme.ua](https://wellme.ua)
**GitHub:** [Shamavision/ai-workflow-rules](https://github.com/Shamavision/ai-workflow-rules)

---

**Last Updated:** 2026-02-08
**Framework Version:** 9.1 (Optimization Release)
