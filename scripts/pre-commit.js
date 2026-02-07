#!/usr/bin/env node
/**
 * ==============================================================================
 * PRE-COMMIT HOOK - UNIVERSAL SECRETS SCANNER + AI PROTECTION (Node.js)
 * AI Workflow Rules Framework v9.0
 * ==============================================================================
 *
 * PHILOSOPHY: Silent Guardian Architecture
 *   - Protect without blocking productivity
 *   - Trust informed decisions
 *   - Universal compatibility (Windows/Mac/Linux, all IDEs)
 *   - 🆕 AI Protection: Prompt injection + PII detection
 *
 * USAGE:
 *   This is a Node.js alternative to the bash version
 *   Works natively on Windows without Git Bash
 *
 *   To use: cp scripts/pre-commit.js .git/hooks/pre-commit
 *           chmod +x .git/hooks/pre-commit
 *
 * REQUIREMENTS:
 *   Node.js 14+ (check: node --version)
 *
 * ==============================================================================
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const readline = require('readline');

// ==============================================================================
// CONFIGURATION
// ==============================================================================

const CONFIG = {
  mode: process.env.SECURITY_HOOK_MODE || 'balanced', // strict | balanced | permissive
  isCI: !!(
    process.env.CI ||
    process.env.GITHUB_ACTIONS ||
    process.env.GITLAB_CI ||
    process.env.JENKINS_HOME ||
    process.env.CIRCLECI ||
    process.env.TRAVIS
  ),
  isInteractive: process.stdin.isTTY && process.stdout.isTTY,
  colors: process.stdout.isTTY,
};

// Colors
const colors = CONFIG.colors
  ? {
      red: '\x1b[0;31m',
      green: '\x1b[0;32m',
      yellow: '\x1b[1;33m',
      blue: '\x1b[0;34m',
      cyan: '\x1b[0;36m',
      reset: '\x1b[0m',
    }
  : { red: '', green: '', yellow: '', blue: '', cyan: '', reset: '' };

// Flags
let hardBlocked = false;
let violationsFound = false;
let trackersFound = false;
let warningsCount = 0;

// ==============================================================================
// UTILITIES
// ==============================================================================

function print(message, color = '') {
  console.log(color + message + colors.reset);
}

function printHeader() {
  print('🔒 Pre-Commit Security Scan', colors.blue);
  if (CONFIG.isCI) {
    print('   Environment: CI/CD (non-interactive mode)', colors.cyan);
  }
  console.log('');
}

function printError(message) {
  print('❌ ' + message, colors.red);
}

function printWarning(message) {
  print('⚠️  ' + message, colors.yellow);
}

function printSuccess(message) {
  print('✅ ' + message, colors.green);
}

function printInfo(message) {
  print('ℹ️  ' + message, colors.cyan);
}

// Calculate Shannon entropy
function calculateEntropy(string) {
  if (string.length < 20) return 0;

  const freq = {};
  for (const char of string) {
    freq[char] = (freq[char] || 0) + 1;
  }

  let entropy = 0;
  const len = string.length;

  for (const count of Object.values(freq)) {
    const p = count / len;
    entropy -= p * Math.log2(p);
  }

  return entropy;
}

// Check if file should be ignored
function isIgnored(filePath) {
  const builtInIgnore = [
    '.env.example',
    '.env.sample',
    '.env.template',
    'scripts/pre-commit',
    'scripts/pre-commit.js',
    'scripts/pre-commit.ps1',
    'scripts/seo-check.sh',
    '.ai/security-policy.json',
    '.ai/forbidden-trackers.json',
    'RULES_CORE.md',
    'RULES_PRODUCT.md',
    'node_modules/',
    'dist/',
    'build/',
    'examples/',
    'tests/fixtures/',
    '__tests__/mocks/',
  ];

  if (builtInIgnore.some((pattern) => filePath.includes(pattern))) {
    return true;
  }

  // Check .securityignore
  const ignoreFile = '.securityignore';
  if (fs.existsSync(ignoreFile)) {
    const patterns = fs
      .readFileSync(ignoreFile, 'utf8')
      .split('\n')
      .filter((line) => line && !line.startsWith('#'));

    for (const pattern of patterns) {
      if (filePath.includes(pattern.trim())) {
        return true;
      }
    }
  }

  return false;
}

// Check if line has bypass comment
function hasBypassComment(line) {
  return (
    line.includes('secure-ignore') ||
    line.includes('security:ignore') ||
    line.includes('nosecret')
  );
}

// Ask user confirmation (interactive mode only)
async function askUserConfirmation(message) {
  if (!CONFIG.isInteractive) {
    printWarning('Non-interactive mode: Auto-blocking suspicious pattern');
    return false;
  }

  if (CONFIG.mode === 'permissive') {
    printWarning('Permissive mode: Auto-allowing');
    return true;
  }

  console.log('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', colors.yellow);
  print('SECURITY WARNING', colors.yellow);
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', colors.yellow);
  console.log('');
  console.log(message);
  console.log('');
  console.log('How to fix:');
  console.log('  1. Use environment variables: process.env.API_KEY');
  console.log('  2. Move to .env file (gitignored)');
  console.log('  3. If false positive: add comment // secure-ignore');
  console.log('');

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    rl.question("Proceed with commit? Type 'yes' to continue: ", (answer) => {
      rl.close();
      console.log('');
      if (answer.toLowerCase() === 'yes') {
        printWarning('User confirmed. Proceeding...');
        resolve(true);
      } else {
        printError('Commit cancelled by user');
        resolve(false);
      }
    });
  });
}

// Log to audit trail
function logToAuditTrail(eventType, details) {
  const auditFile = '.ai/audit-trail.log';

  if (!fs.existsSync('.ai')) {
    fs.mkdirSync('.ai', { recursive: true });
  }

  const timestamp = new Date().toISOString();
  const user = execSync('git config user.name', { encoding: 'utf8' }).trim();
  const email = execSync('git config user.email', { encoding: 'utf8' }).trim();
  const branch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();

  const entry = `
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[${timestamp}] COMMIT BLOCKED
Event: ${eventType}
Details: ${details}
Framework: ai-workflow-rules v8.3
User: ${user} <${email}>
Branch: ${branch}
Environment: ${CONFIG.isCI ? 'CI/CD' : 'Interactive'}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

`;

  fs.appendFileSync(auditFile, entry);
}

// ==============================================================================
// TIER 1: HARD BLOCK PATTERNS (ALL AI PROVIDERS)
// ==============================================================================

const TIER1_PATTERNS = [
  // Anthropic
  {
    name: 'Anthropic API Key',
    provider: 'Anthropic (Claude)',
    regex: /sk-ant-api03-[A-Za-z0-9_-]{95}/,
    envVar: 'ANTHROPIC_API_KEY',
  },

  // OpenAI
  {
    name: 'OpenAI API Key',
    provider: 'OpenAI (GPT)',
    regex: /\bsk-[a-zA-Z0-9]{48,51}\b/,
    exclude: /sk-ant-/,
    envVar: 'OPENAI_API_KEY',
  },

  // Google
  {
    name: 'Google AI API Key',
    provider: 'Google (Gemini, PaLM)',
    regex: /AIza[A-Za-z0-9_-]{35}/,
    envVar: 'GOOGLE_API_KEY',
  },

  // Hugging Face
  {
    name: 'Hugging Face Token',
    provider: 'Hugging Face',
    regex: /hf_[A-Za-z0-9]{32,}/,
    envVar: 'HUGGINGFACE_TOKEN',
  },

  // Replicate
  {
    name: 'Replicate Token',
    provider: 'Replicate',
    regex: /r8_[A-Za-z0-9]{40}/,
    envVar: 'REPLICATE_API_TOKEN',
  },

  // GitHub
  {
    name: 'GitHub Token',
    provider: 'GitHub',
    regex: /ghp_[A-Za-z0-9]{36}/,
    envVar: 'GITHUB_TOKEN',
  },

  {
    name: 'GitHub OAuth Token',
    provider: 'GitHub OAuth',
    regex: /gho_[A-Za-z0-9]{36}/,
    envVar: 'GITHUB_TOKEN',
  },

  // AWS
  {
    name: 'AWS Access Key',
    provider: 'AWS',
    regex: /AKIA[A-Z0-9]{16}/,
    envVar: 'AWS_ACCESS_KEY_ID',
  },

  // Stripe
  {
    name: 'Stripe Secret Key',
    provider: 'Stripe',
    regex: /sk_live_[A-Za-z0-9]{24,}/,
    envVar: 'STRIPE_SECRET_KEY',
  },

  // Private keys
  {
    name: 'Private Key',
    provider: 'Cryptographic Key',
    regex: /BEGIN (RSA )?PRIVATE KEY/,
    envVar: null,
  },
];

// ==============================================================================
// MAIN SCAN LOGIC
// ==============================================================================

async function scanFiles(files) {
  printHeader();
  console.log(`Scanning ${files.length} staged file(s)...`);
  console.log('');

  console.log('━━━ Checking for real API keys (all AI providers)...');

  for (const file of files) {
    if (isIgnored(file)) continue;
    if (!fs.existsSync(file)) continue;

    // Skip binary files
    try {
      const stats = fs.statSync(file);
      if (stats.size > 1024 * 1024) continue; // Skip files > 1MB
    } catch (err) {
      continue;
    }

    const content = fs.readFileSync(file, 'utf8');
    const lines = content.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNum = i + 1;

      if (hasBypassComment(line)) continue;

      // Check Tier 1 patterns
      for (const pattern of TIER1_PATTERNS) {
        if (pattern.exclude && pattern.exclude.test(line)) continue;

        if (pattern.regex.test(line)) {
          printError(`BLOCKED: ${pattern.name} in ${file}:${lineNum}`);
          if (pattern.provider) console.log(`   Provider: ${pattern.provider}`);
          if (pattern.envVar) console.log(`   Fix: Use process.env.${pattern.envVar}`);
          hardBlocked = true;
        }
      }

      // High-entropy detection
      const quotedStrings = line.match(/["'][A-Za-z0-9+/=_-]{20,}["']/g) || [];
      for (const quoted of quotedStrings) {
        const clean = quoted.replace(/["']/g, '');

        if (/example|test|demo|placeholder|your.?key|xxx|sample|fake/i.test(clean)) {
          continue;
        }

        const entropy = calculateEntropy(clean);
        if (entropy > 4.5) {
          printError(`BLOCKED: High-entropy string (likely secret) in ${file}:${lineNum}`);
          console.log(`   Entropy: ${entropy.toFixed(2)} (threshold: 4.5)`);
          console.log(`   Fix: Move to environment variable`);
          hardBlocked = true;
        }
      }
    }
  }

  // Check blocked file types
  for (const file of files) {
    const basename = path.basename(file);

    if (['.env', '.env.local', '.env.production', '.env.development'].includes(basename)) {
      printError(`BLOCKED: Environment file detected: ${file}`);
      hardBlocked = true;
    }

    if (/\.(pem|key|p12|pfx)$/.test(file)) {
      printError(`BLOCKED: Private key file: ${file}`);
      hardBlocked = true;
    }

    if (['credentials.json', 'secrets.json'].includes(basename)) {
      printError(`BLOCKED: Credentials file: ${file}`);
      hardBlocked = true;
    }
  }

  // Tier 2: Suspicious patterns (with user confirmation)
  console.log('━━━ Checking for suspicious patterns...');

  for (const file of files) {
    if (isIgnored(file)) continue;
    if (!fs.existsSync(file)) continue;
    if (!/\.(js|ts|jsx|tsx|py|go|rb|java|cs|php|sh|yml|yaml|json)$/.test(file)) continue;

    const content = fs.readFileSync(file, 'utf8');
    const lines = content.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNum = i + 1;

      if (hasBypassComment(line)) continue;
      if (/^\s*(\/\/|#|\*)/.test(line)) continue; // Skip comments

      // Generic API_KEY assignment
      if (/API_?KEY\s*[=:]\s*["'][A-Za-z0-9_-]{16,}["']/i.test(line)) {
        if (/your.?key|example|placeholder|xxx|test|demo|fake|sample/i.test(line)) {
          continue;
        }

        printWarning(`Suspicious API key assignment in ${file}:${lineNum}`);
        warningsCount++;

        if (!(await askUserConfirmation('Possible hardcoded API key detected'))) {
          hardBlocked = true;
          break;
        }
      }

      // Bearer tokens
      if (/Bearer [A-Za-z0-9_-]{20,}/.test(line)) {
        if (/example|placeholder|xxx|your.?token/i.test(line)) {
          continue;
        }

        printWarning(`Suspicious Bearer token in ${file}:${lineNum}`);
        warningsCount++;

        if (!(await askUserConfirmation('Possible hardcoded Bearer token detected'))) {
          hardBlocked = true;
          break;
        }
      }
    }

    if (hardBlocked) break;
  }

  return {
    hardBlocked,
    violationsFound,
    trackersFound,
    warningsCount,
  };
}

// ==============================================================================
// MAIN
// ==============================================================================

async function main() {
  try {
    // Get staged files
    const stagedFiles = execSync('git diff --cached --name-only --diff-filter=ACM', {
      encoding: 'utf8',
    })
      .split('\n')
      .filter(Boolean);

    if (stagedFiles.length === 0) {
      printSuccess('No files staged');
      process.exit(0);
    }

    // Run scan
    const result = await scanFiles(stagedFiles);

    // AI Protection (v9.0+)
    let aiProtectionFailed = false;

    if (fs.existsSync('.ai/ai-protection-policy.json')) {
      console.log('━━━ AI Protection: Checking for threats...');

      if (fs.existsSync('scripts/ai-protection.js')) {
        try {
          // Run AI protection checks
          require('./ai-protection.js');
          print('✓ AI Protection passed', colors.green);
        } catch (error) {
          aiProtectionFailed = true;
          print('✗ AI Protection detected threats', colors.red);
        }
      } else {
        // Script missing - warn but don't block
        print('⚠  AI Protection script not found (scripts/ai-protection.js)', colors.yellow);
        console.log('   Run installer to add AI Protection: npx @shamavision/ai-workflow-rules@9.0.0 init');
      }
    }

    // Final verdict
    console.log('');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (result.hardBlocked) {
      print('❌ COMMIT BLOCKED', colors.red);
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('');
      console.log('🚨 Your commit contains sensitive data or was cancelled.');
      console.log('');

      if (CONFIG.isCI) {
        console.log('Running in CI/CD: Set SECURITY_HOOK_MODE=permissive to bypass tier 2');
      }

      logToAuditTrail('HARD_BLOCK', 'Secrets detected or user cancellation');
      process.exit(1);
    }

    if (aiProtectionFailed) {
      print('❌ COMMIT BLOCKED - AI PROTECTION', colors.red);
      console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      console.log('');
      console.log('🤖 AI Protection detected threats:');
      console.log('   - Prompt injection attempts');
      console.log('   - PII in AI logs');
      console.log('   - .ai/ directory violations');
      console.log('');
      console.log('See details above for specific issues.');
      console.log('');
      logToAuditTrail('AI_PROTECTION', 'AI threats detected');
      process.exit(1);
    }

    print('✅ SECURITY SCAN PASSED', colors.green);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('');

    if (result.warningsCount > 0) {
      printSuccess(`No critical issues (user confirmed ${result.warningsCount} warning(s))`);
    } else {
      printSuccess('No secrets or trackers detected');
    }

    console.log('');
    console.log('Proceeding with commit...');
    console.log('');
    process.exit(0);
  } catch (error) {
    console.error('Error running pre-commit hook:', error.message);
    process.exit(1);
  }
}

main();
