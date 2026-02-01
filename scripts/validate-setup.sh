#!/bin/bash

# ========================================
# AI Workflow Rules - Validation Script
# ========================================
#
# This script validates that AI Workflow Rules Framework
# is properly installed and configured.
#
# Usage:
#   ./scripts/validate-setup.sh
#
# ========================================

echo ""
echo "🔍 Validating AI Workflow Rules Setup..."
echo "========================================"
echo ""

ERRORS=0
WARNINGS=0

# ----------------------------------------
# Check Essential Files
# ----------------------------------------

echo "📁 Checking essential files..."

# RULES files
if [ -f RULES_CORE.md ]; then
    echo "✅ RULES_CORE.md found"
else
    echo "❌ RULES_CORE.md missing"
    ERRORS=$((ERRORS + 1))
fi

if [ -f RULES_PRODUCT.md ]; then
    echo "✅ RULES_PRODUCT.md found"
else
    echo "⚠️  RULES_PRODUCT.md missing (optional, but recommended for UA market)"
    WARNINGS=$((WARNINGS + 1))
fi

# Configuration files
if [ -f .ai/token-limits.json ]; then
    echo "✅ .ai/token-limits.json found"
else
    echo "❌ .ai/token-limits.json missing"
    ERRORS=$((ERRORS + 1))
fi

if [ -f .ai/forbidden-trackers.json ]; then
    echo "✅ .ai/forbidden-trackers.json found"
else
    echo "❌ .ai/forbidden-trackers.json missing"
    ERRORS=$((ERRORS + 1))
fi

if [ -f .ai/locale-context.json ]; then
    echo "✅ .ai/locale-context.json found"
else
    echo "⚠️  .ai/locale-context.json missing (optional)"
    WARNINGS=$((WARNINGS + 1))
fi

# ----------------------------------------
# Check Git Hooks
# ----------------------------------------

echo ""
echo "🪝 Checking Git hooks..."

if [ -f .git/hooks/pre-commit ]; then
    if [ -x .git/hooks/pre-commit ]; then
        echo "✅ Pre-commit hook installed and executable"
    else
        echo "⚠️  Pre-commit hook found but not executable"
        echo "   Fix: chmod +x .git/hooks/pre-commit"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  Pre-commit hook not installed"
    echo "   Run: cp .git/hooks/pre-commit.sample .git/hooks/pre-commit"
    WARNINGS=$((WARNINGS + 1))
fi

# ----------------------------------------
# Check Scripts
# ----------------------------------------

echo ""
echo "📜 Checking scripts..."

if [ -f scripts/seo-check.sh ]; then
    if [ -x scripts/seo-check.sh ]; then
        echo "✅ seo-check.sh found and executable"
    else
        echo "⚠️  seo-check.sh found but not executable"
        echo "   Fix: chmod +x scripts/seo-check.sh"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  seo-check.sh missing"
    WARNINGS=$((WARNINGS + 1))
fi

# ----------------------------------------
# Check Environment
# ----------------------------------------

echo ""
echo "🔐 Checking environment configuration..."

if [ -f .env ]; then
    echo "✅ .env file exists"

    # Check if .env has placeholder values
    if grep -q "your_.*_key_here" .env 2>/dev/null; then
        echo "⚠️  .env contains placeholder values - remember to update with real keys!"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  .env file missing"
    if [ -f .env.example ]; then
        echo "   Create from template: cp .env.example .env"
    fi
    WARNINGS=$((WARNINGS + 1))
fi

if [ -f .env.example ]; then
    echo "✅ .env.example template found"
else
    echo "⚠️  .env.example missing (optional)"
fi

# ----------------------------------------
# Check .gitignore
# ----------------------------------------

echo ""
echo "🙈 Checking .gitignore..."

if [ -f .gitignore ]; then
    if grep -q "^\.env$" .gitignore 2>/dev/null; then
        echo "✅ .env is in .gitignore (good!)"
    else
        echo "⚠️  .env is NOT in .gitignore - this is a security risk!"
        echo "   Add: echo '.env' >> .gitignore"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  .gitignore file missing"
    WARNINGS=$((WARNINGS + 1))
fi

# ----------------------------------------
# Test seo-check (if exists)
# ----------------------------------------

echo ""
echo "🧪 Testing seo-check.sh..."

if [ -x scripts/seo-check.sh ]; then
    # Run seo-check in quiet mode
    if ./scripts/seo-check.sh . > /dev/null 2>&1; then
        echo "✅ seo-check.sh runs successfully"
    else
        echo "⚠️  seo-check.sh found issues (this is normal for new projects)"
        echo "   Run './scripts/seo-check.sh .' to see details"
    fi
else
    echo "⚠️  Cannot test seo-check.sh (not found or not executable)"
fi

# ----------------------------------------
# Check Optional Files
# ----------------------------------------

echo ""
echo "📖 Checking optional files..."

OPTIONAL_FILES=(
    "QUICKSTART.md"
    "CHEATSHEET.md"
    "TOKEN_USAGE.md"
    "START.md"
    "INSTALL.md"
    "AI_COMPATIBILITY.md"
)

OPTIONAL_PRESENT=0
for FILE in "${OPTIONAL_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        OPTIONAL_PRESENT=$((OPTIONAL_PRESENT + 1))
    fi
done

echo "✅ $OPTIONAL_PRESENT/${#OPTIONAL_FILES[@]} optional guide files present"

# Check examples
if [ -d examples ]; then
    EXAMPLE_COUNT=$(find examples -type f -name "*.tsx" -o -name "*.ts" | wc -l)
    echo "✅ examples/ directory exists ($EXAMPLE_COUNT example files)"
else
    echo "⚠️  examples/ directory missing (optional)"
fi

# ----------------------------------------
# Summary
# ----------------------------------------

echo ""
echo "========================================"
echo "📊 Validation Summary"
echo "========================================"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed! Setup is complete."
    echo ""
    echo "🎯 You're ready to start using AI Workflow Rules!"
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Setup complete with $WARNINGS warning(s)"
    echo "   Everything works, but some optional features are missing."
    echo ""
    echo "🎯 You can start working, but consider fixing warnings above."
    EXIT_CODE=0
else
    echo "❌ Setup incomplete: $ERRORS error(s), $WARNINGS warning(s)"
    echo "   Please fix errors above before proceeding."
    echo ""
    echo "💡 Run './scripts/setup.sh' to auto-fix common issues."
    EXIT_CODE=1
fi

echo ""
echo "📚 Next steps:"
echo "   - Read QUICKSTART.md for 5-minute guide"
echo "   - Read CHEATSHEET.md for quick reference"
echo "   - Run './scripts/seo-check.sh .' to check your project"
echo ""

exit $EXIT_CODE
