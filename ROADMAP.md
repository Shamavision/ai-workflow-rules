# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1
> **Last Updated:** 2026-02-23
> **Archive:** [Round 4 (2026-02-23)](ai-logs/ROADMAP-archive-round4-2026-02-23.md) | [Round 2+3 (2026-02-23)](ai-logs/ROADMAP-archive-2026-02-23.md) | [Tasks 1-8 + Round 1 (2026-02-21)](ai-logs/ROADMAP-archive-2026-02-21.md)
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

## Активні задачі

**Немає активних задач. Всі заплановані задачі виконані.**

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

> **Round 4** (Крок 0 + Tasks 14, 15) — виконано 2026-02-23 (`6d73af0`)
> Ideology doc, arbiter improvements, cleanup sprint (24 scripts, dead files), AGENTS.md update
>
> **Round 2** (Task 12) + **Round 3** (Tasks 13, 10) — виконано 2026-02-23
> Деталі: [ROADMAP-archive-2026-02-23.md](ai-logs/ROADMAP-archive-2026-02-23.md)
>
> **Round 1** (Tasks 9a-9e) — виконано 2026-02-22 (`9de740b`)
> **Tasks 1-8** — виконані 2026-02-21 — 2026-02-22
> Деталі: [ROADMAP-archive-2026-02-21.md](ai-logs/ROADMAP-archive-2026-02-21.md)

---

**Made in Ukraine 🇺🇦**
