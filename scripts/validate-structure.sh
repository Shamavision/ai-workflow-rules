#!/bin/bash
# scripts/validate-structure.sh - Validate v9.1 structure
# Part of AI Workflow Rules Framework v9.1.1

set -e

echo "🔍 AI Workflow Rules - Structure Validator v9.1"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
PASSED=0

# ----------------------------------------
# 1. Check Root Files (v9.1 structure)
# ----------------------------------------

echo "📁 Checking root files (v9.1 structure)..."
echo ""

REQUIRED_ROOT=(
  "AGENTS.md:Entry point for AI assistants"
  "README.md:Project README"
  "LICENSE:License file"
)

OPTIONAL_ROOT=(
  "CHANGELOG.md:Version history"
  "INSTALL.md:Installation guide"
  "ROADMAP.md:Development roadmap"
  "QUICK_CONTEXT.md:Quick context reference"
  "VISUAL_GUIDE.md:Visual guide"
)

for ITEM in "${REQUIRED_ROOT[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $FILE - $DESC (REQUIRED)"
    ERRORS=$((ERRORS + 1))
  fi
done

for ITEM in "${OPTIONAL_ROOT[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}⚠${NC} $FILE - $DESC (optional)"
    WARNINGS=$((WARNINGS + 1))
  fi
done

# ----------------------------------------
# 2. Check .ai/ Directory Structure
# ----------------------------------------

echo ""
echo "📂 Checking .ai/ directory structure..."
echo ""

AI_REQUIRED=(
  ".ai/config.json:Framework configuration"
  ".ai/token-limits.json:Token budget tracking"
  ".ai/AI-ENFORCEMENT.md:Mandatory AI protocols"
  ".ai/forbidden-trackers.json:Blocked trackers list"
)

AI_DIRS=(
  ".ai/contexts:Context presets directory"
  ".ai/docs:Documentation directory"
  ".ai/rules:Full rules directory"
)

for ITEM in "${AI_REQUIRED[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $FILE - $DESC (REQUIRED)"
    ERRORS=$((ERRORS + 1))
  fi
done

for ITEM in "${AI_DIRS[@]}"; do
  DIR="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -d "$DIR" ]; then
    echo -e "${GREEN}✓${NC} $DIR/ - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $DIR/ - $DESC (REQUIRED)"
    ERRORS=$((ERRORS + 1))
  fi
done

# ----------------------------------------
# 3. Check Contexts (v9.1 presets)
# ----------------------------------------

echo ""
echo "📦 Checking context presets..."
echo ""

CONTEXTS=(
  ".ai/contexts/minimal.context.md:Minimal context (~10k)"
  ".ai/contexts/standard.context.md:Standard context (~14k)"
  ".ai/contexts/ukraine-full.context.md:Ukraine-full context (~18k)"
  ".ai/contexts/enterprise.context.md:Enterprise context (~23k)"
)

for ITEM in "${CONTEXTS[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $FILE - $DESC (REQUIRED)"
    ERRORS=$((ERRORS + 1))
  fi
done

# ----------------------------------------
# 4. Check Documentation
# ----------------------------------------

echo ""
echo "📖 Checking documentation files..."
echo ""

DOCS=(
  ".ai/docs/quickstart.md:Quick start guide"
  ".ai/docs/cheatsheet.md:Commands cheatsheet"
  ".ai/docs/token-usage.md:Token usage guide"
  ".ai/docs/session-mgmt.md:Session management guide"
  ".ai/docs/compatibility.md:AI compatibility guide"
  ".ai/docs/start.md:Getting started"
  ".ai/docs/provider-comparison.md:Provider comparison"
  ".ai/docs/code-quality.md:Code quality guide"
)

for ITEM in "${DOCS[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}⚠${NC} $FILE (recommended)"
    WARNINGS=$((WARNINGS + 1))
  fi
done

# ----------------------------------------
# 5. Check Full Rules
# ----------------------------------------

echo ""
echo "📜 Checking full rules..."
echo ""

RULES=(
  ".ai/rules/core.md:Core workflow rules"
  ".ai/rules/product.md:Product-specific rules"
)

for ITEM in "${RULES[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}⚠${NC} $FILE - $DESC (optional)"
    WARNINGS=$((WARNINGS + 1))
  fi
done

# ----------------------------------------
# 6. Check Tool-Specific Files
# ----------------------------------------

echo ""
echo "🛠️  Checking tool-specific files..."
echo ""

TOOL_FILES=(
  ".claude/CLAUDE.md:Claude Code config"
  ".cursorrules:Cursor IDE config"
)

for ITEM in "${TOOL_FILES[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    echo -e "${GREEN}✓${NC} $FILE - $DESC"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}⚠${NC} $FILE - $DESC (auto-generated)"
    WARNINGS=$((WARNINGS + 1))
  fi
done

# ----------------------------------------
# 7. Check Scripts
# ----------------------------------------

echo ""
echo "📜 Checking essential scripts..."
echo ""

SCRIPTS=(
  "scripts/pre-commit:Pre-commit hook"
  "scripts/sync-rules.sh:Sync rules to tool files"
  "scripts/check-links.sh:Link validator"
  "scripts/validate-structure.sh:Structure validator (this script)"
)

for ITEM in "${SCRIPTS[@]}"; do
  FILE="${ITEM%%:*}"
  DESC="${ITEM##*:}"

  if [ -f "$FILE" ]; then
    if [ -x "$FILE" ]; then
      echo -e "${GREEN}✓${NC} $FILE - $DESC (executable)"
      PASSED=$((PASSED + 1))
    else
      echo -e "${YELLOW}⚠${NC} $FILE - $DESC (not executable)"
      WARNINGS=$((WARNINGS + 1))
    fi
  else
    echo -e "${YELLOW}⚠${NC} $FILE - $DESC (recommended)"
    WARNINGS=$((WARNINGS + 1))
  fi
done

# ----------------------------------------
# 8. Check for Obsolete Files (pre-v9.1)
# ----------------------------------------

echo ""
echo "🗑️  Checking for obsolete files (pre-v9.1)..."
echo ""

OBSOLETE=(
  "RULES_CORE.md"
  "RULES_PRODUCT.md"
  "TOKEN_USAGE.md"
  "QUICKSTART.md"
  "CHEATSHEET.md"
  "START.md"
)

FOUND_OBSOLETE=0

for FILE in "${OBSOLETE[@]}"; do
  if [ -f "$FILE" ]; then
    echo -e "${YELLOW}⚠${NC} Found obsolete file: $FILE (should be in .ai/)"
    FOUND_OBSOLETE=$((FOUND_OBSOLETE + 1))
    WARNINGS=$((WARNINGS + 1))
  fi
done

if [ $FOUND_OBSOLETE -eq 0 ]; then
  echo -e "${GREEN}✓${NC} No obsolete files found"
  PASSED=$((PASSED + 1))
else
  echo ""
  echo -e "${YELLOW}💡 Run './scripts/cleanup-root.sh' to remove obsolete files${NC}"
fi

# ----------------------------------------
# 9. Summary
# ----------------------------------------

echo ""
echo "================================================"
echo "📊 Validation Summary"
echo "================================================"
echo ""

echo "Passed:   $PASSED checks"
echo "Warnings: $WARNINGS checks"
echo "Errors:   $ERRORS checks"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✅ Perfect! v9.1 structure is complete.${NC}"
  EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠️  Structure is valid with $WARNINGS warning(s).${NC}"
  echo "Everything works, but some optional components are missing."
  EXIT_CODE=0
else
  echo -e "${RED}❌ Structure validation failed with $ERRORS error(s).${NC}"
  echo "Please fix errors above before proceeding."
  EXIT_CODE=1
fi

echo ""
echo "📚 Next steps:"
echo "   • Run './scripts/sync-rules.sh' to regenerate tool files"
echo "   • Run './scripts/check-links.sh' to verify documentation links"
echo "   • Run './scripts/cleanup-root.sh' to remove obsolete files"
echo ""

exit $EXIT_CODE
