/**
 * ===========================================================================
 * ENVIRONMENT VALIDATION & TYPE-SAFE ENV VARS
 * AI Workflow Rules Framework v4.0
 * ===========================================================================
 *
 * PURPOSE:
 *   Validate environment variables at runtime and provide type-safe access
 *
 * USAGE:
 *   import { env, validateEnv } from '@/lib/env';
 *
 *   // Validate on app startup:
 *   validateEnv();
 *
 *   // Access env vars (type-safe):
 *   const apiKey = env.ANTHROPIC_API_KEY;
 *   const isDev = env.NODE_ENV === 'development';
 *
 * BENEFITS:
 *   - Type safety (TypeScript autocomplete)
 *   - Runtime validation (fail fast on startup)
 *   - Clear error messages (missing/invalid vars)
 *   - No typos (compile-time checks)
 *
 * SECURITY:
 *   - Never log actual values
 *   - Client-side vars prefixed with NEXT_PUBLIC_
 *   - Server-side vars never exposed to client
 *
 * ===========================================================================
 */

// ===========================================================================
// ENVIRONMENT SCHEMA
// ===========================================================================

/**
 * Define your environment variables here
 *
 * Convention:
 *   - NEXT_PUBLIC_* = Client-side accessible
 *   - All others = Server-side only
 */
interface EnvironmentVariables {
  // Node environment
  NODE_ENV: 'development' | 'production' | 'test';

  // App configuration
  NEXT_PUBLIC_APP_URL: string;
  NEXT_PUBLIC_APP_NAME?: string;

  // AI API Keys (server-side only!)
  ANTHROPIC_API_KEY?: string;
  OPENAI_API_KEY?: string;

  // Database (server-side)
  DATABASE_URL?: string;

  // Authentication (server-side)
  NEXTAUTH_URL?: string;
  NEXTAUTH_SECRET?: string;

  // Analytics (client-side)
  NEXT_PUBLIC_ANALYTICS_ID?: string;

  // Feature flags (client-side)
  NEXT_PUBLIC_FEATURE_AI_CHAT?: string; // 'true' | 'false'
  NEXT_PUBLIC_FEATURE_DARK_MODE?: string;

  // Metrics (optional)
  DISABLE_METRICS?: string; // 'true' to disable

  // Add your custom vars here...
}

// ===========================================================================
// VALIDATION RULES
// ===========================================================================

interface ValidationRule {
  required: boolean;
  default?: string;
  validate?: (value: string) => boolean;
  errorMessage?: string;
}

/**
 * Define validation rules for each environment variable
 */
const validationRules: Partial<Record<keyof EnvironmentVariables, ValidationRule>> = {
  // Required in all environments
  NODE_ENV: {
    required: true,
    validate: (val) => ['development', 'production', 'test'].includes(val),
    errorMessage: 'NODE_ENV must be development, production, or test',
  },

  NEXT_PUBLIC_APP_URL: {
    required: true,
    validate: (val) => val.startsWith('http://') || val.startsWith('https://'),
    errorMessage: 'NEXT_PUBLIC_APP_URL must be a valid URL',
  },

  // Optional but validated if present
  ANTHROPIC_API_KEY: {
    required: false,
    validate: (val) => val.startsWith('sk-ant-'),
    errorMessage: 'ANTHROPIC_API_KEY must start with sk-ant-',
  },

  OPENAI_API_KEY: {
    required: false,
    validate: (val) => val.startsWith('sk-'),
    errorMessage: 'OPENAI_API_KEY must start with sk-',
  },

  DATABASE_URL: {
    required: false,
    validate: (val) =>
      val.startsWith('postgres://') ||
      val.startsWith('mysql://') ||
      val.startsWith('mongodb://'),
    errorMessage: 'DATABASE_URL must be a valid database connection string',
  },

  // Add your custom validation rules here...
};

// ===========================================================================
// VALIDATION FUNCTION
// ===========================================================================

/**
 * Validate environment variables according to rules
 *
 * Throws error if validation fails (fail fast on startup)
 */
export function validateEnv(): void {
  const errors: string[] = [];

  // Check each rule
  for (const [key, rule] of Object.entries(validationRules)) {
    const value = process.env[key];

    // Check if required
    if (rule.required && !value) {
      errors.push(`❌ Missing required env var: ${key}`);
      continue;
    }

    // Skip validation if optional and not present
    if (!value) continue;

    // Run custom validation
    if (rule.validate && !rule.validate(value)) {
      const msg = rule.errorMessage || `Invalid value for ${key}`;
      errors.push(`❌ ${msg}`);
    }
  }

  // Throw if any errors
  if (errors.length > 0) {
    console.error('\n🚨 ENVIRONMENT VALIDATION FAILED\n');
    errors.forEach((err) => console.error(err));
    console.error('\nFix errors above and restart.\n');
    throw new Error('Environment validation failed');
  }

  // Success
  if (process.env.NODE_ENV === 'development') {
    console.log('✅ Environment variables validated successfully');
  }
}

// ===========================================================================
// TYPE-SAFE ENV ACCESS
// ===========================================================================

/**
 * Type-safe environment variables object
 *
 * Use this instead of process.env for autocomplete and type safety
 *
 * @example
 *   import { env } from '@/lib/env';
 *   const apiKey = env.ANTHROPIC_API_KEY; // TypeScript knows the type!
 */
export const env: EnvironmentVariables = {
  NODE_ENV: (process.env.NODE_ENV as EnvironmentVariables['NODE_ENV']) || 'development',

  NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
  NEXT_PUBLIC_APP_NAME: process.env.NEXT_PUBLIC_APP_NAME,

  ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY,
  OPENAI_API_KEY: process.env.OPENAI_API_KEY,

  DATABASE_URL: process.env.DATABASE_URL,

  NEXTAUTH_URL: process.env.NEXTAUTH_URL,
  NEXTAUTH_SECRET: process.env.NEXTAUTH_SECRET,

  NEXT_PUBLIC_ANALYTICS_ID: process.env.NEXT_PUBLIC_ANALYTICS_ID,

  NEXT_PUBLIC_FEATURE_AI_CHAT: process.env.NEXT_PUBLIC_FEATURE_AI_CHAT,
  NEXT_PUBLIC_FEATURE_DARK_MODE: process.env.NEXT_PUBLIC_FEATURE_DARK_MODE,

  DISABLE_METRICS: process.env.DISABLE_METRICS,
};

// ===========================================================================
// HELPER FUNCTIONS
// ===========================================================================

/**
 * Check if we're in development mode
 */
export function isDevelopment(): boolean {
  return env.NODE_ENV === 'development';
}

/**
 * Check if we're in production mode
 */
export function isProduction(): boolean {
  return env.NODE_ENV === 'production';
}

/**
 * Check if we're in test mode
 */
export function isTest(): boolean {
  return env.NODE_ENV === 'test';
}

/**
 * Check if a feature flag is enabled
 *
 * @example
 *   if (isFeatureEnabled('AI_CHAT')) {
 *     // Show AI chat UI
 *   }
 */
export function isFeatureEnabled(feature: string): boolean {
  const key = `NEXT_PUBLIC_FEATURE_${feature}` as keyof EnvironmentVariables;
  return env[key] === 'true';
}

/**
 * Get app URL (with trailing slash removed)
 */
export function getAppUrl(): string {
  return env.NEXT_PUBLIC_APP_URL.replace(/\/$/, '');
}

/**
 * Check if metrics are enabled
 */
export function isMetricsEnabled(): boolean {
  return env.DISABLE_METRICS !== 'true';
}

// ===========================================================================
// SERVER-SIDE ONLY HELPERS
// ===========================================================================

/**
 * Throw error if accessed on client-side
 *
 * Use this for sensitive server-only env vars
 *
 * @example
 *   export function getApiKey() {
 *     requireServerSide();
 *     return env.ANTHROPIC_API_KEY;
 *   }
 */
export function requireServerSide(): void {
  if (typeof window !== 'undefined') {
    throw new Error('This function can only be called server-side');
  }
}

/**
 * Get API key (server-side only)
 *
 * Throws error if called on client
 */
export function getAnthropicApiKey(): string {
  requireServerSide();

  if (!env.ANTHROPIC_API_KEY) {
    throw new Error('ANTHROPIC_API_KEY not configured');
  }

  return env.ANTHROPIC_API_KEY;
}

/**
 * Get OpenAI API key (server-side only)
 */
export function getOpenAiApiKey(): string {
  requireServerSide();

  if (!env.OPENAI_API_KEY) {
    throw new Error('OPENAI_API_KEY not configured');
  }

  return env.OPENAI_API_KEY;
}

/**
 * Get database URL (server-side only)
 */
export function getDatabaseUrl(): string {
  requireServerSide();

  if (!env.DATABASE_URL) {
    throw new Error('DATABASE_URL not configured');
  }

  return env.DATABASE_URL;
}

// ===========================================================================
// INITIALIZATION
// ===========================================================================

/**
 * Auto-validate in production
 *
 * In development, validation happens on first import
 * In production, fail fast on startup
 */
if (isProduction() && typeof window === 'undefined') {
  validateEnv();
}

// ===========================================================================
// USAGE EXAMPLES
// ===========================================================================

/**
 * Example 1: Using in API route
 *
 * ```typescript
 * // app/api/chat/route.ts
 * import { env, validateEnv } from '@/lib/env';
 *
 * export async function POST(req: Request) {
 *   const apiKey = env.ANTHROPIC_API_KEY;
 *   // Use apiKey...
 * }
 * ```
 *
 * Example 2: Using in component
 *
 * ```typescript
 * // components/Header.tsx
 * import { env, isFeatureEnabled } from '@/lib/env';
 *
 * export function Header() {
 *   const showAiChat = isFeatureEnabled('AI_CHAT');
 *   return (
 *     <header>
 *       {showAiChat && <AiChatButton />}
 *     </header>
 *   );
 * }
 * ```
 *
 * Example 3: Validate on app startup
 *
 * ```typescript
 * // app/layout.tsx (Server Component)
 * import { validateEnv } from '@/lib/env';
 *
 * // Validate before rendering
 * if (typeof window === 'undefined') {
 *   validateEnv();
 * }
 *
 * export default function RootLayout({ children }) {
 *   return <html>{children}</html>;
 * }
 * ```
 */
