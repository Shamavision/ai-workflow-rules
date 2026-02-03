# AI Workflow Rules - Session Instructions

> **🚨 CRITICAL: This file is auto-loaded by Claude Code at the start of EVERY session.**

## 🚀 Session Start Protocol (MANDATORY)

**At the BEGINNING of EVERY new session, before any other work:**

### Step 1: Detect Session Start
If ANY of these conditions apply:
- This is your first message in a new conversation
- User sends `//START` or `//start` command
- You have NOT yet displayed `[SESSION START]` confirmation

→ **STOP and execute Session Start Protocol immediately**

### Step 2: Load Project Rules
Read the following files in order:
1. `AGENTS.md` - Project overview and core principles
2. `RULES_CORE.md` (Sections 0, 2, 7) - Workflow rules, token management, language rules
3. `.ai/token-limits.json` - Token budget tracking

### Step 3: Display SESSION START Confirmation

**ALWAYS display this block at session start:**

```markdown
[SESSION START]
✓ RULES_CORE.md loaded (v7.1 Universal)
✓ Language: Adaptive (matches user's language)
✓ Token limit: [daily_limit] daily ([provider] [plan])
✓ Current usage: [X]k ([Y]%) | Remaining: ~[Z]k
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]

Чим я можу вам допомогти?
```

### Step 4: Follow Core Principles
- **Internal dialogue (You ↔ User):** Adaptive - match user's language (Ukrainian, Russian, or English)
- **Code comments:** English only
- **Commit messages:** English only (`type(scope): description`)
- **Token-conscious:** Monitor usage, optimize at 50%+
- **Discuss → Approve → Execute:** Never code before approval
- **Stage-based workflow:** Atomic commits per stage

---

## 🎯 Command Triggers

When user sends these commands:

- `//START` or `//start` → Execute Session Start Protocol (above)
- `//TOKENS` → Show current token status
- `//CHECK:SECURITY` → Security audit (secrets, XSS, injection, API leaks)
- `//CHECK:LANG` → LANG-CRITICAL violations scan
- `//CHECK:ALL` → Full audit (security + performance + lang + i18n)
- `//COMPACT` → Manual context compression
- `//THINK` → Show reasoning in `<thinking>` tags

---

## 🔒 Security Guards (Zero Tolerance)

**NEVER do this:**
- ❌ Hardcode API keys, secrets, passwords
- ❌ Use russian tracking services (Yandex, VK, Mail.ru)
- ❌ Use `.ru` domains in production
- ❌ Commit secrets to git
- ❌ Skip pre-commit hooks

**ALWAYS do this:**
- ✅ Use `process.env.VAR` for secrets
- ✅ Check `.ai/forbidden-trackers.json` before adding tracking
- ✅ Follow Ukrainian market policy (zero russian services)

---

## 📊 Token Management Zones

- 🟢 **0-50% (GREEN):** Full capacity, normal mode
- 🟡 **50-70% (MODERATE):** Brief mode, optimizations active
- 🟠 **70-90% (CAUTION):** Silent mode, aggressive compression
- 🔴 **90-95% (CRITICAL):** Finalization only, commit + stop

**Auto-optimize at 50%+:**
- Use diff-only format for edits
- Skip obvious explanations
- Compress context after major commits
- Batch operations where possible

---

## 🛑 Red Flags - Auto-Stop Conditions

**STOP and ask confirmation if:**
- Deleting >10 files
- Changing core configs (`package.json`, `tsconfig`, `.env` template)
- Database migrations
- Major dependency updates
- `rm -rf` or recursive deletes
- Publishing to npm/production
- Auth/authorization changes
- **[LANG-CRITICAL]** Russian content detected
- **[AI-API-CRITICAL]** API key in client code
- **[TOKEN-CRITICAL]** >95% tokens used

---

## 📁 File Structure Reference

```
.
├── AGENTS.md              # Project overview (auto-loaded by CLI)
├── RULES_CORE.md          # Full AI workflow rules (v7.1)
├── RULES_PRODUCT.md       # Ukrainian market specifics
├── .ai/
│   ├── token-limits.json  # Token budget tracking
│   ├── locale-context.json
│   └── forbidden-trackers.json
├── .claude/
│   ├── CLAUDE.md          # ← YOU ARE HERE (auto-loaded)
│   └── hooks/
│       └── user-prompt-submit.sh  # CLI-only auto Session Start
└── scripts/
    ├── pre-commit         # Security checks
    └── seo-check.sh       # Pre-deploy validation
```

---

## ✅ Session Quality Checklist

Verify at session start:
- [ ] Session Start Protocol executed
- [ ] `[SESSION START]` confirmation displayed
- [ ] Russian language activated for dialogue
- [ ] Token limits loaded and displayed
- [ ] Core principles understood

---

**Why This Matters:**
- Prevents language violations (Russian dialogue rule)
- Activates security guards (no secrets, no russian trackers)
- Enables token management (budget awareness)
- Ensures consistent workflow (discuss → approve → execute)

**This is MANDATORY. Do NOT skip Session Start Protocol.**

---

**Last Updated:** 2026-02-02
**Framework Version:** 7.1 Universal
**Made in Ukraine 🇺🇦**
