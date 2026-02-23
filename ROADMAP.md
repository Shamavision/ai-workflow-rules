# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1
> **Last Updated:** 2026-02-23
> **Archive:** [Round 2+3 (2026-02-23)](ai-logs/ROADMAP-archive-2026-02-23.md) | [Tasks 1-8 + Round 1 (2026-02-21)](ai-logs/ROADMAP-archive-2026-02-21.md)
> **Vision:** Opinionated Ukrainian product. No opt-outs. Less is more.

---

## Карта файлів (Source of Truth)

> Перед будь-якою фазою — звіряти з цією таблицею.

| AI / IDE | Dev файл | npm-templates файл |
|----------|----------|--------------------|
| Claude Code | `.claude/CLAUDE.md` | `npm-templates/.claude/CLAUDE.md` |
| Cursor (new ≥0.45) | `.cursor/rules/ai-workflow.mdc` | `npm-templates/.cursor/rules/ai-workflow.mdc` |
| Cursor (legacy <0.45) | `.cursorrules` | `npm-templates/.cursorrules` |
| Any AI (web) | `AGENTS.md` | `npm-templates/AGENTS.md` |
| Claude Skills | `.claude/commands/*.md` | `npm-templates/.claude/commands/*.md` |

> **Правило:** будь-яка зміна rule-файлу = 8+ файлів (4+ пари).

---

## Активні задачі (Round 4 — 2026-02-23)

> Джерело: PROPOSALS.md (скульптор) + ARBITER_REPORT.md (арбітр) від 2026-02-23
> Виконувати по порядку. Кожна задача — атомарний крок.

---

### Крок 0: Commit поточних змін (ПЕРЕД усім іншим)

> Очистити робоче дерево перед cleanup sprint.

**Файли до commit:**
- `PROJECT_IDEOLOGY.md` — NEW (soul doc, створений цієї сесії)
- `npm-templates/PROJECT_IDEOLOGY.md` — NEW (шаблон для користувачів)
- `.claude/commands/arbiter.md` — +3 покращення (DECISIONS, cross-conflict, uncommitted collision)
- `npm-templates/.claude/commands/arbiter.md` — mirror
- `.claude/commands/ctx.md` — +PRODUCT section в Case A template
- `npm-templates/.claude/commands/ctx.md` — mirror
- `bin/cli.js` — +copyFile PROJECT_IDEOLOGY.md, +Next Steps, -dead CONTEXTS const
- `scripts/install.sh` — +copy_file PROJECT_IDEOLOGY.md, +Next Steps
- `PROJECT_CONTEXT_MAP.md` — повний перезапис (full scan 2026-02-23)
- `PROPOSALS.md` — fresh analysis (скульптор, 2026-02-23)
- `ARBITER_REPORT.md` — перший реальний запуск арбітра

**Commit message:** `feat(round-4): ideology + arbiter improvements + full ctx scan`

---

### Task 14: Cleanup Sprint (Round 1)

> Арбітр: всі 5 задач незалежні, виконати в одній сесії, один commit.

**Виконувати в такому порядку:**

#### 14a: Runtime files out of npm-templates (P1.3)
- Видалити `npm-templates/.ai/token-limits.json` (840 рядків, old schema)
- Видалити `npm-templates/.ai/session-log.json` (runtime data)
- Перевірити: `bin/cli.js` + `install.sh` НЕ копіюють ці файли (grep перед видаленням)
- **Ризик:** 🟢 Low | **Токени:** ~3k

#### 14b: config.json cleanup — dead schema fields (P1.2)
- Видалити блок `token_budget` (daily_limit, monthly_limit, auto_approve_thresholds) — dead since Task 6
- Видалити поле `modules: []` — dead, немає значення
- Змінити `config_version: "2.1"` → `"2.2"` (Task 4 bump)
- **Dual-structure:** зробити те ж саме в `npm-templates/.ai/config.json`
- **Ризик:** 🟡 Medium | **Токени:** ~4k

#### 14c: Delete QUICK_CONTEXT.md (P2.1)
- Прочитати `QUICK_CONTEXT.md` → перевірити чи є унікальний контент (якщо є — перенести в PROJECT_CONTEXT_MAP.md)
- Grep по `CLAUDE.md` і `AGENTS.md` — чи немає посилань на QUICK_CONTEXT.md
- Видалити файл
- **Ризик:** 🟢 Low | **Токени:** ~6k

#### 14d: Scripts purge — 24 legacy files (P1.1)
- **Спочатку:** `ls npm-templates/scripts/` — визначити які з legacy скриптів мають mirror
- Видалити з `scripts/` та з `npm-templates/scripts/` (dual-structure!):
  ```
  install.ps1, setup.sh, setup.ps1, setup-lint.sh
  pre-commit.js, pre-commit.ps1, pre-commit-lint.sh
  ai-protection.js, ai-protection.ps1, ai-protection.sh
  ai-session.sh, session-init.sh
  context-diff.sh, estimate-tokens.sh, token-log.sh
  token-status.sh, token-status.ps1
  migrate-to-hub.sh, cleanup-root.sh
  check-links.sh, seo-check.sh
  validate-setup.sh, validate-structure.sh, verify-templates.sh
  ```
- **Залишити:** `install.sh`, `pre-commit`, `post-push.sh`, `sync-rules.sh`
- Після видалення: оновити dual-structure таблицю в `PROJECT_CONTEXT_MAP.md` (прибрати пари видалених файлів)
- **Ризик:** 🟢 Low | **Токени:** ~5k

#### 14e: CHANGELOG catch-up — Rounds 2+3 (P2.2)
- Читати `CHANGELOG.md` → додати записи:
  - Round 3: task-13 (ideology + WebSearch), task-10 (wizard 8→3), task-12 (Cursor .mdc)
  - Round 2: task-12 (Cursor ≥0.45 migration)
  - Round 4 (цей cleanup): task-14
- **Останній крок** в Round 1 (covers весь cleanup sprint)
- **Ризик:** 🟢 Low | **Токени:** ~6k

**Round 1 commit:** `chore(cleanup): scripts purge + config cleanup + dead files`
**Round 1 total:** ~24k токенів (±50%)

---

### Task 15: AGENTS.md update (Round 2 — P2.3)

> Арбітр: після того як Task 14 закомічений. Окрема сесія або відразу після.

**Що оновити в `AGENTS.md` (і `npm-templates/AGENTS.md`):**
1. `//START` → посилання на `PROJECT_IDEOLOGY.md` + `PROJECT_CONTEXT_MAP.md`
2. Skills triangle: `/ctx` (Reality) → `/sculptor` (Clarity) → `/arbiter` (Order + Safety) — по одному рядку на кожен
3. Session anchor: post-push оновлює `## 📍 Last Push` в PROJECT_CONTEXT_MAP.md
4. Прибрати: будь-які згадки Windsurf, Continue.dev (видалені в Task 2)
5. **Dual-structure:** оновити `npm-templates/AGENTS.md` ідентично

**Round 2 commit:** `docs(agents): reflect current workflow + skills triangle`
**Round 2 total:** ~13k токенів (±50%)

---

## Опціонально (low priority)

| Task | Опис | Умова / Рішення |
|------|------|----------------|
| P3.2: File pair manifest | Manifest.json як єдине джерело для dual-structure file pairs | ⏸ Тільки коли ≥2 нових скілів (зараз 3, список стабільний — YAGNI) |
| `/pipeline` skill | Автоматизувати `/ctx → /sculptor → /arbiter` одною командою | ⏸ Відкласти |
| README polish | Оновити README: 3 питання wizard, skills triangle, PROJECT_IDEOLOGY.md | Коли буде час |
| Cross-AI validation | Тестування скілів у Cursor / Windsurf | Після README |

---

## Архів

> **Round 2** (Task 12) + **Round 3** (Tasks 13, 10) — виконано 2026-02-23
> Деталі: [ROADMAP-archive-2026-02-23.md](ai-logs/ROADMAP-archive-2026-02-23.md)
>
> **Round 1** (Tasks 9a-9e) — виконано 2026-02-22 (`9de740b`)
> **Tasks 1-8** — виконані 2026-02-21 — 2026-02-22
> Деталі: [ROADMAP-archive-2026-02-21.md](ai-logs/ROADMAP-archive-2026-02-21.md)

---

**Made in Ukraine 🇺🇦**
