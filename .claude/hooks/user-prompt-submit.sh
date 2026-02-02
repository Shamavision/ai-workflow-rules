#!/bin/bash
# Layer 2: User Prompt Submit Hook
# Ensures AI reads AGENTS.md at session start

set -e

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SESSION_MARKER="$PROJECT_ROOT/.ai/.session-started"
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
START_FILE="$PROJECT_ROOT/START.md"

# Read user's original prompt from stdin
USER_PROMPT=$(cat)

# Check if this is first message in session
if [ ! -f "$SESSION_MARKER" ]; then
  # Determine which file to read
  TARGET_FILE="$AGENTS_FILE"
  if [ ! -f "$AGENTS_FILE" ]; then
    TARGET_FILE="$START_FILE"
  fi

  # Mark session as started
  mkdir -p "$(dirname "$SESSION_MARKER")"
  date +%s > "$SESSION_MARKER"

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
  # Not first message - pass through unchanged
  echo "$USER_PROMPT"
fi
