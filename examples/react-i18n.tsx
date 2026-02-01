/**
 * Example: i18n-Ready React Component
 *
 * This component demonstrates proper internationalization (i18n) patterns
 * following RULES_PRODUCT.md Section 1 (i18n Strategy).
 *
 * ✅ GOOD practices shown here:
 * - No hardcoded text strings
 * - Uses t() function for all user-facing text
 * - Supports variable interpolation
 * - Pluralization ready
 * - Date/currency formatting via Intl API
 *
 * ❌ BAD practices avoided:
 * - Hardcoded strings like "Submit" or "Cancel"
 * - String concatenation ("Hello " + userName)
 * - Hardcoded date formats ("DD.MM.YYYY")
 */

import { useTranslation } from 'react-i18next';

interface UserProfileProps {
  userName: string;
  itemCount: number;
  lastLoginDate: Date;
  accountBalance: number;
}

export function UserProfile({
  userName,
  itemCount,
  lastLoginDate,
  accountBalance
}: UserProfileProps) {
  const { t, i18n } = useTranslation();

  // ✅ GOOD: Format date using Intl API (locale-aware)
  const formattedDate = new Intl.DateTimeFormat(i18n.language, {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(lastLoginDate);

  // ✅ GOOD: Format currency using Intl API
  const formattedBalance = new Intl.NumberFormat(i18n.language, {
    style: 'currency',
    currency: 'UAH' // Ukrainian Hryvnia
  }).format(accountBalance);

  return (
    <div className="user-profile">
      {/* ✅ GOOD: Use t() with variable interpolation */}
      <h1>{t('profile.greeting', { name: userName })}</h1>

      {/* ✅ GOOD: Pluralization (automatically handles 1 item / 2 items / 5 items) */}
      <p>{t('profile.itemCount', { count: itemCount })}</p>

      {/* ✅ GOOD: Formatted date (locale-aware) */}
      <p>{t('profile.lastLogin')}: {formattedDate}</p>

      {/* ✅ GOOD: Formatted currency */}
      <p>{t('profile.balance')}: {formattedBalance}</p>

      {/* ✅ GOOD: Button labels from translations */}
      <div className="actions">
        <button className="primary">
          {t('common.save')}
        </button>
        <button className="secondary">
          {t('common.cancel')}
        </button>
      </div>
    </div>
  );
}

/**
 * Corresponding locale file: locales/uk-UA/profile.json
 *
 * {
 *   "profile": {
 *     "greeting": "Привіт, {{name}}!",
 *     "itemCount_one": "{{count}} елемент",
 *     "itemCount_few": "{{count}} елементи",
 *     "itemCount_many": "{{count}} елементів",
 *     "lastLogin": "Останній вхід",
 *     "balance": "Баланс"
 *   },
 *   "common": {
 *     "save": "Зберегти",
 *     "cancel": "Скасувати"
 *   }
 * }
 */

/**
 * ❌ BAD EXAMPLE (what NOT to do):
 *
 * export function BadUserProfile({ userName, itemCount }: Props) {
 *   return (
 *     <div>
 *       <h1>Привіт, {userName}!</h1>  // ❌ Hardcoded Ukrainian text
 *       <p>У вас {itemCount} елементів</p>  // ❌ No pluralization
 *       <button>Зберегти</button>  // ❌ Hardcoded button label
 *     </div>
 *   );
 * }
 *
 * Problems:
 * - Can't switch to English/other languages
 * - Pluralization broken (1 елементів instead of 1 елемент)
 * - Hard to maintain (text scattered across components)
 */
