# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1
> **Last Updated:** 2026-02-23
> **Archive:** [Tasks 1-8 + Round 1 + old backlog](ai-logs/ROADMAP-archive-2026-02-21.md)
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

> **Правило:** будь-яка зміна rule-файлу = 8 файлів (4 пари).

---

## Активні задачі

### Round 3 — Нова сесія

| Task | Опис | Effort | Залежність |
|------|------|--------|-----------|
| **Task 10:** install.sh Wizard Redesign | Виправити зламаний bash-інсталер: прибрати teamSize, tokenPriority, показати 2 пресети замість 4, auto-install hooks, auto-append .gitignore. NPX ≡ Bash логічно. | ~1-2 дні | — |
| **Task 11:** install.ps1 (Windows) | PowerShell-інсталер з тою ж логікою що redesigned install.sh | ~1 день | Task 10 |

**Деталі реалізації Task 10** (рішення зафіксовані):
- Прибрати питання: teamSize, tokenPriority, "Use recommended context?", "Install product rules?"
- Зробити автоматично: pre-commit hooks, .gitignore append-only
- Злити: market selection → context + product.md автоматично
- Пресети: показати тільки `minimal` + `ukraine-full`

---

### Опціонально (low priority)

| Task | Опис | Рішення |
|------|------|---------|
| `/pipeline` skill | Автоматизувати `/ctx → /sculptor → /arbiter` в одну команду | ⏸ Відкласти — ручний контроль між кроками є перевагою |
| README polish | Оновити README для кінцевих користувачів | Після стабілізації інсталерів |
| Cross-AI validation | Тестування на різних AI-тулах | Після Task 11 |

---

## Архів

> **Round 1** (Tasks 9a-9e) — виконано 2026-02-22 (`9de740b`)
> - 9a: Commit Task 7 ✅
> - 9b: Delete `task2.txt` ✅
> - 9c: Delete `.ai/token-limits.json` ✅
> - 9d: Sync guard у pre-commit ✅
> - 9e: Slim CLAUDE.md ✅
>
> **Round 2** (Tasks 12) — виконано 2026-02-23
> - Task 12: Cursor `.cursor/rules/` міграція ✅
>   - `.cursor/rules/ai-workflow.mdc` (dev + npm-templates)
>   - `bin/cli.js`: генерація `.mdc` з frontmatter
>   - `scripts/pre-commit`: sync pair для нової пари
>
> Задачі 1-8 виконані 2026-02-21 — 2026-02-22.
> Повний контекст: [ROADMAP-archive-2026-02-21.md](ai-logs/ROADMAP-archive-2026-02-21.md)

---

**Made in Ukraine 🇺🇦**
