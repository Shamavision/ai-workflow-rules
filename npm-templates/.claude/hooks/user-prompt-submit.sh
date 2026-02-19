#!/bin/bash
# Layer 2: User Prompt Submit Hook
# Ensures AI reads AGENTS.md at session start
# v2.0: Gap-based session detection + session-log.json tracking

set -e

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SESSION_MARKER="$PROJECT_ROOT/.ai/.session-started"
SESSION_LOG="$PROJECT_ROOT/.ai/session-log.json"
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
START_FILE="$PROJECT_ROOT/START.md"

# Read user's original prompt from stdin
USER_PROMPT=$(cat)

# Gap-based session detection (2h = new session boundary)
NOW=$(date +%s)
LAST_TS=0
if [ -f "$SESSION_MARKER" ]; then
  LAST_TS=$(cat "$SESSION_MARKER" 2>/dev/null || echo 0)
fi
GAP=$(( NOW - LAST_TS ))

# New session if: marker missing OR gap > 2 hours (7200 seconds)
if [ ! -f "$SESSION_MARKER" ] || [ "$GAP" -gt 7200 ]; then
  # Determine which file to read
  TARGET_FILE="$AGENTS_FILE"
  if [ ! -f "$AGENTS_FILE" ]; then
    TARGET_FILE="$START_FILE"
  fi

  # Update session marker with current timestamp
  mkdir -p "$(dirname "$SESSION_MARKER")"
  echo "$NOW" > "$SESSION_MARKER"

  # Write session-start entry to session-log.json (best-effort, never blocks)
  {
    TODAY=$(date +%Y-%m-%d)
    if [ -f "$SESSION_LOG" ] && command -v jq &> /dev/null; then
      NEW_ENTRY="{\"date\":\"$TODAY\",\"tokens\":0,\"tool\":\"claude-code\",\"trigger\":\"session-start\",\"timestamp\":$NOW}"
      jq --argjson e "$NEW_ENTRY" '.sessions += [$e]' "$SESSION_LOG" > "${SESSION_LOG}.tmp" \
        && mv "${SESSION_LOG}.tmp" "$SESSION_LOG"
    fi
  } 2>/dev/null || true

  # Inject Session Start instruction
  cat <<EOF
$USER_PROMPT

---
**[SYSTEM: Session Start Protocol Required]**
Before responding to the user's message above, you MUST:
1. Read file: $TARGET_FILE
2. Execute Session Start Protocol from AGENTS.md (lines 8-34)
3. Display [SESSION START] confirmation block
4. Then proceed with user's request

This is MANDATORY. Do not skip.
EOF
else
  # Same session (gap < 2h) - pass through unchanged
  echo "$USER_PROMPT"
fi
