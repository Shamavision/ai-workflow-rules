#!/bin/bash
# Layer 3: Manual Session Init Script (Fallback)
# Use when AI doesn't auto-load AGENTS.md

set -e

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
START_FILE="$PROJECT_ROOT/START.md"

# Determine which file exists
if [ -f "$AGENTS_FILE" ]; then
  TARGET_FILE="AGENTS.md"
  FALLBACK=""
elif [ -f "$START_FILE" ]; then
  TARGET_FILE="START.md"
  FALLBACK=" (AGENTS.md not found, using fallback)"
else
  echo "ERROR: Neither AGENTS.md nor START.md found in project root!"
  exit 1
fi

# Generate initialization message
cat <<EOF
🤖 **Session Start Protocol Required$FALLBACK**

Before we begin, please:

1. Read the file: \`$TARGET_FILE\`
2. Execute Session Start Protocol (Section 🚀)
3. Display \`[SESSION START]\` confirmation block with:
   - Loaded rules version
   - Language settings
   - Token limits (if applicable)
   - Current usage status

Then say: "Ready to work. В чем помочь?"

---

**Why this matters:**
- Ensures consistent workflow across sessions
- Activates security guards (secrets, trackers)
- Sets language rules (Russian dialogue, English code)
- Enables token management

This is **MANDATORY** - please don't skip! 🚨
EOF

echo ""
echo "---"
echo "💡 Tip: Copy the message above and send it to your AI assistant"
echo "📋 Or pipe to clipboard: ./scripts/session-init.sh | clip  (Windows)"
echo "📋 Or pipe to clipboard: ./scripts/session-init.sh | pbcopy  (macOS)"
