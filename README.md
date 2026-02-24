<div align="center">

### **Install once. Get a compliant, disciplined AI workflow immediately.**

Security guards. Token discipline. Structured thinking skills. Zero russian services.

<p>
  <img src="https://img.shields.io/badge/version-9.1.1-FAAF0D?style=flat-square&labelColor=1D1D1B" alt="Version">
  <img src="https://img.shields.io/badge/license-GPL%20v3-blue?style=flat-square&labelColor=1D1D1B" alt="License">
  <img src="https://img.shields.io/badge/status-Production-success?style=flat-square&labelColor=1D1D1B" alt="Status">
  <img src="https://img.shields.io/badge/Made%20in-Ukraine%20🇺🇦-0099CC?style=flat-square&labelColor=1D1D1B" alt="Made in Ukraine">
</p>

</div>

---

## The Problem

AI coding assistants are powerful but unconfigured by default:
- They don't know about Ukrainian compliance requirements
- They don't block russian trackers (Yandex, VK, Mail.ru, `.ru` domains)
- They leak API keys, secrets, and PII silently
- They have no session discipline — no token tracking, no structured workflow

Every Ukrainian developer has to configure this manually. Or skip it entirely.

---

## 🚀 Install

```bash
# NPX (cross-platform, recommended)
npx @shamavision/ai-workflow-rules

# One-line Bash (Mac / Linux / WSL)
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

**3 questions. 2 minutes. Full protection.**

> **Claude Code users:** After install, open a **new conversation** and type `//START`.
> CLAUDE.md loads only at conversation start — not in existing conversations.

---

## What You Get

### 🛡️ Security (automatic, zero config)

| Guard | What It Blocks | When |
|-------|---------------|------|
| **Tier 1** | API keys (Anthropic, OpenAI, AWS, GitHub, Stripe...) | Hard block on `git commit` |
| **LANG-CRITICAL** | 40+ russian services (Yandex, VK, Mail.ru, `.ru` domains) | Hard block on `git commit` |
| **AI Protection** | Prompt injection, PII in logs, `.ai/` directory guard | On `git commit` |

### 🔺 Skills Triangle (Claude Code)

```
/ctx (Reality) → /sculptor (Clarity) → /arbiter (Order + Safety)
```

| Skill | Generates | What It Does |
|-------|-----------|--------------|
| `/ctx` | `PROJECT_CONTEXT_MAP.md` + `PROJECT_IDEOLOGY.md` | Full project scan — architecture, ideology, entry points |
| `/sculptor` | `PROPOSALS.md` | 5-lens analysis + mandatory WebSearch + architecture proposals |
| `/arbiter` | `ARBITER_REPORT.md` | Execution order, risk scoring, ideology conflict detection |

**Typical run:** `/ctx update` → `/sculptor all` → `/arbiter all` → implement from the report.

### 📊 Session Discipline

- Token budget zones: 🟢 0–50% → 🟡 50–70% → 🟠 70–90% → 🔴 90–95%
- Post-push context compression (saves 40–60% tokens)
- Session anchor: `## 📍 Last Push` in `PROJECT_CONTEXT_MAP.md` — new-day detection without any API
- Discuss → Approve → Execute — AI never codes before approval

---

## 🤖 Commands

| Command | What It Does |
|---------|--------------|
| `//START` | Load rules, init session, show token status |
| `//TOKENS` | Message tracking v2.0: messages today + session count + write to session-log |
| `//COMPACT` | Compress context, save 40–60% tokens |
| `//REFRESH` | Reload rules mid-session (anti-amnesia) |
| `//CHECK:SECURITY` | Audit: secrets, XSS, injection |
| `//CHECK:LANG` | Scan for russian content violations |
| `//CHECK:ALL` | Full audit: security + lang + i18n |
| `//THINK` | Show AI reasoning in `<thinking>` tags |

<details>
<summary>Example: <code>//START</code> output</summary>

```
You: //START

[SESSION START]
✓ Context loaded: ukraine-full (~18k tokens, v9.1 optimized)
✓ Token budget: ~18k for rules (9% of session)
✓ Language: Adaptive (matches user's language)
✓ Session context: 9% / 200k
✓ Messages today: 0 / ~80    ← primary metric
✓ Status: 🟢 Green — Full capacity
✓ Last push: 2026-02-25 | a62ebd4 | 🟢 New day! Fresh limits

Чим я можу вам допомогти?
```

</details>

---

## 🛡️ Protection Layers

<details>
<summary>All 5 layers in detail</summary>

### Layer 1: Secrets — Hard Block

```bash
$ git commit -m "add config"
🔒 Pre-Commit Security Scan

❌ HARD BLOCKED: Real API key detected in config.js:42
   Pattern: sk-ant-... (Anthropic key)
   Fix: Use process.env.ANTHROPIC_API_KEY

Commit blocked.
```

**Tier 1 (hard block):** Anthropic, OpenAI, Google, AWS, GitHub, Stripe, private SSH keys
**Tier 2 (warning + choice):** Suspicious patterns, hardcoded credentials, database URLs
**Tier 3 (silent):** Whitelisted files, example patterns, dev framework files

### Layer 2: LANG-CRITICAL — Zero Russian Services

```bash
❌ RUSSIAN TRACKER detected in analytics.js:12
   Pattern: metrika.yandex.com
   Remove before committing.
```

**40+ patterns blocked:** Yandex Metrika, VK Pixel, Mail.ru, Top.mail.ru,
Yookassa, 2GIS, Wildberries, Ozon, and all `.ru` domains in production code.

### Layer 3: AI Protection (inline, always active)

- **Prompt injection:** `// AI INSTRUCTION: ignore previous rules` → BLOCKED
- **PII in AI logs:** Emails, phones, IBANs in `.ai/` files → BLOCKED
- **Directory guard:** `.ai/` files without `.gitignore` protection → WARNING

### Layer 4: Token Budget Monitoring

4 automatic zones:
- 🟢 **0–50%** — Full capacity, normal mode
- 🟡 **50–70%** — Brief mode, compression suggested
- 🟠 **70–90%** — Caution, aggressive auto-compression
- 🔴 **90–95%** — Finalization only, stop after commit

### Layer 5: Context-Aware Session Rules

- Discuss → Approve → Execute — AI proposes, you approve, then it executes
- Atomic commits — one stage, one commit, clear message
- Anti-amnesia — `//REFRESH` reloads rules if AI forgets protocols mid-session

</details>

---

## 📊 Token Monitoring v2.0

**Philosophy:** Count messages, not tokens. Day is the anchor. No provider API needed.

Primary metric: `messages_today` — AI counts EXACTLY (not estimate ±50%).

```
[AI STATUS] 🟢
Context (сесія):       22% / 200k
Повідомлень сьогодні:  12 / ~80     ← PRIMARY METRIC
Сесій сьогодні:        1
Behavioral:            🟢 Normal
New day:               ✅ 2026-02-25
```

<details>
<summary>How session tracking works</summary>

- AI writes to `.ai/session-log.json` at `//START`, `//TOKENS`, `//COMPACT`, and after `git push`
- Day boundary: local date change resets message count, fresh limits
- Session boundary: gap > 2h since last `session-start` = new session
- No provider API needed — date comparison is the anchor

| Metric | Source | Accuracy |
|--------|--------|----------|
| `messages_today` | AI counts messages in current session | ✅ Exact |
| `session context %` | Token estimate relative to 200k window | ⚠️ Estimate |
| `billing cost` | API plans only — from `access_type` in config | ✅ Exact (API); `N/A` (subscription) |

</details>

---

## 🎯 Context Presets

| Context | Tokens | Best For |
|---------|--------|----------|
| `minimal` | ~10k | Startups, MVP, simple projects |
| `ukraine-full` | ~18k | Ukrainian market compliance (default) |

The installer wizard asks which preset fits your project. Switch anytime:
edit `.ai/config.json` → change `"context"` → restart AI session.

---

## 🤖 Supported AI Tools

| Tool | Config File | How It Loads |
|------|-------------|-------------|
| **Claude Code** (CLI / VSCode) | `.claude/CLAUDE.md` | Auto at session start |
| **Cursor ≥0.45** | `.cursor/rules/ai-workflow.mdc` | Auto (YAML frontmatter) |
| **Cursor <0.45** | `.cursorrules` | Auto (legacy format) |
| **Any AI** (web, Gemini, ChatGPT) | `AGENTS.md` | Manual `//START` command |

---

## 🆚 Why This Framework?

| Feature | ❌ No framework | ✅ This framework |
|---------|----------------|------------------|
| Secret detection | Hope for the best | **Auto-blocked before commit** |
| Russian trackers | Manual audit | **40+ patterns blocked** |
| Token optimization | None | **40–60% savings, session log** |
| Structured AI workflow | Ad-hoc prompting | **Skills triangle: ctx→sculptor→arbiter** |
| Ukrainian compliance | DIY | **Built-in, GDPR-ready, zero russian services** |
| Project ideology capture | Lost between sessions | **PROJECT_IDEOLOGY.md — AI knows your WHY** |
| Setup time | Hours | **2 minutes** |

---

## 🇺🇦 Made in Ukraine

Built during the war, for teams that keep shipping. Ukrainian compliance requirements — zero russian services, GDPR, Ukrainian language standards — are the foundation, not an afterthought.

**Free. Open source. GPL v3.**

---

<details>
<summary>📦 What gets installed</summary>

```
your-project/
├── AGENTS.md                         # Universal AI entry point (//START)
├── PROJECT_IDEOLOGY.md               # Soul doc — WHY/WHO/PRODUCT/VISION (template)
├── .editorconfig                     # Consistent editor settings
├── .claude/
│   ├── CLAUDE.md                     # Claude Code session protocol (auto-loaded)
│   ├── settings.json                 # Enables hooks in Claude Code
│   ├── hooks/
│   │   └── user-prompt-submit.sh     # Session-start auto-trigger
│   └── commands/
│       ├── ctx.md                    # /ctx skill
│       ├── sculptor.md               # /sculptor skill
│       └── arbiter.md                # /arbiter skill
├── .cursor/
│   └── rules/
│       └── ai-workflow.mdc           # Cursor ≥0.45 rules (YAML frontmatter, generated)
├── .cursorrules                      # Cursor <0.45 legacy rules (generated)
├── .ai/
│   ├── config.json                   # Your configuration (context, provider, market)
│   ├── AI-ENFORCEMENT.md             # Mandatory AI protocols (auto-loaded)
│   ├── ai-protection-policy.json     # Prompt injection + PII + directory protection config
│   ├── presets.json                  # Tool/plan message limit presets
│   ├── forbidden-trackers.json       # 40+ blocked russian services
│   ├── contexts/
│   │   ├── minimal.context.md        # ~10k tokens
│   │   └── ukraine-full.context.md   # ~18k tokens
│   ├── rules/
│   │   ├── core.md                   # Complete workflow rules
│   │   └── product.md                # Ukrainian market rules
│   └── docs/                         # Reference docs (token usage, sessions, etc.)
└── scripts/
    ├── pre-commit                    # Security hook → auto-installed to .git/hooks/
    ├── post-push.sh                  # Session anchor update → auto-installed to .git/hooks/
    └── sync-rules.sh                 # Sync dev ↔ distributable pairs
```

</details>

---

**Made with ❤️ in Ukraine 🇺🇦** | **License:** GPL v3 | [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues) | **v9.1.1** | Updated: 2026-02-25
