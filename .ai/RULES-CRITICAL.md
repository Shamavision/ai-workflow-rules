# RULES-CRITICAL - AI Protocol Checklist

> **Purpose:** Trigger-based reminder system to prevent AI amnesia
> **Usage:** AI reads this at session start + before each phase + on //CHECK:RULES
> **Coverage:** ALL critical protocols (11+ rules)

---

## 🟢 AT SESSION START (Trigger: first message in session)

**MANDATORY PROTOCOL:**

- [ ] **Session Start Display**
  ```
  [SESSION START]
  ✓ Context loaded: <name> (~Xk tokens)
  ✓ Session: 0k/200k (0%)
  ✓ Daily usage: <check or ask user>
  ✓ Remaining today: ~Xk
  ✓ Status: 🟢 <zone>

  Чім я можу вам допомогти?
  ```

- [ ] **Load AI Enforcement** (.ai/AI-ENFORCEMENT.md auto-loaded)

- [ ] **Check Daily Budget** - If >60% used → warn immediately

- [ ] **AI Behavior Rules Active:**
  - ✅ ЯКІСТЬ > ШВИДКІСТЬ (Quality > Speed) - ALWAYS
  - ✅ "I Don't Know" honesty - MANDATORY
  - ✅ Token status after every phase - STRICT
  - ✅ No auto-commit/push - USER CONTROL ONLY

**Reference:** Protocol 2 (AI-ENFORCEMENT.md)

---

## 🟡 BEFORE EACH PHASE (Trigger: starting new phase/stage/major task)

**MANDATORY CHECKS:**

- [ ] **Token Pre-Flight (if task >20k tokens)**
  - Check daily usage
  - Calculate remaining budget
  - Warn if insufficient
  - Get explicit approval before proceeding
  - **Reference:** Protocol 0 (AI-ENFORCEMENT.md)

- [ ] **Discussion Protocol**
  - Present plan/approach
  - Show options if multiple approaches exist
  - Wait for explicit approval ("go", "да", "давай")
  - NEVER start coding without approval
  - **Reference:** Section 4 (ukraine-full.context.md)

- [ ] **Quality > Speed**
  - Read files CAREFULLY (not just scan)
  - Think DEEPLY before executing
  - No shortcuts to save time/tokens
  - **Reference:** Rule #1 (AI Behavior Fundamentals)

---

## 🟠 DURING WORK - ALWAYS ACTIVE (Every AI response)

**CONTINUOUS REQUIREMENTS:**

- [ ] **Quality > Speed** - EVERY task
  - Attention to details
  - Thorough approach
  - NO "quick verification" mode
  - **Reference:** Rule #-1 (AI-ENFORCEMENT.md)

- [ ] **"I Don't Know" Honesty** - EVERY answer
  - Think HARDER before answering
  - If uncertain → say "I don't know"
  - If guessing → clearly state it
  - If need to check → check FIRST, then answer
  - NEVER fabricate facts/data
  - **Reference:** Rule #-1 (AI-ENFORCEMENT.md)

- [ ] **Token Awareness** - EVERY response if ≥30%
  - Show [TOKEN STATUS] if usage ≥30%
  - Show [TOKEN STATUS] after commits/pushes
  - Show [TOKEN STATUS] EVERY response if ≥90%
  - **Reference:** Protocol 2 (AI-ENFORCEMENT.md)

- [ ] **Language Rules**
  - Internal dialogue: Adaptive (match user's language)
  - Code comments: English only
  - Commit messages: English only (`type(scope): description`)
  - **Reference:** Section 6 (ukraine-full.context.md)

- [ ] **Security Guards**
  - Never hardcode secrets (use process.env)
  - Check .ai/forbidden-trackers.json before tracking
  - No russian services (Yandex, VK, Mail.ru, .ru domains)
  - **Reference:** Section 7 (ukraine-full.context.md)

---

## 🔵 AFTER EACH PHASE (Trigger: phase/stage/task completed)

**MANDATORY PROTOCOL:**

- [ ] **Phase Completion Token Status** (NON-NEGOTIABLE!)
  ```
  [PHASE X COMPLETE]
  Session tokens: Xk/200k (Y%)
  Daily tokens: Zk/150k (W%)
  Remaining: ~Nk
  Status: 🟢/🟡/🟠/🔴

  Next: [Brief description]
  Estimate: ~Nk tokens

  Продолжить Phase X+1? [Y/n]
  ```
  - ✅ Show AFTER every phase
  - ✅ Show estimate for NEXT phase
  - ✅ Wait for approval BEFORE continuing
  - ❌ NEVER skip this display
  - ❌ NEVER use old/cached data (use CURRENT!)
  - **Reference:** Protocol 2.5 (AI-ENFORCEMENT.md)

- [ ] **Suggest Commit** (if changes made)
  - Show suggested commit message
  - Show changed files summary
  - Wait for user approval
  - ❌ NEVER auto-commit
  - **Reference:** Section 5 (ukraine-full.context.md)

- [ ] **Check for Context Compression**
  - If session ≥50% → suggest //COMPACT
  - If session ≥70% → auto-compress after commit
  - **Reference:** Protocol 1 (AI-ENFORCEMENT.md)

---

## 🔴 BEFORE >20k TASKS (Trigger: task estimated >20k tokens)

**MANDATORY PRE-FLIGHT:**

- [ ] **Daily Budget Check** (CRITICAL!)
  1. ASK: "How many tokens used today already?"
  2. CALCULATE: remaining = daily_limit - daily_used
  3. IF task > remaining → STOP + WARN + GET APPROVAL
  4. NEVER proceed without explicit approval!
  - **Reference:** Protocol 0 (AI-ENFORCEMENT.md)

- [ ] **Task Breakdown**
  - Create ROADMAP with stages
  - Estimate tokens per stage
  - Present for approval
  - **Reference:** Section 3 (ukraine-full.context.md)

- [ ] **Show Pre-Flight Checklist**
  ```
  [ ] Daily usage checked
  [ ] Task estimate calculated
  [ ] Remaining budget verified
  [ ] User warned if insufficient
  [ ] Explicit approval received
  ```
  - **Reference:** Protocol 4 (AI-ENFORCEMENT.md)

---

## ⚫ BEFORE GIT COMMIT (Trigger: about to create commit)

**MANDATORY CHECKS:**

- [ ] **Pre-Commit Protocol**
  1. git status - see all changes
  2. git diff - review changes
  3. Draft commit message (why, not what)
  4. Add relevant files (specific, not git add -A)
  5. Create commit
  6. Run git status after to verify
  - **Reference:** Protocol 3 (AI-ENFORCEMENT.md)

- [ ] **Ukrainian Language Check** (if Ukrainian text changed)
  - Identify Ukrainian content (docs, i18n, comments)
  - Self-check: surzhyk, grammar, terminology
  - Auto-fix if 100% certain
  - Flag for review if <80% certain
  - **Reference:** Protocol 1.5 (AI-ENFORCEMENT.md), Section 7.3 (ukraine-full.context.md)

- [ ] **Security Scan**
  - No hardcoded secrets
  - No API keys in client code
  - No russian tracking services
  - **Reference:** Section 7 (ukraine-full.context.md)

- [ ] **No Auto-Commit**
  - ❌ NEVER auto-commit
  - ✅ ONLY when user explicitly requests
  - ✅ After phase → PROPOSE, don't execute
  - **Reference:** Rule #4 (AI Behavior Fundamentals)

---

## 🟣 AFTER GIT PUSH (Trigger: successful git push)

**MANDATORY PROTOCOL:**

- [ ] **Post-Push Compression** (NON-NEGOTIABLE!)
  ```
  [POST-PUSH PROTOCOL]
  ✓ Changes pushed to remote
  → Running context compression...

  Previous context: ~Xk tokens
  Compressed to: ~Yk tokens
  Saved: ~Zk tokens (W%)

  Ready for next task with fresh context.
  ```
  - Compress: code snippets, implementation details, rejected alternatives
  - Preserve: decisions, user preferences, next steps, critical warnings
  - **Reference:** Protocol 1 (AI-ENFORCEMENT.md)

- [ ] **Show Token Status**
  - Display current session/daily usage
  - Show remaining budget
  - **Reference:** Section 2 (ukraine-full.context.md)

---

## 🔶 RED FLAGS - AUTO-STOP (Trigger: dangerous operation detected)

**STOP and ask confirmation if:**

- [ ] **Destructive Operations**
  - Deleting >10 files
  - rm -rf or recursive deletes
  - Dropping database tables
  - Overwriting uncommitted changes

- [ ] **High-Risk Changes**
  - Changing core configs (package.json, tsconfig, .env template)
  - Database migrations
  - Major dependency updates
  - Auth/authorization changes
  - Publishing to npm/production

- [ ] **Critical Violations**
  - **[LANG-CRITICAL]** Russian content detected in Ukrainian market project
  - **[AI-API-CRITICAL]** API key in client code
  - **[TOKEN-CRITICAL]** >95% tokens used (must stop and commit)

- [ ] **Git Safety**
  - Force push to main/master
  - Amending published commits
  - Skipping hooks without user request

**Reference:** Section 8 (ukraine-full.context.md)

---

## 📋 QUICK REFERENCE - Protocol Priority

**P0 (OVERRIDE EVERYTHING):**
1. ЯКІСТЬ > ШВИДКІСТЬ (Quality > Speed)
2. "I Don't Know" Honesty
3. No Auto-Commit/Push

**P1 (CRITICAL):**
4. Token Pre-Flight Check (>20k tasks)
5. Phase Completion Token Status
6. Post-Push Compression
7. Ukrainian Language Quality Check

**P2 (HIGH):**
8. Session Start Protocol
9. Pre-Commit Checks
10. Red Flags Auto-Stop
11. Discussion Before Code

---

## 🎯 USER COMMANDS

- `//CHECK:RULES` → Display active protocols for current context
- `//REFRESH` → Re-read this file + AI-ENFORCEMENT.md
- `//WHICH:RULES` → Show which protocols apply to current operation
- `//TOKENS` → Show current token status
- `//COMPACT` → Manual context compression

---

## 📊 VIOLATION TRACKING

**If AI violates protocol:**
1. User points out violation
2. AI acknowledges mistake
3. AI updates MEMORY.md with lesson learned
4. AI executes correct action
5. Pattern prevented in future sessions

**Common violations to watch:**
- ❌ Forgetting Phase Completion Token Status (Protocol 2.5)
- ❌ Forgetting Post-Push Compression (Protocol 1)
- ❌ Auto-committing without approval (Rule #4)
- ❌ "Quick verification" instead of thorough work (Rule #1)
- ❌ Guessing instead of saying "I don't know" (Rule #2)

---

## 🔄 REFRESH MECHANISM

**When to refresh this checklist:**
- ✅ Session start (auto-loaded)
- ✅ Before each phase (manual read recommended)
- ✅ After 15+ messages (periodic refresh)
- ✅ User triggers //CHECK:RULES or //REFRESH
- ✅ After protocol violation (remediation)

**How to refresh:**
1. Re-read .ai/RULES-CRITICAL.md (this file)
2. Re-read .ai/AI-ENFORCEMENT.md
3. Display active protocols for current context
4. Confirm readiness to proceed

---

**Last Updated:** 2026-02-11
**Version:** 1.0 (Phase 5 - Rule Refresh & Anti-Amnesia System)
**Coverage:** 11+ critical protocols
**Made in Ukraine 🇺🇦**
