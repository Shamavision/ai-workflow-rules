#!/bin/bash
# Token Status Dashboard for AI Workflow Rules
# Version: 1.0 (v9.1 Phase 5)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 TOKEN USAGE DASHBOARD"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq not found. Install it for full functionality:"
    echo "   - Ubuntu/Debian: sudo apt-get install jq"
    echo "   - macOS: brew install jq"
    echo "   - Windows (Git Bash): download from https://stedolan.github.io/jq/"
    echo ""
    exit 1
fi

# Read token limits config
if [ -f ".ai/token-limits.json" ]; then
    PROVIDER=$(jq -r '.provider' .ai/token-limits.json 2>/dev/null || echo "unknown")
    PLAN=$(jq -r '.plan' .ai/token-limits.json 2>/dev/null || echo "unknown")
    DAILY_LIMIT=$(jq -r '.daily_limit' .ai/token-limits.json 2>/dev/null || echo "200000")
    MONTHLY_LIMIT=$(jq -r '.monthly_limit' .ai/token-limits.json 2>/dev/null || echo "5000000")
    DAILY_USED=$(jq -r '.daily_usage' .ai/token-limits.json 2>/dev/null || echo "0")
    MONTHLY_USED=$(jq -r '.monthly_usage' .ai/token-limits.json 2>/dev/null || echo "0")
else
    PROVIDER="claude.ai"
    PLAN="pro"
    DAILY_LIMIT=500000
    MONTHLY_LIMIT=15000000
    DAILY_USED=0
    MONTHLY_USED=0
fi

# Read context from config
if [ -f ".ai/config.json" ]; then
    CONTEXT=$(jq -r '.context' .ai/config.json 2>/dev/null || echo "standard")
else
    CONTEXT="standard"
fi

# Estimate session start cost based on context
case $CONTEXT in
    "minimal") SESSION_START=10000 ;;
    "standard") SESSION_START=14000 ;;
    "ukraine-full") SESSION_START=18000 ;;
    "enterprise") SESSION_START=23000 ;;
    *) SESSION_START=14000 ;;
esac

echo "🤖 Provider: ${PROVIDER} (${PLAN})"
echo "📦 Context: ${CONTEXT}"
echo ""

# Session Start Cost
echo "─────────────────────────────────────────────────"
echo "💬 Session Start Cost:"
echo "   Tokens: $(printf "%'d" $SESSION_START)"
echo "   Percentage: $(($SESSION_START * 100 / $DAILY_LIMIT))% of daily budget"
echo ""

# Daily Usage
DAILY_PERCENT=$(($DAILY_USED * 100 / $DAILY_LIMIT))
DAILY_REMAINING=$(($DAILY_LIMIT - $DAILY_USED))

echo "─────────────────────────────────────────────────"
echo "📅 Daily Usage (Estimated):"
echo "   Limit: $(printf "%'d" $DAILY_LIMIT) tokens"
echo "   Used: $(printf "%'d" $DAILY_USED) tokens (${DAILY_PERCENT}%)"
echo "   Remaining: $(printf "%'d" $DAILY_REMAINING) tokens"
echo ""

# Zone indicator
if [ $DAILY_PERCENT -lt 50 ]; then
    ZONE="🟢 GREEN"
    ZONE_DESC="Full capacity"
elif [ $DAILY_PERCENT -lt 70 ]; then
    ZONE="🟡 MODERATE"
    ZONE_DESC="Optimizations active"
elif [ $DAILY_PERCENT -lt 90 ]; then
    ZONE="🟠 CAUTION"
    ZONE_DESC="Brief mode, aggressive compression"
else
    ZONE="🔴 CRITICAL"
    ZONE_DESC="Finalize work and stop"
fi

echo "   Status: $ZONE - $ZONE_DESC"
echo ""

# Monthly Usage
MONTHLY_PERCENT=$(($MONTHLY_USED * 100 / $MONTHLY_LIMIT))
MONTHLY_REMAINING=$(($MONTHLY_LIMIT - $MONTHLY_USED))

echo "─────────────────────────────────────────────────"
echo "📆 Monthly Usage (Estimated):"
echo "   Limit: $(printf "%'d" $MONTHLY_LIMIT) tokens"
echo "   Used: $(printf "%'d" $MONTHLY_USED) tokens (${MONTHLY_PERCENT}%)"
echo "   Remaining: $(printf "%'d" $MONTHLY_REMAINING) tokens"
echo ""

# Projections
AVAILABLE=$(($DAILY_LIMIT - $DAILY_USED - $SESSION_START))
AVG_MSG=5000
ESTIMATED_MSGS=$(($AVAILABLE / $AVG_MSG))

if [ $AVAILABLE -gt 0 ]; then
    echo "─────────────────────────────────────────────────"
    echo "🔮 Projections (after session start):"
    echo "   Available: $(printf "%'d" $AVAILABLE) tokens"
    echo "   Est. messages: ~${ESTIMATED_MSGS} (at 5k/msg average)"
    echo "   Green zone until: ~$(($DAILY_LIMIT / 2 / 1000))k tokens"
    echo ""
fi

# Recommendations
if [ $DAILY_PERCENT -gt 70 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  RECOMMENDATIONS:"
    echo ""
    echo "   • Consider finishing current work and taking a break"
    echo "   • Daily budget will reset in a few hours"
    echo "   • Use //COMPACT to compress context and save tokens"
    echo ""
elif [ $DAILY_PERCENT -gt 50 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 TIPS:"
    echo ""
    echo "   • Use //COMPACT after finishing tasks"
    echo "   • Brief mode active - optimizations running"
    echo "   • $(printf "%'d" $DAILY_REMAINING) tokens remaining today"
    echo ""
fi

# Context comparison
SESSION_PERCENT=$(($SESSION_START * 100 / $DAILY_LIMIT))
if [ $SESSION_PERCENT -gt 10 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Context Optimization:"
    echo ""
    echo "   Current: $CONTEXT (${SESSION_START} tokens)"
    echo ""
    if [ "$CONTEXT" = "ukraine-full" ]; then
        echo "   💰 Consider: standard (14k tokens, -22%)"
    elif [ "$CONTEXT" = "enterprise" ]; then
        echo "   💰 Consider: ukraine-full (18k tokens, -22%)"
    fi
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📖 For real usage (${PROVIDER}):"
if [ "$PROVIDER" = "claude.ai" ]; then
    echo "   → https://claude.ai/settings/usage"
elif [ "$PROVIDER" = "anthropic" ]; then
    echo "   → https://console.anthropic.com/settings/limits"
fi
echo ""
echo "Commands:"
echo "   npm run token-status    # Show this dashboard"
echo "   //COMPACT               # Compress context (in AI chat)"
echo "   //TOKENS                # Quick token check (in AI chat)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
