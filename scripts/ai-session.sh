#!/bin/bash
# scripts/ai-session.sh - AI session wrapper with automatic token tracking
# Part of AI Workflow Rules Framework v9.1.1

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SESSION_LOG=".ai/session-log.json"
TOKEN_FILE=".ai/token-limits.json"

# ----------------------------------------
# Help message
# ----------------------------------------

show_help() {
  echo "🤖 AI Workflow Rules - Session Wrapper"
  echo "========================================"
  echo ""
  echo "Usage: ./scripts/ai-session.sh <command> [args]"
  echo ""
  echo "Commands:"
  echo "  start <ide> [description]  - Start new AI session"
  echo "  end <tokens>               - End session and log token usage"
  echo "  current                    - Show current session info"
  echo "  list                       - List recent sessions"
  echo "  stats                      - Show session statistics"
  echo ""
  echo "IDE options:"
  echo "  vscode      - VSCode with Claude Code"
  echo "  cursor      - Cursor IDE"
  echo "  windsurf    - Windsurf IDE"
  echo "  cli         - Claude Code CLI"
  echo "  web         - Claude.ai web interface"
  echo ""
  echo "Examples:"
  echo "  ./scripts/ai-session.sh start vscode \"Fix auth bug\""
  echo "  ./scripts/ai-session.sh end 45000"
  echo "  ./scripts/ai-session.sh current"
  echo "  ./scripts/ai-session.sh stats"
  echo ""
}

# ----------------------------------------
# Initialize session log file
# ----------------------------------------

init_session_log() {
  if [ ! -f "$SESSION_LOG" ]; then
    echo '{
  "version": "1.0",
  "sessions": [],
  "current_session": null
}' > "$SESSION_LOG"
  fi
}

# ----------------------------------------
# Start new session
# ----------------------------------------

start_session() {
  local IDE="$1"
  local DESC="$2"

  if [ -z "$IDE" ]; then
    echo -e "${RED}Error: IDE required${NC}"
    echo "Usage: ./scripts/ai-session.sh start <ide> [description]"
    exit 1
  fi

  # Check if there's already an active session
  if jq -e '.current_session' "$SESSION_LOG" > /dev/null 2>&1; then
    CURRENT=$(jq -r '.current_session.id // "none"' "$SESSION_LOG")
    if [ "$CURRENT" != "null" ]; then
      echo -e "${YELLOW}⚠ Warning: Active session already exists (ID: $CURRENT)${NC}"
      echo ""
      read -p "End current session first? (y/n): " -r
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Please run: ./scripts/ai-session.sh end <tokens>"
        exit 1
      fi
    fi
  fi

  # Generate session ID
  SESSION_ID=$(date +%s)
  START_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Get daily usage before session
  DAILY_BEFORE=$(jq -r '.daily_usage // 0' "$TOKEN_FILE")

  # Create session object
  SESSION=$(jq -n \
    --arg id "$SESSION_ID" \
    --arg ide "$IDE" \
    --arg desc "$DESC" \
    --arg start "$START_TIME" \
    --argjson daily_before "$DAILY_BEFORE" \
    '{
      id: $id,
      ide: $ide,
      description: $desc,
      start_time: $start,
      end_time: null,
      tokens_used: null,
      daily_before: $daily_before,
      daily_after: null
    }')

  # Update session log
  jq ".current_session = $SESSION" "$SESSION_LOG" > "${SESSION_LOG}.tmp"
  mv "${SESSION_LOG}.tmp" "$SESSION_LOG"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "🚀 ${GREEN}Session Started${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo -e "Session ID:   ${CYAN}$SESSION_ID${NC}"
  echo -e "IDE:          ${BLUE}$IDE${NC}"
  echo -e "Description:  $DESC"
  echo -e "Started:      $START_TIME"
  echo -e "Daily usage:  ${YELLOW}${DAILY_BEFORE}${NC} tokens (before session)"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 When done, run: ./scripts/ai-session.sh end <tokens>"
  echo ""
}

# ----------------------------------------
# End session
# ----------------------------------------

end_session() {
  local TOKENS="$1"

  if [ -z "$TOKENS" ]; then
    echo -e "${RED}Error: Token amount required${NC}"
    echo "Usage: ./scripts/ai-session.sh end <tokens>"
    exit 1
  fi

  # Check if there's an active session
  if ! jq -e '.current_session' "$SESSION_LOG" > /dev/null 2>&1; then
    echo -e "${RED}Error: No active session${NC}"
    echo "Start a session first: ./scripts/ai-session.sh start <ide>"
    exit 1
  fi

  SESSION_ID=$(jq -r '.current_session.id' "$SESSION_LOG")
  if [ "$SESSION_ID" = "null" ]; then
    echo -e "${RED}Error: No active session${NC}"
    exit 1
  fi

  # Get session info
  IDE=$(jq -r '.current_session.ide' "$SESSION_LOG")
  DESC=$(jq -r '.current_session.description' "$SESSION_LOG")
  START_TIME=$(jq -r '.current_session.start_time' "$SESSION_LOG")
  DAILY_BEFORE=$(jq -r '.current_session.daily_before' "$SESSION_LOG")

  # Get current daily usage
  DAILY_AFTER=$(jq -r '.daily_usage // 0' "$TOKEN_FILE")

  # Calculate actual tokens used (from daily increase)
  ACTUAL_USED=$((DAILY_AFTER - DAILY_BEFORE))

  # End time
  END_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Update session with end data
  COMPLETED_SESSION=$(jq \
    --arg end "$END_TIME" \
    --argjson tokens "$TOKENS" \
    --argjson daily_after "$DAILY_AFTER" \
    '.current_session.end_time = $end |
     .current_session.tokens_used = $tokens |
     .current_session.daily_after = $daily_after' \
    "$SESSION_LOG")

  # Move to sessions array
  jq ".sessions += [.current_session] | .current_session = null" "$SESSION_LOG" > "${SESSION_LOG}.tmp"
  mv "${SESSION_LOG}.tmp" "$SESSION_LOG"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "🏁 ${GREEN}Session Ended${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo -e "Session ID:   ${CYAN}$SESSION_ID${NC}"
  echo -e "IDE:          ${BLUE}$IDE${NC}"
  echo -e "Description:  $DESC"
  echo -e "Duration:     $START_TIME → $END_TIME"
  echo -e "Tokens used:  ${YELLOW}${TOKENS}${NC} (reported)"
  echo -e "Daily before: ${DAILY_BEFORE}"
  echo -e "Daily after:  ${DAILY_AFTER}"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "✅ Session logged successfully"
  echo ""
}

# ----------------------------------------
# Show current session
# ----------------------------------------

show_current() {
  if ! jq -e '.current_session' "$SESSION_LOG" > /dev/null 2>&1; then
    echo ""
    echo "No active session"
    echo ""
    exit 0
  fi

  SESSION_ID=$(jq -r '.current_session.id' "$SESSION_LOG")
  if [ "$SESSION_ID" = "null" ]; then
    echo ""
    echo "No active session"
    echo ""
    exit 0
  fi

  IDE=$(jq -r '.current_session.ide' "$SESSION_LOG")
  DESC=$(jq -r '.current_session.description' "$SESSION_LOG")
  START_TIME=$(jq -r '.current_session.start_time' "$SESSION_LOG")
  DAILY_BEFORE=$(jq -r '.current_session.daily_before' "$SESSION_LOG")
  DAILY_NOW=$(jq -r '.daily_usage // 0' "$TOKEN_FILE")

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "🔄 ${CYAN}Current Session${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo -e "Session ID:   ${CYAN}$SESSION_ID${NC}"
  echo -e "IDE:          ${BLUE}$IDE${NC}"
  echo -e "Description:  $DESC"
  echo -e "Started:      $START_TIME"
  echo -e "Daily before: ${DAILY_BEFORE}"
  echo -e "Daily now:    ${YELLOW}${DAILY_NOW}${NC}"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ----------------------------------------
# List recent sessions
# ----------------------------------------

list_sessions() {
  echo ""
  echo "📋 Recent Sessions (last 10)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  if ! jq -e '.sessions' "$SESSION_LOG" > /dev/null 2>&1; then
    echo "No sessions logged yet"
    echo ""
    exit 0
  fi

  jq -r '.sessions[-10:] | .[] |
    "\(.start_time) | \(.ide) | \(.tokens_used)k tokens | \(.description)"' \
    "$SESSION_LOG"

  echo ""
}

# ----------------------------------------
# Show statistics
# ----------------------------------------

show_stats() {
  echo ""
  echo "📊 Session Statistics"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  if ! jq -e '.sessions' "$SESSION_LOG" > /dev/null 2>&1; then
    echo "No sessions logged yet"
    echo ""
    exit 0
  fi

  TOTAL_SESSIONS=$(jq '.sessions | length' "$SESSION_LOG")
  TOTAL_TOKENS=$(jq '[.sessions[].tokens_used] | add // 0' "$SESSION_LOG")
  AVG_TOKENS=$((TOTAL_TOKENS / TOTAL_SESSIONS))

  echo "Total sessions: $TOTAL_SESSIONS"
  echo "Total tokens:   ${TOTAL_TOKENS}k"
  echo "Average/session: ${AVG_TOKENS}k"
  echo ""

  echo "By IDE:"
  jq -r '.sessions | group_by(.ide) | .[] |
    "\(.[0].ide): \(length) sessions, \([.[].tokens_used] | add)k tokens"' \
    "$SESSION_LOG"

  echo ""
}

# ----------------------------------------
# Main
# ----------------------------------------

init_session_log

COMMAND="$1"
shift || true

case "$COMMAND" in
  start)
    start_session "$@"
    ;;
  end)
    end_session "$@"
    ;;
  current)
    show_current
    ;;
  list)
    list_sessions
    ;;
  stats)
    show_stats
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
