# PROJECT IDEOLOGY
> Created by `/ctx` on 2026-02-23.
> Append-only. Update with `/ctx update` or `/ctx ideology` — never overwrite.
> This document captures WHY the project exists and the decisions that define it.

---

## [v1.0] 2026-02-23 — Initial Ideology Capture

### WHY — Core Purpose

AI tools (Claude Code, Cursor) are market-agnostic by default — they don't know about Ukrainian compliance requirements, don't guard against Russian tracking services, and don't enforce token discipline. Ukrainian developers have to configure this manually every time, or skip it entirely.

This project exists to make the right defaults automatic: **install once, get a compliant, disciplined AI workflow immediately.** No configuration. No opt-outs. No Russian trackers. No token burnout.

---

### WHO — Primary User

Ukrainian developers and small Ukrainian studios (2-5 people) who use Claude Code and/or Cursor professionally. They build products for the Ukrainian market, care deeply about compliance with Ukrainian digital standards (no Russian services), and want their AI assistant to work with discipline — not just answer questions, but follow a structured workflow: understand → analyze → plan → execute.

They are not enterprise. They don't want documentation. They want it to work.

---

### PRODUCT — What It Delivers (Concrete)

**After `npx @shamavision/ai-workflow-rules` (2 minutes to full protection):**

**AI rules files (auto-generated from selected context):**
- `.claude/CLAUDE.md` — session protocol, token tracking, behavior rules (Claude Code)
- `.cursor/rules/ai-workflow.mdc` — YAML frontmatter + rules (Cursor ≥0.45)
- `.cursorrules` — full rules (Cursor legacy <0.45)
- `AGENTS.md` — universal entry point for any AI with `//START` command

**Skills triangle (Claude Code):**
- `/ctx` → generates `PROJECT_CONTEXT_MAP.md` + `PROJECT_IDEOLOGY.md` (this file)
- `/sculptor` → generates `PROPOSALS.md` (5-lens architectural analysis + mandatory WebSearch)
- `/arbiter` → generates `ARBITER_REPORT.md` (execution order + risk scoring + ideology conflicts)

**Security layer (always automatic):**
- Pre-commit hook: blocks secrets, PII, Russian services before every commit
- LANG-CRITICAL: 40+ patterns (Yandex, VK, Mail.ru, `.ru` domains)
- Prompt injection detection + PII protection (GDPR-ready)

**Session discipline (always automatic):**
- Post-push hook: context compression + session anchor update
- Token tracking zones: 🟢 0-50% → 🟡 50-70% → 🟠 70-90% → 🔴 90-95%
- Daily limit awareness + new-day detection via `PROJECT_CONTEXT_MAP.md` anchor

**Commands available after installation:**
`//START` · `//TOKENS` · `//COMPACT` · `//REFRESH` · `//CHECK:SECURITY` · `//CHECK:LANG` · `//CHECK:ALL`

---

### PRINCIPLES — Non-Negotiable Rules

1. **Opinionated by default** — no opt-outs, no "configure it yourself". The product knows what Ukrainian developers need.
2. **Quality > Speed** — always. Every proposal, every change, every audit must be thorough. Rushing is a bug.
3. **Less is more (YAGNI)** — remove more than you add. Every file must earn its place.
4. **Zero Russian services** — no Yandex, VK, Mail.ru, no `.ru` domains. Zero tolerance, zero exceptions.
5. **Honest AI** — think harder before answering. "I don't know" is a valid and professional answer. Never fabricate.
6. **Session discipline** — track tokens, respect daily limits, compress context after every push.

---

### ANTI-GOALS — What This Project Is NOT

1. **Not a generic/global tool** — intentionally Ukrainian-market-focused. Not for everyone.
2. **Not opt-in** — not "enable what you want". Defaults are mandatory, not suggestions.
3. **Not enterprise-first** — simple, small-team focused. No RBAC, no compliance dashboards, no onboarding flows.
4. **Not a plugin ecosystem** — no extension points added for hypothetical future use cases. YAGNI.
5. **Not documentation-heavy** — every file must justify its existence. README exists to install, not to impress.

---

### DECISIONS — Architectural Choices Locked In

- **Decision:** Dual-structure (`dev/` ↔ `npm-templates/`)
  **Rationale:** The installer distributes `npm-templates/`; `dev/` is the source of truth. Keeps distributable clean and predictable.
  **Alternatives rejected:** Monorepo (overkill), single directory (no clean separation).

- **Decision:** 2 context presets only (`minimal` + `ukraine-full`)
  **Rationale:** `standard` and `enterprise` presets added complexity without proportional value. Removed in Task 4.
  **Alternatives rejected:** 4 presets (too many choices), 1 preset (not enough flexibility).

- **Decision:** 3-question installer wizard (`provider → plan → market`)
  **Rationale:** Simplified from 8 questions — most decisions (hooks, gitignore, product rules) should be automatic based on market.
  **Alternatives rejected:** 8+ questions (friction, fatigue), 1 question (not enough context).

- **Decision:** Skills triangle (`/ctx → /sculptor → /arbiter`)
  **Rationale:** Structured thinking beats ad-hoc AI prompting. Three focused roles: understand reality, gain clarity, ensure safe execution order.
  **Alternatives rejected:** Single mega-skill (too many responsibilities), no skills (just rules files).

- **Decision:** `PROJECT_IDEOLOGY.md` as append-only soul document
  **Rationale:** The WHY of a project changes slowly and accumulates. Overwriting loses history; append-only preserves the decision trail.
  **Alternatives rejected:** Version-controlled separate files (over-engineered), no ideology capture (loses context between sessions).

- **Decision:** No PowerShell installer (Task 11 cancelled)
  **Rationale:** `npx @shamavision/ai-workflow-rules` works cross-platform. Git Bash covers bash on Windows. Maintaining 3 installers violates "less is more".
  **Alternatives rejected:** PowerShell installer (YAGNI — npx covers the gap).

---

### VISION — Where This Is Going (2026+)

When a Ukrainian developer runs `npx @shamavision/ai-workflow-rules`, within 2 minutes they have: workflow rules for Claude Code + Cursor, security against Russian tracking, token discipline, and the full skills triangle ready to use (`/ctx → /sculptor → /arbiter`).

The final form: a developer opens a new project, runs the installer, then runs `/ctx` — and immediately has a grounded understanding of their project's structure, ideology, and next steps. The AI becomes a structured thinking partner, not a code autocomplete.

**Done looks like:** no README needed to start, no configuration required, no Russian service slips through.

---

### MARKET CONTEXT (from WebSearch 2026-02-23)

**Query:** `"AI workflow rules framework npx CLI 2026 best practices"`

The 2026 AI coding tools landscape is converging on:
- **Agent skills / rules packages** — tools like `agent-rules` (CLI for unified governance across Copilot/Cursor/Claude), Vercel's `agent-skills` (npx-based skills package manager), `@ai-coders/context` (PREVC process). The "npx install + rules files" pattern is validated as an industry approach.
- **Quality gates are becoming standard** — AI-on-AI code reviews, more tests, more monitoring. This project's "Quality > Speed" principle aligns with industry direction.
- **Cursor crossed $500M ARR** in 2025 — `.cursor/rules/*.mdc` format (≥0.45) is now the standard. Our Task 12 migration was timely.
- **Skills/agents pattern growing** — Cursor introduced agent sub-skills by late 2025. Our `/ctx → /sculptor → /arbiter` triangle is ahead of most open-source alternatives.

**Differentiation:** Most tools are generic/global. This project is intentionally Ukrainian-first — the market compliance layer (zero Russian services, Ukrainian product rules, Ukrainian context) is unique in the space. No direct competitor addresses the Ukrainian developer market specifically.

[Based on WebSearch: "AI workflow rules framework npx CLI 2026", 2026-02-23]
