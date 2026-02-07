# ==============================================================================
# AI PROTECTION SCRIPT - PowerShell Version
# AI Workflow Rules Framework v9.0
# ==============================================================================

$ErrorActionPreference = "Stop"

# Config
$POLICY_FILE = ".ai\ai-protection-policy.json"
$PROMPT_PATTERNS = ".ai\prompt-injection-patterns.json"
$PII_PATTERNS = ".ai\pii-patterns.json"
$AUDIT_LOG = ".ai\audit-trail.log"

# Flags
$script:ThreatsFound = $false
$script:PromptInjectionFound = $false
$script:PIIFound = $false
$script:GitignoreViolations = $false

# ==============================================================================
# UTILITIES
# ==============================================================================

function Write-AuditLog {
    param([string]$EventType, [string]$Details)

    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $logEntry = "$timestamp | $EventType | $Details"

    try {
        if (Test-Path ".ai") {
            Add-Content -Path $AUDIT_LOG -Value $logEntry
        }
    } catch {
        # Silent fail
    }
}

# ==============================================================================
# CHECK 1: Prompt Injection Detection
# ==============================================================================

function Test-PromptInjection {
    Write-Host "━━━ Checking for prompt injection..." -ForegroundColor Cyan

    if (-not (Test-Path $PROMPT_PATTERNS)) {
        Write-Host "⚠  Prompt injection patterns file not found" -ForegroundColor Yellow
        return
    }

    # Get staged files
    try {
        $stagedFiles = git diff --cached --name-only --diff-filter=ACM
        if (-not $stagedFiles) { return }
        if ($stagedFiles -is [string]) { $stagedFiles = @($stagedFiles) }
    } catch {
        return
    }

    # Patterns
    $patterns = @(
        @{ Regex = '(AI|SYSTEM|ASSISTANT|CLAUDE|GPT|GEMINI)\s*(INSTRUCTION|OVERRIDE|COMMAND|DIRECTIVE)\s*:'; Name = 'System Override' },
        @{ Regex = 'ignore\s+(all\s+)?(previous|prior|earlier)\s+(instructions?|rules?|prompts?)'; Name = 'Ignore Previous' },
        @{ Regex = '(bypass|disable|skip|ignore)\s+(security|validation|check|protection)'; Name = 'Security Bypass' },
        @{ Regex = '(add|insert|include)\s+(API\s+key|token|password|secret)'; Name = 'Credential Insertion' }
    )

    # Whitelist
    $whitelistPatterns = @('\.md$', '\\docs\\', '\\examples\\', '\\test\\', '\.test\.', '\.spec\.')

    foreach ($file in $stagedFiles) {
        if (-not (Test-Path $file)) { continue }

        # Check whitelist
        $isWhitelisted = $false
        foreach ($whitelist in $whitelistPatterns) {
            if ($file -match $whitelist) {
                $isWhitelisted = $true
                break
            }
        }
        if ($isWhitelisted) { continue }

        # Read file
        try {
            $content = Get-Content $file -Raw -ErrorAction Stop
        } catch {
            continue
        }

        # Scan
        $lines = $content -split "`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            foreach ($pattern in $patterns) {
                if ($line -match $pattern.Regex) {
                    $lineNum = $i + 1
                    $matchedText = $line.Substring(0, [Math]::Min(80, $line.Length))

                    Write-Host "🚨 PROMPT INJECTION detected in ${file}:${lineNum}" -ForegroundColor Red
                    Write-Host "   Pattern: $($pattern.Name)"
                    Write-Host "   Text: $matchedText..."
                    Write-Host ""

                    $script:PromptInjectionFound = $true
                    $script:ThreatsFound = $true
                    Write-AuditLog "PROMPT_INJECTION" "${file}:${lineNum}"
                    break
                }
            }

            if ($script:ThreatsFound) { break }
        }

        if ($script:ThreatsFound) { break }
    }

    if (-not $script:PromptInjectionFound) {
        Write-Host "✓ No prompt injection detected" -ForegroundColor Green
    }
}

# ==============================================================================
# CHECK 2: PII Detection
# ==============================================================================

function Test-PIIInAILogs {
    Write-Host "━━━ Checking for PII in AI logs..." -ForegroundColor Cyan

    if (-not (Test-Path $PII_PATTERNS)) {
        Write-Host "⚠  PII patterns file not found" -ForegroundColor Yellow
        return
    }

    $scanFiles = @('.ai\token-limits.json', '.ai\audit-trail.log')

    $emailPattern = '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
    $phoneUAPattern = '\+380[0-9]{9}'
    $emailWhitelist = @('example.com', 'test.com', 'noreply@', 'no-reply@')

    foreach ($scanFile in $scanFiles) {
        if (-not (Test-Path $scanFile)) { continue }

        try {
            $content = Get-Content $scanFile -Raw
        } catch {
            continue
        }

        # Emails
        $emails = [regex]::Matches($content, $emailPattern)
        $realEmails = $emails | Where-Object {
            $email = $_.Value
            $isWhitelisted = $false
            foreach ($whitelist in $emailWhitelist) {
                if ($email -like "*$whitelist*") {
                    $isWhitelisted = $true
                    break
                }
            }
            -not $isWhitelisted
        }

        if ($realEmails.Count -gt 0) {
            Write-Host "⚠  PII detected in ${scanFile}: $($realEmails.Count) email(s)" -ForegroundColor Yellow
            $script:PIIFound = $true
            Write-AuditLog "PII_DETECTED" "${scanFile} (emails: $($realEmails.Count))"
        }

        # Phones
        $phones = [regex]::Matches($content, $phoneUAPattern)
        if ($phones.Count -gt 0) {
            Write-Host "⚠  PII detected in ${scanFile}: $($phones.Count) Ukrainian phone(s)" -ForegroundColor Yellow
            $script:PIIFound = $true
            Write-AuditLog "PII_DETECTED" "${scanFile} (phones: $($phones.Count))"
        }
    }

    if (-not $script:PIIFound) {
        Write-Host "✓ No PII detected in AI logs" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "⚠  PII found in AI logs (non-blocking warning)" -ForegroundColor Yellow
        Write-Host "   Recommendation: Review and redact manually"
        Write-Host "   Or run: //PII-SCAN --redact"
        Write-Host ""
    }
}

# ==============================================================================
# CHECK 3: Directory Protection
# ==============================================================================

function Test-AIDirectoryProtection {
    Write-Host "━━━ Checking .ai/ directory protection..." -ForegroundColor Cyan

    $requiredEntries = @('.ai/audit-trail.log', '.ai/.ai-protection-cache/', 'ai-logs/')

    if (-not (Test-Path '.gitignore')) {
        Write-Host "❌ .gitignore not found" -ForegroundColor Red
        Write-Host "   Create .gitignore and add:"
        $requiredEntries | ForEach-Object { Write-Host "   $_" }
        $script:GitignoreViolations = $true
        $script:ThreatsFound = $true
        return
    }

    $gitignoreContent = Get-Content '.gitignore' -Raw

    foreach ($entry in $requiredEntries) {
        if ($gitignoreContent -notmatch [regex]::Escape($entry)) {
            Write-Host "❌ Missing in .gitignore: $entry" -ForegroundColor Red
            $script:GitignoreViolations = $true
            $script:ThreatsFound = $true
        }
    }

    # Check staged files
    try {
        $stagedFiles = git diff --cached --name-only
        if ($stagedFiles) {
            if ($stagedFiles -is [string]) { $stagedFiles = @($stagedFiles) }

            $blockedFiles = @('.ai/audit-trail.log', '.ai/.ai-protection-cache', 'ai-logs/')

            foreach ($file in $stagedFiles) {
                foreach ($blocked in $blockedFiles) {
                    if ($file.StartsWith($blocked)) {
                        Write-Host "❌ Blocked file staged: $file" -ForegroundColor Red
                        Write-Host "   This file must be in .gitignore"
                        $script:GitignoreViolations = $true
                        $script:ThreatsFound = $true
                    }
                }
            }
        }
    } catch {
        # No git
    }

    if (-not $script:GitignoreViolations) {
        Write-Host "✓ .ai/ directory properly protected" -ForegroundColor Green
    }
}

# ==============================================================================
# MAIN
# ==============================================================================

try {
    if (-not (Test-Path $POLICY_FILE)) {
        Write-Host "⚠  AI Protection not configured (.ai\ai-protection-policy.json missing)"
        Write-Host "   Run: npx @shamavision/ai-workflow-rules@9.0.0 init"
        exit 0
    }

    Write-Host ""
    Write-Host "🤖 AI Protection v9.0"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""

    Test-PromptInjection
    Test-PIIInAILogs
    Test-AIDirectoryProtection

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ($script:ThreatsFound) {
        Write-Host ""
        Write-Host "❌ AI PROTECTION FAILED" -ForegroundColor Red
        Write-Host ""
        Write-Host "Threats detected:"

        if ($script:PromptInjectionFound) { Write-Host "  - Prompt injection attempts" }
        if ($script:GitignoreViolations) { Write-Host "  - .ai/ directory violations" }
        if ($script:PIIFound) { Write-Host "  - PII in AI logs (warning only)" }

        Write-Host ""
        Write-Host "Fix issues above before committing."
        Write-Host ""

        Write-AuditLog "AI_PROTECTION_FAILED" "Threats detected"
        exit 1
    } else {
        Write-Host ""
        Write-Host "✅ AI PROTECTION PASSED" -ForegroundColor Green
        Write-Host ""
        Write-AuditLog "AI_PROTECTION_PASSED" "All checks passed"
        exit 0
    }
} catch {
    Write-Host "Error running AI Protection: $_" -ForegroundColor Red
    exit 1
}
