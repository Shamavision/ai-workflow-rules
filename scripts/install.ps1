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
# ⚠️ v9.1 WARNING: This installer needs update for new .ai/ hub structure
# Recommended: Use npx @shamavision/ai-workflow-rules instead (bin/cli.js)

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
# Context Selection (v9.1 Smart Selection)
# ========================================

Print-Step "Context Selection Wizard (v9.1)..."

Write-Host ""
Write-Host "📊 Answer a few questions for personalized recommendation" -ForegroundColor Cyan
Write-Host ""

# Question 1: Team size
Write-Host "1. How many team members?"
Write-Host "   1) 1-2 developers (solo/small)"
Write-Host "   2) 3-5 developers (team)"
Write-Host "   3) 6+ developers (large team)"
Write-Host ""
$TeamSize = Read-Host "Enter number (1-3)"
Write-Host ""

# Question 2: Market
Write-Host "2. Primary market?"
Write-Host "   1) Ukrainian market (compliance, language rules)"
Write-Host "   2) International (English-focused)"
Write-Host ""
$Market = Read-Host "Enter number (1-2)"
Write-Host ""

# Question 3: Token priority
Write-Host "3. Token budget priority?"
Write-Host "   1) High priority (minimize token usage)"
Write-Host "   2) Medium (balanced)"
Write-Host "   3) Low (prefer full features)"
Write-Host ""
$TokenPriority = Read-Host "Enter number (1-3)"
Write-Host ""

# Recommendation logic
$Recommended = ""
$Reason = ""

if ($Market -eq "1") {
    $Recommended = "ukraine-full"
    $Reason = "Ukrainian market needs full compliance features"
} elseif ($TokenPriority -eq "1") {
    $Recommended = "minimal"
    $Reason = "Token efficiency prioritized"
} elseif ($TeamSize -eq "3" -or $TokenPriority -eq "3") {
    $Recommended = "enterprise"
    if ($TeamSize -eq "3") {
        $Reason = "Large team benefits from enterprise workflows"
    } else {
        $Reason = "Full features prioritized"
    }
} else {
    $Recommended = "standard"
    $Reason = "Balanced approach for most projects"
}

# Show comparison table
Write-Host ""
Write-Host "📊 Context Comparison (v9.1 optimized)" -ForegroundColor Cyan
Write-Host ""
Write-Host "┌─────────────────┬────────────┬─────────────┬──────────────────────┐"
Write-Host "│ Context         │ Tokens     │ Daily %     │ Best For             │"
Write-Host "├─────────────────┼────────────┼─────────────┼──────────────────────┤"
Write-Host "│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │"
Write-Host "│ Standard        │ ~14k       │ 7%          │ Most projects        │"
Write-Host "│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │"
Write-Host "│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │"
Write-Host "└─────────────────┴────────────┴─────────────┴──────────────────────┘"
Write-Host ""

# Show recommendation
Write-Host "✅ Recommended: " -NoNewline -ForegroundColor Green
Write-Host $Recommended -ForegroundColor Green
Write-Host "   Reasoning: $Reason" -ForegroundColor Gray
Write-Host ""

# Confirm or choose manually
$ConfirmChoice = Read-Host "Use $Recommended? (Y/n)"

if ([string]::IsNullOrEmpty($ConfirmChoice) -or $ConfirmChoice -match "^[Yy]") {
    $Context = $Recommended
} else {
    # Manual selection
    Write-Host ""
    Write-Host "Choose context manually:"
    Write-Host "  1) Minimal (~10k tokens)"
    Write-Host "  2) Standard (~14k tokens)"
    Write-Host "  3) Ukraine-Full (~18k tokens)"
    Write-Host "  4) Enterprise (~23k tokens)"
    Write-Host ""
    $ManualChoice = Read-Host "Enter number (1-4)"

    $Context = switch ($ManualChoice) {
        "1" { "minimal" }
        "2" { "standard" }
        "3" { "ukraine-full" }
        "4" { "enterprise" }
        default { $Recommended }
    }
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
# Generate Rules for AI Tools (v9.0 Universal)
# ========================================

Print-Step "Generating rules for AI tools..."

$SourceRules = "$TargetDir\.ai\contexts\$Context.context.md"

if (-Not (Test-Path $SourceRules)) {
    Print-Warning "Source rules not found: $SourceRules"
} else {
    Write-Host ""
    Write-Host "Detecting AI tools..." -ForegroundColor Cyan
    Write-Host ""

    # Detect AI tools (Windows typically uses VSCode)
    $AITools = @()

    # Always create for Claude VSCode Extension
    $AITools += @{Name="Claude VSCode Extension"; File=".claude\CLAUDE.md"}

    # Always create AGENTS.md (universal)
    $AITools += @{Name="Universal (all AI tools)"; File="AGENTS.md"}

    # Check for Cursor
    if ((Test-Path "$TargetDir\.cursorrules") -or (Test-Path "$env:LOCALAPPDATA\Cursor")) {
        $AITools += @{Name="Cursor"; File=".cursorrules"}
    }

    # Check for Windsurf
    if (Test-Path "$TargetDir\.windsurfrules") {
        $AITools += @{Name="Windsurf"; File=".windsurfrules"}
    }

    Write-Host "Found: $($AITools.Count) tool(s)" -ForegroundColor Cyan
    Write-Host ""

    # Function to generate rules file
    function Generate-RulesFile {
        param($ToolName, $TargetFile)

        $FullPath = "$TargetDir\$TargetFile"
        $TargetDir_File = Split-Path $FullPath -Parent

        # Create directory if needed
        if (-Not (Test-Path $TargetDir_File)) {
            New-Item -ItemType Directory -Path $TargetDir_File -Force | Out-Null
        }

        Write-Host "  → Generating $TargetFile for $ToolName..." -ForegroundColor Cyan

        # Header
        $Header = @"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI WORKFLOW RULES FRAMEWORK v9.0
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Tool: $ToolName
# Context: $Context
# Auto-generated from: .ai/contexts/$Context.context.md
#
# To update rules: npm run sync-rules
# Framework: https://github.com/Shamavision/ai-workflow-rules
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"@

        # Footer
        $Footer = @"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# END OF AUTO-GENERATED RULES
# Made in Ukraine 🇺🇦
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"@

        # Read source content
        $SourceContent = Get-Content $SourceRules -Raw

        # Write combined file
        Set-Content -Path $FullPath -Value ($Header + $SourceContent + $Footer) -NoNewline

        Print-Success "$TargetFile created"
    }

    # Generate files for each tool
    foreach ($Tool in $AITools) {
        $ToolFile = $Tool.File
        $ToolName = $Tool.Name

        # Check if file exists and has user content
        if (Test-Path "$TargetDir\$ToolFile") {
            $Content = Get-Content "$TargetDir\$ToolFile" -Raw
            if ($Content -notmatch "AI-WORKFLOW-RULES") {
                # User's existing file - backup and append
                Write-Host "  ⚠️  $ToolFile exists - backing up..." -ForegroundColor Yellow
                Copy-Item "$TargetDir\$ToolFile" "$TargetDir\$ToolFile.backup" -Force
            }
        }

        Generate-RulesFile -ToolName $ToolName -TargetFile $ToolFile
    }

    Write-Host ""
    Print-Success "Rules generated for $($AITools.Count) AI tool(s)"
    Write-Host ""
}

# ========================================
# Verification
# ========================================

Print-Step "Verifying installation..."

$Issues = 0

# Check essential files
$FilesToCheck = @(
    ".ai/rules/core.md",
    ".ai/rules/product.md",
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

Write-Host "✓ AI Workflow Rules Framework v9.0 installed" -ForegroundColor Green
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
Write-Host "🛡️  AI Protection v9.0:" -ForegroundColor Blue
Write-Host "   - Prompt injection detection"
Write-Host "   - PII protection (GDPR-ready)"
Write-Host "   - Auto-runs in pre-commit hook"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
Write-Host ""
Write-Host "Made with ❤️ in Ukraine 🇺🇦" -ForegroundColor Blue
Write-Host "https://wellme.ua" -ForegroundColor Blue
Write-Host ""
