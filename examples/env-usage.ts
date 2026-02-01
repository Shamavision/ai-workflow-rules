/**
 * Example: Environment Variables Usage
 *
 * This file demonstrates how to properly use environment variables
 * following RULES_CORE.md Section 10 (Security & Quality Guards).
 *
 * ✅ GOOD practices:
 * - Use process.env for all secrets and config
 * - Validate environment variables at startup
 * - Provide sensible defaults for non-secret values
 * - Type-safe environment config
 *
 * ❌ BAD practices avoided:
 * - Hardcoding secrets in code
 * - Committing .env file to git
 * - Missing validation (app crashes if env var missing)
 */

/**
 * ✅ GOOD: Type-safe environment configuration
 */
interface EnvironmentConfig {
  // API Keys (REQUIRED - app won't start without these)
  openaiApiKey: string;
  anthropicApiKey: string;

  // Database (REQUIRED)
  databaseUrl: string;

  // Optional configs (have defaults)
  nodeEnv: 'development' | 'production' | 'test';
  port: number;
  logLevel: 'debug' | 'info' | 'warn' | 'error';

  // Feature flags (optional)
  enableAnalytics: boolean;
  enableDebugMode: boolean;
}

/**
 * ✅ GOOD: Load and validate environment variables
 */
function loadEnvironmentConfig(): EnvironmentConfig {
  // Required variables
  const openaiApiKey = process.env.OPENAI_API_KEY;
  const anthropicApiKey = process.env.ANTHROPIC_API_KEY;
  const databaseUrl = process.env.DATABASE_URL;

  // ✅ GOOD: Validate required variables
  const missingVars: string[] = [];
  if (!openaiApiKey) missingVars.push('OPENAI_API_KEY');
  if (!anthropicApiKey) missingVars.push('ANTHROPIC_API_KEY');
  if (!databaseUrl) missingVars.push('DATABASE_URL');

  if (missingVars.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missingVars.join(', ')}\n` +
      `Please check your .env file or environment configuration.`
    );
  }

  // ✅ GOOD: Optional variables with defaults
  const nodeEnv = (process.env.NODE_ENV || 'development') as EnvironmentConfig['nodeEnv'];
  const port = parseInt(process.env.PORT || '3000', 10);
  const logLevel = (process.env.LOG_LEVEL || 'info') as EnvironmentConfig['logLevel'];

  // ✅ GOOD: Boolean flags (with defaults)
  const enableAnalytics = process.env.ENABLE_ANALYTICS === 'true';
  const enableDebugMode = process.env.ENABLE_DEBUG_MODE === 'true';

  return {
    openaiApiKey,
    anthropicApiKey,
    databaseUrl,
    nodeEnv,
    port,
    logLevel,
    enableAnalytics,
    enableDebugMode
  };
}

/**
 * ✅ GOOD: Export validated config (not raw process.env)
 */
export const config = loadEnvironmentConfig();

/**
 * ✅ GOOD: Usage in application code
 */
export async function makeOpenAIRequest(prompt: string) {
  // ✅ Using validated config (guaranteed to exist)
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${config.openaiApiKey}` // ✅ From env
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages: [{ role: 'user', content: prompt }]
    })
  });

  return await response.json();
}

/**
 * ✅ GOOD: Using feature flags
 */
export function logDebugInfo(message: string) {
  if (config.enableDebugMode) {
    console.log(`[DEBUG] ${message}`);
  }
}

/**
 * ❌ BAD EXAMPLE (what NOT to do):
 *
 * // ❌ CRITICAL: Hardcoded API key
 * const apiKey = "sk-ant-1234567890abcdef";
 *
 * // ❌ No validation - crashes if undefined
 * const dbUrl = process.env.DATABASE_URL;
 * database.connect(dbUrl); // Crashes if DATABASE_URL not set!
 *
 * // ❌ Magic strings scattered across codebase
 * fetch('...', {
 *   headers: { 'Authorization': `Bearer ${process.env.OPENAI_API_KEY}` }
 * });
 *
 * // ❌ Boolean parsing wrong
 * const flag = process.env.ENABLE_FEATURE; // Always truthy (even if "false")!
 *
 * Problems:
 * 1. Hardcoded secret → git leak
 * 2. No validation → runtime crashes
 * 3. process.env everywhere → hard to test, easy to typo
 * 4. Wrong boolean parsing → bugs
 */

/**
 * .env file example (NEVER commit this file!):
 *
 * # API Keys (REQUIRED)
 * OPENAI_API_KEY=sk-...
 * ANTHROPIC_API_KEY=sk-ant-...
 *
 * # Database (REQUIRED)
 * DATABASE_URL=postgresql://user:pass@localhost:5432/db
 *
 * # Optional (have defaults)
 * NODE_ENV=development
 * PORT=3000
 * LOG_LEVEL=debug
 *
 * # Feature Flags (optional)
 * ENABLE_ANALYTICS=false
 * ENABLE_DEBUG_MODE=true
 */

/**
 * .env.example file (SAFE to commit):
 *
 * # Copy this file to .env and fill in your values
 *
 * OPENAI_API_KEY=your_openai_key_here
 * ANTHROPIC_API_KEY=your_anthropic_key_here
 * DATABASE_URL=postgresql://localhost:5432/mydb
 * NODE_ENV=development
 */

/**
 * .gitignore (MUST include):
 *
 * # Environment files (NEVER commit!)
 * .env
 * .env.local
 * .env.*.local
 *
 * # OK to commit (template only):
 * # .env.example
 */
