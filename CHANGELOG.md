# Changelog

All notable changes to AI Workflow Rules Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
