# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1
> **Last Updated:** 2026-02-22
> **Archive:** [Tasks 1-8 + old backlog](ai-logs/ROADMAP-archive-2026-02-21.md)
> **Vision:** Opinionated Ukrainian product. No opt-outs. Less is more.

---

## Карта файлів (Source of Truth)

> Перед будь-якою фазою — звіряти з цією таблицею.

| AI / IDE | Dev файл | npm-templates файл |
|----------|----------|--------------------|
| Claude Code | `.claude/CLAUDE.md` | `npm-templates/.claude/CLAUDE.md` |
| Cursor | `.cursorrules` | `npm-templates/.cursorrules` |
| Any AI (web) | `AGENTS.md` | `npm-templates/AGENTS.md` |

> **Правило:** будь-яка зміна rule-файлу = 6 файлів (3 пари).

---

## Активні задачі

### Round 1 — Швидке прибирання (поточна сесія або сьогодні)

| Task | Опис | Effort |
|------|------|--------|
| **Task 9a:** Commit Task 7 | Закомітити post-push.sh + всі зміни Task 7 | ~5 хв |
| **Task 9b:** Delete `task2.txt` | Прибрати артефакт з кореня проекту | ~5 хв |
| **Task 9c:** Delete `.ai/token-limits.json` | 840-рядковий мертвий файл — пастка для AI (замінений presets.json) | ~30 хв |
| **Task 9d:** Sync guard у pre-commit | Warning якщо rule-файл змінено без npm-templates копії | ~1 год |
| **Task 9e:** Slim CLAUDE.md | Прибрати "File Structure Reference" + "What's New v9.1" (дублюють map + changelog) | ~30 хв |

---

### Round 2 — Нова сесія (основна робота)

| Task | Опис | Effort |
|------|------|--------|
| **Task 10:** install.sh Wizard Redesign | Виправити зламаний bash-інсталер: прибрати teamSize, tokenPriority, показати 2 пресети замість 4, auto-install hooks, auto-append .gitignore. NPX ≡ Bash логічно. | ~1-2 дні |

**Деталі реалізації Task 10** (рішення зафіксовані):
- Прибрати питання: teamSize, tokenPriority, "Use recommended context?", "Install product rules?"
- Зробити автоматично: pre-commit hooks, .gitignore append-only
- Злити: market selection → context + product.md автоматично
- Пресети: показати тільки `minimal` + `ukraine-full`

---

### Round 3 — Після Task 10

| Task | Опис | Effort | Залежність |
|------|------|--------|-----------|
| **Task 11:** install.ps1 (Windows) | PowerShell-інсталер з тою ж логікою що redesigned install.sh | ~1 день | Task 10 |
| **Task 12:** Cursor format check | Перевірити чи підтримується `.cursorrules` в поточних версіях Cursor. Якщо ні — додати `.cursor/rules/ai-workflow.mdc` | ~1 год | Верифікація користувачем |

> **Для Task 12:** Відкрий проект з `.cursorrules` у Cursor і перевір чи застосовуються правила.
> Якщо НІ → Task 12 стає пріоритетом Round 1.

---

### Опціонально (low priority)

| Task | Опис | Рішення |
|------|------|---------|
| `/pipeline` skill | Автоматизувати `/ctx → /sculptor → /arbiter` в одну команду | ⏸ Відкласти — ручний контроль між кроками є перевагою |
| README polish | Оновити README для кінцевих користувачів | Після стабілізації інсталерів |
| Cross-AI validation | Тестування на різних AI-тулах | Після Task 11 |

---

## Архів

> Задачі 1-8 виконані 2026-02-21 — 2026-02-22.
> Повний контекст: [ROADMAP-archive-2026-02-21.md](ai-logs/ROADMAP-archive-2026-02-21.md)

---

**Made in Ukraine 🇺🇦**
