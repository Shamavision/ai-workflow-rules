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

const CONTEXTS = [
  { name: 'Minimal - Startups, MVP (~10k tokens, v9.1)', value: 'minimal', tokens: 10000 },
  { name: 'Standard - Most projects (~14k tokens, v9.1)', value: 'standard', tokens: 14000 },
  { name: 'Ukraine-Full - Ukrainian businesses (~18k tokens, v9.1)', value: 'ukraine-full', tokens: 18000 },
  { name: 'Enterprise - Large teams (~23k tokens, v9.1)', value: 'enterprise', tokens: 23000 }
];

// Function: Generate rules files for AI tools
async function generateRulesFiles(targetDir, context) {
  console.log(chalk.cyan('\n🤖 Generating rules for AI tools...\n'));

  const sourceRules = path.join(targetDir, '.ai', 'contexts', `${context}.context.md`);

  if (!await fs.pathExists(sourceRules)) {
    console.log(chalk.yellow('⚠️  Source rules not found, skipping'));
    return;
  }

  const sourceContent = await fs.readFile(sourceRules, 'utf8');

  // Detect AI tools
  const tools = [
    { name: 'Claude VSCode Extension', file: '.claude/CLAUDE.md' },
    { name: 'Universal (all AI tools)', file: 'AGENTS.md' }
  ];

  // Check for Cursor
  if (await fs.pathExists(path.join(targetDir, '.cursorrules'))) {
    tools.push({ name: 'Cursor', file: '.cursorrules' });
  }

  // Check for Windsurf
  if (await fs.pathExists(path.join(targetDir, '.windsurfrules'))) {
    tools.push({ name: 'Windsurf', file: '.windsurfrules' });
  }

  console.log(chalk.gray(`Found: ${tools.length} tool(s)\n`));

  // Generate files
  for (const tool of tools) {
    const targetFile = path.join(targetDir, tool.file);
    const targetDir_file = path.dirname(targetFile);

    // Ensure directory exists
    await fs.ensureDir(targetDir_file);

    console.log(chalk.gray(`  → Generating ${tool.file} for ${tool.name}...`));

    const header = `# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI WORKFLOW RULES FRAMEWORK v9.0
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
  }

  console.log(chalk.green(`\n✓ Rules generated for ${tools.length} AI tool(s)\n`));
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
      message: 'Token budget priority?',
      choices: [
        { name: 'High priority (minimize token usage)', value: 'high' },
        { name: 'Medium (balanced)', value: 'medium' },
        { name: 'Low (prefer full features)', value: 'low' }
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
  console.log('│ Context         │ Tokens     │ Daily %     │ Best For             │');
  console.log('├─────────────────┼────────────┼─────────────┼──────────────────────┤');
  console.log('│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │');
  console.log('│ Standard        │ ~14k       │ 7%          │ Most projects        │');
  console.log('│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │');
  console.log('│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │');
  console.log('└─────────────────┴────────────┴─────────────┴──────────────────────┘\n');

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
  console.log(chalk.bold.cyan('\n🤖 AI Workflow Rules Setup v9.0\n'));
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

    // Smart context selection (v9.1)
    const selectedContext = await selectContextWithRecommendation();
    answers.context = selectedContext;

    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold('\n📦 Installing files...\n'));

    const templatesDir = path.join(__dirname, '../npm-templates');
    const currentDir = process.cwd();

    // Copy core files
    await copyFile(templatesDir, currentDir, 'AGENTS.md');
    await copyFile(templatesDir, currentDir, 'RULES_CORE.md');
    await copyFile(templatesDir, currentDir, 'START.md');

    // Copy documentation files
    await copyFile(templatesDir, currentDir, 'CHEATSHEET.md');
    await copyFile(templatesDir, currentDir, 'QUICKSTART.md');
    await copyFile(templatesDir, currentDir, 'TOKEN_USAGE.md');
    await copyFile(templatesDir, currentDir, 'AI_COMPATIBILITY.md');
    await copyFile(templatesDir, currentDir, 'LICENSE');

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

    // Generate rules for AI tools
    await generateRulesFiles(currentDir, answers.context);

    // Success message
    console.log('\n' + chalk.gray('━'.repeat(50)));
    console.log(chalk.bold.green('\n🎉 Setup complete!\n'));
    console.log(chalk.bold('Next steps:'));
    console.log(chalk.gray('  1. Open your project in your AI assistant'));
    console.log(chalk.gray('  2. Type ') + chalk.cyan('//START') + chalk.gray(' in the chat'));
    console.log(chalk.gray('  3. AI will load rules and start working\n'));
    console.log(chalk.bold.blue('🛡️  AI Protection v9.0 enabled:'));
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
