# AI PRODUCT RULES v1.0

## 0. ABOUT THIS DOCUMENT

### 📋 SCOPE
Продуктовые правила для разработки UI/UX, локализации, accessibility, масштабирования.
Дополняет **RULES_CORE.md** (технический workflow).

### 📁 LOCATION
```bash
# Хранится в приватном submodule:
/.ai-rules/
  ├── RULES_CORE.md       # Технический workflow
  ├── RULES_PRODUCT.md    # Этот файл
  └── .ai/
      ├── token-limits.json
      └── locale-context.json
```

### 🔄 SYNC WITH CORE
AI читает оба файла:
- **RULES_CORE.md** — как работаем (workflow, git, security)
- **RULES_PRODUCT.md** — что создаём (UX, i18n, accessibility)

---

## 1. INTERNATIONALIZATION (i18n) STRATEGY

### 1.1. PHILOSOPHY
**Сейчас:** Фокус на украинский рынок для скорости выхода на рынок.
**Завтра:** Архитектура готова к мультиязычности без рефакторинга.

### 1.2. i18n-READY ARCHITECTURE

#### Принципы с первого дня:
```typescript
// ❌ НЕПРАВИЛЬНО (хардкод текста)
<button>Відправити</button>

// ✅ ПРАВИЛЬНО (i18n-ready)
<button>{t('common.submit')}</button>

// ❌ НЕПРАВИЛЬНО (конкатенация строк)
const msg = "Привіт, " + userName + "!";

// ✅ ПРАВИЛЬНО (интерполяция переменных)
const msg = t('greeting', { name: userName });
```

#### Структура локализации:
```bash
/locales/
  ├── uk-UA/              # Украинский (primary)
  │   ├── common.json     # Общие элементы (buttons, forms)
  │   ├── auth.json       # Аутентификация
  │   ├── dashboard.json  # Дашборд
  │   └── errors.json     # Сообщения об ошибках
  ├── en-US/              # Английский (для будущего)
  │   └── common.json
  └── index.ts            # Экспорт всех переводов
```

#### Пример структуры файла локализации:
```json
// locales/uk-UA/common.json
{
  "common": {
    "submit": "Відправити",
    "cancel": "Скасувати",
    "save": "Зберегти",
    "delete": "Видалити",
    "edit": "Редагувати",
    "back": "Назад",
    "next": "Далі",
    "loading": "Завантаження...",
    "error": "Помилка",
    "success": "Успішно"
  },
  "greeting": "Привіт, {{name}}!",
  "itemCount": "{{count}} елемент",
  "itemCount_plural": "{{count}} елементи",
  "itemCount_many": "{{count}} елементів"
}
```

### 1.3. NAMESPACES (масштабирование переводов)
**Для больших проектов:**
```typescript
// Загружаем только нужные переводы
const { t } = useTranslation(['common', 'auth']);

// Используем:
t('common:submit')      // "Відправити"
t('auth:loginTitle')    // "Вхід в систему"
```

**Плюсы:**
- Меньше bundle size (не грузим все переводы сразу)
- Легко масштабировать (добавлять новые модули)
- Быстрее загрузка страниц

### 1.4. PLURALIZATION (множественное число)
**Украинский язык имеет сложные правила:**
```json
// uk-UA/common.json
{
  "itemCount_one": "{{count}} товар",      // 1, 21, 31...
  "itemCount_few": "{{count}} товари",     // 2-4, 22-24...
  "itemCount_many": "{{count}} товарів",   // 0, 5-20, 25-30...
  "itemCount_other": "{{count}} товарів"   // fallback
}
```
```typescript
// Использование:
t('itemCount', { count: 1 })   // "1 товар"
t('itemCount', { count: 2 })   // "2 товари"
t('itemCount', { count: 5 })   // "5 товарів"
t('itemCount', { count: 21 })  // "21 товар"
```

### 1.5. DATE/TIME/CURRENCY (форматирование)
**Используем Intl API (встроенный в браузер):**
```typescript
// lib/formatters.ts
export const formatters = {
  // Дата
  date: (date: Date, locale = 'uk-UA') => 
    new Intl.DateTimeFormat(locale, {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    }).format(date),
  // Результат для uk-UA: "26.01.2025"
  
  // Время
  time: (date: Date, locale = 'uk-UA') =>
    new Intl.DateTimeFormat(locale, {
      hour: '2-digit',
      minute: '2-digit'
    }).format(date),
  // Результат: "14:30"
  
  // Валюта
  currency: (amount: number, currency = 'UAH', locale = 'uk-UA') =>
    new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currency
    }).format(amount),
  // Результат: "1 234,56 ₴"
  
  // Число
  number: (num: number, locale = 'uk-UA') =>
    new Intl.NumberFormat(locale).format(num),
  // Результат: "1 234 567,89"
  
  // Телефон (украинский формат)
  phone: (phone: string) => {
    const cleaned = phone.replace(/\D/g, '');
    // +380 XX XXX XX XX
    return `+380 ${cleaned.slice(3, 5)} ${cleaned.slice(5, 8)} ${cleaned.slice(8, 10)} ${cleaned.slice(10, 12)}`;
  }
};
```

### 1.6. RTL SUPPORT (для будущего арабского/иврита)
**Если планируешь RTL языки в будущем:**
```css
/* Используй logical properties вместо left/right: */

/* ❌ ПЛОХО */
.button {
  margin-left: 1rem;
  padding-right: 2rem;
  text-align: left;
}

/* ✅ ХОРОШО (RTL-ready) */
.button {
  margin-inline-start: 1rem;  /* left в LTR, right в RTL */
  padding-inline-end: 2rem;   /* right в LTR, left в RTL */
  text-align: start;          /* left в LTR, right в RTL */
}
```

### 1.7. LANGUAGE DETECTION (определение языка пользователя)
```typescript
// lib/locale-detector.ts
export function detectUserLocale(): string {
  // Приоритет определения языка:
  
  // 1. Сохранённый выбор пользователя (если залогинен)
  const savedLocale = localStorage.getItem('user_locale');
  if (savedLocale) return savedLocale;
  
  // 2. Язык браузера
  const browserLocale = navigator.language; // "uk-UA", "en-US", etc.
  
  // 3. Проверяем поддерживаемые языки
  const supportedLocales = ['uk-UA', 'en-US'];
  
  // Точное совпадение
  if (supportedLocales.includes(browserLocale)) {
    return browserLocale;
  }
  
  // Совпадение по языку (игнорируем регион)
  const browserLang = browserLocale.split('-')[0]; // "uk", "en"
  const match = supportedLocales.find(locale => 
    locale.startsWith(browserLang)
  );
  if (match) return match;
  
  // 4. Fallback для украинского рынка
  return 'uk-UA';
}
```

### 1.8. i18n CHECKLIST (при создании нового компонента)
```markdown
i18n READINESS CHECKLIST:
- [ ] Все тексты через t('key'), не хардкод
- [ ] Переводы добавлены в locales/uk-UA/[namespace].json
- [ ] Используются переменные для имён/чисел (не конкатенация)
- [ ] Pluralization настроен для чисел (если applicable)
- [ ] Даты форматируются через Intl.DateTimeFormat
- [ ] Валюта форматируется через Intl.NumberFormat
- [ ] CSS использует logical properties (если есть позиционирование)
- [ ] Не используются хардкод форматы дат ("DD.MM.YYYY" в коде)
```

---

## 2. DEVICE ADAPTATION (адаптация под устройство пользователя)

### 2.1. PHILOSOPHY
**Уважаем выбор пользователя.** Не навязываем свои предпочтения.

### 2.2. THEME DETECTION (тёмная/светлая тема)
```typescript
// lib/theme-detector.ts
export function detectUserTheme(): 'light' | 'dark' {
  // Приоритет определения темы:
  
  // 1. Сохранённый выбор пользователя
  const savedTheme = localStorage.getItem('user_theme');
  if (savedTheme === 'light' || savedTheme === 'dark') {
    return savedTheme;
  }
  
  // 2. Системная настройка
  if (window.matchMedia) {
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    return prefersDark ? 'dark' : 'light';
  }
  
  // 3. Fallback
  return 'light'; // или 'dark' — твой выбор
}

// Слушаем изменения системной темы
if (window.matchMedia) {
  window.matchMedia('(prefers-color-scheme: dark)')
    .addEventListener('change', (e) => {
      // Если пользователь не выбрал тему вручную — обновляем автоматически
      if (!localStorage.getItem('user_theme')) {
        const newTheme = e.matches ? 'dark' : 'light';
        applyTheme(newTheme);
      }
    });
}
```

**CSS переменные для темы:**
```css
/* globals.css */
:root {
  /* Light theme (default) */
  --bg-primary: #ffffff;
  --bg-secondary: #f5f5f5;
  --text-primary: #1a1a1a;
  --text-secondary: #666666;
  --border-color: #e0e0e0;
  --accent-color: #3b82f6;
}

[data-theme="dark"] {
  /* Dark theme */
  --bg-primary: #1a1a1a;
  --bg-secondary: #2a2a2a;
  --text-primary: #ffffff;
  --text-secondary: #a0a0a0;
  --border-color: #404040;
  --accent-color: #60a5fa;
}

/* Использование: */
.card {
  background: var(--bg-primary);
  color: var(--text-primary);
  border: 1px solid var(--border-color);
}
```

### 2.3. FONT SIZE ADAPTATION (размер шрифта)
```css
/* ✅ ПРАВИЛЬНО — уважаем системные настройки */
html {
  /* Не устанавливаем жёсткий размер! */
  /* Браузер по умолчанию = 16px, но пользователь мог изменить в настройках */
  font-size: 100%; /* или вообще не указывать */
}

body {
  /* Используем относительные единицы */
  font-size: 1rem;      /* = базовый размер браузера */
  line-height: 1.5;
}

h1 { font-size: 2.5rem; }  /* 40px при базовом 16px */
h2 { font-size: 2rem; }    /* 32px */
p  { font-size: 1rem; }    /* 16px */
small { font-size: 0.875rem; } /* 14px */

/* ❌ НЕПРАВИЛЬНО — игнорирует настройки пользователя */
html {
  font-size: 16px; /* Жёсткий размер — плохо для accessibility */
}
```

**Правило:** Никогда не используй `px` для размеров текста. Только `rem`, `em`, `%`.

### 2.4. REDUCED MOTION (уважение к настройкам анимации)
```css
/* Пользователи с motion sickness могут отключить анимации в системе */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* В JS: */
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

if (!prefersReducedMotion) {
  // Показываем анимации
  element.classList.add('animated');
}
```

### 2.5. HIGH CONTRAST MODE (режим высокой контрастности)
```css
/* Для пользователей с проблемами зрения */
@media (prefers-contrast: high) {
  :root {
    --text-primary: #000000;
    --bg-primary: #ffffff;
    --border-color: #000000;
  }
  
  .button {
    border: 2px solid currentColor; /* Чёткая граница */
  }
}
```

### 2.6. VIEWPORT & RESPONSIVE (адаптивность)
```css
/* Mobile-first подход */

/* Base styles (mobile) */
.container {
  padding: 1rem;
  font-size: 1rem;
}

/* Tablet (768px+) */
@media (min-width: 48rem) {
  .container {
    padding: 2rem;
    font-size: 1.125rem;
  }
}

/* Desktop (1024px+) */
@media (min-width: 64rem) {
  .container {
    padding: 3rem;
    max-width: 1200px;
    margin: 0 auto;
  }
}

/* Large desktop (1440px+) */
@media (min-width: 90rem) {
  .container {
    max-width: 1400px;
  }
}
```

**Используй `rem` для breakpoints!** Уважает изменение базового размера шрифта.

### 2.7. TOUCH VS MOUSE (разные устройства ввода)
```css
/* Увеличенные зоны касания для touch устройств */
@media (pointer: coarse) {
  /* Coarse = touch (палец менее точен) */
  .button {
    min-height: 44px; /* Apple HIG рекомендация */
    min-width: 44px;
    padding: 0.75rem 1.5rem;
  }
  
  /* Больше spacing между интерактивными элементами */
  .nav-item {
    margin: 0.5rem;
  }
}

@media (pointer: fine) {
  /* Fine = mouse/trackpad */
  .button {
    min-height: 36px;
    padding: 0.5rem 1rem;
  }
  
  .nav-item {
    margin: 0.25rem;
  }
  
  /* Hover эффекты только для устройств с мышью */
  .button:hover {
    opacity: 0.8;
  }
}
```

### 2.8. DEVICE ADAPTATION CHECKLIST
```markdown
DEVICE ADAPTATION CHECKLIST:
- [ ] Тема определяется из системных настроек (prefers-color-scheme)
- [ ] Размеры шрифтов в rem/em, не px
- [ ] Анимации отключаются если prefers-reduced-motion
- [ ] Высокая контрастность поддерживается (prefers-contrast)
- [ ] Touch targets минимум 44x44px на мобильных
- [ ] Hover эффекты только для pointer: fine
- [ ] Респонсивные breakpoints в rem
- [ ] Locale определяется из navigator.language
- [ ] Валюта/даты форматируются через Intl API
```

---

## 3. UKRAINIAN MARKET POLICY (ZERO TOLERANCE)

### 3.1. CONTEXT
**Украина в состоянии войны с россией.** ANY russian presence = юридический/репутационный/safety риск.

### 3.2. ABSOLUTE PROHIBITIONS (всё, что НИКОГДА)

#### ❌ В коде/UI/контенте запрещено:
*   Russian language (тексты, строки, примеры, тесты, mock данные)
*   `.ru` домены (даже в примерах/тестах)
*   `ru-RU`, `ru_RU`, `rus`, `russian` локали
*   Russian имена в mock данных ("Иван Иванов", "Петров")
*   Russian города/регионы (Москва, Санкт-Петербург, etc.)
*   `RUB`, `₽` валюта
*   Телефон `+7 XXX-XXX-XX-XX`
*   Географические ссылки на россию
*   "Нейтральные" транслитерации: "Kiev" (ТОЛЬКО "Kyiv"/"Київ")
*   Russian культурные ссылки, бренды, компании

### 3.3. USE INSTEAD (украинские defaults)

#### ✅ Стандарты для UA рынка:
```typescript
// Конфиг по умолчанию (.ai/locale-context.json):
{
  "target_market": "UA",
  "ui_language": "uk-UA",
  "forbidden_langs": ["ru", "ru-RU", "russian"],
  "currency": "UAH",
  "currency_symbol": "₴",
  "phone_prefix": "+380",
  "phone_format": "+380 XX XXX XX XX",
  "date_format": "DD.MM.YYYY",
  "mock_data": {
    "names": ["Олена Коваленко", "Іван Шевченко", "Марія Бойко"],
    "cities": ["Київ", "Львів", "Одеса", "Харків", "Дніпро"],
    "emails": ["user@example.ua", "test@company.com"]
  }
}
```

#### Форматы данных:
```typescript
// lib/validators.ts (украинские форматы)

// Телефон
export const phoneRegex = /^\+380\d{9}$/;
// Пример: +380501234567

// ІПН (Tax ID)
export const taxIdRegex = /^\d{10}$/;
// Пример: 1234567890

// IBAN (банк)
export const ibanRegex = /^UA\d{27}$/;
// Пример: UA123456789012345678901234567

// Индекс (почтовый код)
export const postalCodeRegex = /^\d{5}$/;
// Пример: 01001
```

### 3.4. PRE-RELEASE CHECKLIST (перед каждым deploy)
```bash
# Запустить в корне проекта:

# 1. Проверка на .ru домены
grep -r "\.ru[^a-z]" ./src ./public ./app ./components

# 2. Проверка на russian локали
grep -r "ru-RU\|ru_RU\|russian" ./src ./app ./locales

# 3. Проверка на russian валюту
grep -r "RUB\|₽" ./src ./app

# 4. Проверка на russian телефоны
grep -r "\+7 " ./src ./app

# 5. Проверка на russian города/имена
grep -r "Москва\|Петербург\|Иван Иванов" ./src ./app

# Если ЛЮБАЯ команда вернула результат → БЛОКИРОВАТЬ deploy!
```

**Автоматизация в CI/CD:**
```yaml
# .github/workflows/lang-check.yml
name: LANG-CRITICAL Check

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Check for russian content
        run: |
          if grep -r "\.ru[^a-z]" ./src ./public; then
            echo "❌ LANG-CRITICAL: .ru domain found!"
            exit 1
          fi
          
          if grep -r "ru-RU\|ru_RU" ./src; then
            echo "❌ LANG-CRITICAL: russian locale found!"
            exit 1
          fi
          
          if grep -r "RUB\|₽" ./src; then
            echo "❌ LANG-CRITICAL: russian currency found!"
            exit 1
          fi
          
          echo "✅ No russian content detected"
```

### 3.5. AI BEHAVIOR ON LANG-CRITICAL

**Если AI случайно генерирует russian контент:**
```markdown
[LANG-CRITICAL DETECTED]
🚨 Violation: [Specific issue, e.g., "Generated mock data with russian name"]
File: [path/to/file.ts]
Line: [123]

ACTION TAKEN:
1. ⛔ STOPPED generation immediately
2. 🗑️ Deleted violating content
3. 🔄 Regenerating with Ukrainian alternatives

NEW VERSION:
[corrected code with Ukrainian mock data]

Please confirm before proceeding: [APPROVE/ADJUST]
```

**Автоматические проверки AI:**
*   Перед генерацией mock данных → использовать украинские имена из `.ai/locale-context.json`
*   Перед добавлением email примеров → использовать `.ua` или `.com` домены (никогда `.ru`)
*   Перед форматированием телефонов → использовать `+380` префикс
*   Перед добавлением локалей → проверить не содержит ли `ru`

### 3.6. GDPR & PRIVACY (для украинского рынка)

#### Обязательные элементы:
```typescript
// components/CookieConsent.tsx (украинский текст!)
export function CookieConsent() {
  return (
    <div className="cookie-banner">
      <p>
        Ми використовуємо cookies для покращення вашого досвіду. 
        Продовжуючи користуватися сайтом, ви погоджуєтесь з нашою{' '}
        <a href="/privacy">Політикою конфіденційності</a>.
      </p>
      <button onClick={acceptCookies}>Прийняти</button>
      <button onClick={rejectCookies}>Відхилити</button>
    </div>
  );
}
```

#### Шаблони документов (українською):
*   **Privacy Policy** (Політика конфіденційності)
*   **Terms of Service** (Умови використання)
*   **Cookie Policy** (Політика cookies)
*   **Data Deletion Request Form** (Форма видалення даних — GDPR right to be forgotten)

### 3.7. LEGAL RATIONALE
Ця політика існує для:
*   ✅ Відповідності українському законодавству у воєнний час
*   ✅ Захисту безпеки клієнтів і бренду
*   ✅ Юридичного захисту команди
*   ✅ Доступу до ринку і бізнес-континуїтету

**Це не обговорюється. Недотримання = ризик для проекту.**

---

## 4. ACCESSIBILITY (A11Y)

### 4.1. WCAG 2.1 LEVEL AA COMPLIANCE
**Мінімальний стандарт для всіх проектів:** WCAG 2.1 Level AA

### 4.2. SEMANTIC HTML
```html
<!-- ✅ ПРАВИЛЬНО -->
<header>
  <nav aria-label="Головна навігація">
    <ul>
      <li><a href="/">Головна</a></li>
      <li><a href="/about">Про нас</a></li>
    </ul>
  </nav>
</header>

<main>
  <h1>Заголовок сторінки</h1>
  <section>
    <h2>Розділ 1</h2>
    <p>Контент...</p>
  </section>
</main>

<footer>
  <p>&copy; 2025 Компанія</p>
</footer>

<!-- ❌ НЕПРАВИЛЬНО -->
<div class="header">
  <div class="nav">
    <div><span onclick="navigate('/')">Головна</span></div>
  </div>
</div>
```

### 4.3. ARIA LABELS
```tsx
// ✅ ПРАВИЛЬНО
<button 
  aria-label="Закрити модальне вікно"
  onClick={closeModal}
>
  <XIcon />
</button>

<input 
  type="search"
  aria-label="Пошук по сайту"
  placeholder="Введіть запит..."
/>

// ❌ НЕПРАВИЛЬНО (іконка без label)
<button onClick={closeModal}>
  <XIcon />
</button>
```

### 4.4. KEYBOARD NAVIGATION
```tsx
// Все интерактивные элементы должны работать с клавиатуры

function Dropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  
  // Закрытие по Escape
  useEffect(() => {
    function handleEscape(e: KeyboardEvent) {
      if (e.key === 'Escape' && isOpen) {
        setIsOpen(false);
      }
    }
    
    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, [isOpen]);
  
  return (
    <div ref={dropdownRef}>
      <button 
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        Меню
      </button>
      
      {isOpen && (
        <ul role="menu">
          <li role="menuitem">
            <a href="/profile">Профіль</a>
          </li>
          <li role="menuitem">
            <a href="/settings">Налаштування</a>
          </li>
        </ul>
      )}
    </div>
  );
}
```

### 4.5. COLOR CONTRAST (контрастність)
**Мінімальні значення WCAG AA:**
- Звичайний текст: мінімум 4.5:1
- Великий текст (18pt+): мінімум 3:1
- UI компоненти: мінімум 3:1
```css
/* ✅ ХОРОША контрастність */
.text {
  color: #1a1a1a;        /* Темний текст */
  background: #ffffff;    /* Білий фон */
  /* Контраст: 19.42:1 ✅ */
}

/* ⚠️ ПОГАНА контрастність */
.text-low-contrast {
  color: #999999;        /* Світло-сірий текст */
  background: #ffffff;   /* Білий фон */
  /* Контраст: 2.85:1 ❌ Не проходить WCAG AA */
}
```

**Перевірка:** Використовуй [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

### 4.6. FOCUS INDICATORS (індикатори фокусу)
```css
/* ✅ ПРАВИЛЬНО — чіткий focus indicator */
button:focus-visible {
  outline: 3px solid #3b82f6;
  outline-offset: 2px;
}

input:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 1px;
}

/* ❌ НЕПРАВИЛЬНО — прибираємо focus без альтернативи */
button:focus {
  outline: none; /* НІКОЛИ так не робити! */
}
```

### 4.7. SCREEN READER SUPPORT
```tsx
// Живі регіони для динамічного контенту
<div 
  role="alert" 
  aria-live="assertive"
>
  {error && <p>{error}</p>}
</div>

<div 
  role="status" 
  aria-live="polite"
>
  {successMessage && <p>{successMessage}</p>}
</div>

// Приховані елементи для screen readers
<span className="sr-only">
  Завантаження...
</span>

// CSS для sr-only:
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

### 4.8. A11Y CHECKLIST
```markdown
ACCESSIBILITY CHECKLIST:
- [ ] Semantic HTML (header, nav, main, section, footer)
- [ ] All images have alt text
- [ ] All interactive elements accessible via keyboard
- [ ] Focus indicators visible (не прибрані)
- [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [ ] Forms have proper labels
- [ ] ARIA labels for icon buttons
- [ ] Skip to content link (для довгих сторінок)
- [ ] Responsive для screen readers (aria-live regions)
- [ ] Tested with screen reader (NVDA/JAWS/VoiceOver)
```

---

## 5. SCALABILITY (масштабування)

### 5.1. COMPONENT ARCHITECTURE
```
/components/
  ├── ui/                 # Базові UI компоненти (Button, Input)
  │   ├── Button/
  │   │   ├── Button.tsx
  │   │   ├── Button.test.tsx
  │   │   └── Button.stories.tsx
  │   └── Input/
  ├── features/           # Фіча-специфічні компоненти
  │   ├── Auth/
  │   └── Dashboard/
  ├── layouts/            # Layout компоненти
  └── shared/             # Shared utilities
```

### 5.2. CONFIGURATION OVER CODE
```typescript
// ✅ ПРАВИЛЬНО — конфігурація зовні
// config/features.ts
export const features = {
  auth: {
    providers: ['google', 'github'],
    sessionDuration: 7 * 24 * 60 * 60, // 7 днів
  },
  payments: {
    enabled: process.env.NODE_ENV === 'production',
    currency: 'UAH',
  },
  ai: {
    enabled: true,
    model: 'claude-3-5-sonnet',
    maxTokens: 1024,
  },
};

// components/AuthButton.tsx
import { features } from '@/config/features';

export function AuthButton() {
  return (
    <>
      {features.auth.providers.map(provider => (
        <button key={provider} onClick={() => signIn(provider)}>
          {provider}
        </button>
      ))}
    </>
  );
}

// ❌ НЕПРАВИЛЬНО — хардкод в компоненті
export function AuthButton() {
  return (
    <>
      <button onClick={() => signIn('google')}>Google</button>
      <button onClick={() => signIn('github')}>GitHub</button>
    </>
  );
}
```

### 5.3. FEATURE FLAGS
```typescript
// lib/feature-flags.ts
export const featureFlags = {
  newDashboard: process.env.NEXT_PUBLIC_FEATURE_NEW_DASHBOARD === 'true',
  aiChat: process.env.NEXT_PUBLIC_FEATURE_AI_CHAT === 'true',
  darkMode: true, // Завжди enabled
};

// Використання:
import { featureFlags } from '@/lib/feature-flags';

export function Dashboard() {
  if (featureFlags.newDashboard) {
    return <NewDashboard />;
  }
  return <LegacyDashboard />;
}
```

### 5.4. API VERSIONING
```typescript
// app/api/v1/users/route.ts
export async function GET() {
  // v1 logic
}

// app/api/v2/users/route.ts
export async function GET() {
  // v2 logic with breaking changes
}

// Клієнт може вибирати версію:
fetch('/api/v1/users')  // Стара версія
fetch('/api/v2/users')  // Нова версія
```

### 5.5. DATABASE SCALABILITY
```typescript
// Не плодити таблиці без необхідності
// ✅ ПРАВИЛЬНО — одна таблиця з типом
model Notification {
  id        String   @id @default(cuid())
  userId    String
  type      String   // "email" | "push" | "sms"
  content   Json
  createdAt DateTime @default(now())
  
  user User @relation(fields: [userId], references: [id])
}

// ❌ НЕПРАВИЛЬНО — окрема таблиця для кожного типу
model EmailNotification { ... }
model PushNotification { ... }
model SMSNotification { ... }
```

### 5.6. CACHING STRATEGY
```typescript
// Кешування на різних рівнях

// 1. Browser cache (статичні assets)
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/images/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};

// 2. API cache (React Query)
const { data } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
  staleTime: 5 * 60 * 1000, // 5 хвилин
  cacheTime: 10 * 60 * 1000, // 10 хвилин
});

// 3. Server cache (Redis) — додавати тільки якщо є проблема з performance
```

### 5.7. PERFORMANCE BUDGETS
```json
// performance-budget.json
{
  "budgets": [
    {
      "resourceSizes": [
        { "resourceType": "script", "budget": 300 },
        { "resourceType": "total", "budget": 1000 }
      ],
      "resourceCounts": [
        { "resourceType": "third-party", "budget": 10 }
      ]
    }
  ]
}
```

### 5.8. SCALABILITY CHECKLIST
```markdown
SCALABILITY CHECKLIST:
- [ ] Components in ui/ are generic and reusable
- [ ] Feature-specific code in features/
- [ ] Configuration extracted to config files
- [ ] Feature flags for gradual rollouts
- [ ] API versioning if breaking changes expected
- [ ] Database schema normalized (no duplication)
- [ ] Caching strategy defined (browser + API + server if needed)
- [ ] Performance budgets set
- [ ] No premature optimization (start simple)
- [ ] Easy to add new language (i18n-ready)
- [ ] Easy to add new theme (CSS variables)
```

---

## 6. PRODUCT QUALITY STANDARDS

### 6.1. CODE REVIEW CHECKLIST
```markdown
BEFORE COMMITTING:
- [ ] Code follows i18n patterns (no hardcoded text)
- [ ] Responsive on mobile/tablet/desktop
- [ ] Works with keyboard navigation
- [ ] Contrast meets WCAG AA
- [ ] No LANG-CRITICAL violations (no russian content)
- [ ] Uses CSS variables for theming
- [ ] Font sizes in rem, not px
- [ ] No hardcoded breakpoints in pixels
- [ ] Touch targets min 44x44px on mobile
- [ ] Tested in light + dark theme
- [ ] Passes //CHECK:ALL
```

### 6.2. DEFINITION OF DONE
```markdown
FEATURE IS DONE WHEN:
- [ ] Code written and reviewed
- [ ] Tests written (unit + integration if complex)
- [ ] Translations added to locales/uk-UA/
- [ ] Works on mobile + desktop
- [ ] Accessibility checked (keyboard + screen reader)
- [ ] Dark theme tested
- [ ] LANG-CRITICAL scan passed
- [ ] Performance acceptable (<3s load)
- [ ] Documented (if complex feature)
- [ ] Deployed to staging
- [ ] Client/stakeholder approved
```

---

## CHANGELOG
*   **v1.0** [2025-01-26] – Initial product rules: i18n strategy, device adaptation, Ukrainian market policy, accessibility, scalability

---

*Stored in private repo with RULES_CORE.md. Last updated: 2025-01-26*