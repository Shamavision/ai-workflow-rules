#!/bin/bash
# scripts/token-log.sh - Log token usage to .ai/token-limits.json
# Part of AI Workflow Rules Framework v9.1.1

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TOKEN_FILE=".ai/token-limits.json"

# ----------------------------------------
# Help message
# ----------------------------------------

show_help() {
  echo "📊 AI Workflow Rules - Token Usage Logger"
  echo "=========================================="
  echo ""
  echo "Usage: ./scripts/token-log.sh <command> [amount]"
  echo ""
  echo "Commands:"
  echo "  add <amount>     - Add tokens to daily usage"
  echo "  set <amount>     - Set daily usage to exact amount"
  echo "  reset            - Reset daily usage to 0"
  echo "  status           - Show current token status"
  echo "  history          - Show usage history (last 7 days)"
  echo ""
  echo "Examples:"
  echo "  ./scripts/token-log.sh add 15000       # Add 15k tokens"
  echo "  ./scripts/token-log.sh set 45000       # Set to 45k"
  echo "  ./scripts/token-log.sh reset           # Reset to 0"
  echo "  ./scripts/token-log.sh status          # Show status"
  echo ""
}

# ----------------------------------------
# Check if token file exists
# ----------------------------------------

if [ ! -f "$TOKEN_FILE" ]; then
  echo -e "${RED}Error: $TOKEN_FILE not found${NC}"
  echo "Run this script from project root."
  exit 1
fi

# ----------------------------------------
# Check if jq is available
# ----------------------------------------

if ! command -v jq &> /dev/null; then
  echo -e "${RED}Error: 'jq' command not found${NC}"
  echo ""
  echo "This script requires jq for JSON manipulation."
  echo "Install: sudo apt-get install jq  (Linux)"
  echo "Install: brew install jq           (macOS)"
  echo "Install: choco install jq          (Windows)"
  exit 1
fi

# ----------------------------------------
# Parse command
# ----------------------------------------

COMMAND="$1"
AMOUNT="$2"

if [ -z "$COMMAND" ]; then
  show_help
  exit 1
fi

# ----------------------------------------
# Get current values
# ----------------------------------------

get_daily_usage() {
  jq -r '.daily_usage // 0' "$TOKEN_FILE"
}

get_daily_limit() {
  jq -r '.daily_limit // 150000' "$TOKEN_FILE"
}

get_provider() {
  jq -r '.provider // "unknown"' "$TOKEN_FILE"
}

get_plan() {
  jq -r '.plan // "unknown"' "$TOKEN_FILE"
}

# ----------------------------------------
# Calculate zone
# ----------------------------------------

get_zone() {
  local USAGE=$1
  local LIMIT=$2
  local PERCENT=$((USAGE * 100 / LIMIT))

  if [ $PERCENT -lt 50 ]; then
    echo "🟢 GREEN"
  elif [ $PERCENT -lt 70 ]; then
    echo "🟡 MODERATE"
  elif [ $PERCENT -lt 90 ]; then
    echo "🟠 CAUTION"
  else
    echo "🔴 CRITICAL"
  fi
}

# ----------------------------------------
# Show status
# ----------------------------------------

show_status() {
  local USAGE=$(get_daily_usage)
  local LIMIT=$(get_daily_limit)
  local PROVIDER=$(get_provider)
  local PLAN=$(get_plan)

  local PERCENT=$((USAGE * 100 / LIMIT))
  local REMAINING=$((LIMIT - USAGE))
  local ZONE=$(get_zone "$USAGE" "$LIMIT")

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "📊 ${CYAN}Token Usage Status${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo -e "Provider:  ${BLUE}$PROVIDER${NC} ($plan)"
  echo -e "Daily:     ${YELLOW}${USAGE}${NC} / ${LIMIT} (${PERCENT}%)"
  echo -e "Remaining: ${GREEN}~${REMAINING}${NC} tokens"
  echo -e "Status:    $ZONE"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ----------------------------------------
# Update daily usage
# ----------------------------------------

update_daily_usage() {
  local NEW_USAGE=$1

  # Update JSON file
  jq ".daily_usage = $NEW_USAGE" "$TOKEN_FILE" > "${TOKEN_FILE}.tmp"
  mv "${TOKEN_FILE}.tmp" "$TOKEN_FILE"

  echo -e "${GREEN}✓ Updated daily usage: $NEW_USAGE${NC}"
}

# ----------------------------------------
# Log to history
# ----------------------------------------

log_history() {
  local USAGE=$1
  local ACTION=$2

  # Get current date
  DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Create history entry
  ENTRY=$(jq -n \
    --arg date "$DATE" \
    --arg action "$ACTION" \
    --argjson usage "$USAGE" \
    '{date: $date, action: $action, daily_usage: $usage}')

  # Append to history (if history section exists)
  if jq -e '.history' "$TOKEN_FILE" > /dev/null 2>&1; then
    jq ".history.entries += [$ENTRY]" "$TOKEN_FILE" > "${TOKEN_FILE}.tmp"
    mv "${TOKEN_FILE}.tmp" "$TOKEN_FILE"
  fi
}

# ----------------------------------------
# Handle commands
# ----------------------------------------

case "$COMMAND" in

  add)
    if [ -z "$AMOUNT" ]; then
      echo -e "${RED}Error: Amount required${NC}"
      echo "Usage: ./scripts/token-log.sh add <amount>"
      exit 1
    fi

    CURRENT=$(get_daily_usage)
    NEW_USAGE=$((CURRENT + AMOUNT))

    update_daily_usage "$NEW_USAGE"
    log_history "$NEW_USAGE" "add $AMOUNT"
    show_status
    ;;

  set)
    if [ -z "$AMOUNT" ]; then
      echo -e "${RED}Error: Amount required${NC}"
      echo "Usage: ./scripts/token-log.sh set <amount>"
      exit 1
    fi

    update_daily_usage "$AMOUNT"
    log_history "$AMOUNT" "set $AMOUNT"
    show_status
    ;;

  reset)
    update_daily_usage 0
    log_history 0 "reset"

    echo ""
    echo -e "${GREEN}✓ Daily usage reset to 0${NC}"
    echo ""
    ;;

  status)
    show_status
    ;;

  history)
    echo ""
    echo "📅 Token Usage History (last 7 days)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if jq -e '.history.entries' "$TOKEN_FILE" > /dev/null 2>&1; then
      # Show last 7 entries
      jq -r '.history.entries[-7:] | .[] | "\(.date) - \(.action) → \(.daily_usage) tokens"' "$TOKEN_FILE"
    else
      echo "No history available"
      echo "(History tracking is optional in token-limits.json)"
    fi

    echo ""
    ;;

  help|--help|-h)
    show_help
    ;;

  *)
    echo -e "${RED}Error: Unknown command '$COMMAND'${NC}"
    echo ""
    show_help
    exit 1
    ;;

esac

exit 0
