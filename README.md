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

## What Is This?

AI Workflow Rules Framework is an **open source template** for developers working with AI assistants (like Claude Code, GitHub Copilot, Cursor). It provides:

- 🛡️ **Security protection** - Prevents data leaks and ensures clean code
- 🇺🇦 **Ukrainian compliance** - Zero tolerance for russian tracking services
- 🤖 **AI budget management** - Token tracking and optimization
- ⚡ **Pre-deploy checks** - 9 automated security & SEO audits

**Perfect for:**
- Ukrainian IT companies and freelancers
- Projects targeting EU markets
- Teams requiring GDPR compliance
- Anyone building secure, ethical applications

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

### 1. Download & Integrate

```bash
# Clone or download
git clone https://github.com/Shamavision/ai-workflow-rules.git
cd ai-workflow-rules

# Copy to your project
cp -r .ai /path/to/your-project/
cp RULES_*.md /path/to/your-project/
cp -r scripts /path/to/your-project/
```

### 2. Install Git Hooks

```bash
# Copy pre-commit hook
cp .git/hooks/pre-commit /path/to/your-project/.git/hooks/
chmod +x /path/to/your-project/.git/hooks/pre-commit
```

### 3. Customize

```bash
# Edit token limits for your plan
nano .ai/token-limits.json  # Update with your Anthropic plan

# (Optional) Customize forbidden services
nano .ai/forbidden-trackers.json
```

### 4. Run Security Check

```bash
# Before deploy
./scripts/seo-check.sh /path/to/your-project

# ✅ All checks passed - ready to deploy!
```

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
  └── seo-check.sh               # 9 automated security & SEO checks

.git/hooks/
  └── pre-commit                 # Automatic checks on every commit

RULES_CORE.md                    # AI workflow instructions (token mgmt, security)
RULES_PRODUCT.md                 # Ukrainian market specifics (i18n, SEO, compliance)
START.md                         # Quick onboarding guide for AI assistants
INSTALL.md                       # Installation guide (multiple options)
AI_COMPATIBILITY.md              # AI assistant compatibility matrix
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
