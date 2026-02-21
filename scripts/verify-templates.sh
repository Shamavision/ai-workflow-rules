#!/bin/bash
# scripts/verify-templates.sh - Verify npm-templates sync with project files
# Part of AI Workflow Rules Framework v9.1.1

set -e

echo "🔄 AI Workflow Rules - Template Sync Verifier"
echo "=============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
IN_SYNC=0

# Check if npm-templates directory exists
if [ ! -d "npm-templates" ]; then
  echo -e "${RED}✗ npm-templates/ directory not found!${NC}"
  echo "This script should be run from project root."
  exit 1
fi

echo "📋 Checking sync between development files and npm-templates..."
echo ""

# ----------------------------------------
# Files that MUST be synced
# ----------------------------------------

SYNC_FILES=(
  ".ai/AI-ENFORCEMENT.md"
  ".ai/config.json"
  ".ai/forbidden-trackers.json"
  ".ai/token-limits.json"
  ".ai/contexts/minimal.context.md"
  ".ai/contexts/standard.context.md"
  ".ai/contexts/ukraine-full.context.md"
  ".ai/contexts/enterprise.context.md"
  ".ai/docs/quickstart.md"
  ".ai/docs/cheatsheet.md"
  ".ai/docs/token-usage.md"
  ".ai/docs/session-mgmt.md"
  ".ai/docs/compatibility.md"
  ".ai/docs/start.md"
  ".ai/docs/provider-comparison.md"
  ".ai/docs/code-quality.md"
  ".ai/rules/core.md"
  ".ai/rules/product.md"
  ".claude/CLAUDE.md"
  ".claude/hooks/user-prompt-submit.sh"
  ".cursorrules"
)

# ----------------------------------------
# Compare files
# ----------------------------------------

echo "🔍 Comparing files..."
echo ""

for FILE in "${SYNC_FILES[@]}"; do
  DEV_FILE="$FILE"
  TEMPLATE_FILE="npm-templates/$FILE"

  # Check if dev file exists
  if [ ! -f "$DEV_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} $FILE - Missing in development (not in project)"
    WARNINGS=$((WARNINGS + 1))
    continue
  fi

  # Check if template file exists
  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}✗${NC} $FILE - Missing in npm-templates"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Compare files
  if cmp -s "$DEV_FILE" "$TEMPLATE_FILE"; then
    echo -e "${GREEN}✓${NC} $FILE - In sync"
    IN_SYNC=$((IN_SYNC + 1))
  else
    echo -e "${RED}✗${NC} $FILE - OUT OF SYNC!"
    ERRORS=$((ERRORS + 1))

    # Show diff summary (optional)
    if command -v diff &> /dev/null; then
      DIFF_LINES=$(diff "$DEV_FILE" "$TEMPLATE_FILE" | wc -l)
      echo -e "   ${BLUE}ℹ${NC} $DIFF_LINES lines differ"
    fi
  fi
done

# ----------------------------------------
# Check for extra files in npm-templates
# ----------------------------------------

echo ""
echo "🔍 Checking for extra files in npm-templates..."
echo ""

EXTRA_COUNT=0

while IFS= read -r -d '' TEMPLATE_FILE; do
  # Remove npm-templates/ prefix
  REL_PATH="${TEMPLATE_FILE#npm-templates/}"

  # Skip directories
  if [ -d "$TEMPLATE_FILE" ]; then
    continue
  fi

  # Check if file should exist in dev
  DEV_FILE="$REL_PATH"

  # Skip special npm files
  if [[ "$REL_PATH" == "package.json" ]] || \
     [[ "$REL_PATH" == "README.md" ]] || \
     [[ "$REL_PATH" == "AGENTS.md" ]] || \
     [[ "$REL_PATH" == "LICENSE" ]]; then
    continue
  fi

  # Check if exists in SYNC_FILES list
  FOUND=false
  for SYNC_FILE in "${SYNC_FILES[@]}"; do
    if [[ "$SYNC_FILE" == "$REL_PATH" ]]; then
      FOUND=true
      break
    fi
  done

  if [ "$FOUND" = false ]; then
    # This file is in npm-templates but not tracked
    echo -e "${YELLOW}ℹ${NC} Extra file in npm-templates: $REL_PATH"
    EXTRA_COUNT=$((EXTRA_COUNT + 1))
  fi

done < <(find npm-templates -type f -print0 2>/dev/null)

if [ $EXTRA_COUNT -eq 0 ]; then
  echo -e "${GREEN}✓${NC} No unexpected extra files"
fi

# ----------------------------------------
# Summary
# ----------------------------------------

echo ""
echo "=============================================="
echo "📊 Sync Verification Summary"
echo "=============================================="
echo ""

TOTAL=$((IN_SYNC + ERRORS + WARNINGS))

echo "In sync:  $IN_SYNC / $TOTAL files"
echo "Errors:   $ERRORS file(s) out of sync"
echo "Warnings: $WARNINGS file(s) missing"
echo ""

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✅ All tracked files are in sync!${NC}"
  EXIT_CODE=0
else
  echo -e "${RED}❌ Sync verification failed!${NC}"
  echo ""
  echo "Out of sync files need to be updated in npm-templates."
  echo ""
  echo "💡 Fix options:"
  echo "   1. Run './scripts/sync-rules.sh' to regenerate tool files"
  echo "   2. Manually copy updated files to npm-templates/"
  echo "   3. Check if changes should be in npm-templates at all"
  echo ""
  echo "⚠️  CRITICAL: Always verify sync before 'npm publish'!"
  EXIT_CODE=1
fi

echo ""
echo "📚 Next steps:"
echo "   • Ensure all changes are synced before publishing"
echo "   • Run 'npm run verify-templates' in CI/CD pipeline"
echo "   • Consider this a pre-publish requirement"
echo ""

exit $EXIT_CODE
