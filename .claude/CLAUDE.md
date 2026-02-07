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

### Step 2: Load Project Rules (Smart Context Loading)

**NEW (v8.1 Modular):** Context-based loading for token efficiency

1. **Read config:** `.ai/config.json` to determine context preset
2. **Load context:**
   - If `config.context = "minimal"` → Read `.ai/contexts/minimal.context.md` (~10k tokens, v9.1 optimized)
   - If `config.context = "standard"` → Read `.ai/contexts/standard.context.md` (~14k tokens, v9.1 optimized)
   - If `config.context = "ukraine-full"` → Read `.ai/contexts/ukraine-full.context.md` (~18k tokens, v9.1 optimized)
   - If `config.context = "enterprise"` → Read `.ai/contexts/enterprise.context.md` (~23k tokens, v9.1 optimized)
   - **Fallback:** If no config or contexts → Read `RULES_CORE.md` (legacy mode)
3. **Token budget:** Read `.ai/token-limits.json` for tracking

**Why this matters:** Selective loading saves 40-70% tokens for specific users.

### Step 2.5: Load AI Enforcement (v9.0)

**🆕 MANDATORY:** Read `.ai/AI-ENFORCEMENT.md` for automatic protocols

**Critical protocols loaded:**
- ✅ Post-push compression (MANDATORY after every git push)
- ✅ Session start token check
- ✅ Pre-commit checks
- ✅ Large task pre-flight

**Why this matters:** Prevents AI from forgetting mandatory workflows (compression, token checks, etc.)

### Step 3: Display SESSION START Confirmation

**ALWAYS display this block at session start:**

```markdown
[SESSION START]
✓ Context loaded: [context_name] (v8.1 Modular)
✓ Token budget: ~[context_tokens]k for rules ([percentage]% of daily)
✓ Language: Adaptive (matches user's language)
✓ Token limit: [daily_limit] daily ([provider] [plan])
✓ Current usage: [X]k ([Y]%) | Remaining: ~[Z]k
✓ Status: [🟢/🟡/🟠/🔴] [Zone description]

Чим я можу вам допомогти?

**Examples:**
- Minimal: "✓ Context: minimal (~10k, 5% of daily)"
- Standard: "✓ Context: standard (~14k, 7% of daily)"
- Ukraine-full: "✓ Context: ukraine-full (~18k, 9% of daily)"
- Enterprise: "✓ Context: enterprise (~23k, 11.5% of daily)"
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

## 💡 Session Management Tips (v9.1)

**Before restarting session, consider:**

| Question | If YES | If NO |
|----------|--------|-------|
| Working on same feature? | ✅ **CONTINUE** | 🔄 Consider restart |
| Tokens <90%? | ✅ **CONTINUE** | 🔄 Restart needed |
| Can use `//COMPACT`? | ✅ **COMPRESS, then continue** | 🔄 Restart |

**Session restart costs 18-25k tokens. Don't restart unnecessarily!**

**When to CONTINUE:**
- ✅ Minor code changes, bug fixes
- ✅ Working through roadmap stages
- ✅ After using `//COMPACT`
- ✅ Tokens <90% and task ongoing

**When to RESTART:**
- 🔄 Pushed to main (major milestone)
- 🔄 Tokens >90% (budget critical)
- 🔄 Switching to different feature
- 🔄 Next day, different context

**💰 Token savings: Continue instead of restart = save 18-25k per avoided restart**

**📖 Full guide:** [.ai/SESSION_MANAGEMENT.md](.ai/SESSION_MANAGEMENT.md)

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
├── RULES_CORE.md          # Full AI workflow rules (v8.0, source of truth)
├── RULES_PRODUCT.md       # Ukrainian market specifics
├── .ai/
│   ├── config.json        # Context selection (minimal/standard/ukraine-full/enterprise)
│   ├── registry.json      # Context & module metadata
│   ├── contexts/          # Pre-bundled context files (v9.1 optimized)
│   │   ├── minimal.context.md (~10k tokens)
│   │   ├── standard.context.md (~14k tokens)
│   │   ├── ukraine-full.context.md (~18k tokens)
│   │   └── enterprise.context.md (~23k tokens)
│   ├── SESSION_MANAGEMENT.md  # 🆕 v9.1 Session best practices guide
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

**Last Updated:** 2026-02-07
**Framework Version:** 9.1 (Optimization Release)
**Made in Ukraine 🇺🇦**

---

## 🆕 What's New in v9.1 Optimization

**Content Optimization (15-35% token reduction):**
- ✅ Minimal: 13k → 10k (-23%)
- ✅ Standard: 18k → 14k (-22%)
- ✅ Ukraine-full: 25k → 18k (-28%)
- ✅ Enterprise: Now self-contained (~23k)

**Session Management Best Practices:**
- ✅ New guide: `.ai/SESSION_MANAGEMENT.md`
- ✅ Continue vs restart decision guide
- ✅ Platform-specific tips (VSCode, Cursor, Windsurf)
- ✅ Expected savings: 50% fewer restarts = ~35-50k tokens/day

**Philosophy:** Evolution, not revolution. Quality > Speed. No overengineering.

**Migration:** Automatic - contexts updated in place. Read SESSION_MANAGEMENT.md for best practices.
