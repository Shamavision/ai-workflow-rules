<div align="center">

<img src="public/wellme-logo.svg" alt="Wellme™ - AI Workflow Rules" width="500">

# AI Workflow Rules Framework

### **Open Source Security Framework for Ukrainian Developers**

<p>
  <img src="https://img.shields.io/badge/version-7.0-FAAF0D?style=flat-square&labelColor=1D1D1B" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square&labelColor=1D1D1B" alt="License">
  <img src="https://img.shields.io/badge/status-Production%20Ready-success?style=flat-square&labelColor=1D1D1B" alt="Status">
  <img src="https://img.shields.io/badge/Made%20in-Ukraine%20🇺🇦-0099CC?style=flat-square&labelColor=1D1D1B" alt="Made in Ukraine">
</p>

**3-layer protection framework for AI-assisted development.**
**Built for security, compliance, and Ukrainian market requirements.**

</div>

---

## 💡 What Is This?

**AI Workflow Rules Framework** is a production-ready template for developers working with AI coding assistants (Claude Code, GitHub Copilot, Cursor, ChatGPT). Think of it as **security guardrails + best practices** for AI-powered development.

### 🎯 Core Features

| Feature | What You Get | Why It Matters |
|---------|-------------|----------------|
| 🛡️ **Security Protection** | Automatic scanning for secrets, API keys, and vulnerabilities | Prevent costly data leaks before they happen |
| 🇺🇦 **Ukrainian Compliance** | Zero tolerance for russian tracking services | GDPR-ready, ethical code by default |
| 🤖 **AI Budget Management** | Token tracking, compression, optimization | Save 40-60% tokens, work smarter |
| ⚡ **Pre-Deploy Checks** | 9 automated audits (SEO, security, dependencies) | Ship clean code every time |
| 🌍 **Universal AI Support** | Works with Claude, ChatGPT, Copilot, Cursor, Gemini | One framework, any AI assistant |
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
- 🤖 **AI compatibility layer** - START.md for ChatGPT/Gemini, automatic for Claude/Cursor
- 🛠️ **Automation toolkit** - setup.sh, validate-setup.sh, seo-check.sh
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

### Визуально: Что мы делаем

```
ПЕРЕД установкой:
📂 ai-workflow-rules/         ← Скачанный репозиторий (НЕ ваш проект!)
   ├── .ai/
   ├── RULES_*.md
   └── scripts/

📂 my-awesome-project/         ← ВАШ рабочий проект
   ├── src/
   └── package.json

ПОСЛЕ установки:
📂 my-awesome-project/         ← ВАШ проект + защита
   ├── .ai/ ⭐                 ← Скопировали сюда
   ├── RULES_*.md ⭐          ← Скопировали сюда
   ├── scripts/ ⭐            ← Скопировали сюда
   ├── src/
   └── package.json
```

---

### Шаг 1: Скачайте репозиторий

**Windows (Git Bash или PowerShell):**
```bash
# Скачиваем во временную папку (НЕ в ваш проект!)
cd C:\Temp
git clone https://github.com/Shamavision/ai-workflow-rules.git
cd ai-workflow-rules
```

**Mac / Linux:**
```bash
# Скачиваем во временную папку
cd ~/Downloads
git clone https://github.com/Shamavision/ai-workflow-rules.git
cd ai-workflow-rules
```

📌 **Важно:** Это ВРЕМЕННАЯ копия. Мы скопируем нужные файлы в ваш проект на следующем шаге.

---

### Шаг 2: Скопируйте файлы в ВАШ проект

**Замените `/path/to/your-project` на реальный путь к ВАШЕМУ проекту!**

**Пример для Windows:**
```bash
# Если ваш проект в D:\Projects\my-app
cp -r .ai D:/Projects/my-app/
cp RULES_*.md D:/Projects/my-app/
cp -r scripts D:/Projects/my-app/
cp .editorconfig D:/Projects/my-app/
```

**Пример для Mac/Linux:**
```bash
# Если ваш проект в ~/Projects/my-app
cp -r .ai ~/Projects/my-app/
cp RULES_*.md ~/Projects/my-app/
cp -r scripts ~/Projects/my-app/
cp .editorconfig ~/Projects/my-app/
```

**Используете VS Code?** Еще проще:
1. Откройте **2 окна VS Code**:
   - Окно 1: `C:\Temp\ai-workflow-rules` (скачанный репозиторий)
   - Окно 2: `D:\Projects\my-app` (ваш проект)
2. Перетащите мышкой:
   - Папку `.ai` → в корень вашего проекта
   - Файлы `RULES_*.md` → в корень вашего проекта
   - Папку `scripts` → в корень вашего проекта

---

### Шаг 3: Установите Git Hooks (защита от утечек)

```bash
# Перейдите В ВАШ проект (не в репозиторий!)
cd D:/Projects/my-app  # Windows
# cd ~/Projects/my-app  # Mac/Linux

# Скопируйте pre-commit hook
cp C:/Temp/ai-workflow-rules/.git/hooks/pre-commit .git/hooks/  # Windows
# cp ~/Downloads/ai-workflow-rules/.git/hooks/pre-commit .git/hooks/  # Mac/Linux

# Сделайте исполняемым (Mac/Linux only)
chmod +x .git/hooks/pre-commit
```

---

### Шаг 4: Проверьте что получилось

```bash
# Перейдите в ВАШ проект
cd D:/Projects/my-app  # ваш путь

# Проверьте структуру
ls -la

# Должно быть:
# .ai/                   ✅
# RULES_CORE.md          ✅
# RULES_PRODUCT.md       ✅
# scripts/               ✅
# .editorconfig          ✅
```

---

### Шаг 5: Настройте под себя

Откройте файл `.ai/token-limits.json` в вашем проекте и обновите лимиты:

```json
{
  "provider": "anthropic",
  "plan": "Pro",  // или "Free", "Team", "Enterprise"
  "limits": {
    "daily": 200000,  // ваш лимит
    "session": 66000
  }
}
```

---

### Шаг 6: Готово! 🎉

Теперь откройте **ваш проект** в Claude Code / Cursor / Copilot:

```bash
# В VS Code
code D:/Projects/my-app

# Или просто откройте папку через File → Open Folder
```

AI автоматически прочитает RULES файлы и начнет работать с защитой!

---

## 🆘 Troubleshooting (Частые проблемы)

### ❌ "cp: command not found" (Windows)

**Проблема:** Команда `cp` не работает в PowerShell.

**Решение:**
```powershell
# Используйте Copy-Item в PowerShell
Copy-Item -Recurse .ai D:\Projects\my-app\
Copy-Item RULES_*.md D:\Projects\my-app\
Copy-Item -Recurse scripts D:\Projects\my-app\
```

Или используйте **Git Bash** (входит в Git for Windows).

---

### ❌ "Не понимаю где мой проект"

**Найдите путь к вашему проекту:**

**Windows:**
1. Откройте папку проекта в Explorer
2. Кликните в адресной строке
3. Скопируйте путь (например: `D:\Projects\my-app`)

**Mac:**
1. Откройте папку в Finder
2. Правый клик → "Get Info"
3. Скопируйте путь из "Where:"

**VS Code:**
1. Откройте ваш проект в VS Code
2. Terminal → New Terminal
3. Напечатайте `pwd` (покажет текущий путь)

---

### ❌ "Скопировал не туда / запутался"

**Проверьте структуру:**

```bash
# Перейдите в ВАШ проект
cd D:\Projects\my-app

# Посмотрите что там
ls -la
# или (Windows PowerShell):
dir
```

**Должны увидеть:**
- `.ai/` (папка)
- `RULES_CORE.md` (файл)
- `RULES_PRODUCT.md` (файл)
- `scripts/` (папка)

**Если не видите:** Скопировали в неправильное место. Удалите и повторите Шаг 2.

---

### ❌ "AI не видит RULES файлы"

**Проверьте:**

1. **Файлы в корне проекта?**
   ```bash
   # В папке проекта:
   ls RULES_*.md
   # Должно показать: RULES_CORE.md  RULES_PRODUCT.md
   ```

2. **Открыли правильный проект в VS Code?**
   - File → Open Folder → выберите ВАШУ папку проекта
   - НЕ папку `ai-workflow-rules`!

3. **Перезапустите AI:**
   - Закройте VS Code
   - Откройте снова
   - AI прочитает RULES при старте

---

### ❌ "Git hooks не работают"

**Windows:** Убедитесь что у вас установлен Git Bash:
```bash
# Проверка
git --version
# Должно показать версию Git
```

**Mac/Linux:** Проверьте права:
```bash
ls -la .git/hooks/pre-commit
# Должно быть: -rwxr-xr-x (x = executable)

# Если нет, добавьте права:
chmod +x .git/hooks/pre-commit
```

---

### 💡 Все еще не работает?

1. **Проверьте через VS Code:**
   - Откройте 2 окна: репозиторий + ваш проект
   - Перетащите файлы мышкой (самый надежный способ!)

2. **Убедитесь что копируете ИЗ репозитория В проект:**
   ```
   ❌ НЕПРАВИЛЬНО:
   my-app/ → ai-workflow-rules/

   ✅ ПРАВИЛЬНО:
   ai-workflow-rules/ → my-app/
   ```

3. **Спросите в Issues:**
   - [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
   - Опишите что делали, что получилось
   - Прикрепите скриншот структуры папок

---

## 🤖 Supported AI Assistants

This framework works with multiple AI assistants:

| AI Assistant | Support Level | Installation | Token Tracking |
|-------------|---------------|--------------|----------------|
| **Claude Code** | ✅ Full | Automatic | ✅ Yes |
| **Cursor IDE** | ✅ Full | Automatic | ✅ Yes |
| **ChatGPT** | ⚠️ Partial | Manual (copy-paste) | ⚠️ Basic |
| **GitHub Copilot** | ⚠️ Limited | Copy files | ❌ No |
| **Gemini** | ⚠️ Partial | Manual (copy-paste) | ⚠️ Basic |

**📖 Full compatibility details:** [AI_COMPATIBILITY.md](AI_COMPATIBILITY.md)

**🚀 Quick onboarding for AI:** [START.md](START.md)

**📦 Installation guide:** [INSTALL.md](INSTALL.md)

---

## 📋 What's Included

### Core Files

```
.ai/
  ├── forbidden-trackers.json    # Blacklist of russian services (40+ patterns)
  ├── locale-context.json        # Ukrainian locale & compliance settings
  └── token-limits.json          # AI budget tracking template

scripts/
  ├── seo-check.sh               # 9 automated security & SEO checks
  ├── setup.sh                   # Automatic setup (Unix/Mac/WSL)
  ├── setup.ps1                  # Automatic setup (Windows PowerShell)
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

## 🇺🇦 Ukrainian Market Protection

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

## 🤖 AI Budget Management

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

---

## 📖 Documentation

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

## 🛠️ Usage Examples

### Example 1: Freelancer

```bash
# Start new client project
cp -r ai-workflow-rules/ ~/projects/new-client/
cd ~/projects/new-client/

# Customize
nano .ai/token-limits.json  # Set your plan limits

# Work with AI assistant
# AI reads RULES automatically, follows security guidelines

# Before deploy
./scripts/seo-check.sh .
# ✅ All checks passed
```

### Example 2: Agency

```bash
# Standardize across all projects
for project in ~/clients/*/; do
  cp -r ai-workflow-rules/.ai "$project"
  cp ai-workflow-rules/RULES_*.md "$project"
  echo "✅ Protected: $project"
done

# All projects now have:
# - Same security standards
# - GDPR compliance
# - Russian services protection
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

## ⚠️ Disclaimer

**AS-IS, NO WARRANTY:**

This framework is provided **"as-is"** without any warranty. While we (Wellme™) use it in production for our Ukrainian projects, **you use it at your own risk.**

✅ **Free to use** (MIT License)
✅ **Modify for your needs**
✅ **Commercial use allowed**
❌ **No liability** - we're not responsible if you have issues
❌ **No support guarantees** - community-driven

**For production use:** Test thoroughly before deploying.

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

**MIT License** - See [LICENSE](LICENSE) for full terms.

```
Copyright (c) 2025 Wellme™(Ukraine)

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

**TL;DR:** Free to use, modify, distribute. No warranty. Attribution appreciated.

---

## 🌟 Why We Built This

As a **Ukrainian IT company**, we face unique challenges:
- **Legal risks** from accidental russian service integration
- **Compliance requirements** for EU/international clients
- **Security standards** for sensitive projects
- **AI budget constraints** (tokens are expensive!)

This framework solves **our** problems. We hope it helps you too.

**Made with ❤️ in Ukraine** 🇺🇦

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

**AI Workflow Rules Framework v7.0**
*Open Source • Made in Ukraine 🇺🇦*

[wellme.ua](https://wellme.ua) • © 2025 Wellme™

</div>
