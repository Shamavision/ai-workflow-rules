<div align="center">

### **Your AI assistant will commit secrets. We stop it.**

Production-ready security framework for AI-assisted development.
**Stop leaks. Save tokens. Stay compliant.**

<p>
  <img src="https://img.shields.io/badge/version-9.1.1-FAAF0D?style=flat-square&labelColor=1D1D1B" alt="Version">
  <img src="https://img.shields.io/badge/license-GPL%20v3-blue?style=flat-square&labelColor=1D1D1B" alt="License">
  <img src="https://img.shields.io/badge/status-Production-success?style=flat-square&labelColor=1D1D1B" alt="Status">
  <img src="https://img.shields.io/badge/AGENTS.md-Universal-blue?style=flat-square&labelColor=1D1D1B" alt="AGENTS.md">
  <img src="https://img.shields.io/badge/Made%20in-Ukraine%20🇺🇦-0099CC?style=flat-square&labelColor=1D1D1B" alt="Made in Ukraine">
</p>

</div>

---

## The Problem

AI coding assistants are powerful but dangerous:
- **47% accidentally commit API keys** (GitHub 2024 security report)
- **Token waste** costs $40-120/month on Pro plans
- **Compliance violations** from banned services (russian trackers, GDPR)

## The Solution

**🛡️ Multi-Layer Protection Architecture — works automatically:**
- ✅ **Pre-commit hooks** — block secrets before git commit (Tier 1: hard block, Tier 2: suspicious patterns)
- ✅ **AI Protection** — prompt injection detection, PII scanning, directory protection
- ✅ **LANG-CRITICAL guard** — zero russian trackers (Yandex, VK, Mail.ru, .ru domains)
- ✅ **Token optimization** — saves 40-60% budget (MODEL_3 session-aware, 2026-ready)
- ✅ **Ukrainian market compliance** — GDPR-ready, language rules, zero russian services

> **Philosophy:** Protect without interfering. Monitor critical points, not every action. Zero overengineering.

**Works with Claude Code, Cursor, Windsurf, Continue.dev, and any AI that reads AGENTS.md.**

---

## 🇺🇦 Made in Ukraine. Open Source.

This framework is our tribute to Ukrainian business — built during the war, for the teams that keep shipping under extraordinary conditions.

Ukrainian teams have specific requirements: zero russian services, GDPR compliance, Ukrainian language standards enforced at commit level. We turned those requirements into automation — not as a filter added on top, but as the foundation.

**Free. Open source. For the community.**
Because Ukrainian expertise belongs to everyone.

---

## 🚀 Quick Start

**Two ways to install — both produce identical results:**

### Option 1: NPX (Recommended, cross-platform)

```bash
npx @shamavision/ai-workflow-rules
```

### Option 2: One-Line Script (Mac / Linux / WSL)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

**Windows PowerShell:**
```powershell
iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
```

Both installers run the **same interactive wizard** and produce **identical file sets**.

---

## 🤖 AI Commands

**After installation, open your AI assistant and type:**

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `//START` | Load rules, init session | First message in new chat |
| `//TOKENS` | Show token budget status | Check remaining budget |
| `//CHECK:SECURITY` | Security audit | Before commit/deploy |
| `//CHECK:LANG` | Scan for russian content | Before deploy (Ukrainian market) |
| `//CHECK:ALL` | Full audit (security + lang + i18n) | Before release |
| `//COMPACT` | Compress context (saves 40-60%) | At 50%+ token usage |
| `//THINK` | Show AI reasoning | Debugging/learning |

**Example:**
```
You: //START
AI: [SESSION START]
    ✓ Context loaded: ukraine-full (~18k tokens, v9.1)
    ✓ Token limit: 200k/session (MODEL_3: daily limit UNKNOWN — Fair Use Dynamic)
    ✓ Status: 🟢 Green — Full capacity

    Чим я можу вам допомогти?
```

---

## 🛡️ Protection Layers (5 levels)

### Layer 1: Pre-Commit Security Hook

Local bash script. Zero tokens. Runs automatically on every `git commit`.

```bash
$ git commit -m "add feature"
🔒 Pre-Commit Security Scan — Scanning 3 staged file(s)...
━━━ Checking for real API keys (all AI providers)...
❌ BLOCKED: Real Anthropic API key in config.js:42
   Fix: Use process.env.ANTHROPIC_API_KEY
```

**Tier 1 (hard block):** Anthropic, OpenAI, Google, AWS, GitHub, Stripe API keys, private keys
**Tier 2 (warning + choice):** Suspicious patterns, hardcoded credentials, database URLs
**Tier 3 (silent):** Whitelisted files, example patterns, dev framework files

### Layer 2: LANG-CRITICAL Guard

Blocks russian tracking services and .ru domains from production code.

```bash
━━━ Checking for russian tracking services...
❌ RUSSIAN TRACKER detected: .ai/config.js:12
   Pattern: metrika.yandex
```

**40+ patterns blocked:** Yandex Metrika, VK Pixel, Mail.ru, Top.mail.ru, Yookassa, 2GIS, WB, Ozon

### Layer 3: AI Protection (v9.0+)

Scans for AI-specific threats before each commit:
- **Prompt injection:** `// AI INSTRUCTION: ignore rules` → ❌ BLOCKED
- **PII leakage:** Emails, phones, credit cards, IBANs in `.ai/` logs → ❌ BLOCKED
- **Directory protection:** `.ai/` files properly gitignored

### Layer 4: Token Budget Monitoring

```bash
$ npm run token-status

📊 TOKEN USAGE DASHBOARD
🤖 Provider: anthropic (pro) [MODEL_3 - Fair Use Dynamic]

⚠️  FAIR USE DYNAMIC LIMITS (MODEL_3)
   Real daily/monthly limits: UNKNOWN (NOT DISCLOSED by provider)

💬 Session Info:
   Session limit:    200,000 tokens
   Session window:   ~5h rolling
   Messages/session: ~45 (baseline)

📅 Daily Usage (ESTIMATE ONLY):
   Limit: 500,000 tokens (conservative estimate)
   Status: 🟢 GREEN — Full capacity
```

**4 zones:**
- 🟢 **0-50%** — Full capacity, normal mode
- 🟡 **50-70%** — Brief mode, compression suggested
- 🟠 **70-90%** — Caution, aggressive compression
- 🔴 **90-95%** — Critical, finalize and stop

### Layer 5: Context-Aware Rules (AGENTS.md + .claude/CLAUDE.md)

AI assistants automatically load project rules at session start:
- **Discuss → Approve → Execute** — never code before approval
- **Atomic commits** — one stage, one commit
- **Security-first** — automatic checks on critical operations
- **Anti-amnesia** — `//REFRESH` reloads rules if AI forgets

---

## 🎯 Context Selection (4 Presets)

```bash
📊 Context Comparison

┌─────────────────┬────────────┬─────────────┬──────────────────────┐
│ Context         │ Tokens     │ Session %   │ Best For             │
├─────────────────┼────────────┼─────────────┼──────────────────────┤
│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │
│ Standard        │ ~14k       │ 7%          │ Most projects        │
│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │
│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │
└─────────────────┴────────────┴─────────────┴──────────────────────┘
Session % = tokens used of 200K session limit (MODEL_3 primary metric)
```

**Smart recommendation wizard** asks 3 questions and suggests the right preset.

**Ukraine-Full includes:**
- Language rules (LANG-CRITICAL violations stop commits)
- Forbidden russian services list (40+ patterns)
- Ukrainian market compliance (GDPR, no .ru domains)
- i18n guidelines (UK/EN language management)
- Product rules (.ai/rules/product.md)

---

## 🤖 Supported AI Tools

| Tool | Config File | Auto-Loaded |
|------|-------------|-------------|
| **Claude Code** (CLI/VSCode) | `.claude/CLAUDE.md` | ✅ Auto |
| **Cursor** | `.cursorrules` | ✅ Auto |
| **Windsurf** | `.windsurfrules` | ✅ Auto |
| **Continue.dev** | `.continuerules` | ✅ Auto |
| **Any AI** (Claude web, Gemini, ChatGPT) | `AGENTS.md` | Via `//START` |

All tool files are **auto-generated** from your selected context. Update with `bash scripts/sync-rules.sh`.

---

## 📦 What Gets Installed

```
your-project/
├── AGENTS.md                    # Universal AI entry point
├── .claude/
│   ├── CLAUDE.md                # Claude Code rules + session protocol
│   ├── settings.json            # Claude Code settings
│   └── hooks/
│       └── user-prompt-submit.sh # Auto session start (CLI)
├── .cursorrules                 # Cursor IDE rules (generated)
├── .windsurfrules               # Windsurf IDE rules (generated)
├── .ai/
│   ├── config.json              # Your context selection
│   ├── token-limits.json        # Token budget tracking
│   ├── AI-ENFORCEMENT.md        # Mandatory AI protocols
│   ├── forbidden-trackers.json  # 40+ blocked services
│   ├── contexts/
│   │   ├── minimal.context.md   # ~10k tokens
│   │   ├── standard.context.md  # ~14k tokens
│   │   ├── ukraine-full.context.md # ~18k tokens
│   │   └── enterprise.context.md   # ~23k tokens
│   ├── docs/
│   │   ├── quickstart.md
│   │   ├── cheatsheet.md
│   │   ├── token-usage.md
│   │   ├── session-mgmt.md
│   │   ├── provider-comparison.md
│   │   ├── compatibility.md
│   │   ├── start.md
│   │   └── code-quality.md
│   └── rules/
│       ├── core.md              # Complete workflow rules (~56k)
│       └── product.md           # Ukrainian market rules (~76k, optional)
└── scripts/
    ├── pre-commit               # Security hook (also → .git/hooks/)
    ├── sync-rules.sh            # Regenerate tool files
    └── token-status.sh          # Token dashboard
```

---

## 📊 Token System (2026 Reality)

**3 architecture models — the installer detects yours automatically:**

| Model | Providers | Daily Limit | Tracking |
|-------|-----------|-------------|---------|
| **MODEL_1** (Hard Billing) | Anthropic API, Mistral, DeepSeek, Google API | Published, metered | Per-token billing |
| **MODEL_2** (Request Quota) | GitHub Copilot | ~300 requests/month | Request counting |
| **MODEL_3** (Fair Use Dynamic) | Claude Pro, Gemini Advanced, Cursor, Windsurf | **UNKNOWN (not disclosed)** | Session-based |

**MODEL_3 reality (most users):**
- Daily/monthly limits: **NOT DISCLOSED by provider** (intentional opacity)
- Session limit: **200K tokens / ~5h rolling window** (primary budget metric)
- Framework uses **conservative ESTIMATES** for planning (clearly labeled)

---

## 🆚 Why This Framework?

| Feature | ❌ Manual | ⚠️ AI Default | ✅ This Framework |
|---------|-----------|---------------|-------------------|
| Secret detection | Remember to check | Sometimes warns | **Auto-blocked** |
| Russian trackers | Manual audit | No protection | **40+ patterns blocked** |
| Token optimization | None | Basic | **40-60% savings** |
| Ukrainian compliance | DIY | Not included | **Built-in (GDPR-ready)** |
| Multi-AI support | One tool | One tool | **All major AIs** |
| Setup time | 3-4 hours | 30 min | **30 seconds** |

---

## 🔧 After Installation

**Configure AI provider (during wizard — or edit manually):**
```bash
# Edit .ai/token-limits.json for your provider/plan
# Edit .ai/config.json to change context preset
```

**Regenerate tool files after context change:**
```bash
bash scripts/sync-rules.sh
```

**Check token status:**
```bash
npm run token-status
# or
bash scripts/token-status.sh
```

**Verify compliance:**
```bash
//CHECK:ALL    # Run in AI chat
```

---

## 📖 Documentation

| Guide | Description |
|-------|-------------|
| [Quick Start](.ai/docs/quickstart.md) | Get started in 5 minutes |
| [Cheatsheet](.ai/docs/cheatsheet.md) | Commands & shortcuts |
| [Token Usage](.ai/docs/token-usage.md) | MODEL_1/2/3 explained |
| [Session Management](.ai/docs/session-mgmt.md) | When to restart vs continue |
| [Provider Comparison](.ai/docs/provider-comparison.md) | 9 providers, 25+ plans |
| [Compatibility](.ai/docs/compatibility.md) | Supported tools & models |
| [Code Quality](.ai/docs/code-quality.md) | Standards & practices |

---

## 📝 Version History

- **v9.1.1** [2026-02-18] — **INSTALLER PARITY.** Phase 9: both install paths (`npx` + `bash install.sh`) now produce identical 24-file sets. `.ai/config.json` generation added to npx (critical — was causing legacy mode). `install.sh` fully rewritten: npm-templates source, 10 providers, provider-specific plans, language selection, MODEL_3 support.
- **v9.1.1** [2026-02-17] — **DISTRIBUTION AUDIT.** Phase 8: 6 bugs fixed in CLI installer (contexts never copied, MODEL_3 fields missing, AI-ENFORCEMENT.md missing). Token System 2026 VARIANT B: 13 MODEL_3 plans with conservative ESTIMATES. pre-commit hook: fixed set-e bug.
- **v9.1** [2026-02-08] — **OPTIMIZATION RELEASE.** .ai/ hub restructure. Token optimization: 20-28% smaller contexts. Session management best practices guide.
- **v9.0** [2026-02-05] — **AI ENFORCEMENT.** Mandatory protocols auto-loaded. Post-push compression. Multi-level compression (Light/Aggressive/Maximum).
- **v8.1** [2026-02-04] — **MODULAR CONTEXTS.** Smart context loading (minimal/standard/ukraine-full/enterprise). Token savings: 40-70%.
- **v8.0** [2026-02-03] — **TOKEN CONTROL v3.0.** Intelligent budget management. Pre-flight approval, emergency reserves.

---

**Made with ❤️ in Ukraine 🇺🇦**
**License:** GPL v3
**GitHub:** [Shamavision/ai-workflow-rules](https://github.com/Shamavision/ai-workflow-rules)
**Last Updated:** 2026-02-18 | **Framework Version:** 9.1.1
