# ========================================
# AI Workflow Rules - Automatic Setup (PowerShell)
# ========================================
#
# This script automates the installation and configuration
# of AI Workflow Rules Framework in your project.
#
# Usage:
#   .\scripts\setup.ps1
#
# ========================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "🚀 AI Workflow Rules Framework - Setup" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------
# Step 1: Install Git Hooks
# ----------------------------------------

Write-Host "📦 Step 1/5: Installing Git hooks..." -ForegroundColor Yellow

$hookPath = ".git\hooks\pre-commit"
$hookSamplePath = ".git\hooks\pre-commit.sample"

if (Test-Path $hookPath) {
    Write-Host "⚠️  Pre-commit hook already exists. Backing up..." -ForegroundColor Yellow
    Move-Item -Path $hookPath -Destination "$hookPath.backup" -Force
    Write-Host "   Backup saved: $hookPath.backup"
}

if (Test-Path $hookSamplePath) {
    Copy-Item -Path $hookSamplePath -Destination $hookPath -Force
    Write-Host "✅ Pre-commit hook installed" -ForegroundColor Green
    Write-Host "   Note: Use Git Bash or WSL to run git commands (hooks require bash)" -ForegroundColor Gray
} else {
    Write-Host "⚠️  No pre-commit.sample found, skipping hook installation" -ForegroundColor Yellow
}

# ----------------------------------------
# Step 2: Configure Token Limits
# ----------------------------------------

Write-Host ""
Write-Host "🤖 Step 2/5: Configure token limits..." -ForegroundColor Yellow

$tokenLimitsPath = ".ai\token-limits.json"

if (Test-Path $tokenLimitsPath) {
    $config = Get-Content $tokenLimitsPath | ConvertFrom-Json
    Write-Host "Current provider: $($config.provider)"
    Write-Host "Current plan: $($config.plan)"
    Write-Host ""

    $updateConfig = Read-Host "Do you want to update provider/plan? (y/n)"

    if ($updateConfig -eq "y" -or $updateConfig -eq "Y") {
        Write-Host ""
        Write-Host "Select your AI provider:"
        Write-Host "  1) Anthropic (Claude)"
        Write-Host "  2) OpenAI (ChatGPT)"
        Write-Host "  3) Google (Gemini)"
        Write-Host "  4) Cursor"
        Write-Host "  5) GitHub Copilot"
        Write-Host "  6) Custom"
        $providerChoice = Read-Host "Enter number (1-6)"

        $provider = switch ($providerChoice) {
            "1" { "anthropic" }
            "2" { "openai" }
            "3" { "google" }
            "4" { "cursor" }
            "5" { "github_copilot" }
            "6" { "custom" }
            default { $null }
        }

        if ($provider) {
            Write-Host ""
            Write-Host "Select your plan:"
            Write-Host "  1) Free"
            Write-Host "  2) Pro / Plus"
            Write-Host "  3) Team / Business"
            $planChoice = Read-Host "Enter number (1-3)"

            $plan = switch ($planChoice) {
                "1" { "free" }
                "2" { "pro" }
                "3" { "team" }
                default { $null }
            }

            if ($plan) {
                $config.provider = $provider
                $config.plan = $plan
                $config | ConvertTo-Json -Depth 10 | Set-Content $tokenLimitsPath
                Write-Host "✅ Updated to $provider ($plan)" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "✅ Keeping current configuration" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  .ai\token-limits.json not found, skipping configuration" -ForegroundColor Yellow
}

# ----------------------------------------
# Step 3: Setup Environment File
# ----------------------------------------

Write-Host ""
Write-Host "🔐 Step 3/5: Setup environment variables..." -ForegroundColor Yellow

if (Test-Path ".env") {
    Write-Host "⚠️  .env file already exists, skipping creation" -ForegroundColor Yellow
    Write-Host "   (To recreate, delete .env and run setup again)"
} else {
    if (Test-Path ".env.example") {
        Copy-Item -Path ".env.example" -Destination ".env" -Force
        Write-Host "✅ Created .env from template" -ForegroundColor Green
        Write-Host "   ⚠️  Remember to fill in your API keys in .env file!" -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  .env.example not found, skipping .env creation" -ForegroundColor Yellow
    }
}

# ----------------------------------------
# Step 4: Verify Installation
# ----------------------------------------

Write-Host ""
Write-Host "🔍 Step 4/5: Verifying installation..." -ForegroundColor Yellow

$issues = 0

# Check essential files
if (Test-Path "RULES_CORE.md") {
    Write-Host "✅ RULES_CORE.md" -ForegroundColor Green
} else {
    Write-Host "❌ Missing RULES_CORE.md" -ForegroundColor Red
    $issues++
}

if (Test-Path ".ai\token-limits.json") {
    Write-Host "✅ .ai\token-limits.json" -ForegroundColor Green
} else {
    Write-Host "❌ Missing .ai\token-limits.json" -ForegroundColor Red
    $issues++
}

if (Test-Path ".ai\forbidden-trackers.json") {
    Write-Host "✅ .ai\forbidden-trackers.json" -ForegroundColor Green
} else {
    Write-Host "❌ Missing .ai\forbidden-trackers.json" -ForegroundColor Red
    $issues++
}

if (Test-Path ".git\hooks\pre-commit") {
    Write-Host "✅ Pre-commit hook" -ForegroundColor Green
} else {
    Write-Host "⚠️  Pre-commit hook missing" -ForegroundColor Yellow
    $issues++
}

if (Test-Path "scripts\seo-check.sh") {
    Write-Host "✅ scripts\seo-check.sh" -ForegroundColor Green
} else {
    Write-Host "⚠️  Missing scripts\seo-check.sh" -ForegroundColor Yellow
}

# ----------------------------------------
# Step 5: Summary
# ----------------------------------------

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
if ($issues -eq 0) {
    Write-Host "✅ Setup complete!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Setup complete with $issues warning(s)" -ForegroundColor Yellow
    Write-Host "   Check messages above for details"
}
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Edit .env file with your API keys"
Write-Host "   2. Read QUICKSTART.md for quick start guide"
Write-Host "   3. Read CHEATSHEET.md for one-page reference"
Write-Host "   4. Run 'bash scripts/seo-check.sh .' to verify (requires Git Bash)"
Write-Host ""
Write-Host "🤖 For AI assistants:" -ForegroundColor Cyan
Write-Host "   - Claude Code/Cursor: Rules loaded automatically"
Write-Host "   - ChatGPT/Gemini: Copy START.md content into first message"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
Write-Host ""
