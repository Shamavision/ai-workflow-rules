#!/bin/bash

# ========================================
# AI Workflow Rules - One-Line Installer
# ========================================
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/Shamavision/ai-workflow-rules/main/scripts/install.sh)
#
# This script will:
#   1. Download AI Workflow Rules from GitHub
#   2. Copy all necessary files to your project
#   3. Configure git hooks
#   4. Setup token limits for your AI provider
#
# ========================================

set -e  # Exit on error

REPO_URL="https://github.com/Shamavision/ai-workflow-rules.git"
TEMP_DIR=$(mktemp -d)
TARGET_DIR=$(pwd)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Cleanup on exit
trap cleanup EXIT

# ========================================
# Pre-flight Checks
# ========================================

print_header

print_step "Running pre-flight checks..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install git first."
    exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_warning "Not a git repository. Initializing git..."
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
echo "This will install AI Workflow Rules Framework in your project."
echo "Files will be copied: .ai/, .claude/, RULES_*.md, scripts/, etc."
echo ""
read -p "Continue? (y/n): " -n 1 -r
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

print_success "Repository downloaded to temporary directory"

# ========================================
# Copy Files
# ========================================

print_step "Copying files to your project..."

# Copy .ai directory
if [ -d "$TEMP_DIR/.ai" ]; then
    mkdir -p "$TARGET_DIR/.ai"
    cp -r "$TEMP_DIR/.ai/"* "$TARGET_DIR/.ai/"
    print_success "Copied .ai/ configuration"
fi

# Copy .claude directory (Layer 0: CLAUDE.md + hooks)
if [ -d "$TEMP_DIR/.claude" ]; then
    mkdir -p "$TARGET_DIR/.claude"
    mkdir -p "$TARGET_DIR/.claude/hooks"

    # Copy CLAUDE.md (universal session start)
    if [ -f "$TEMP_DIR/.claude/CLAUDE.md" ]; then
        cp "$TEMP_DIR/.claude/CLAUDE.md" "$TARGET_DIR/.claude/"
        print_success "Copied .claude/CLAUDE.md (Layer 0)"
    fi

    # Copy settings.json
    if [ -f "$TEMP_DIR/.claude/settings.json" ]; then
        cp "$TEMP_DIR/.claude/settings.json" "$TARGET_DIR/.claude/"
        print_success "Copied .claude/settings.json"
    fi

    # Copy hooks
    if [ -d "$TEMP_DIR/.claude/hooks" ]; then
        cp -r "$TEMP_DIR/.claude/hooks/"* "$TARGET_DIR/.claude/hooks/" 2>/dev/null || true
        chmod +x "$TARGET_DIR/.claude/hooks/"*.sh 2>/dev/null || true
        print_success "Copied .claude/hooks/"
    fi
fi

# Copy RULES files
for file in "$TEMP_DIR"/RULES_*.md; do
    if [ -f "$file" ]; then
        cp "$file" "$TARGET_DIR/"
        print_success "Copied $(basename "$file")"
    fi
done

# Copy documentation files
DOCS=("AGENTS.md" "START.md" "CHEATSHEET.md" "QUICKSTART.md" "TOKEN_USAGE.md" "AI_COMPATIBILITY.md" "INSTALL.md")
for doc in "${DOCS[@]}"; do
    if [ -f "$TEMP_DIR/$doc" ]; then
        cp "$TEMP_DIR/$doc" "$TARGET_DIR/"
        print_success "Copied $doc"
    fi
done

# Copy scripts directory
if [ -d "$TEMP_DIR/scripts" ]; then
    mkdir -p "$TARGET_DIR/scripts"
    cp -r "$TEMP_DIR/scripts/"* "$TARGET_DIR/scripts/"
    chmod +x "$TARGET_DIR/scripts/"*.sh 2>/dev/null || true
    print_success "Copied scripts/ directory"
fi

# Copy .editorconfig
if [ -f "$TEMP_DIR/.editorconfig" ]; then
    cp "$TEMP_DIR/.editorconfig" "$TARGET_DIR/"
    print_success "Copied .editorconfig"
fi

# Copy .env.example
if [ -f "$TEMP_DIR/.env.example" ]; then
    cp "$TEMP_DIR/.env.example" "$TARGET_DIR/"
    print_success "Copied .env.example"
fi

# Update .gitignore
print_step "Updating .gitignore..."

GITIGNORE_ENTRIES=(
    ".ai/.session-started"
    ".env"
    "node_modules/"
)

if [ ! -f "$TARGET_DIR/.gitignore" ]; then
    touch "$TARGET_DIR/.gitignore"
fi

for entry in "${GITIGNORE_ENTRIES[@]}"; do
    if ! grep -qF "$entry" "$TARGET_DIR/.gitignore"; then
        echo "$entry" >> "$TARGET_DIR/.gitignore"
    fi
done

print_success "Updated .gitignore"

# ========================================
# Install Git Hooks
# ========================================

print_step "Installing git pre-commit hook..."

if [ -f "$TARGET_DIR/scripts/pre-commit" ]; then
    mkdir -p "$TARGET_DIR/.git/hooks"

    if [ -f "$TARGET_DIR/.git/hooks/pre-commit" ]; then
        print_warning "Pre-commit hook already exists, backing up..."
        mv "$TARGET_DIR/.git/hooks/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit.backup"
        print_success "Backup saved: .git/hooks/pre-commit.backup"
    fi

    cp "$TARGET_DIR/scripts/pre-commit" "$TARGET_DIR/.git/hooks/pre-commit"
    chmod +x "$TARGET_DIR/.git/hooks/pre-commit"
    print_success "Pre-commit hook installed"
else
    print_warning "Pre-commit hook not found, skipping"
fi

# ========================================
# Configure Token Limits
# ========================================

print_step "Configuring AI token limits..."

echo ""
echo "Select your AI provider:"
echo "  1) Anthropic (Claude)"
echo "  2) OpenAI (ChatGPT)"
echo "  3) Google (Gemini)"
echo "  4) Cursor"
echo "  5) GitHub Copilot"
echo "  6) Custom / Skip"
echo ""
read -p "Enter number (1-6): " PROVIDER_CHOICE

case $PROVIDER_CHOICE in
    1) PROVIDER="anthropic" ;;
    2) PROVIDER="openai" ;;
    3) PROVIDER="google" ;;
    4) PROVIDER="cursor" ;;
    5) PROVIDER="github_copilot" ;;
    *) PROVIDER="anthropic" ;;
esac

echo ""
echo "Select your plan:"
echo "  1) Free"
echo "  2) Pro / Plus"
echo "  3) Team / Business"
echo ""
read -p "Enter number (1-3): " PLAN_CHOICE

case $PLAN_CHOICE in
    1) PLAN="free" ;;
    2) PLAN="pro" ;;
    3) PLAN="team" ;;
    *) PLAN="pro" ;;
esac

# Update token-limits.json
if [ -f "$TARGET_DIR/.ai/token-limits.json" ]; then
    # Use sed to update provider and plan
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\"provider\": \"[^\"]*\"/\"provider\": \"$PROVIDER\"/" "$TARGET_DIR/.ai/token-limits.json"
        sed -i '' "s/\"plan\": \"[^\"]*\"/\"plan\": \"$PLAN\"/" "$TARGET_DIR/.ai/token-limits.json"
    else
        # Linux
        sed -i "s/\"provider\": \"[^\"]*\"/\"provider\": \"$PROVIDER\"/" "$TARGET_DIR/.ai/token-limits.json"
        sed -i "s/\"plan\": \"[^\"]*\"/\"plan\": \"$PLAN\"/" "$TARGET_DIR/.ai/token-limits.json"
    fi

    print_success "Configured for $PROVIDER ($PLAN)"
else
    print_warning "token-limits.json not found"
fi

# ========================================
# Context Selection (v9.1 Smart Selection)
# ========================================

print_step "Context Selection Wizard (v9.1)..."

echo ""
echo -e "${CYAN}📊 Answer a few questions for personalized recommendation${NC}"
echo ""

# Question 1: Team size
echo "1. How many team members?"
echo "   1) 1-2 developers (solo/small)"
echo "   2) 3-5 developers (team)"
echo "   3) 6+ developers (large team)"
echo ""
read -p "Enter number (1-3): " TEAM_SIZE
echo ""

# Question 2: Market
echo "2. Primary market?"
echo "   1) Ukrainian market (compliance, language rules)"
echo "   2) International (English-focused)"
echo ""
read -p "Enter number (1-2): " MARKET
echo ""

# Question 3: Token priority
echo "3. Token budget priority?"
echo "   1) High priority (minimize token usage)"
echo "   2) Medium (balanced)"
echo "   3) Low (prefer full features)"
echo ""
read -p "Enter number (1-3): " TOKEN_PRIORITY
echo ""

# Recommendation logic
RECOMMENDED=""
REASON=""

if [ "$MARKET" = "1" ]; then
    RECOMMENDED="ukraine-full"
    REASON="Ukrainian market needs full compliance features"
elif [ "$TOKEN_PRIORITY" = "1" ]; then
    RECOMMENDED="minimal"
    REASON="Token efficiency prioritized"
elif [ "$TEAM_SIZE" = "3" ] || [ "$TOKEN_PRIORITY" = "3" ]; then
    RECOMMENDED="enterprise"
    if [ "$TEAM_SIZE" = "3" ]; then
        REASON="Large team benefits from enterprise workflows"
    else
        REASON="Full features prioritized"
    fi
else
    RECOMMENDED="standard"
    REASON="Balanced approach for most projects"
fi

# Show comparison table
echo ""
echo -e "${CYAN}📊 Context Comparison (v9.1 optimized)${NC}"
echo ""
echo "┌─────────────────┬────────────┬─────────────┬──────────────────────┐"
echo "│ Context         │ Tokens     │ Daily %     │ Best For             │"
echo "├─────────────────┼────────────┼─────────────┼──────────────────────┤"
echo "│ Minimal         │ ~10k       │ 5%          │ Startups, MVP        │"
echo "│ Standard        │ ~14k       │ 7%          │ Most projects        │"
echo "│ Ukraine-Full    │ ~18k       │ 9%          │ Ukrainian market     │"
echo "│ Enterprise      │ ~23k       │ 11.5%       │ Large teams          │"
echo "└─────────────────┴────────────┴─────────────┴──────────────────────┘"
echo ""

# Show recommendation
echo -e "${GREEN}✅ Recommended: ${RECOMMENDED}${NC}"
echo -e "${GRAY}   Reasoning: ${REASON}${NC}"
echo ""

# Confirm or choose manually
read -p "Use ${RECOMMENDED}? (Y/n): " CONFIRM_CHOICE

if [[ "$CONFIRM_CHOICE" =~ ^[Yy]$ ]] || [ -z "$CONFIRM_CHOICE" ]; then
    CONTEXT="$RECOMMENDED"
else
    # Manual selection
    echo ""
    echo "Choose context manually:"
    echo "  1) Minimal (~10k tokens)"
    echo "  2) Standard (~14k tokens)"
    echo "  3) Ukraine-Full (~18k tokens)"
    echo "  4) Enterprise (~23k tokens)"
    echo ""
    read -p "Enter number (1-4): " MANUAL_CHOICE

    case $MANUAL_CHOICE in
        1) CONTEXT="minimal" ;;
        2) CONTEXT="standard" ;;
        3) CONTEXT="ukraine-full" ;;
        4) CONTEXT="enterprise" ;;
        *) CONTEXT="$RECOMMENDED" ;;
    esac
fi

# Update config.json with selected context
if [ -f "$TARGET_DIR/.ai/config.json" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\"context\": \"[^\"]*\"/\"context\": \"$CONTEXT\"/" "$TARGET_DIR/.ai/config.json"
    else
        # Linux
        sed -i "s/\"context\": \"[^\"]*\"/\"context\": \"$CONTEXT\"/" "$TARGET_DIR/.ai/config.json"
    fi

    print_success "Context configured: $CONTEXT"
else
    print_warning "config.json not found"
fi

# ========================================
# Create .env if needed
# ========================================

print_step "Setting up environment file..."

if [ -f "$TARGET_DIR/.env" ]; then
    print_warning ".env already exists, skipping"
else
    if [ -f "$TARGET_DIR/.env.example" ]; then
        cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
        print_success "Created .env from template"
        print_warning "Remember to add your API keys to .env file!"
    fi
fi

# ========================================
# Generate Rules for AI Tools (v9.0 Universal)
# ========================================

print_step "Generating rules for AI tools..."

# Source of truth
SOURCE_RULES="$TARGET_DIR/.ai/contexts/$CONTEXT.context.md"

# Function: Detect installed AI tools
detect_ai_tools() {
    local tools=()

    # Claude Code CLI
    if command -v claude &> /dev/null; then
        tools+=("claude-cli")
    fi

    # Cursor
    if command -v cursor &> /dev/null || [ -d "$HOME/.cursor" ] || [ -f "$TARGET_DIR/.cursorrules" ]; then
        tools+=("cursor")
    fi

    # Windsurf
    if command -v windsurf &> /dev/null || [ -f "$TARGET_DIR/.windsurfrules" ]; then
        tools+=("windsurf")
    fi

    # Continue.dev
    if [ -f "$TARGET_DIR/.continuerules" ] || [ -f "$TARGET_DIR/continue.config.json" ]; then
        tools+=("continue")
    fi

    # Always include Claude VSCode Extension (hard to detect, common)
    tools+=("claude-vscode")

    # Always include AGENTS.md (universal fallback)
    tools+=("agents-md")

    echo "${tools[@]}"
}

# Function: Generate rules file for specific tool
generate_rules_file() {
    local tool=$1
    local target=$2
    local tool_name=$3

    echo -e "  ${CYAN}→${NC} Generating $target for $tool_name..."

    # Create target directory if needed
    mkdir -p "$(dirname "$TARGET_DIR/$target")"

    # Generate file with header
    cat > "$TARGET_DIR/$target" << EOF
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI WORKFLOW RULES FRAMEWORK v9.0
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Tool: $tool_name
# Context: $CONTEXT
# Auto-generated from: .ai/contexts/$CONTEXT.context.md
#
# To update rules: npm run sync-rules (or bash scripts/sync-rules.sh)
# Framework: https://github.com/Shamavision/ai-workflow-rules
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    # Append source rules
    if [ -f "$SOURCE_RULES" ]; then
        cat "$SOURCE_RULES" >> "$TARGET_DIR/$target"
    else
        echo "⚠️  Source rules not found: $SOURCE_RULES" >> "$TARGET_DIR/$target"
    fi

    # Footer
    cat >> "$TARGET_DIR/$target" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# END OF AUTO-GENERATED RULES
# Made in Ukraine 🇺🇦
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    print_success "$target created"
}

# Function: Append rules to existing file (with markers)
append_to_existing() {
    local target=$1
    local tool_name=$2

    echo -e "  ${YELLOW}⚠${NC}  $target exists - appending with markers..."

    # Backup
    cp "$TARGET_DIR/$target" "$TARGET_DIR/$target.backup"

    # Check if already has our markers
    if grep -q "AI-WORKFLOW-RULES-START" "$TARGET_DIR/$target"; then
        echo -e "  ${CYAN}→${NC} Already integrated, skipping"
        return
    fi

    # Append with markers
    cat >> "$TARGET_DIR/$target" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI-WORKFLOW-RULES-START v9.0.0
# Auto-managed section. Edit at your own risk.
# To update: npm run sync-rules
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    cat "$SOURCE_RULES" >> "$TARGET_DIR/$target"

    cat >> "$TARGET_DIR/$target" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI-WORKFLOW-RULES-END v9.0.0
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    print_success "Appended to $target (backup: $target.backup)"
}

# Detect AI tools
echo ""
echo "Detecting installed AI coding tools..."
AI_TOOLS=($(detect_ai_tools))

if [ ${#AI_TOOLS[@]} -eq 0 ]; then
    print_warning "No AI tools detected, creating default files"
    AI_TOOLS=("claude-vscode" "agents-md")
fi

echo -e "${CYAN}Found: ${AI_TOOLS[*]}${NC}"
echo ""

# Generate files for each detected tool
for tool in "${AI_TOOLS[@]}"; do
    case $tool in
        claude-cli)
            generate_rules_file "$tool" "AGENTS.md" "Claude Code CLI"
            ;;

        claude-vscode)
            generate_rules_file "$tool" ".claude/CLAUDE.md" "Claude VSCode Extension"
            ;;

        cursor)
            if [ -f "$TARGET_DIR/.cursorrules" ]; then
                append_to_existing ".cursorrules" "Cursor"
            else
                generate_rules_file "$tool" ".cursorrules" "Cursor"
            fi
            ;;

        windsurf)
            if [ -f "$TARGET_DIR/.windsurfrules" ]; then
                append_to_existing ".windsurfrules" "Windsurf"
            else
                generate_rules_file "$tool" ".windsurfrules" "Windsurf"
            fi
            ;;

        continue)
            if [ -f "$TARGET_DIR/.continuerules" ]; then
                append_to_existing ".continuerules" "Continue.dev"
            else
                generate_rules_file "$tool" ".continuerules" "Continue.dev"
            fi
            ;;

        agents-md)
            # Always create AGENTS.md as universal fallback
            generate_rules_file "$tool" "AGENTS.md" "Universal (all AI tools)"
            ;;
    esac
done

echo ""
print_success "Rules generated for ${#AI_TOOLS[@]} AI tool(s)"
echo ""

# ========================================
# Verification
# ========================================

print_step "Verifying installation..."

ISSUES=0

# Check essential files
FILES_TO_CHECK=(
    ".ai/rules/core.md"
    ".ai/rules/product.md"
    "AGENTS.md"
    ".ai/config.json"
    ".ai/contexts/minimal.context.md"
    ".ai/contexts/standard.context.md"
    ".ai/contexts/ukraine-full.context.md"
    ".ai/contexts/enterprise.context.md"
    ".ai/token-limits.json"
    ".ai/forbidden-trackers.json"
    ".claude/CLAUDE.md"
    ".claude/settings.json"
    "scripts/seo-check.sh"
)

for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$TARGET_DIR/$file" ]; then
        print_success "$file"
    else
        print_warning "Missing $file"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check git hook
if [ -x "$TARGET_DIR/.git/hooks/pre-commit" ]; then
    print_success "Pre-commit hook (executable)"
else
    print_warning "Pre-commit hook not executable"
    ISSUES=$((ISSUES + 1))
fi

# ========================================
# Summary
# ========================================

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"

if [ $ISSUES -eq 0 ]; then
    echo -e "${BLUE}║${GREEN}  ✓ Installation Complete!${NC}                 ${BLUE}║${NC}"
else
    echo -e "${BLUE}║${YELLOW}  ⚠ Installation Complete with warnings${NC}    ${BLUE}║${NC}"
fi

echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}✓ AI Workflow Rules Framework v9.0 installed${NC}"
echo -e "${BLUE}   Context: ${CONTEXT}${NC}"
echo ""
echo "📚 Next Steps:"
echo ""
echo "  1. Configure your API keys:"
echo "     ${YELLOW}nano .env${NC}"
echo ""
echo "  2. Start AI session (Claude Code, Cursor, etc.):"
echo "     ${YELLOW}//START${NC}"
echo ""
echo "     AI will load ${CONTEXT} context automatically."
echo ""
echo "  3. Read quick start guide:"
echo "     ${YELLOW}cat QUICKSTART.md${NC}"
echo ""
echo "  4. Verify your project (optional):"
echo "     ${YELLOW}./scripts/seo-check.sh .${NC}"
echo ""
echo -e "${BLUE}🤖 Universal AI Support:${NC}"
echo "   - Claude Code, Cursor, Windsurf: Auto-loads AGENTS.md ✓"
echo "   - ChatGPT, Gemini (web): Use //START command"
echo ""
echo -e "${BLUE}🛡️  AI Protection v9.0:${NC}"
echo "   - Prompt injection detection"
echo "   - PII protection (GDPR-ready)"
echo "   - Auto-runs in pre-commit hook"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
echo -e "${BLUE}Made with ❤️ in Ukraine 🇺🇦${NC}"
echo -e "${BLUE}https://wellme.ua${NC}"
echo ""
