#!/bin/bash
# scripts/context-diff.sh - Compare context presets
# Part of AI Workflow Rules Framework v9.1.1

set -e

echo "🔍 AI Workflow Rules - Context Comparison Tool"
echo "=============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ----------------------------------------
# Available contexts
# ----------------------------------------

CONTEXTS=(
  "minimal"
  "standard"
  "ukraine-full"
  "enterprise"
)

# ----------------------------------------
# Parse arguments
# ----------------------------------------

CONTEXT1="$1"
CONTEXT2="$2"
MODE="${3:-summary}"  # summary | full | tokens

# ----------------------------------------
# Help message
# ----------------------------------------

show_help() {
  echo "Usage: ./scripts/context-diff.sh <context1> <context2> [mode]"
  echo ""
  echo "Contexts:"
  echo "  minimal       - ~10k tokens (startups, MVP)"
  echo "  standard      - ~14k tokens (most projects)"
  echo "  ukraine-full  - ~18k tokens (Ukrainian market)"
  echo "  enterprise    - ~23k tokens (large teams)"
  echo ""
  echo "Modes:"
  echo "  summary  - Show summary differences (default)"
  echo "  full     - Show detailed diff"
  echo "  tokens   - Show token estimates only"
  echo ""
  echo "Examples:"
  echo "  ./scripts/context-diff.sh minimal standard"
  echo "  ./scripts/context-diff.sh minimal ukraine-full full"
  echo "  ./scripts/context-diff.sh standard enterprise tokens"
  echo ""
}

# ----------------------------------------
# Validate arguments
# ----------------------------------------

if [ -z "$CONTEXT1" ] || [ -z "$CONTEXT2" ]; then
  show_help
  exit 1
fi

# Check if contexts are valid
VALID_CONTEXT1=false
VALID_CONTEXT2=false

for CTX in "${CONTEXTS[@]}"; do
  if [ "$CTX" = "$CONTEXT1" ]; then
    VALID_CONTEXT1=true
  fi
  if [ "$CTX" = "$CONTEXT2" ]; then
    VALID_CONTEXT2=true
  fi
done

if [ "$VALID_CONTEXT1" = false ]; then
  echo -e "${RED}Error: Invalid context '$CONTEXT1'${NC}"
  echo ""
  show_help
  exit 1
fi

if [ "$VALID_CONTEXT2" = false ]; then
  echo -e "${RED}Error: Invalid context '$CONTEXT2'${NC}"
  echo ""
  show_help
  exit 1
fi

# ----------------------------------------
# Get file paths
# ----------------------------------------

FILE1=".ai/contexts/${CONTEXT1}.context.md"
FILE2=".ai/contexts/${CONTEXT2}.context.md"

if [ ! -f "$FILE1" ]; then
  echo -e "${RED}Error: $FILE1 not found${NC}"
  exit 1
fi

if [ ! -f "$FILE2" ]; then
  echo -e "${RED}Error: $FILE2 not found${NC}"
  exit 1
fi

# ----------------------------------------
# Get token estimates from file headers
# ----------------------------------------

get_token_estimate() {
  local FILE="$1"
  # Extract token count from header (e.g., "**Tokens:** ~10k")
  grep -m 1 "Tokens:" "$FILE" | sed 's/.*~\([0-9]*\)k.*/\1/' || echo "unknown"
}

TOKENS1=$(get_token_estimate "$FILE1")
TOKENS2=$(get_token_estimate "$FILE2")

# ----------------------------------------
# Token-only mode
# ----------------------------------------

if [ "$MODE" = "tokens" ]; then
  echo "📊 Token Comparison"
  echo ""
  echo -e "${CYAN}$CONTEXT1${NC}: ~${TOKENS1}k tokens"
  echo -e "${CYAN}$CONTEXT2${NC}: ~${TOKENS2}k tokens"
  echo ""

  if [ "$TOKENS1" != "unknown" ] && [ "$TOKENS2" != "unknown" ]; then
    DIFF=$((TOKENS2 - TOKENS1))
    if [ $DIFF -gt 0 ]; then
      echo -e "Difference: ${YELLOW}+${DIFF}k${NC} tokens (${CONTEXT2} is larger)"
    elif [ $DIFF -lt 0 ]; then
      echo -e "Difference: ${GREEN}${DIFF}k${NC} tokens (${CONTEXT1} is larger)"
    else
      echo "Difference: Same size"
    fi
  fi

  exit 0
fi

# ----------------------------------------
# Extract sections from context files
# ----------------------------------------

get_sections() {
  local FILE="$1"
  grep -E '^##+ ' "$FILE" | sed 's/^##* //' || true
}

SECTIONS1=$(get_sections "$FILE1")
SECTIONS2=$(get_sections "$FILE2")

# ----------------------------------------
# Summary mode
# ----------------------------------------

if [ "$MODE" = "summary" ]; then
  echo -e "Comparing: ${CYAN}$CONTEXT1${NC} vs ${CYAN}$CONTEXT2${NC}"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Token info
  echo "📊 Token Estimates:"
  echo -e "   $CONTEXT1: ~${TOKENS1}k tokens"
  echo -e "   $CONTEXT2: ~${TOKENS2}k tokens"
  echo ""

  # File sizes
  SIZE1=$(wc -l < "$FILE1")
  SIZE2=$(wc -l < "$FILE2")
  echo "📄 File Sizes:"
  echo -e "   $CONTEXT1: $SIZE1 lines"
  echo -e "   $CONTEXT2: $SIZE2 lines"
  echo ""

  # Section count
  COUNT1=$(echo "$SECTIONS1" | wc -l)
  COUNT2=$(echo "$SECTIONS2" | wc -l)
  echo "📑 Sections:"
  echo -e "   $CONTEXT1: $COUNT1 sections"
  echo -e "   $CONTEXT2: $COUNT2 sections"
  echo ""

  # Key differences
  echo "🔑 Key Features:"
  echo ""

  echo -e "${CYAN}$CONTEXT1 includes:${NC}"
  case "$CONTEXT1" in
    minimal)
      echo "   • Core workflow only"
      echo "   • Basic security"
      echo "   • Essential git discipline"
      ;;
    standard)
      echo "   • Full workflow"
      echo "   • Token management"
      echo "   • Advanced git discipline"
      ;;
    ukraine-full)
      echo "   • Everything in standard +"
      echo "   • Ukrainian market compliance"
      echo "   • Language quality rules"
      echo "   • Cyber defense"
      ;;
    enterprise)
      echo "   • Everything in ukraine-full +"
      echo "   • Advanced patterns"
      echo "   • Team collaboration features"
      echo "   • Enterprise integrations"
      ;;
  esac

  echo ""
  echo -e "${CYAN}$CONTEXT2 includes:${NC}"
  case "$CONTEXT2" in
    minimal)
      echo "   • Core workflow only"
      echo "   • Basic security"
      echo "   • Essential git discipline"
      ;;
    standard)
      echo "   • Full workflow"
      echo "   • Token management"
      echo "   • Advanced git discipline"
      ;;
    ukraine-full)
      echo "   • Everything in standard +"
      echo "   • Ukrainian market compliance"
      echo "   • Language quality rules"
      echo "   • Cyber defense"
      ;;
    enterprise)
      echo "   • Everything in ukraine-full +"
      echo "   • Advanced patterns"
      echo "   • Team collaboration features"
      echo "   • Enterprise integrations"
      ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 Tip: Use 'full' mode for detailed diff"
  echo "   ./scripts/context-diff.sh $CONTEXT1 $CONTEXT2 full"
  echo ""

  exit 0
fi

# ----------------------------------------
# Full diff mode
# ----------------------------------------

if [ "$MODE" = "full" ]; then
  echo -e "Comparing: ${CYAN}$CONTEXT1${NC} vs ${CYAN}$CONTEXT2${NC}"
  echo ""

  # Check if diff command exists
  if ! command -v diff &> /dev/null; then
    echo -e "${RED}Error: 'diff' command not found${NC}"
    echo "Please install diff utility or use 'summary' mode"
    exit 1
  fi

  echo "Full diff:"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Show diff with colors (if supported)
  if command -v colordiff &> /dev/null; then
    colordiff -u "$FILE1" "$FILE2" || true
  else
    diff -u "$FILE1" "$FILE2" || true
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Legend:"
  echo "  - lines: Present in $CONTEXT1, absent in $CONTEXT2"
  echo "  + lines: Present in $CONTEXT2, absent in $CONTEXT1"
  echo ""

  exit 0
fi

# ----------------------------------------
# Unknown mode
# ----------------------------------------

echo -e "${RED}Error: Unknown mode '$MODE'${NC}"
show_help
exit 1
