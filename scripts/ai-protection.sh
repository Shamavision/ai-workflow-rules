#!/bin/bash
# ==============================================================================
# AI PROTECTION SCRIPT - Bash Version
# AI Workflow Rules Framework v9.0
# ==============================================================================
#
# PURPOSE:
#   Protects AI assistants from leaking sensitive data through:
#   - Prompt injection detection (malicious AI instructions)
#   - PII scanning (.ai/ logs for emails, phones, IPNs)
#   - Directory protection (.ai/ must be in .gitignore)
#
# USAGE:
#   Called automatically by pre-commit hook
#   Can also be run manually: bash scripts/ai-protection.sh
#
# EXIT CODES:
#   0 = All checks passed
#   1 = Threats detected (fail-closed)
#
# ==============================================================================

set -e

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    CYAN=''
    NC=''
fi

# Config files
POLICY_FILE=".ai/ai-protection-policy.json"
PROMPT_PATTERNS=".ai/prompt-injection-patterns.json"
PII_PATTERNS=".ai/pii-patterns.json"
AUDIT_LOG=".ai/audit-trail.log"

# Flags
THREATS_FOUND=false
PROMPT_INJECTION_FOUND=false
PII_FOUND=false
GITIGNORE_VIOLATIONS=false

# ==============================================================================
# FUNCTIONS
# ==============================================================================

log_audit() {
    local event_type="$1"
    local details="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%SZ")

    if [ -d ".ai" ]; then
        echo "$timestamp | $event_type | $details" >> "$AUDIT_LOG"
    fi
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${CYAN}$1${NC}"
}

# ==============================================================================
# CHECK 1: Prompt Injection Detection
# ==============================================================================

check_prompt_injection() {
    echo -e "${CYAN}━━━ Checking for prompt injection...${NC}"

    if [ ! -f "$PROMPT_PATTERNS" ]; then
        print_warning "⚠  Prompt injection patterns file not found"
        return 0
    fi

    # Get staged files
    local staged_files=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || echo "")

    if [ -z "$staged_files" ]; then
        return 0
    fi

    # Critical patterns (simplified for bash)
    local patterns=(
        "(AI|SYSTEM|ASSISTANT|CLAUDE|GPT|GEMINI)[[:space:]]*(INSTRUCTION|OVERRIDE|COMMAND|DIRECTIVE)[[:space:]]*:"
        "ignore[[:space:]]+(all[[:space:]]+)?(previous|prior|earlier)[[:space:]]+(instructions?|rules?|prompts?)"
        "(bypass|disable|skip|ignore)[[:space:]]+(security|validation|check|protection)"
        "(add|insert|include)[[:space:]]+(API[[:space:]]+key|token|password|secret)"
    )

    # Whitelist patterns (docs, examples, tests)
    local whitelist_patterns=(
        "\.md$"
        "/docs/"
        "/examples/"
        "/test/"
        "\.test\."
        "\.spec\."
    )

    while IFS= read -r file; do
        # Skip binary files
        if file "$file" 2>/dev/null | grep -q "binary"; then
            continue
        fi

        # Skip if file doesn't exist
        if [ ! -f "$file" ]; then
            continue
        fi

        # Check whitelist
        local skip=false
        for whitelist in "${whitelist_patterns[@]}"; do
            if echo "$file" | grep -qE "$whitelist"; then
                skip=true
                break
            fi
        done

        if [ "$skip" = true ]; then
            continue
        fi

        # Scan for patterns
        for pattern in "${patterns[@]}"; do
            if grep -inE "$pattern" "$file" > /dev/null 2>&1; then
                local line_num=$(grep -inE "$pattern" "$file" | head -n 1 | cut -d: -f1)
                local matched_text=$(grep -inE "$pattern" "$file" | head -n 1 | cut -d: -f2- | head -c 80)

                print_error "🚨 PROMPT INJECTION detected in $file:$line_num"
                echo "   Pattern: $pattern"
                echo "   Text: $matched_text..."
                echo ""

                PROMPT_INJECTION_FOUND=true
                THREATS_FOUND=true

                log_audit "PROMPT_INJECTION" "$file:$line_num"
                break
            fi
        done

        if [ "$THREATS_FOUND" = true ]; then
            break
        fi
    done <<< "$staged_files"

    if [ "$PROMPT_INJECTION_FOUND" = false ]; then
        print_success "✓ No prompt injection detected"
    fi
}

# ==============================================================================
# CHECK 2: PII Detection in .ai/ Directory
# ==============================================================================

check_pii_in_ai_logs() {
    echo -e "${CYAN}━━━ Checking for PII in AI logs...${NC}"

    if [ ! -f "$PII_PATTERNS" ]; then
        print_warning "⚠  PII patterns file not found"
        return 0
    fi

    # Files to scan
    local scan_files=(
        ".ai/token-limits.json"
        ".ai/audit-trail.log"
    )

    # PII patterns (simplified for bash)
    local email_pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
    local phone_ua_pattern="\+380[0-9]{9}"
    local ipn_pattern="[0-9]{10}"

    for scan_file in "${scan_files[@]}"; do
        if [ ! -f "$scan_file" ]; then
            continue
        fi

        # Check for emails
        if grep -oE "$email_pattern" "$scan_file" 2>/dev/null | grep -v "example.com\|test.com\|noreply@" > /dev/null; then
            local count=$(grep -oE "$email_pattern" "$scan_file" | grep -v "example.com\|test.com\|noreply@" | wc -l | tr -d ' ')
            if [ "$count" -gt 0 ]; then
                print_warning "⚠  PII detected in $scan_file: $count email(s)"
                PII_FOUND=true
                log_audit "PII_DETECTED" "$scan_file (emails: $count)"
            fi
        fi

        # Check for Ukrainian phones
        if grep -oE "$phone_ua_pattern" "$scan_file" > /dev/null 2>&1; then
            local count=$(grep -oE "$phone_ua_pattern" "$scan_file" | wc -l | tr -d ' ')
            print_warning "⚠  PII detected in $scan_file: $count Ukrainian phone(s)"
            PII_FOUND=true
            log_audit "PII_DETECTED" "$scan_file (phones: $count)"
        fi
    done

    if [ "$PII_FOUND" = false ]; then
        print_success "✓ No PII detected in AI logs"
    else
        print_warning ""
        print_warning "⚠  PII found in AI logs (non-blocking warning)"
        print_warning "   Recommendation: Review and redact manually"
        print_warning "   Or run: //PII-SCAN --redact"
        print_warning ""
    fi
}

# ==============================================================================
# CHECK 3: .ai/ Directory Protection
# ==============================================================================

check_ai_directory_protection() {
    echo -e "${CYAN}━━━ Checking .ai/ directory protection...${NC}"

    # Required entries in .gitignore
    local required_entries=(
        ".ai/audit-trail.log"
        ".ai/.ai-protection-cache/"
        "ai-logs/"
    )

    if [ ! -f ".gitignore" ]; then
        print_error "❌ .gitignore not found"
        print_error "   Create .gitignore and add:"
        for entry in "${required_entries[@]}"; do
            echo "   $entry"
        done
        GITIGNORE_VIOLATIONS=true
        THREATS_FOUND=true
        return 1
    fi

    for entry in "${required_entries[@]}"; do
        if ! grep -q "^${entry}$" .gitignore 2>/dev/null; then
            print_error "❌ Missing in .gitignore: $entry"
            GITIGNORE_VIOLATIONS=true
            THREATS_FOUND=true
        fi
    done

    # Check if .ai/ sensitive files are staged
    local staged_files=$(git diff --cached --name-only 2>/dev/null || echo "")

    local blocked_files=(
        ".ai/audit-trail.log"
        ".ai/.ai-protection-cache/"
        "ai-logs/"
    )

    while IFS= read -r file; do
        for blocked in "${blocked_files[@]}"; do
            if echo "$file" | grep -q "^${blocked}"; then
                print_error "❌ Blocked file staged: $file"
                print_error "   This file must be in .gitignore"
                GITIGNORE_VIOLATIONS=true
                THREATS_FOUND=true
            fi
        done
    done <<< "$staged_files"

    if [ "$GITIGNORE_VIOLATIONS" = false ]; then
        print_success "✓ .ai/ directory properly protected"
    fi
}

# ==============================================================================
# MAIN
# ==============================================================================

main() {
    # Check if AI protection is enabled
    if [ ! -f "$POLICY_FILE" ]; then
        # Policy file missing - graceful fallback
        echo "⚠  AI Protection not configured (.ai/ai-protection-policy.json missing)"
        echo "   Run: npx @shamavision/ai-workflow-rules@9.0.0 init"
        exit 0
    fi

    echo ""
    echo "🤖 AI Protection v9.0"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Run checks
    check_prompt_injection
    check_pii_in_ai_logs
    check_ai_directory_protection

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Final verdict
    if [ "$THREATS_FOUND" = true ]; then
        echo ""
        print_error "❌ AI PROTECTION FAILED"
        echo ""
        echo "Threats detected:"

        if [ "$PROMPT_INJECTION_FOUND" = true ]; then
            echo "  - Prompt injection attempts"
        fi

        if [ "$GITIGNORE_VIOLATIONS" = true ]; then
            echo "  - .ai/ directory violations"
        fi

        if [ "$PII_FOUND" = true ]; then
            echo "  - PII in AI logs (warning only)"
        fi

        echo ""
        echo "Fix issues above before committing."
        echo ""

        log_audit "AI_PROTECTION_FAILED" "Threats detected"
        exit 1
    else
        echo ""
        print_success "✅ AI PROTECTION PASSED"
        echo ""
        log_audit "AI_PROTECTION_PASSED" "All checks passed"
        exit 0
    fi
}

# Run main
main
