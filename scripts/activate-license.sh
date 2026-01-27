#!/bin/bash
# ==============================================================================
# LICENSE ACTIVATION SCRIPT
# AI Workflow Rules Framework v5.0
# ==============================================================================
#
# PURPOSE:
#   Client-side script to activate AI Workflow Rules license
#
# USAGE:
#   ./scripts/activate-license.sh
#   ./scripts/activate-license.sh --no-metrics  (disable optional metrics)
#   ./scripts/activate-license.sh --key YOUR-LICENSE-KEY
#
# WHAT IT DOES:
#   1. Prompts for license key (or accepts via --key flag)
#   2. Validates license key format
#   3. Creates .ai/license.json with activation info
#   4. Prompts for metrics opt-in/opt-out
#   5. Runs authenticity verification
#
# OUTPUT:
#   .ai/license.json - Contains license info (DO NOT commit to git!)
#
# ==============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==============================================================================
# CONFIGURATION
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
AI_DIR="$PROJECT_ROOT/.ai"
LICENSE_FILE="$AI_DIR/license.json"

# ==============================================================================
# FUNCTIONS
# ==============================================================================

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  AI Workflow Rules - License Activation${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Validate license key format
# Expected format: AWRF-XXXX-XXXX-XXXX-XXXX (20 chars + 4 dashes)
validate_license_key() {
    local key="$1"

    # Check format: AWRF-XXXX-XXXX-XXXX-XXXX
    if [[ ! "$key" =~ ^AWRF-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$ ]]; then
        print_error "Invalid license key format"
        echo "Expected format: AWRF-XXXX-XXXX-XXXX-XXXX"
        echo "Example: AWRF-A1B2-C3D4-E5F6-G7H8"
        return 1
    fi

    # Basic checksum validation (simple example - real implementation would verify signature)
    # In production, this would validate HMAC signature with server public key

    return 0
}

# Create license activation file
create_license_file() {
    local license_key="$1"
    local metrics_enabled="$2"
    local activation_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Ensure .ai directory exists
    mkdir -p "$AI_DIR"

    # Create license.json
    cat > "$LICENSE_FILE" <<EOF
{
  "_comment": "AI Workflow Rules License - DO NOT SHARE OR COMMIT TO GIT",
  "license_key": "$license_key",
  "activation_date": "$activation_date",
  "license_version": "4.0",
  "metrics_enabled": $metrics_enabled,
  "license_type": "proprietary",
  "activated_by": "$(whoami)@$(hostname)",
  "last_verified": "$activation_date"
}
EOF

    # Set restrictive permissions (owner read/write only)
    chmod 600 "$LICENSE_FILE"

    print_success "License file created: $LICENSE_FILE"
}

# Check if license is already activated
check_existing_license() {
    if [ -f "$LICENSE_FILE" ]; then
        print_warning "License already activated!"
        echo ""
        echo "Current license info:"
        cat "$LICENSE_FILE" | grep -E '"license_key"|"activation_date"' || true
        echo ""
        read -p "Do you want to re-activate with a new key? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Activation cancelled. Existing license retained."
            exit 0
        fi
    fi
}

# Prompt for metrics consent (GDPR compliance)
prompt_metrics_consent() {
    local no_metrics_flag="$1"

    if [ "$no_metrics_flag" == "true" ]; then
        echo "false"  # Metrics disabled via flag
        return
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 OPTIONAL METRICS COLLECTION"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To improve AI Workflow Rules, we collect anonymous usage metrics."
    echo ""
    echo "What we collect (see LICENSE-METRICS.md for details):"
    echo "  ✅ Feature usage patterns (anonymous)"
    echo "  ✅ Performance metrics (load times)"
    echo "  ✅ Error rates (no sensitive data)"
    echo ""
    echo "What we NEVER collect:"
    echo "  ❌ Personal information (names, emails)"
    echo "  ❌ Code or file contents"
    echo "  ❌ Secrets or credentials"
    echo ""
    echo "You can disable metrics anytime by editing .ai/license.json"
    echo ""
    read -p "Enable optional metrics? (y/N): " metrics_consent

    if [[ "$metrics_consent" =~ ^[Yy]$ ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Update .gitignore to protect license file
update_gitignore() {
    local gitignore_file="$PROJECT_ROOT/.gitignore"

    # Check if .ai/license.json is already in .gitignore
    if [ -f "$gitignore_file" ]; then
        if ! grep -q ".ai/license.json" "$gitignore_file"; then
            echo "" >> "$gitignore_file"
            echo "# License activation (NEVER commit!)" >> "$gitignore_file"
            echo ".ai/license.json" >> "$gitignore_file"
            print_success "Updated .gitignore to protect license file"
        fi
    else
        print_warning ".gitignore not found - ensure .ai/license.json is never committed!"
    fi
}

# ==============================================================================
# MAIN SCRIPT
# ==============================================================================

main() {
    print_header

    # Parse arguments
    LICENSE_KEY=""
    NO_METRICS=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --key)
                LICENSE_KEY="$2"
                shift 2
                ;;
            --no-metrics)
                NO_METRICS=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --key KEY         Provide license key directly"
                echo "  --no-metrics      Disable optional metrics collection"
                echo "  --help            Show this help message"
                echo ""
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Check for existing license
    check_existing_license

    # Get license key (prompt if not provided via flag)
    if [ -z "$LICENSE_KEY" ]; then
        echo "Please enter your AI Workflow Rules license key."
        echo "Format: AWRF-XXXX-XXXX-XXXX-XXXX"
        echo ""
        read -p "License Key: " LICENSE_KEY
        echo ""
    fi

    # Validate license key format
    if ! validate_license_key "$LICENSE_KEY"; then
        exit 1
    fi

    print_success "License key format valid"

    # In production, verify license with server here
    # Example:
    # if ! verify_with_server "$LICENSE_KEY"; then
    #     print_error "License verification failed. Key may be invalid or revoked."
    #     exit 1
    # fi

    # Prompt for metrics consent
    print_info "Checking metrics preferences..."
    METRICS_ENABLED=$(prompt_metrics_consent "$NO_METRICS")

    if [ "$METRICS_ENABLED" == "true" ]; then
        print_success "Optional metrics enabled (thank you!)"
    else
        print_info "Optional metrics disabled (can enable later in .ai/license.json)"
    fi

    # Create license file
    echo ""
    print_info "Creating license activation file..."
    create_license_file "$LICENSE_KEY" "$METRICS_ENABLED"

    # Update .gitignore
    update_gitignore

    # Run authenticity verification (if script exists)
    echo ""
    if [ -f "$SCRIPT_DIR/verify-authenticity.sh" ]; then
        print_info "Running authenticity verification..."
        echo ""
        bash "$SCRIPT_DIR/verify-authenticity.sh"
    else
        print_warning "Authenticity verification script not found"
    fi

    # Success message
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_success "LICENSE ACTIVATED SUCCESSFULLY!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "License Details:"
    echo "  📄 License Key: ${LICENSE_KEY:0:9}****-****-****-****"
    echo "  📅 Activated: $(date)"
    echo "  📊 Metrics: $METRICS_ENABLED"
    echo ""
    echo "IMPORTANT:"
    echo "  ⚠️  DO NOT commit .ai/license.json to git"
    echo "  ⚠️  DO NOT share your license key"
    echo "  ℹ️  See LICENSE-METRICS.md for privacy policy"
    echo ""
    echo "Next Steps:"
    echo "  1. Review RULES_CORE.md for workflow guidelines"
    echo "  2. Review RULES_PRODUCT.md for product rules"
    echo "  3. Start using AI Workflow Rules in your projects!"
    echo ""
    echo "Support: support@[your-company].com"
    echo ""
}

# Run main function
main "$@"
