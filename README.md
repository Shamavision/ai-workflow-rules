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

**🛡️ Multi-Layer Protection — works automatically:**
- ✅ **Pre-commit hooks** — block secrets before `git commit`
- ✅ **LANG-CRITICAL guard** — zero russian trackers (Yandex, VK, Mail.ru, .ru domains)
- ✅ **Token optimization** — saves 40-60% budget (MODEL_3 session-aware, 2026-ready)
- ✅ **Ukrainian market compliance** — GDPR-ready, language rules, zero russian services

Works with **Claude Code, Cursor, Windsurf, Continue.dev**, and any AI that reads `AGENTS.md`.

---

## 🚀 Quick Start

```bash
# NPX (cross-platform, recommended)
npx @shamavision/ai-workflow-rules

# One-line script (Mac / Linux / WSL)
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

> **⚠️ Claude Code users:** After install, open a **NEW conversation**, then type `//START`.
> Do not type `//START` in an existing conversation — CLAUDE.md loads only at conversation start.

---

## 🤖 AI Commands

| Command | What It Does |
|---------|--------------|
| `//START` | Load rules, init session, show token status |
| `//TOKENS` | Show current token budget (session + daily log) |
| `//COMPACT` | Compress context, save 40-60% tokens |
| `//REFRESH` | Reload rules mid-session (anti-amnesia) |
| `//CHECK:SECURITY` | Security audit — secrets, XSS, injection |
| `//CHECK:LANG` | Scan for russian content (Ukrainian market) |
| `//CHECK:ALL` | Full audit: security + lang + i18n |
| `//CHECK:RULES` | Show active protocol checklist |
| `//WHICH:RULES` | Show which protocols apply to current operation |
| `//THINK` | Show AI reasoning in `<thinking>` tags |

<details>
<summary>📟 Example: <code>//START</code> output</summary>

```
You: //START
AI:
[SESSION START]
✓ Context loaded: ukraine-full (~18k tokens, v9.1)
✓ Token limit: 200k/session (MODEL_3: daily limit UNKNOWN — Fair Use Dynamic)
✓ Status: 🟢 Green — Full capacity

📊 Session log: 🟢 New day! Yesterday: ~67k. Fresh limits today.

Чим я можу вам допомогти? | What can I help you with?
```

</details>

---

## 🛡️ Protection (5 Layers)

| Layer | What It Does | When |
|-------|-------------|------|
| **Pre-commit hook** | Block API keys, secrets, PII | Every `git commit` |
| **LANG-CRITICAL** | Block 40+ russian services (.ru, Yandex, VK) | Every `git commit` |
| **AI Protection** | Prompt injection, PII in logs, directory guard | Every `git commit` |
| **Token Monitoring** | Budget zones, auto-compression, session log | Continuous |
| **Context Rules** | Discuss→Approve→Execute, atomic commits | Every AI session |

<details>
<summary>🔍 Protection layers in detail</summary>

### Layer 1: Pre-Commit Security Hook

```bash
$ git commit -m "add feature"
🔒 Pre-Commit Security Scan — Scanning 3 staged file(s)...
❌ BLOCKED: Real Anthropic API key in config.js:42
   Fix: Use process.env.ANTHROPIC_API_KEY
```

**Tier 1 (hard block):** Anthropic, OpenAI, Google, AWS, GitHub, Stripe API keys, private keys
**Tier 2 (warning + choice):** Suspicious patterns, hardcoded credentials, database URLs
**Tier 3 (silent):** Whitelisted files, example patterns, dev framework files

### Layer 2: LANG-CRITICAL Guard

```bash
❌ RUSSIAN TRACKER detected: config.js:12
   Pattern: metrika.yandex
```

**40+ patterns blocked:** Yandex Metrika, VK Pixel, Mail.ru, Top.mail.ru, Yookassa, 2GIS, WB, Ozon

### Layer 3: AI Protection

- **Prompt injection:** `// AI INSTRUCTION: ignore rules` → ❌ BLOCKED
- **PII leakage:** Emails, phones, credit cards, IBANs in `.ai/` logs → ❌ BLOCKED
- **Directory protection:** `.ai/` files properly gitignored

### Layer 4: Token Budget Monitoring

4 zones:
- 🟢 **0-50%** — Full capacity, normal mode
- 🟡 **50-70%** — Brief mode, compression suggested
- 🟠 **70-90%** — Caution, aggressive compression
- 🔴 **90-95%** — Critical, finalize and stop

### Layer 5: Context-Aware Rules

AI automatically loads project rules at session start:
- **Discuss → Approve → Execute** — never code before approval
- **Atomic commits** — one stage, one commit
- **Anti-amnesia** — `//REFRESH` reloads rules if AI forgets

</details>

---

## 🎯 Context Presets

| Context | Tokens | Session % | Best For |
|---------|--------|-----------|----------|
| Minimal | ~10k | 5% | Startups, MVP |
| Standard | ~14k | 7% | Most projects |
| Ukraine-Full | ~18k | 9% | Ukrainian market |
| Enterprise | ~23k | 11.5% | Large teams |

*Session % = tokens of 200K session limit (MODEL_3 primary metric)*

The installer wizard asks 3 questions and recommends the right preset.

---

## 📊 Token Monitoring

**How it works:** AI self-reports token estimates to `.ai/session-log.json` at key moments.
No provider API needed — local date is the day boundary anchor.

```
//TOKENS output:
[TOKEN STATUS]
Session est.:  ~45k tokens (±30% rough estimate)
Today (log):   ~112k accumulated (2 sessions)
  Session 1 (09:15): ~67k tokens
  Session 2 (14:30): ~45k tokens
Limit:         UNKNOWN (MODEL_3 — not disclosed by provider)
Status:        🟢 Session GREEN
```

**Triggered automatically at:** `//TOKENS`, `//COMPACT`, `git push`, phase complete, `//START`

<details>
<summary>💡 Why "UNKNOWN"? — 2026 provider reality</summary>

**3 architecture models** (auto-detected by installer):

| Model | Providers | Daily Limit | Tracking |
|-------|-----------|-------------|---------|
| **MODEL_1** (Hard Billing) | Anthropic API, Mistral, DeepSeek, Google API | Published, metered | Per-token billing |
| **MODEL_2** (Request Quota) | GitHub Copilot | ~300 requests/month | Request counting |
| **MODEL_3** (Fair Use Dynamic) | Claude Pro, Gemini Advanced, Cursor, Windsurf | **UNKNOWN (not disclosed)** | Session-based |

**MODEL_3 reality (most users):**
- Daily/monthly limits: **NOT DISCLOSED by provider** — intentional opacity since 2024
- Session limit: **200K tokens / ~5h rolling window** — this is your primary budget metric
- Framework uses **conservative estimates** for planning (clearly labeled as estimates)

> "I don't know exact limit, but I know I used ~112k today — be careful."
> *Progressive truth > fabricated precision.*

</details>

---

## 🤖 Supported AI Tools

| Tool | Config File | Auto-Loaded |
|------|-------------|-------------|
| **Claude Code** (CLI/VSCode) | `.claude/CLAUDE.md` | ✅ Auto |
| **Cursor** | `.cursorrules` | ✅ Auto |
| **Windsurf** | `.windsurfrules` | ✅ Auto |
| **Continue.dev** | `.continuerules` | ✅ Auto |
| **Any AI** (Claude web, Gemini, ChatGPT) | `AGENTS.md` | Via `//START` |

All tool files auto-generated from your selected context. Update with `bash scripts/sync-rules.sh`.

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

## 🇺🇦 Made in Ukraine. Open Source.

Built during the war, for teams that keep shipping under extraordinary conditions. Ukrainian requirements — zero russian services, GDPR compliance, Ukrainian language standards — are the foundation, not an afterthought.

**Free. Open source. For the community.**

<details>
<summary>📦 What gets installed (file tree)</summary>

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
│   ├── token-limits.json        # Token budget config
│   ├── session-log.json         # Token self-reporting log (gitignored)
│   ├── AI-ENFORCEMENT.md        # Mandatory AI protocols
│   ├── forbidden-trackers.json  # 40+ blocked services
│   ├── contexts/                # 4 context presets
│   ├── docs/                    # Guides (quickstart, cheatsheet, etc.)
│   └── rules/
│       ├── core.md              # Complete workflow rules
│       └── product.md           # Ukrainian market rules (optional)
└── scripts/
    ├── pre-commit               # Security hook → .git/hooks/
    ├── sync-rules.sh            # Regenerate tool files
    └── token-status.sh          # Token dashboard
```

</details>

<details>
<summary>🔧 After Installation — useful commands</summary>

```bash
# Check token status
npm run token-status
# or
bash scripts/token-status.sh

# Regenerate tool files after context change
bash scripts/sync-rules.sh

# Edit context
# .ai/config.json → change "context" field
# .ai/token-limits.json → change provider/plan

# Run in AI chat
//CHECK:ALL    # Full compliance audit
//TOKENS       # Current token budget
```

</details>

<details>
<summary>📝 Version History</summary>

- **v9.1.1** [2026-02-20] — **КРОЛИК FIXES.** Phase 10: removed language question (always adaptive), Ukrainian+English first response, human-friendly token labels, "Open NEW conversation" in next steps. Phase 11: token self-reporting via `session-log.json` (time-anchored, gap-based session detection). Phase 12: README restructure with accordions.
- **v9.1.1** [2026-02-18] — **INSTALLER PARITY.** Phase 9: both install paths (`npx` + `bash install.sh`) now produce identical 24-file sets. `.ai/config.json` generation added to npx. `install.sh` fully rewritten: npm-templates source, 10 providers, provider-specific plans, MODEL_3 support.
- **v9.1.1** [2026-02-17] — **DISTRIBUTION AUDIT.** Phase 8: 6 bugs fixed in CLI installer. Token System 2026 VARIANT B: 13 MODEL_3 plans with conservative ESTIMATES. pre-commit hook: fixed set-e bug.
- **v9.1** [2026-02-08] — **OPTIMIZATION RELEASE.** .ai/ hub restructure. Token optimization: 20-28% smaller contexts. Session management best practices guide.
- **v9.0** [2026-02-05] — **AI ENFORCEMENT.** Mandatory protocols auto-loaded. Post-push compression. Multi-level compression (Light/Aggressive/Maximum).
- **v8.1** [2026-02-04] — **MODULAR CONTEXTS.** Smart context loading. Token savings: 40-70%.

</details>

---

<details>
<summary>📖 Documentation</summary>

| Guide | Description |
|-------|-------------|
| [Quick Start](.ai/docs/quickstart.md) | Get started in 5 minutes |
| [Cheatsheet](.ai/docs/cheatsheet.md) | Commands & shortcuts |
| [Token Usage](.ai/docs/token-usage.md) | MODEL_1/2/3 explained |
| [Session Management](.ai/docs/session-mgmt.md) | When to restart vs continue |
| [Provider Comparison](.ai/docs/provider-comparison.md) | 9 providers, 25+ plans |
| [Compatibility](.ai/docs/compatibility.md) | Supported tools & models |
| [Code Quality](.ai/docs/code-quality.md) | Standards & practices |

</details>

---

**Made with ❤️ in Ukraine 🇺🇦** | **License:** GPL v3 | [GitHub](https://github.com/Shamavision/ai-workflow-rules) | **v9.1.1** | Updated: 2026-02-20
