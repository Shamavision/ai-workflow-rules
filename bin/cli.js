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
const TOKEN_PRESETS = {
  anthropic: {
    free: { monthly: 250000, daily: 8000 },
    pro: { monthly: 5000000, daily: 150000 },
    team: { monthly: 25000000, daily: 800000 }
  },
  openai: {
    free: { monthly: 80000, daily: 4000 },
    plus: { monthly: 800000, daily: 40000 },
    team: { monthly: 4000000, daily: 150000 }
  },
  google: {
    free: { monthly: 400000, daily: 15000 },
    pro: { monthly: 1500000, daily: 80000 }
  },
  cursor: {
    free: { monthly: 150000, daily: 8000 },
    pro: { monthly: 1500000, daily: 80000 }
  },
  github_copilot: {
    free: { monthly: 100000, daily: 5000 },
    individual: { monthly: 500000, daily: 25000 },
    business: { monthly: 2000000, daily: 100000 }
  },
  other: {
    default: { monthly: 500000, daily: 20000 }
  }
};

// Provider and plan mappings
const PROVIDERS = [
  { name: 'Claude (Anthropic)', value: 'anthropic' },
  { name: 'ChatGPT (OpenAI)', value: 'openai' },
  { name: 'Gemini (Google)', value: 'google' },
  { name: 'Cursor', value: 'cursor' },
  { name: 'GitHub Copilot', value: 'github_copilot' },
  { name: 'Other / Custom', value: 'other' }
];

const PLANS = {
  anthropic: ['Free', 'Pro', 'Team'],
  openai: ['Free', 'Plus', 'Team'],
  google: ['Free', 'Pro'],
  cursor: ['Free', 'Pro'],
  github_copilot: ['Free', 'Individual', 'Business'],
  other: ['Default']
};

const LANGUAGES = [
  { name: 'English (en-US)', value: 'en-US' },
  { name: 'Ukrainian (uk-UA)', value: 'uk-UA' },
  { name: 'Russian (ru-RU)', value: 'ru-RU' }
];

async function main() {
  console.log(chalk.bold.cyan('\n🤖 AI Workflow Rules Setup v7.1\n'));
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
        type: 'list',
        name: 'language',
        message: 'Primary language for your project?',
        choices: LANGUAGES,
        default: 'en-US'
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
        message: 'Install RULES_PRODUCT.md? (Ukrainian market specifics)',
        default: false
      }
    ]);

    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold('\n📦 Installing files...\n'));

    const templatesDir = path.join(__dirname, '../npm-templates');
    const currentDir = process.cwd();

    // Copy core files
    await copyFile(templatesDir, currentDir, 'AGENTS.md');
    await copyFile(templatesDir, currentDir, 'RULES_CORE.md');
    await copyFile(templatesDir, currentDir, 'START.md');

    // Copy RULES_PRODUCT.md if requested
    if (answers.installProductRules) {
      await copyFile(templatesDir, currentDir, 'RULES_PRODUCT.md');
    }

    // Create .ai directory
    await fs.ensureDir(path.join(currentDir, '.ai'));

    // Copy forbidden trackers
    await copyFile(
      path.join(templatesDir, '.ai'),
      path.join(currentDir, '.ai'),
      'forbidden-trackers.json'
    );

    // Create token-limits.json with user config
    await createTokenLimitsConfig(currentDir, answers);

    // Create scripts directory
    await fs.ensureDir(path.join(currentDir, 'scripts'));

    // Copy pre-commit script
    await copyFile(
      path.join(templatesDir, 'scripts'),
      path.join(currentDir, 'scripts'),
      'pre-commit'
    );

    // Install pre-commit hook
    if (answers.installHooks) {
      await installPreCommitHook(currentDir);
    }

    // Update .gitignore
    if (answers.updateGitignore) {
      await updateGitignore(currentDir);
    }

    // Success message
    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold.green('\n🎉 Setup complete!\n'));
    console.log(chalk.bold('Next steps:'));
    console.log(chalk.gray('  1. Open your project in your AI assistant'));
    console.log(chalk.gray('  2. Type ') + chalk.cyan('//START') + chalk.gray(' in the chat'));
    console.log(chalk.gray('  3. AI will load rules and start working\n'));
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

async function createTokenLimitsConfig(targetDir, answers) {
  const provider = answers.provider;
  const plan = answers.plan.toLowerCase();

  const limits = TOKEN_PRESETS[provider]?.[plan] || TOKEN_PRESETS.other.default;

  const config = {
    "_comment": "🤖 Universal AI Token Tracker v3.0 - Auto-configured",
    "provider": provider,
    "plan": plan,
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

  const targetPath = path.join(targetDir, '.ai', 'token-limits.json');
  await fs.writeJson(targetPath, config, { spaces: 2 });
  console.log(chalk.green(`  ✓ .ai/token-limits.json (${provider} ${plan}: ${limits.daily.toLocaleString()} daily)`));
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
