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
  # Same session (gap < 2h) — check context map freshness and proposals
  CONTEXT_HINTS=""

  # Check PROJECT_CONTEXT_MAP.md age
  CTX_MAP="$PROJECT_ROOT/PROJECT_CONTEXT_MAP.md"
  if [ -f "$CTX_MAP" ]; then
    LAST_MODIFIED=$(stat -c %Y "$CTX_MAP" 2>/dev/null || stat -f %m "$CTX_MAP" 2>/dev/null || echo 0)
    AGE_DAYS=$(( (NOW - LAST_MODIFIED) / 86400 ))
    if [ "$AGE_DAYS" -gt 7 ]; then
      CONTEXT_HINTS="${CONTEXT_HINTS}⚠️ [CONTEXT] PROJECT_CONTEXT_MAP.md is ${AGE_DAYS} days old. Consider: /ctx update → /sculptor\n"
    fi
  fi

  # Check for unreviewed PROPOSALS.md
  PROPOSALS="$PROJECT_ROOT/PROPOSALS.md"
  if [ -f "$PROPOSALS" ]; then
    CONTEXT_HINTS="${CONTEXT_HINTS}📋 [PROPOSALS] PROPOSALS.md has architectural recommendations pending review.\n"
  fi

  # Output prompt with hints (if any)
  if [ -n "$CONTEXT_HINTS" ]; then
    printf "%s\n\n---\n**[CONTEXT HINTS]**\n%s---\n" "$USER_PROMPT" "$CONTEXT_HINTS"
  else
    echo "$USER_PROMPT"
  fi
fi
