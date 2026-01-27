#!/bin/bash
# ==============================================================================
# AUTHENTICITY VERIFICATION SCRIPT
# AI Workflow Rules Framework v4.0
# ==============================================================================
#
# PURPOSE:
#   Verify that this is a legitimate, unmodified copy of AI Workflow Rules
#
# USAGE:
#   ./scripts/verify-authenticity.sh
#   ./scripts/verify-authenticity.sh --verbose
#   ./scripts/verify-authenticity.sh --update-checksums  (internal use only)
#
# WHAT IT CHECKS:
#   1. SHA-256 checksums of critical files (RULES_CORE.md, LICENSE, etc.)
#   2. Presence of required files
#   3. License activation status
#   4. Git repository integrity (if applicable)
#
# OUTPUT:
#   ✅ AUTHENTIC - All checks passed
#   ⚠️  WARNING - Minor issues detected
#   ❌ COUNTERFEIT - Critical issues, likely tampered or unauthorized
#
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKSUMS_FILE="$PROJECT_ROOT/.ai/checksums.sha256"

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
WARNINGS=0
ERRORS=0

# Verbose mode
VERBOSE=false

# ==============================================================================
# FUNCTIONS
# ==============================================================================

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Authenticity Verification${NC}"
    echo -e "${BLUE}  AI Workflow Rules v4.0${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((PASSED_CHECKS++))
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

print_info() {
    if [ "$VERBOSE" == "true" ]; then
        echo -e "${BLUE}ℹ️  $1${NC}"
    fi
}

start_check() {
    local check_name="$1"
    ((TOTAL_CHECKS++))
    echo -n "[$TOTAL_CHECKS] Checking $check_name... "
}

# ==============================================================================
# VERIFICATION CHECKS
# ==============================================================================

# Check 1: Required Files Exist
check_required_files() {
    start_check "required files"

    local required_files=(
        "RULES_CORE.md"
        "RULES_PRODUCT.md"
        "LICENSE"
        "LICENSE-METRICS.md"
        "CERTIFICATE.md"
        "TRADEMARK.md"
        "README.md"
        ".ai/token-limits.json"
        ".ai/locale-context.json"
    )

    local missing_files=()

    for file in "${required_files[@]}"; do
        if [ ! -f "$PROJECT_ROOT/$file" ]; then
            missing_files+=("$file")
        fi
    done

    if [ ${#missing_files[@]} -eq 0 ]; then
        print_success "All required files present"
        return 0
    else
        echo ""
        print_error "Missing required files:"
        for file in "${missing_files[@]}"; do
            echo "   - $file"
        done
        return 1
    fi
}

# Check 2: SHA-256 Checksums
check_file_integrity() {
    start_check "file integrity (SHA-256)"

    # If checksums file doesn't exist, warn but don't fail
    if [ ! -f "$CHECKSUMS_FILE" ]; then
        echo ""
        print_warning "Checksums file not found (.ai/checksums.sha256)"
        print_info "Run with --update-checksums to generate (internal use only)"
        return 0
    fi

    # Verify checksums
    cd "$PROJECT_ROOT"
    local failed=false

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        # Parse line: checksum filename
        local expected_checksum=$(echo "$line" | awk '{print $1}')
        local filename=$(echo "$line" | awk '{print $2}')

        if [ ! -f "$filename" ]; then
            print_warning "File missing: $filename"
            failed=true
            continue
        fi

        # Calculate actual checksum
        local actual_checksum
        if command -v sha256sum &> /dev/null; then
            actual_checksum=$(sha256sum "$filename" | awk '{print $1}')
        elif command -v shasum &> /dev/null; then
            actual_checksum=$(shasum -a 256 "$filename" | awk '{print $1}')
        else
            print_warning "No SHA-256 tool available (sha256sum or shasum)"
            return 0
        fi

        # Compare checksums
        if [ "$expected_checksum" != "$actual_checksum" ]; then
            echo ""
            print_error "Checksum mismatch: $filename"
            print_info "Expected: $expected_checksum"
            print_info "Actual:   $actual_checksum"
            failed=true
        fi
    done < "$CHECKSUMS_FILE"

    if [ "$failed" == "false" ]; then
        print_success "All checksums valid"
        return 0
    else
        return 1
    fi
}

# Check 3: License Activation
check_license_activation() {
    start_check "license activation"

    local license_file="$PROJECT_ROOT/.ai/license.json"

    if [ ! -f "$license_file" ]; then
        echo ""
        print_warning "License not activated"
        print_info "Run: ./scripts/activate-license.sh"
        return 0
    fi

    # Validate license file structure
    if ! grep -q '"license_key"' "$license_file" 2>/dev/null; then
        echo ""
        print_error "Invalid license file structure"
        return 1
    fi

    # Extract license key (first 9 chars)
    local license_key=$(grep '"license_key"' "$license_file" | cut -d'"' -f4 | head -c 9)

    print_success "License activated (${license_key}****)"
    return 0
}

# Check 4: Git Repository Integrity (if applicable)
check_git_integrity() {
    start_check "git repository integrity"

    if [ ! -d "$PROJECT_ROOT/.git" ]; then
        print_info "Not a git repository (OK)"
        return 0
    fi

    # Check if this is the official repository
    cd "$PROJECT_ROOT"

    # Get remote URL (if exists)
    local remote_url=$(git remote get-url origin 2>/dev/null || echo "")

    if [ -z "$remote_url" ]; then
        print_warning "No git remote configured"
        return 0
    fi

    # Check if it's from an authorized source
    # In real implementation, verify against known official repository URLs
    print_success "Git repository present"
    print_info "Remote: $remote_url"
    return 0
}

# Check 5: Copyright Notices
check_copyright_notices() {
    start_check "copyright notices"

    local files_to_check=(
        "LICENSE"
        "README.md"
    )

    local missing_copyright=()

    for file in "${files_to_check[@]}"; do
        local filepath="$PROJECT_ROOT/$file"
        if [ -f "$filepath" ]; then
            if ! grep -q "Copyright" "$filepath" 2>/dev/null; then
                missing_copyright+=("$file")
            fi
        fi
    done

    if [ ${#missing_copyright[@]} -eq 0 ]; then
        print_success "Copyright notices intact"
        return 0
    else
        echo ""
        print_error "Missing copyright notices in:"
        for file in "${missing_copyright[@]}"; do
            echo "   - $file"
        done
        return 1
    fi
}

# Check 6: Trademark Protection
check_trademark_presence() {
    start_check "trademark protection"

    if [ -f "$PROJECT_ROOT/TRADEMARK.md" ]; then
        if grep -q "AI Workflow Rules" "$PROJECT_ROOT/TRADEMARK.md" 2>/dev/null; then
            print_success "Trademark file valid"
            return 0
        else
            print_error "TRADEMARK.md corrupted"
            return 1
        fi
    else
        print_error "TRADEMARK.md missing"
        return 1
    fi
}

# Check 7: Suspicious Files (common malware patterns)
check_suspicious_files() {
    start_check "suspicious files"

    local suspicious_patterns=(
        "*.exe"
        "*.dll"
        "*.so"
        "*.dylib"
        "malware*"
        "*backdoor*"
        "*keylog*"
    )

    local suspicious_found=()

    for pattern in "${suspicious_patterns[@]}"; do
        while IFS= read -r file; do
            suspicious_found+=("$file")
        done < <(find "$PROJECT_ROOT" -name "$pattern" -type f 2>/dev/null)
    done

    if [ ${#suspicious_found[@]} -eq 0 ]; then
        print_success "No suspicious files detected"
        return 0
    else
        echo ""
        print_warning "Suspicious files found (may be false positive):"
        for file in "${suspicious_found[@]}"; do
            echo "   - $file"
        done
        return 0
    fi
}

# ==============================================================================
# CHECKSUM MANAGEMENT (Internal Use)
# ==============================================================================

generate_checksums() {
    echo "Generating checksums for critical files..."

    local files_to_hash=(
        "RULES_CORE.md"
        "RULES_PRODUCT.md"
        "LICENSE"
        "LICENSE-METRICS.md"
        "CERTIFICATE.md"
        "TRADEMARK.md"
        "scripts/activate-license.sh"
        "scripts/verify-authenticity.sh"
    )

    mkdir -p "$PROJECT_ROOT/.ai"

    echo "# AI Workflow Rules v4.0 - SHA-256 Checksums" > "$CHECKSUMS_FILE"
    echo "# Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> "$CHECKSUMS_FILE"
    echo "# DO NOT MODIFY THIS FILE" >> "$CHECKSUMS_FILE"
    echo "" >> "$CHECKSUMS_FILE"

    cd "$PROJECT_ROOT"

    for file in "${files_to_hash[@]}"; do
        if [ -f "$file" ]; then
            if command -v sha256sum &> /dev/null; then
                sha256sum "$file" >> "$CHECKSUMS_FILE"
            elif command -v shasum &> /dev/null; then
                shasum -a 256 "$file" >> "$CHECKSUMS_FILE"
            else
                echo "Error: No SHA-256 tool available"
                exit 1
            fi
        fi
    done

    echo "Checksums generated: $CHECKSUMS_FILE"
}

# ==============================================================================
# FINAL VERDICT
# ==============================================================================

print_verdict() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "VERIFICATION SUMMARY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Total Checks: $TOTAL_CHECKS"
    echo "Passed: $PASSED_CHECKS"
    echo "Warnings: $WARNINGS"
    echo "Errors: $ERRORS"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✅ VERDICT: AUTHENTIC${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "This appears to be a legitimate copy of AI Workflow Rules."
        echo ""
        exit 0

    elif [ $ERRORS -eq 0 ] && [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}⚠️  VERDICT: LIKELY AUTHENTIC (with warnings)${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "Minor issues detected. Review warnings above."
        echo "If you obtained this from an authorized source, it's likely OK."
        echo ""
        exit 0

    else
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}❌ VERDICT: SUSPICIOUS / COUNTERFEIT${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "⚠️  CRITICAL ISSUES DETECTED!"
        echo ""
        echo "This copy may be:"
        echo "  • Tampered or modified"
        echo "  • Counterfeit or unauthorized"
        echo "  • Corrupted during transfer"
        echo ""
        echo "RECOMMENDATIONS:"
        echo "  1. DO NOT use this copy for production work"
        echo "  2. Obtain a legitimate copy from official source"
        echo "  3. Report counterfeit: legal@[your-company].com"
        echo ""
        echo "Official source: https://[your-company].com"
        echo ""
        exit 1
    fi
}

# ==============================================================================
# MAIN SCRIPT
# ==============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                VERBOSE=true
                shift
                ;;
            --update-checksums)
                generate_checksums
                exit 0
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --verbose             Show detailed information"
                echo "  --update-checksums    Generate checksums (internal use only)"
                echo "  --help                Show this help"
                echo ""
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage"
                exit 1
                ;;
        esac
    done

    print_header

    # Run all checks
    check_required_files
    check_file_integrity
    check_license_activation
    check_git_integrity
    check_copyright_notices
    check_trademark_presence
    check_suspicious_files

    # Print final verdict
    print_verdict
}

# Run main
main "$@"
