# Roadmap - Comprehensive Framework Audit

> **Comprehensive Quality & Consistency Audit**
> **Version:** v9.1.1 (no version change)
> **Status:** Phase 1 COMPLETE → Phases 2-8 In Progress

**Last Updated:** 2026-02-13
**Philosophy:** Quality > Speed | Think Harder | No Overengineering
**Strategy:** Variant 2 (Safe) - 3 days total, thorough approach

---

## 🎯 Audit Objective

Провести **систематическую проверку** всех компонентов фреймворка:

**Цели:**
- ✅ Проверить синхронизацию npm-templates с dev-версией
- ✅ Убедиться, что .gitignore защищает все критические файлы
- ✅ Валидировать пути (paths) - нет битых ссылок
- ✅ Проверить версии - нет расхождений
- ✅ Протестировать scripts - все работают
- ✅ Валидировать документацию - полнота, точность
- ✅ Проверить wizard (bin/cli.js) - копирует все нужные файлы
- ✅ Убедиться "система работает как часики"

**Принципы:**
- Не торопимся - разбиваем на фазы
- Высокая концентрация - внимание к деталям
- Think harder - проверяем, не предполагаем
- Token-conscious - не превышаем daily limit

---

## 📋 Audit Phases (8 Phases)

### **Phase 1: npm-templates Sync Audit** ✅ **COMPLETE**

**Цель:** Убедиться, что npm-templates синхронизированы с dev

**Status:** ✅ **PASSED** (2026-02-13)

**Проверки:**
- [x] Compare all files: `.ai/contexts/*.context.md` - 4 files synced
- [x] Compare: `.ai/AI-ENFORCEMENT.md` - 223 lines synced
- [x] Compare: `.ai/docs/*.md` (9 files) - 6 files synced
- [x] Compare: `.ai/rules/*.md` (2 files) - already in sync
- [x] Compare: `.claude/CLAUDE.md` - 206 lines synced
- [x] Compare: `.cursorrules`, `.windsurfrules` - both synced
- [x] Compare: `.ai/config.json`, `token-limits.json`, `forbidden-trackers.json` - token-limits.json synced (388 lines)
- [x] Compare: hooks (`user-prompt-submit.sh`) - already in sync
- [x] Run: `npm run verify-templates` → ✅ PASSED (22/22 files in sync)
- [x] List files ONLY in npm-templates (unexpected extras) - 6 intentional extras (settings.json, editorconfig, scripts)
- [x] List files ONLY in dev (missing from templates) - none

**Result:**
- ✅ All 22 tracked files 100% in sync
- ✅ 15/22 files were out of sync → fixed
- ✅ verify-templates.sh passes
- ✅ npm-templates ready for distribution

**Actual Token Usage:** ~96k (detailed diffs + analysis + verification)
**Original Estimate:** ~8-12k
**Lesson Learned:** Quality > Speed approach requires 8-10x more tokens for thorough audit

---

### **Phase 2: .gitignore Security Audit** (~5-8k tokens)

**Цель:** Убедиться, что .gitignore защищает все секреты

**Проверки:**
- [ ] Check `.ai/` sensitive files protected:
  - [ ] `.ai/.session-started` (temp marker)
  - [ ] `.ai/audit-trail.log` (local only)
  - [ ] `.ai/.ai-protection-cache/` (cache)
  - [ ] `.ai/.backups/` (backups)
  - [ ] `.ai/.pii-scan-summary.json` (scan results)
- [ ] Check user secrets protected:
  - [ ] `.env`, `.env.local`, `.env.*.local`
  - [ ] `*.key`, `*.pem`, `*.p12`
  - [ ] `.DS_Store`, `Thumbs.db`
- [ ] Check logs protected:
  - [ ] `*.log` (except specific allowed)
  - [ ] `npm-debug.log*`, `yarn-debug.log*`
- [ ] Check no tracked files violate .gitignore
- [ ] Test: Create `.env` with fake secret → git status → should be ignored

**Expected Result:**
- ✅ All sensitive patterns ignored
- ✅ No tracked files violate rules
- ✅ Test confirms protection works

**Token Estimate:** ~5-8k (file checks, tests)

---

### **Phase 3: Paths & References Audit** (~10-15k tokens)

**Цель:** Проверить все пути - нет битых ссылок

**Проверки:**
- [ ] **Documentation links:**
  - [ ] Run `npm run check-links` → все ✅
  - [ ] Manually verify critical paths in README.md
  - [ ] Check `.ai/docs/` cross-references
- [ ] **File paths in code:**
  - [ ] `bin/cli.js` - все пути к npm-templates корректны
  - [ ] `scripts/sync-rules.sh` - пути к contexts, IDE configs
  - [ ] `scripts/verify-templates.sh` - список sync files актуален
- [ ] **Import paths in scripts:**
  - [ ] Check all `require()` paths in .js files
  - [ ] Check all `source` paths in .sh files
- [ ] **IDE config paths:**
  - [ ] `.claude/CLAUDE.md` - ссылки на `.ai/`
  - [ ] `.cursorrules` - ссылки на `.ai/`
  - [ ] `.windsurfrules` - ссылки на `.ai/`

**Expected Result:**
- ✅ Zero broken links
- ✅ All file references valid
- ✅ All import paths correct

**Token Estimate:** ~10-15k (grep, reads, validation)

---

### **Phase 4: Version Consistency Audit** (~5-8k tokens)

**Цель:** Проверить версии - нет расхождений

**Проверки:**
- [ ] `package.json` version = "9.1.1"
- [ ] Check all docs mention correct version:
  - [ ] README.md
  - [ ] CHANGELOG.md (latest entry)
  - [ ] .ai/docs/*.md (where applicable)
  - [ ] AGENTS.md
- [ ] Check contexts mention correct version:
  - [ ] All `*.context.md` headers
- [ ] Check scripts version comments:
  - [ ] `scripts/*.sh` headers
- [ ] Check no hardcoded old versions (9.0, 9.1, etc.)

**Expected Result:**
- ✅ All version references = 9.1.1
- ✅ No outdated version strings

**Token Estimate:** ~5-8k (grep, checks)

---

### **Phase 5: Scripts Functionality Audit** (~12-18k tokens)

**Цель:** Протестировать все scripts - работают ли

**Проверки (dry-run где возможно):**
- [ ] **Validation scripts:**
  - [ ] `npm run check-links` → runs without error
  - [ ] `npm run validate-structure` → passes (or shows expected warnings)
  - [ ] `npm run verify-templates` → we know status from Phase 1
- [ ] **Token scripts:**
  - [ ] `npm run token-status` → displays correct format
  - [ ] `npm run token-log status` → works
  - [ ] `npm run session current` → handles no active session
- [ ] **Utility scripts:**
  - [ ] `npm run cleanup-root` (dry-run) → lists obsolete files
  - [ ] `npm run compare-contexts minimal standard` → shows summary
  - [ ] `npm run estimate-tokens README.md` → gives estimate
- [ ] **Sync scripts:**
  - [ ] Check `npm run sync-rules` command exists
  - [ ] Verify sync-rules.sh has correct paths

**Expected Result:**
- ✅ All scripts executable
- ✅ All npm scripts defined in package.json work
- ✅ Help messages clear
- ✅ Error handling present

**If issues:** Document + fix or mark as known limitation

**Token Estimate:** ~12-18k (run tests, check outputs)

---

### **Phase 6: Documentation Completeness Audit** (~8-12k tokens)

**Цель:** Проверить документацию - полнота, точность

**Проверки:**
- [ ] **README.md:**
  - [ ] All features mentioned still exist
  - [ ] Installation commands work
  - [ ] Examples accurate
  - [ ] Badges/links valid
- [ ] **INSTALL.md:**
  - [ ] Step-by-step still valid
  - [ ] Platform-specific instructions correct
  - [ ] Troubleshooting section helpful
- [ ] **CHANGELOG.md:**
  - [ ] Phase 3 (2026-02-12) documented
  - [ ] Format consistent
  - [ ] Links to commits/PRs work
- [ ] **.ai/docs/ (9 files):**
  - [ ] Each file up-to-date
  - [ ] No outdated info
  - [ ] Cross-references valid
- [ ] **QUICK_CONTEXT.md:**
  - [ ] Still reflects 30 essential rules
  - [ ] Examples accurate

**Expected Result:**
- ✅ All docs accurate
- ✅ No outdated information
- ✅ Examples work

**Token Estimate:** ~8-12k (reads, validation)

---

### **Phase 7: IDE Configs Completeness Audit** (~5-8k tokens)

**Цель:** Проверить IDE configs - все поддерживаемые IDE покрыты

**Проверки:**
- [ ] **.claude/CLAUDE.md:**
  - [ ] Session Start Protocol correct
  - [ ] References to .ai/ paths valid
  - [ ] Commands list complete
  - [ ] Version mentioned (if any) correct
- [ ] **.cursorrules:**
  - [ ] Mirrors key rules from CLAUDE.md
  - [ ] Cursor-specific syntax correct
  - [ ] No broken paths
- [ ] **.windsurfrules:**
  - [ ] Mirrors key rules from CLAUDE.md
  - [ ] Windsurf-specific syntax correct
  - [ ] No broken paths
- [ ] **AGENTS.md:**
  - [ ] Universal standard format
  - [ ] Entry point clear
  - [ ] Links to actual files valid
- [ ] **Sync mechanism:**
  - [ ] `scripts/sync-rules.sh` can regenerate IDE configs
  - [ ] Test run (dry-run if possible)

**Expected Result:**
- ✅ All IDE configs valid
- ✅ Sync mechanism works
- ✅ Multi-IDE support functional

**Token Estimate:** ~5-8k (reads, checks)

---

### **Phase 8: Distribution Package Audit** (~8-12k tokens)

**Цель:** Проверить npm package - пользователь получит все нужное

**Проверки:**
- [ ] **package.json:**
  - [ ] "files" field includes all needed:
    - [ ] `bin/`
    - [ ] `npm-templates/`
  - [ ] "bin" field points to correct CLI
  - [ ] "scripts" all functional
  - [ ] Dependencies minimal (inquirer, fs-extra, chalk)
  - [ ] No unnecessary dev dependencies leaked
- [ ] **bin/cli.js:**
  - [ ] Shebang correct (`#!/usr/bin/env node`)
  - [ ] Executable permission set
  - [ ] Copies all files from npm-templates correctly
  - [ ] Wizard questions cover all contexts
  - [ ] Token presets up-to-date
  - [ ] Error handling robust
- [ ] **npm-templates/ structure:**
  - [ ] Contains all files user needs
  - [ ] No unnecessary files (dev-only)
  - [ ] No sensitive data
  - [ ] README.md for npm-templates (if exists)
- [ ] **Test npm pack:**
  - [ ] `npm pack` creates .tgz
  - [ ] Inspect contents: `tar -tzf *.tgz | head -50`
  - [ ] Verify critical files included

**Expected Result:**
- ✅ Package contains exactly what users need
- ✅ No unnecessary bloat
- ✅ CLI wizard works
- ✅ npm pack output looks correct

**Token Estimate:** ~8-12k (reads, pack test, validation)

---

## 📊 Token Estimates - Revised (Based on Phase 1 Experience)

### Original vs Realistic Estimates:

| Phase | Original | **Realistic** | **Optimized** | Status |
|-------|----------|---------------|---------------|--------|
| **Phase 1** | 8-12k | 96k (actual) | N/A | ✅ COMPLETE |
| **Phase 2** | 5-8k | 20-30k | **15-20k** | Pending |
| **Phase 3** | 10-15k | 35-50k | **25-35k** | Pending |
| **Phase 4** | 5-8k | 18-25k | **12-18k** | Pending |
| **Phase 5** | 12-18k | 40-60k | **30-45k** | Pending |
| **Phase 6** | 8-12k | 30-40k | **20-30k** | Pending |
| **Phase 7** | 5-8k | 18-25k | **12-18k** | Pending |
| **Phase 8** | 8-12k | 25-35k | **18-25k** | Pending |
| **Phases 2-8** | 53-81k | 186-265k | **132-191k** | Remaining |

### 3-Day Breakdown (Variant 2 - Safe):

**Day 1 (2026-02-13):** ✅ COMPLETE
- Phase 1: npm-templates sync (96k actual)
- Commit: 76730ea

**Day 2 (2026-02-14):**
- Phase 2: .gitignore security (~15-20k optimized)
- Phase 3: Paths & references (~25-35k optimized)
- Phase 4: Version consistency (~12-18k optimized)
- **Total:** ~52-73k tokens ✅ (safe within 150k daily limit)

**Day 3 (2026-02-15):**
- Phase 5: Scripts functionality (~30-45k optimized)
- Phase 6: Documentation completeness (~20-30k optimized)
- **Total:** ~50-75k tokens ✅

**Day 4 (2026-02-16):**
- Phase 7: IDE configs completeness (~12-18k optimized)
- Phase 8: Distribution package (~18-25k optimized)
- **Total:** ~30-43k tokens ✅

**Day 5 (After Audit Complete):**
- 🐰 Test на "кролику" (fresh install verification)
- Create professional README (essentials only)
- Final validation

### Optimization Strategies (Phases 2-8):

1. ✅ Use `diff --stat` instead of `diff -u` (saves 30-50%)
2. ✅ Batch script runs (execute once, not repeatedly)
3. ✅ Brief analysis (focus on issues, not full dumps)
4. ✅ Targeted reads (only what's needed)
5. ✅ Compression after each phase

**Expected Total (Phases 2-8):** ~132-191k tokens optimized
**Spread across:** 3 days (Days 2-4)
**Safety margin:** ✅ Comfortable within daily limits

---

## 🎯 Current Status & Next Steps

**Phase 1:** ✅ COMPLETE (2026-02-13)
- Commit: `76730ea` - feat(audit): Phase 1 complete - npm-templates sync 100%
- Result: 22/22 files synchronized, npm-templates ready for distribution

**Next Session (Day 2 - 2026-02-14):**
- Start with fresh 150k daily budget
- Execute Phases 2-4 (~52-73k tokens)
- Focus: Security (.gitignore), Paths validation, Version consistency
- Approach: Quality > Speed with token optimizations

**Important Reminders for Next Session:**
1. ⚠️ **Think Harder** - thorough approach, not quick verification
2. ⚠️ **"I Don't Know" Honesty** - verify before claiming
3. ⚠️ **Token Status** - show after EVERY phase completion
4. ⚠️ **No Auto-Commit** - propose only, wait for approval
5. ⚠️ Use optimizations: `diff --stat`, batch runs, brief analysis

**Testing Strategy:**
- 🐰 Fresh install test ("кролик") - **ONLY AFTER Phase 8 complete**
- Professional README creation - **AFTER full audit**
- Rationale: Ensure all issues found & fixed before testing

**Timeline:**
- Days 2-4: Complete Phases 2-8 (audit)
- Day 5: Fresh install test + README + final validation

---

**Made in Ukraine 🇺🇦**
