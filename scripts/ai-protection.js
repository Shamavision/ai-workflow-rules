#!/usr/bin/env node
/**
 * ==============================================================================
 * AI PROTECTION SCRIPT - Node.js Version
 * AI Workflow Rules Framework v9.0
 * ==============================================================================
 *
 * PURPOSE:
 *   Protects AI assistants from leaking sensitive data through:
 *   - Prompt injection detection (malicious AI instructions)
 *   - PII scanning (.ai/ logs for emails, phones, IPNs)
 *   - Directory protection (.ai/ must be in .gitignore)
 *
 * USAGE:
 *   Called automatically by pre-commit hook
 *   Can also be run manually: node scripts/ai-protection.js
 *
 * EXIT CODES:
 *   0 = All checks passed
 *   1 = Threats detected (fail-closed)
 *
 * ==============================================================================
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Config files
const POLICY_FILE = '.ai/ai-protection-policy.json';
const PROMPT_PATTERNS = '.ai/prompt-injection-patterns.json';
const PII_PATTERNS = '.ai/pii-patterns.json';
const AUDIT_LOG = '.ai/audit-trail.log';

// Flags
let threatsFound = false;
let promptInjectionFound = false;
let piiFound = false;
let gitignoreViolations = false;

// Colors (disabled in non-TTY)
const colors = process.stdout.isTTY ? {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  reset: '\x1b[0m',
} : {
  red: '', green: '', yellow: '', cyan: '', reset: ''
};

// ==============================================================================
// UTILITIES
// ==============================================================================

function logAudit(eventType, details) {
  const timestamp = new Date().toISOString();
  const logEntry = `${timestamp} | ${eventType} | ${details}\n`;

  try {
    if (fs.existsSync('.ai')) {
      fs.appendFileSync(AUDIT_LOG, logEntry);
    }
  } catch (error) {
    // Silent fail - audit is non-critical
  }
}

function printError(message) {
  console.log(`${colors.red}${message}${colors.reset}`);
}

function printWarning(message) {
  console.log(`${colors.yellow}${message}${colors.reset}`);
}

function printSuccess(message) {
  console.log(`${colors.green}${message}${colors.reset}`);
}

function printInfo(message) {
  console.log(`${colors.cyan}${message}${colors.reset}`);
}

// ==============================================================================
// CHECK 1: Prompt Injection Detection
// ==============================================================================

function checkPromptInjection() {
  printInfo('━━━ Checking for prompt injection...');

  if (!fs.existsSync(PROMPT_PATTERNS)) {
    printWarning('⚠  Prompt injection patterns file not found');
    return;
  }

  // Get staged files
  let stagedFiles = [];
  try {
    const output = execSync('git diff --cached --name-only --diff-filter=ACM', {
      encoding: 'utf8',
    }).trim();
    stagedFiles = output ? output.split('\n') : [];
  } catch (error) {
    return;
  }

  if (stagedFiles.length === 0) {
    return;
  }

  // Critical patterns (simplified)
  const patterns = [
    {
      regex: /(AI|SYSTEM|ASSISTANT|CLAUDE|GPT|GEMINI)\s*(INSTRUCTION|OVERRIDE|COMMAND|DIRECTIVE)\s*:/i,
      name: 'System Override'
    },
    {
      regex: /ignore\s+(all\s+)?(previous|prior|earlier)\s+(instructions?|rules?|prompts?)/i,
      name: 'Ignore Previous'
    },
    {
      regex: /(bypass|disable|skip|ignore)\s+(security|validation|check|protection)/i,
      name: 'Security Bypass'
    },
    {
      regex: /(add|insert|include)\s+(API\s+key|token|password|secret)/i,
      name: 'Credential Insertion'
    }
  ];

  // Whitelist patterns
  const whitelistPatterns = [
    /\.md$/,
    /\/docs\//,
    /\/examples\//,
    /\/test\//,
    /\.test\./,
    /\.spec\./
  ];

  for (const file of stagedFiles) {
    // Skip if file doesn't exist
    if (!fs.existsSync(file)) {
      continue;
    }

    // Check whitelist
    const isWhitelisted = whitelistPatterns.some(pattern => pattern.test(file));
    if (isWhitelisted) {
      continue;
    }

    // Skip binary files
    try {
      const stats = fs.statSync(file);
      if (stats.size === 0 || stats.size > 1024 * 1024) {
        continue; // Empty or >1MB
      }
    } catch (error) {
      continue;
    }

    // Read file
    let content;
    try {
      content = fs.readFileSync(file, 'utf8');
    } catch (error) {
      continue; // Binary or unreadable
    }

    // Scan for patterns
    const lines = content.split('\n');
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];

      for (const pattern of patterns) {
        const match = line.match(pattern.regex);
        if (match) {
          const lineNum = i + 1;
          const matchedText = line.substring(0, 80);

          printError(`🚨 PROMPT INJECTION detected in ${file}:${lineNum}`);
          console.log(`   Pattern: ${pattern.name}`);
          console.log(`   Text: ${matchedText}...`);
          console.log('');

          promptInjectionFound = true;
          threatsFound = true;

          logAudit('PROMPT_INJECTION', `${file}:${lineNum}`);
          break;
        }
      }

      if (threatsFound) break;
    }

    if (threatsFound) break;
  }

  if (!promptInjectionFound) {
    printSuccess('✓ No prompt injection detected');
  }
}

// ==============================================================================
// CHECK 2: PII Detection in .ai/ Directory
// ==============================================================================

function checkPIIInAILogs() {
  printInfo('━━━ Checking for PII in AI logs...');

  if (!fs.existsSync(PII_PATTERNS)) {
    printWarning('⚠  PII patterns file not found');
    return;
  }

  // Files to scan
  const scanFiles = [
    '.ai/token-limits.json',
    '.ai/audit-trail.log'
  ];

  // PII patterns
  const emailPattern = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g;
  const phoneUAPattern = /\+380[0-9]{9}/g;

  const emailWhitelist = ['example.com', 'test.com', 'noreply@', 'no-reply@'];

  for (const scanFile of scanFiles) {
    if (!fs.existsSync(scanFile)) {
      continue;
    }

    let content;
    try {
      content = fs.readFileSync(scanFile, 'utf8');
    } catch (error) {
      continue;
    }

    // Check for emails
    const emails = content.match(emailPattern) || [];
    const realEmails = emails.filter(email =>
      !emailWhitelist.some(whitelist => email.includes(whitelist))
    );

    if (realEmails.length > 0) {
      printWarning(`⚠  PII detected in ${scanFile}: ${realEmails.length} email(s)`);
      piiFound = true;
      logAudit('PII_DETECTED', `${scanFile} (emails: ${realEmails.length})`);
    }

    // Check for Ukrainian phones
    const phones = content.match(phoneUAPattern) || [];
    if (phones.length > 0) {
      printWarning(`⚠  PII detected in ${scanFile}: ${phones.length} Ukrainian phone(s)`);
      piiFound = true;
      logAudit('PII_DETECTED', `${scanFile} (phones: ${phones.length})`);
    }
  }

  if (!piiFound) {
    printSuccess('✓ No PII detected in AI logs');
  } else {
    printWarning('');
    printWarning('⚠  PII found in AI logs (non-blocking warning)');
    printWarning('   Recommendation: Review and redact manually');
    printWarning('   Or run: //PII-SCAN --redact');
    printWarning('');
  }
}

// ==============================================================================
// CHECK 3: .ai/ Directory Protection
// ==============================================================================

function checkAIDirectoryProtection() {
  printInfo('━━━ Checking .ai/ directory protection...');

  // Required entries in .gitignore
  const requiredEntries = [
    '.ai/audit-trail.log',
    '.ai/.ai-protection-cache/',
    'ai-logs/'
  ];

  if (!fs.existsSync('.gitignore')) {
    printError('❌ .gitignore not found');
    printError('   Create .gitignore and add:');
    requiredEntries.forEach(entry => console.log(`   ${entry}`));
    gitignoreViolations = true;
    threatsFound = true;
    return;
  }

  const gitignoreContent = fs.readFileSync('.gitignore', 'utf8');

  for (const entry of requiredEntries) {
    const regex = new RegExp(`^${entry.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`, 'm');
    if (!regex.test(gitignoreContent)) {
      printError(`❌ Missing in .gitignore: ${entry}`);
      gitignoreViolations = true;
      threatsFound = true;
    }
  }

  // Check if .ai/ sensitive files are staged
  let stagedFiles = [];
  try {
    const output = execSync('git diff --cached --name-only', { encoding: 'utf8' }).trim();
    stagedFiles = output ? output.split('\n') : [];
  } catch (error) {
    // No git or no staged files
  }

  const blockedFiles = [
    '.ai/audit-trail.log',
    '.ai/.ai-protection-cache',
    'ai-logs/'
  ];

  for (const file of stagedFiles) {
    for (const blocked of blockedFiles) {
      if (file.startsWith(blocked)) {
        printError(`❌ Blocked file staged: ${file}`);
        printError('   This file must be in .gitignore');
        gitignoreViolations = true;
        threatsFound = true;
      }
    }
  }

  if (!gitignoreViolations) {
    printSuccess('✓ .ai/ directory properly protected');
  }
}

// ==============================================================================
// MAIN
// ==============================================================================

function main() {
  // Check if AI protection is enabled
  if (!fs.existsSync(POLICY_FILE)) {
    console.log('⚠  AI Protection not configured (.ai/ai-protection-policy.json missing)');
    console.log('   Run: npx @shamavision/ai-workflow-rules@9.0.0 init');
    process.exit(0);
  }

  console.log('');
  console.log('🤖 AI Protection v9.0');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('');

  // Run checks
  checkPromptInjection();
  checkPIIInAILogs();
  checkAIDirectoryProtection();

  console.log('');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  // Final verdict
  if (threatsFound) {
    console.log('');
    printError('❌ AI PROTECTION FAILED');
    console.log('');
    console.log('Threats detected:');

    if (promptInjectionFound) {
      console.log('  - Prompt injection attempts');
    }

    if (gitignoreViolations) {
      console.log('  - .ai/ directory violations');
    }

    if (piiFound) {
      console.log('  - PII in AI logs (warning only)');
    }

    console.log('');
    console.log('Fix issues above before committing.');
    console.log('');

    logAudit('AI_PROTECTION_FAILED', 'Threats detected');
    process.exit(1);
  } else {
    console.log('');
    printSuccess('✅ AI PROTECTION PASSED');
    console.log('');
    logAudit('AI_PROTECTION_PASSED', 'All checks passed');
    process.exit(0);
  }
}

// Run main
main();
