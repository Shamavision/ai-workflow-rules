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
| **Task 10:** install.sh + cli.js Redesign | Виправити bash-інсталер і синхронізувати з NPX: єдина логіка wizard | ~1 день | — |
| **Task 11:** install.ps1 (Windows) | PowerShell-інсталер з тою ж логікою | ~1 день | Task 10 |

---

### Task 10 — Деталі реалізації (зафіксовано 2026-02-23)

#### Wizard Flow (до і після)

**БУЛО (8 питань):**
```
1. Provider
2. Plan
3. Install hooks? (confirm)
4. Add to .gitignore? (confirm)
5. Install product rules? (confirm)
6. How many team members? ← ВИДАЛИТИ (dead code)
7. Primary market?
8. Token priority? ← ВИДАЛИТИ (dead code)
9. Use recommended context? ← ВИДАЛИТИ
```

**СТАЛО (3 питання):**
```
1. Provider
2. Plan
3. Market? (Ukrainian → ukraine-full | International → minimal)
→ All else: automatic
```

---

#### Файли що змінюються

| Файл | Зміна | Пріоритет |
|------|-------|-----------|
| `scripts/install.sh` | Повний redesign wizard | 🔴 |
| `bin/cli.js` | Видалити 3 питання, simplify context selection | 🔴 |

> **Правило dual-structure:** `scripts/install.sh` — без npm-templates копії (це installer script, не rule-файл).
> `bin/cli.js` — також без npm-templates копії.

---

#### install.sh — Конкретні зміни

**Видалити:**
- `get_token_limits()` функцію (рядки 79-100) — hardcoded ліміти, старий підхід
- `get_arch_model()` функцію (рядки 102-112) — більше не потрібна
- `teamSize` питання (рядки 258-261)
- `tokenPriority` питання (рядки 271-274)
- Recommendation logic (рядки 276-293) — тепер просто market → context
- "Use recommended?" питання (рядок 312)
- Manual context selection (4 опції → не потрібно, ринок сам вибирає)
- `installHooks` питання (рядок 240-241) — automatic
- `updateGitignore` питання (рядок 244-245) — automatic
- `installProductRules` питання (рядок 248-249) — auto from market

**Змінити:**
- Context selection: `market=ukraine → ukraine-full + INSTALL_PRODUCT=yes`, else → `minimal`
- Context table: показати тільки 2 рядки (minimal + ukraine-full)
- Context loop (рядок 374): `for ctx in minimal ukraine-full` (прибрати standard, enterprise)
- `generate_rules_file`: додати `.cursor/rules/ai-workflow.mdc` з frontmatter
- `token-limits.json` format: спростити (без великих блоків, daily_limit: null)
- `config.json`: прибрати `token_budget` блок, config_version → "2.2"
- Hooks install: unconditional (завжди, без питання)
- .gitignore: unconditional (завжди, append-only)

**Додати:**
- Copy `.claude/commands/` (ctx.md, sculptor.md, arbiter.md) — MISSING зараз!
- Copy `scripts/post-push.sh` — MISSING зараз!
- Install post-push hook (automatic, як cli.js робить)
- `generate_rules_file` з frontmatter параметром для `.mdc`
- Verification: додати перевірку `.claude/commands/ctx.md`, `.cursor/rules/ai-workflow.mdc`

---

#### cli.js — Конкретні зміни

**Видалити:**
```js
// ВИДАЛИТИ ці три питання з main():
const installHooks = await confirm({ message: 'Install security pre-commit hooks?...' });
const shouldUpdateGitignore = await confirm({ message: 'Add AI files to .gitignore?...' });
const installProductRules = await confirm({ message: 'Install product rules?...' });
```

**Замінити `selectContextWithRecommendation()`:**
```js
// СТАРА функція (видалити):
// async function selectContextWithRecommendation() { ... }

// НОВА логіка (inline в main()):
const market = await select({
  message: 'Primary market?',
  options: [
    { value: 'ukraine', label: 'Ukrainian market', hint: 'ukraine-full context + compliance rules' },
    { value: 'international', label: 'International', hint: 'minimal context' }
  ]
});
const selectedContext = market === 'ukraine' ? 'ukraine-full' : 'minimal';
const installProductRules = market === 'ukraine';  // auto

// Показати що вибрано:
log.success(`Context: ${selectedContext}`);
```

**Змінити answers:**
```js
const answers = {
  provider,
  plan,
  installHooks: true,          // always
  updateGitignore: true,       // always
  installProductRules,         // from market
  context: selectedContext
};
```

---

#### Нова структура файлів після install (user side)

```
project/
├── AGENTS.md
├── .claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── commands/
│   │   ├── ctx.md          ← NEW (був missing)
│   │   ├── sculptor.md     ← NEW (був missing)
│   │   └── arbiter.md      ← NEW (був missing)
│   └── hooks/
│       └── user-prompt-submit.sh
├── .cursor/
│   └── rules/
│       └── ai-workflow.mdc ← NEW (Task 12)
├── .cursorrules
├── .ai/
│   ├── config.json
│   ├── token-limits.json   (спрощений формат)
│   ├── AI-ENFORCEMENT.md
│   ├── contexts/
│   │   ├── minimal.context.md
│   │   └── ukraine-full.context.md
│   ├── docs/ (8 файлів)
│   ├── rules/
│   │   ├── core.md
│   │   └── product.md      (тільки якщо ukraine)
│   └── forbidden-trackers.json
├── scripts/
│   ├── pre-commit
│   ├── sync-rules.sh
│   ├── token-status.sh
│   └── post-push.sh        ← NEW (був missing)
└── .git/hooks/
    ├── pre-commit          ← always (auto)
    └── post-push           ← NEW (auto)
```

---

#### Ризики

| Ризик | Рівень | Мітигація |
|-------|--------|-----------|
| Bash heredoc з JSON (backticks, $VAR) | 🟡 | Використовувати `EOF` без интерполяції де потрібно |
| `copy_file` для директорій | 🟡 | Зберегти `mkdir -p` перед кожним блоком |
| Backward compat у config.json | 🟢 | config_version 2.2 — нові поля, старі видалені gracefully |

---

### Task 11 — PowerShell (після Task 10)

> Деталі — після завершення Task 10. Логіка ідентична redesigned install.sh.

---

### Опціонально (low priority)

| Task | Опис | Рішення |
|------|------|---------|
| `/pipeline` skill | Автоматизувати `/ctx → /sculptor → /arbiter` | ⏸ Відкласти |
| README polish | Оновити README | Після стабілізації інсталерів |
| Cross-AI validation | Тестування | Після Task 11 |

---

## Архів

> **Round 1** (Tasks 9a-9e) — виконано 2026-02-22 (`9de740b`)
> **Round 2** (Task 12) — виконано 2026-02-23 (`e5d89a9`)
>
> Задачі 1-8 виконані 2026-02-21 — 2026-02-22.
> Повний контекст: [ROADMAP-archive-2026-02-21.md](ai-logs/ROADMAP-archive-2026-02-21.md)

---

**Made in Ukraine 🇺🇦**
