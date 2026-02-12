#!/bin/bash
# scripts/cleanup-root.sh - Clean up obsolete files from root directory
# Part of AI Workflow Rules Framework v9.1.1

set -e

echo "🧹 AI Workflow Rules - Root Cleanup"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
REMOVED=0
SKIPPED=0
ERRORS=0

# ----------------------------------------
# Obsolete files from pre-v9.1 structure
# ----------------------------------------

OBSOLETE_FILES=(
  "RULES_CORE.md"
  "RULES_PRODUCT.md"
  "RULES-CRITICAL.md"  # Moved to .ai/
  "TOKEN_USAGE.md"     # Moved to .ai/docs/
  "QUICKSTART.md"      # Moved to .ai/docs/
  "CHEATSHEET.md"      # Moved to .ai/docs/
  "START.md"           # Moved to .ai/docs/
  "AI_COMPATIBILITY.md" # Moved to .ai/docs/
  "AI-ENFORCEMENT.md"  # Moved to .ai/
  "token-limits.json"  # Moved to .ai/
  "forbidden-trackers.json" # Moved to .ai/
)

echo "📋 Checking for obsolete files..."
echo ""

# DRY RUN mode (default)
DRY_RUN=true

# Check if --execute flag is passed
if [[ "$1" == "--execute" ]]; then
  DRY_RUN=false
  echo "⚠️  EXECUTE MODE: Files will be deleted!"
  echo ""
  read -p "Are you sure? (yes/no): " -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "❌ Cleanup cancelled."
    exit 0
  fi
else
  echo "ℹ️  DRY RUN MODE: No files will be deleted (use --execute to actually delete)"
  echo ""
fi

# ----------------------------------------
# Check and remove obsolete files
# ----------------------------------------

for FILE in "${OBSOLETE_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo -e "${YELLOW}Would delete:${NC} $FILE"
      REMOVED=$((REMOVED + 1))
    else
      echo -e "Deleting: $FILE"
      if rm "$FILE" 2>/dev/null; then
        echo -e "${GREEN}✓ Deleted:${NC} $FILE"
        REMOVED=$((REMOVED + 1))
      else
        echo -e "${RED}✗ Failed to delete:${NC} $FILE"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  else
    SKIPPED=$((SKIPPED + 1))
  fi
done

# ----------------------------------------
# Summary
# ----------------------------------------

echo ""
echo "===================================="
echo "📊 Cleanup Summary"
echo "===================================="
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "Mode: DRY RUN (no files deleted)"
  echo "Would remove: $REMOVED file(s)"
  echo "Already clean: $SKIPPED file(s)"
  echo ""
  echo "💡 To actually delete files, run:"
  echo "   ./scripts/cleanup-root.sh --execute"
else
  if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Cleanup complete!${NC}"
    echo "Removed: $REMOVED file(s)"
    echo "Already clean: $SKIPPED file(s)"
  else
    echo -e "${RED}⚠️  Cleanup completed with errors${NC}"
    echo "Removed: $REMOVED file(s)"
    echo "Errors: $ERRORS file(s)"
    echo "Already clean: $SKIPPED file(s)"
  fi
fi

echo ""
echo "📁 Root directory structure:"
echo "   ✅ Keep: AGENTS.md (entry point)"
echo "   ✅ Keep: README.md, LICENSE, CHANGELOG.md"
echo "   ✅ Keep: INSTALL.md, NOTICE.md, VISUAL_GUIDE.md"
echo "   ✅ Keep: ROADMAP.md, QUICK_CONTEXT.md"
echo "   ❌ Obsolete files (pre-v9.1): moved to .ai/"
echo ""

exit 0
