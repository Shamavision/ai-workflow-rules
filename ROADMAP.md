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
| Cursor (new ≥0.45) | `.cursor/rules/ai-workflow.mdc` | `npm-templates/.cursor/rules/ai-workflow.mdc` |
| Cursor (legacy <0.45) | `.cursorrules` | `npm-templates/.cursorrules` |
| Any AI (web) | `AGENTS.md` | `npm-templates/AGENTS.md` |

> **Правило:** будь-яка зміна rule-файлу = 8 файлів (4 пари після Task 12).

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

| Task | Опис | Effort | Пріоритет |
|------|------|--------|-----------|
| **Task 10:** install.sh Wizard Redesign | Виправити зламаний bash-інсталер: прибрати teamSize, tokenPriority, показати 2 пресети замість 4, auto-install hooks, auto-append .gitignore. NPX ≡ Bash логічно. | ~1-2 дні | 🔴 High |
| **Task 12:** Cursor `.cursor/rules/` міграція | `.cursorrules` deprecated з Cursor 0.45. Створити `.cursor/rules/ai-workflow.mdc` (dev + npm-templates). Оновити installer. Залишити `.cursorrules` для backward compat. | ~2 год | 🔴 High (підтверджено!) |

**Деталі реалізації Task 10** (рішення зафіксовані):
- Прибрати питання: teamSize, tokenPriority, "Use recommended context?", "Install product rules?"
- Зробити автоматично: pre-commit hooks, .gitignore append-only
- Злити: market selection → context + product.md автоматично
- Пресети: показати тільки `minimal` + `ukraine-full`

**Деталі реалізації Task 12** (рішення зафіксовані, підтверджено WebSearch):

Причина: `.cursorrules` deprecated з Cursor 0.45. Новий формат — `.cursor/rules/*.mdc`.
Без оверінжинірингу: просто додати новий файл поряд зі старим.

**Кроки (в наступній сесії):**

1. **Створити** `.cursor/rules/ai-workflow.mdc`:
   ```
   ---
   description: AI Workflow Rules — session protocol, token management, security guards
   globs: ["**/*"]
   alwaysApply: true
   ---
   [вміст з .cursorrules без змін]
   ```
   Frontmatter `alwaysApply: true` = аналог глобального `.cursorrules`

2. **Дзеркало** → `npm-templates/.cursor/rules/ai-workflow.mdc` (той самий файл)

3. **`bin/cli.js`** — додати копіювання `.cursor/rules/` при інсталяції:
   ```js
   // В install() після копіювання .cursorrules:
   const cursorRulesDir = path.join(targetDir, '.cursor', 'rules');
   await fs.ensureDir(cursorRulesDir);
   await fs.copy(
     path.join(sourceDir, '.cursor', 'rules', 'ai-workflow.mdc'),
     path.join(cursorRulesDir, 'ai-workflow.mdc')
   );
   ```

4. **`scripts/pre-commit`** — додати нову пару до sync guard:
   ```bash
   check_sync_pair ".cursor/rules/ai-workflow.mdc" "npm-templates/.cursor/rules/ai-workflow.mdc"
   ```
   (обидві копії: dev + npm-templates)

5. **`.cursorrules` НЕ видаляти** — backward compat для Cursor <0.45

6. **`.gitignore`** — НЕ змінювати (`.cursor/rules/` має бути в git)

**Файли зміняться:** 6 файлів (mdc×2, cli.js, pre-commit×2, CHANGELOG)
**Ризик:** 🟢 Non-breaking (additive)
**Оцінка:** ~10-15k tokens

---

### Round 3 — Після Task 10

| Task | Опис | Effort | Залежність |
|------|------|--------|-----------|
| **Task 11:** install.ps1 (Windows) | PowerShell-інсталер з тою ж логікою що redesigned install.sh | ~1 день | Task 10 |

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
