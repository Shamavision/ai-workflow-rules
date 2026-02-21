#!/bin/bash
# ==============================================================================
# SYNC RULES - Update AI tool rules from source context
# AI Workflow Rules Framework v9.1
# ==============================================================================
#
# Usage:
#   bash scripts/sync-rules.sh
#
# This script regenerates IDE-specific rule files from the selected context.
# Files regenerated: .cursorrules
# Files NOT touched: AGENTS.md (navigation hub), .claude/CLAUDE.md (custom wrapper)
#
# Use this after:
#   - Updating framework (npm update)
#   - Changing context in .ai/config.json
#   - Manual edits to context files
#
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔄 Syncing AI Rules${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==============================================================================
# READ CONFIG
# ==============================================================================

if [ ! -f ".ai/config.json" ]; then
    echo -e "${RED}❌ Error: .ai/config.json not found${NC}"
    echo "   Run installer first: npm install @shamavision/ai-workflow-rules"
    exit 1
fi

# Extract context from config
CONTEXT=$(grep -o '"context"[[:space:]]*:[[:space:]]*"[^"]*"' .ai/config.json | sed 's/.*"\([^"]*\)".*/\1/')

if [ -z "$CONTEXT" ]; then
    echo -e "${YELLOW}⚠️  Context not found in config, using 'standard'${NC}"
    CONTEXT="standard"
fi

echo -e "${CYAN}Context: $CONTEXT${NC}"
echo ""

SOURCE_RULES=".ai/contexts/$CONTEXT.context.md"

if [ ! -f "$SOURCE_RULES" ]; then
    echo -e "${RED}❌ Error: Source rules not found: $SOURCE_RULES${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Source: $SOURCE_RULES"
echo ""

# ==============================================================================
# DETECT EXISTING RULE FILES
# ==============================================================================

echo "Detecting AI tool rule files..."
echo ""

RULE_FILES=()

# Check for each tool's rule file
#
# NOTE (v9.1): AGENTS.md and .claude/CLAUDE.md are now custom files (not auto-generated)
# - AGENTS.md: Navigation hub with links to .ai/docs/ and .ai/rules/
# - .claude/CLAUDE.md: Custom wrapper for Claude Code with smart context loading
#
# These files are synchronized from IDE templates (.cursorrules, .windsurfrules, etc.)
[ -f ".cursorrules" ] && RULE_FILES+=(".cursorrules:Cursor")

if [ ${#RULE_FILES[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No rule files found${NC}"
    echo "   Run installer to create them"
    exit 0
fi

echo -e "${CYAN}Found ${#RULE_FILES[@]} file(s) to sync:${NC}"
for item in "${RULE_FILES[@]}"; do
    file="${item%%:*}"
    tool="${item##*:}"
    echo -e "  • $file ${BLUE}($tool)${NC}"
done
echo ""

# ==============================================================================
# SYNC FUNCTIONS
# ==============================================================================

# Function: Update generated file (without markers)
update_generated_file() {
    local file=$1
    local tool_name=$2

    echo -e "${CYAN}→${NC} Updating $file..."

    # Backup
    cp "$file" "$file.backup-$(date +%Y%m%d-%H%M%S)"

    # Regenerate
    cat > "$file" << EOF
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI WORKFLOW RULES FRAMEWORK v9.0
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Tool: $tool_name
# Context: $CONTEXT
# Auto-generated from: .ai/contexts/$CONTEXT.context.md
# Last synced: $(date '+%Y-%m-%d %H:%M:%S')
#
# To update rules: npm run sync-rules (or bash scripts/sync-rules.sh)
# Framework: https://github.com/Shamavision/ai-workflow-rules
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    cat "$SOURCE_RULES" >> "$file"

    cat >> "$file" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# END OF AUTO-GENERATED RULES
# Made in Ukraine 🇺🇦
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    echo -e "${GREEN}✓${NC} Updated $file"
}

# Function: Update file with markers (preserves user content)
update_marked_file() {
    local file=$1
    local tool_name=$2

    echo -e "${CYAN}→${NC} Updating $file (preserving user content)..."

    # Check if file has markers
    if ! grep -q "AI-WORKFLOW-RULES-START" "$file"; then
        echo -e "${YELLOW}  ⚠️  No markers found - skipping (manual file)${NC}"
        return
    fi

    # Backup
    cp "$file" "$file.backup-$(date +%Y%m%d-%H%M%S)"

    # Extract content between markers
    START_LINE=$(grep -n "AI-WORKFLOW-RULES-START" "$file" | cut -d: -f1)
    END_LINE=$(grep -n "AI-WORKFLOW-RULES-END" "$file" | cut -d: -f1)

    if [ -z "$START_LINE" ] || [ -z "$END_LINE" ]; then
        echo -e "${RED}  ✗ Markers incomplete - skipping${NC}"
        return
    fi

    # Keep content before markers
    head -n "$START_LINE" "$file" > "$file.tmp"

    # Regenerate our section
    cat >> "$file.tmp" << EOF

EOF

    cat "$SOURCE_RULES" >> "$file.tmp"

    cat >> "$file.tmp" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI-WORKFLOW-RULES-END v9.0.0
# Last synced: $(date '+%Y-%m-%d %H:%M:%S')
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    # Keep content after markers (if any)
    TAIL_START=$((END_LINE + 1))
    tail -n +$TAIL_START "$file" >> "$file.tmp"

    # Replace original
    mv "$file.tmp" "$file"

    echo -e "${GREEN}✓${NC} Updated $file (user content preserved)"
}

# ==============================================================================
# SYNC ALL FILES
# ==============================================================================

echo "Syncing files..."
echo ""

for item in "${RULE_FILES[@]}"; do
    file="${item%%:*}"
    tool="${item##*:}"

    # Check if file has markers (user's existing file) or is fully generated
    if grep -q "AI-WORKFLOW-RULES-START" "$file" 2>/dev/null; then
        # Has markers - preserve user content
        update_marked_file "$file" "$tool"
    else
        # Fully generated - replace entirely
        update_generated_file "$file" "$tool"
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Sync complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Updated ${#RULE_FILES[@]} file(s) from context: $CONTEXT"
echo ""
echo "Backups created with timestamp suffix"
echo "Next: Restart your AI assistant to load updated rules"
echo ""
