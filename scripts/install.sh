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
# Token presets lookup
# Synced with TOKEN_PRESETS in bin/cli.js (v9.1.1 VARIANT B)
# ========================================

get_token_limits() {
    local provider="$1"
    local plan="$2"
    case "$provider.$plan" in
        anthropic.free)              TOKEN_DAILY=20000;      TOKEN_MONTHLY=200000    ;;
        anthropic.pro)               TOKEN_DAILY=500000;     TOKEN_MONTHLY=5000000   ;;
        anthropic.team)              TOKEN_DAILY=800000;     TOKEN_MONTHLY=8000000   ;;
        anthropic.api)               TOKEN_DAILY=999999999;  TOKEN_MONTHLY=999999999 ;;
        google.free)                 TOKEN_DAILY=5000;       TOKEN_MONTHLY=100000    ;;
        google.advanced)             TOKEN_DAILY=80000;      TOKEN_MONTHLY=1500000   ;;
        google.api)                  TOKEN_DAILY=999999999;  TOKEN_MONTHLY=999999999 ;;
        cursor.free)                 TOKEN_DAILY=20000;      TOKEN_MONTHLY=400000    ;;
        cursor.pro)                  TOKEN_DAILY=80000;      TOKEN_MONTHLY=1500000   ;;
        cursor.business)             TOKEN_DAILY=120000;     TOKEN_MONTHLY=2500000   ;;
        windsurf.free)               TOKEN_DAILY=10000;      TOKEN_MONTHLY=200000    ;;
        windsurf.enterprise)         TOKEN_DAILY=50000;      TOKEN_MONTHLY=1000000   ;;
        github_copilot.individual)   TOKEN_DAILY=25000;      TOKEN_MONTHLY=500000    ;;
        github_copilot.business)     TOKEN_DAILY=100000;     TOKEN_MONTHLY=2000000   ;;
        github_copilot.enterprise)   TOKEN_DAILY=200000;     TOKEN_MONTHLY=5000000   ;;
        perplexity.free)             TOKEN_DAILY=10000;      TOKEN_MONTHLY=200000    ;;
        perplexity.pro)              TOKEN_DAILY=20000;      TOKEN_MONTHLY=400000    ;;
        mistral.api)                 TOKEN_DAILY=999999999;  TOKEN_MONTHLY=999999999 ;;
        deepseek.api)                TOKEN_DAILY=999999999;  TOKEN_MONTHLY=999999999 ;;
        groq.free)                   TOKEN_DAILY=5000;       TOKEN_MONTHLY=100000    ;;
        *)                           TOKEN_DAILY=20000;      TOKEN_MONTHLY=500000    ;;
    esac
}

# Returns MODEL_1, MODEL_2, or MODEL_3
get_arch_model() {
    local provider="$1"
    local plan="$2"
    case "$provider.$plan" in
        anthropic.api|google.api|mistral.api|deepseek.api)
            echo "MODEL_1" ;;
        github_copilot.individual|github_copilot.business|github_copilot.enterprise)
            echo "MODEL_2" ;;
        *)
            echo "MODEL_3" ;;
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
# WIZARD - Provider Selection
# ========================================

echo ""
echo -e "${CYAN}━━━ AI Provider Setup ━━━${NC}"
echo ""
echo "What AI provider are you using?"
echo "  1) Claude (Anthropic)"
echo "  2) Gemini (Google)"
echo "  3) Cursor IDE"
echo "  4) Windsurf IDE"
echo "  5) GitHub Copilot"
echo "  6) Perplexity"
echo "  7) Mistral API"
echo "  8) DeepSeek API"
echo "  9) Groq"
echo " 10) Other / Custom"
echo ""
read -rp "Enter number (1-10): " PROVIDER_CHOICE

case $PROVIDER_CHOICE in
    1) PROVIDER="anthropic" ;;
    2) PROVIDER="google" ;;
    3) PROVIDER="cursor" ;;
    4) PROVIDER="windsurf" ;;
    5) PROVIDER="github_copilot" ;;
    6) PROVIDER="perplexity" ;;
    7) PROVIDER="mistral" ;;
    8) PROVIDER="deepseek" ;;
    9) PROVIDER="groq" ;;
    *) PROVIDER="other" ;;
esac

# Provider-specific plan selection (matches cli.js PLANS)
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
    windsurf)
        echo "Your Windsurf plan?"
        echo "  1) Free   2) Enterprise"
        read -rp "Enter number (1-2): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="free" ;; 2) PLAN="enterprise" ;; *) PLAN="free" ;;
        esac ;;
    github_copilot)
        echo "Your GitHub Copilot plan?"
        echo "  1) Individual   2) Business   3) Enterprise"
        read -rp "Enter number (1-3): " PLAN_CHOICE
        case $PLAN_CHOICE in
            1) PLAN="individual" ;; 2) PLAN="business" ;; 3) PLAN="enterprise" ;; *) PLAN="individual" ;;
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

# Install git hooks?
echo ""
read -rp "Install security pre-commit hooks? (Y/n): " HOOKS_REPLY
[[ "$HOOKS_REPLY" =~ ^[Nn]$ ]] && INSTALL_HOOKS="no" || INSTALL_HOOKS="yes"

# Update .gitignore?
read -rp "Add AI files to .gitignore? (Y/n): " GITIGNORE_REPLY
[[ "$GITIGNORE_REPLY" =~ ^[Nn]$ ]] && UPDATE_GITIGNORE="no" || UPDATE_GITIGNORE="yes"

# Install product rules?
read -rp "Install product rules? (Ukrainian market specifics) (y/N): " PRODUCT_REPLY
[[ "$PRODUCT_REPLY" =~ ^[Yy]$ ]] && INSTALL_PRODUCT="yes" || INSTALL_PRODUCT="no"

# ========================================
# WIZARD - Context Selection
# ========================================

echo ""
echo -e "${CYAN}━━━ Context Selection Wizard ━━━${NC}"
echo ""
echo "1. How many team members?"
echo "   1) 1-2 (solo/small)   2) 3-5 (team)   3) 6+ (large)"
echo ""
read -rp "Enter number (1-3): " TEAM_SIZE

echo ""
echo "2. Primary market?"
echo "   1) Ukrainian market (compliance, language rules)"
echo "   2) International (English-focused)"
echo ""
read -rp "Enter number (1-2): " MARKET_CHOICE

echo ""
echo "3. How cautious should AI be with tokens?"
echo "   1) Careful (warns early)   2) Balanced (standard)   3) Relaxed (minimal interruptions)"
echo ""
read -rp "Enter number (1-3): " TOKEN_PRIORITY

# Recommendation logic (mirrors cli.js selectContextWithRecommendation)
if [ "$MARKET_CHOICE" = "1" ]; then
    RECOMMENDED="ukraine-full"
    REASON="Ukrainian market needs full compliance features"
    MARKET_VALUE="ukraine"
elif [ "$TOKEN_PRIORITY" = "1" ]; then
    RECOMMENDED="minimal"
    REASON="Token efficiency prioritized"
    MARKET_VALUE="international"
elif [ "$TEAM_SIZE" = "3" ] || [ "$TOKEN_PRIORITY" = "3" ]; then
    RECOMMENDED="enterprise"
    REASON="Large team / full features prioritized"
    MARKET_VALUE="international"
else
    RECOMMENDED="standard"
    REASON="Balanced approach for most projects"
    MARKET_VALUE="international"
fi

# Show comparison table
echo ""
echo -e "${CYAN}📊 Context Comparison${NC}"
echo ""
echo "┌─────────────────┬────────────┬─────────────┬──────────────────────┐"
echo "│ Context         │ Tokens     │ Session %   │ Best For             │"
echo "├─────────────────┼────────────┼─────────────┼──────────────────────┤"
echo "│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │"
echo "│ Standard        │ ~14k       │ 7%          │ Most projects        │"
echo "│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │"
echo "│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │"
echo "└─────────────────┴────────────┴─────────────┴──────────────────────┘"
echo -e "  ${GRAY}Session % = tokens used of 200K session limit (MODEL_3 primary metric)${NC}"
echo ""
echo -e "${GREEN}✅ Recommended: $RECOMMENDED${NC}"
echo -e "${GRAY}   Reasoning: $REASON${NC}"
echo ""
read -rp "Use $RECOMMENDED context? (Y/n): " CONTEXT_REPLY

if [[ "$CONTEXT_REPLY" =~ ^[Nn]$ ]]; then
    echo ""
    echo "Choose context manually:"
    echo "  1) Minimal (~10k)   2) Standard (~14k)   3) Ukraine-Full (~18k)   4) Enterprise (~23k)"
    echo ""
    read -rp "Enter number (1-4): " MANUAL_CTX
    case $MANUAL_CTX in
        1) CONTEXT="minimal" ;;
        2) CONTEXT="standard" ;;
        3) CONTEXT="ukraine-full" ;;
        4) CONTEXT="enterprise" ;;
        *) CONTEXT="$RECOMMENDED" ;;
    esac
else
    CONTEXT="$RECOMMENDED"
fi

# ========================================
# Install Files
# ========================================

echo ""
echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 Installing files...${NC}"
echo ""

# AGENTS.md + LICENSE
copy_file "$TEMPLATES_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
copy_file "$TEMPLATES_DIR/LICENSE" "$TARGET_DIR/LICENSE"

# .claude/ - CLAUDE.md, settings.json, hooks
mkdir -p "$TARGET_DIR/.claude/hooks"
copy_file "$TEMPLATES_DIR/.claude/CLAUDE.md"   "$TARGET_DIR/.claude/CLAUDE.md"
copy_file "$TEMPLATES_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"
copy_file "$TEMPLATES_DIR/.claude/hooks/user-prompt-submit.sh" \
          "$TARGET_DIR/.claude/hooks/user-prompt-submit.sh"
chmod +x "$TARGET_DIR/.claude/hooks/user-prompt-submit.sh" 2>/dev/null || true

# .ai/ directory structure
mkdir -p "$TARGET_DIR/.ai/docs" "$TARGET_DIR/.ai/rules" "$TARGET_DIR/.ai/contexts"

# AI-ENFORCEMENT.md
copy_file "$TEMPLATES_DIR/.ai/AI-ENFORCEMENT.md" "$TARGET_DIR/.ai/AI-ENFORCEMENT.md"

# Documentation files
for doc in quickstart.md cheatsheet.md token-usage.md compatibility.md \
           start.md session-mgmt.md code-quality.md provider-comparison.md; do
    copy_file "$TEMPLATES_DIR/.ai/docs/$doc" "$TARGET_DIR/.ai/docs/$doc"
done

# Rules
copy_file "$TEMPLATES_DIR/.ai/rules/core.md" "$TARGET_DIR/.ai/rules/core.md"
if [ "$INSTALL_PRODUCT" = "yes" ]; then
    copy_file "$TEMPLATES_DIR/.ai/rules/product.md" "$TARGET_DIR/.ai/rules/product.md"
fi

# Forbidden trackers
copy_file "$TEMPLATES_DIR/.ai/forbidden-trackers.json" "$TARGET_DIR/.ai/forbidden-trackers.json"

# All 4 context files
for ctx in minimal standard ukraine-full enterprise; do
    copy_file "$TEMPLATES_DIR/.ai/contexts/$ctx.context.md" \
              "$TARGET_DIR/.ai/contexts/$ctx.context.md"
done

# ========================================
# Generate .ai/token-limits.json
# ========================================

get_token_limits "$PROVIDER" "$PLAN"
ARCH_MODEL=$(get_arch_model "$PROVIDER" "$PLAN")
TODAY=$(date -u +"%Y-%m-%dT00:00:00Z")
THIS_MONTH=$(date -u +"%Y-%m")
MONTH_START="${THIS_MONTH}-01T00:00:00Z"
IS_MODEL3=0
[ "$ARCH_MODEL" = "MODEL_3" ] && IS_MODEL3=1

TOKEN_LIMITS_PATH="$TARGET_DIR/.ai/token-limits.json"

if [ -f "$TOKEN_LIMITS_PATH" ]; then
    print_warning ".ai/token-limits.json already exists, skipping"
else
    # Build MODEL_3 extra fields if applicable
    MODEL3_FIELDS=""
    if [ "$IS_MODEL3" = "1" ]; then
        MODEL3_FIELDS=",
  \"daily_limit_type\": \"fair_use_dynamic\",
  \"daily_limit_note\": \"ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3 - Fair Use Dynamic).\",
  \"monthly_limit_note\": \"ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3 - Fair Use Dynamic).\",
  \"session_limit\": 200000,
  \"session_duration_hours\": 5"
    fi

    cat > "$TOKEN_LIMITS_PATH" << EOF
{
  "_comment": "🤖 Universal AI Token Tracker v3.0 - Auto-configured",
  "provider": "$PROVIDER",
  "plan": "$PLAN",
  "_architecture_model": "$ARCH_MODEL",
  "monthly_limit": $TOKEN_MONTHLY,
  "daily_limit": $TOKEN_DAILY$MODEL3_FIELDS,
  "tracking_enabled": true,
  "current_month": "$THIS_MONTH",
  "monthly_usage": 0,
  "monthly_percentage": 0,
  "daily_usage": 0,
  "daily_percentage": 0,
  "last_reset_daily": "$TODAY",
  "last_reset_monthly": "$MONTH_START",
  "thresholds": {
    "green": 50,
    "moderate": 70,
    "caution": 90,
    "critical": 95
  },
  "current_status": "green",
  "current_zone": "🟢 Green - Full capacity",
  "sessions": [],
  "notes": [
    "Auto-configured by ai-workflow-rules installer",
    "Limits are CONSERVATIVE (10-20% lower) for early warnings",
    "Context compression auto-triggers at 50% (saves 40-60% tokens)"
  ],
  "history": {}
}
EOF
    print_success ".ai/token-limits.json ($PROVIDER $PLAN: $TOKEN_DAILY daily)"
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
  "config_version": "2.0",
  "context": "$CONTEXT",
  "modules": [],
  "market": "$MARKET_VALUE",
  "language": {
    "internal_dialogue": "adaptive",
    "code_comments": "en",
    "commit_messages": "en",
    "variable_names": "en"
  },
  "token_budget": {
    "daily_limit": $TOKEN_DAILY,
    "monthly_limit": $TOKEN_MONTHLY,
    "auto_approve_thresholds": {
      "green_zone": 15000,
      "moderate_zone": 8000,
      "caution_zone": 3000,
      "critical_zone": 0
    }
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
    print_success ".ai/config.json (context: $CONTEXT, market: $MARKET_VALUE)"
fi

# ========================================
# Scripts
# ========================================

mkdir -p "$TARGET_DIR/scripts"
copy_file "$TEMPLATES_DIR/scripts/pre-commit"      "$TARGET_DIR/scripts/pre-commit"
copy_file "$TEMPLATES_DIR/scripts/sync-rules.sh"   "$TARGET_DIR/scripts/sync-rules.sh"
copy_file "$TEMPLATES_DIR/scripts/token-status.sh" "$TARGET_DIR/scripts/token-status.sh"
chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true

# ========================================
# Install pre-commit hook (conditional)
# ========================================

if [ "$INSTALL_HOOKS" = "yes" ]; then
    if [ -f "$TARGET_DIR/.git/hooks/pre-commit" ]; then
        print_warning "Pre-commit hook already exists, backing up..."
        mv "$TARGET_DIR/.git/hooks/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit.backup"
    fi
    cp "$TARGET_DIR/scripts/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit"
    chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
    print_success "Pre-commit hook installed"
fi

# ========================================
# Update .gitignore (conditional)
# ========================================

if [ "$UPDATE_GITIGNORE" = "yes" ]; then
    GITIGNORE_PATH="$TARGET_DIR/.gitignore"
    [ -f "$GITIGNORE_PATH" ] || touch "$GITIGNORE_PATH"

    if grep -qF "# AI Workflow Rules" "$GITIGNORE_PATH" 2>/dev/null; then
        print_warning ".gitignore already contains AI rules, skipping"
    else
        printf '\n# AI Workflow Rules\n.ai/.session-started\n.ai/checkpoint-*.md\nai-logs/\n' \
            >> "$GITIGNORE_PATH"
        print_success ".gitignore updated"
    fi
fi

# ========================================
# Generate rules for AI tools
# ========================================

print_step "Generating rules for AI tools..."

SOURCE_RULES="$TARGET_DIR/.ai/contexts/$CONTEXT.context.md"

generate_rules_file() {
    local target_file="$TARGET_DIR/$1"
    local tool_name="$2"

    if [ -f "$target_file" ]; then
        print_warning "$1 already exists, skipping"
        return
    fi

    mkdir -p "$(dirname "$target_file")"
    {
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

generate_rules_file ".cursorrules"  "Cursor"
generate_rules_file ".windsurfrules" "Windsurf"

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
check_file ".claude/CLAUDE.md"
check_file ".claude/settings.json"
check_file ".claude/hooks/user-prompt-submit.sh"
check_file ".ai/AI-ENFORCEMENT.md"
check_file ".ai/config.json"
check_file ".ai/token-limits.json"
check_file ".ai/forbidden-trackers.json"
check_file ".ai/rules/core.md"
check_file ".ai/contexts/$CONTEXT.context.md"
check_file "scripts/pre-commit"
check_file "scripts/sync-rules.sh"
check_file "scripts/token-status.sh"

if [ "$INSTALL_HOOKS" = "yes" ] && [ -x "$TARGET_DIR/.git/hooks/pre-commit" ]; then
    print_success ".git/hooks/pre-commit (executable)"
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
