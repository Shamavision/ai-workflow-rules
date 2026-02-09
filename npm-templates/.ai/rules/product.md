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

## 7. SEO/GEO STRATEGY (Ukrainian Market)

### 7.1. PHILOSOPHY
**Balance:** Защита бизнеса + SEO для украинского рынка

- ✅ **SEO-friendly:** Поисковые системы могут индексировать контент
- 🔒 **Geo-targeted:** Фокус на украинский рынок, блокируем russian
- 🚀 **Performance:** Быстрая загрузка = лучший SEO ranking

### 7.2. ROBOTS.TXT CONFIGURATION

**Location:** `public/robots.txt`

#### Best Practices:
```txt
# Allow all by default (good for SEO)
User-agent: *
Allow: /

# Declare sitemap
Sitemap: https://yourdomain.com/sitemap.xml

# Block russian search engines (Ukrainian market policy)
User-agent: Yandex
Disallow: /

User-agent: Mail.RU_Bot
Disallow: /
```

**Common Mistakes to Avoid:**
```txt
# ❌ DON'T block everything:
User-agent: *
Disallow: /
# This prevents ALL search engines from indexing!

# ✅ DO allow important pages:
User-agent: *
Allow: /
```

### 7.3. HTML META TAGS (Ukrainian Market)

#### Required Meta Tags:
```html
<html lang="uk-UA">
<head>
  <!-- Charset -->
  <meta charset="UTF-8" />

  <!-- Viewport (mobile) -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <!-- Title (50-60 chars) -->
  <title>Ваш заголовок тут - Назва сайту</title>

  <!-- Description (150-160 chars) -->
  <meta name="description" content="Опис вашого сайту для пошукових систем" />

  <!-- Keywords (optional, less important now) -->
  <meta name="keywords" content="ключові, слова, українською" />

  <!-- Language alternatives (hreflang) -->
  <link rel="alternate" hreflang="uk-UA" href="https://yourdomain.com" />
  <link rel="alternate" hreflang="en-US" href="https://yourdomain.com/en" />
  <link rel="alternate" hreflang="x-default" href="https://yourdomain.com" />

  <!-- Canonical URL (avoid duplicate content) -->
  <link rel="canonical" href="https://yourdomain.com/page" />
</head>
</html>
```

#### Open Graph (Social Media):
```html
<!-- Facebook / LinkedIn -->
<meta property="og:type" content="website" />
<meta property="og:url" content="https://yourdomain.com/" />
<meta property="og:title" content="Заголовок для соціальних мереж" />
<meta property="og:description" content="Опис для соціальних мереж" />
<meta property="og:image" content="https://yourdomain.com/og-image.jpg" />
<meta property="og:locale" content="uk_UA" />

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:url" content="https://yourdomain.com/" />
<meta name="twitter:title" content="Заголовок для Twitter" />
<meta name="twitter:description" content="Опис для Twitter" />
<meta name="twitter:image" content="https://yourdomain.com/twitter-image.jpg" />
```

### 7.4. SITEMAP.XML

**Location:** `public/sitemap.xml`

#### Basic Structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <!-- Homepage -->
  <url>
    <loc>https://yourdomain.com/</loc>
    <lastmod>2025-01-27</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>

    <!-- Language alternatives -->
    <xhtml:link rel="alternate" hreflang="uk-UA" href="https://yourdomain.com/" />
    <xhtml:link rel="alternate" hreflang="en-US" href="https://yourdomain.com/en" />
  </url>

  <!-- Other pages... -->
</urlset>
```

#### Next.js Auto-Generation:
```typescript
// app/sitemap.ts
import { MetadataRoute } from 'next';

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: 'https://yourdomain.com',
      lastModified: new Date(),
      changeFrequency: 'daily',
      priority: 1,
      alternates: {
        languages: {
          'uk-UA': 'https://yourdomain.com',
          'en-US': 'https://yourdomain.com/en',
        },
      },
    },
    // Add more URLs...
  ];
}
```

### 7.5. STRUCTURED DATA (Schema.org)

**Improves search results with rich snippets**

#### Organization Schema:
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Ваша компанія",
  "url": "https://yourdomain.com",
  "logo": "https://yourdomain.com/logo.png",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+380-50-123-4567",
    "contactType": "customer service",
    "availableLanguage": ["uk", "en"]
  },
  "address": {
    "@type": "PostalAddress",
    "addressCountry": "UA",
    "addressLocality": "Київ",
    "postalCode": "01001",
    "streetAddress": "вул. Хрещатик, 1"
  }
}
</script>
```

#### LocalBusiness Schema (for local businesses):
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "name": "Назва бізнесу",
  "image": "https://yourdomain.com/business.jpg",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "вул. Хрещатик, 1",
    "addressLocality": "Київ",
    "postalCode": "01001",
    "addressCountry": "UA"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "50.4501",
    "longitude": "30.5234"
  },
  "url": "https://yourdomain.com",
  "telephone": "+380501234567",
  "priceRange": "$$"
}
</script>
```

### 7.6. PERFORMANCE OPTIMIZATION (SEO Impact)

**Google ranks faster sites higher**

#### Core Web Vitals:
- **LCP (Largest Contentful Paint):** <2.5s ✅
- **FID (First Input Delay):** <100ms ✅
- **CLS (Cumulative Layout Shift):** <0.1 ✅

#### Quick Wins:
```typescript
// 1. Image optimization (Next.js)
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Опис зображення"
  width={1200}
  height={600}
  priority // For above-the-fold images
  loading="lazy" // For below-the-fold
/>

// 2. Font optimization
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin', 'cyrillic'], // Ukrainian support
  display: 'swap' // Avoid FOIT
});

// 3. Lazy loading components
import dynamic from 'next/dynamic';

const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <p>Завантаження...</p>,
  ssr: false // Client-side only
});
```

### 7.7. UKRAINIAN MARKET SEO SPECIFICS

#### Google is Primary:
- 🇺🇦 **95%+ market share** in Ukraine
- Focus SEO efforts on Google Search Console
- Bing is secondary (~2-3% share)

#### Block Russian Search Engines:
```txt
# robots.txt
User-agent: Yandex
Disallow: /

User-agent: Mail.RU_Bot
Disallow: /
```

**Why?**
- Ukrainian market policy (see Section 3)
- Compliance with wartime regulations
- Reduce unwanted traffic from russian IPs

#### Ukrainian Language SEO:
```html
<!-- Always specify UK locale -->
<html lang="uk-UA">

<!-- Not "uk" alone, full locale -->
<meta property="og:locale" content="uk_UA" />

<!-- Hreflang for multi-language sites -->
<link rel="alternate" hreflang="uk-UA" href="..." />
```

### 7.8. SEO CHECKLIST (Pre-Launch)

```markdown
SEO READINESS CHECKLIST:
- [ ] robots.txt configured (Allow: /, Sitemap declared)
- [ ] sitemap.xml generated and submitted to Google Search Console
- [ ] HTML lang="uk-UA" on all pages
- [ ] Meta title (50-60 chars) and description (150-160 chars)
- [ ] Canonical URLs on all pages
- [ ] Open Graph tags for social media
- [ ] Structured data (Organization/LocalBusiness schema)
- [ ] Mobile-friendly (responsive design)
- [ ] HTTPS enabled (SSL certificate)
- [ ] Core Web Vitals passing (LCP, FID, CLS)
- [ ] No LANG-CRITICAL violations (run //CHECK:LANG)
- [ ] Images optimized (<200KB, WebP format)
- [ ] 404 page exists
- [ ] No broken links (run link checker)
- [ ] Google Analytics / Plausible installed
```

### 7.9. GOOGLE SEARCH CONSOLE SETUP

**Essential for Ukrainian market:**

1. **Verify ownership:**
   - HTML file upload
   - Meta tag
   - Google Analytics
   - DNS TXT record

2. **Submit sitemap:**
   ```
   https://yourdomain.com/sitemap.xml
   ```

3. **Set target country:**
   - International Targeting → Ukraine (UA)

4. **Monitor:**
   - Indexing status
   - Search performance
   - Core Web Vitals
   - Mobile usability
   - Security issues

### 7.10. SEO AUTOMATION

#### Pre-deploy SEO Check:
```bash
# Run before each deployment
./scripts/seo-check.sh

# Expected output:
# ✅ robots.txt configured
# ✅ No LANG-CRITICAL violations
# ✅ Meta tags present
# ✅ Sitemap exists
```

#### CI/CD Integration:
```yaml
# .github/workflows/deploy.yml
- name: SEO Check
  run: |
    chmod +x scripts/seo-check.sh
    ./scripts/seo-check.sh

- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v9
  with:
    urls: |
      https://staging.yourdomain.com
    uploadArtifacts: true
```

### 7.11. MONITORING & ANALYTICS

#### Recommended Tools:
- **Google Search Console** (free, essential)
- **Google Analytics 4** or **Plausible Analytics** (privacy-friendly)
- **PageSpeed Insights** (performance)
- **Screaming Frog** (site audit)

#### Key Metrics to Track:
- Organic search traffic (Ukraine)
- Click-through rate (CTR) in search results
- Average position for target keywords
- Core Web Vitals scores
- Bounce rate
- Page load time

### 7.12. LANG-CRITICAL IN SEO CONTEXT

**Flexible Policy (as discussed):**

#### Hard Rules (Always Block):
- ❌ `.ru` domains in production config
- ❌ `lang="ru"` in public HTML
- ❌ Russian legal documents

#### Soft Rules (Warning + Review):
- ⚠️ Detection patterns in security tools (this is OK)
- ⚠️ Historical data in databases
- ⚠️ Names in mock data (may be russian names)

**Use `//CHECK:LANG` for automated scan before deploy**

---

## 8. FORBIDDEN TRACKING (Russian Services Protection)

### 8.1. THREAT MODEL

**WHY THIS MATTERS:**

For Ukrainian market projects, using russian tracking services is a **CRITICAL SECURITY THREAT**:

🚨 **Security Risks:**
- User data sent to russian state servers
- Potential FSB/GRU surveillance and intelligence gathering
- Code injection risk from russian CDNs
- Session hijacking via russian pixels

⚖️ **Legal Risks:**
- GDPR violations (illegal data transfers to russia)
- Ukrainian wartime regulations (citizen data protection)
- International sanctions violations
- Corporate liability and reputational damage

💼 **Business Risks:**
- Loss of customer trust
- EU market access blocked
- Payment processor sanctions
- B2B contract violations

**POLICY:** Zero tolerance for russian tracking services in production code.

---

### 8.2. BLACKLIST CATEGORIES

The framework maintains a comprehensive blacklist in [.ai/forbidden-trackers.json](.ai/forbidden-trackers.json):

#### 8.2.1. Analytics (CRITICAL)
**Threat Level:** CRITICAL - Direct state surveillance

Forbidden:
- ❌ **Яндекс.Метрика** (`metrika.yandex.ru`, `mc.yandex.ru`)
  - Pattern: `metrika.yandex`, `ym(`, `yaCounter`
- ❌ **Top.Mail.ru** (`top.mail.ru`, `top-fwz1.mail.ru`)
  - Pattern: `top.mail.ru`, `_tmr`
- ❌ **Рамблер/топ-100** (`counter.rambler.ru`)
- ❌ **LiveInternet** (`liveinternet.ru`, `counter.yadro.ru`)

✅ **Safe Alternatives:**
```typescript
// Replace Yandex.Metrika with:
import { Analytics } from '@vercel/analytics';  // Privacy-focused
// OR
import { GoogleAnalytics } from 'next-google-analytics';  // GA4
// OR
import Plausible from 'plausible-tracker';  // EU-hosted, GDPR
```

#### 8.2.2. Social Media Pixels (CRITICAL)
**Threat Level:** CRITICAL - State-controlled networks

Forbidden:
- ❌ **VK (ВКонтакте)** Pixel (`vk.com/pixel`, `VK.Retargeting`)
- ❌ **OK.ru (Одноклассники)** (`ok.ru`, `ODKL`)

✅ **Safe Alternatives:**
```html
<!-- Replace VK Pixel with: -->
<script>
  !function(f,b,e,v,n,t,s) { /* Facebook Pixel */ }
</script>
<!-- OR LinkedIn Insight Tag, Twitter Pixel -->
```

#### 8.2.3. CDN & Static Assets (HIGH)
**Threat Level:** HIGH - Code injection risk

Forbidden:
- ❌ **Yandex CDN** (`yastatic.net`, `yandex.st`)
- ❌ **Mail.ru CDN** (`imgsmail.ru`, `filin.mail.ru`)

✅ **Safe Alternatives:**
```html
<!-- Replace: -->
<script src="https://yastatic.net/jquery/3.6.0/jquery.min.js"></script>

<!-- With: -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<!-- OR Cloudflare CDN, unpkg, cdnjs -->
```

#### 8.2.4. Payment Processors (CRITICAL)
**Threat Level:** CRITICAL - Sanctions risk

Forbidden:
- ❌ **ЮKassa / Яндекс.Касса** (`yookassa.ru`, `kassa.yandex.ru`)
- ❌ **QIWI** (`qiwi.com`, `qiwi.ru`)
- ❌ **WebMoney** (`webmoney.ru`)

✅ **Safe Alternatives (Ukrainian-friendly):**
```typescript
// Replace YooKassa with:
import Stripe from 'stripe';               // International
// OR
import { WayForPay } from 'wayforpay-sdk';  // Ukrainian
// OR
import { LiqPay } from 'liqpay';            // Ukrainian (ПриватБанк)
// OR
import { Fondy } from '@fondy/api';         // Ukrainian
```

#### 8.2.5. Maps & Geolocation (HIGH)
**Threat Level:** HIGH - Location tracking

Forbidden:
- ❌ **Яндекс.Карты** (`api-maps.yandex.ru`, `ymaps`)
- ❌ **2GIS** (`2gis.ru`, `2gis.com`)

✅ **Safe Alternatives:**
```typescript
// Replace Yandex Maps with:
import { GoogleMap } from '@react-google-maps/api';  // Google Maps
// OR
import { MapContainer } from 'react-leaflet';  // OpenStreetMap (open-source)
// OR
import mapboxgl from 'mapbox-gl';  // Mapbox
```

#### 8.2.6. Video Hosting (CRITICAL)
**Threat Level:** CRITICAL - Propaganda platform

Forbidden:
- ❌ **Rutube** (`rutube.ru`)
- ❌ **VK Video** (`vk.com/video`, `vkvideo.ru`)

✅ **Safe Alternatives:**
```typescript
// Use YouTube or Vimeo
<iframe src="https://www.youtube.com/embed/VIDEO_ID" />
<iframe src="https://player.vimeo.com/video/VIDEO_ID" />
```

#### 8.2.7. E-commerce Integrations (HIGH)
**Threat Level:** HIGH - Sanctions, business risk

Forbidden:
- ❌ **Wildberries** SDK (`wildberries.ru`, `wbstatic.net`)
- ❌ **Ozon** SDK (`ozon.ru`)

✅ **Safe Alternatives:**
```typescript
// Replace with international/Ukrainian platforms:
import Shopify from '@shopify/shopify-api';        // International
// OR
import { PromUA } from 'prom-ua-api';               // Ukrainian
// OR WooCommerce (WordPress), Magento
```

#### 8.2.8. Search Widgets (HIGH)
**Threat Level:** HIGH - Query tracking

Forbidden:
- ❌ **Yandex Search** (`yandex.ru/search`, `site.yandex.ru`)

✅ **Safe Alternatives:**
```typescript
// Replace with:
import algoliasearch from 'algoliasearch';  // Algolia (advanced)
// OR
<script async src="https://cse.google.com/cse.js?cx=YOUR_ID"></script>  // Google Custom Search
// OR self-hosted Elasticsearch
```

#### 8.2.9. Fonts (MEDIUM)
**Threat Level:** MEDIUM - Tracking via font loading

Forbidden:
- ❌ **Yandex Fonts** (`fonts.yandex.ru`)

✅ **Safe Alternatives:**
```html
<!-- Replace with: -->
<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
<!-- OR Bunny Fonts (GDPR-compliant Google Fonts proxy) -->
<!-- OR self-hosted fonts -->
```

#### 8.2.10. CAPTCHA (HIGH)
**Threat Level:** HIGH - Behavior tracking

Forbidden:
- ❌ **Yandex SmartCaptcha** (`smartcaptcha.yandexcloud.net`)

✅ **Safe Alternatives:**
```typescript
// Replace with:
import ReCAPTCHA from "react-google-recaptcha";  // Google reCAPTCHA v3
// OR
import HCaptcha from '@hcaptcha/react-hcaptcha';  // hCaptcha (privacy-focused)
// OR
import { Turnstile } from '@marsidev/react-turnstile';  // Cloudflare Turnstile
```

---

### 8.3. DETECTION MECHANISMS

The framework provides **3-layer detection**:

#### Layer 1: Pre-commit Hook (BLOCKS commits)
```bash
# .git/hooks/pre-commit
# Automatically scans staged files for russian trackers
# BLOCKS commit if trackers detected
# Shows safe alternatives
```

**What it checks:**
- Script src tags with russian domains
- JavaScript tracker code (`ym(`, `VK.Retargeting`, etc.)
- Payment processor integrations
- CDN URLs

**Behavior:**
- ✅ Clean code → Commit proceeds
- ❌ Tracker detected → **COMMIT BLOCKED** with alternatives shown

#### Layer 2: SEO Check Script (PRE-DEPLOY audit)
```bash
# Run before deployment:
./scripts/seo-check.sh /path/to/project

# Check 8: Russian Tracking Services
# ✅ No russian trackers detected
# OR
# ❌ RUSSIAN TRACKER: src/pages/index.tsx:42
#    Pattern: metrika.yandex
#    Threat: Data sent to russian servers

# Check 9: NPM Packages (NEW in v2.0!)
# ✅ No forbidden packages in dependencies
# OR
# ❌ FORBIDDEN NPM PACKAGES DETECTED!
#    yandex-metrika (Yandex Metrika) - CRITICAL
#    Alternatives: plausible.io, google-analytics
```

**What it checks:**
- All HTML/JS/JSX/TS/TSX files in project
- **NPM dependencies in package.json** (NEW!)
- 40+ patterns across 10 categories
- Reports threat level (CRITICAL/HIGH/MEDIUM)
- Shows migration alternatives with specific package recommendations

#### Layer 3: Centralized Blacklist (v2.0 - Enhanced Structure)
```json
// .ai/forbidden-trackers.json v2.0
{
  "$schema": "./forbidden-services-schema.json",
  "version": "2.0.0",
  "categories": [
    {
      "id": "analytics",
      "name": "Аналітика та трекінг (CRITICAL)",
      "services": [
        {
          "id": "yandex-metrika",
          "name": "Yandex Metrika",
          "domains": ["mc.yandex.ru", ...],
          "patterns": ["metrika\\.yandex", ...],  // Regex for code scanning
          "npmPackages": ["yandex-metrika", "ym"],  // NEW! For package.json
          "risk": "CRITICAL",
          "reason": "...",
          "alternatives": ["Plausible", "Google Analytics 4"],
          "replacement_guide": { "from": "...", "to": "..." }
        }
      ]
    }
  ],
  "whitelist": { ... },
  "legal_compliance": { ... }
}
```

**Benefits:**
- Single source of truth
- **NPM package detection** (prevents supply-chain attacks)
- Category-based organization (easier navigation)
- Detailed service metadata (risk levels, reasons, alternatives)
- Replacement guides with code examples
- Shared across all checks
- JSON Schema validation support

---

### 8.4. MIGRATION GUIDE

#### Step 1: Audit Existing Project
```bash
# Run SEO check to find all russian trackers:
./scripts/seo-check.sh /path/to/existing/project

# Review output:
# ❌ RUSSIAN TRACKER: src/app/layout.tsx:12
#    Pattern: metrika.yandex
```

#### Step 2: Identify Category
Reference [.ai/forbidden-trackers.json](.ai/forbidden-trackers.json) to find:
- Threat level (CRITICAL/HIGH/MEDIUM)
- Why it's dangerous
- Safe alternatives
- Code examples

#### Step 3: Replace Tracker
**Example: Yandex.Metrika → Google Analytics 4**

Before:
```html
<!-- Remove this: -->
<script src="https://mc.yandex.ru/metrika/tag.js"></script>
<script>
  ym(123456, "init", { /* ... */ });
</script>
```

After:
```typescript
// Add this:
import { GoogleAnalytics } from 'next-google-analytics';

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <GoogleAnalytics trackPageViews />
        {children}
      </body>
    </html>
  );
}
```

#### Step 4: Update Environment Variables
```bash
# .env (add to .gitignore!)
NEXT_PUBLIC_GA_MEASUREMENT_ID=G-XXXXXXXXXX

# Remove old russian credentials:
# YANDEX_METRIKA_ID=123456  ← DELETE THIS
```

#### Step 5: Verify Clean
```bash
# Run checks again:
./scripts/seo-check.sh .

# Expected:
# ✅ [8] Checking russian tracking services... No russian trackers detected
```

#### Step 6: Test in Production
- Verify analytics still work
- Check no russian requests in Network tab (DevTools)
- Confirm GDPR compliance

**Typical migration time:** 1-2 hours per tracker category

---

### 8.5. LEGAL COMPLIANCE

#### 8.5.1. Ukrainian Law
**Basis:** Wartime regulations protect citizen data from hostile state surveillance

**Risk:** Using russian services exposes Ukrainian users to russian intelligence

**Penalties:**
- Reputational damage
- Legal liability
- Sanctions violations
- B2B contract breaches

#### 8.5.2. GDPR (EU Regulation)
**Issue:** Russian services do NOT comply with GDPR Article 44-50 (international data transfers)

**Violations:**
- ❌ Data transfers to russia without adequacy decision
- ❌ No valid Standard Contractual Clauses (SCCs)
- ❌ No user consent for surveillance

**Solution:** Use EU/US-based services (Google, Cloudflare, Stripe, etc.)

#### 8.5.3. International Sanctions
**Financial:** Many russian services under US/EU sanctions:
- Payment processors (YooKassa, QIWI, WebMoney)
- Banks (Sberbank, VTB)
- Technology companies (Yandex, Mail.ru Group)

**Risk:** Business account closure, legal penalties

---

### 8.6. SEO IMPACT (Myth-Busting)

#### ❌ MYTH: "Blocking Yandex hurts SEO"
✅ **REALITY:** Yandex has <1% market share in Ukraine. Google dominates 95%+. **Zero SEO impact.**

**Data:**
- Google Search: 95.6% (Ukraine, 2025)
- Bing: 2.1%
- Yandex: 0.8%
- Other: 1.5%

**Conclusion:** Optimizing for Yandex is wasted effort. Focus on Google.

#### ❌ MYTH: "Need Яндекс.Метрика for analytics"
✅ **REALITY:** Google Analytics 4 provides:
- Same data (+ better international insights)
- GDPR compliance
- Faster page load (no russian CDN delays)
- Better integration with Google Ads

#### ❌ MYTH: "Russian CDN is faster"
✅ **REALITY:** Cloudflare/jsDelivr are **FASTER** for Ukrainian users:
- Servers closer to Ukraine (EU/US)
- No sanctions-related routing issues
- Better Core Web Vitals scores

**Benchmark (Kyiv → CDN latency):**
- yastatic.net (Yandex): ~80ms
- cdn.jsdelivr.net: ~25ms ✅
- cdnjs.cloudflare.com: ~22ms ✅

**CONCLUSION:** Removing russian trackers **IMPROVES** SEO, not harms it.

---

### 8.7. INTEGRATION WITH WORKFLOW

#### Pre-commit (Automatic)
```bash
# Runs automatically on `git commit`
# BLOCKS commit if russian trackers detected
# Bypass (emergency only): git commit --no-verify
```

#### Pre-deploy (Manual/CI)
```bash
# Run before deploying to production:
./scripts/seo-check.sh

# CI/CD integration:
# .github/workflows/deploy.yml
- name: Check Russian Trackers
  run: ./scripts/seo-check.sh
  # Fails pipeline if trackers found
```

#### Code Review Checklist
```markdown
## Security Review
- [ ] No russian tracking scripts
- [ ] No .ru domains in config
- [ ] Payment processor is sanctions-safe
- [ ] CDN is EU/US-based
- [ ] Analytics is GDPR-compliant
```

#### Client Onboarding
When taking over existing project:
1. Run `./scripts/seo-check.sh /path/to/client/project`
2. Document all russian trackers found
3. Estimate migration effort (1-2 hours per category)
4. Present alternatives to client
5. Get approval for migration
6. Execute migration
7. Verify clean with second scan

---

### 8.8. FALSE POSITIVES & EXCEPTIONS

**Legitimate Use Cases (don't block):**

✅ **Security Tools:**
- Detection patterns in `pre-commit` hook (self-reference)
- Blacklist in `.ai/forbidden-trackers.json` (documentation)
- SEO check script (scanning patterns)

✅ **Documentation:**
- Examples showing what NOT to do
- Migration guides with "before" code
- Security training materials

✅ **Historical Data:**
- Mock data with russian names (Иванов, Петров)
- Ukrainian/Russian bilingual content (if targeting diaspora)

**How to handle:**
```typescript
// Mark legitimate usage:
// TRACKER-EXCEPTION: Documentation example
const badExample = "https://metrika.yandex.ru/tag.js";  // Don't use this!
```

**Pre-commit hook already whitelists:**
- `.ai/forbidden-trackers.json`
- `scripts/seo-check.sh`
- `.git/hooks/pre-commit`

---

### 8.9. UPDATING THE BLACKLIST

As new russian services emerge:

#### Step 1: Add to forbidden-trackers.json (v2.0 structure)
```json
{
  "categories": [
    {
      "id": "new_category",
      "name": "Category Name (RISK LEVEL)",
      "description": "What this category represents",
      "services": [
        {
          "id": "service-id",
          "name": "Service Name",
          "domains": ["example.ru"],
          "patterns": ["example\\.ru"],
          "npmPackages": ["npm-package-name"],  // NEW! Add if has npm package
          "risk": "CRITICAL",
          "reason": "Why it's dangerous",
          "alternatives": ["Safe Alternative 1", "Safe Alternative 2"]
        }
      ]
    }
  ]
}
```

#### Step 2: Update pre-commit hook
```bash
# .git/hooks/pre-commit
TRACKER_PATTERNS=(
    # ... existing patterns ...
    "example\\.ru"  # NEW: Description
)
```

#### Step 3: Update seo-check.sh
Already reads patterns from pre-commit structure (no change needed).

#### Step 4: Document in RULES_PRODUCT.md
Add to Section 8.2 (this document).

#### Step 5: Commit Changes
```bash
git add .ai/forbidden-trackers.json .git/hooks/pre-commit RULES_PRODUCT.md
git commit -m "security: add new russian tracker to blacklist"
```

---

### 8.10. REFERENCES

**Legal:**
- GDPR Article 44-50 (International Transfers)
- Ukrainian Wartime Regulations (citizen data protection)
- US/EU Sanctions Lists

**Technical:**
- [.ai/forbidden-trackers.json](.ai/forbidden-trackers.json) - Full blacklist
- [.git/hooks/pre-commit](.git/hooks/pre-commit) - Automated blocking
- [scripts/seo-check.sh](scripts/seo-check.sh) - Pre-deploy audit

**Alternatives:**
- Analytics: Google Analytics, Plausible, Matomo
- Social: Facebook Pixel, LinkedIn Insight Tag
- CDN: Cloudflare, jsDelivr, unpkg
- Payments: Stripe, WayForPay (UA), LiqPay (UA)
- Maps: Google Maps, OpenStreetMap, Mapbox

---

## 9. CYBER DEFENSE (Ukrainian Market Security)

### 9.1. THREAT MODEL

**Reality Check (2024-2026):**

Ukrainian companies ARE active targets for:
- 🔴 **DDoS attacks** - Daily for major sites, sporadic for SMBs
- 🔴 **Data exfiltration** - Russian intelligence agencies target Ukrainian user data
- 🔴 **Supply chain attacks** - Compromised npm packages, CDN injections
- 🟠 **Phishing campaigns** - Targeted at employees, clients
- 🟠 **Reputation attacks** - False accusations, social media campaigns

**You ARE a target if:**
- Ukrainian company (ТОВ, ФОП, etc.)
- Processing Ukrainian citizen data
- B2B/B2C with Ukrainian clients
- Public-facing service (website, API, mobile app)
- Fintech, healthcare, government contractors (HIGH PRIORITY targets)

**This is NOT paranoia. This is 2026 reality.**

---

### 9.2. MANDATORY PROTECTIONS

#### Layer 1: Infrastructure (FREE tier sufficient)

**Cloudflare Proxy (REQUIRED):**
```nginx
# Setup: cloudflare.com → Add site → Update DNS → Orange cloud ON

Benefits (FREE plan):
✅ DDoS protection (automatic, unlimited)
✅ WAF (Web Application Firewall)
✅ Bot protection
✅ Rate limiting (10 req/sec per IP default)
✅ SSL/TLS encryption
✅ CDN (faster page load)

# Additional: Block russian IP ranges
Cloudflare Dashboard → Security → WAF → Custom Rules:
  Rule: Block country = RU, BY
  Action: Block
```

**Why Cloudflare:**
- Absorbs 99% of DDoS attacks automatically
- FREE tier sufficient for SMBs (<100k visitors/month)
- Takes 10 minutes to setup
- **Cost:** $0/month

**Alternative:** Nginx rate limiting (self-hosted):
```nginx
# /etc/nginx/nginx.conf
limit_req_zone $binary_remote_addr zone=req_limit:10m rate=10r/s;

server {
  # Block russian IP ranges (updated list)
  include /etc/nginx/block-russia.conf;

  # Rate limiting
  limit_req zone=req_limit burst=20 nodelay;

  # DDoS protection headers
  add_header X-Frame-Options "DENY" always;
  add_header X-Content-Type-Options "nosniff" always;
}
```

---

#### Layer 2: Application Security

**Content Security Policy (CSP) - CRITICAL:**
```typescript
// middleware/security.ts or next.config.js
export const securityHeaders = {
  'Content-Security-Policy': [
    "default-src 'self'",
    "script-src 'self' https://trusted-cdn.com",
    "connect-src 'self' https://api.yourdomain.com",
    "img-src 'self' data: https:",
    "style-src 'self' 'unsafe-inline'",  // Only if necessary

    // CRITICAL: Prevent data exfiltration
    "form-action 'self'",  // No form submission to external sites
    "frame-ancestors 'none'",  // Prevent clickjacking
    "block-all-mixed-content",  // Force HTTPS
    "upgrade-insecure-requests"
  ].join('; '),

  // Additional headers
  'X-Frame-Options': 'DENY',
  'X-Content-Type-Options': 'nosniff',
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'geolocation=(), microphone=(), camera=()',

  // HSTS (force HTTPS for 1 year)
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload'
};
```

**Why CSP matters:**
- Blocks russian tracking scripts (even if bypassed pre-commit)
- Prevents XSS attacks
- Stops data exfiltration to external domains

**Supply Chain Protection:**
```json
// package.json - Add security checks
{
  "scripts": {
    "preinstall": "npx lockfile-lint --type npm --path package-lock.json",
    "audit": "npm audit --audit-level=moderate",
    "check-deps": "npx better-npm-audit audit"
  }
}
```

**NPM Best Practices:**
```bash
# Before installing any package:
1. Check package age: >1 year = safer
2. Check downloads: >100k/week = popular, reviewed
3. Check repo: GitHub stars, last commit, maintainer
4. Avoid: .ru domains in repo, russian maintainers (sad but true)

# Example:
npm view yandex-metrika  # Check before install
```

---

#### Layer 3: Monitoring & Alerts

**Real-time Security Monitoring:**
```typescript
// lib/security-monitor.ts
export function initSecurityMonitoring() {
  // Monitor for suspicious patterns

  // 1. Russian IP detection
  app.use((req, res, next) => {
    const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    const country = geoip.lookup(ip)?.country;

    if (country === 'RU' || country === 'BY') {
      logSecurityEvent({
        type: 'BLOCKED_HOSTILE_IP',
        ip: ip,
        country: country,
        url: req.url,
        timestamp: new Date()
      });

      return res.status(403).json({ error: 'Access denied' });
    }

    next();
  });

  // 2. Rate limit exceeded
  app.use((req, res, next) => {
    // If Cloudflare/nginx rate limit bypassed somehow
    const key = req.ip;
    const requests = requestCount.get(key) || 0;

    if (requests > 100) {  // 100 req/minute = suspicious
      alertAdmins('Rate limit abuse detected', { ip: req.ip });
    }

    next();
  });

  // 3. Data export monitoring
  app.get('/api/users/export', async (req, res) => {
    // Log ALL data export requests (GDPR requirement + security)
    await logAuditEvent({
      type: 'DATA_EXPORT',
      user: req.user.id,
      ip: req.ip,
      timestamp: new Date(),
      reason: req.body.reason || 'Not provided'
    });

    // Alert if unusual pattern (e.g., 10+ exports in hour)
    if (recentExports > 10) {
      alertAdmins('Unusual data export activity', { user: req.user.id });
    }

    // ... proceed with export
  });
}
```

**Alert Channels:**
```typescript
// Notify admins immediately
function alertAdmins(message: string, context: any) {
  // Email
  sendEmail({
    to: ['security@company.com', 'cto@company.com'],
    subject: `🚨 Security Alert: ${message}`,
    body: JSON.stringify(context, null, 2)
  });

  // Telegram (instant)
  sendTelegram({
    chatId: process.env.SECURITY_TELEGRAM_CHAT,
    text: `🚨 ${message}\n${JSON.stringify(context)}`
  });

  // Sentry / Rollbar
  Sentry.captureMessage(message, {
    level: 'error',
    extra: context
  });
}
```

---

### 9.3. INCIDENT RESPONSE PLAN

**Scenario 1: DDoS Attack (Service Unavailable)**

**Detection:**
- Traffic spike >1000x normal
- Server response time >5 seconds
- Cloudflare "Under Attack" mode triggered

**Response (Automatic):**
1. Cloudflare absorbs attack (no action needed usually)
2. If overwhelmed → Manual: Enable "I'm Under Attack Mode"
   - Cloudflare Dashboard → Security → Settings → Security Level: I'm Under Attack

**Response (Manual, if Cloudflare fails):**
1. **Switch to maintenance mode:**
   ```nginx
   # nginx: Serve static page only
   return 503;
   error_page 503 /maintenance.html;
   ```

2. **Activate backup:**
   - Secondary domain (different registrar)
   - GitHub Pages static site (announcements)

3. **Communication:**
   - Post on social media: "We're experiencing technical difficulties. Working to restore service."
   - Email subscribers (if possible)

**Recovery time:** <1 hour (usually automatic via Cloudflare)

**Post-incident:**
- Review logs (identify attacker patterns)
- Update Cloudflare rules (block specific patterns)
- Consider upgrading to Cloudflare Pro ($20/month) if attacks persist

---

**Scenario 2: Data Breach (Sensitive Data Exposed)**

**Detection:**
- Unusual database queries
- Large data export requests
- User reports unauthorized access
- Sentry alerts on suspicious activity

**Response (IMMEDIATE, <1 hour):**

1. **ISOLATE** - Disconnect affected systems:
   ```bash
   # Take server offline temporarily
   systemctl stop nginx
   systemctl stop app-service
   ```

2. **ASSESS** - Scope of breach:
   - Which data? (users, payments, passwords, etc.)
   - How many records?
   - When did breach occur? (check logs)
   - How was access gained? (vulnerability, stolen credentials, etc.)

3. **PRESERVE** - Evidence (for investigation):
   ```bash
   # Backup logs immediately
   tar -czf incident-$(date +%Y%m%d-%H%M%S).tar.gz /var/log/

   # Database snapshot
   pg_dump database > breach-snapshot-$(date +%Y%m%d).sql
   ```

4. **NOTIFY** - Legal obligations (Ukraine + GDPR):
   - **Users:** Email affected users "without undue delay" (GDPR Art. 34)
     - What data was exposed
     - When it happened
     - What you're doing about it
     - What they should do (change passwords, monitor accounts)

   - **Уповноважений (Commissioner):** Within 72 hours (GDPR Art. 33)
     - Online: https://pd.gov.ua/notification/
     - Include: nature of breach, affected data, measures taken

   - **Cyberpolice:** Report to https://cyberpolice.gov.ua
     - Evidence: logs, snapshots, attacker IPs

   - **Media:** Only if breach affects >100k users or high-profile

5. **FIX** - Patch vulnerability:
   - Identify entry point (SQL injection, XSS, stolen credentials, etc.)
   - Deploy fix
   - Rotate ALL credentials (database, API keys, admin passwords)
   - Force password reset for all users

6. **MONITOR** - Extra vigilance (30 days):
   - Watch for repeat attacks
   - Monitor dark web (is your data being sold?)
   - Track user complaints

**Recovery time:** 2-4 hours (system back online), 1-2 weeks (full resolution)

**Legal consequences:**
- GDPR fine: Up to €20M or 4% annual revenue (whichever higher)
- Ukrainian law: Up to 3% annual revenue
- **Reality:** SMBs usually get warnings first, not fines (if you notify promptly)

---

**Scenario 3: Reputation Attack (False Accusations)**

**Detection:**
- Social media posts claiming "data leak", "russian trackers", etc.
- Negative reviews on DOU, Glassdoor, Google
- Articles on tech blogs

**Response (CALM, <24 hours):**

1. **DOCUMENT** - Save evidence:
   - Screenshots of all claims (before they're deleted)
   - Archive URLs (web.archive.org)
   - Note: date, author, platform

2. **VERIFY** - Is claim true?
   ```bash
   # Check audit logs
   tail -n 1000 .ai/audit-trail.log | grep "RUSSIAN"

   # Check git history
   git log --all --grep="yandex\|metrika\|vk\.com" --oneline

   # Run framework checks
   ./scripts/seo-check.sh .
   ```

3. **RESPOND** - Public statement (if claim is FALSE):
   ```markdown
   Public Response Template:

   "We investigated the claim of [accusation].

   Our audit trail shows:
   - Framework blocked [service] on [date] (see attached log)
   - Pre-commit hook triggered (see git history)
   - All checks passed (see seo-check.sh output)

   We take security seriously. Our framework (open-source,
   community-reviewed) enforces Ukrainian market standards.

   Full audit log: [link to public gist with redacted sensitive info]
   Framework: https://github.com/Shamavision/ai-workflow-rules

   We welcome independent audits."
   ```

4. **LEGAL** - If defamation:
   - Consult lawyer (if damages significant)
   - Send cease-and-desist letter
   - Consider lawsuit (as last resort)

**Recovery time:** 1-2 days (respond), 1-2 weeks (reputation stabilizes)

**Prevention:**
- Maintain audit trail (proof you did your job)
- Be transparent (open-source helps)
- Respond quickly (silence = guilt in public opinion)

---

**Scenario 4: Regulatory Inquiry (Government Questions)**

**Detection:**
- Official letter from Уповноважений (Commissioner)
- Email from tax authorities (DPS)
- Phone call from cyberpolice

**Response (PROFESSIONAL, <72 hours):**

1. **DON'T PANIC**
   - Having framework = good faith effort
   - Inquiry ≠ accusation
   - Cooperation = mitigation

2. **GATHER EVIDENCE:**
   - Audit trail logs (`.ai/audit-trail.log`)
   - Framework documentation (RULES_PRODUCT.md)
   - Git history (shows implementation of security measures)
   - Pre-commit hook configuration
   - seo-check.sh reports (if saved)

3. **LEGAL CONSULTATION**
   - DO NOT respond officially without lawyer review
   - Show evidence to lawyer first
   - Prepare response together

4. **RESPOND OFFICIALLY:**
   ```markdown
   Response Template (lawyer-approved):

   "In response to inquiry [number], we provide:

   1. Security Measures Implemented:
      - Open-source security framework (ai-workflow-rules v8.0)
      - Automated pre-commit scanning (russian content blocked)
      - Pre-deploy validation (seo-check.sh)
      - Continuous monitoring (audit trail)

   2. Evidence of Compliance:
      - Audit trail logs (attached, [dates])
      - Git commit history (shows security commits)
      - Framework documentation (transparent, public)

   3. Good Faith Effort:
      - Industry best practices applied
      - Community-reviewed framework (GitHub public)
      - Zero tolerance policy for russian services

   We remain available for further questions.

   [Company name], [authorized representative]"
   ```

5. **COOPERATE**
   - Answer questions honestly
   - Provide requested documents
   - Show willingness to improve

**Recovery time:** 1-2 weeks (inquiry resolution)

**Outcome (if good faith shown):**
- Warning (first offense, minor issues)
- Recommendation to improve (specific items)
- No penalties (if cooperation + evidence of effort)

---

### 9.4. BUSINESS CONTINUITY

**Backup Infrastructure:**
```yaml
# docker-compose.backup.yml
# Deploy to different region (EU, US)

services:
  app-backup:
    image: your-app:latest
    environment:
      - DATABASE_URL=${BACKUP_DB_URL}
      - CLOUDFLARE_ZONE=${BACKUP_ZONE}

  # Secondary database (replica)
  db-backup:
    image: postgres:15
    volumes:
      - backup-data:/var/lib/postgresql/data
```

**Failover Plan:**
```markdown
IF primary site down:
1. Update DNS (point to backup server)
   - TTL: 300 seconds (5 min propagation)

2. Activate backup database (read replica → primary)

3. Update Cloudflare proxy (if needed)

4. Test critical paths:
   - Login works
   - Payment processing works
   - Data accessible

RECOVERY TIME: <15 minutes
```

**Communication Plan:**
```markdown
IF service unavailable >1 hour:

1. Post on social media (Facebook, LinkedIn, Twitter/X):
   "We're experiencing technical difficulties.
    Our team is working to restore service.
    ETA: [estimate].
    Updates every 30 min."

2. Email subscribers:
   Subject: "Service Status Update"
   Body: Transparent explanation, ETA, apology

3. Website banner (if accessible):
   "Service degraded. Restoration in progress."

4. Status page (if you have one):
   Update status.yourdomain.com

FREQUENCY: Update every 30 minutes until resolved
```

---

### 9.5. SECURITY CHECKLIST (Pre-Launch)

```markdown
CYBER DEFENSE READINESS CHECKLIST:

Infrastructure:
- [ ] Cloudflare proxy enabled (orange cloud ON)
- [ ] DDoS protection active (auto)
- [ ] Russian IP ranges blocked (Cloudflare rule)
- [ ] Rate limiting configured (10 req/sec default)
- [ ] SSL/TLS certificate valid (A+ rating on ssllabs.com)

Application:
- [ ] Content-Security-Policy header configured
- [ ] Security headers present (X-Frame-Options, HSTS, etc.)
- [ ] Form actions restricted to same domain
- [ ] No russian CDN URLs in code
- [ ] lockfile-lint in preinstall hook
- [ ] npm audit passing (no HIGH/CRITICAL vulns)

Monitoring:
- [ ] Error tracking configured (Sentry/Rollbar)
- [ ] Security alerts configured (email + Telegram)
- [ ] Audit trail logging active
- [ ] Unusual traffic monitoring (russian IPs, rate limit abuse)

Incident Response:
- [ ] Incident response plan documented (this section)
- [ ] Team trained (knows who to contact, what to do)
- [ ] Backup infrastructure tested (failover works)
- [ ] Communication templates ready (social media, email)
- [ ] Legal contacts ready (lawyer, cyberpolice, Commissioner)

Compliance:
- [ ] GDPR compliance verified (privacy policy, cookie consent)
- [ ] Ukrainian law compliance (data retention, AML if fintech)
- [ ] Audit trail proves security efforts
```

---

### 9.6. COST ESTIMATE

**Cyber Defense Budget (Monthly):**

```
FREE Tier (Sufficient for SMBs):
- Cloudflare Free:              $0
- GitHub (public repo):         $0
- npm audit:                    $0
- Pre-commit hooks:             $0
- Nginx rate limiting:          $0
                                ----
TOTAL (Minimal):                $0/month

Recommended Tier (Better protection):
- Cloudflare Pro:               $20
- Sentry (error tracking):      $0 (free tier: 5k events/month)
- VPS backup (Hetzner):         €5 ($5.50)
- Monitoring (UptimeRobot):     $0 (free tier)
                                ----
TOTAL (Recommended):            ~$26/month

Enterprise Tier (Large scale):
- Cloudflare Business:          $200
- Sentry Business:              $80
- Dedicated backup infra:       $50
- 24/7 SOC monitoring:          $500+
                                ----
TOTAL (Enterprise):             $830+/month
```

**ROI:**
- One prevented DDoS attack: Saves $1000-10,000 (downtime cost)
- One prevented data breach: Saves $10,000-100,000+ (fines + reputation)
- **Conclusion:** $26/month is cheap insurance.

---

### 9.7. REFERENCES & TOOLS

**Official:**
- Уповноважений із захисту персональних даних: https://pd.gov.ua
- Кіберполіція України: https://cyberpolice.gov.ua
- CERT-UA (Computer Emergency Response Team): https://cert.gov.ua

**Tools (FREE):**
- Cloudflare: https://cloudflare.com (DDoS protection)
- SSL Labs: https://ssllabs.com/ssltest/ (SSL audit)
- Security Headers: https://securityheaders.com (header audit)
- Mozilla Observatory: https://observatory.mozilla.org (security scan)
- OWASP ZAP: https://zaproxy.org (penetration testing)

**Monitoring:**
- Sentry: https://sentry.io (error tracking)
- UptimeRobot: https://uptimerobot.com (uptime monitoring)
- Cloudflare Analytics (included in free plan)

**IP Blocklists:**
- Russian IP ranges: https://www.ip2location.com/free/russia-ip-address-ranges
- Tor exit nodes: https://check.torproject.org/exit-addresses
- Known attack IPs: https://www.abuseipdb.com

---

**This section added 2026-02-03 to address active cyber threats against Ukrainian businesses.**

---

## CHANGELOG
*   **v1.4** [2026-02-03] – **SECURITY CRITICAL:** Added Section 9: CYBER DEFENSE (Ukrainian Market Security). Comprehensive threat model (DDoS, data breaches, reputation attacks), 3-layer protection (infrastructure, application, monitoring), 4 incident response scenarios, business continuity planning. Added pre-commit audit trail logging (legal protection evidence). Total: 900+ lines of real-world security guidance for Ukrainian companies under active cyber threat.
*   **v1.3** [2026-01-31] – Enhanced Section 8: forbidden-trackers.json v2.0 with npmPackages support, category-based structure, improved seo-check.sh with package.json scanning
*   **v1.2** [2025-01-27] – Added Section 8: FORBIDDEN TRACKING (Russian Services Protection)
*   **v1.1** [2025-01-27] – Added Section 7: SEO/GEO Strategy (Ukrainian market)
*   **v1.0** [2025-01-26] – Initial product rules: i18n strategy, device adaptation, Ukrainian market policy, accessibility, scalability

---

*Stored in public repo (open source). Last updated: 2026-02-03*