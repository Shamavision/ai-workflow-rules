#!/bin/bash
# Pre-commit Lint Hook (Warnings Only)
# Version: 9.1
# Purpose: Check code quality and formatting (non-blocking)

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Skip if disabled
if [ "$AI_SKIP_LINT" = "1" ]; then
    echo -e "${BLUE}ℹ️  Linting skipped (AI_SKIP_LINT=1)${NC}"
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}🔍 Code Quality Check (Warnings Only)${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

WARNINGS=0
CHECKS_RUN=0

# Get staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
    echo -e "${GREEN}✓ No files to check${NC}"
    exit 0
fi

# ============================================
# JavaScript/TypeScript Projects
# ============================================

if [ -f "package.json" ]; then
    echo -e "${BLUE}📦 Detected: JavaScript/TypeScript project${NC}"
    ((CHECKS_RUN++))

    # Check for lint script
    if npm run lint --silent 2>/dev/null | grep -q "Missing script"; then
        echo -e "${YELLOW}⚠️  No 'lint' script in package.json${NC}"
        echo "   Suggestion: Add \"lint\": \"eslint .\" to scripts"
    else
        echo "   Running: npm run lint..."
        if npm run lint --silent 2>&1; then
            echo -e "${GREEN}   ✓ Linting passed${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Linting issues found (not blocking)${NC}"
            ((WARNINGS++))
        fi
    fi

    # Check for format script
    if npm run format --silent 2>/dev/null | grep -q "Missing script"; then
        echo -e "${YELLOW}⚠️  No 'format' script in package.json${NC}"
        echo "   Suggestion: Add \"format\": \"prettier --write .\" to scripts"
    else
        echo "   Running: npm run format --check..."
        if npm run format -- --check --silent 2>&1; then
            echo -e "${GREEN}   ✓ Formatting is consistent${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Formatting issues found${NC}"
            echo "   Fix: Run 'npm run format' to auto-fix"
            ((WARNINGS++))
        fi
    fi

    # Basic syntax check for JS/TS files
    echo "   Checking syntax..."
    for file in $STAGED_FILES; do
        if [[ "$file" =~ \.(js|ts|jsx|tsx)$ ]]; then
            if ! node --check "$file" 2>/dev/null; then
                echo -e "${RED}   ✗ Syntax error in: $file${NC}"
                ((WARNINGS++))
            fi
        fi
    done

    echo ""
fi

# ============================================
# Python Projects
# ============================================

if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    echo -e "${BLUE}🐍 Detected: Python project${NC}"
    ((CHECKS_RUN++))

    # Check for Black
    if command -v black &> /dev/null; then
        echo "   Running: black --check..."
        if black --check . 2>&1 | head -5; then
            echo -e "${GREEN}   ✓ Formatting is consistent${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Formatting issues found${NC}"
            echo "   Fix: Run 'black .' to auto-fix"
            ((WARNINGS++))
        fi
    else
        echo -e "${YELLOW}   ⚠️  Black not installed${NC}"
        echo "   Install: pip install black"
    fi

    # Check for Flake8
    if command -v flake8 &> /dev/null; then
        echo "   Running: flake8..."
        if flake8 . 2>&1 | head -5; then
            echo -e "${GREEN}   ✓ No style issues${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Style issues found${NC}"
            ((WARNINGS++))
        fi
    else
        echo -e "${YELLOW}   ⚠️  Flake8 not installed${NC}"
        echo "   Install: pip install flake8"
    fi

    # Basic syntax check
    echo "   Checking syntax..."
    for file in $STAGED_FILES; do
        if [[ "$file" =~ \.py$ ]]; then
            if ! python -m py_compile "$file" 2>/dev/null; then
                echo -e "${RED}   ✗ Syntax error in: $file${NC}"
                ((WARNINGS++))
            fi
        fi
    done

    echo ""
fi

# ============================================
# Go Projects
# ============================================

if [ -f "go.mod" ]; then
    echo -e "${BLUE}🔷 Detected: Go project${NC}"
    ((CHECKS_RUN++))

    # Check gofmt
    echo "   Running: gofmt -l..."
    UNFORMATTED=$(gofmt -l . 2>/dev/null)
    if [ -z "$UNFORMATTED" ]; then
        echo -e "${GREEN}   ✓ All files formatted${NC}"
    else
        echo -e "${YELLOW}   ⚠️  Unformatted files:${NC}"
        echo "$UNFORMATTED" | sed 's/^/     /'
        echo "   Fix: Run 'gofmt -w .' to auto-fix"
        ((WARNINGS++))
    fi

    # Check go vet
    echo "   Running: go vet..."
    if go vet ./... 2>&1 | head -5; then
        echo -e "${GREEN}   ✓ No issues found${NC}"
    else
        echo -e "${YELLOW}   ⚠️  Issues found${NC}"
        ((WARNINGS++))
    fi

    echo ""
fi

# ============================================
# Shell Scripts
# ============================================

SHELL_FILES=$(echo "$STAGED_FILES" | grep -E '\.(sh|bash)$')
if [ -n "$SHELL_FILES" ]; then
    echo -e "${BLUE}🐚 Detected: Shell scripts${NC}"
    ((CHECKS_RUN++))

    if command -v shellcheck &> /dev/null; then
        echo "   Running: shellcheck..."
        for file in $SHELL_FILES; do
            if ! shellcheck "$file" 2>&1 | head -5; then
                echo -e "${YELLOW}   ⚠️  Issues in: $file${NC}"
                ((WARNINGS++))
            fi
        done
        echo -e "${GREEN}   ✓ Shellcheck complete${NC}"
    else
        echo -e "${YELLOW}   ⚠️  Shellcheck not installed${NC}"
        echo "   Install: brew install shellcheck (macOS) or apt install shellcheck (Linux)"
    fi

    echo ""
fi

# ============================================
# Markdown Files
# ============================================

MD_FILES=$(echo "$STAGED_FILES" | grep -E '\.md$')
if [ -n "$MD_FILES" ]; then
    echo -e "${BLUE}📝 Detected: Markdown files${NC}"
    ((CHECKS_RUN++))

    if command -v markdownlint &> /dev/null; then
        echo "   Running: markdownlint..."
        for file in $MD_FILES; do
            if ! markdownlint "$file" 2>&1 | head -5; then
                echo -e "${YELLOW}   ⚠️  Issues in: $file${NC}"
                ((WARNINGS++))
            fi
        done
        echo -e "${GREEN}   ✓ Markdown check complete${NC}"
    else
        echo -e "${YELLOW}   ℹ️  Markdownlint not installed (optional)${NC}"
    fi

    echo ""
fi

# ============================================
# Summary
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $CHECKS_RUN -eq 0 ]; then
    echo -e "${BLUE}ℹ️  No project type detected${NC}"
    echo "   Supported: JavaScript/TypeScript, Python, Go, Shell, Markdown"
elif [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All quality checks passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Found $WARNINGS warning(s)${NC}"
    echo ""
    echo "These are warnings only and won't block your commit."
    echo "Consider fixing them before pushing to remote."
    echo ""
    echo "To skip lint checks: AI_SKIP_LINT=1 git commit"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Always exit 0 (non-blocking)
exit 0
