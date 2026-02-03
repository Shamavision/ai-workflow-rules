# Dialog Example: Bug Investigation & Debugging

## 📋 Context
Task: "Users can't upload files, getting 500 error"
Impact: 200+ support tickets in 2 hours
Pressure: HIGH (production is down)
Developer state: Panicking 😱

---

## ❌ Bad Approach (Panic Mode)

```markdown
User: "FILE UPLOAD BROKEN! Fix ASAP!!!"

AI: "Let me check the upload component..."
[Reads 5 random files, 15k tokens]
AI: "Try this fix..." [suggests random code change]

User: [applies fix] "Still broken!"

AI: "Maybe it's the API..." [reads more files, 10k tokens]
AI: "Try this..." [another random fix]

User: "STILL BROKEN! What's happening?!"

Result:
- 2 hours wasted
- 40k tokens burned
- Bug still not found
- Random code changes made (now even more broken)
- Pressure mounting, client calling
```

**Why it failed:** No methodology, guessing, no systematic investigation.

---

## ✅ Good Approach (Professional Debugging)

### User's First Message:
```markdown
//START
PRODUCTION ISSUE

Symptom: File upload returns 500 error
When: Started ~2 hours ago (was working yesterday)
Frequency: 100% of upload attempts fail
Impact: 200+ tickets, blocking users
Recent changes: Deployed v2.4.3 this morning

Error from browser console:
POST /api/upload 500 (Internal Server Error)

Need help debugging systematically.
```

### AI Response:
```markdown
[BUG INVESTIGATION PROTOCOL]

Got it. Let's debug methodically, not randomly.

Step 1: GATHER DATA (before touching code)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Need answers (from logs/monitoring):

1. **Server logs** - What's the actual error?
   - Check: CloudWatch, Sentry, or console logs
   - Look for: Stack trace, error message

2. **What changed** - What's in v2.4.3 deployment?
   - Run: git diff v2.4.2..v2.4.3
   - Focus: Files related to upload

3. **Environment** - Is it all environments or just production?
   - Test: Staging/dev upload works?

4. **Scope** - All file types or specific ones?
   - Test: Small file vs large file

📋 Before I read ANY code, get me:
- Server error message (exact text)
- Git diff of deployment
- Staging upload test result

This saves us from reading wrong files (waste tokens).
```

### User:
```markdown
Server error: "TypeError: Cannot read property 'mimetype' of undefined"
Git diff: Changed multer config in api/upload.ts
Staging: Works fine
Scope: All files fail in production
```

### AI Response:
```markdown
[DIAGNOSIS]

Pattern identified: "undefined" + "staging works" + "multer config change"

Hypothesis: Environment-specific config issue

Most likely causes (ordered by probability):
1. 🔴 **ENV variable missing in production** (80% probability)
   - multer needs UPLOAD_PATH or similar
   - Staging has it, production doesn't

2. 🟡 **File permissions** (15% probability)
   - Production folder not writable

3. 🟢 **Deployment artifact issue** (5% probability)
   - Build failed partially

Next action: Check production ENV variables
Run: `env | grep UPLOAD` on production server

(This takes 30 seconds vs 20k tokens reading code randomly)
```

### User:
```markdown
Checked ENV... UPLOAD_MAX_SIZE is there but UPLOAD_DIR is missing!
In staging: UPLOAD_DIR=/tmp/uploads (exists)
In production: UPLOAD_DIR= (empty!)
```

### AI Response:
```markdown
[ROOT CAUSE FOUND] 🎯

Issue: UPLOAD_DIR environment variable missing in production

Why it broke:
- v2.4.3 changed multer config to use process.env.UPLOAD_DIR
- No fallback value
- TypeError because multer config is undefined

Evidence:
✅ Staging has UPLOAD_DIR → works
✅ Production missing UPLOAD_DIR → fails
✅ Error says "undefined" → confirms missing config

Fix (2 parts):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IMMEDIATE (stop bleeding):
1. Add UPLOAD_DIR to production ENV
2. Restart service
3. Test upload
Time: 5 minutes

PERMANENT (prevent recurrence):
1. Add fallback in code: UPLOAD_DIR || '/tmp/uploads'
2. Add ENV validation on startup
3. Update deployment checklist
Time: 20 minutes

Want me to write the permanent fix code? [YES/NO]
```

### User:
```markdown
Added ENV var, restarted - IT WORKS! 🎉
Yes, write permanent fix.
```

### AI Response:
```markdown
[PERMANENT FIX]

File: api/upload.ts

Changes:
1. Add fallback value
2. Add startup validation
3. Better error message

[Shows code with diff-only format]

Also creating: DEPLOYMENT_CHECKLIST.md
- ENV variables validation step
- Prevents this class of issues

Suggested commit:
fix(upload): add ENV fallback and validation

Prevents 500 error when UPLOAD_DIR missing.
Root cause: Production ENV not synced with staging.
Prevention: Startup validation + fallback value.

Estimated: ~3k tokens
Ready? [YES]
```

### Result:
```markdown
[INCIDENT RESOLVED] ✅

Timeline:
- 00:00 - Bug reported
- 00:05 - Systematic data gathering
- 00:10 - Root cause identified (ENV missing)
- 00:15 - Immediate fix deployed
- 00:35 - Permanent fix committed

Metrics:
- Time to fix: 35 minutes (vs 2+ hours guessing)
- Tokens used: ~5k (vs 40k random exploration)
- Code changes: 1 file, 10 lines (vs random fixes everywhere)
- Prevention: Added validation (won't happen again)

Post-mortem:
- Why missed in staging: ENV variables not synced
- Action item: Add ENV sync check to CI/CD
```

---

## 🔑 Key Takeaways

1. **Data BEFORE code** - Logs/errors tell you where to look
2. **Methodology > Panic** - Systematic investigation saves time
3. **Hypothesis-driven** - Form theory, test, adjust (not guess randomly)
4. **Environment diff** - "Works in staging" = compare environments
5. **Fix + Prevent** - Stop bleeding, then add guardrails

---

## 🧪 Debugging Methodology (Checklist)

```markdown
BEFORE reading code:
[ ] What's the exact error message?
[ ] When did it start? (timing = clues)
[ ] What changed recently? (git diff)
[ ] Can you reproduce? (local/staging/production)
[ ] Is it consistent or intermittent?

THEN form hypothesis:
[ ] Based on error + changes + environment
[ ] List 2-3 most likely causes (prioritized)
[ ] Test hypothesis (cheapest test first)

ONLY THEN read code:
[ ] Read files related to hypothesis
[ ] Not random exploration
[ ] Targeted investigation

AFTER fix:
[ ] Test the fix works
[ ] Add prevention (validation, tests)
[ ] Document root cause
[ ] Update runbooks
```

---

## 🚨 Anti-Patterns (Don't Do This)

❌ **Random code exploration** - "Let me read all upload-related files"
✅ **Targeted investigation** - "Show me the error, I'll tell you what to read"

❌ **Guess-and-check fixes** - "Try this... no? Try this..."
✅ **Hypothesis-driven** - "Based on error X, likely cause is Y, let's test"

❌ **Fix without prevention** - "Changed the code, it works now"
✅ **Fix + prevent** - "Fixed + added validation so it can't happen again"

---

## 📊 Comparison

| Approach | Time to Fix | Tokens Used | Code Changes | Prevention |
|----------|-------------|-------------|--------------|------------|
| **Panic mode** | 2+ hours | 40k+ | Random (risky) | None |
| **Systematic** | 35 min | 5k | Targeted | Yes |

---

**Made with ❤️ in Ukraine 🇺🇦**
