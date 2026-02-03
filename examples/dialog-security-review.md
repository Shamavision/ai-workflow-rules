# Dialog Example: Security Review with AI

## 📋 Context
Task: Pre-launch security audit of payment integration
Startup: Ukrainian fintech, handling real money
Risk: HIGH (data breach = bankruptcy)
Timeline: Launch in 3 days

---

## ❌ Bad Approach (Dangerous)

```markdown
User: "Review security of payment.ts"

AI: [reads file]
AI: "Looks good! Using HTTPS ✅, validation present ✅"

User: "Great, shipping to prod!"

[2 days later]
- 500 users' card data leaked
- SQL injection in payment logs
- API keys in frontend bundle
- Company sued, service shut down

Result: Business destroyed because AI missed critical issues
```

**Why it failed:** No systematic checklist, AI looked at surface, missed real threats.

---

## ✅ Good Approach (Professional Security Audit)

### User's First Message:
```markdown
//START
//CHECK:SECURITY

Context: Pre-launch security audit
Component: Payment integration (Stripe)
Files:
- api/payment.ts (backend)
- components/CheckoutForm.tsx (frontend)
- lib/stripe.ts (integration)

Risk: HIGH (handling payments)
Compliance: Need GDPR compliance (Ukrainian/EU users)

Run full security audit checklist.
```

### AI Response:
```markdown
[SECURITY AUDIT INITIATED] 🔒

Target: Payment integration
Risk level: HIGH (financial data)
Compliance: GDPR required

Running systematic checks (not just "looks good"):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Reading files with security focus...
- api/payment.ts
- components/CheckoutForm.tsx
- lib/stripe.ts
- .env.example (checking for leaks)
- package.json (vulnerable deps check)

Will check against OWASP Top 10 + GDPR + PCI DSS basics.
```

### After reading (10k tokens):
```markdown
[SECURITY AUDIT RESULTS] 🚨

Found: 2 CRITICAL, 3 HIGH, 4 MEDIUM issues

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 CRITICAL (FIX BEFORE LAUNCH)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. **API Key in Frontend Bundle** 🚨
   File: lib/stripe.ts:3
   Issue: `const STRIPE_SECRET = 'sk_live_...'`

   Risk:
   - Secret key in client code = publicly exposed
   - Anyone can charge cards, refund, access customer data
   - Violation: PCI DSS, catastrophic breach

   Fix:
   ❌ const STRIPE_SECRET = 'sk_live_xxx'
   ✅ Use STRIPE_SECRET from backend only
   ✅ Frontend uses publishable key: 'pk_live_xxx'

   Estimated fix: ~2k tokens

2. **SQL Injection in Payment Logs** 🚨
   File: api/payment.ts:67
   Code:
   ```js
   db.query(`INSERT INTO logs VALUES ('${userId}', '${amount}')`)
   ```

   Risk:
   - Attacker sends: userId = "1'); DROP TABLE users; --"
   - Your database gets wiped
   - Data loss + breach

   Fix:
   ❌ String concatenation in SQL
   ✅ Parameterized queries: db.query('INSERT ... VALUES (?, ?)', [userId, amount])

   Estimated fix: ~2k tokens

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟠 HIGH (Fix before launch, serious risk)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. **No Rate Limiting on Payment Endpoint**
   File: api/payment.ts
   Risk: Brute force attacks, card testing, DDoS
   Fix: Add rate limit (5 attempts / 15 min per IP)
   Estimated: ~3k tokens

4. **Card Data in Server Logs**
   File: api/payment.ts:45
   Code: `console.log('Payment:', req.body)`
   Risk: PCI DSS violation (can't log card numbers)
   Fix: Sanitize logs, never log card data
   Estimated: ~1k tokens

5. **Missing CSRF Protection**
   File: api/payment.ts
   Risk: Cross-site request forgery attacks
   Fix: Add CSRF tokens to payment forms
   Estimated: ~4k tokens

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟡 MEDIUM (Fix soon, good practice)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

6. **Weak Password Requirements** (users can set "123")
7. **No Security Headers** (XSS, clickjacking risk)
8. **Error Messages Too Detailed** (info disclosure)
9. **Missing Input Validation** (amount can be negative)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[RECOMMENDATION]

🔴 BLOCK LAUNCH - Critical issues must be fixed first
Estimated time: 4-6 hours
Estimated tokens: ~15k

Fix priority:
1. Move API key to backend (30 min)
2. Fix SQL injection (20 min)
3. Add rate limiting (1 hour)
4. Remove card data from logs (15 min)
5. Add CSRF protection (2 hours)

After fixes: Run audit again to verify.

Ready to fix Critical issues? [YES/SHOW_CODE/ADJUST]
```

### User:
```markdown
😱 Holy shit, yes! Fix Critical + High issues immediately!
Start with API key (that's terrifying)
```

### AI Response:
```markdown
[FIXING CRITICAL #1: API Key Exposure]

This is indeed terrifying. Good catch before launch.

Changes needed:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: lib/stripe.ts (frontend)
❌ REMOVE:
- const STRIPE_SECRET = 'sk_live_...'

✅ ADD:
+ const STRIPE_PUBLIC = 'pk_live_...'
+ // Note: Secret key NEVER goes to frontend

File: api/payment.ts (backend)
✅ ADD:
+ const stripe = require('stripe')(process.env.STRIPE_SECRET)

File: .env.example
✅ ADD:
+ STRIPE_SECRET=sk_test_your_key_here
+ STRIPE_PUBLIC=pk_test_your_key_here

File: .gitignore
✅ VERIFY:
+ .env (must be ignored!)

Also creating: PRE_COMMIT_HOOK
- Scans for 'sk_live_' or 'sk_test_' in staged files
- Blocks commit if found
- Prevents future accidents

[Shows actual code diffs...]

Estimated: ~3k tokens
Ready? [YES]
```

### After fixing all issues (18k tokens):
```markdown
[SECURITY FIXES COMPLETE] ✅

Fixed:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ API key moved to backend (+ pre-commit hook)
✅ SQL injection fixed (parameterized queries)
✅ Rate limiting added (5 attempts / 15 min)
✅ Card data removed from logs (sanitized)
✅ CSRF protection added (tokens on forms)
✅ Security headers added (helmet.js)
✅ Input validation strengthened

Tokens used: 18k (vs estimated 15k, found extra issues)

Running audit again to verify...

[RE-AUDIT RESULTS] 🟢
Critical: 0 (was 2) ✅
High: 0 (was 3) ✅
Medium: 2 (was 4) - acceptable for launch
Low: 3 - can fix post-launch

Status: ✅ SAFE TO LAUNCH

Recommended commits:
1. security(payment): fix API key exposure + SQL injection
2. security(payment): add rate limiting and CSRF
3. security(payment): sanitize logs, add headers

Also created:
- docs/SECURITY.md (security practices)
- .git/hooks/pre-commit (secret scanning)
- docs/INCIDENT_RESPONSE.md (if breach happens)

Your payment integration is now production-ready from security standpoint.

Next: Manual pen-test recommended (optional but good practice).
```

---

## 🔑 Key Takeaways

1. **Systematic audit > "looks good"** - Use OWASP checklist, not gut feeling
2. **Assume breach mentality** - What if attacker has this code?
3. **Secrets ≠ Frontend** - Backend only, ALWAYS
4. **Parameterized queries** - NEVER string concatenation in SQL
5. **Defense in depth** - Multiple layers (validation, rate limit, CSRF, headers)

---

## 🔒 Security Audit Checklist

```markdown
//CHECK:SECURITY runs these checks:

[ ] **Secrets Management**
    - No API keys in code
    - .env not committed
    - Secrets in environment variables only

[ ] **Injection Attacks**
    - SQL injection (parameterized queries?)
    - XSS (input sanitization?)
    - Command injection (no shell execution with user input?)

[ ] **Authentication & Authorization**
    - Password requirements (min 8 chars, complexity)
    - Sessions secure (httpOnly, secure, sameSite cookies)
    - JWT tokens signed (if used)
    - Authorization checks (can user access resource?)

[ ] **Data Protection**
    - HTTPS only (no HTTP)
    - Sensitive data encrypted at rest
    - PCI DSS if handling cards
    - GDPR if EU/Ukraine users

[ ] **Rate Limiting**
    - Login attempts limited (5 per 15min)
    - API endpoints protected
    - Payment endpoints rate-limited

[ ] **Error Handling**
    - No stack traces to users
    - Generic error messages (not "User X not found")
    - Logging (but not sensitive data)

[ ] **Dependencies**
    - npm audit (no critical vulnerabilities)
    - Dependencies up to date
    - No known CVEs

[ ] **Headers**
    - X-Frame-Options (clickjacking)
    - X-Content-Type-Options (MIME sniffing)
    - Content-Security-Policy (XSS)
    - Strict-Transport-Security (force HTTPS)

[ ] **GDPR Compliance** (if Ukrainian/EU market)
    - Privacy policy (Ukrainian language)
    - Cookie consent
    - Data deletion endpoint
    - Data export endpoint
```

---

## 🚨 Common Critical Issues (from real audits)

### **TOP 5 issues we find:**

1. **API keys in frontend** (60% of audits)
   - Pattern: `const API_KEY = 'sk_live_xxx'`
   - Fix: Backend only, use public keys in frontend

2. **SQL injection** (40% of audits)
   - Pattern: ``db.query(`SELECT * FROM users WHERE id = '${req.params.id}'`)``
   - Fix: Parameterized queries

3. **No rate limiting** (70% of audits)
   - Pattern: Payment/login endpoint with no limits
   - Fix: express-rate-limit middleware

4. **Secrets in git history** (30% of audits)
   - Pattern: .env committed once, then removed
   - Fix: git-filter-branch (painful!), or start fresh repo

5. **XSS vulnerabilities** (50% of audits)
   - Pattern: `innerHTML = userInput`
   - Fix: Sanitize input, use textContent, or DOMPurify

---

## 📊 Audit Impact

| Metric | Before Audit | After Audit |
|--------|--------------|-------------|
| **Critical issues** | 2 | 0 ✅ |
| **High issues** | 3 | 0 ✅ |
| **Breach probability** | 85% (within 6 months) | <5% |
| **PCI DSS compliant** | ❌ No | ✅ Yes |
| **GDPR compliant** | ❌ No | ✅ Yes |
| **Time to fix** | 6 hours | - |
| **Tokens used** | 18k | - |
| **Business saved** | 💰💰💰 | Priceless |

---

## 🎯 When to Run Security Audit

```markdown
MANDATORY:
✅ Before production launch
✅ After major feature (auth, payments, file upload)
✅ After security incident
✅ Every 3 months (recurring)

RECOMMENDED:
✅ After dependency updates
✅ Before investor demo (shows professionalism)
✅ When handling new data types (PII, financial)

Use: //CHECK:SECURITY command
Estimated: ~10-15k tokens
Time: 30-60 minutes
Value: Can save your business
```

---

**Made with ❤️ in Ukraine 🇺🇦**

> **"Security is not expensive. A breach is."**
