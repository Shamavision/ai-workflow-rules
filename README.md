# AI Workflow Rules (Private)

🔒 **CONFIDENTIAL** — Corporate Intellectual Property  
Do not share or publish this repository publicly.

---

## 📁 WHAT'S IN THIS REPO

This repository contains the complete AI workflow and product development rules used across all projects.
```
/.ai-rules/
├── RULES_CORE.md           # Technical workflow (git, security, tokens)
├── RULES_PRODUCT.md        # Product rules (i18n, a11y, scaling)
├── .ai/
│   ├── token-limits.json   # Token usage tracking
│   └── locale-context.json # i18n configuration
├── templates/              # Templates for new projects
│   ├── .gitignore.template
│   ├── .security-baseline.template
│   └── PROJECT_INFO.md.template
└── README.md               # This file
```

---

## 🚀 SETUP (First Time)

### Step 1: Create Private GitHub Repo
```bash
# On GitHub.com:
Repositories → New
Name: ai-workflow-rules
Private: ✅ (CRITICAL!)
Initialize: No README, no .gitignore
```

### Step 2: Clone and Initialize
```bash
# Clone this starter repo (or create from scratch)
git clone git@github.com:YOUR_USERNAME/ai-workflow-rules.git
cd ai-workflow-rules

# Add all files
git add .
git commit -m "init: AI workflow rules v4.0"
git push -u origin main
```

### Step 3: Add to New Project as Submodule
```bash
cd /path/to/your-project

# Add submodule
git submodule add git@github.com:YOUR_USERNAME/ai-workflow-rules.git .ai-rules

# Add to .gitignore
echo ".ai-rules/" >> .gitignore

# Commit
git add .gitignore .gitmodules
git commit -m "chore: add private AI rules submodule"
git push
```

---

## 📋 DAILY USAGE

### Starting a Work Session
```bash
cd /your-project

# Pull latest rules (if updated in another project)
cd .ai-rules && git pull && cd ..

# Update token limits
# Edit .ai-rules/.ai/token-limits.json
# Set current_usage = 0 if new day
# Or += yesterday's usage if continuing

# AI will auto-read rules and token limits
```

### Ending a Work Session
```bash
# Update token usage
# Edit .ai-rules/.ai/token-limits.json
# Update current_usage += tokens_used_today

# If you made changes to RULES
cd .ai-rules
git add RULES_CORE.md RULES_PRODUCT.md
git commit -m "rules: [describe changes]"
git push
cd ..
```

### Syncing Rules Across Projects
```bash
# In project A (where you updated RULES)
cd .ai-rules
git push

# In project B (to get updates)
cd .ai-rules
git pull
cd ..
```

---

## 📝 UPDATING RULES

### When to Update
- Pattern used 2+ times → add to RULES_CORE.md
- Product decision made → add to RULES_PRODUCT.md
- Security lesson learned → update security sections
- New market/language → update locale-context.json

### How to Update
```bash
cd .ai-rules

# Edit the relevant file
nano RULES_CORE.md  # or RULES_PRODUCT.md

# Commit with context
git add RULES_CORE.md
git commit -m "rules(security): add pre-commit hook for secrets scanning"
git push

# Sync to other projects
cd /other-project/.ai-rules
git pull
```

---

## 🆕 STARTING NEW PROJECT

### Quick Start Checklist
```bash
# 1. Clone project template or init new project
npx create-next-app@latest my-project

# 2. Add .ai-rules submodule
cd my-project
git submodule add git@github.com:YOUR_USERNAME/ai-workflow-rules.git .ai-rules

# 3. Copy templates
cp .ai-rules/templates/.gitignore.template .gitignore
cp .ai-rules/templates/.security-baseline.template .security-baseline
cp .ai-rules/templates/PROJECT_INFO.md.template PROJECT_INFO.md

# 4. Edit PROJECT_INFO.md
nano PROJECT_INFO.md  # Fill in project details

# 5. Update .security-baseline
nano .security-baseline  # Fill in security config

# 6. Create .env.example
touch .env.example
# Add all env var keys (no values)

# 7. First commit
git add .
git commit -m "init: project setup with AI rules"
git push
```

---

## 👥 TEAM ONBOARDING

### Adding Team Member
```bash
# On GitHub:
# 1. Go to ai-workflow-rules repo
# 2. Settings → Collaborators → Add people
# 3. Enter their GitHub username
# 4. They get invitation email

# Team member clones project with submodule:
git clone --recurse-submodules git@github.com:team/project.git
```

### Revoking Access
```bash
# On GitHub:
# 1. Go to ai-workflow-rules repo
# 2. Settings → Collaborators
# 3. Remove user
# They immediately lose access to rules
```

---

## 🔧 TROUBLESHOOTING

### Submodule Not Updating
```bash
# Force update
cd .ai-rules
git fetch origin
git reset --hard origin/main
cd ..
```

### Forgot to Add Submodule on Clone
```bash
git submodule update --init --recursive
```

### Rules Conflicts Between Projects
```bash
# Choose which version to keep
cd .ai-rules
git status  # See conflicts
# Edit files to resolve
git add .
git commit -m "rules: resolve conflicts"
git push
```

---

## 📊 TOKEN MANAGEMENT

### Checking Token Usage
```bash
# View current usage
cat .ai-rules/.ai/token-limits.json

# AI automatically warns at 90% and stops at 95%
```

### Resetting Daily Tokens
```bash
# Edit .ai-rules/.ai/token-limits.json
# Set:
# "current_usage": 0
# "last_reset": "2025-01-27T00:00:00Z"  # Today's date
```

### Tracking History (Optional)
```bash
# Script to auto-log daily usage:
# Add to .ai-rules/.ai/token-limits.json "history" section
# Run at end of each day
```

---

## 🔒 SECURITY REMINDERS

### What MUST Stay Private
- ✅ Entire .ai-rules/ directory
- ✅ All RULES_*.md files
- ✅ token-limits.json (contains usage patterns)
- ✅ Any project-specific notes in rules

### What CAN Be Public
- ✅ .env.example (keys without values)
- ✅ PROJECT_INFO.md (if sanitized)
- ✅ .security-baseline (if generic)

### Regular Security Tasks
- **Monthly:** Review who has access to this repo
- **Quarterly:** Audit rules for any accidentally committed secrets
- **Annually:** Full security review of rules repository

---

## 📞 SUPPORT

### Questions About Rules
- Check RULES_CORE.md for technical workflow
- Check RULES_PRODUCT.md for product/UX guidance
- Check this README for setup/sync issues

### Updating Rules
- Make changes in any project
- Push to ai-workflow-rules repo
- Pull in other projects
- Rules evolve with experience

---

## 📈 VERSION HISTORY

- **v4.0** [2025-01-26] — Split into CORE + PRODUCT, added token management, security enhancements
- **v3.5** [2025-01-26] — Added AI API security, anti-overengineering rules
- **v3.0** — Initial comprehensive version

---

*Last Updated: 2025-01-26*  
*Keep this repo private. Update rules as you learn. Share knowledge, protect IP.*
```

---

## ✅ ВСЕ ФАЙЛЫ ГОТОВЫ!

### Что создано:

1. ✅ **RULES_CORE.md v4.0** — технический workflow
2. ✅ **RULES_PRODUCT.md v1.0** — продуктовые правила
3. ✅ **.ai/token-limits.json** — трекинг токенов с комментариями
4. ✅ **.ai/locale-context.json** — i18n конфигурация с примерами
5. ✅ **templates/.gitignore.template** — для новых проектов
6. ✅ **templates/.security-baseline.template** — security конфиг
7. ✅ **templates/PROJECT_INFO.md.template** — информация о проекте
8. ✅ **README.md** — инструкция по использованию всей системы

---

### Итоговая структура `.ai-rules` repo:
```
/.ai-rules/  (private GitHub repo)
├── RULES_CORE.md              # 950 строк, workflow
├── RULES_PRODUCT.md           # 850 строк, продукт
├── .ai/
│   ├── token-limits.json      # 35 строк, с инструкциями
│   └── locale-context.json    # 120 строк, с примерами
├── templates/
│   ├── .gitignore.template    # 150 строк, comprehensive
│   ├── .security-baseline.template  # 130 строк, checklist
│   └── PROJECT_INFO.md.template     # 300 строк, полная документация
└── README.md                  # 400 строк, setup guide