#!/bin/bash

# ========================================
# AI Workflow Rules - One-Line Installer
# ========================================
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
#
# Parity: identical wizard and file set as npx @shamavision/ai-workflow-rules
#
# ========================================

set -e  # Exit on error

REPO_URL="https://github.com/Shamavision/ai-workflow-rules.git"
TEMP_DIR=$(mktemp -d)
TARGET_DIR=$(pwd)
# KEY: Use npm-templates/ subdirectory as source of truth (not dev repo root)
TEMPLATES_DIR="$TEMP_DIR/npm-templates"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# ========================================
# Helper Functions
# ========================================

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  AI Workflow Rules - Installation Wizard  ║${NC}"
    echo -e "${BLUE}║           Made in Ukraine 🇺🇦              ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "\n${BLUE}▶ $1${NC}"; }
print_success() { echo -e "  ${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "  ${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }

# Copy file with "already exists" skip (matches cli.js behavior)
copy_file() {
    local src="$1"
    local dest="$2"
    local name
    name=$(basename "$dest")

    if [ -f "$dest" ]; then
        print_warning "$name already exists, skipping"
        return
    fi
    if [ ! -f "$src" ]; then
        print_warning "Source not found: $src"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    print_success "$name"
}

cleanup() {
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# ========================================
# Session config lookup
# Synced with presets.json — billing type + session_limit only
# daily_limit = null (not published by providers)
# ========================================

get_session_config() {
    local provider="$1"
    local plan="$2"
    case "$provider.$plan" in
        anthropic.api|google.api|mistral.api|deepseek.api)
            BILLING_TYPE="api"
            SESSION_LIMIT=200000 ;;
        google.free)
            BILLING_TYPE="subscription"
            SESSION_LIMIT=128000 ;;
        google.advanced)
            BILLING_TYPE="subscription"
            SESSION_LIMIT=128000 ;;
        cursor.free|cursor.pro|cursor.business)
            BILLING_TYPE="subscription"
            SESSION_LIMIT=200000 ;;
        *)
            BILLING_TYPE="subscription"
            SESSION_LIMIT=200000 ;;
    esac
}

# ========================================
# Pre-flight Checks
# ========================================

print_header

print_step "Running pre-flight checks..."

if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

if [ ! -d ".git" ]; then
    print_warning "Not a git repository. Initializing..."
    git init
    print_success "Git repository initialized"
fi

print_success "Pre-flight checks passed"

# ========================================
# Confirmation
# ========================================

echo ""
echo -e "${YELLOW}Installation directory:${NC} $TARGET_DIR"
echo ""
echo "This will install AI Workflow Rules Framework v9.1 in your project."
echo ""
read -rp "Continue? (y/n): " REPLY
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled"
    exit 0
fi

# ========================================
# Download Repository
# ========================================

print_step "Downloading AI Workflow Rules from GitHub..."

git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    print_error "Failed to download repository"
    exit 1
}

if [ ! -d "$TEMPLATES_DIR" ]; then
    print_error "npm-templates/ directory not found in repository"
    exit 1
fi

print_success "Repository downloaded"

# ========================================
# WIZARD — Question 1: Provider
# ========================================

echo ""
echo -e "${CYAN}━━━ AI Provider Setup ━━━${NC}"
echo ""
echo "What AI provider are you using?"
echo "  1) Claude (Anthropic)"
echo "  2) Gemini (Google)"
echo "  3) Cursor IDE"
echo "  4) Perplexity"
echo "  5) Mistral API"
echo "  6) DeepSeek API"
echo "  7) Groq"
echo "  8) Other / Custom"
echo ""
read -rp "Enter number (1-8): " PROVIDER_CHOICE

case $PROVIDER_CHOICE in
    1) PROVIDER="anthropic" ;;
    2) PROVIDER="google" ;;
    3) PROVIDER="cursor" ;;
    4) PROVIDER="perplexity" ;;
    5) PROVIDER="mistral" ;;
    6) PROVIDER="deepseek" ;;
    7) PROVIDER="groq" ;;
    *) PROVIDER="other" ;;
esac

# ========================================
# WIZARD — Question 2: Plan
# ========================================

echo ""
case $PROVIDER in
    anthropic)
        echo "Your Anthropic plan?"
        echo "  1) Free   2) Pro   3) Team   4) API"
        read -rp "Enter number (1-4): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="free" ;; 2) PLAN="pro" ;; 3) PLAN="team" ;; 4) PLAN="api" ;; *) PLAN="pro" ;;
        esac ;;
    google)
        echo "Your Google plan?"
        echo "  1) Free   2) Advanced   3) API"
        read -rp "Enter number (1-3): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="free" ;; 2) PLAN="advanced" ;; 3) PLAN="api" ;; *) PLAN="advanced" ;;
        esac ;;
    cursor)
        echo "Your Cursor plan?"
        echo "  1) Free   2) Pro   3) Business"
        read -rp "Enter number (1-3): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="free" ;; 2) PLAN="pro" ;; 3) PLAN="business" ;; *) PLAN="pro" ;;
        esac ;;
    perplexity)
        echo "Your Perplexity plan?"
        echo "  1) Free   2) Pro"
        read -rp "Enter number (1-2): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="free" ;; 2) PLAN="pro" ;; *) PLAN="pro" ;;
        esac ;;
    mistral|deepseek)
        PLAN="api" ;;
    groq)
        PLAN="free" ;;
    *)
        PLAN="default" ;;
esac

# ========================================
# WIZARD — Question 3: Market
# ========================================

echo ""
echo -e "${CYAN}━━━ Context Preset ━━━${NC}"
echo ""
echo "Which context preset?"
echo "  1) minimal           — AI workflow essentials (skills + token monitoring)"
echo "  2) minimal + ukraine — Full Ukrainian market compliance"
echo ""
read -rp "Enter number (1-2): " MARKET_CHOICE

if [ "$MARKET_CHOICE" = "2" ]; then
    CONTEXT="ukraine"
    INSTALL_PRODUCT="yes"
    MARKET_VALUE="ukraine"
else
    CONTEXT="minimal"
    INSTALL_PRODUCT="no"
    MARKET_VALUE="international"
fi

echo ""
echo -e "${GREEN}✓ Context: $CONTEXT${NC}"
echo ""

# All other settings are automatic
INSTALL_HOOKS="yes"
UPDATE_GITIGNORE="yes"

# ========================================
# Install Files
# ========================================

echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 Installing files...${NC}"
echo ""

# Copy all static files from MANIFEST (single source of truth for both installers)
while IFS='|' read -r src dest chmod_flag; do
    copy_file "$TEMPLATES_DIR/$src" "$TARGET_DIR/$dest"
    [ "$chmod_flag" = "1" ] && chmod +x "$TARGET_DIR/$dest" 2>/dev/null || true
done < <(node -e "
const fs = require('fs');
const m = JSON.parse(fs.readFileSync('$TEMPLATES_DIR/MANIFEST.json', 'utf8'));
m.files
  .filter(f => f.group === 'core' || ('$INSTALL_PRODUCT' === 'yes' && f.group === 'ukraine'))
  .forEach(f => process.stdout.write(f.src + '|' + f.dest + '|' + (f.chmod ? '1' : '0') + '\n'));
")

# ========================================
# Generate .ai/token-limits.json
# ========================================

get_session_config "$PROVIDER" "$PLAN"
TODAY_DATE=$(date -u +"%Y-%m-%d")

TOKEN_LIMITS_PATH="$TARGET_DIR/.ai/token-limits.json"

if [ -f "$TOKEN_LIMITS_PATH" ]; then
    print_warning ".ai/token-limits.json already exists, skipping"
else
    cat > "$TOKEN_LIMITS_PATH" << EOF
{
  "_comment": "AI Token Tracker v4.0 — session-based. New day = fresh limits.",
  "tool": "$PROVIDER",
  "plan": "$PLAN",
  "billing": "$BILLING_TYPE",
  "session_limit": $SESSION_LIMIT,
  "daily_limit": null,
  "daily_note": "Daily limit not published by provider — track via session count",
  "today": "$TODAY_DATE",
  "today_sessions": 0,
  "today_estimated_tokens": 0,
  "sessions": []
}
EOF
    print_success ".ai/token-limits.json ($PROVIDER $PLAN: session ${SESSION_LIMIT}, $BILLING_TYPE)"
fi

# ========================================
# Generate .ai/config.json
# ========================================

CONFIG_PATH="$TARGET_DIR/.ai/config.json"

if [ -f "$CONFIG_PATH" ]; then
    print_warning ".ai/config.json already exists, skipping"
else
    cat > "$CONFIG_PATH" << EOF
{
  "framework": "ai-workflow-rules",
  "version": "9.1.1",
  "config_version": "2.2",
  "access_type": "$BILLING_TYPE",
  "model": {
    "name": "claude-sonnet-4-6",
    "context_limit": $SESSION_LIMIT
  },
  "context": "$CONTEXT",
  "modules": [],
  "market": "$MARKET_VALUE",
  "language": {
    "internal_dialogue": "adaptive",
    "code_comments": "en",
    "commit_messages": "en",
    "variable_names": "en"
  },
  "optimizations": {
    "auto_compress": true,
    "post_push_compress": true,
    "lazy_loading": true,
    "diff_only_mode": true
  },
  "workflow": {
    "roadmap_required": true,
    "stage_based_commits": true,
    "discuss_before_execute": true
  },
  "security": {
    "check_forbidden_trackers": true,
    "no_hardcoded_secrets": true,
    "api_key_protection": true
  },
  "detection": {
    "auto_detect_market": true,
    "smart_preset_suggestion": true
  }
}
EOF
    print_success ".ai/config.json (context: $CONTEXT, market: $MARKET_VALUE, access_type: $BILLING_TYPE)"
fi

# ========================================
# Install pre-commit hook (automatic)
# ========================================

if [ -d "$TARGET_DIR/.git" ]; then
    if [ -f "$TARGET_DIR/.git/hooks/pre-commit" ]; then
        print_warning "Pre-commit hook already exists, backing up..."
        mv "$TARGET_DIR/.git/hooks/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit.backup"
    fi
    cp "$TARGET_DIR/scripts/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit"
    chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
    print_success "Pre-commit hook installed"
fi

# ========================================
# Install post-push hook (automatic — session memory anchor)
# ========================================

if [ -d "$TARGET_DIR/.git" ] && [ -f "$TARGET_DIR/scripts/post-push.sh" ]; then
    cp "$TARGET_DIR/scripts/post-push.sh" "$TARGET_DIR/.git/hooks/post-push"
    chmod +x "$TARGET_DIR/.git/hooks/post-push"
    print_success "Post-push hook installed (session memory anchor)"
fi

# ========================================
# Update .gitignore (automatic, append-only)
# ========================================

GITIGNORE_PATH="$TARGET_DIR/.gitignore"
[ -f "$GITIGNORE_PATH" ] || touch "$GITIGNORE_PATH"

if grep -qF "# AI Workflow Rules" "$GITIGNORE_PATH" 2>/dev/null; then
    print_warning ".gitignore already contains AI rules, skipping"
else
    printf '\n# AI Workflow Rules\n.ai/.session-started\n.ai/checkpoint-*.md\nai-logs/\n' \
        >> "$GITIGNORE_PATH"
    print_success ".gitignore updated"
fi

# ========================================
# Generate rules for AI tools
# ========================================

print_step "Generating rules for AI tools..."

SOURCE_RULES="$TARGET_DIR/.ai/contexts/$CONTEXT.context.md"

# generate_rules_file <relative_path> <tool_name> [frontmatter=yes|no]
generate_rules_file() {
    local target_file="$TARGET_DIR/$1"
    local tool_name="$2"
    local add_frontmatter="${3:-no}"

    if [ -f "$target_file" ]; then
        print_warning "$1 already exists, skipping"
        return
    fi

    mkdir -p "$(dirname "$target_file")"
    {
        if [ "$add_frontmatter" = "yes" ]; then
            cat << 'FRONTMATTER'
---
description: AI Workflow Rules — session protocol, token management, security guards
globs: ["**/*"]
alwaysApply: true
---

FRONTMATTER
        fi
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "# AI WORKFLOW RULES FRAMEWORK v9.1"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "#"
        echo "# Tool: $tool_name"
        echo "# Context: $CONTEXT"
        echo "# Auto-generated from: .ai/contexts/$CONTEXT.context.md"
        echo "#"
        echo "# To update rules: bash scripts/sync-rules.sh"
        echo "# Framework: https://github.com/Shamavision/ai-workflow-rules"
        echo "#"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        cat "$SOURCE_RULES"
        echo ""
        echo ""
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "# END OF AUTO-GENERATED RULES"
        echo "# Made in Ukraine 🇺🇦"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    } > "$target_file"

    print_success "$1 created"
}

generate_rules_file ".cursorrules"                    "Cursor (legacy <0.45)"
generate_rules_file ".cursor/rules/ai-workflow.mdc"  "Cursor (new ≥0.45)" "yes"

# ========================================
# Verification
# ========================================

print_step "Verifying installation..."

ISSUES=0

check_file() {
    if [ -f "$TARGET_DIR/$1" ]; then
        print_success "$1"
    else
        print_warning "Missing: $1"
        ISSUES=$((ISSUES + 1))
    fi
}

check_file "AGENTS.md"
check_file "PROJECT_IDEOLOGY.md"
check_file ".claude/CLAUDE.md"
check_file ".claude/settings.json"
check_file ".claude/hooks/user-prompt-submit.sh"
check_file ".claude/commands/ctx.md"
check_file ".claude/commands/sculptor.md"
check_file ".claude/commands/arbiter.md"
check_file ".ai/AI-ENFORCEMENT.md"
check_file ".ai/presets.json"
check_file ".ai/config.json"
check_file ".ai/token-limits.json"
check_file ".ai/ai-protection-policy.json"
check_file ".ai/forbidden-trackers.json"
check_file ".ai/rules/core.md"
check_file ".ai/contexts/$CONTEXT.context.md"
check_file "scripts/pre-commit"
check_file "scripts/sync-rules.sh"
check_file "scripts/post-push.sh"
check_file ".cursorrules"
check_file ".cursor/rules/ai-workflow.mdc"

if [ -x "$TARGET_DIR/.git/hooks/pre-commit" ]; then
    print_success ".git/hooks/pre-commit (executable)"
fi
if [ -x "$TARGET_DIR/.git/hooks/post-push" ]; then
    print_success ".git/hooks/post-push (executable)"
fi

# ========================================
# Success Message
# ========================================

echo ""
echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}🎉 Setup complete!${NC}"
else
    echo -e "${YELLOW}⚠ Setup complete with $ISSUES warning(s)${NC}"
fi

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Open a NEW conversation in your AI assistant"
echo -e "  2. Type ${CYAN}//START${NC} in the chat"
echo "  3. AI will load rules and start working"
echo -e "  4. Fill in ${CYAN}PROJECT_IDEOLOGY.md${NC} — WHY / PRINCIPLES / VISION"
echo -e "  5. Run ${CYAN}/ctx${NC} to auto-generate your project's context + ideology map"
echo ""
echo -e "${BLUE}🛡️  AI Protection v9.1 enabled:${NC}"
echo "  ✓ Prompt injection detection"
echo "  ✓ PII protection (GDPR-ready)"
echo "  ✓ Auto-runs in pre-commit hook"
echo ""
echo "Need help? https://github.com/Shamavision/ai-workflow-rules/issues"
echo ""
echo -e "${BLUE}Made with ❤️  in Ukraine 🇺🇦${NC}"
echo ""
