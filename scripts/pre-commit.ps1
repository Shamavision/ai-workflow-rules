# ==============================================================================
# PRE-COMMIT HOOK - UNIVERSAL SECRETS SCANNER + AI PROTECTION (PowerShell)
# AI Workflow Rules Framework v9.0
# ==============================================================================
#
# PHILOSOPHY: Silent Guardian Architecture
#   - Protect without blocking productivity
#   - Trust informed decisions
#   - Universal compatibility (Windows native, no Git Bash needed)
#   - 🆕 AI Protection: Prompt injection + PII detection
#
# USAGE:
#   This is a PowerShell alternative to the bash version
#   Works natively on Windows without Git Bash or WSL
#
#   To use: Copy-Item scripts\pre-commit.ps1 .git\hooks\pre-commit
#           (Git for Windows supports PowerShell hooks)
#
# REQUIREMENTS:
#   PowerShell 5.1+ (built into Windows 10+)
#
# ==============================================================================

# Configuration
$ErrorActionPreference = "Stop"

$Config = @{
    Mode = if ($env:SECURITY_HOOK_MODE) { $env:SECURITY_HOOK_MODE } else { "balanced" }
    IsCI = [bool]($env:CI -or $env:GITHUB_ACTIONS -or $env:GITLAB_CI -or $env:JENKINS_HOME)
    IsInteractive = [Environment]::UserInteractive
}

# Flags
$script:HardBlocked = $false
$script:WarningsCount = 0

# ==============================================================================
# UTILITIES
# ==============================================================================

function Write-Header {
    Write-Host "🔒 Pre-Commit Security Scan" -ForegroundColor Blue
    if ($Config.IsCI) {
        Write-Host "   Environment: CI/CD (non-interactive mode)" -ForegroundColor Cyan
    }
    Write-Host ""
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-WarningMsg {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-SuccessMsg {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-InfoMsg {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

# Calculate Shannon entropy
function Get-Entropy {
    param([string]$String)

    if ($String.Length -lt 20) {
        return 0
    }

    $freq = @{}
    foreach ($char in $String.ToCharArray()) {
        if ($freq.ContainsKey($char)) {
            $freq[$char]++
        } else {
            $freq[$char] = 1
        }
    }

    $entropy = 0
    $len = $String.Length

    foreach ($count in $freq.Values) {
        $p = $count / $len
        $entropy -= $p * [Math]::Log($p, 2)
    }

    return [Math]::Round($entropy, 2)
}

# Check if file should be ignored
function Test-Ignored {
    param([string]$FilePath)

    $builtInIgnore = @(
        ".env.example",
        ".env.sample",
        ".env.template",
        "scripts\pre-commit",
        "scripts\pre-commit.js",
        "scripts\pre-commit.ps1",
        ".ai\security-policy.json",
        ".ai\forbidden-trackers.json",
        "RULES_CORE.md",
        "RULES_PRODUCT.md",
        "node_modules\",
        "dist\",
        "build\",
        "examples\",
        "tests\fixtures\"
    )

    foreach ($pattern in $builtInIgnore) {
        if ($FilePath -like "*$pattern*") {
            return $true
        }
    }

    # Check .securityignore
    if (Test-Path ".securityignore") {
        $patterns = Get-Content ".securityignore" | Where-Object { $_ -and !$_.StartsWith("#") }
        foreach ($pattern in $patterns) {
            if ($FilePath -like "*$pattern*") {
                return $true
            }
        }
    }

    return $false
}

# Check if line has bypass comment
function Test-BypassComment {
    param([string]$Line)

    return ($Line -match "secure-ignore" -or $Line -match "security:ignore" -or $Line -match "nosecret")
}

# Ask user confirmation
function Get-UserConfirmation {
    param([string]$Message)

    if (-not $Config.IsInteractive) {
        Write-WarningMsg "Non-interactive mode: Auto-blocking suspicious pattern"
        return $false
    }

    if ($Config.Mode -eq "permissive") {
        Write-WarningMsg "Permissive mode: Auto-allowing"
        return $true
    }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host "SECURITY WARNING" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host ""
    Write-Host $Message
    Write-Host ""
    Write-Host "How to fix:"
    Write-Host "  1. Use environment variables: process.env.API_KEY"
    Write-Host "  2. Move to .env file (gitignored)"
    Write-Host "  3. If false positive: add comment // secure-ignore"
    Write-Host ""

    $response = Read-Host "Proceed with commit? Type 'yes' to continue"

    if ($response -eq "yes") {
        Write-WarningMsg "User confirmed. Proceeding..."
        return $true
    } else {
        Write-ErrorMsg "Commit cancelled by user"
        return $false
    }
}

# Log to audit trail
function Write-AuditTrail {
    param(
        [string]$EventType,
        [string]$Details
    )

    $auditFile = ".ai\audit-trail.log"

    if (-not (Test-Path ".ai")) {
        New-Item -ItemType Directory -Path ".ai" | Out-Null
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $user = git config user.name
    $email = git config user.email
    $branch = git branch --show-current

    $entry = @"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[$timestamp UTC] COMMIT BLOCKED
Event: $EventType
Details: $Details
Framework: ai-workflow-rules v8.3
User: $user <$email>
Branch: $branch
Environment: $(if ($Config.IsCI) { "CI/CD" } else { "Interactive" })
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"@

    Add-Content -Path $auditFile -Value $entry
}

# ==============================================================================
# TIER 1 PATTERNS (ALL AI PROVIDERS)
# ==============================================================================

$Tier1Patterns = @(
    @{ Name = "Anthropic API Key"; Provider = "Anthropic (Claude)"; Pattern = "sk-ant-api03-[A-Za-z0-9_-]{95}"; EnvVar = "ANTHROPIC_API_KEY" },
    @{ Name = "OpenAI API Key"; Provider = "OpenAI (GPT)"; Pattern = "\bsk-[a-zA-Z0-9]{48,51}\b"; EnvVar = "OPENAI_API_KEY" },
    @{ Name = "Google AI API Key"; Provider = "Google (Gemini)"; Pattern = "AIza[A-Za-z0-9_-]{35}"; EnvVar = "GOOGLE_API_KEY" },
    @{ Name = "Hugging Face Token"; Provider = "Hugging Face"; Pattern = "hf_[A-Za-z0-9]{32,}"; EnvVar = "HUGGINGFACE_TOKEN" },
    @{ Name = "Replicate Token"; Provider = "Replicate"; Pattern = "r8_[A-Za-z0-9]{40}"; EnvVar = "REPLICATE_API_TOKEN" },
    @{ Name = "GitHub Token"; Provider = "GitHub"; Pattern = "ghp_[A-Za-z0-9]{36}"; EnvVar = "GITHUB_TOKEN" },
    @{ Name = "AWS Access Key"; Provider = "AWS"; Pattern = "AKIA[A-Z0-9]{16}"; EnvVar = "AWS_ACCESS_KEY_ID" },
    @{ Name = "Stripe Secret Key"; Provider = "Stripe"; Pattern = "sk_live_[A-Za-z0-9]{24,}"; EnvVar = "STRIPE_SECRET_KEY" },
    @{ Name = "Private Key"; Provider = "Cryptographic Key"; Pattern = "BEGIN (RSA )?PRIVATE KEY"; EnvVar = $null }
)

# ==============================================================================
# MAIN SCAN LOGIC
# ==============================================================================

function Invoke-SecurityScan {
    param([string[]]$Files)

    Write-Header
    Write-Host "Scanning $($Files.Count) staged file(s)..."
    Write-Host ""

    Write-Host "━━━ Checking for real API keys (all AI providers)..."

    foreach ($file in $Files) {
        if (Test-Ignored $file) { continue }
        if (-not (Test-Path $file)) { continue }

        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        $lines = $content -split "`n"

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            $lineNum = $i + 1

            if (Test-BypassComment $line) { continue }

            # Check Tier 1 patterns
            foreach ($pattern in $Tier1Patterns) {
                if ($line -match $pattern.Pattern) {
                    if ($pattern.Name -eq "OpenAI API Key" -and $line -match "sk-ant-") {
                        continue  # Skip Anthropic keys in OpenAI check
                    }

                    Write-ErrorMsg "BLOCKED: $($pattern.Name) in ${file}:${lineNum}"
                    if ($pattern.Provider) {
                        Write-Host "   Provider: $($pattern.Provider)"
                    }
                    if ($pattern.EnvVar) {
                        Write-Host "   Fix: Use `$env:$($pattern.EnvVar)"
                    }
                    $script:HardBlocked = $true
                }
            }

            # High-entropy detection
            $quotedStrings = [regex]::Matches($line, '["''][A-Za-z0-9+/=_-]{20,}["'']')
            foreach ($match in $quotedStrings) {
                $clean = $match.Value -replace '["'']', ''

                if ($clean -match "example|test|demo|placeholder|your.?key|xxx|sample|fake") {
                    continue
                }

                $entropy = Get-Entropy $clean
                if ($entropy -gt 4.5) {
                    Write-ErrorMsg "BLOCKED: High-entropy string (likely secret) in ${file}:${lineNum}"
                    Write-Host "   Entropy: $entropy (threshold: 4.5)"
                    Write-Host "   Fix: Move to environment variable"
                    $script:HardBlocked = $true
                }
            }
        }
    }

    # Check blocked file types
    foreach ($file in $Files) {
        $basename = Split-Path $file -Leaf

        if ($basename -in @(".env", ".env.local", ".env.production", ".env.development")) {
            Write-ErrorMsg "BLOCKED: Environment file detected: $file"
            $script:HardBlocked = $true
        }

        if ($file -match '\.(pem|key|p12|pfx)$') {
            Write-ErrorMsg "BLOCKED: Private key file: $file"
            $script:HardBlocked = $true
        }

        if ($basename -in @("credentials.json", "secrets.json")) {
            Write-ErrorMsg "BLOCKED: Credentials file: $file"
            $script:HardBlocked = $true
        }
    }

    # Tier 2: Suspicious patterns
    Write-Host "━━━ Checking for suspicious patterns..."

    foreach ($file in $Files) {
        if (Test-Ignored $file) { continue }
        if ($file -notmatch '\.(js|ts|jsx|tsx|py|go|rb|java|cs|php|sh|yml|yaml|json)$') { continue }
        if (-not (Test-Path $file)) { continue }

        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        $lines = $content -split "`n"

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            $lineNum = $i + 1

            if (Test-BypassComment $line) { continue }
            if ($line -match '^\s*(//|#|\*)') { continue }  # Skip comments

            # Generic API_KEY assignment
            if ($line -match 'API_?KEY\s*[=:]\s*["''][A-Za-z0-9_-]{16,}["'']') {
                if ($line -match 'your.?key|example|placeholder|xxx|test|demo|fake|sample') {
                    continue
                }

                Write-WarningMsg "Suspicious API key assignment in ${file}:${lineNum}"
                $script:WarningsCount++

                if (-not (Get-UserConfirmation "Possible hardcoded API key detected")) {
                    $script:HardBlocked = $true
                    break
                }
            }

            # Bearer tokens
            if ($line -match 'Bearer [A-Za-z0-9_-]{20,}') {
                if ($line -match 'example|placeholder|xxx|your.?token') {
                    continue
                }

                Write-WarningMsg "Suspicious Bearer token in ${file}:${lineNum}"
                $script:WarningsCount++

                if (-not (Get-UserConfirmation "Possible hardcoded Bearer token detected")) {
                    $script:HardBlocked = $true
                    break
                }
            }
        }

        if ($script:HardBlocked) { break }
    }
}

# ==============================================================================
# MAIN
# ==============================================================================

try {
    # Get staged files
    $stagedFiles = git diff --cached --name-only --diff-filter=ACM
    if (-not $stagedFiles) {
        Write-SuccessMsg "No files staged"
        exit 0
    }

    if ($stagedFiles -is [string]) {
        $stagedFiles = @($stagedFiles)
    }

    # Run scan
    Invoke-SecurityScan -Files $stagedFiles

    # AI Protection (v9.0+)
    $script:AIProtectionFailed = $false

    if (Test-Path ".ai\ai-protection-policy.json") {
        Write-Host "━━━ AI Protection: Checking for threats..."

        if (Test-Path "scripts\ai-protection.ps1") {
            try {
                # Run AI protection checks
                & ".\scripts\ai-protection.ps1"
                if ($LASTEXITCODE -ne 0) {
                    $script:AIProtectionFailed = $true
                    Write-Host "✗ AI Protection detected threats" -ForegroundColor Red
                } else {
                    Write-Host "✓ AI Protection passed" -ForegroundColor Green
                }
            } catch {
                $script:AIProtectionFailed = $true
                Write-Host "✗ AI Protection failed: $_" -ForegroundColor Red
            }
        } else {
            # Script missing - warn but don't block
            Write-Host "⚠  AI Protection script not found (scripts\ai-protection.ps1)" -ForegroundColor Yellow
            Write-Host "   Run installer to add AI Protection: npx @shamavision/ai-workflow-rules@9.0.0 init"
        }
    }

    # Final verdict
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ($script:HardBlocked) {
        Write-Host "❌ COMMIT BLOCKED" -ForegroundColor Red
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        Write-Host ""
        Write-Host "🚨 Your commit contains sensitive data or was cancelled."
        Write-Host ""

        if ($Config.IsCI) {
            Write-Host "Running in CI/CD: Set `$env:SECURITY_HOOK_MODE='permissive' to bypass tier 2"
        }

        Write-AuditTrail -EventType "HARD_BLOCK" -Details "Secrets detected or user cancellation"
        exit 1
    }

    if ($script:AIProtectionFailed) {
        Write-Host "❌ COMMIT BLOCKED - AI PROTECTION" -ForegroundColor Red
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        Write-Host ""
        Write-Host "🤖 AI Protection detected threats:"
        Write-Host "   - Prompt injection attempts"
        Write-Host "   - PII in AI logs"
        Write-Host "   - .ai/ directory violations"
        Write-Host ""
        Write-Host "See details above for specific issues."
        Write-Host ""
        Write-AuditTrail -EventType "AI_PROTECTION" -Details "AI threats detected"
        exit 1
    }

    Write-Host "✅ SECURITY SCAN PASSED" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""

    if ($script:WarningsCount -gt 0) {
        Write-SuccessMsg "No critical issues (user confirmed $($script:WarningsCount) warning(s))"
    } else {
        Write-SuccessMsg "No secrets or trackers detected"
    }

    Write-Host ""
    Write-Host "Proceeding with commit..."
    Write-Host ""
    exit 0

} catch {
    Write-Host "Error running pre-commit hook: $_" -ForegroundColor Red
    exit 1
}
