# Changelog

All notable changes to AI Workflow Rules Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [9.1.0] - 2026-02-07

### 🚀 Changed - Token Optimization (Evolution, Not Revolution)

**Major Release:** 30-40% overall token savings through intelligent management and optimization.

**Philosophy:** Evolution over revolution. Quality > Speed. No overengineering. Preserve all protections.

**Context Size Reductions:**
- **Minimal:** 13k → 10k (-23%, -3k tokens)
- **Standard:** 18k → 14k (-22%, -4k tokens)
- **Ukraine-full:** 25k → 18k (-28%, -7k tokens)
- **Enterprise:** 30k → 23k (-23%, -7k tokens)

**How we achieved it:**
- ✅ Removed repetition
- ✅ Concise writing (active voice, shorter sentences)
- ✅ Tables instead of verbose lists
- ✅ Smarter organization
- ✅ **Zero feature loss** (all protections intact)

### 🆕 Added - Enhanced Compression System

**Multi-Level Compression (AI-ENFORCEMENT.md v2.0):**
- **Level 1 (Light):** 50-70% tokens → saves 40%
- **Level 2 (Aggressive):** 70-90% tokens → saves 60%
- **Level 3 (Maximum):** 90%+ tokens → saves 70%

**5 Automatic Triggers:**
1. After `git push origin <branch>` (ALWAYS)
2. After session reaches 50% tokens (100k/200k)
3. After completing major task (user confirms)
4. Before starting new major task
5. After 15+ messages in current thread

**Auto-Level Selection:**
- Session 50-70% → Level 1 (Light)
- Session 70-90% → Level 2 (Aggressive)
- Session 90%+ → Level 3 (Maximum)

**Proactive Suggestions:**
- At 25% (50k): Suggest compression after current task
- At 50% (100k): Recommend compression now
- At 70% (140k): Auto-switch to brief mode + warning
- At 90% (180k): Critical warning + finalize recommendation

### 🆕 Added - Session Management Best Practices

**New Guide:** `.ai/SESSION_MANAGEMENT.md` (~405 lines)

**Key Insights:**
- Session restart costs 18-25k tokens
- 50% fewer restarts = 35-50k tokens/day saved
- Continue vs restart decision guide
- Platform-specific tips (VSCode, Cursor, Windsurf)

**When to CONTINUE (not restart):**
- ✅ Minor code changes, bug fixes
- ✅ Working through roadmap stages
- ✅ After using `//COMPACT`
- ✅ Tokens <90% and task ongoing

**When to RESTART:**
- 🔄 Pushed to main (major milestone)
- 🔄 Tokens >90% (budget critical)
- 🔄 Switching to different feature
- 🔄 Next day, different context

**Expected savings:** 50% reduction in unnecessary restarts

### 🆕 Added - Token Dashboard & Utilities

**Token Status Dashboard:**
- `scripts/token-status.sh` - Bash version (Linux, macOS, Git Bash)
- `scripts/token-status.ps1` - PowerShell version (Windows)
- Shows: daily/monthly usage, zone indicators (🟢/🟡/🟠/🔴), projections, recommendations
- Context optimization tips included

**Token Estimation Utility:**
- `scripts/estimate-tokens.sh` - Estimates tokens from files/stdin
- Uses ~4 chars = 1 token rule (Claude tokenizer average)
- Verbose mode with detailed breakdown
- Context comparison (% of session limit)

**NPM Scripts:**
```json
{
  "scripts": {
    "token-status": "bash scripts/token-status.sh || pwsh scripts/token-status.ps1",
    "estimate-tokens": "bash scripts/estimate-tokens.sh",
    "providers": "cat .ai/docs/provider-comparison.md"
  }
}
```

### 🆕 Added - Comprehensive Provider Database

**File:** `.ai/token-limits.json` updated with complete provider data

**Coverage:** 9 providers, 25+ plans with full details
- **Anthropic (Claude):** API + claude.ai (Free/Pro/Team)
- **Google (Gemini):** API + Gemini (Free/Advanced)
- **Cursor:** Free/Pro/Business
- **GitHub Copilot:** Individual/Business/Enterprise
- **Mistral:** API (Large/Medium/Small)
- **Groq:** Free tier
- **DeepSeek:** API (ultra-cheap)
- **Perplexity:** Free/Pro
- **Windsurf (Codeium):** Free/Enterprise

**Data includes:**
- Monthly/daily/session limits
- Pricing ($/month, per 1M tokens input/output)
- Rate limiting type (hard/soft/fair use)
- Notes, recommendations, sources
- Last updated: 2026-02-07

**New Guide:** `.ai/docs/provider-comparison.md` (~900 lines)
- Quick comparison table
- Recommendations by use case
- Cost calculator
- Decision matrix
- Migration tips

### 🆕 Added - Smart Context Selection

**Enhanced installers with recommendation engine:**
- `bin/cli.js` - Interactive questionnaire
- `scripts/install.sh` - Bash version
- `scripts/install.ps1` - PowerShell version

**Features:**
- 3 questions: team size, market (Ukrainian/International), token priority
- Personalized recommendations based on answers
- Visual comparison table during installation
- Manual override option available

**Example:**
```
Team size: 1-2 developers
Market: Ukrainian
Token priority: High

→ Recommended: ukraine-full (~18k tokens, 9% of daily)
Reasoning:
  • Ukrainian market needs full compliance features
  • Token efficiency prioritized
```

### 📊 Impact Analysis

**Typical session savings (ukraine-full context):**
```
v9.0:
- Session start: 25k tokens
- Work (15 messages): 75k tokens
- Total: 100k tokens

v9.1:
- Session start: 18k tokens (-7k)
- Work with better compression: 60k tokens (-15k)
- Total: 78k tokens (-22k, -22% savings)
```

**Better practices → fewer restarts:**
```
v9.0: 4 restarts/day × 25k = 100k overhead
v9.1: 2 restarts/day × 18k = 36k overhead
Savings: 64k tokens/day from session management alone
```

**Combined savings: 30-40% overall token usage**

### 🔧 Changed

**Files Updated:**
- `.ai/AI-ENFORCEMENT.md` → v2.0 (Enhanced Compression)
- `.ai/token-limits.json` → Comprehensive provider database
- `.ai/contexts/minimal.context.md` → Optimized (-23%)
- `.ai/contexts/standard.context.md` → Optimized (-22%)
- `.ai/contexts/ukraine-full.context.md` → Optimized (-28%)
- `.ai/contexts/enterprise.context.md` → Optimized (-23%)
- `.claude/CLAUDE.md` → Updated with v9.1 token counts
- `README.md` → Added v9.1 features section
- `package.json` → Added npm scripts for token management

**Files Created:**
- `.ai/SESSION_MANAGEMENT.md` - Session best practices guide
- `.ai/docs/provider-comparison.md` - Comprehensive provider guide
- `scripts/token-status.sh` - Token dashboard (bash)
- `scripts/token-status.ps1` - Token dashboard (PowerShell)
- `scripts/estimate-tokens.sh` - Token estimation utility

### ✅ Preserved - Zero Breaking Changes

**ALL systems intact:**
- ✅ All 6 protection layers (client/user/business/AI)
- ✅ Universal AI tool support (Claude/Cursor/Windsurf/Continue)
- ✅ Cross-platform compatibility (Linux/macOS/Windows)
- ✅ Security systems (pre-commit, AI Protection, PII detection)
- ✅ Backward compatible (existing users unaffected)

**Migration:** Automatic - contexts updated in place. No user action required.

### 🎯 Philosophy

**v9.1 Principles:**
- Evolution, not revolution
- Quality > Speed
- No overengineering (rejected Smart Contexts v10.0 approach)
- Focus on real pain points, not theoretical optimization
- Aligned with industry best practices 2026

**Made in Ukraine 🇺🇦**

---

## [9.0.0] - 2026-02-07

### 🛡️ Added - AI Protection System

**New Major Feature:** Comprehensive AI protection against prompt injection and PII leaks.

- **Prompt Injection Detection**
  - 10 critical attack patterns (system override, jailbreak, data exfiltration, etc.)
  - Context-aware whitelist (docs, tests, examples auto-excluded)
  - Intelligent false positive reduction
  - `.ai/prompt-injection-patterns.json` - Full pattern library

- **PII Protection (GDPR-Ready)**
  - Auto-detects: emails, phones, IPs, API keys, Ukrainian IPN/passports
  - Auto-redaction with backup
  - Scans `.ai/` directory and AI logs
  - `.ai/pii-patterns.json` - Ukrainian market focus

- **Directory Protection**
  - Validates `.ai/` gitignore configuration
  - Prevents `ai-logs/` commits (full conversation logs)
  - Protects `.claude/cache/` and sensitive files

- **Cross-Platform Scripts**
  - `scripts/ai-protection.sh` (Linux, macOS, Git Bash)
  - `scripts/ai-protection.ps1` (Windows PowerShell)
  - `scripts/ai-protection.js` (Node.js, universal)

- **Integration**
  - Auto-runs in pre-commit hook (after Tier 1/2/3 checks)
  - Fail-closed by default (secure)
  - Backward compatible (graceful fallback if missing)

- **Configuration**
  - `.ai/ai-protection-policy.json` - Master config
  - 3 modes: strict, balanced (default), permissive
  - Bypass: `// ai-protection-ignore` or `.ai-protection-ignore` file

- **Documentation**
  - `.ai/THREAT_MODEL.md` - Security analysis
  - `.ai/DISCLAIMERS.md` - Legal framework

### 🔧 Fixed

- **Tier 3 Whitelist:** Added AI Protection pattern files to prevent false positives:
  - `.ai/ai-protection-policy.json`
  - `.ai/prompt-injection-patterns.json`
  - `.ai/pii-patterns.json`

### 🚀 Changed

- **Installers Updated (v9.0)**
  - `scripts/install.sh` - Added AI Protection info
  - `scripts/install.ps1` - Added AI Protection info
  - `bin/cli.js` - Updated to v9.0 with new features

- **Pre-commit Hook:** Now includes AI Protection as 4th layer (after Tier 1/2/3)

### 📚 Technical Details

**Philosophy:** "Silent Guardian" - Protect without blocking productivity

**Approach:** Defense in Depth + Fail-Closed + Context-Aware

**Supported AI Assistants:**
- Claude Code, Cursor, Windsurf, Aider, Continue.dev
- GitHub Copilot, ChatGPT, Gemini Code Assist
- All generic AI coding tools

**Performance:** +1-5 seconds to pre-commit (negligible impact)

**Ukrainian Market Focus:**
- GDPR compliance tools (not certification)
- Ukrainian PII patterns (IPN, passport, IBAN)
- Zero russian services policy (inherited from v8.3)

---

## [8.3.0] - 2026-02-04

### Added
- Universal cross-platform compatibility
- Enhanced security with 3-tier protection
- Russian tracker detection (Ukrainian market policy)

---

## [8.1.0] - 2026-02-03

### Added
- Modular context system (minimal, standard, ukraine-full, enterprise)
- Token efficiency (40-70% savings for international users)
- Smart context selection wizard

---

## [8.0.0] - 2026-01-28

### Added
- Complete framework rewrite
- Token management v2.0
- Roadmap-driven development workflow
- Multi-language support

---

## Earlier Versions

See git history for versions < 8.0

---

**Made in Ukraine 🇺🇦**
