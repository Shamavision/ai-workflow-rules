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
echo "Files will be copied: .ai/, RULES_*.md, scripts/, etc."
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
# Verification
# ========================================

print_step "Verifying installation..."

ISSUES=0

# Check essential files
FILES_TO_CHECK=(
    "RULES_CORE.md"
    "RULES_PRODUCT.md"
    "AGENTS.md"
    ".ai/token-limits.json"
    ".ai/forbidden-trackers.json"
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

echo -e "${GREEN}✓ AI Workflow Rules Framework installed${NC}"
echo ""
echo "📚 Next Steps:"
echo ""
echo "  1. Configure your API keys:"
echo "     ${YELLOW}nano .env${NC}"
echo ""
echo "  2. Start AI session (Claude Code, Cursor, etc.):"
echo "     ${YELLOW}//START${NC}"
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
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
echo -e "${BLUE}Made with ❤️ in Ukraine 🇺🇦${NC}"
echo -e "${BLUE}https://wellme.ua${NC}"
echo ""
