# 📋 Cheatsheet - Quick Reference

One-page guide to AI Workflow Rules Framework. Print this or keep it open while working.

---

## 🚨 NEVER Do This

| ❌ DON'T | Why | Instead |
|----------|-----|---------|
| Hardcode secrets | Git history leak | `process.env.API_KEY` |
| Use russian trackers | Legal + security risk | Google Analytics, Plausible |
| Commit with `--no-verify` | Bypasses security | Fix issue, then commit |
| Use `.ru` domains | Ukrainian market policy | `.com`, `.ua`, `.eu` |
| Concatenate i18n strings | Breaks translations | `t('key', { var })` |

---

## ✅ ALWAYS Do This

| ✅ DO | Example |
|-------|---------|
| Use env vars for secrets | `const key = process.env.OPENAI_API_KEY` |
| Check forbidden trackers | Before adding: check `.ai/forbidden-trackers.json` |
| Run seo-check before deploy | `./scripts/seo-check.sh .` |
| Use i18n for all text | `<button>{t('common.submit')}</button>` |
| Discuss before coding | Present plan → get approval → code |

---

## 🤖 AI Commands

Type these in conversation with your AI assistant:

| Command | What It Does |
|---------|--------------|
| `//CHECK:SECURITY` | Security audit (secrets, XSS, injection) |
| `//CHECK:LANG` | Russian content detection |
| `//CHECK:ALL` | Full audit (security + performance + i18n) |
| `//TOKENS` | Show token usage status |
| `//COMPACT` | Compress context (saves tokens) |
| `//THINK` | Show AI reasoning in `<thinking>` tags |

---

## 📝 Git Commit Format

```bash
git commit -m "type(scope): description"
```

| Type | When to Use | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add OAuth login` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation | `docs(readme): update install guide` |
| `refactor` | Code restructure | `refactor(ui): extract Button component` |
| `style` | Formatting | `style(eslint): fix indentation` |
| `chore` | Maintenance | `chore(deps): update dependencies` |
| `security` | Security fix | `security(ai): remove hardcoded API key` |

---

## 📋 Copy-Paste Templates

### i18n Component (React)
```tsx
import { useTranslation } from 'react-i18next';

export function MyComponent() {
  const { t } = useTranslation();

  return (
    <div>
      <h1>{t('page.title')}</h1>
      <p>{t('page.description', { name: 'User' })}</p>
      <button>{t('common.submit')}</button>
    </div>
  );
}
```

### Secure API Route
```ts
export async function POST(req: Request) {
  // ✅ Get secret from env
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return new Response('Missing API key', { status: 500 });
  }

  // ✅ Validate input
  const body = await req.json();
  if (!body.prompt) {
    return new Response('Invalid request', { status: 400 });
  }

  // ✅ Use secret safely
  const response = await fetch('https://api.openai.com/v1/...', {
    headers: { 'Authorization': `Bearer ${apiKey}` }
  });

  return Response.json(await response.json());
}
```

### Environment Variables Usage
```ts
// ✅ CORRECT - use env vars
const config = {
  apiKey: process.env.OPENAI_API_KEY,
  dbUrl: process.env.DATABASE_URL,
  nodeEnv: process.env.NODE_ENV || 'development'
};

// ❌ WRONG - hardcoded secrets
const apiKey = "sk-ant-1234567890"; // DON'T!
```

### i18n Locale File
```json
{
  "common": {
    "submit": "Submit",
    "cancel": "Cancel",
    "save": "Save",
    "delete": "Delete"
  },
  "auth": {
    "login": "Login",
    "logout": "Logout",
    "register": "Register"
  },
  "errors": {
    "notFound": "Not found",
    "serverError": "Server error",
    "unauthorized": "Unauthorized"
  }
}
```

---

## 🛡️ Security Checklist

Before each commit:

- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] No russian tracking services (Yandex, VK, Mail.ru)
- [ ] `.env` file in `.gitignore` (not committed)
- [ ] All user input validated
- [ ] Error handling present
- [ ] Pre-commit hook passed

---

## 🇺🇦 Ukrainian Market Policy

**Forbidden:**
- ❌ Yandex Metrika, VK Pixel, OK.ru, Mail.ru
- ❌ Yandex Maps, 2GIS
- ❌ YooKassa, QIWI, WebMoney
- ❌ `.ru` domains in production
- ❌ Russian language in UI (unless targeting diaspora)

**Use instead:**
- ✅ Google Analytics, Plausible, Matomo
- ✅ Google Maps, OpenStreetMap, Mapbox
- ✅ Stripe, WayForPay (UA), LiqPay (UA)
- ✅ Ukrainian language UI (`uk-UA`)

Full list: `.ai/forbidden-trackers.json`

---

## 📊 Token Management

| Status | % Used | Action |
|--------|--------|--------|
| 🟢 Green | 0-50% | Normal mode |
| 🟡 Moderate | 50-70% | Brief mode, optimize |
| 🟠 Caution | 70-90% | Silent mode, compress |
| 🔴 Critical | 90-95% | Finalize only |
| ⛔ Emergency | 95-100% | Commit & stop |

**Save tokens:**
- Use `//COMPACT` at 50% usage
- Delete optional files after reading
- Use diff-only mode for edits

---

## 🔧 Quick Commands

```bash
# Security check
./scripts/seo-check.sh .

# Validate setup
./scripts/validate-setup.sh

# Check token usage
cat .ai/token-limits.json | grep "daily_percentage"

# Test pre-commit hook
git add test.txt && git commit -m "test"

# Bypass hook (emergency only!)
git commit --no-verify -m "docs: legitimate exception"
```

---

## 📚 Full Documentation

| File | What's Inside | Reading Time |
|------|---------------|--------------|
| [QUICKSTART.md](QUICKSTART.md) | 5-minute setup | 5 min |
| [RULES_CORE.md](RULES_CORE.md) | Main workflow rules | 15 min |
| [RULES_PRODUCT.md](RULES_PRODUCT.md) | UA market specifics | 10 min |
| [TOKEN_USAGE.md](TOKEN_USAGE.md) | Token optimization | 5 min |
| [START.md](START.md) | AI onboarding | 3 min |

---

<div align="center">

**Keep this cheatsheet open while working!**

Questions? [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)

**AI Workflow Rules Framework v7.0** • Made in Ukraine 🇺🇦

</div>
