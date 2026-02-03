<div align="center">

<img src="public/wellme-logo.svg" alt="Wellme™ - AI Workflow Rules" width="500">

# AI Workflow Rules Framework

### **Open Source Security Framework for Ukrainian Developers**

<p>
  <img src="https://img.shields.io/badge/version-8.0%20Token%20Control%20v3.0-FAAF0D?style=flat-square&labelColor=1D1D1B" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square&labelColor=1D1D1B" alt="License">
  <img src="https://img.shields.io/badge/status-Production%20Ready-success?style=flat-square&labelColor=1D1D1B" alt="Status">
  <img src="https://img.shields.io/badge/AGENTS.md-Universal-blue?style=flat-square&labelColor=1D1D1B" alt="AGENTS.md">
  <img src="https://img.shields.io/badge/Made%20in-Ukraine%20🇺🇦-0099CC?style=flat-square&labelColor=1D1D1B" alt="Made in Ukraine">
</p>

**3-layer protection framework for AI-assisted development.**
**Built for security, compliance, and Ukrainian market requirements.**
**✨ NEW in v8.0: Token Control v3.0 — Intelligent budget management with pre-flight approval!**

---

### 📑 Navigation

<div align="center">

**[🚀 Quick Start](#-quick-start)** •
**[🤖 AI Commands](#-ai-commands)** •
**[📖 Documentation](#-documentation)** •
**[🆘 Troubleshooting](#-troubleshooting-частые-проблемы)** •
**[🤖 AI Support](#-supported-ai-assistants)** •
**[🤝 Contributing](#-contributing)**

</div>

</div>

---

## 🎯 AI Workflow Manifesto

> **Five principles that actually work in production.**

### 1. **Discuss → Approve → Execute**

**What it means:** AI proposes, you decide. Never code before alignment.

**Example:**
```
❌ BAD: "Add auth" → AI codes OAuth immediately → wrong approach, redo
✅ GOOD: "Add auth" → AI shows 3 options + costs → you pick → done right
```

**Why:** One 2-minute discussion saves hours of rework.

---

### 2. **Code is Consequence, Not Goal**

**What it means:** Solve problems, don't chase lines of code. Best code is code you don't write.

**Example:**
```
❌ BAD: "Write custom caching system" (200 lines, 3 days, bugs)
✅ GOOD: "Use Redis" (10 lines, 1 hour, battle-tested)
```

**Why:** Simple solutions beat clever abstractions 99% of the time.

---

### 3. **Token-Conscious by Design**

**What it means:** AI time costs money. Budget awareness = efficiency. Monitor, optimize, never waste.

**Example:**
```
❌ BAD: "Let me read 15 files to understand..." (35k tokens wasted)
✅ GOOD: "Which files should I read?" (5k tokens, targeted)
```

**Why:** 50% token savings = 2x more work per day. [See real metrics →](examples/dialog-token-optimization.md)

---

### 4. **Security & Ukraine First**

**What it means:** Zero tolerance for secrets leaks, russian services, compliance violations.

**Example:**
```
🚨 BLOCKED: API key in code → pre-commit hook stops you
🚨 BLOCKED: Yandex tracker → pre-commit hook stops you
✅ PASSED: process.env secrets → safe to commit
```

**Why:** One breach destroys your business. Prevention is cheaper than recovery. [See security audit →](examples/dialog-security-review.md)

---

### 5. **Simple Tools > Complex Frameworks**

**What it means:** Don't solve imaginary future problems. YAGNI (You Aren't Gonna Need It).

**Example:**
```
❌ BAD: "Add microservices" (nobody asked, small app, overkill)
✅ GOOD: "10 lines solve it" (works today, maintainable tomorrow)
```

**Why:** Complexity is a debt. Simple code survives turnover, rewrites, and time.

---

<div align="center">

**These aren't theories. These are patterns from 100+ real projects.**

**[See them in action →](examples/)** • **[Start using now →](#-quick-start)**

</div>

---

## 💡 What Is This?

**AI Workflow Rules Framework** is a production-ready template for developers working with AI coding assistants (Claude Code, GitHub Copilot, Cursor, ChatGPT). Think of it as **security guardrails + best practices** for AI-powered development.

### 🎯 Core Features

| Feature | What You Get | Why It Matters |
|---------|-------------|----------------|
| 🛡️ **Security Protection** | Automatic scanning for secrets, API keys, and vulnerabilities | Prevent costly data leaks before they happen |
| 🇺🇦 **Ukrainian Compliance** | Zero tolerance for russian tracking services | GDPR-ready, ethical code by default |
| 🤖 **Token Control v3.0** | Pre-flight approval, confidence estimation, learning engine | 10-15% savings without quality loss |
| ⚡ **Pre-Deploy Checks** | 9 automated audits (SEO, security, dependencies) | Ship clean code every time |
| 🌍 **Universal AI Support** | AGENTS.md standard: Claude, Cursor, Windsurf, Aider, OpenAI + 60k projects | Auto-loaded in 90%+ AI tools |
| 🚀 **Session Start Protocol** | 3-layer enforcement (ONION): file directive + hook + manual fallback | AI loads rules automatically, guaranteed |
| 📚 **Ready-to-Use Examples** | React i18n, API security, environment setup | Copy-paste production patterns |
| 🚀 **Automation Scripts** | One-command setup for Windows, Mac, Linux | 5-minute installation |

### ✅ Perfect For

- **Ukrainian IT companies & freelancers** - Built-in compliance with Ukrainian market standards
- **EU market projects** - GDPR-compliant, ethical tracking, localization-ready
- **Security-conscious teams** - Multi-layer protection against secrets leaks
- **AI-powered development** - Optimize token usage, prevent AI hallucinations
- **Open source projects** - MIT licensed, community-driven, transparent

### 🎁 What's Included

- 📖 **Comprehensive guides** - QUICKSTART (5 min), CHEATSHEET (1 page), TOKEN_USAGE analysis
- 🔧 **Production examples** - Real-world code for i18n, security, env management
- 🤖 **Universal AI compatibility** - AGENTS.md (auto-loaded by 90%+ tools), START.md manual fallback
- 🛠️ **Automation toolkit** - install.sh, install.ps1, seo-check.sh, validate-setup.sh
- ⚙️ **IDE configs** - .vscode/settings.json, .editorconfig for consistency

---

## ⚠️ Token Usage Warning

**First-time setup cost:** ~66k tokens (~33% of Pro daily limit, ~44% of Free)

**Why?** AI reads all RULES files automatically to understand your project context.

**This is ONE-TIME cost.** After setup:
- ✅ AI uses context compression (~40-60% savings)
- ✅ Lazy loading (reads only what's needed)
- ✅ Session checkpoints for multi-day work

**Recommendations:**
- 🟢 **Pro/Team plan:** Full installation recommended (~134k tokens left for work)
- 🟡 **Free plan:** Consider minimal installation (30k tokens) or delete optional files after reading

📖 **Full details:** [TOKEN_USAGE.md](TOKEN_USAGE.md)

---

## 🧅 ONION Architecture (3 Layers)

Multi-layer protection for your development workflow:

| Layer | What It Does | Files |
|-------|--------------|-------|
| **Layer 1: AI Rules** | Instructions for AI assistants on how to work securely | `RULES_CORE.md`<br>`RULES_PRODUCT.md` |
| **Layer 2: Runtime Protection** | Blacklist of forbidden services, locale context | `.ai/forbidden-trackers.json`<br>`.ai/locale-context.json`<br>`.ai/token-limits.json` |
| **Layer 3: Pre-Deploy Checks** | Automated scanning before commits and deployment | `scripts/seo-check.sh`<br>`.git/hooks/pre-commit` |

**Result:** Your code is protected from secrets leaks, russian trackers, and compliance violations.

---

## 🚀 Quick Start

**Two ways to install - both automatic:**

---

### 1️⃣ NPX Installer (Recommended)

**Interactive wizard with guided setup:**

```bash
# Using GitHub (available now):
npx github:Shamavision/ai-workflow-rules init

# Or via NPM (coming soon):
# npx @shamavision/ai-workflow-rules init
```

✅ Interactive wizard
✅ Auto-configures everything
✅ Works on all platforms

**Requirements:** Node.js 14+

---

### 2️⃣ Terminal Script (No NPX)

**One command - automatic installation:**

⚠️ **Important:** Open terminal in your **project's root directory** (not in `/Downloads` or temp folders)!

**Mac / Linux / WSL:**

**Option 1 (Recommended):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

**Option 2 (Alternative - pipe):**
```bash
curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh | bash
```

> **⚠️ Important:** Make sure to include `bash <(...)` or `| bash` at the end!
> Without it, the command will only **display** the script instead of **executing** it.

**Windows PowerShell:**
```powershell
iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
```

✅ Downloads files automatically
✅ Copies to your project
✅ Configures hooks
✅ No manual steps

**Requirements:** Git installed

---

### 3️⃣ Start Working

**Open your project in AI tool and type:**

```
//START
```

AI will load all rules and show confirmation. Ready to work! 🎉

---

**🔧 Need manual installation?** See detailed guide: [INSTALL.md](INSTALL.md)

---

## 🤖 AI Commands

**Что это?** Специальные команды для управления AI помощником прямо в чате.

**Как использовать?** Просто напечатай команду в чате с AI и нажми Enter.

### 🚀 Первый запуск

**Если AI не загрузил правила автоматически** (например, в VSCode Extension):

```
//START
```

Эта команда загрузит все правила проекта и инициализирует сессию. AI покажет подтверждение и будет готов к работе.

### 📊 Полезные команды

| Команда | Что делает | Когда использовать |
|---------|------------|-------------------|
| `//START` | Инициализация сессии | Первое сообщение в новом чате |
| `//TOKENS` | Показать использование токенов | Проверить бюджет |
| `//CHECK:SECURITY` | Проверка безопасности | Перед коммитом |
| `//CHECK:LANG` | Проверка на русский контент | Перед деплоем |
| `//CHECK:ALL` | Полная проверка | Перед релизом |
| `//COMPACT` | Сжать контекст | При 50%+ токенов |
| `//THINK` | Показать рассуждения AI | Отладка/обучение |

### 💡 Примеры использования

**Начало работы:**
```
Вы: //START
AI: [SESSION START]
    ✓ RULES_CORE.md loaded (v7.1)
    ✓ Language: Russian (internal dialogue)
    ✓ Token limit: 150k daily
    Ready to work. В чем помочь?
```

**Проверка безопасности:**
```
Вы: //CHECK:SECURITY
AI: [CHECK RESULTS: SECURITY]
    ✅ No hardcoded secrets
    ✅ Input validation present
    ✓ Ready to commit
```

**Экономия токенов:**
```
Вы: //TOKENS
AI: [TOKEN STATUS] Session: 92k/200k (46%) | 🟢 Green

Вы: //COMPACT
AI: [COMPACTING CONTEXT]
    Compressed: ~35k → ~8k tokens
    Saved: 27k (77%)
```

📖 **Полный список команд:** [AGENTS.md - Workflow Triggers](AGENTS.md#-workflow-triggers)

---

## 🆘 Troubleshooting (Частые проблемы)

<details>
<summary><b>🔧 Click to expand common problems and solutions</b></summary>

### ❌ "curl: command not found" (Windows)

**Проблема:** Команда `bash <(curl ...)` не работает в Windows.

**Решение:**

**Option 1:** Используйте PowerShell вместо bash:
```powershell
iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
```

**Option 2:** Установите Git for Windows (включает Git Bash):
- Download: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- После установки используйте Git Bash для bash команд

**Option 3:** Используйте NPX installer (работает везде):
```bash
npx github:Shamavision/ai-workflow-rules init
```

---

### ❌ "Файлы установились не в мой проект"

**Проблема:** Запустили скрипт не в корне проекта, файлы скопировались не туда.

**Решение:**

1. **Проверьте где вы сейчас:**
   ```bash
   pwd  # Mac/Linux/Git Bash
   # или
   cd   # Windows PowerShell
   ```

2. **Перейдите в корень ВАШЕГО проекта:**
   ```bash
   cd /path/to/your-project  # Mac/Linux
   cd D:\Projects\my-app     # Windows
   ```

3. **Запустите скрипт снова:**
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
   ```

⚠️ **Важно:** Terminal должен быть открыт в корне вашего проекта, НЕ в `/Downloads` или `/tmp`!

---

### ❌ "Git не установлен"

**Проблема:** `git: command not found` при запуске installer.

**Решение:**

Установите Git:
- **Windows:** [https://git-scm.com/download/win](https://git-scm.com/download/win)
- **Mac:** `brew install git` (или Xcode Command Line Tools)
- **Linux:** `sudo apt install git` (Ubuntu/Debian) или `sudo yum install git` (CentOS/RHEL)

**Проверка:**
```bash
git --version
# Должно показать: git version 2.x.x
```

Если не хотите устанавливать Git → используйте **NPX installer**:
```bash
npx github:Shamavision/ai-workflow-rules init
```

---

### ❌ "PowerShell: scripts disabled" (Windows)

**Проблема:** PowerShell блокирует выполнение скриптов (Execution Policy).

**Ошибка:**
```
iwr : Cannot be loaded because running scripts is disabled on this system
```

**Решение:**

**Option 1:** Разрешить скрипты для текущей сессии (безопасно):
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Потом запустите installer снова.

**Option 2:** Используйте NPX installer (не требует PowerShell):
```bash
npx github:Shamavision/ai-workflow-rules init
```

**Option 3:** Используйте Git Bash вместо PowerShell:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
```

---

### ❌ "AI не видит RULES файлы"

**Проблема:** AI не загружает правила, работает без защиты.

**Решение:**

1. **Проверьте что файлы установлены:**
   ```bash
   ls RULES_*.md AGENTS.md
   # Должно показать: AGENTS.md  RULES_CORE.md  RULES_PRODUCT.md
   ```

2. **Открыли правильный проект в IDE?**
   - File → Open Folder → выберите ВАШУ папку проекта
   - НЕ папку временного скачивания!

3. **Запустите Session Start Protocol:**
   Откройте AI чат и напечатайте:
   ```
   //START
   ```

   AI должен показать:
   ```
   [SESSION START]
   ✓ RULES_CORE.md loaded (v7.1)
   ✓ Language: Russian (internal dialogue)
   ...
   ```

4. **Если AI всё равно не видит:**
   - Закройте IDE полностью
   - Откройте проект снова
   - Напишите `//START` в новом чате

---

### ❌ "Installer выдал ошибку"

**Проблема:** Скрипт завершился с ошибкой.

**Общие решения:**

1. **Проверьте интернет соединение:**
   ```bash
   ping github.com
   ```

2. **Попробуйте другой метод установки:**
   - NPX: `npx github:Shamavision/ai-workflow-rules init`
   - Manual: См. [INSTALL.md](INSTALL.md)

3. **Проверьте что папка не read-only:**
   ```bash
   # Создайте тестовый файл
   touch test.txt
   # Если ошибка → нет прав на запись
   ```

4. **Посмотрите полный вывод ошибки:**
   - Скопируйте текст ошибки
   - Создайте Issue: [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
   - Прикрепите вывод терминала

---

### 💡 Всё ещё не работает?

**Fallback: Manual Installation**

Если автоматические installers не работают → используйте manual установку:

📖 **Полная инструкция:** [INSTALL.md](INSTALL.md)

Включает:
- Шаг-за-шагом guide с скриншотами
- Drag-and-drop в VS Code (без командной строки)
- Troubleshooting для каждого шага

**Или спросите в Issues:**
- [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
- Опишите что делали, что получилось
- Прикрепите вывод терминала или скриншот

</details>

---

## ⚠️ Legal Disclaimer & Liability

<details>
<summary><b>⚖️ Click to read full disclaimer (IMPORTANT)</b></summary>

### AS-IS, NO WARRANTY

This framework is provided **"AS-IS"** under **GPL v3 License** without warranty of any kind, express or implied.

**YOU USE IT AT YOUR OWN RISK.**

### License & Distribution

This framework is licensed under **GNU General Public License v3.0**:

**✅ You CAN:**
- Use commercially (free for all business use)
- Modify privately (no obligation to share)
- Distribute as-is (keep attribution)

**⚠️ You MUST (if distributing modified framework):**
- Share modifications under GPL v3
- Keep source code available
- Maintain copyright notices

**📖 See [NOTICE.md](NOTICE.md) for full GPL v3 explanation.**

**YOUR application code remains private** - GPL v3 only applies to framework itself.

### What We Are NOT Responsible For

Wellme™ and framework contributors are **NOT liable** for:

- ❌ Legal consequences of using this framework
- ❌ Compliance violations in your projects
- ❌ Data breaches or security incidents
- ❌ Financial losses or business damages
- ❌ Regulatory fines or penalties
- ❌ Reputational damage
- ❌ Any direct, indirect, incidental, or consequential damages

### Your Responsibilities

By using this framework, YOU are responsible for:

- ✅ Verifying framework meets YOUR legal requirements
- ✅ Consulting YOUR legal advisors before production use
- ✅ Testing thoroughly in YOUR environment
- ✅ Implementing YOUR own additional security measures
- ✅ Keeping framework updated (we don't guarantee updates)
- ✅ Compliance with YOUR jurisdiction's laws

### Ukrainian Market Policy

**Russian Content Zero Tolerance:**

This framework implements **ZERO TOLERANCE** for russian services/content as:
1. Security measure (data protection from hostile state)
2. Compliance guideline (sanctions, GDPR, Ukrainian law)
3. Best practice recommendation (Ukrainian market safety)

**HOWEVER:**
- We do NOT provide legal advice
- We do NOT guarantee legal compliance
- We do NOT guarantee this is sufficient for YOUR specific case
- **Consult YOUR legal team** before relying on this policy

### No Support Obligation

We provide this open-source for community benefit:

- ❌ We are NOT obligated to provide support
- ❌ We are NOT obligated to fix issues
- ❌ We are NOT obligated to update framework
- ❌ We are NOT obligated to respond to requests

Community contributions welcome, but **NO guarantees**.

### Limitation of Liability

**Maximum liability:** USD $0 (ZERO)

Under no circumstances shall Wellme™ or contributors be liable for any amount.

### Indemnification

By using this framework, you agree to:
- Indemnify Wellme™ from any claims arising from your use
- Hold Wellme™ harmless from any damages
- Not sue Wellme™ for any reason related to framework use

### Governing Law

This disclaimer is governed by laws of Ukraine.

Disputes shall be resolved in courts of Kyiv, Ukraine.

### Acceptance

By downloading, installing, or using this framework, you acknowledge that you have read, understood, and agree to be bound by this disclaimer.

**If you do not agree, DO NOT use this framework.**

---

**Last Updated:** 2026-02-03

**TL;DR:** Use at your own risk. We help Ukrainian community. Don't sue us. Consult your lawyers. 🇺🇦

</details>

---

## 🤖 Supported AI Assistants

<details>
<summary><b>🤖 Click to see all supported AI platforms</b></summary>

This framework works with multiple AI assistants through **AGENTS.md universal standard**:

| AI Assistant | Support Level | Auto-Load | Config File |
|-------------|---------------|-----------|-------------|
| **Claude Code** | ✅ Full | ✅ Yes | AGENTS.md or .claude/CLAUDE.md |
| **Cursor** | ✅ Full | ✅ Yes | AGENTS.md or .cursorrules |
| **Windsurf** | ✅ Full | ✅ Yes | AGENTS.md |
| **Aider** | ✅ Full | ✅ Yes | AGENTS.md |
| **Continue.dev** | ✅ Full | ✅ Yes | AGENTS.md |
| **OpenAI Codex** | ✅ Full | ✅ Yes | AGENTS.md |
| **Google Jules** | ✅ Full | ✅ Yes | AGENTS.md |
| **ChatGPT (Web)** | ⚠️ Partial | ❌ Manual | START.md (copy-paste) |
| **GitHub Copilot** | ⚠️ Limited | ⚠️ Partial | AGENTS.md (limited context) |
| **Gemini (Web)** | ⚠️ Partial | ❌ Manual | START.md (copy-paste) |

**✨ 90%+ of AI coding tools now support AGENTS.md auto-loading!**

**📖 Full compatibility details:** [AI_COMPATIBILITY.md](AI_COMPATIBILITY.md)

**🚀 Quick onboarding for AI:** [START.md](START.md)

**📦 Installation guide:** [INSTALL.md](INSTALL.md)

</details>

---

## 📋 What's Included

<details>
<summary><b>📦 Click to see complete feature list</b></summary>

### Core Files

```
.ai/
  ├── forbidden-trackers.json    # Blacklist of russian services (40+ patterns)
  ├── locale-context.json        # Ukrainian locale & compliance settings
  └── token-limits.json          # AI budget tracking template

scripts/
  ├── install.sh                 # One-line installer (Mac/Linux/WSL)
  ├── install.ps1                # One-line installer (Windows PowerShell)
  ├── seo-check.sh               # 9 automated security & SEO checks
  ├── pre-commit                 # Git hook for security scanning
  └── validate-setup.sh          # Verify installation

examples/
  ├── react-i18n.tsx             # i18n component example
  ├── api-security.ts            # Secure API route example
  └── env-usage.ts               # Environment variables example

.vscode/
  └── settings.json              # VS Code configuration

.git/hooks/
  └── pre-commit                 # Automatic checks on every commit

RULES_CORE.md                    # AI workflow instructions (token mgmt, security)
RULES_PRODUCT.md                 # Ukrainian market specifics (i18n, SEO, compliance)
START.md                         # Quick onboarding guide for AI assistants
QUICKSTART.md                    # 5-minute setup guide
CHEATSHEET.md                    # One-page quick reference
INSTALL.md                       # Installation guide (multiple options)
AI_COMPATIBILITY.md              # AI assistant compatibility matrix
TOKEN_USAGE.md                   # Token cost transparency
.env.example                     # Environment variables template
.editorconfig                    # Cross-IDE consistency
README.md                        # This file
LICENSE                          # MIT License
```

### 9 Automated Checks (seo-check.sh)

1. **robots.txt** configuration
2. **HTML meta tags** (lang="uk-UA", hreflang, charset)
3. **LANG-CRITICAL violations** (russian content detection)
4. **Canonical URLs** and sitemap
5. **Open Graph / Twitter Cards** (social media)
6. **GEO targeting** (Ukrainian market)
7. **Performance hints** (image optimization, next/image)
8. **Russian tracking services** (CRITICAL SECURITY) ⚠️
9. **NPM packages** (forbidden russian dependencies) ⚠️

---

### 🇺🇦 Ukrainian Market Protection

**Why this matters:**

As a Ukrainian company (Wellme™), we face **high legal risks** if our projects accidentally include russian services. This framework provides:

✅ **Automatic detection** of 40+ russian tracking services
✅ **NPM package scanning** for supply-chain attacks
✅ **Pre-commit protection** - can't commit russian trackers
✅ **Migration guides** - safe alternatives with code examples
✅ **Legal compliance** - GDPR + Ukrainian sanctions

**Forbidden services detected:**
- Yandex Metrika, VK.com, OK.ru
- Yandex Maps, 2GIS
- YooKassa, Cloudpayments
- Rutube, Wildberries
- ...and 30+ more

---

### 🤖 AI Budget Management

**Problem:** AI assistants cost money. Free plans run out fast. Pro plans have daily limits.

**Solution:** Built-in token tracking system.

`.ai/token-limits.json` template:
```json
{
  "plan": "pro",
  "monthly_limit": 6000000,
  "daily_limit": 200000,
  "current_status": "green"
}
```

**Features:**
- ✅ AI automatically reads this file at session start
- ✅ Shows budget status (🟢 Green, 🟡 Moderate, 🟠 Caution, 🔴 Critical)
- ✅ Auto-optimizes when running low (brief mode, context compression)
- ✅ Saves 40-60% tokens with smart compression
- ✅ Works with Free, Pro, and Team plans

</details>

---

## 📖 Documentation

<details>
<summary><b>📚 Click to see full documentation and examples</b></summary>

### For Developers

- **[RULES_CORE.md](RULES_CORE.md)** - Full AI workflow rules
  - Session Start Protocol
  - Token Management v2.0
  - Security best practices
  - Git workflow

- **[RULES_PRODUCT.md](RULES_PRODUCT.md)** - Ukrainian market specifics
  - i18n architecture
  - SEO/GEO strategy
  - Forbidden services (detailed)
  - Accessibility (WCAG 2.1)

### For AI Assistants

When working with AI (Claude Code, etc.), they will automatically:
1. Read `RULES_CORE.md` at session start
2. Check `.ai/token-limits.json` for budget
3. Follow security guidelines (no secrets, no russian trackers)
4. Optimize token usage based on budget

---

### 🛠️ Usage Examples

### Example 1: Freelancer

```bash
# Start new client project
cd ~/projects/new-client/

# One-line installation
bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)

# Choose provider (Anthropic/OpenAI/Google/etc.) in interactive wizard
# AI reads RULES automatically, follows security guidelines

# Before deploy
./scripts/seo-check.sh .
# ✅ All checks passed
```

### Example 2: Agency

```bash
# Standardize across all projects
for project in ~/clients/*/; do
  cd "$project"
  # One-line install in each project
  bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh) <<< $'1\n2\n'  # Auto-select Anthropic Pro
  echo "✅ Protected: $project"
done

# All projects now have:
# - Same security standards
# - GDPR compliance
# - Russian services protection
# - Automated installation in seconds
```

### Example 3: Startup (EU Expansion)

```bash
# Audit existing project
./scripts/seo-check.sh /path/to/my-app

# Output:
# ❌ RUSSIAN TRACKER: src/analytics.ts:12
#    Pattern: metrika.yandex
#    Alternatives: Google Analytics 4, Plausible

# Fix issues, pass investor due diligence ✅
```

---

### ⚠️ Disclaimer

**AS-IS, NO WARRANTY:**

This framework is provided **"as-is"** without any warranty. While we (Wellme™) use it in production for our Ukrainian projects, **you use it at your own risk.**

✅ **Free to use** (MIT License)
✅ **Modify for your needs**
✅ **Commercial use allowed**
❌ **No liability** - we're not responsible if you have issues
❌ **No support guarantees** - community-driven

**For production use:** Test thoroughly before deploying.

</details>

---

## 🤝 Contributing

We welcome contributions from the community!

**How to contribute:**
1. Fork this repo
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

**Areas we need help:**
- Additional language support (RULES translation)
- More forbidden services detection
- Integration with other AI assistants
- Documentation improvements

---

## 📜 License

**GPL v3 License** - See [LICENSE](LICENSE) for full terms.

```
GNU General Public License v3.0
Copyright (c) 2025 Wellme™ (Ukraine)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License v3.
```

**TL;DR:** Free for commercial use. Can't resell framework itself. Your code stays private.

**📖 Read [NOTICE.md](NOTICE.md) for detailed explanation.**

---

## ❓ GPL v3 FAQ

<details>
<summary><b>🔓 Click to understand GPL v3 licensing</b></summary>

### Q: Can I use this for commercial projects?

**A: YES!** 100% free for commercial use:
- ✅ Startups and enterprises
- ✅ Client projects (agencies)
- ✅ SaaS products
- ✅ Any commercial application

### Q: Do I need to open-source my project?

**A: NO!** Your code stays private.

**Framework = Tool** (like Git, which is also GPL)
- Git is GPL v2 → companies don't open-source because they use Git
- Same here → use the framework, keep your code private

### Q: When must I share code?

**A: Only if you:**
1. Modify the framework itself (hooks, scripts, rules)
2. AND distribute modified version (sell, publish, share)

**If you use as-is:** Zero obligations.

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

**We're not against making money. We're against locking community tools behind paywalls.**

### Q: What if my company fears GPL?

**A: Common misconception.**

GPL v3 applies to **framework code**, not to projects using it.

**Still concerned?** Contact: opensource@wellme.ua

### Real Example

```
Your Company "Laba" builds e-commerce:
1. Uses ai-workflow-rules framework ✅
2. Develops React/Node.js app ✅
3. Keeps app code private ✅
4. Sells product to users ✅

GPL v3 obligations: ZERO
```

**📖 Full details:** [NOTICE.md](NOTICE.md)

</details>

---

## 🌟 Why We Built This

<details>
<summary><b>💡 Click to read our story</b></summary>

As a **Ukrainian IT company**, we face unique challenges:
- **Legal risks** from accidental russian service integration
- **Compliance requirements** for EU/international clients
- **Security standards** for sensitive projects
- **AI budget constraints** (tokens are expensive!)

This framework solves **our** problems. We hope it helps you too.

**Made with ❤️ in Ukraine** 🇺🇦

</details>

---

<div align="center">

## Ready to Protect Your Project?

**1. Download** → **2. Integrate** → **3. Deploy Safely**

<p>
  <a href="#-quick-start"><img src="https://img.shields.io/badge/Get%20Started-→-FAAF0D?style=for-the-badge&labelColor=1D1D1B" alt="Get Started"></a>
  <a href="RULES_CORE.md"><img src="https://img.shields.io/badge/Read%20Documentation-→-0099CC?style=for-the-badge&labelColor=1D1D1B" alt="Docs"></a>
  <a href="https://github.com/Shamavision/ai-workflow-rules/issues"><img src="https://img.shields.io/badge/Report%20Issue-→-FAAF0D?style=for-the-badge&labelColor=1D1D1B" alt="Issues"></a>
</p>

---

### Support & Links

- **Documentation:** [RULES_CORE.md](RULES_CORE.md) • [RULES_PRODUCT.md](RULES_PRODUCT.md)
- **Issues:** [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
- **Website:** [wellme.ua](https://wellme.ua)

---

<img src="public/wellme-logo.svg" alt="Wellme™" width="300">

**AI Workflow Rules Framework v7.1 Universal**
*Open Source • Made in Ukraine 🇺🇦*

[wellme.ua](https://wellme.ua) • © 2025 Wellme™

</div>
