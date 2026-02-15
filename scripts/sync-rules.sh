#!/bin/bash
# ==============================================================================
# SYNC RULES - Simplified Version v2.0
# AI Workflow Rules Framework v9.1.1
# ==============================================================================
#
# Philosophy: IDE configs are STATIC TEMPLATES (context-agnostic)
#             Context is DYNAMIC CONFIGURATION (.ai/config.json)
#
# What this script does:
#   1. If IDE config missing → copy from npm-templates
#   2. If IDE config exists → update version header only (preserve content!)
#   3. NEVER copy full context into IDE configs (breaks modularity!)
#
# Usage:
#   bash scripts/sync-rules.sh
#
# When to run:
#   - After npm install (first time setup)
#   - After framework update (to update version number)
#   - NOT needed when changing context (just edit .ai/config.json)
#
# ==============================================================================

# Note: NOT using 'set -e' because we handle return codes explicitly

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

FRAMEWORK_VERSION="9.1.1"
TEMPLATE_DIR="npm-templates"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔄 Syncing AI Rules (Simplified v2.0)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==============================================================================
# VALIDATE ENVIRONMENT
# ==============================================================================

if [ ! -f ".ai/config.json" ]; then
    echo -e "${RED}❌ Error: .ai/config.json not found${NC}"
    echo "   Run installer first: npm install @shamavision/ai-workflow-rules"
    exit 1
fi

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "${RED}❌ Error: $TEMPLATE_DIR directory not found${NC}"
    echo "   This script must be run from project root"
    exit 1
fi

# Extract context from config (for display only, not used for generation!)
CONTEXT=$(grep -o '"context"[[:space:]]*:[[:space:]]*"[^"]*"' .ai/config.json | sed 's/.*"\([^"]*\)".*/\1/')

if [ -z "$CONTEXT" ]; then
    CONTEXT="standard"
fi

echo -e "${CYAN}Current context: $CONTEXT${NC}"
echo -e "${CYAN}Framework version: $FRAMEWORK_VERSION${NC}"
echo ""

# ==============================================================================
# SYNC FUNCTIONS
# ==============================================================================

# Function: Ensure IDE config exists (copy from template if missing)
# Returns: 0 = created new, 1 = updated existing, 2 = error
ensure_ide_config() {
    local file=$1
    local tool_name=$2
    local template="$TEMPLATE_DIR/$file"

    if [ ! -f "$template" ]; then
        echo -e "${YELLOW}⚠️  Template not found: $template${NC}"
        return 2
    fi

    if [ ! -f "$file" ]; then
        # File missing - copy from template
        echo -e "${CYAN}→${NC} Creating $file from template..."
        cp "$template" "$file"
        echo -e "${GREEN}✓${NC} Created $file (${tool_name})"
        return 0
    fi

    # File exists - update header only
    echo -e "${CYAN}→${NC} Updating $file header..."

    # Backup
    cp "$file" "$file.backup-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true

    # Update version (line 2) and timestamp (line 5)
    # Using platform-agnostic sed approach

    # Create temp file with updated header
    {
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "# AI WORKFLOW RULES FRAMEWORK v$FRAMEWORK_VERSION"
        echo "# Tool: $tool_name"
        echo "# Auto-generated - DO NOT EDIT MANUALLY"
        echo "# Update via: npm run sync-rules (or bash scripts/sync-rules.sh)"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        tail -n +7 "$file"  # Keep everything after line 6
    } > "$file.tmp"

    # Replace original
    mv "$file.tmp" "$file"

    echo -e "${GREEN}✓${NC} Updated $file (content preserved, header updated)"
    return 1
}

# ==============================================================================
# DETECT AND SYNC IDE CONFIGS
# ==============================================================================

echo "Detecting IDE config files..."
echo ""

SYNCED_COUNT=0
CREATED_COUNT=0
FAILED_COUNT=0

# Cursor IDE
ensure_ide_config ".cursorrules" "Cursor IDE"
RESULT=$?
case $RESULT in
    0) ((CREATED_COUNT++)) ;;
    1) ((SYNCED_COUNT++)) ;;
    2) ((FAILED_COUNT++)) ;;
esac
echo ""

# Windsurf IDE
ensure_ide_config ".windsurfrules" "Windsurf IDE"
RESULT=$?
case $RESULT in
    0) ((CREATED_COUNT++)) ;;
    1) ((SYNCED_COUNT++)) ;;
    2) ((FAILED_COUNT++)) ;;
esac
echo ""

# Continue.dev (optional)
if [ -f "$TEMPLATE_DIR/.continuerules" ]; then
    ensure_ide_config ".continuerules" "Continue.dev"
    RESULT=$?
    case $RESULT in
        0) ((CREATED_COUNT++)) ;;
        1) ((SYNCED_COUNT++)) ;;
        2) ((FAILED_COUNT++)) ;;
    esac
    echo ""
fi

# ==============================================================================
# SUMMARY
# ==============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Sync complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $CREATED_COUNT -gt 0 ]; then
    echo -e "${GREEN}Created:${NC} $CREATED_COUNT file(s) from templates"
fi

if [ $SYNCED_COUNT -gt 0 ]; then
    echo -e "${CYAN}Updated:${NC} $SYNCED_COUNT file(s) (header only, content preserved)"
fi

if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}Skipped:${NC} $FAILED_COUNT file(s) (templates missing)"
fi

echo ""
echo -e "${CYAN}💡 How it works:${NC}"
echo "   • IDE configs are STATIC templates (context-agnostic)"
echo "   • To change context: Edit .ai/config.json"
echo "   • AI will load the appropriate context automatically"
echo "   • No need to re-run sync-rules after context change!"
echo ""
echo -e "${CYAN}📖 Context system:${NC}"
echo "   • minimal: ~10k tokens (startups, MVP)"
echo "   • standard: ~14k tokens (standard projects)"
echo "   • ukraine-full: ~18k tokens (Ukrainian market + full features)"
echo "   • enterprise: ~23k tokens (compliance + advanced)"
echo ""

if [ $SYNCED_COUNT -gt 0 ]; then
    echo "Backups created with timestamp suffix (.backup-YYYYMMDD-HHMMSS)"
    echo ""
fi

echo "Next: Restart your AI assistant to ensure updated rules are loaded"
echo ""
