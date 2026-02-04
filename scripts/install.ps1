# ========================================
# AI Workflow Rules - One-Line Installer (Windows)
# ========================================
#
# Usage:
#   iwr -useb https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.ps1 | iex
#
# This script will:
#   1. Download AI Workflow Rules from GitHub
#   2. Copy all necessary files to your project
#   3. Configure git hooks
#   4. Setup token limits for your AI provider
#
# ========================================

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/Shamavision/ai-workflow-rules.git"
$TempDir = Join-Path $env:TEMP "ai-workflow-rules-$(Get-Random)"
$TargetDir = Get-Location

# ========================================
# Helper Functions
# ========================================

function Print-Header {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║  AI Workflow Rules - Installation Wizard  ║" -ForegroundColor Blue
    Write-Host "║           Made in Ukraine 🇺🇦              ║" -ForegroundColor Blue
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

function Print-Step {
    param([string]$Message)
    Write-Host "▶ $Message" -ForegroundColor Blue
}

function Print-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Cleanup {
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ========================================
# Pre-flight Checks
# ========================================

Print-Header

Print-Step "Running pre-flight checks..."

# Check if git is installed
try {
    $null = git --version
} catch {
    Print-Error "Git is not installed. Please install Git for Windows first."
    Print-Warning "Download from: https://git-scm.com/download/win"
    exit 1
}

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Print-Warning "Not a git repository. Initializing git..."
    git init
    Print-Success "Git repository initialized"
}

Print-Success "Pre-flight checks passed"

# ========================================
# Confirmation
# ========================================

Write-Host ""
Write-Host "Installation directory: " -NoNewline
Write-Host $TargetDir -ForegroundColor Yellow
Write-Host ""
Write-Host "This will install AI Workflow Rules Framework in your project."
Write-Host "Files will be copied: .ai/, RULES_*.md, scripts/, etc."
Write-Host ""

$Confirmation = Read-Host "Continue? (y/n)"
if ($Confirmation -notmatch '^[Yy]$') {
    Print-Warning "Installation cancelled"
    exit 0
}

# ========================================
# Download Repository
# ========================================

Print-Step "Downloading AI Workflow Rules from GitHub..."

try {
    git clone --depth 1 --quiet $RepoUrl $TempDir 2>$null
    Print-Success "Repository downloaded to temporary directory"
} catch {
    Print-Error "Failed to download repository"
    exit 1
}

# ========================================
# Copy Files
# ========================================

Print-Step "Copying files to your project..."

# Copy .ai directory
if (Test-Path "$TempDir\.ai") {
    if (-not (Test-Path "$TargetDir\.ai")) {
        New-Item -Path "$TargetDir\.ai" -ItemType Directory -Force | Out-Null
    }
    Copy-Item -Path "$TempDir\.ai\*" -Destination "$TargetDir\.ai\" -Recurse -Force
    Print-Success "Copied .ai/ configuration"
}

# Copy RULES files
Get-ChildItem -Path "$TempDir\RULES_*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $TargetDir -Force
    Print-Success "Copied $($_.Name)"
}

# Copy documentation files
$Docs = @("AGENTS.md", "START.md", "CHEATSHEET.md", "QUICKSTART.md", "TOKEN_USAGE.md", "AI_COMPATIBILITY.md", "INSTALL.md")
foreach ($Doc in $Docs) {
    if (Test-Path "$TempDir\$Doc") {
        Copy-Item -Path "$TempDir\$Doc" -Destination $TargetDir -Force
        Print-Success "Copied $Doc"
    }
}

# Copy scripts directory
if (Test-Path "$TempDir\scripts") {
    if (-not (Test-Path "$TargetDir\scripts")) {
        New-Item -Path "$TargetDir\scripts" -ItemType Directory -Force | Out-Null
    }
    Copy-Item -Path "$TempDir\scripts\*" -Destination "$TargetDir\scripts\" -Recurse -Force
    Print-Success "Copied scripts/ directory"
}

# Copy .editorconfig
if (Test-Path "$TempDir\.editorconfig") {
    Copy-Item -Path "$TempDir\.editorconfig" -Destination $TargetDir -Force
    Print-Success "Copied .editorconfig"
}

# Copy .env.example
if (Test-Path "$TempDir\.env.example") {
    Copy-Item -Path "$TempDir\.env.example" -Destination $TargetDir -Force
    Print-Success "Copied .env.example"
}

# Update .gitignore
Print-Step "Updating .gitignore..."

$GitignoreEntries = @(
    ".ai/.session-started",
    ".env",
    "node_modules/"
)

$GitignorePath = "$TargetDir\.gitignore"
if (-not (Test-Path $GitignorePath)) {
    New-Item -Path $GitignorePath -ItemType File -Force | Out-Null
}

$ExistingContent = Get-Content $GitignorePath -ErrorAction SilentlyContinue
foreach ($Entry in $GitignoreEntries) {
    if ($ExistingContent -notcontains $Entry) {
        Add-Content -Path $GitignorePath -Value $Entry
    }
}

Print-Success "Updated .gitignore"

# ========================================
# Install Git Hooks
# ========================================

Print-Step "Installing git pre-commit hook..."

if (Test-Path "$TargetDir\scripts\pre-commit") {
    $HooksDir = "$TargetDir\.git\hooks"
    if (-not (Test-Path $HooksDir)) {
        New-Item -Path $HooksDir -ItemType Directory -Force | Out-Null
    }

    $PreCommitPath = "$HooksDir\pre-commit"
    if (Test-Path $PreCommitPath) {
        Print-Warning "Pre-commit hook already exists, backing up..."
        Move-Item -Path $PreCommitPath -Destination "$PreCommitPath.backup" -Force
        Print-Success "Backup saved: .git\hooks\pre-commit.backup"
    }

    Copy-Item -Path "$TargetDir\scripts\pre-commit" -Destination $PreCommitPath -Force
    Print-Success "Pre-commit hook installed"
} else {
    Print-Warning "Pre-commit hook not found, skipping"
}

# ========================================
# Configure Token Limits
# ========================================

Print-Step "Configuring AI token limits..."

Write-Host ""
Write-Host "Select your AI provider:"
Write-Host "  1) Anthropic (Claude)"
Write-Host "  2) OpenAI (ChatGPT)"
Write-Host "  3) Google (Gemini)"
Write-Host "  4) Cursor"
Write-Host "  5) GitHub Copilot"
Write-Host "  6) Custom / Skip"
Write-Host ""

$ProviderChoice = Read-Host "Enter number (1-6)"

$Provider = switch ($ProviderChoice) {
    "1" { "anthropic" }
    "2" { "openai" }
    "3" { "google" }
    "4" { "cursor" }
    "5" { "github_copilot" }
    default { "anthropic" }
}

Write-Host ""
Write-Host "Select your plan:"
Write-Host "  1) Free"
Write-Host "  2) Pro / Plus"
Write-Host "  3) Team / Business"
Write-Host ""

$PlanChoice = Read-Host "Enter number (1-3)"

$Plan = switch ($PlanChoice) {
    "1" { "free" }
    "2" { "pro" }
    "3" { "team" }
    default { "pro" }
}

# Update token-limits.json
$TokenLimitsPath = "$TargetDir\.ai\token-limits.json"
if (Test-Path $TokenLimitsPath) {
    $Content = Get-Content $TokenLimitsPath -Raw
    $Content = $Content -replace '"provider":\s*"[^"]*"', "`"provider`": `"$Provider`""
    $Content = $Content -replace '"plan":\s*"[^"]*"', "`"plan`": `"$Plan`""
    Set-Content -Path $TokenLimitsPath -Value $Content -NoNewline
    Print-Success "Configured for $Provider ($Plan)"
} else {
    Print-Warning "token-limits.json not found"
}

# ========================================
# Context Selection (v8.1 Modular)
# ========================================

Print-Step "Selecting project context..."

Write-Host ""
Write-Host "Which context fits your project best?"
Write-Host ""
Write-Host "  1) " -NoNewline
Write-Host "Minimal" -ForegroundColor Green -NoNewline
Write-Host " - Startups, MVP, quick projects"
Write-Host "     (~13k tokens, 6.5% daily budget)"
Write-Host "     Core workflow + essential security"
Write-Host ""
Write-Host "  2) " -NoNewline
Write-Host "Standard" -ForegroundColor Green -NoNewline
Write-Host " - Most international projects (RECOMMENDED)"
Write-Host "     (~18k tokens, 9% daily budget)"
Write-Host "     Full workflow + token management + git discipline"
Write-Host ""
Write-Host "  3) " -NoNewline
Write-Host "Ukraine-Full" -ForegroundColor Yellow -NoNewline
Write-Host " - Ukrainian businesses"
Write-Host "     (~25k tokens, 12.5% daily budget)"
Write-Host "     Everything + Ukrainian compliance + cyber defense"
Write-Host ""
Write-Host "  4) " -NoNewline
Write-Host "Enterprise" -ForegroundColor Blue -NoNewline
Write-Host " - Large teams, complex projects"
Write-Host "     (~30k tokens, 15% daily budget)"
Write-Host "     Maximum features + team collaboration"
Write-Host ""

$ContextChoice = Read-Host "Enter number (1-4, default: 2)"

$Context = switch ($ContextChoice) {
    "1" { "minimal" }
    "2" { "standard" }
    "3" { "ukraine-full" }
    "4" { "enterprise" }
    default { "standard" }
}

# Update config.json with selected context
$ConfigPath = "$TargetDir\.ai\config.json"
if (Test-Path $ConfigPath) {
    $ConfigContent = Get-Content $ConfigPath -Raw
    $ConfigContent = $ConfigContent -replace '"context":\s*"[^"]*"', "`"context`": `"$Context`""
    Set-Content -Path $ConfigPath -Value $ConfigContent -NoNewline
    Print-Success "Context configured: $Context"
} else {
    Print-Warning "config.json not found"
}

# ========================================
# Create .env if needed
# ========================================

Print-Step "Setting up environment file..."

if (Test-Path "$TargetDir\.env") {
    Print-Warning ".env already exists, skipping"
} else {
    if (Test-Path "$TargetDir\.env.example") {
        Copy-Item -Path "$TargetDir\.env.example" -Destination "$TargetDir\.env" -Force
        Print-Success "Created .env from template"
        Print-Warning "Remember to add your API keys to .env file!"
    }
}

# ========================================
# Verification
# ========================================

Print-Step "Verifying installation..."

$Issues = 0

# Check essential files
$FilesToCheck = @(
    "RULES_CORE.md",
    "RULES_PRODUCT.md",
    "AGENTS.md",
    ".ai\config.json",
    ".ai\contexts\minimal.context.md",
    ".ai\contexts\standard.context.md",
    ".ai\contexts\ukraine-full.context.md",
    ".ai\contexts\enterprise.context.md",
    ".ai\token-limits.json",
    ".ai\forbidden-trackers.json",
    "scripts\seo-check.sh"
)

foreach ($File in $FilesToCheck) {
    if (Test-Path "$TargetDir\$File") {
        Print-Success $File
    } else {
        Print-Warning "Missing $File"
        $Issues++
    }
}

# Check git hook
if (Test-Path "$TargetDir\.git\hooks\pre-commit") {
    Print-Success "Pre-commit hook"
} else {
    Print-Warning "Pre-commit hook not found"
    $Issues++
}

# ========================================
# Cleanup
# ========================================

Cleanup

# ========================================
# Summary
# ========================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Blue

if ($Issues -eq 0) {
    Write-Host "║" -NoNewline -ForegroundColor Blue
    Write-Host "  ✓ Installation Complete!                 " -NoNewline -ForegroundColor Green
    Write-Host "║" -ForegroundColor Blue
} else {
    Write-Host "║" -NoNewline -ForegroundColor Blue
    Write-Host "  ⚠ Installation Complete with warnings    " -NoNewline -ForegroundColor Yellow
    Write-Host "║" -ForegroundColor Blue
}

Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

Write-Host "✓ AI Workflow Rules Framework v8.1 installed" -ForegroundColor Green
Write-Host "   Context: " -NoNewline -ForegroundColor Blue
Write-Host $Context -ForegroundColor Blue
Write-Host ""
Write-Host "📚 Next Steps:"
Write-Host ""
Write-Host "  1. Configure your API keys:"
Write-Host "     " -NoNewline
Write-Host "notepad .env" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Start AI session (Claude Code, Cursor, etc.):"
Write-Host "     " -NoNewline
Write-Host "//START" -ForegroundColor Yellow
Write-Host ""
Write-Host "     AI will load $Context context automatically."
Write-Host ""
Write-Host "  3. Read quick start guide:"
Write-Host "     " -NoNewline
Write-Host "Get-Content QUICKSTART.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Verify your project (optional):"
Write-Host "     " -NoNewline
Write-Host "bash scripts/seo-check.sh ." -ForegroundColor Yellow
Write-Host ""
Write-Host "🤖 Universal AI Support:" -ForegroundColor Blue
Write-Host "   - Claude Code, Cursor, Windsurf: Auto-loads AGENTS.md ✓"
Write-Host "   - ChatGPT, Gemini (web): Use //START command"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
Write-Host ""
Write-Host "Made with ❤️ in Ukraine 🇺🇦" -ForegroundColor Blue
Write-Host "https://wellme.ua" -ForegroundColor Blue
Write-Host ""
