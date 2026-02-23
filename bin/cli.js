#!/usr/bin/env node

/**
 * AI Workflow Rules - CLI Installer
 * Universal setup wizard for AI coding assistants
 */

const { select, intro, outro, isCancel, cancel, log } = require('@clack/prompts');
const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');

// Tool/plan presets — loaded from presets.json (v1.0)
// No hardcoded limits: session_limit from public docs, daily_limit = null (not published)
const PRESETS_PATH = path.join(__dirname, '../npm-templates/.ai/presets.json');

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
  { name: 'Ukraine-Full - Ukrainian businesses (~18k tokens, v9.1)', value: 'ukraine-full', tokens: 18000 }
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

  // Detect AI tools (v9.1: Only generate IDE-specific files)
  // Note: AGENTS.md and .claude/CLAUDE.md are now static templates (copied, not generated)
  const tools = [
    { name: 'Cursor (legacy <0.45)', file: '.cursorrules' },
    { name: 'Cursor (new ≥0.45)', file: '.cursor/rules/ai-workflow.mdc', addFrontmatter: true }
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

    let header;
    if (tool.addFrontmatter) {
      header = `---
description: AI Workflow Rules — session protocol, token management, security guards
globs: ["**/*"]
alwaysApply: true
---

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
    } else {
      header = `# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
    }

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


async function main() {
  intro(chalk.bold.cyan('🤖 AI Workflow Rules Setup v9.1'));
  console.log(chalk.gray('Universal framework for AI coding assistants\n'));

  try {
    const provider = await select({
      message: 'What AI provider are you using?',
      options: PROVIDERS.map(p => ({ value: p.value, label: p.name }))
    });
    if (isCancel(provider)) { cancel('Setup cancelled.'); process.exit(0); }

    const planOptions = (PLANS[provider] || PLANS.other).map(p => ({ value: p, label: p }));
    const plan = await select({
      message: `What's your ${provider} plan?`,
      options: planOptions
    });
    if (isCancel(plan)) { cancel('Setup cancelled.'); process.exit(0); }

    const market = await select({
      message: 'Primary market?',
      options: [
        { value: 'ukraine', label: 'Ukrainian market', hint: 'ukraine-full context + compliance rules' },
        { value: 'international', label: 'International', hint: 'minimal context' }
      ]
    });
    if (isCancel(market)) { cancel('Setup cancelled.'); process.exit(0); }

    const selectedContext = market === 'ukraine' ? 'ukraine-full' : 'minimal';
    const installProductRules = market === 'ukraine';

    log.success(`Context: ${selectedContext}`);

    const answers = {
      provider,
      plan,
      installHooks: true,          // always
      updateGitignore: true,       // always
      installProductRules,         // from market
      context: selectedContext
    };

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

    // Copy Claude Code skills (/ctx, /sculptor, /arbiter)
    await fs.ensureDir(path.join(currentDir, '.claude', 'commands'));
    for (const skill of ['ctx.md', 'sculptor.md', 'arbiter.md']) {
      await copyFile(
        path.join(templatesDir, '.claude', 'commands'),
        path.join(currentDir, '.claude', 'commands'),
        skill
      );
    }

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
    await copyFile(
      path.join(templatesDir, 'scripts'),
      path.join(currentDir, 'scripts'),
      'post-push.sh'
    );

    // Install pre-commit hook
    if (answers.installHooks) {
      await installPreCommitHook(currentDir);
    }

    // Install post-push hook (session memory anchor — always automatic)
    await installPostPushHook(currentDir);

    // Update .gitignore
    if (answers.updateGitignore) {
      await updateGitignore(currentDir);
    }

    // Generate rules for AI tools (reads from .ai/contexts/ copied above)
    await generateRulesFiles(currentDir, answers.context);

    // Success
    outro(chalk.bold.green('🎉 Setup complete!'));
    console.log(chalk.bold('\nNext steps:'));
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
    log.error(`Setup failed: ${error.message}`);
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
    'ukraine-full.context.md'
  ];

  for (const file of contextFiles) {
    await copyFile(sourceContextsDir, targetContextsDir, file);
  }
}

async function createTokenLimitsConfig(targetDir, answers) {
  const provider = answers.provider;
  const plan = answers.plan.toLowerCase();

  const presets = await fs.readJson(PRESETS_PATH);
  const key = `${provider}.${plan}`;
  const mapping = presets.mappings[key] || presets.default;
  const billingInfo = presets.billing_types[mapping.billing] || presets.billing_types.subscription;

  const config = {
    "_comment": "AI Token Tracker v4.0 — session-based. New day = fresh limits.",
    "tool": provider,
    "plan": plan,
    "billing": mapping.billing,
    "session_limit": mapping.session_limit,
    "session_thresholds": billingInfo.session_thresholds,
    "daily_limit": null,
    "daily_note": billingInfo.daily_note,
    "today": new Date().toISOString().split('T')[0],
    "today_sessions": 0,
    "today_estimated_tokens": 0,
    "sessions": []
  };

  const targetPath = path.join(targetDir, '.ai', 'token-limits.json');
  await fs.writeJson(targetPath, config, { spaces: 2 });

  const sessionLabel = mapping.session_limit
    ? `session: ${Math.round(mapping.session_limit / 1000)}k`
    : 'session: unknown (not published)';
  console.log(chalk.green(`  ✓ .ai/token-limits.json (${provider} ${plan}: ${sessionLabel}, ${mapping.billing})`));
}

async function createAiConfig(targetDir, answers) {
  const provider = answers.provider;
  const plan = answers.plan.toLowerCase();

  const presets = await fs.readJson(PRESETS_PATH);
  const key = `${provider}.${plan}`;
  const mapping = presets.mappings[key] || presets.default;

  const market = answers.context === 'ukraine-full' ? 'ukraine' : 'international';

  const config = {
    "framework": "ai-workflow-rules",
    "version": "9.1.1",
    "config_version": "2.2",
    "access_type": mapping.billing,
    "model": {
      "name": "claude-sonnet-4-6",
      "context_limit": mapping.session_limit || 200000
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

  const targetPath = path.join(targetDir, '.ai', 'config.json');

  if (await fs.pathExists(targetPath)) {
    console.log(chalk.yellow('  ⚠️  .ai/config.json already exists, skipping'));
    return;
  }

  await fs.writeJson(targetPath, config, { spaces: 2 });
  console.log(chalk.green(`  ✓ .ai/config.json (context: ${answers.context}, access_type: ${mapping.billing})`));
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

async function installPostPushHook(targetDir) {
  const gitDir = path.join(targetDir, '.git');
  const gitHooksDir = path.join(gitDir, 'hooks');

  // Skip silently if no .git (not a git repo)
  if (!await fs.pathExists(gitDir)) {
    return;
  }

  await fs.ensureDir(gitHooksDir);

  const source = path.join(targetDir, 'scripts', 'post-push.sh');
  const target = path.join(gitHooksDir, 'post-push');

  // Skip if post-push.sh not found in scripts/ (shouldn't happen, but defensive)
  if (!await fs.pathExists(source)) {
    return;
  }

  await fs.copy(source, target);

  // Make executable (Unix systems)
  if (process.platform !== 'win32') {
    await fs.chmod(target, 0o755);
  }

  console.log(chalk.green('  ✓ Post-push hook installed (session memory anchor)'));
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
