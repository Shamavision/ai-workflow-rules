#!/bin/bash
# Token Status Dashboard for AI Workflow Rules
# Version: 1.1 (Phase 8.7.2 - MODEL_3 Support)

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

    # Raw values may be numeric or "UNKNOWN (NOT DISCLOSED)" (old configs / MODEL_2)
    DAILY_LIMIT_RAW=$(jq -r '.daily_limit' .ai/token-limits.json 2>/dev/null || echo "200000")
    MONTHLY_LIMIT_RAW=$(jq -r '.monthly_limit' .ai/token-limits.json 2>/dev/null || echo "5000000")
    SESSION_LIMIT=$(jq -r '.session_limit // 200000' .ai/token-limits.json 2>/dev/null || echo "200000")
    DAILY_USED=$(jq -r '.daily_usage // 0' .ai/token-limits.json 2>/dev/null || echo "0")
    MONTHLY_USED=$(jq -r '.monthly_usage // 0' .ai/token-limits.json 2>/dev/null || echo "0")

    # VARIANT B fields: limit type and notes
    DAILY_LIMIT_TYPE=$(jq -r '.daily_limit_type // "hard"' .ai/token-limits.json 2>/dev/null || echo "hard")
    DAILY_LIMIT_NOTE=$(jq -r '.daily_limit_note // ""' .ai/token-limits.json 2>/dev/null || echo "")

    # Read architecture model and session info from PRESETS
    ARCH_MODEL=$(jq -r --arg p "$PROVIDER" --arg pl "$PLAN" \
        '.PRESETS[$p][$pl]._architecture_model // "MODEL_1"' \
        .ai/token-limits.json 2>/dev/null || echo "MODEL_1")
    APPROX_MSGS=$(jq -r --arg p "$PROVIDER" --arg pl "$PLAN" \
        '.PRESETS[$p][$pl].approx_messages_per_session // "unknown"' \
        .ai/token-limits.json 2>/dev/null || echo "unknown")
    SESSION_DURATION=$(jq -r --arg p "$PROVIDER" --arg pl "$PLAN" \
        '.PRESETS[$p][$pl].session_duration_hours // "unknown"' \
        .ai/token-limits.json 2>/dev/null || echo "unknown")
    PLAN_DAILY_NOTE=$(jq -r --arg p "$PROVIDER" --arg pl "$PLAN" \
        '.PRESETS[$p][$pl].daily_note // ""' \
        .ai/token-limits.json 2>/dev/null || echo "")
else
    PROVIDER="claude.ai"
    PLAN="pro"
    DAILY_LIMIT_RAW="500000"
    MONTHLY_LIMIT_RAW="5000000"
    SESSION_LIMIT=200000
    DAILY_USED=0
    MONTHLY_USED=0
    DAILY_LIMIT_TYPE="fair_use_dynamic"
    DAILY_LIMIT_NOTE="Conservative estimate. Real limit UNKNOWN (MODEL_3)."
    ARCH_MODEL="MODEL_3"
    APPROX_MSGS=45
    SESSION_DURATION=5
    PLAN_DAILY_NOTE="ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3 - Fair Use Dynamic)."
fi

# Handle non-numeric values (backward compat: old configs may have "UNKNOWN" strings)
if [[ "$DAILY_LIMIT_RAW" =~ ^[0-9]+$ ]]; then
    DAILY_LIMIT=$DAILY_LIMIT_RAW
else
    DAILY_LIMIT=500000
fi

if [[ "$MONTHLY_LIMIT_RAW" =~ ^[0-9]+$ ]]; then
    MONTHLY_LIMIT=$MONTHLY_LIMIT_RAW
else
    MONTHLY_LIMIT=5000000
fi

# Detect MODEL_3 (Fair Use Dynamic)
IS_MODEL3=false
if [ "$ARCH_MODEL" = "MODEL_3" ] || [ "$DAILY_LIMIT_TYPE" = "fair_use_dynamic" ]; then
    IS_MODEL3=true
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

# Provider + arch model label
if $IS_MODEL3; then
    ARCH_LABEL="${ARCH_MODEL} - Fair Use Dynamic"
else
    ARCH_LABEL="${ARCH_MODEL}"
fi

echo "🤖 Provider: ${PROVIDER} (${PLAN}) [${ARCH_LABEL}]"
echo "📦 Context: ${CONTEXT}"
echo ""

# MODEL_3: Show fair use notice and session info
if $IS_MODEL3; then
    echo "─────────────────────────────────────────────────"
    echo "⚠️  FAIR USE DYNAMIC LIMITS (MODEL_3)"
    echo "   Real daily/monthly limits: UNKNOWN (NOT DISCLOSED)"
    if [ -n "$DAILY_LIMIT_NOTE" ]; then
        echo "   ${DAILY_LIMIT_NOTE}"
    fi
    echo ""
    echo "💬 Session Info:"
    echo "   Session limit:    $(printf "%'d" $SESSION_LIMIT) tokens"
    if [ "$SESSION_DURATION" != "unknown" ] && [ "$SESSION_DURATION" != "null" ]; then
        echo "   Session window:   ~${SESSION_DURATION}h rolling"
    fi
    if [ "$APPROX_MSGS" != "unknown" ] && [ "$APPROX_MSGS" != "null" ]; then
        echo "   Messages/session: ~${APPROX_MSGS} (baseline)"
    fi
    echo ""
fi

# Session Start Cost
echo "─────────────────────────────────────────────────"
echo "💬 Session Start Cost:"
echo "   Tokens: $(printf "%'d" $SESSION_START)"
SESSION_PCT=$(($SESSION_START * 100 / $DAILY_LIMIT))
echo "   Percentage: ${SESSION_PCT}% of daily budget"
echo ""

# Daily Usage
DAILY_PERCENT=$(($DAILY_USED * 100 / $DAILY_LIMIT))
DAILY_REMAINING=$(($DAILY_LIMIT - $DAILY_USED))

echo "─────────────────────────────────────────────────"
if $IS_MODEL3; then
    echo "📅 Daily Usage (ESTIMATE ONLY - not a real limit):"
else
    echo "📅 Daily Usage:"
fi
echo "   Limit: $(printf "%'d" $DAILY_LIMIT) tokens"
if $IS_MODEL3 && [ -n "$PLAN_DAILY_NOTE" ]; then
    echo "   Note: ${PLAN_DAILY_NOTE}"
fi
echo "   Used: $(printf "%'d" $DAILY_USED) tokens (${DAILY_PERCENT}%)"
echo "   Remaining: $(printf "%'d" $DAILY_REMAINING) tokens"
echo ""

# Zone indicator (based on daily % for all models)
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
if $IS_MODEL3; then
    echo "📆 Monthly Usage (ESTIMATE ONLY - not a real limit):"
else
    echo "📆 Monthly Usage:"
fi
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
    if $IS_MODEL3; then
        echo "   Note: Based on conservative estimate, not real limit"
    else
        echo "   Green zone until: ~$(($DAILY_LIMIT / 2 / 1000))k tokens"
    fi
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
echo "📖 Check real usage at:"
if [ "$PROVIDER" = "anthropic" ]; then
    if $IS_MODEL3; then
        echo "   → https://claude.ai (session indicator)"
    else
        echo "   → https://console.anthropic.com/settings/limits"
    fi
elif [ "$PROVIDER" = "claude.ai" ]; then
    echo "   → https://claude.ai/settings/usage"
fi
echo ""
echo "Commands:"
echo "   npm run token-status    # Show this dashboard"
echo "   //COMPACT               # Compress context (in AI chat)"
echo "   //TOKENS                # Quick token check (in AI chat)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
