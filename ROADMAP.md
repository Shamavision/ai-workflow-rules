# AI Workflow Rules — ROADMAP

> **Version:** 9.1.1 | **Status:** ✅ Production Ready
> **Last Updated:** 2026-02-20
> **Archive:** Completed phases → [`ai-logs/ROADMAP-audit-2026-02-complete.md`](ai-logs/ROADMAP-audit-2026-02-complete.md)

---

## Карта файлов проекта (Source of Truth)

> Перед любой фазой — сверяться с этой таблицей.

### Rule-файлы (dev ↔ npm-templates пары, 10 файлов)

| AI / IDE | Dev файл | npm-templates файл | Как загружается |
|----------|----------|--------------------|----------------|
| Claude Code | `.claude/CLAUDE.md` | `npm-templates/.claude/CLAUDE.md` | Auto, at session start |
| Cursor | `.cursorrules` | `npm-templates/.cursorrules` | Auto |
| Windsurf | `.windsurfrules` | `npm-templates/.windsurfrules` | Auto |
| Any AI (web) | `AGENTS.md` | `npm-templates/AGENTS.md` | Via `//START` |
| Universal enforcement | `.ai/AI-ENFORCEMENT.md` | `npm-templates/.ai/AI-ENFORCEMENT.md` | Loaded by CLAUDE.md |

> ⚠️ `.continuerules` — **НЕ СУЩЕСТВУЕТ** (ни dev, ни npm-templates), хотя README упоминает Continue.dev. Баг.

### Конфигурационные файлы

| Файл | Назначение |
|------|-----------|
| `npm-templates/.ai/config.json` | Шаблон конфига пользователя |
| `npm-templates/.ai/session-log.json` | Шаблон лога сессий |
| `npm-templates/.ai/token-limits.json` | Шаблон лимитов |
| `.ai/session-log.json` | Dev-копия лога |

### Скрипты

| Скрипт | Dev | npm-templates |
|--------|-----|---------------|
| token-status.sh | `scripts/token-status.sh` | `npm-templates/scripts/token-status.sh` |
| sync-rules.sh | `scripts/sync-rules.sh` | `npm-templates/scripts/sync-rules.sh` |
| pre-commit | `scripts/pre-commit` | `npm-templates/scripts/pre-commit` |

### Инсталляторы

| Инсталлятор | Файл |
|-------------|------|
| NPX | `bin/cli.js` |
| Bash | `scripts/install.sh` |

### Документация (только npm-templates)

`npm-templates/.ai/docs/`: `token-usage.md`, `cheatsheet.md`, `quickstart.md`, `session-mgmt.md`, `provider-comparison.md`, `compatibility.md`, `code-quality.md`

---

## Phase 14: 3-Layer Mental Model

> **Status:** 🔴 PLANNED
> **Scope:** Документация и вывод `//TOKENS` — без изменений схем
> **Estimate:** ~15k tokens

### Концепция

Заменить размытую терминологию "токены / UNKNOWN" на честную трёхслойную модель.

| Слой | Что это | Точность |
|------|---------|----------|
| **Context Layer** | Жёсткий лимит окна модели (200k, 128k...) | ✅ Точно — AI знает |
| **Rate Layer** | Поведенческий throttle провайдера | ⚠️ Оцениваем — UNKNOWN для Pro |
| **Billing Layer** | Финансовый лимит (только API) | ✅ Точно — per-token billing |

Subscription (Claude Pro, ChatGPT Plus) → Billing Layer = `null`. Честно, без выдуманных лимитов.

### Целевой вывод `//TOKENS` после Phase 14

```
[AI STATUS]
Provider: Claude Pro (subscription)

Context Layer:  ~85k / 200k (42%)    ← AI знает точно
Rate Layer:     🟢 Normal            ← оценка по паттерну
Billing Layer:  N/A (subscription)

Status: 🟢 GREEN
```

Для API-режима:
```
[AI STATUS]
Provider: Anthropic API (billing)

Context Layer:  ~45k / 200k (22%)
Rate Layer:     🟢 Normal
Billing Layer:  ~$1.74 today / $20 budget (8%)

Status: 🟢 GREEN
```

### Файлы для изменения

**Rule-файлы (10 файлов — все пары):**

| Файл | Что меняем |
|------|-----------|
| `.claude/CLAUDE.md` | `//TOKENS` вывод → 3-layer формат |
| `npm-templates/.claude/CLAUDE.md` | То же |
| `.cursorrules` | `//TOKENS` секция → 3-layer формат |
| `npm-templates/.cursorrules` | То же |
| `.windsurfrules` | `//TOKENS` секция → 3-layer формат |
| `npm-templates/.windsurfrules` | То же |
| `AGENTS.md` | Секция TOKEN STATUS → 3-layer |
| `npm-templates/AGENTS.md` | То же |
| `.ai/AI-ENFORCEMENT.md` | TOKEN STATUS блок → 3-layer |
| `npm-templates/.ai/AI-ENFORCEMENT.md` | То же |

**Документация:**

| Файл | Что меняем |
|------|-----------|
| `README.md` | Секция "Token Monitoring" → 3-layer terminology |
| `npm-templates/.ai/docs/token-usage.md` | Полностью переписать под 3-layer model |

**Итого: 12 файлов**

---

## Phase 15: Burst Detection (context_pct)

> **Status:** 🔴 PLANNED
> **Scope:** Схема session-log + все 10 rule-файлов + 2 скрипта
> **Estimate:** ~30k tokens
> **Dependency:** После Phase 14 (используем 3-layer terminology)

### Концепция

Добавить `context_pct` в записи session-log. AI реально знает % заполнения контекста — это измеримый сигнал без выдуманных лимитов.

**Почему не ALU:** ALU требует классификации каждого запроса + выдуманных soft limits. `context_pct` — то, что AI знает без догадок.

### Изменение схемы session-log.json v1.2

```json
{
  "_version": "1.2",
  "sessions": [
    {
      "date": "2026-02-20",
      "tokens": 85000,
      "context_pct": 42,
      "tool": "claude-code",
      "trigger": "//tokens",
      "timestamp": 1771602000
    }
  ]
}
```

`context_pct` — опциональное int поле (0-100). Пишется при `//TOKENS` и `git-push`. Не пишется при `session-start`.

### Burst detection логика

```
Burst warning = 3+ записей подряд с context_pct > 60% в один день
```

Вывод в Rate Layer:
```
Rate Layer: 🟠 High load (context >60% in last 3 entries)
Rate Layer: 🟢 Normal
```

### Файлы для изменения

**Схема (2 файла):**

| Файл | Что меняем |
|------|-----------|
| `.ai/session-log.json` | `_version: "1.2"`, добавить `context_pct` в schema + пример |
| `npm-templates/.ai/session-log.json` | То же |

**Rule-файлы (10 файлов — все пары):**

| Файл | Что меняем |
|------|-----------|
| `.claude/CLAUDE.md` | `//TOKENS` step: estimate + write `context_pct`; burst check в Rate Layer |
| `npm-templates/.claude/CLAUDE.md` | То же |
| `.cursorrules` | `//TOKENS` секция: то же |
| `npm-templates/.cursorrules` | То же |
| `.windsurfrules` | `//TOKENS` секция: то же |
| `npm-templates/.windsurfrules` | То же |
| `AGENTS.md` | TOKEN STATUS: добавить context_pct + burst |
| `npm-templates/AGENTS.md` | То же |
| `.ai/AI-ENFORCEMENT.md` | TOKEN STATUS блок: то же |
| `npm-templates/.ai/AI-ENFORCEMENT.md` | То же |

**Скрипты (2 файла):**

| Файл | Что меняем |
|------|-----------|
| `scripts/token-status.sh` | Читать `context_pct` из последних записей session-log; показывать burst warning |
| `npm-templates/scripts/token-status.sh` | То же |

**Итого: 14 файлов**

### Backward compatibility

`context_pct` — опциональное поле. Старые записи без него работают как раньше. Нет breaking changes.

---

## Phase 16: API/Subscription Split в config.json

> **Status:** 🔴 PLANNED
> **Scope:** Config schema + инсталляторы + все 10 rule-файлов + 2 скрипта
> **Estimate:** ~35k tokens
> **Dependency:** Phase 14 (3-layer terminology уже в rule-файлах)

### Концепция

Добавить `"access_type": "subscription" | "billing"` в `config.json`. Это даёт rule-файлам возможность адаптировать вывод `//TOKENS` без догадок.

### Изменение config.json

**Subscription (Claude Pro, ChatGPT Plus, Cursor):**
```json
{
  "provider": "anthropic",
  "plan": "pro",
  "access_type": "subscription",
  "model": {
    "name": "claude-sonnet-4-6",
    "context_limit": 200000
  }
}
```

**API (Anthropic API, OpenAI API):**
```json
{
  "provider": "anthropic",
  "plan": "api",
  "access_type": "billing",
  "model": {
    "name": "claude-sonnet-4-6",
    "context_limit": 200000
  },
  "billing": {
    "cost_per_1k_input": 0.003,
    "cost_per_1k_output": 0.015,
    "daily_budget_usd": 20
  }
}
```

### Файлы для изменения

**Config шаблон (1 файл):**

| Файл | Что меняем |
|------|-----------|
| `npm-templates/.ai/config.json` | Добавить `access_type` + опциональный `billing` блок |

**Инсталляторы (2 файла):**

| Файл | Что меняем |
|------|-----------|
| `bin/cli.js` | `createAiConfig()`: добавить `access_type` по выбранному плану; добавить `billing` секцию для API-планов |
| `scripts/install.sh` | То же — в bash-генерации config.json |

**Rule-файлы (10 файлов — все пары):**

| Файл | Что меняем |
|------|-----------|
| `.claude/CLAUDE.md` | `//TOKENS` logic: `if access_type == "billing"` → показать Billing Layer |
| `npm-templates/.claude/CLAUDE.md` | То же |
| `.cursorrules` | То же |
| `npm-templates/.cursorrules` | То же |
| `.windsurfrules` | То же |
| `npm-templates/.windsurfrules` | То же |
| `AGENTS.md` | То же |
| `npm-templates/AGENTS.md` | То же |
| `.ai/AI-ENFORCEMENT.md` | То же |
| `npm-templates/.ai/AI-ENFORCEMENT.md` | То же |

**Скрипты (2 файла):**

| Файл | Что меняем |
|------|-----------|
| `scripts/token-status.sh` | Читать `access_type` из config.json → условный вывод Billing секции |
| `npm-templates/scripts/token-status.sh` | То же |

**Итого: 15 файлов**

### Backward compatibility

`access_type` — новое поле. Если отсутствует → fallback на `"subscription"` (текущее поведение). Нет breaking changes.

---

## Бонус: Phase 16.5 — Фикс .continuerules

> **Status:** ✅ DONE (2026-02-20)
> **Scope:** 2 файла + оба инсталлятора
> **Actual:** ~5k tokens

**Сделано:**
- ✅ `.continuerules` (dev) + `npm-templates/.continuerules` — созданы
- ✅ `bin/cli.js` — добавлен `Continue.dev` в tools array
- ✅ `scripts/install.sh` — добавлен `generate_rules_file ".continuerules"`
- ✅ `provider-comparison.md` — статус Continue.dev → ✅ Full support

---

## Remaining: Phase 10 / 12 / 13

### Phase 10 — Кролик #4

| Task | Status |
|------|--------|
| Collect кролик bash install feedback (issue #4) | ⏳ Awaiting user |
| Fix bash install issues from feedback | 🔴 PLANNED |
| Re-test кролик after fixes | 🔴 PLANNED |

### Phase 12 — README Polish + Cross-AI Validation

| Task | Status |
|------|--------|
| Update/replace "47% GitHub 2024" statistic | 🔴 NEEDS RESEARCH |
| Rethink Token Monitoring display (after Phase 14) | 🔴 → решается Phase 14 |
| Cross-AI Validation (session-log + //TOKENS по всем AI/IDE) | 🔴 NOT TESTED |

### Phase 13 — Update Mechanism

`sync-rules.sh --update` — pull framework files from GitHub, preserve user config.
Full spec: [`ai-logs/ROADMAP-audit-2026-02-complete.md`](ai-logs/ROADMAP-audit-2026-02-complete.md)

---

## Future: v9.2 Ideas

| Idea | Priority |
|------|----------|
| `install.ps1` parity (Windows PowerShell) | 🔴 High |
| GitHub Actions CI for verify-templates | 🟡 Medium |
| Auto-context selector (AI detects project type) | 🔵 Low |
| v10.0: TypeScript rewrite of CLI | 🔵 Very Low |

---

## 📦 Package Info

```
Name:    @shamavision/ai-workflow-rules
Version: 9.1.1
Files:   35 (164.9kB packed, 497.4kB unpacked)
CLI:     npx @shamavision/ai-workflow-rules
```

**Architecture Models (2026):**
- `MODEL_1`: Hard Token Billing — Anthropic API, Mistral, DeepSeek, Google API
- `MODEL_2`: Request Quota — GitHub Copilot (~300/month)
- `MODEL_3`: Fair Use Dynamic — Claude Pro, Gemini Advanced, Cursor, Windsurf

**Made in Ukraine 🇺🇦**
