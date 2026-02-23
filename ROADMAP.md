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

---

### Task 16: Token Monitoring Redesign (Round 5)

> **Пріоритет:** P1 — архітектурна помилка в основі системи
> **Джерело:** Діагностика 2026-02-23 — виявили що `~/.claude/stats-cache.json` містить реальні дані
> **Передумова:** новий день (свіжі ліміти)

---

#### Діагноз (зафіксувати перед реалізацією)

**Що знайшли в `~/.claude/stats-cache.json`:**
```json
"dailyModelTokens": [{"date": "2026-02-17", "tokensByModel": {"claude-sonnet-4-6": 3255}}]
"modelUsage": {"inputTokens": 253425, "cacheReadInputTokens": 781988277}
"dailyActivity": [{"date": "2026-02-17", "messageCount": 747, "sessionCount": 1}]
"lastComputedDate": "2026-02-17"   ← оновлюється Claude Code, не в реальному часі
```

**Три кореневі помилки поточної системи:**

1. **Хибна ментальна модель** — "200k токенів на день" не існує для підписки.
   - 200k = розмір вікна контексту ОДНІЄЇ сесії (не денний ліміт)
   - Нові input-токени/день: 3k–75k (реальні дані stats-cache)
   - Cache reads: ~31M/день (доміную, але безкоштовні для підписки)
   - Rate limiting для Claude Pro = **поведінковий** (message count), не токенний

2. **AI самооцінка вимірювала не те** — session-log.json писав ~100k "estimates"
   які ніколи не корелювали з реальними цифрами stats-cache.json

3. **stats-cache.json стає** — `lastComputedDate` відстає на 1+ день.
   Дані є, але не real-time.

---

#### Що змінити

**16a: Нова логіка `//TOKENS` (читати stats-cache.json)**
- Читати `~/.claude/stats-cache.json` напряму (cross-platform path: `$HOME/.claude/stats-cache.json`)
- Показувати реальні дані з чесною датою: "дані за [lastComputedDate]"
- Показувати: нові токени за вчора + кількість сесій сьогодні (за .jsonl file dates)
- Прибрати фіктивне "200k daily" — замінити на "Context window (ця сесія)"
- **Нова модель відображення:**
  ```
  [AI STATUS] 🟢
  Context (ця сесія):  X% / 200k  ← AI оцінює
  Нові токени вчора:   Xk          ← stats-cache (реальні)
  Сесій сьогодні:      N           ← count .jsonl files modified today
  Rate limit:          🟢 Normal   ← якщо немає "overloaded" помилок
  Дані від:            YYYY-MM-DD  ← stats-cache lastComputedDate
  ```

**16b: Переписати Protocol 1.1 в AI-ENFORCEMENT.md**
- Видалити: `session-log.json` write protocol (самооцінка більше не потрібна)
- Замінити: читати `stats-cache.json` при `//TOKENS`
- Додати: cross-platform path detection (`$HOME/.claude/stats-cache.json`)
- Додати: graceful degradation якщо файл не знайдений
- **Dual-structure:** `.ai/AI-ENFORCEMENT.md` → `npm-templates/.ai/AI-ENFORCEMENT.md`

**16c: Оновити `//TOKENS` секцію в CLAUDE.md**
- Замінити алгоритм session-log на stats-cache читання
- Оновити `[AI STATUS]` формат (нові поля: "дані від", "сесій сьогодні")
- Прибрати: "today_total = sum sessions[].tokens" — це була фікція
- **Dual-structure:** `.claude/CLAUDE.md` → `npm-templates/.claude/CLAUDE.md`

**16d: Оновити context files (ukraine-full + minimal)**
- Секції про token tracking → нова ментальна модель
- Прибрати: "daily_limit: 200k" як абсолютний ліміт
- Додати: stats-cache як джерело truth
- **Dual-structure:** обидва contexts + npm-templates mirrors (4 файли)

**16e: session-log.json — депрекація або перепрофілювання**
- Вирішити: видалити session-log.json підхід повністю? чи залишити як fallback?
- Якщо залишати: переробити під "human-readable журнал" без фальшивих підрахунків
- Оновити `.gitignore` якщо потрібно

---

#### Технічні деталі

**stats-cache.json шлях:**
```bash
# Unix/Mac/WSL
~/.claude/stats-cache.json

# Windows (Git Bash)
$USERPROFILE/.claude/stats-cache.json   # або
$HOME/.claude/stats-cache.json
```

**Як рахувати "сесій сьогодні" без stats-cache:**
```bash
# Кількість .jsonl файлів змінених сьогодні в ~/.claude/projects/[project]/
find ~/.claude/projects/ -name "*.jsonl" -newer <(date -d "today 00:00" +%s) 2>/dev/null | wc -l
```

**Що stats-cache.json оновлює:**
- `dailyModelTokens` — нові input-токени (без кешу) — РЕАЛЬНІ
- `dailyActivity.messageCount` — кількість повідомлень — РЕАЛЬНІ
- `lastComputedDate` — коли останній раз обрахований (може бути стале на 1 день)
- Оновлюється Claude Code при запуску — не real-time

**Graceful degradation (якщо stats-cache не знайдений):**
```
[AI STATUS] ⚠️ Stats unavailable
Context (ця сесія): X% / 200k  ← тільки це доступно без stats-cache
Stats file: not found at ~/.claude/stats-cache.json
Tip: Run //TOKENS after first Claude Code session to populate stats.
```

---

#### Порядок виконання

1. **16b** (AI-ENFORCEMENT.md) — серце зміни, визначає нову логіку
2. **16c** (CLAUDE.md) — застосовує логіку до Claude Code
3. **16a** (verify //TOKENS вихід) — перевірка що нова модель показує правильно
4. **16d** (context files) — оновлення ментальної моделі в обох контекстах
5. **16e** (session-log.json) — cleanup артефакту старої системи

**Один commit після всіх 5 підзадач:** `feat(task-16): token monitoring redesign — stats-cache ground truth`

---

#### Ризики

| Ризик | Рівень | Мітигація |
|-------|--------|-----------|
| stats-cache стала (1 день) | 🟡 Medium | Показувати дату чесно, не ховати |
| Windows vs Unix path | 🟡 Medium | Cross-platform detection в AI протоколі |
| Cursor / інші AI не мають stats-cache | 🟡 Medium | Graceful degradation — показувати тільки context % |
| Видалення session-log.json ламає щось | 🟢 Low | Перевірити всі references перед видаленням |

**Токени:** ~30k (±50%) — середня задача
**Dual-structure файли:** 6–8 (CLAUDE.md ×2, AI-ENFORCEMENT.md ×2, contexts ×4)

---

## Опціонально (low priority)

| Task | Опис | Умова / Рішення |
|------|------|----------------|
| P3.2: File pair manifest | Manifest.json як єдине джерело для dual-structure file pairs | ⏸ Тільки коли ≥2 нових скілів (зараз 3, список стабільний — YAGNI) |
| `/pipeline` skill | Автоматизувати `/ctx → /sculptor → /arbiter` одною командою | ⏸ Відкласти |
| Cross-AI validation | Тестування скілів у Cursor / Windsurf | Після Task 16 |

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
