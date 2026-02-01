#!/bin/bash

# ========================================
# AI Workflow Rules - Automatic Setup
# ========================================
#
# This script automates the installation and configuration
# of AI Workflow Rules Framework in your project.
#
# Usage:
#   ./scripts/setup.sh
#
# ========================================

set -e  # Exit on error

echo ""
echo "🚀 AI Workflow Rules Framework - Setup"
echo "======================================"
echo ""

# ----------------------------------------
# Step 1: Install Git Hooks
# ----------------------------------------

echo "📦 Step 1/5: Installing Git hooks..."

if [ -f .git/hooks/pre-commit ]; then
    echo "⚠️  Pre-commit hook already exists. Backing up..."
    mv .git/hooks/pre-commit .git/hooks/pre-commit.backup
    echo "   Backup saved: .git/hooks/pre-commit.backup"
fi

# Copy pre-commit hook
if [ -f .git/hooks/pre-commit.sample ]; then
    cp .git/hooks/pre-commit.sample .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✅ Pre-commit hook installed"
else
    echo "⚠️  No pre-commit.sample found, skipping hook installation"
fi

# ----------------------------------------
# Step 2: Configure Token Limits
# ----------------------------------------

echo ""
echo "🤖 Step 2/5: Configure token limits..."

if [ -f .ai/token-limits.json ]; then
    echo "Current provider: $(grep -o '"provider": "[^"]*"' .ai/token-limits.json | cut -d'"' -f4)"
    echo "Current plan: $(grep -o '"plan": "[^"]*"' .ai/token-limits.json | cut -d'"' -f4)"
    echo ""

    read -p "Do you want to update provider/plan? (y/n): " UPDATE_CONFIG

    if [ "$UPDATE_CONFIG" = "y" ] || [ "$UPDATE_CONFIG" = "Y" ]; then
        echo ""
        echo "Select your AI provider:"
        echo "  1) Anthropic (Claude)"
        echo "  2) OpenAI (ChatGPT)"
        echo "  3) Google (Gemini)"
        echo "  4) Cursor"
        echo "  5) GitHub Copilot"
        echo "  6) Custom"
        read -p "Enter number (1-6): " PROVIDER_CHOICE

        case $PROVIDER_CHOICE in
            1) PROVIDER="anthropic" ;;
            2) PROVIDER="openai" ;;
            3) PROVIDER="google" ;;
            4) PROVIDER="cursor" ;;
            5) PROVIDER="github_copilot" ;;
            6) PROVIDER="custom" ;;
            *) echo "Invalid choice, keeping current"; PROVIDER="" ;;
        esac

        if [ -n "$PROVIDER" ]; then
            echo ""
            echo "Select your plan:"
            echo "  1) Free"
            echo "  2) Pro / Plus"
            echo "  3) Team / Business"
            read -p "Enter number (1-3): " PLAN_CHOICE

            case $PLAN_CHOICE in
                1) PLAN="free" ;;
                2) PLAN="pro" ;;
                3) PLAN="team" ;;
                *) echo "Invalid choice, keeping current"; PLAN="" ;;
            esac

            if [ -n "$PLAN" ]; then
                # Update token-limits.json
                sed -i.bak "s/\"provider\": \"[^\"]*\"/\"provider\": \"$PROVIDER\"/" .ai/token-limits.json
                sed -i.bak "s/\"plan\": \"[^\"]*\"/\"plan\": \"$PLAN\"/" .ai/token-limits.json
                rm .ai/token-limits.json.bak 2>/dev/null || true
                echo "✅ Updated to $PROVIDER ($PLAN)"
            fi
        fi
    else
        echo "✅ Keeping current configuration"
    fi
else
    echo "⚠️  .ai/token-limits.json not found, skipping configuration"
fi

# ----------------------------------------
# Step 3: Setup Environment File
# ----------------------------------------

echo ""
echo "🔐 Step 3/5: Setup environment variables..."

if [ -f .env ]; then
    echo "⚠️  .env file already exists, skipping creation"
    echo "   (To recreate, delete .env and run setup again)"
else
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env from template"
        echo "   ⚠️  Remember to fill in your API keys in .env file!"
    else
        echo "⚠️  .env.example not found, skipping .env creation"
    fi
fi

# ----------------------------------------
# Step 4: Verify Installation
# ----------------------------------------

echo ""
echo "🔍 Step 4/5: Verifying installation..."

ISSUES=0

# Check essential files
if [ -f RULES_CORE.md ]; then
    echo "✅ RULES_CORE.md"
else
    echo "❌ Missing RULES_CORE.md"
    ISSUES=$((ISSUES + 1))
fi

if [ -f .ai/token-limits.json ]; then
    echo "✅ .ai/token-limits.json"
else
    echo "❌ Missing .ai/token-limits.json"
    ISSUES=$((ISSUES + 1))
fi

if [ -f .ai/forbidden-trackers.json ]; then
    echo "✅ .ai/forbidden-trackers.json"
else
    echo "❌ Missing .ai/forbidden-trackers.json"
    ISSUES=$((ISSUES + 1))
fi

if [ -x .git/hooks/pre-commit ]; then
    echo "✅ Pre-commit hook (executable)"
else
    echo "⚠️  Pre-commit hook not executable or missing"
    ISSUES=$((ISSUES + 1))
fi

if [ -f scripts/seo-check.sh ]; then
    echo "✅ scripts/seo-check.sh"
else
    echo "⚠️  Missing scripts/seo-check.sh"
fi

# ----------------------------------------
# Step 5: Run Validation
# ----------------------------------------

echo ""
echo "🎯 Step 5/5: Running validation..."

if [ -f scripts/validate-setup.sh ]; then
    chmod +x scripts/validate-setup.sh
    ./scripts/validate-setup.sh
else
    echo "⚠️  scripts/validate-setup.sh not found, skipping validation"
fi

# ----------------------------------------
# Summary
# ----------------------------------------

echo ""
echo "======================================"
if [ $ISSUES -eq 0 ]; then
    echo "✅ Setup complete!"
else
    echo "⚠️  Setup complete with $ISSUES warning(s)"
    echo "   Check messages above for details"
fi
echo "======================================"
echo ""
echo "📚 Next steps:"
echo "   1. Edit .env file with your API keys"
echo "   2. Read QUICKSTART.md for quick start guide"
echo "   3. Read CHEATSHEET.md for one-page reference"
echo "   4. Run './scripts/seo-check.sh .' to verify your project"
echo ""
echo "🤖 For AI assistants:"
echo "   - Claude Code/Cursor: Rules loaded automatically"
echo "   - ChatGPT/Gemini: Copy START.md content into first message"
echo ""
echo "Happy coding! 🚀"
echo ""
