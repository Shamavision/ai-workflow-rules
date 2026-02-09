# Code Quality & Linting

> **Auto-enabled in v9.1** | **Non-blocking warnings only**

---

## 🎯 Overview

The framework includes an **optional code quality check** that runs automatically before commits. It shows warnings but **never blocks your commits**.

**Philosophy:**
- ✅ Help you catch issues early
- ✅ Show suggestions, not demands
- ✅ Easy to skip when needed
- ❌ Never interrupt your workflow

---

## 🔍 What Gets Checked

### Supported Languages & Tools

| Language | Tools | What's Checked |
|----------|-------|----------------|
| **JavaScript/TypeScript** | ESLint, Prettier | Syntax, style, formatting |
| **Python** | Black, Flake8 | Formatting, PEP 8 compliance |
| **Go** | gofmt, go vet | Formatting, common mistakes |
| **Shell Scripts** | shellcheck | Best practices, portability |
| **Markdown** | markdownlint | Consistency, formatting |

### Auto-Detection

The hook automatically detects your project type:

```bash
# JavaScript/TypeScript - looks for package.json
npm run lint
npm run format --check

# Python - looks for pyproject.toml, setup.py, requirements.txt
black --check .
flake8 .

# Go - looks for go.mod
gofmt -l .
go vet ./...

# Shell - checks *.sh, *.bash files
shellcheck *.sh

# Markdown - checks *.md files
markdownlint *.md
```

---

## ⚙️ Setup

### Quick Setup (Recommended)

```bash
# Auto-install linters for your project type
bash scripts/setup-lint.sh
```

This will:
1. Detect your project type
2. Install appropriate linters
3. Add npm scripts (for JS/TS projects)
4. Create config files if needed

### Manual Setup

#### JavaScript/TypeScript

```bash
npm install --save-dev eslint prettier

# Add to package.json:
{
  "scripts": {
    "lint": "eslint .",
    "format": "prettier --write ."
  }
}
```

**Optional config:** `.eslintrc.json`, `.prettierrc`

#### Python

```bash
pip install black flake8

# Optional config: pyproject.toml
[tool.black]
line-length = 88

[tool.flake8]
max-line-length = 88
```

#### Go

```bash
# gofmt is built-in with Go
# No setup needed!

# Optional: Install golint
go install golang.org/x/lint/golint@latest
```

#### Shell Scripts

```bash
# macOS
brew install shellcheck

# Linux (Ubuntu/Debian)
apt install shellcheck

# Linux (Fedora/RHEL)
dnf install shellcheck
```

---

## 📋 Example Output

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Code Quality Check (Warnings Only)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Detected: JavaScript/TypeScript project
   Running: npm run lint...
   ✓ Linting passed

   Running: npm run format --check...
   ⚠️  Formatting issues found
   Fix: Run 'npm run format' to auto-fix

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Found 1 warning(s)

These are warnings only and won't block your commit.
Consider fixing them before pushing to remote.

To skip lint checks: AI_SKIP_LINT=1 git commit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🚫 Skipping Lint Checks

### Permanently Disable

```bash
# .ai/config.json
{
  "linting": {
    "enabled": false
  }
}
```

### One-Time Skip

```bash
# Skip for single commit
AI_SKIP_LINT=1 git commit -m "WIP: testing"

# Skip all pre-commit hooks (emergency)
git commit --no-verify -m "Emergency fix"
```

### Selective Skip

```bash
# Skip specific linters (not implemented yet)
AI_SKIP_ESLINT=1 git commit
```

---

## 🤖 AI Behavior

When AI makes commits, it should:

1. **Before commit:** Suggest running lint
   ```
   AI: "Run `npm run lint` to check code quality?"
   User: "yes" | "skip"
   ```

2. **If warnings found:** Show them but don't block
   ```
   AI: "⚠️ Found 3 linting warnings. Commit anyway? (warnings won't block)"
   ```

3. **AI can auto-fix:** If user approves
   ```
   AI: "I can run `npm run format` to auto-fix formatting. Proceed?"
   ```

**Protocols added to:**
- `.ai/AI-ENFORCEMENT.md` - Mandatory protocols
- Contexts - AI session start rules

---

## 📖 Best Practices

### For Projects

1. **Start with recommended configs**
   ```bash
   # Don't over-configure at start
   # Use framework defaults first
   ```

2. **Add configs gradually**
   ```
   Only add rules when you encounter specific issues
   Don't copy-paste huge eslint configs blindly
   ```

3. **Document exceptions**
   ```javascript
   // eslint-disable-next-line no-console
   console.log('Debug info'); // OK: development only
   ```

### For Teams

1. **Commit lint configs to repo**
   - `.eslintrc.json`
   - `.prettierrc`
   - `pyproject.toml`

2. **Run lint in CI/CD**
   ```yaml
   # .github/workflows/lint.yml
   - run: npm run lint
   - run: npm run format --check
   ```

3. **Auto-fix on save (IDE)**
   ```json
   // .vscode/settings.json
   {
     "editor.formatOnSave": true,
     "editor.codeActionsOnSave": {
       "source.fixAll.eslint": true
     }
   }
   ```

---

## 🔧 Troubleshooting

### "Linter not found"

```bash
# JavaScript/TypeScript
npm install --save-dev eslint prettier

# Python
pip install black flake8

# Shell
brew install shellcheck  # macOS
apt install shellcheck   # Linux
```

### "Lint script fails"

Check if npm script exists:
```bash
npm run lint  # Should not error with "Missing script"
```

Add to `package.json` if missing:
```json
{
  "scripts": {
    "lint": "eslint .",
    "format": "prettier --write ."
  }
}
```

### "Too many warnings"

Start with auto-fix:
```bash
# JavaScript/TypeScript
npm run format
npm run lint -- --fix

# Python
black .

# Go
gofmt -w .
```

Then gradually enable stricter rules.

---

## 📚 Resources

### ESLint (JavaScript/TypeScript)
- Docs: https://eslint.org/docs/latest/
- Config: https://eslint.org/docs/latest/use/configure/
- Rules: https://eslint.org/docs/latest/rules/

### Prettier (All languages)
- Docs: https://prettier.io/docs/en/
- Config: https://prettier.io/docs/en/configuration

### Black (Python)
- Docs: https://black.readthedocs.io/
- Config: https://black.readthedocs.io/en/stable/usage_and_configuration/

### Shellcheck (Shell scripts)
- Docs: https://www.shellcheck.net/
- Wiki: https://github.com/koalaman/shellcheck/wiki

---

**Version:** 9.1
**Last Updated:** 2026-02-08
**Made in Ukraine 🇺🇦**
