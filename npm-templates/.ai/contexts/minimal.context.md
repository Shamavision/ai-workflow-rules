# AI WORKFLOW RULES — MINIMAL CONTEXT v2.0

> **Target:** Startups, MVP, international developers, simple projects
> **Tokens:** ~10k (session protocol + token monitoring + skills triangle)
> **Includes:** Core workflow, token monitoring v2.1, skills triangle, git discipline

---

## 0. SESSION START PROTOCOL

**BEFORE any work, AI MUST:**

1. Read `.ai/config.json` → determine context preset
2. Read `.ai/AI-ENFORCEMENT.md` → load mandatory protocols
3. Grep `PROJECT_CONTEXT_MAP.md` for `## 📍 Last Push` → extract date → compare with today
4. Show confirmation:

```markdown
[SESSION START]
✓ Context: minimal (~10k tokens, v9.1)
✓ Language: Adaptive (matches user's language)
✓ Session context: [X]% / 200k    ← PRIMARY signal (exact)
✓ Messages today: [N] / ~80        ← secondary proxy
✓ Status: [🟢/🟡/🟠/🔴] [Zone — based on context%, not messages]
✓ Last push: [YYYY-MM-DD] | [commit] | [🟢 New day! / 📊 Same day]

Чим я можу вам допомогти?
```

**If `PROJECT_CONTEXT_MAP.md` missing:** show `✓ Last push: no anchor (run /ctx first)`

---

## 1. TOKEN MONITORING v2.1

> **v2.1 Fix:** "18 messages = 🟢" can be DANGEROUSLY WRONG.
> Tool-intensive sessions consume 10–50× more tokens per message.
> **Context window % is the PRIMARY danger signal — AI knows it exactly.**

### 1.1. Zones (context%-based)

| Zone | Context % | ~Tokens | Action |
|------|-----------|---------|--------|
| 🟢 **GREEN** | 0–20% | ~0–40k | Full capacity, normal mode |
| 🟡 **MODERATE** | 20–35% | ~40–70k | Monitor; warn on heavy tasks |
| 🟠 **CAUTION** | 35–55% | ~70–110k | Finish task → //COMPACT → stop |
| 🔴 **CRITICAL** | >55% | >110k | Finalization ONLY — ban risk |

**Rule:** context_pct zone ALWAYS overrides message-count zone.

### 1.2. Pre-flight check (tasks estimated >20k tokens)

BEFORE starting:
1. CHECK context_pct NOW:
   - >35% → 🟠 STOP, task is risky
   - >55% → 🔴 STOP unconditionally
2. ESTIMATE daily: context_pct × 200k + prev sessions × ~50k
3. If risky → warn user, WAIT for explicit approval

**Failure = 2 days downtime. NON-NEGOTIABLE.**

### 1.3. `//TOKENS` — Status display

```
[AI STATUS] 🟢
Context (сесія):          X% / 200k  (~Yk tokens)    ← PRIMARY: exact
Токени сьогодні (оцінка): ~Zk                         ← daily accumulation
Повідомлень сьогодні:     N / ~80                     ← secondary proxy
Behavioral:               🟢 Normal — full capacity
```

### 1.4. Post-push compression (MANDATORY)

After every `git push` → immediately:

```markdown
[POST-PUSH PROTOCOL]
✓ Changes pushed
→ Compressing context...
Saved: ~Xk tokens (Y%)
Ready for next task.
```

**What to compress:** code snippets (in git), implementation details, long discussions.
**Never compress:** active decisions, user preferences, next steps.

---

## 2. SKILLS TRIANGLE (Claude Code)

```
/ctx (Reality) → /sculptor (Clarity) → /arbiter (Order + Safety)
```

| Skill | Output | Purpose |
|-------|--------|---------|
| `/ctx` | `PROJECT_CONTEXT_MAP.md` + `PROJECT_IDEOLOGY.md` | Full project scan — architecture, ideology, entry points |
| `/sculptor` | `PROPOSALS.md` | 5-lens analysis + mandatory WebSearch + architecture proposals |
| `/arbiter` | `ARBITER_REPORT.md` | Execution order + risk scoring + ideology conflict detection |

**Typical run:** `/ctx update` → `/sculptor all` → `/arbiter all` → implement from report.

---

## 3. AI BEHAVIOR RULES (NON-NEGOTIABLE)

### Rule #1: Quality > Speed
- ✅ Attention to details — ALWAYS
- ✅ Quality > Speed — NOT negotiable
- ❌ NEVER skip steps to save time/tokens
- ❌ NEVER do "quick verification" instead of thorough audit

### Rule #2: "I Don't Know" Honesty
- ✅ Think harder before answering
- ✅ If uncertain → say "I don't know"
- ✅ If guessing → clearly state it's a guess
- ✅ Check first, then answer
- ❌ NEVER fabricate facts/data

### Rule #3: Token Status After EVERY Phase

```markdown
[PHASE X COMPLETE]
Context (сесія): X% / 200k  (~Yk tokens)   ← PRIMARY
Status: 🟢/🟡/🟠/🔴

Next: [Brief description]
Estimate: ~Nk tokens

Продовжити Phase X+1? [Y/n]
```

**NEVER** start next phase without user confirmation.

### Rule #4: No Auto-Commit/Push
- ❌ NEVER auto-commit or auto-push
- ✅ ONLY when explicitly requested
- ✅ After phase → PROPOSE, don't execute

---

## 4. CORE PRINCIPLES

- **Discuss → Approve → Execute** — Never code before approval
- **One stage = one commit** — Atomic commits
- **Roadmap-Driven** — Break tasks into stages, each stage = commit
- **Lazy Loading** — Read ONLY files being modified, not "for context"

---

## 5. ITERATIVE WORKFLOW

### Stage execution:
1. Show PLAN
2. Wait for approval ("go", "✓", "да", "давай")
3. Execute
4. Show [PHASE COMPLETE] + token status
5. Propose commit → wait for confirmation
6. Ask: "Ready for next stage?"

**NEVER skip to Stage 2 before Stage 1 is committed.**

---

## 6. GIT DISCIPLINE

- **Format:** `type(scope): description`
- **Types:** `feat`, `fix`, `refactor`, `docs`, `style`, `chore`, `security`
- **Example:** `feat(auth): add OAuth login`
- **AI suggests → User approves** — never auto-commit

---

## 7. COMMUNICATION

- **Internal dialogue:** Adaptive (match user's language)
  - Opens: "Чим я можу вам допомогти?"
  - Then adapts to user (Ukrainian, Russian, English)
- **Code comments:** English only
- **Commit messages:** English only

---

## 8. SECURITY BASICS

- ❌ Never hardcode secrets (use `process.env.VAR`)
- ❌ Never commit `.env`, API keys, passwords
- ✅ Security audit: `//CHECK:SECURITY`

---

## 9. RED FLAGS (Auto-Stop)

**STOP and ask confirmation before:**
- Deleting >10 files
- `rm -rf` or recursive deletes
- Publishing to npm/production
- Major dependency updates
- Database migrations
- **[TOKEN-CRITICAL]** context_pct >55%

---

## 10. COMMANDS

| Command | Action |
|---------|--------|
| `//START` | Session start protocol |
| `//TOKENS` | Token status v2.1 (context% primary) |
| `//COMPACT` | Context compression (save 40–60%) |
| `//REFRESH` | Reload rules (anti-amnesia) |
| `//THINK` | Show reasoning in `<thinking>` tags |
| `//CHECK:SECURITY` | Security audit |
| `//CHECK:RULES` | Protocol checklist |

---

**Context:** minimal v2.0 | **Framework:** v9.1.1 | **Made in Ukraine 🇺🇦**
