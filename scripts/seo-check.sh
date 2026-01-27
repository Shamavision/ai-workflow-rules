#!/bin/bash
# ==============================================================================
# SEO/GEO VERIFICATION SCRIPT
# AI Workflow Rules Framework v4.0
# ==============================================================================
#
# PURPOSE:
#   Verify SEO and GEO compliance for Ukrainian market projects
#
# USAGE:
#   ./scripts/seo-check.sh /path/to/client/project
#   ./scripts/seo-check.sh /path/to/client/project --verbose
#   ./scripts/seo-check.sh --help
#
# WHAT IT CHECKS:
#   1. robots.txt configuration (not blocking important pages)
#   2. HTML meta tags (lang="uk-UA", hreflang, charset)
#   3. LANG-CRITICAL violations (russian content)
#   4. Canonical URLs and sitemap
#   5. Open Graph / Twitter Cards (social media)
#   6. GEO targeting (Ukrainian market)
#   7. Performance hints (image optimization, next/image)
#   8. Russian tracking services (CRITICAL SECURITY)
#
# OUTPUT:
#   ✅ SEO OK - No issues
#   ⚠️  WARNINGS - Minor issues
#   ❌ CRITICAL - Must fix before deploy
#
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
WARNINGS=0
ERRORS=0

# Configuration
VERBOSE=false
PROJECT_PATH=""

# ==============================================================================
# FUNCTIONS
# ==============================================================================

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  SEO/GEO Verification${NC}"
    echo -e "${BLUE}  Ukrainian Market (UA)${NC}"
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
# SEO CHECKS
# ==============================================================================

# Check 1: robots.txt
check_robots_txt() {
    start_check "robots.txt"

    local robots_file="$PROJECT_PATH/public/robots.txt"

    # Check if file exists
    if [ ! -f "$robots_file" ]; then
        echo ""
        print_warning "robots.txt not found in public/"
        print_info "Create one to control search engine indexing"
        return 0
    fi

    # Check for common mistakes
    local issues_found=false

    # Mistake 1: Disallow all
    if grep -q "Disallow: /" "$robots_file" && ! grep -q "Allow:" "$robots_file"; then
        echo ""
        print_error "robots.txt blocks ALL pages (Disallow: /)"
        print_info "This prevents search engines from indexing your site!"
        issues_found=true
    fi

    # Mistake 2: No sitemap
    if ! grep -q "Sitemap:" "$robots_file"; then
        echo ""
        print_warning "No Sitemap declared in robots.txt"
        print_info "Add: Sitemap: https://yourdomain.com/sitemap.xml"
        issues_found=true
    fi

    if [ "$issues_found" == "false" ]; then
        print_success "robots.txt looks good"
    fi

    return 0
}

# Check 2: HTML Meta Tags
check_html_meta_tags() {
    start_check "HTML meta tags"

    # Find HTML files
    local html_files=$(find "$PROJECT_PATH" -name "*.html" -o -name "*.tsx" -o -name "*.jsx" 2>/dev/null | head -n 10)

    if [ -z "$html_files" ]; then
        echo ""
        print_warning "No HTML/JSX/TSX files found"
        print_info "If using Next.js, check app/ or pages/ directory"
        return 0
    fi

    local missing_lang=0
    local wrong_lang=0
    local missing_charset=0

    while IFS= read -r file; do
        # Check for lang attribute
        if ! grep -q 'lang=' "$file" 2>/dev/null; then
            ((missing_lang++))
        fi

        # Check for wrong language (russian)
        if grep -q 'lang="ru"' "$file" 2>/dev/null; then
            ((wrong_lang++))
            print_error "LANG-CRITICAL: Found lang=\"ru\" in $file"
        fi

        # Check for charset
        if ! grep -q 'charset=' "$file" 2>/dev/null && ! grep -q '<meta charSet=' "$file" 2>/dev/null; then
            ((missing_charset++))
        fi

    done <<< "$html_files"

    local issues=false

    if [ $missing_lang -gt 0 ]; then
        echo ""
        print_warning "$missing_lang file(s) missing lang attribute"
        print_info "Add: <html lang=\"uk-UA\">"
        issues=true
    fi

    if [ $wrong_lang -gt 0 ]; then
        echo ""
        print_error "LANG-CRITICAL: Russian language detected!"
        issues=true
    fi

    if [ $missing_charset -gt 0 ]; then
        echo ""
        print_warning "$missing_charset file(s) missing charset"
        print_info "Add: <meta charset=\"UTF-8\" />"
        issues=true
    fi

    if [ "$issues" == "false" ]; then
        print_success "Meta tags OK"
    fi

    return 0
}

# Check 3: LANG-CRITICAL (Russian content)
check_lang_critical() {
    start_check "LANG-CRITICAL violations"

    local violations_found=false

    # Check for .ru domains
    if grep -r "\.ru[^a-z]" "$PROJECT_PATH/src" "$PROJECT_PATH/app" "$PROJECT_PATH/public" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        echo ""
        print_error "LANG-CRITICAL: .ru domain found!"
        violations_found=true
    fi

    # Check for russian locales
    if grep -r "ru-RU\|ru_RU\|russian" "$PROJECT_PATH/src" "$PROJECT_PATH/app" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        echo ""
        print_error "LANG-CRITICAL: Russian locale found!"
        violations_found=true
    fi

    # Check for RUB currency
    if grep -r "RUB\|₽" "$PROJECT_PATH/src" "$PROJECT_PATH/app" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        echo ""
        print_error "LANG-CRITICAL: Russian currency found!"
        violations_found=true
    fi

    # Check for +7 phone prefix
    if grep -r '"+7 \|+7[0-9]' "$PROJECT_PATH/src" "$PROJECT_PATH/app" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        echo ""
        print_error "LANG-CRITICAL: Russian phone prefix found!"
        violations_found=true
    fi

    if [ "$violations_found" == "false" ]; then
        print_success "No LANG-CRITICAL violations"
    else
        print_info "See RULES_PRODUCT.md Section 3 for details"
    fi

    return 0
}

# Check 4: Canonical URLs & Sitemap
check_seo_structure() {
    start_check "SEO structure"

    local sitemap_found=false
    local canonical_found=false

    # Check for sitemap.xml
    if [ -f "$PROJECT_PATH/public/sitemap.xml" ]; then
        sitemap_found=true
    fi

    # Check for canonical tags in HTML
    if grep -r "rel=\"canonical\"" "$PROJECT_PATH" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        canonical_found=true
    fi

    if [ "$sitemap_found" == "true" ] && [ "$canonical_found" == "true" ]; then
        print_success "Sitemap and canonical URLs present"
    else
        echo ""
        if [ "$sitemap_found" == "false" ]; then
            print_warning "sitemap.xml not found in public/"
        fi
        if [ "$canonical_found" == "false" ]; then
            print_warning "No canonical tags found in HTML"
        fi
    fi

    return 0
}

# Check 5: Open Graph / Twitter Cards
check_social_meta() {
    start_check "social media meta tags"

    local og_found=false
    local twitter_found=false

    # Check for Open Graph tags
    if grep -r "og:title\|og:description\|og:image" "$PROJECT_PATH" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        og_found=true
    fi

    # Check for Twitter Cards
    if grep -r "twitter:card\|twitter:title" "$PROJECT_PATH" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        twitter_found=true
    fi

    if [ "$og_found" == "true" ] || [ "$twitter_found" == "true" ]; then
        print_success "Social meta tags present"
    else
        echo ""
        print_warning "No Open Graph or Twitter Card tags found"
        print_info "Add social meta tags for better sharing on social media"
    fi

    return 0
}

# Check 6: Ukrainian Market GEO Targeting
check_geo_targeting() {
    start_check "GEO targeting (UA market)"

    local geo_issues=false

    # Check for hreflang="uk-UA"
    if ! grep -r "hreflang=\"uk-UA\"\|hreflang=\"uk\"" "$PROJECT_PATH" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        echo ""
        print_warning "No hreflang=\"uk-UA\" found"
        print_info "Add: <link rel=\"alternate\" hreflang=\"uk-UA\" href=\"...\" />"
        geo_issues=true
    fi

    # Check for correct phone format (+380)
    if grep -r '"+380' "$PROJECT_PATH/src" "$PROJECT_PATH/app" 2>/dev/null | grep -v node_modules | head -n 1 > /dev/null; then
        if [ "$geo_issues" == "false" ]; then
            print_success "Ukrainian phone format found (+380)"
        fi
    else
        if [ "$geo_issues" == "false" ]; then
            echo ""
        fi
        print_warning "No +380 phone format found"
        geo_issues=true
    fi

    return 0
}

# Check 7: Performance (Basic)
check_performance_hints() {
    start_check "performance hints"

    local perf_issues=false

    # Check for large images (>500KB)
    local large_images=$(find "$PROJECT_PATH/public" -type f \( -name "*.jpg" -o -name "*.png" \) -size +500k 2>/dev/null | wc -l)

    if [ "$large_images" -gt 0 ]; then
        echo ""
        print_warning "$large_images large image(s) found (>500KB)"
        print_info "Optimize images for faster page load"
        perf_issues=true
    fi

    # Check for next/image usage (Next.js)
    if [ -d "$PROJECT_PATH/app" ] || [ -d "$PROJECT_PATH/pages" ]; then
        if grep -r "<img " "$PROJECT_PATH" 2>/dev/null | grep -v node_modules | grep -v "next/image" | head -n 1 > /dev/null; then
            if [ "$perf_issues" == "false" ]; then
                echo ""
            fi
            print_warning "Using <img> instead of next/image"
            print_info "Use next/image for automatic optimization"
            perf_issues=true
        fi
    fi

    if [ "$perf_issues" == "false" ]; then
        print_success "No obvious performance issues"
    fi

    return 0
}

# Check 8: Russian Tracking Services (CRITICAL SECURITY)
check_russian_trackers() {
    start_check "russian tracking services"

    # Russian tracking patterns (critical security threats)
    local TRACKER_PATTERNS=(
        # Analytics
        "metrika\\.yandex"
        "mc\\.yandex"
        "yaCounter"
        "ym\\("
        "webvisor"
        "top\\.mail\\.ru"
        "top-fwz1\\.mail\\.ru"
        "_tmr"
        "rambler.*counter"
        "liveinternet"
        "counter\\.yadro"

        # Social
        "vk\\.com/js/api"
        "vk\\.com/pixel"
        "VK\\.Retargeting"
        "VK\\.Goal"
        "ok\\.ru"
        "ODKL"

        # CDN
        "yastatic\\.net"
        "yandex\\.st"
        "imgsmail"
        "filin\\.mail"

        # Payments
        "yookassa"
        "kassa\\.yandex"
        "money\\.yandex"
        "qiwi\\."
        "webmoney"

        # Maps
        "api-maps\\.yandex"
        "ymaps"
        "2gis"

        # Video
        "rutube\\.ru"
        "vk.*video"
        "vkvideo"

        # E-commerce
        "wildberries"
        "wbstatic"
        "ozon\\.ru"

        # Fonts
        "fonts\\.yandex"

        # Captcha
        "smartcaptcha.*yandex"
    )

    local trackers_found=false
    local tracker_count=0

    # Find files to scan (HTML, JS, JSX, TSX)
    local files_to_scan=$(find "$PROJECT_PATH" -type f \( \
        -name "*.html" -o \
        -name "*.js" -o \
        -name "*.jsx" -o \
        -name "*.ts" -o \
        -name "*.tsx" \
    \) ! -path "*/node_modules/*" ! -path "*/.next/*" ! -path "*/dist/*" ! -path "*/build/*" 2>/dev/null)

    if [ -z "$files_to_scan" ]; then
        print_success "No files to scan"
        return 0
    fi

    # Scan for russian trackers
    while IFS= read -r file; do
        for pattern in "${TRACKER_PATTERNS[@]}"; do
            if grep -qE "$pattern" "$file" 2>/dev/null; then
                if [ "$trackers_found" == "false" ]; then
                    echo ""
                    trackers_found=true
                fi

                local line_num=$(grep -nE "$pattern" "$file" | head -n 1 | cut -d: -f1)
                local relative_path="${file#$PROJECT_PATH/}"

                print_error "RUSSIAN TRACKER: $relative_path:$line_num"
                print_info "Pattern: $pattern"
                ((tracker_count++))

                # Show context (first match only per file)
                break
            fi
        done
    done <<< "$files_to_scan"

    if [ "$trackers_found" == "true" ]; then
        echo ""
        echo -e "${RED}🚨 SECURITY THREAT: $tracker_count russian tracker(s) detected!${NC}"
        echo ""
        echo -e "${YELLOW}Why this is critical:${NC}"
        echo "  • User data sent to russian state servers"
        echo "  • Potential FSB/GRU surveillance"
        echo "  • GDPR violations (illegal data transfers)"
        echo "  • Sanctions risk"
        echo "  • Legal liability for Ukrainian businesses"
        echo ""
        echo -e "${GREEN}Safe alternatives:${NC}"
        echo "  Analytics:  Google Analytics 4, Plausible, Matomo"
        echo "  Social:     Facebook Pixel, LinkedIn Insight Tag"
        echo "  Payments:   Stripe, PayPal, WayForPay (UA), LiqPay (UA)"
        echo "  CDN:        Cloudflare, jsDelivr, unpkg"
        echo "  Maps:       Google Maps, OpenStreetMap, Mapbox"
        echo "  Video:      YouTube, Vimeo, Cloudflare Stream"
        echo ""
        echo -e "${BLUE}Migration guide:${NC}"
        echo "  See: .ai/forbidden-trackers.json for detailed alternatives"
        echo "  Typical migration time: 1-2 hours"
        echo ""
    else
        print_success "No russian trackers detected"
    fi

    return 0
}

# ==============================================================================
# VERDICT
# ==============================================================================

print_verdict() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "SEO/GEO VERIFICATION SUMMARY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Total Checks: $TOTAL_CHECKS"
    echo "Passed: $PASSED_CHECKS"
    echo "Warnings: $WARNINGS"
    echo "Errors: $ERRORS"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✅ VERDICT: SEO/GEO READY FOR PRODUCTION${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        exit 0

    elif [ $ERRORS -eq 0 ] && [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}⚠️  VERDICT: READY (with warnings)${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "Warnings should be addressed, but not blocking."
        echo ""
        exit 0

    else
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}❌ VERDICT: CRITICAL ISSUES - FIX BEFORE DEPLOY${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "Fix critical errors above before deploying to production."
        echo ""
        exit 1
    fi
}

# ==============================================================================
# MAIN
# ==============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help)
                echo "Usage: $0 [PROJECT_PATH] [OPTIONS]"
                echo ""
                echo "Arguments:"
                echo "  PROJECT_PATH    Path to client project (default: current directory)"
                echo ""
                echo "Options:"
                echo "  --verbose       Show detailed information"
                echo "  --help          Show this help"
                echo ""
                echo "Example:"
                echo "  ./scripts/seo-check.sh /path/to/client/project"
                echo "  ./scripts/seo-check.sh . --verbose"
                echo ""
                exit 0
                ;;
            *)
                PROJECT_PATH="$1"
                shift
                ;;
        esac
    done

    # Default to current directory if not specified
    if [ -z "$PROJECT_PATH" ]; then
        PROJECT_PATH="."
    fi

    # Resolve absolute path
    PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)

    print_header
    echo "Project: $PROJECT_PATH"
    echo ""

    # Run all checks
    check_robots_txt
    check_html_meta_tags
    check_lang_critical
    check_seo_structure
    check_social_meta
    check_geo_targeting
    check_performance_hints
    check_russian_trackers

    # Print verdict
    print_verdict
}

# Run main
main "$@"
