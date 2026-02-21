#!/usr/bin/env node

/**
 * AI Workflow Rules - CLI Installer
 * Universal setup wizard for AI coding assistants
 */

const inquirer = require('inquirer');
const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');

// Presets for token limits by provider and plan
// Synced with .ai/token-limits.json (v3.0 VARIANT B) - 2026-02-17
const TOKEN_PRESETS = {
  anthropic: {
    free: { monthly: 200000, daily: 20000 },
    pro: { monthly: 5000000, daily: 500000 },
    team: { monthly: 8000000, daily: 800000 },
    api: { monthly: 999999999, daily: 999999999 }
  },
  google: {
    free: { monthly: 100000, daily: 5000 },
    advanced: { monthly: 1500000, daily: 80000 },
    api: { monthly: 999999999, daily: 999999999 }
  },
  cursor: {
    free: { monthly: 400000, daily: 20000 },
    pro: { monthly: 1500000, daily: 80000 },
    business: { monthly: 2500000, daily: 120000 }
  },
  mistral: {
    api: { monthly: 999999999, daily: 999999999 }
  },
  groq: {
    free: { monthly: 100000, daily: 5000 }
  },
  deepseek: {
    api: { monthly: 999999999, daily: 999999999 }
  },
  perplexity: {
    free: { monthly: 200000, daily: 10000 },
    pro: { monthly: 400000, daily: 20000 }
  },
  other: {
    default: { monthly: 500000, daily: 20000 }
  }
};

// Provider and plan mappings
// Synced with .ai/token-limits.json PRESETS - 2026-02-17
const PROVIDERS = [
  { name: 'Claude (Anthropic)', value: 'anthropic' },
  { name: 'Gemini (Google)', value: 'google' },
  { name: 'Cursor IDE', value: 'cursor' },
  { name: 'Perplexity', value: 'perplexity' },
  { name: 'Mistral API', value: 'mistral' },
  { name: 'DeepSeek API', value: 'deepseek' },
  { name: 'Groq', value: 'groq' },
  { name: 'Other / Custom', value: 'other' }
];

const PLANS = {
  anthropic: ['Free', 'Pro', 'Team', 'API'],
  google: ['Free', 'Advanced', 'API'],
  cursor: ['Free', 'Pro', 'Business'],
  perplexity: ['Free', 'Pro'],
  mistral: ['API'],
  deepseek: ['API'],
  groq: ['Free'],
  other: ['Default']
};

const CONTEXTS = [
  { name: 'Minimal - Startups, MVP (~10k tokens, v9.1)', value: 'minimal', tokens: 10000 },
  { name: 'Standard - Most projects (~14k tokens, v9.1)', value: 'standard', tokens: 14000 },
  { name: 'Ukraine-Full - Ukrainian businesses (~18k tokens, v9.1)', value: 'ukraine-full', tokens: 18000 },
  { name: 'Enterprise - Large teams (~23k tokens, v9.1)', value: 'enterprise', tokens: 23000 }
];

// Architecture model classification (2026 reality)
// MODEL_1: Hard Token Billing (API, metered)
// MODEL_2: Request Quota (GitHub Copilot)
// MODEL_3: Fair Use Dynamic (limits NOT DISCLOSED by provider)
const MODEL_1_KEYS = new Set(['anthropic.api', 'google.api', 'mistral.api', 'deepseek.api']);

function getArchModel(provider, plan) {
  const key = `${provider}.${plan}`;
  if (MODEL_1_KEYS.has(key)) return 'MODEL_1';
  return 'MODEL_3';
}

// Function: Generate rules files for AI tools
async function generateRulesFiles(targetDir, context) {
  console.log(chalk.cyan('\n🤖 Generating rules for AI tools...\n'));

  const sourceRules = path.join(targetDir, '.ai', 'contexts', `${context}.context.md`);

  if (!await fs.pathExists(sourceRules)) {
    console.log(chalk.yellow('⚠️  Source rules not found, skipping'));
    return;
  }

  const sourceContent = await fs.readFile(sourceRules, 'utf8');

  // Detect AI tools (v9.1: Only generate IDE-specific files)
  // Note: AGENTS.md and .claude/CLAUDE.md are now static templates (copied, not generated)
  const tools = [
    { name: 'Cursor', file: '.cursorrules' }
  ];

  console.log(chalk.gray(`Found: ${tools.length} tool(s)\n`));

  // Generate files (non-destructive: skip if already exists)
  let created = 0;
  let skipped = 0;

  for (const tool of tools) {
    const targetFile = path.join(targetDir, tool.file);

    if (await fs.pathExists(targetFile)) {
      console.log(chalk.yellow(`  ⚠️  ${tool.file} already exists, skipping`));
      skipped++;
      continue;
    }

    await fs.ensureDir(path.dirname(targetFile));

    const header = `# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI WORKFLOW RULES FRAMEWORK v9.1
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Tool: ${tool.name}
# Context: ${context}
# Auto-generated from: .ai/contexts/${context}.context.md
#
# To update rules: npm run sync-rules
# Framework: https://github.com/Shamavision/ai-workflow-rules
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

`;

    const footer = `


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# END OF AUTO-GENERATED RULES
# Made in Ukraine 🇺🇦
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`;

    await fs.writeFile(targetFile, header + sourceContent + footer, 'utf8');
    console.log(chalk.green(`  ✓ ${tool.file} created`));
    created++;
  }

  const summary = [
    created > 0 ? `${created} created` : null,
    skipped > 0 ? `${skipped} skipped (already exist)` : null
  ].filter(Boolean).join(', ');

  console.log(chalk.green(`\n✓ Rules: ${summary}\n`));
}

// Function: Smart context selection with recommendations
async function selectContextWithRecommendation() {
  console.log(chalk.bold.cyan('\n📊 Context Selection Wizard\n'));
  console.log(chalk.gray('Answer a few questions to get the best recommendation\n'));

  const answers = await inquirer.prompt([
    {
      type: 'list',
      name: 'teamSize',
      message: 'How many team members?',
      choices: [
        { name: '1-2 developers (solo/small)', value: 'small' },
        { name: '3-5 developers (team)', value: 'medium' },
        { name: '6+ developers (large team)', value: 'large' }
      ]
    },
    {
      type: 'list',
      name: 'market',
      message: 'Primary market?',
      choices: [
        { name: 'Ukrainian market (compliance, language rules)', value: 'ukraine' },
        { name: 'International (English-focused)', value: 'international' }
      ]
    },
    {
      type: 'list',
      name: 'tokenPriority',
      message: 'How cautious should AI be with tokens?',
      choices: [
        { name: 'Careful — warns early, fewer long tasks (recommended for Pro/subscription)', value: 'high' },
        { name: 'Balanced — standard warnings (recommended for most users)', value: 'medium' },
        { name: 'Relaxed — minimal interruptions (good for API/pay-per-token)', value: 'low' }
      ]
    }
  ]);

  // Recommendation logic
  let recommended;
  const reasons = [];

  if (answers.market === 'ukraine') {
    recommended = 'ukraine-full';
    reasons.push('Ukrainian market needs full compliance features');
  } else if (answers.tokenPriority === 'high') {
    recommended = 'minimal';
    reasons.push('Token efficiency prioritized');
  } else if (answers.teamSize === 'large' || answers.tokenPriority === 'low') {
    recommended = 'enterprise';
    reasons.push(answers.teamSize === 'large' ? 'Large team benefits from enterprise workflows' : 'Full features prioritized');
  } else {
    recommended = 'standard';
    reasons.push('Balanced approach for most projects');
  }

  // Show comparison table
  console.log(chalk.bold.cyan('\n📊 Context Comparison\n'));
  console.log('┌─────────────────┬────────────┬─────────────┬──────────────────────┐');
  console.log('│ Context         │ Tokens     │ Session %   │ Best For             │');
  console.log('├─────────────────┼────────────┼─────────────┼──────────────────────┤');
  console.log('│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │');
  console.log('│ Standard        │ ~14k       │ 7%          │ Most projects        │');
  console.log('│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │');
  console.log('│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │');
  console.log('└─────────────────┴────────────┴─────────────┴──────────────────────┘');
  console.log(chalk.gray('  Session % = tokens used of 200K session limit (MODEL_3 primary metric)\n'));

  // Show recommendation
  console.log(chalk.bold.green(`✅ Recommended: ${recommended}\n`));
  console.log(chalk.gray('Reasoning:'));
  reasons.forEach(reason => console.log(chalk.gray(`  • ${reason}`)));
  console.log();

  // Confirm or choose manually
  const confirmation = await inquirer.prompt([
    {
      type: 'confirm',
      name: 'useRecommended',
      message: `Use ${recommended} context?`,
      default: true
    }
  ]);

  if (confirmation.useRecommended) {
    return recommended;
  }

  // Manual selection
  const manual = await inquirer.prompt([
    {
      type: 'list',
      name: 'context',
      message: 'Choose context manually:',
      choices: CONTEXTS,
      default: recommended
    }
  ]);

  return manual.context;
}

async function main() {
  console.log(chalk.bold.cyan('\n🤖 AI Workflow Rules Setup v9.1\n'));
  console.log(chalk.gray('Universal framework for AI coding assistants\n'));
  console.log(chalk.gray('━'.repeat(50)) + '\n');

  try {
    // Ask questions
    const answers = await inquirer.prompt([
      {
        type: 'list',
        name: 'provider',
        message: 'What AI provider are you using?',
        choices: PROVIDERS
      },
      {
        type: 'list',
        name: 'plan',
        message: (answers) => `What's your ${answers.provider} plan?`,
        choices: (answers) => PLANS[answers.provider] || PLANS.other
      },
      {
        type: 'confirm',
        name: 'installHooks',
        message: 'Install security pre-commit hooks? (Recommended)',
        default: true
      },
      {
        type: 'confirm',
        name: 'updateGitignore',
        message: 'Add AI files to .gitignore? (Recommended)',
        default: true
      },
      {
        type: 'confirm',
        name: 'installProductRules',
        message: 'Install product rules? (Ukrainian market specifics → .ai/rules/product.md)',
        default: false
      }
    ]);

    // Smart context selection (v9.1)
    const selectedContext = await selectContextWithRecommendation();
    answers.context = selectedContext;

    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold('\n📦 Installing files...\n'));

    const templatesDir = path.join(__dirname, '../npm-templates');
    const currentDir = process.cwd();

    // Copy entry point
    await copyFile(templatesDir, currentDir, 'AGENTS.md');
    await copyFile(templatesDir, currentDir, 'LICENSE');

    // Create .claude directory and copy Claude Code configuration
    await fs.ensureDir(path.join(currentDir, '.claude'));
    await copyFile(
      path.join(templatesDir, '.claude'),
      path.join(currentDir, '.claude'),
      'CLAUDE.md'
    );

    // Copy Claude Code settings (enables hooks)
    await copyFile(
      path.join(templatesDir, '.claude'),
      path.join(currentDir, '.claude'),
      'settings.json'
    );

    // Create .claude/hooks and copy Session Start hook
    await fs.ensureDir(path.join(currentDir, '.claude', 'hooks'));
    await copyFile(
      path.join(templatesDir, '.claude', 'hooks'),
      path.join(currentDir, '.claude', 'hooks'),
      'user-prompt-submit.sh'
    );

    // Make hook executable (Unix systems)
    if (process.platform !== 'win32') {
      const hookPath = path.join(currentDir, '.claude', 'hooks', 'user-prompt-submit.sh');
      if (await fs.pathExists(hookPath)) {
        await fs.chmod(hookPath, 0o755);
      }
    }

    // Create .ai directory structure
    await fs.ensureDir(path.join(currentDir, '.ai'));
    await fs.ensureDir(path.join(currentDir, '.ai/docs'));
    await fs.ensureDir(path.join(currentDir, '.ai/rules'));
    await fs.ensureDir(path.join(currentDir, '.ai/contexts'));

    // Copy AI enforcement protocol (required by CLAUDE.md)
    await copyFile(
      path.join(templatesDir, '.ai'),
      path.join(currentDir, '.ai'),
      'AI-ENFORCEMENT.md'
    );

    // Copy documentation files to .ai/docs/
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'quickstart.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'cheatsheet.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'token-usage.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'compatibility.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'start.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'session-mgmt.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'code-quality.md'
    );
    await copyFile(
      path.join(templatesDir, '.ai/docs'),
      path.join(currentDir, '.ai/docs'),
      'provider-comparison.md'
    );

    // Copy rules files to .ai/rules/
    await copyFile(
      path.join(templatesDir, '.ai/rules'),
      path.join(currentDir, '.ai/rules'),
      'core.md'
    );

    // Copy product rules if requested
    if (answers.installProductRules) {
      await copyFile(
        path.join(templatesDir, '.ai/rules'),
        path.join(currentDir, '.ai/rules'),
        'product.md'
      );
    }

    // Copy forbidden trackers
    await copyFile(
      path.join(templatesDir, '.ai'),
      path.join(currentDir, '.ai'),
      'forbidden-trackers.json'
    );

    // Copy all context files (required for generateRulesFiles and future sync-rules)
    await copyContextFiles(templatesDir, currentDir);

    // Create token-limits.json with user config
    await createTokenLimitsConfig(currentDir, answers);

    // Create .ai/config.json with user's selected context (CRITICAL: CLAUDE.md reads this first)
    await createAiConfig(currentDir, answers);

    // Create scripts directory
    await fs.ensureDir(path.join(currentDir, 'scripts'));

    // Copy pre-commit script
    await copyFile(
      path.join(templatesDir, 'scripts'),
      path.join(currentDir, 'scripts'),
      'pre-commit'
    );

    // Copy utility scripts (framework tools)
    await copyFile(
      path.join(templatesDir, 'scripts'),
      path.join(currentDir, 'scripts'),
      'sync-rules.sh'
    );
    await copyFile(
      path.join(templatesDir, 'scripts'),
      path.join(currentDir, 'scripts'),
      'token-status.sh'
    );

    // Install pre-commit hook
    if (answers.installHooks) {
      await installPreCommitHook(currentDir);
    }

    // Update .gitignore
    if (answers.updateGitignore) {
      await updateGitignore(currentDir);
    }

    // Generate rules for AI tools (reads from .ai/contexts/ copied above)
    await generateRulesFiles(currentDir, answers.context);

    // Success message
    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold.green('\n🎉 Setup complete!\n'));
    console.log(chalk.bold('Next steps:'));
    console.log(chalk.gray('  1. Open a ') + chalk.bold('NEW conversation') + chalk.gray(' in your AI assistant'));
    console.log(chalk.gray('  2. Type ') + chalk.cyan('//START') + chalk.gray(' in the chat'));
    console.log(chalk.gray('  3. AI will load rules and start working\n'));
    console.log(chalk.bold.blue('🛡️  AI Protection v9.1 enabled:'));
    console.log(chalk.gray('  ✓ Prompt injection detection'));
    console.log(chalk.gray('  ✓ PII protection (GDPR-ready)'));
    console.log(chalk.gray('  ✓ Auto-runs in pre-commit hook\n'));
    console.log(chalk.gray('Need help? https://github.com/Shamavision/ai-workflow-rules/issues\n'));
    console.log(chalk.gray('Made with ❤️  in Ukraine 🇺🇦\n'));

  } catch (error) {
    if (error.isTtyError) {
      console.error(chalk.red('\n❌ Interactive prompt not supported in this environment'));
    } else {
      console.error(chalk.red('\n❌ Error:'), error.message);
    }
    process.exit(1);
  }
}

async function copyFile(sourceDir, targetDir, filename) {
  const source = path.join(sourceDir, filename);
  const target = path.join(targetDir, filename);

  if (await fs.pathExists(target)) {
    console.log(chalk.yellow(`  ⚠️  ${filename} already exists, skipping`));
    return;
  }

  await fs.copy(source, target);
  console.log(chalk.green(`  ✓ ${filename}`));
}

async function copyContextFiles(templatesDir, targetDir) {
  const sourceContextsDir = path.join(templatesDir, '.ai/contexts');
  const targetContextsDir = path.join(targetDir, '.ai/contexts');

  const contextFiles = [
    'minimal.context.md',
    'standard.context.md',
    'ukraine-full.context.md',
    'enterprise.context.md'
  ];

  for (const file of contextFiles) {
    await copyFile(sourceContextsDir, targetContextsDir, file);
  }
}

async function createTokenLimitsConfig(targetDir, answers) {
  const provider = answers.provider;
  const plan = answers.plan.toLowerCase();

  const limits = TOKEN_PRESETS[provider]?.[plan] || TOKEN_PRESETS.other.default;
  const archModel = getArchModel(provider, plan);
  const isModel3 = archModel === 'MODEL_3';

  const config = {
    "_comment": "🤖 Universal AI Token Tracker v3.0 - Auto-configured",
    "provider": provider,
    "plan": plan,
    "_architecture_model": archModel,
    "monthly_limit": limits.monthly,
    "daily_limit": limits.daily,
    "tracking_enabled": true,
    "current_month": new Date().toISOString().slice(0, 7),
    "monthly_usage": 0,
    "monthly_percentage": 0,
    "daily_usage": 0,
    "daily_percentage": 0,
    "last_reset_daily": new Date().toISOString().split('T')[0] + 'T00:00:00Z',
    "last_reset_monthly": new Date().toISOString().slice(0, 8) + '01T00:00:00Z',
    "thresholds": {
      "green": 50,
      "moderate": 70,
      "caution": 90,
      "critical": 95
    },
    "current_status": "green",
    "current_zone": "🟢 Green - Full capacity",
    "sessions": [],
    "optimization_stats": {
      "context_compressions": 0,
      "tokens_saved_by_compression": 0,
      "diff_only_mode_activations": 0,
      "lazy_loading_prevented_reads": 0
    },
    "notes": [
      "Auto-configured by ai-workflow-rules installer",
      "Limits are CONSERVATIVE (10-20% lower) for early warnings",
      "Context compression auto-triggers at 50% (saves 40-60% tokens)",
      "AI automatically updates this file - no manual tracking needed"
    ],
    "history": {}
  };

  // MODEL_3: Add Fair Use Dynamic fields (daily/monthly limits UNKNOWN by provider)
  if (isModel3) {
    config.daily_limit_type = "fair_use_dynamic";
    config.daily_limit_note = "ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3 - Fair Use Dynamic).";
    config.monthly_limit_note = "ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3 - Fair Use Dynamic).";
    config.session_limit = 200000;
    config.session_duration_hours = 5;
    config.notes.unshift(
      "MODEL_3: Fair Use Dynamic - real daily/monthly limits NOT DISCLOSED by provider",
      "Session limit: 200K tokens / ~5h rolling window (primary budget metric for MODEL_3)"
    );
  }

  const targetPath = path.join(targetDir, '.ai', 'token-limits.json');
  await fs.writeJson(targetPath, config, { spaces: 2 });

  const limitLabel = isModel3
    ? `${limits.daily.toLocaleString()} daily est. (MODEL_3: real limit UNKNOWN)`
    : `${limits.daily.toLocaleString()} daily`;
  console.log(chalk.green(`  ✓ .ai/token-limits.json (${provider} ${plan}: ${limitLabel})`));
}

async function createAiConfig(targetDir, answers) {
  const provider = answers.provider;
  const plan = answers.plan.toLowerCase();
  const limits = TOKEN_PRESETS[provider]?.[plan] || TOKEN_PRESETS.other.default;
  const archModel = getArchModel(provider, plan);

  // access_type: "billing" for API plans (MODEL_1), "subscription" for all others
  const accessType = archModel === 'MODEL_1' ? 'billing' : 'subscription';

  // Derive market from context choice
  const market = answers.context === 'ukraine-full' ? 'ukraine' : 'international';

  const config = {
    "framework": "ai-workflow-rules",
    "version": "9.1.1",
    "config_version": "2.1",
    "access_type": accessType,
    "model": {
      "name": "claude-sonnet-4-6",
      "context_limit": 200000
    },
    "context": answers.context,
    "modules": [],
    "market": market,
    "language": {
      "internal_dialogue": "adaptive",
      "code_comments": "en",
      "commit_messages": "en",
      "variable_names": "en"
    },
    "token_budget": {
      "daily_limit": limits.daily,
      "monthly_limit": limits.monthly,
      "auto_approve_thresholds": {
        "green_zone": 15000,
        "moderate_zone": 8000,
        "caution_zone": 3000,
        "critical_zone": 0
      }
    },
    "optimizations": {
      "auto_compress": true,
      "post_push_compress": true,
      "lazy_loading": true,
      "diff_only_mode": true
    },
    "workflow": {
      "roadmap_required": true,
      "stage_based_commits": true,
      "discuss_before_execute": true
    },
    "security": {
      "check_forbidden_trackers": true,
      "no_hardcoded_secrets": true,
      "api_key_protection": true
    },
    "detection": {
      "auto_detect_market": true,
      "smart_preset_suggestion": true
    }
  };

  // Add billing block for API plans (access_type == "billing")
  if (accessType === 'billing') {
    config.billing = {
      "cost_per_1k_input": 0.003,
      "cost_per_1k_output": 0.015,
      "daily_budget_usd": 20,
      "_note": "Update cost_per_1k_input/output to match your model pricing. daily_budget_usd = soft spending limit."
    };
  }

  const targetPath = path.join(targetDir, '.ai', 'config.json');

  if (await fs.pathExists(targetPath)) {
    console.log(chalk.yellow('  ⚠️  .ai/config.json already exists, skipping'));
    return;
  }

  await fs.writeJson(targetPath, config, { spaces: 2 });
  console.log(chalk.green(`  ✓ .ai/config.json (context: ${answers.context}, access_type: ${accessType})`));
}

async function installPreCommitHook(targetDir) {
  const gitHooksDir = path.join(targetDir, '.git', 'hooks');

  // Check if .git exists
  if (!await fs.pathExists(path.join(targetDir, '.git'))) {
    console.log(chalk.yellow('  ⚠️  No .git directory found, skipping pre-commit hook'));
    return;
  }

  await fs.ensureDir(gitHooksDir);

  const source = path.join(targetDir, 'scripts', 'pre-commit');
  const target = path.join(gitHooksDir, 'pre-commit');

  await fs.copy(source, target);

  // Make executable (Unix systems)
  if (process.platform !== 'win32') {
    await fs.chmod(target, 0o755);
  }

  console.log(chalk.green('  ✓ Pre-commit hook installed'));
}

async function updateGitignore(targetDir) {
  const gitignorePath = path.join(targetDir, '.gitignore');

  const rulesToAdd = [
    '',
    '# AI Workflow Rules',
    '.ai/.session-started',
    '.ai/checkpoint-*.md',
    'ai-logs/'
  ];

  let gitignoreContent = '';

  if (await fs.pathExists(gitignorePath)) {
    gitignoreContent = await fs.readFile(gitignorePath, 'utf8');
  }

  // Check if rules already exist
  if (gitignoreContent.includes('# AI Workflow Rules')) {
    console.log(chalk.yellow('  ⚠️  .gitignore already contains AI rules, skipping'));
    return;
  }

  // Append rules
  gitignoreContent += '\n' + rulesToAdd.join('\n') + '\n';
  await fs.writeFile(gitignorePath, gitignoreContent);
  console.log(chalk.green('  ✓ .gitignore updated'));
}

// Run
main();
