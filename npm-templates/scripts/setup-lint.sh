#!/bin/bash
# Setup Lint Tools - Auto-install linters for your project
# Version: 9.1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Lint Tools Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detect project type
DETECTED=""

if [ -f "package.json" ]; then
    DETECTED="JavaScript/TypeScript"
    echo "📦 Detected: $DETECTED project"
    echo ""

    # Check if already installed
    if grep -q '"eslint"' package.json && grep -q '"prettier"' package.json; then
        echo "✓ ESLint and Prettier already installed"
    else
        echo "Installing ESLint and Prettier..."
        npm install --save-dev eslint prettier eslint-config-prettier
        echo "✓ Installed"
    fi

    # Add npm scripts if missing
    echo ""
    echo "Checking npm scripts..."

    if ! grep -q '"lint"' package.json; then
        echo "Adding 'lint' script..."
        npm pkg set scripts.lint="eslint ."
    fi

    if ! grep -q '"format"' package.json; then
        echo "Adding 'format' script..."
        npm pkg set scripts.format="prettier --write ."
    fi

    echo "✓ npm scripts configured"

    # Create .eslintrc.json if missing
    if [ ! -f ".eslintrc.json" ]; then
        echo ""
        echo "Creating .eslintrc.json..."
        cat > .eslintrc.json << 'EOF'
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "prettier"
  ],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {}
}
EOF
        echo "✓ Created .eslintrc.json"
    fi

    # Create .prettierrc if missing
    if [ ! -f ".prettierrc" ]; then
        echo "Creating .prettierrc..."
        cat > .prettierrc << 'EOF'
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
EOF
        echo "✓ Created .prettierrc"
    fi
fi

if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    [ -n "$DETECTED" ] && DETECTED="$DETECTED + "
    DETECTED="${DETECTED}Python"
    echo "🐍 Detected: Python project"
    echo ""

    echo "Installing Black and Flake8..."
    if command -v pip &> /dev/null; then
        pip install black flake8
        echo "✓ Installed"
    elif command -v pip3 &> /dev/null; then
        pip3 install black flake8
        echo "✓ Installed"
    else
        echo "⚠️  pip not found. Install manually:"
        echo "   pip install black flake8"
    fi

    # Create pyproject.toml config if missing
    if [ ! -f "pyproject.toml" ]; then
        echo ""
        echo "Creating pyproject.toml..."
        cat > pyproject.toml << 'EOF'
[tool.black]
line-length = 88
target-version = ['py38', 'py39', 'py310', 'py311']

[tool.flake8]
max-line-length = 88
extend-ignore = E203
EOF
        echo "✓ Created pyproject.toml"
    fi
fi

if [ -f "go.mod" ]; then
    [ -n "$DETECTED" ] && DETECTED="$DETECTED + "
    DETECTED="${DETECTED}Go"
    echo "🔷 Detected: Go project"
    echo ""
    echo "✓ gofmt is built-in with Go (no installation needed)"
    echo ""
    echo "Optional: Install golint for additional checks"
    echo "   go install golang.org/x/lint/golint@latest"
fi

if [ -z "$DETECTED" ]; then
    echo "⚠️  No supported project type detected"
    echo ""
    echo "Supported:"
    echo "  - JavaScript/TypeScript (package.json)"
    echo "  - Python (pyproject.toml, setup.py, requirements.txt)"
    echo "  - Go (go.mod)"
    echo ""
    echo "You can still use the lint hook - it will skip silently."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Test: git commit (lint hook will run automatically)"
echo "  2. Manual check: bash scripts/pre-commit-lint.sh"
echo "  3. Skip lint: AI_SKIP_LINT=1 git commit"
echo ""
echo "Documentation: .ai/docs/code-quality.md"
echo ""
