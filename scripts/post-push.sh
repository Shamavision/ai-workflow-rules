#!/usr/bin/env bash
# post-push.sh — Session Memory Anchor
# Updates the "Last Push" section in PROJECT_CONTEXT_MAP.md after every git push.
# This gives AI tools a reliable anchor: compare today's date with last push date
# to detect "new day = fresh limits" vs "continuing same session".
#
# Install: copy to .git/hooks/post-push and make executable
# Or: run manually after git push via `bash scripts/post-push.sh`

set -euo pipefail

# ---------------------------------------------------------------------------
# 1. Find repo root (works from any subdirectory)
# ---------------------------------------------------------------------------
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "[post-push] ERROR: not inside a git repository" >&2
  exit 0  # soft exit — don't block push
}

MAP_FILE="$REPO_ROOT/PROJECT_CONTEXT_MAP.md"

# ---------------------------------------------------------------------------
# 2. Gather push info
# ---------------------------------------------------------------------------
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "unknown")
PUSH_DATE=$(date +"%Y-%m-%d")
PUSH_TIME=$(date +"%H:%M")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
FILES_CHANGED=$(git diff --name-only HEAD~1 HEAD 2>/dev/null | wc -l | tr -d ' ' || echo "?")

# Guard: if no PROJECT_CONTEXT_MAP.md, skip silently
if [ ! -f "$MAP_FILE" ]; then
  echo "[post-push] PROJECT_CONTEXT_MAP.md not found — skipping anchor update."
  echo "[post-push] Run /ctx to create the map first."
  exit 0
fi

# ---------------------------------------------------------------------------
# 3. Build the Last Push block
# ---------------------------------------------------------------------------
ANCHOR_HEADER="## 📍 Last Push (Session Anchor)"

NEW_BLOCK="${ANCHOR_HEADER}

> **AI: Compare this date with today to detect new day. New day = fresh limits!**
>
> Read this section at session start to orient yourself.

| Field | Value |
|-------|-------|
| **Date** | ${PUSH_DATE} |
| **Time** | ${PUSH_TIME} |
| **Commit** | \`${COMMIT_HASH}\` — ${COMMIT_MSG} |
| **Branch** | \`${BRANCH}\` |
| **Files changed** | ${FILES_CHANGED} |

**New-day detection (for AI):**
\`\`\`
today == ${PUSH_DATE} → 📊 Same day, continuing (check session usage)
today != ${PUSH_DATE} → 🟢 New day! Fresh token limits since last push
\`\`\`

---"

# ---------------------------------------------------------------------------
# 4. Update or append the anchor section
# ---------------------------------------------------------------------------
TMPFILE=$(mktemp)

if grep -q "Last Push (Session Anchor)" "$MAP_FILE" 2>/dev/null; then
  # Section exists — replace everything from the header until the next "## " heading
  # (or end of file). Use awk for reliable multi-line replacement.
  # Note: avoid emoji in awk pattern for Windows/Git-Bash compatibility
  awk -v new_block="$NEW_BLOCK" '
    /Last Push \(Session Anchor\)/ { in_section=1; print new_block; next }
    in_section && /^## / && !/Last Push/ { in_section=0 }
    !in_section { print }
  ' "$MAP_FILE" > "$TMPFILE"
  mv "$TMPFILE" "$MAP_FILE"
  echo "[post-push] ✓ Updated Last Push anchor in PROJECT_CONTEXT_MAP.md"
else
  # Section missing — append before the last line (or at end of file)
  {
    cat "$MAP_FILE"
    echo ""
    echo "$NEW_BLOCK"
  } > "$TMPFILE"
  mv "$TMPFILE" "$MAP_FILE"
  echo "[post-push] ✓ Appended Last Push anchor to PROJECT_CONTEXT_MAP.md"
fi

# ---------------------------------------------------------------------------
# 5. Update session-log.json push count (v2.0 — requires node)
# ---------------------------------------------------------------------------
SESSION_LOG="$REPO_ROOT/.ai/session-log.json"

if [ -f "$SESSION_LOG" ] && command -v node &>/dev/null; then
  node -e "
    const fs = require('fs');
    try {
      const log = JSON.parse(fs.readFileSync('$SESSION_LOG', 'utf8'));
      if (!log.days) process.exit(0); // v1.x format — skip
      const today = new Date().toISOString().slice(0,10);
      let day = log.days.find(d => d.date === today);
      if (!day) {
        day = { date: today, sessions: [], daily_total: { sessions: 0, messages: 0, pushes: 0 } };
        log.days.push(day);
      }
      if (!day.daily_total) day.daily_total = { sessions: 0, messages: 0, pushes: 0 };
      day.daily_total.pushes = (day.daily_total.pushes || 0) + 1;
      fs.writeFileSync('$SESSION_LOG', JSON.stringify(log, null, 2));
      console.log('[post-push] ✓ session-log.json: push #' + day.daily_total.pushes + ' recorded for ' + today);
    } catch(e) {
      console.log('[post-push] Note: could not update session-log.json (' + e.message + ')');
    }
  " 2>/dev/null || echo "[post-push] Note: session-log.json not updated (node error)"
fi

# ---------------------------------------------------------------------------
# 6. Done
# ---------------------------------------------------------------------------
echo "[post-push] Session anchor: ${PUSH_DATE} | ${COMMIT_HASH} | ${BRANCH}"
echo "[post-push] AI can compare today's date to '${PUSH_DATE}' for new-day detection."
