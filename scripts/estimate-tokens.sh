#!/bin/bash
# Token Estimation Utility
# Estimates tokens from text using ~4 chars = 1 token rule (Claude tokenizer average)
# Version: 1.0 (v9.1 Phase 5)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to estimate tokens
estimate_tokens() {
    local chars=$1
    local tokens=$((chars / 4))
    echo $tokens
}

# Help message
show_help() {
    echo "Token Estimation Utility"
    echo ""
    echo "Usage:"
    echo "  bash scripts/estimate-tokens.sh <file>          # Estimate tokens in file"
    echo "  cat file.txt | bash scripts/estimate-tokens.sh  # Estimate from stdin"
    echo "  echo 'text' | bash scripts/estimate-tokens.sh   # Estimate from text"
    echo ""
    echo "Examples:"
    echo "  bash scripts/estimate-tokens.sh README.md"
    echo "  git diff | bash scripts/estimate-tokens.sh"
    echo "  pbpaste | bash scripts/estimate-tokens.sh       # macOS clipboard"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  -v, --verbose Show detailed breakdown"
    echo ""
}

# Parse options
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            FILE="$1"
            shift
            ;;
    esac
done

# Get character count
if [ -n "$FILE" ]; then
    # File provided
    if [ ! -f "$FILE" ]; then
        echo "❌ Error: File '$FILE' not found"
        exit 1
    fi
    CHARS=$(wc -m < "$FILE" | tr -d ' ')
    SOURCE="File: $FILE"
else
    # Read from stdin
    INPUT=$(cat)
    CHARS=$(echo -n "$INPUT" | wc -m | tr -d ' ')
    SOURCE="stdin"
fi

# Calculate tokens
TOKENS=$(estimate_tokens $CHARS)
WORDS=$(echo "$CHARS" | awk '{print int($1/5)}')  # Rough word estimate

# Output
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📊 TOKEN ESTIMATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$VERBOSE" = true ]; then
    echo -e "${YELLOW}Source:${NC} $SOURCE"
    echo ""
    echo -e "${YELLOW}Character count:${NC} $(printf "%'d" $CHARS) chars"
    echo -e "${YELLOW}Word estimate:${NC} ~$(printf "%'d" $WORDS) words"
    echo ""
    echo -e "${GREEN}Estimated tokens:${NC} ~$(printf "%'d" $TOKENS) tokens"
    echo ""
    echo -e "${CYAN}Method:${NC} ~4 chars = 1 token (Claude tokenizer average)"
    echo -e "${CYAN}Accuracy:${NC} ±20% (depends on language, code, etc.)"
else
    echo -e "  ${GREEN}Estimated tokens: ~$(printf "%'d" $TOKENS)${NC}"
    echo -e "  ${YELLOW}Characters: $(printf "%'d" $CHARS)${NC}"
fi

echo ""

# Context comparison
if [ $TOKENS -gt 200000 ]; then
    echo -e "${YELLOW}⚠️  This exceeds session limit (200k tokens)${NC}"
    echo -e "   Consider splitting into smaller chunks"
elif [ $TOKENS -gt 100000 ]; then
    echo -e "${YELLOW}⚠️  This is 50%+ of session limit (200k tokens)${NC}"
    echo -e "   May want to compress or split"
elif [ $TOKENS -gt 50000 ]; then
    echo -e "${CYAN}💡 This is ~25-50% of session limit${NC}"
    echo -e "   Reasonable for one session"
else
    echo -e "${GREEN}✅ This is <25% of session limit${NC}"
    echo -e "   Plenty of room in session"
fi

echo ""

# Additional info
if [ "$VERBOSE" = true ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Token Limits:${NC}"
    echo "  • Session: 200,000 tokens per conversation"
    echo "  • Daily: Varies by plan (check with npm run token-status)"
    echo ""
    echo -e "${CYAN}Tokenization varies by:${NC}"
    echo "  • Language (English ~4 chars/token, Ukrainian ~5-6)"
    echo "  • Content type (code ~3-4, prose ~4-5)"
    echo "  • Special characters (emojis, symbols)"
    echo ""
    echo -e "${CYAN}For more accurate count:${NC}"
    echo "  Use official tokenizer: https://platform.openai.com/tokenizer"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
fi

exit 0
