# Token Status Dashboard for AI Workflow Rules (PowerShell)
# Version: 1.0 (v9.1 Phase 5)

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📊 TOKEN USAGE DASHBOARD" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Read token limits config
if (Test-Path ".ai\token-limits.json") {
    $tokenLimits = Get-Content ".ai\token-limits.json" -Raw | ConvertFrom-Json
    $provider = $tokenLimits.provider
    $plan = $tokenLimits.plan
    $dailyLimit = $tokenLimits.daily_limit
    $monthlyLimit = $tokenLimits.monthly_limit
    $dailyUsed = $tokenLimits.daily_usage
    $monthlyUsed = $tokenLimits.monthly_usage
} else {
    $provider = "claude.ai"
    $plan = "pro"
    $dailyLimit = 500000
    $monthlyLimit = 15000000
    $dailyUsed = 0
    $monthlyUsed = 0
}

# Read context from config
if (Test-Path ".ai\config.json") {
    $config = Get-Content ".ai\config.json" -Raw | ConvertFrom-Json
    $context = $config.context
} else {
    $context = "standard"
}

# Estimate session start cost based on context
$sessionStart = switch ($context) {
    "minimal" { 10000 }
    "standard" { 14000 }
    "ukraine-full" { 18000 }
    "enterprise" { 23000 }
    default { 14000 }
}

Write-Host "🤖 Provider: $provider ($plan)"
Write-Host "📦 Context: $context"
Write-Host ""

# Session Start Cost
Write-Host "─────────────────────────────────────────────────"
Write-Host "💬 Session Start Cost:"
Write-Host "   Tokens: $($sessionStart.ToString('N0'))"
Write-Host "   Percentage: $([math]::Floor($sessionStart * 100 / $dailyLimit))% of daily budget"
Write-Host ""

# Daily Usage
$dailyPercent = [math]::Floor($dailyUsed * 100 / $dailyLimit)
$dailyRemaining = $dailyLimit - $dailyUsed

Write-Host "─────────────────────────────────────────────────"
Write-Host "📅 Daily Usage (Estimated):"
Write-Host "   Limit: $($dailyLimit.ToString('N0')) tokens"
Write-Host "   Used: $($dailyUsed.ToString('N0')) tokens ($dailyPercent%)"
Write-Host "   Remaining: $($dailyRemaining.ToString('N0')) tokens"
Write-Host ""

# Zone indicator
if ($dailyPercent -lt 50) {
    $zone = "🟢 GREEN"
    $zoneDesc = "Full capacity"
    $zoneColor = "Green"
} elseif ($dailyPercent -lt 70) {
    $zone = "🟡 MODERATE"
    $zoneDesc = "Optimizations active"
    $zoneColor = "Yellow"
} elseif ($dailyPercent -lt 90) {
    $zone = "🟠 CAUTION"
    $zoneDesc = "Brief mode, aggressive compression"
    $zoneColor = "DarkYellow"
} else {
    $zone = "🔴 CRITICAL"
    $zoneDesc = "Finalize work and stop"
    $zoneColor = "Red"
}

Write-Host "   Status: " -NoNewline
Write-Host "$zone" -ForegroundColor $zoneColor -NoNewline
Write-Host " - $zoneDesc"
Write-Host ""

# Monthly Usage
$monthlyPercent = [math]::Floor($monthlyUsed * 100 / $monthlyLimit)
$monthlyRemaining = $monthlyLimit - $monthlyUsed

Write-Host "─────────────────────────────────────────────────"
Write-Host "📆 Monthly Usage (Estimated):"
Write-Host "   Limit: $($monthlyLimit.ToString('N0')) tokens"
Write-Host "   Used: $($monthlyUsed.ToString('N0')) tokens ($monthlyPercent%)"
Write-Host "   Remaining: $($monthlyRemaining.ToString('N0')) tokens"
Write-Host ""

# Projections
$available = $dailyLimit - $dailyUsed - $sessionStart
$avgMsg = 5000
$estimatedMsgs = [math]::Floor($available / $avgMsg)

if ($available -gt 0) {
    Write-Host "─────────────────────────────────────────────────"
    Write-Host "🔮 Projections (after session start):"
    Write-Host "   Available: $($available.ToString('N0')) tokens"
    Write-Host "   Est. messages: ~$estimatedMsgs (at 5k/msg average)"
    Write-Host "   Green zone until: ~$([math]::Floor($dailyLimit / 2 / 1000))k tokens"
    Write-Host ""
}

# Recommendations
if ($dailyPercent -gt 70) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host "⚠️  RECOMMENDATIONS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   • Consider finishing current work and taking a break"
    Write-Host "   • Daily budget will reset in a few hours"
    Write-Host "   • Use //COMPACT to compress context and save tokens"
    Write-Host ""
} elseif ($dailyPercent -gt 50) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "💡 TIPS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   • Use //COMPACT after finishing tasks"
    Write-Host "   • Brief mode active - optimizations running"
    Write-Host "   • $($dailyRemaining.ToString('N0')) tokens remaining today"
    Write-Host ""
}

# Context comparison
$sessionPercent = [math]::Floor($sessionStart * 100 / $dailyLimit)
if ($sessionPercent -gt 10) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "💡 Context Optimization:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Current: $context ($sessionStart tokens)"
    Write-Host ""
    if ($context -eq "ukraine-full") {
        Write-Host "   💰 Consider: standard (14k tokens, -22%)"
    } elseif ($context -eq "enterprise") {
        Write-Host "   💰 Consider: ukraine-full (18k tokens, -22%)"
    }
    Write-Host ""
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📖 For real usage ($provider):"
if ($provider -eq "claude.ai") {
    Write-Host "   → https://claude.ai/settings/usage"
} elseif ($provider -eq "anthropic") {
    Write-Host "   → https://console.anthropic.com/settings/limits"
}
Write-Host ""
Write-Host "Commands:"
Write-Host "   npm run token-status    # Show this dashboard"
Write-Host "   //COMPACT               # Compress context (in AI chat)"
Write-Host "   //TOKENS                # Quick token check (in AI chat)"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
