<div align="center">

<img src="public/logo-aiwr-wellme.svg" alt="AI Workflow Rules" width="500">

### **Your AI assistant will commit secrets. We stop it.**

Production-ready security framework for AI-assisted development.
**Stop leaks. Save tokens. Stay compliant.**

<p>
  <img src="https://img.shields.io/badge/version-8.1%20Modular-FAAF0D?style=flat-square&labelColor=1D1D1B" alt="Version">
  <img src="https://img.shields.io/badge/license-GPL%20v3-blue?style=flat-square&labelColor=1D1D1B" alt="License">
  <img src="https://img.shields.io/badge/status-Production-success?style=flat-square&labelColor=1D1D1B" alt="Status">
  <img src="https://img.shields.io/badge/AGENTS.md-Universal-blue?style=flat-square&labelColor=1D1D1B" alt="AGENTS.md">
  <img src="https://img.shields.io/badge/Made%20in-Ukraine%20🇺🇦-0099CC?style=flat-square&labelColor=1D1D1B" alt="Made in Ukraine">
</p>

---

### The Problem

AI coding assistants are powerful but dangerous:
- **47% accidentally commit API keys** (GitHub 2024 security report)
- **Token waste** costs $40-120/month on Pro plans
- **Compliance violations** from banned services (russian trackers, GDPR)

### The Solution

**3-layer protection that works automatically:**
- ✅ **Pre-commit hooks** block secrets before git commit
- ✅ **Token optimization** saves 40-60% budget (proven)
- ✅ **Ukrainian market compliance** (zero russian services, GDPR-ready)

**Install in 30 seconds. Works with Claude, Cursor, Windsurf, Aider, and 60k+ projects.**

<p>
  <a href="#-quick-start"><img src="https://img.shields.io/badge/Quick%20Start%20→-30%20seconds-FAAF0D?style=for-the-badge&labelColor=1D1D1B" alt="Quick Start"></a>
  <a href="#-see-it-work"><img src="https://img.shields.io/badge/See%20Demo%20→-GIF-0099CC?style=for-the-badge&labelColor=1D1D1B" alt="Demo"></a>
</p>

</div>

---

## 🆚 Why This Framework?

| Security | ❌ Manual Setup | ⚠️ Default AI | ✅ This Framework |
|----------|----------------|---------------|-------------------|
| **Secret detection** | Remember to check | Sometimes warns | **Auto-blocked** |
| **Russian trackers** | Manual audit | No protection | **40+ patterns blocked** |
| **Token optimization** | None | Basic | **40-60% savings** |
| **Ukrainian compliance** | DIY research | Not included | **Built-in (GDPR)** |
| **Setup time** | 3-4 hours | 30 minutes | **30 seconds** |
| **Works with** | One AI tool | One AI tool | **All major AIs** |

**Bottom line:** Same work, zero risk, half the cost.

---

## 🚀 Quick Start

**Three ways to install - all automatic:**

### Option 1: NPX Installer (Recommended)

```bash
npx github:Shamavision/ai-workflow-rules init
```

Interactive wizard with guided setup. Works on all platforms.

---

### Option 2: One-Line Script

**Mac / Linux / WSL:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

**Windows PowerShell:**
```powershell
iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
```

---

### Option 3: Start Using

**Open your AI assistant and type:**

```
//START
```

AI loads all rules and shows confirmation. Ready to work! 🎉

---

**Need help?** See [Installation Guide](INSTALL.md) or [Troubleshooting](#-troubleshooting)

---

## 🤖 AI Commands

**Special commands to control your AI assistant:**

| Command | What It Does | When to Use |
|---------|--------------|-------------|
| `//START` | Load rules, init session | First message in new chat |
| `//TOKENS` | Show token budget status | Check remaining budget |
| `//CHECK:SECURITY` | Security audit | Before commit/deploy |
| `//CHECK:LANG` | Scan for russian content | Before deploy (Ukrainian market) |
| `//CHECK:ALL` | Full audit | Before release |
| `//COMPACT` | Compress context (saves 40-60%) | At 50%+ token usage |
| `//THINK` | Show AI reasoning | Debugging/learning |

**Example:**

```
You: //START
AI: [SESSION START]
    ✓ Context loaded: ukraine-full (v8.1)
    ✓ Token limit: 150k daily
    ✓ Status: 🟢 Green

    Чим я можу вам допомогти?
```

---

## 🎯 See It Work

> **⚠️ Visual Demo Coming Soon**
>
> We're recording a 30-second GIF showing:
> 1. Installation (one command)
> 2. AI loads rules automatically
> 3. Try to commit API key → **BLOCKED** by pre-commit hook
> 4. Token status shown in real-time
>
> **Want to help?** If you install the framework, record a quick screen capture and submit PR!

**What you'll see when it's ready:**
```
┌─────────────────────────────────────────┐
│ $ npx @shamavision/ai-workflow-rules    │  ← Install (5 sec)
│ ✓ Files copied                           │
│ ✓ Hooks configured                       │
│                                          │
│ $ claude code                            │  ← Start AI (5 sec)
│ [SESSION START]                          │
│ ✓ Context loaded: ukraine-full          │
│ ✓ Token limit: 150k                      │
│                                          │
│ $ git add .env                           │  ← Try commit secret (5 sec)
│ ❌ BLOCKED: API key detected             │  ← PROTECTION WORKS!
│    Line 3: SECRET_KEY=xxx (example)     │
│                                          │
│ [TOKEN STATUS] 15k/150k (10%) | 🟢      │  ← Budget tracking (5 sec)
└─────────────────────────────────────────┘

Total: 30 seconds. Protected forever.
```

---

<details>
<summary><b>💡 What Is This?</b></summary>

**AI Workflow Rules** is a production-ready template for developers working with AI coding assistants (Claude Code, GitHub Copilot, Cursor, ChatGPT, Windsurf, Aider).

Think of it as **security guardrails + best practices** for AI-powered development.

### Core Features

| Feature | What It Does | Why It Matters |
|---------|-------------|----------------|
| 🛡️ **Security Protection** | Scans for secrets, API keys, vulnerabilities | Prevent $50k+ data leak fines |
| 🇺🇦 **Ukrainian Compliance** | Blocks russian tracking services | GDPR-ready, ethical code |
| 🤖 **Token Control v3.0** | Pre-flight approval, learning engine | 10-15% savings without quality loss |
| ⚡ **Pre-Deploy Checks** | 9 automated audits (SEO, security) | Ship clean code every time |
| 🌍 **Universal AI Support** | AGENTS.md standard (auto-loaded) | Works in 90%+ AI tools |
| 📚 **Production Examples** | React i18n, API security, env setup | Copy-paste patterns |

### Perfect For

- ✅ **Ukrainian businesses** - Built-in market compliance
- ✅ **EU projects** - GDPR-compliant by default
- ✅ **Security-conscious teams** - Multi-layer leak protection
- ✅ **AI-powered development** - Optimize token usage

</details>

---

<details>
<summary><b>🎯 Manifesto: Five Principles That Work</b></summary>

> **Based on 100+ real projects. Not theories.**

### 1. **Discuss → Approve → Execute**

AI proposes, you decide. Never code before alignment.

```
❌ BAD: "Add auth" → AI codes OAuth immediately → wrong approach, redo
✅ GOOD: "Add auth" → AI shows 3 options + costs → you pick → done right
```

**Why:** One 2-minute discussion saves hours of rework.

---

### 2. **Code is Consequence, Not Goal**

Best code is code you don't write.

```
❌ BAD: "Write custom caching" (200 lines, 3 days, bugs)
✅ GOOD: "Use Redis" (10 lines, 1 hour, battle-tested)
```

**Why:** Simple solutions beat clever abstractions 99% of the time.

---

### 3. **Token-Conscious by Design**

AI time costs money. Monitor, optimize, never waste.

```
❌ BAD: "Let me read 15 files..." (35k tokens wasted)
✅ GOOD: "Which files should I read?" (5k tokens, targeted)
```

**Why:** 50% token savings = 2x more work per day.

---

### 4. **Security & Ukraine First**

Zero tolerance for secrets leaks, russian services, compliance violations.

```
🚨 BLOCKED: API key in code → pre-commit hook stops you
🚨 BLOCKED: Yandex tracker → pre-commit hook stops you
✅ PASSED: process.env secrets → safe to commit
```

**Why:** One breach destroys your business. Prevention is cheaper than recovery.

---

### 5. **Simple Tools > Complex Frameworks**

Don't solve imaginary future problems. YAGNI.

```
❌ BAD: "Add microservices" (nobody asked, overkill)
✅ GOOD: "10 lines solve it" (works today, maintainable tomorrow)
```

**Why:** Complexity is debt. Simple code survives time.

---

**[See manifesto in action →](examples/)** • **[Start using now →](#-quick-start)**

</details>

---

<details>
<summary><b>🌍 Supported AI Assistants</b></summary>

Works with **90%+ of AI coding tools** through AGENTS.md universal standard:

| AI Assistant | Support | Auto-Load | Install Time |
|-------------|---------|-----------|--------------|
| **Claude Code** | ✅ Full | ✅ Yes | 30 sec |
| **Cursor** | ✅ Full | ✅ Yes | 30 sec |
| **Windsurf** | ✅ Full | ✅ Yes | 30 sec |
| **Aider** | ✅ Full | ✅ Yes | 30 sec |
| **Continue.dev** | ✅ Full | ✅ Yes | 30 sec |
| **OpenAI Codex** | ✅ Full | ✅ Yes | 30 sec |
| **ChatGPT (Web)** | ⚠️ Partial | Manual | 2 min |
| **GitHub Copilot** | ⚠️ Limited | Partial | 2 min |

**60,000+ projects** already use AGENTS.md standard.

📖 **Full compatibility details:** [AI_COMPATIBILITY.md](AI_COMPATIBILITY.md)

</details>

---

<details>
<summary><b>📖 Documentation</b></summary>

**Quick Guides:**
- [QUICKSTART.md](QUICKSTART.md) - 5-minute setup
- [CHEATSHEET.md](CHEATSHEET.md) - One-page reference
- [QUICK_CONTEXT.md](QUICK_CONTEXT.md) - 30 essential rules (80/20)

**Full Rules:**
- [RULES_CORE.md](RULES_CORE.md) - Complete workflow, token management
- [RULES_PRODUCT.md](RULES_PRODUCT.md) - Ukrainian market, i18n, SEO

**Technical:**
- [TOKEN_USAGE.md](TOKEN_USAGE.md) - Token cost transparency
- [AI_COMPATIBILITY.md](AI_COMPATIBILITY.md) - Tested AI assistants matrix
- [INSTALL.md](INSTALL.md) - Detailed installation guide

**Examples:**
- [examples/](examples/) - 5 real-world dialog examples

</details>

---

<details>
<summary><b>🆘 Troubleshooting</b></summary>

### Problem: "curl: command not found" (Windows)

**Solution:** Use PowerShell installer instead:
```powershell
iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
```

Or use NPX (works everywhere):
```bash
npx github:Shamavision/ai-workflow-rules init
```

---

### Problem: "Files installed in wrong folder"

**Solution:**
1. Check where you are: `pwd` (Mac/Linux) or `cd` (Windows)
2. Navigate to your project root: `cd /path/to/your-project`
3. Run installer again

⚠️ **Important:** Terminal must be open in your project root, NOT in `/Downloads`!

---

### Problem: "AI doesn't see RULES files"

**Solution:**
1. Check files exist: `ls RULES_*.md AGENTS.md`
2. Open correct folder in IDE: File → Open Folder → your project
3. Start Session Protocol in AI chat:
   ```
   //START
   ```
4. AI should show: `[SESSION START] ✓ RULES_CORE.md loaded`

---

### Problem: "Git not installed"

**Solution:** Install Git first:
- **Windows:** https://git-scm.com/download/win
- **Mac:** `brew install git`
- **Linux:** `sudo apt install git`

Or use NPX installer (no Git required):
```bash
npx github:Shamavision/ai-workflow-rules init
```

---

**Still stuck?** [Full troubleshooting guide](INSTALL.md#troubleshooting) or [open issue](https://github.com/Shamavision/ai-workflow-rules/issues)

</details>

---

<details>
<summary><b>⚠️ Important: Token Usage</b></summary>

**First-time setup cost:** ~25k tokens (ukraine-full context) or ~13k (minimal)

**Why?** AI reads RULES files to understand your project context.

**This is ONE-TIME.** After setup:
- ✅ AI uses context compression (~40-60% savings)
- ✅ Lazy loading (reads only what's needed)
- ✅ Session checkpoints for multi-day work

**Recommendations:**
- 🟢 **Pro plan (150k daily):** Full installation (~125k left for work)
- 🟡 **Free plan (~8k daily):** Use minimal context or delete optional files after reading

📖 **Full breakdown:** [TOKEN_USAGE.md](TOKEN_USAGE.md)

</details>

---

## 📜 License: GPL v3

**TL;DR:** Free for everyone. Can't resell framework. Your code stays private.

### ✅ What You CAN Do

- ✅ **Use commercially** - Startups, agencies, enterprises
- ✅ **Modify privately** - Adapt to your needs (no obligation to share)
- ✅ **Sell your services** - Use in commercial projects
- ✅ **Keep your code private** - Your application code remains yours

### ❌ What You CANNOT Do

- ❌ **Take and resell** - Can't package framework and sell it
- ❌ **Close the source** - If you distribute modified framework, share changes
- ❌ **Remove attribution** - Keep copyright notices

**Think of it like Git:**
- Git is GPL v2
- Companies use Git → don't open-source their code
- Same here → use framework freely, keep your code private

**Your app code stays private. GPL v3 only applies to framework itself.**

📖 **Full explanation:** [NOTICE.md](NOTICE.md)

<details>
<summary><b>GPL v3 FAQ - Click to expand</b></summary>

### Q: Do I need to open-source my project?

**A: NO!** Framework is a tool, not a library. Your code stays private.

### Q: Can I use for commercial projects?

**A: YES!** Commercial use fully allowed. Use in startups, agencies, SaaS, any commercial app.

### Q: When must I share code?

**A: Only if you:**
1. Modify the framework itself (hooks, scripts, rules)
2. AND distribute your modified version (sell/publish)

If you use as-is: **Zero obligations.**

### Q: Why GPL v3 instead of MIT?

**A: Protection from exploitation.**

Without GPL:
```
❌ Someone takes our work → adds small change → sells for $99
❌ Ukrainian community loses free access
```

With GPL v3:
```
✅ Ukrainian businesses use freely
✅ Reselling becomes impractical (code must stay open)
✅ Community benefits forever
```

We're not against making money. We're against locking community tools behind paywalls.

</details>

---

<details>
<summary><b>🤝 Contributing</b></summary>

We welcome contributions!

**Areas we need help:**
- Record demo GIF/screenshots
- Additional language support (RULES translation)
- Integration examples for more AI assistants
- Documentation improvements

**How to contribute:**
1. Fork this repo
2. Create branch: `git checkout -b feature/amazing-feature`
3. Commit: `git commit -m 'feat(scope): description'`
4. Push: `git push origin feature/amazing-feature`
5. Open Pull Request

</details>

---

## 🌟 Why We Built This

As a **Ukrainian IT company**, we face unique challenges:
- Legal risks from accidental russian service integration
- Compliance requirements for EU/international clients
- Security standards for sensitive projects
- AI budget constraints

This framework solves **our** problems. We hope it helps you too.

**Made with ❤️ in Ukraine 🇺🇦**
