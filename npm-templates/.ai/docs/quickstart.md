# 🚀 Quick Start - 5 Minutes to Production

Get up and running with AI Workflow Rules Framework in 5 minutes.

---

## ✅ Step 1: Choose Installation Type

### Option A: Minimal (30k tokens, Free plan friendly)
```bash
# Copy essentials only
cp -r .ai /path/to/your-project/
cp RULES_CORE.md START.md /path/to/your-project/
cp scripts/seo-check.sh /path/to/your-project/scripts/
```

### Option B: Full (66k tokens, recommended for Pro)
```bash
# Copy everything
cp -r .ai /path/to/your-project/
cp RULES_*.md START.md INSTALL.md AI_COMPATIBILITY.md /path/to/your-project/
cp QUICKSTART.md CHEATSHEET.md TOKEN_USAGE.md /path/to/your-project/
cp -r scripts examples /path/to/your-project/
cp .env.example .editorconfig /path/to/your-project/
cp -r .vscode /path/to/your-project/
```

### Option C: Automatic (recommended!)
```bash
# Run setup script - it does everything for you
cd /path/to/your-project/
./scripts/setup.sh  # Unix/Mac/WSL
# OR
./scripts/setup.ps1  # Windows PowerShell
```

---

## ✅ Step 2: Configure Token Limits

Edit `.ai/token-limits.json`:

```json
{
  "provider": "anthropic",  // YOUR provider: anthropic, openai, google, cursor
  "plan": "pro",            // YOUR plan: free, pro, team

  // Limits auto-fill from PRESETS below - just set provider + plan!
  "monthly_limit": 5000000,
  "daily_limit": 150000
}
```

**Don't know your limits?** Check PRESETS section in the file or [provider docs](https://console.anthropic.com/settings/limits).

---

## ✅ Step 3: Setup Environment Secrets

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your secrets (NEVER commit this file!)
nano .env
```

Add your API keys:
```bash
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
DATABASE_URL=postgresql://...
```

**Important:** `.env` is in `.gitignore` - it won't be committed.

---

## ✅ Step 4: Validate Setup

```bash
# Run validation script
./scripts/validate-setup.sh

# Expected output:
# ✅ token-limits.json
# ✅ RULES_CORE.md
# ✅ Pre-commit hook
# ✅ seo-check works
```

If anything shows ❌, follow the instructions to fix it.

---

## ✅ Step 5: Start Working!

### For Claude Code / Cursor:
Just start coding - AI automatically reads RULES ✅

### For ChatGPT / Gemini:
1. Open [`START.md`](START.md)
2. Copy content into first message
3. Tell AI: "Follow these rules"

### Test Security Checks:
```bash
# Run pre-deploy security check
./scripts/seo-check.sh .

# Should output:
# ✅ [1] robots.txt...
# ✅ [2] HTML meta tags...
# ... (9 checks total)
```

---

## 📋 Next Steps

### First Time User?
Read the one-page cheatsheet:
```bash
cat CHEATSHEET.md
```

### Need Examples?
Check `examples/` folder:
- `react-i18n.tsx` - i18n component
- `api-security.ts` - secure API route
- `env-usage.ts` - environment variables

### Want Full Docs?
- [RULES_CORE.md](RULES_CORE.md) - Main rules (15 min read)
- [RULES_PRODUCT.md](RULES_PRODUCT.md) - Product specifics (10 min read)
- [TOKEN_USAGE.md](TOKEN_USAGE.md) - Token optimization

---

## 🚨 Common Issues

### "AI doesn't see the rules"
- **Claude Code/Cursor:** Restart IDE
- **ChatGPT:** Copy-paste START.md manually
- **GitHub Copilot:** Add key rules as code comments

### "Pre-commit hook doesn't work"
```bash
# Make it executable
chmod +x .git/hooks/pre-commit

# On Windows: use Git Bash or WSL
```

### "Ran out of tokens on setup"
See [TOKEN_USAGE.md](TOKEN_USAGE.md) for:
- Minimal installation (30k tokens)
- Files you can delete after reading
- Token optimization tips

---

## 🎯 Quick Reference

| Task | Command |
|------|---------|
| **Run security check** | `./scripts/seo-check.sh .` |
| **Validate setup** | `./scripts/validate-setup.sh` |
| **Check token usage** | `cat .ai/token-limits.json` |
| **AI: show tokens** | Type `//TOKENS` in conversation |
| **AI: security audit** | Type `//CHECK:SECURITY` |
| **AI: russian content** | Type `//CHECK:LANG` |

---

## ✅ You're Ready!

**What you have now:**
- 🛡️ Protection from secrets leaks
- 🇺🇦 Zero tolerance for russian services
- 🤖 AI budget management
- ⚡ Pre-deploy security checks

**Start coding safely!** 🚀

---

<div align="center">

Need help? Check [CHEATSHEET.md](CHEATSHEET.md) or [open an issue](https://github.com/Shamavision/ai-workflow-rules/issues)

**AI Workflow Rules Framework v7.0** • Made in Ukraine 🇺🇦

</div>
