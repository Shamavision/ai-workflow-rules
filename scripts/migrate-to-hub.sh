#!/bin/bash
# Migration script for existing AI Workflow Rules users
# Version: 9.1 Hub Restructure
# Purpose: Migrate from v9.0 structure to v9.1 .ai/ hub

set -e

echo "🔄 Migrating to .ai/ hub structure (v9.1)..."
echo ""

# Create new directories
echo "Creating directory structure..."
mkdir -p .ai/docs
mkdir -p .ai/rules
echo "  ✓ .ai/docs/ created"
echo "  ✓ .ai/rules/ created"
echo ""

# Track moved files
MOVED_COUNT=0

# Move documentation files
echo "Moving documentation files..."
[ -f "QUICKSTART.md" ] && mv QUICKSTART.md .ai/docs/quickstart.md && echo "  ✓ QUICKSTART.md → .ai/docs/quickstart.md" && ((MOVED_COUNT++))
[ -f "CHEATSHEET.md" ] && mv CHEATSHEET.md .ai/docs/cheatsheet.md && echo "  ✓ CHEATSHEET.md → .ai/docs/cheatsheet.md" && ((MOVED_COUNT++))
[ -f "TOKEN_USAGE.md" ] && mv TOKEN_USAGE.md .ai/docs/token-usage.md && echo "  ✓ TOKEN_USAGE.md → .ai/docs/token-usage.md" && ((MOVED_COUNT++))
[ -f "AI_COMPATIBILITY.md" ] && mv AI_COMPATIBILITY.md .ai/docs/compatibility.md && echo "  ✓ AI_COMPATIBILITY.md → .ai/docs/compatibility.md" && ((MOVED_COUNT++))
[ -f "START.md" ] && mv START.md .ai/docs/start.md && echo "  ✓ START.md → .ai/docs/start.md" && ((MOVED_COUNT++))
[ -f ".ai/SESSION_MANAGEMENT.md" ] && mv .ai/SESSION_MANAGEMENT.md .ai/docs/session-mgmt.md && echo "  ✓ SESSION_MANAGEMENT.md → .ai/docs/session-mgmt.md" && ((MOVED_COUNT++))
echo ""

# Move rules files
echo "Moving rules files..."
[ -f "RULES_CORE.md" ] && mv RULES_CORE.md .ai/rules/core.md && echo "  ✓ RULES_CORE.md → .ai/rules/core.md" && ((MOVED_COUNT++))
[ -f "RULES_PRODUCT.md" ] && mv RULES_PRODUCT.md .ai/rules/product.md && echo "  ✓ RULES_PRODUCT.md → .ai/rules/product.md" && ((MOVED_COUNT++))
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Migration complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Summary:"
echo "  • Files moved: $MOVED_COUNT"
echo "  • Documentation: .ai/docs/"
echo "  • Rules: .ai/rules/"
echo ""
echo "Next steps:"
echo "  1. Update AGENTS.md (download latest from npm)"
echo "  2. Run: npm run sync-rules"
echo "  3. Restart AI session"
echo ""
echo "Rollback (if needed):"
echo "  # Files are moved, not deleted - check git status"
echo "  git checkout -- ."
echo ""
echo "Made in Ukraine 🇺🇦"
