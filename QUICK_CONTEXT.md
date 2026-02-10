# Quick Context Guide

> **Copy-paste this into new AI sessions for instant project context.**

---

## 🎯 What This Is

When starting a new AI session, you don't need to re-read full .ai/rules/core.md. This file is the **essential 30 rules** that matter most.

**Usage:**
```
//START
Also, follow quick context from QUICK_CONTEXT.md
```

---

## 🔒 Security Rules (Non-Negotiable)

### 1. **No Secrets in Code**
```
❌ const API_KEY = 'sk_live_xxx'
✅ const API_KEY = process.env.API_KEY
```

### 2. **No Secrets in Git History**
```
Check BEFORE commit: git diff --cached
If found: Remove + git commit --amend (if not pushed yet)
```

### 3. **No Russian Tracking Services**
```
❌ FORBIDDEN: See .ai/forbidden-trackers.json (40+ patterns)
✅ ALLOWED: Google Analytics, Plausible, Stripe, PayPal
Legal risk: HIGH (sanctions, GDPR violations)
Detection: Automatic (pre-commit hook blocks)
```

### 4. **Parameterized SQL Queries Only**
```
❌ db.query(`SELECT * FROM users WHERE id = '${userId}'`)
✅ db.query('SELECT * FROM users WHERE id = ?', [userId])
```

### 5. **Rate Limiting on Auth Endpoints**
```
Login, registration, password reset: 5 attempts / 15 min
Payment endpoints: 3 attempts / 5 min
```

### 6. **Input Validation**
```
Validate: type, length, format, range
Sanitize: HTML, SQL, XSS
Never trust user input (not even from authenticated users)
```

### 7. **HTTPS Only**
```
Production: Force HTTPS (redirect HTTP → HTTPS)
Cookies: secure: true, httpOnly: true, sameSite: 'strict'
```

### 8. **Security Headers**
```
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=31536000
```

### 9. **No Sensitive Data in Logs**
```
❌ console.log('User:', req.body) // may contain passwords
✅ console.log('User ID:', req.body.id) // safe
```

### 10. **Pre-Commit Hooks Active**
```
Auto-scans for: secrets, API keys, russian trackers
Location: .git/hooks/pre-commit
NEVER bypass with --no-verify (unless emergency)
```

---

## 🇺🇦 Ukrainian Market Rules

### 1. **Zero Russian Services**
```
Legal risk: High (sanctions, GDPR violations)
Detection: Automatic (pre-commit hook)
Alternatives: .ai/forbidden-trackers.json → "alternatives" field
```

### 2. **Ukrainian Language First**
```
Primary: uk-UA (Ukrainian)
Secondary: en-US (English), other if client requires
Meta tags: <html lang="uk-UA">
i18n structure: /locales/uk.json, /locales/en.json
```

### 3. **GDPR Compliant**
```
Required:
- Privacy policy (Ukrainian language)
- Cookie consent
- Data export endpoint
- Data deletion endpoint
```

### 4. **Localization Architecture**
```
i18n-ready from day 1 (not "we'll add it later")
Structure: /locales/uk.json, /locales/en.json
Examples: examples/react-i18n.tsx
```

### 5. **Data Sovereignty**
```
Store Ukrainian user data in EU (not russia, not .ru domains)
Hosting: AWS eu-central-1, Google europe-west3, Azure westeurope
```

---

## 💰 Token Management Rules

### 1. **Ask Before Reading**
```
❌ "Let me explore your codebase..." (35k wasted)
✅ "Which files should I read?" (5k targeted)
```

### 2. **Show Estimates for Large Tasks**
```
>15k tokens: Show estimate + breakdown + confidence
>40k tokens: Suggest splitting into stages
>80k tokens: MANDATORY discussion
```

### 3. **Diff-Only at 50%+**
```
🟡 Moderate zone (50-70%): Show diffs, not full files
Saves: 80-90% tokens on edits
```

### 4. **Context Compression**
```
Triggers: Every 3 tasks, 50% tokens, after git push
Saves: 40-60% tokens
Preserves: Decisions, preferences, current task
```

### 5. **Emergency Reserve**
```
Always protect 10-15% for: bugs, clarifications, rollbacks
If task would use reserve: Suggest split/defer
```

---

## 📝 Git Discipline

### 1. **One Stage = One Commit**
```
Atomic commits (revertable, reviewable)
NOT: "Fixed stuff" (50 files, unrelated changes)
```

### 2. **Conventional Commits**
```
Format: type(scope): description

Types:
feat: New feature
fix: Bug fix
security: Security improvement
refactor: Code restructuring
docs: Documentation
i18n: Internationalization
test: Tests
chore: Maintenance
```

### 3. **AI Suggests → User Approves**
```
NEVER auto-commit
Show: git add + git commit suggestion
Wait for: YES/EDIT/WAIT
```

### 4. **Meaningful Messages**
```
❌ "Update code"
❌ "Fix bug"
✅ "fix(auth): prevent rate limit bypass via IP spoofing"
✅ "feat(i18n): add Ukrainian translations for checkout flow"
```

### 5. **Pre-Commit Checks Pass**
```
Automatic: Security scan, secret detection, tracker check
If fails: Fix issues, DON'T use --no-verify
```

---

## ⚡ Workflow Rules

### 1. **Discuss → Approve → Execute**
```
NEVER code before agreement on approach
Present options: show trade-offs, costs, risks
Wait for explicit approval: YES/GO/✓
```

### 2. **Stage-Based Execution**
```
Break into stages: ~8-15k tokens each
After each stage: commit + verify + ask "continue?"
Allows: Pause, adjust, rollback
```

### 3. **Token Status Zones**
```
🟢 0-50% (Green): Full capacity, normal mode
🟡 50-70% (Moderate): Brief mode, optimizations
🟠 70-90% (Caution): Silent mode, aggressive compression
🔴 90-95% (Critical): Finalize + commit + stop
```

### 4. **Security First**
```
Red flags (auto-stop):
- Deleting >10 files
- Changing package.json, tsconfig
- Database migrations
- rm -rf commands
- Publishing to npm/production
- Russian content detected
- API key in client code
```

### 5. **Simple > Complex**
```
YAGNI (You Aren't Gonna Need It)
No: Premature optimization, "just in case" abstractions
Yes: Solve today's problem, refactor when needed
```

---

## 🎯 Quick Commands

```
//START           - Load all rules, init session
//TOKENS          - Show token budget status
//CHECK:SECURITY  - Run security audit
//CHECK:LANG      - Check for russian content
//CHECK:ALL       - Full audit (security + lang + i18n)
//COMPACT         - Compress context (saves 40-60%)
//THINK           - Show AI reasoning
```

---

## 📊 Red Flags Checklist

**Before EVERY commit, verify:**

```
[ ] No API keys or secrets in code
[ ] No russian tracking services
[ ] SQL queries are parameterized
[ ] User input is validated/sanitized
[ ] Sensitive data not in logs
[ ] Security headers present (if web app)
[ ] Rate limiting on auth endpoints
[ ] HTTPS enforced (production)
[ ] i18n structure exists (Ukrainian market)
[ ] Git commit message follows convention
```

**If ANY ❌ → Fix before commit**

---

## 🚀 Typical Session Flow

```
1. Start session: //START
   → AI loads RULES, shows token status

2. Describe task:
   "Add user profile page. Stack: React, TS. Ukrainian market."

3. AI analyzes:
   - Asks questions (reuse components? API ready?)
   - Shows token estimate
   - Presents options (if multiple approaches)

4. You approve:
   "YES" or "Option 2"

5. AI executes stage-by-stage:
   Stage 1 → commit → Stage 2 → commit → ...

6. Verify + test:
   //CHECK:SECURITY before final commit

7. Done:
   git push
   AI compresses context (frees 40-60% tokens)
```

---

## 💡 When to Use Full RULES

**Use this QUICK_CONTEXT for:** 90% of sessions (standard work)

**Read full .ai/rules/core.md when:**
- First time using framework
- Complex architectural decisions
- Multi-day projects (read checkpoints section)
- Token budget planning (variance tracking)
- Security incident response

**Read .ai/rules/product.md when:**
- Ukrainian market specifics (SEO, compliance)
- i18n architecture decisions
- Migrating from russian services

---

## 🔗 Key Files

```
.ai/rules/core.md           - Full workflow rules
.ai/rules/product.md        - Ukrainian market specifics
.ai/token-limits.json       - Token budget tracking
.ai/forbidden-trackers.json - Russian services blacklist
examples/                   - Real-world dialog examples
scripts/pre-commit          - Security scanning hook
```

---

## ⚡ Emergency Commands

```bash
# Rollback last commit (if not pushed)
git reset --soft HEAD~1

# Check what's staged
git status
git diff --cached

# Verify security
./scripts/seo-check.sh .

# Compress context manually
//COMPACT
```

---

**This is your 80/20 rule: 30 rules cover 80% of scenarios.**

**Made with ❤️ in Ukraine 🇺🇦**
