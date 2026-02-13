# Roadmap - Comprehensive Framework Audit

> **Comprehensive Quality & Consistency Audit**
> **Version:** v9.1.1 (no version change)
> **Status:** Planning Complete → Ready for Execution

**Last Updated:** 2026-02-12
**Philosophy:** Quality > Speed | Think Harder | No Overengineering

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

### **Phase 1: npm-templates Sync Audit** (~8-12k tokens)

**Цель:** Убедиться, что npm-templates синхронизированы с dev

**Проверки:**
- [ ] Compare all files: `.ai/contexts/*.context.md`
- [ ] Compare: `.ai/AI-ENFORCEMENT.md`
- [ ] Compare: `.ai/docs/*.md` (9 files)
- [ ] Compare: `.ai/rules/*.md` (2 files)
- [ ] Compare: `.claude/CLAUDE.md`
- [ ] Compare: `.cursorrules`, `.windsurfrules`
- [ ] Compare: `.ai/config.json`, `token-limits.json`, `forbidden-trackers.json`
- [ ] Compare: hooks (`user-prompt-submit.sh`)
- [ ] Run: `npm run verify-templates` → должен пройти
- [ ] List files ONLY in npm-templates (unexpected extras)
- [ ] List files ONLY in dev (missing from templates)

**Expected Result:**
- ✅ All tracked files in sync
- ✅ No unexpected files
- ✅ verify-templates.sh passes

**If issues found:** Fix sync → re-verify → document

**Token Estimate:** ~8-12k (file comparisons, diffs)

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

## 📊 Total Token Estimate

| Phase | Estimate | Description |
|-------|----------|-------------|
| **Phase 1** | 8-12k | npm-templates sync |
| **Phase 2** | 5-8k | .gitignore security |
| **Phase 3** | 10-15k | Paths & references |
| **Phase 4** | 5-8k | Version consistency |
| **Phase 5** | 12-18k | Scripts functionality |
| **Phase 6** | 8-12k | Documentation |
| **Phase 7** | 5-8k | IDE configs |
| **Phase 8** | 8-12k | Distribution package |
| **TOTAL** | **61-93k** | Full audit |

**Current Budget:**
- Daily: 116k/150k used (77%) → **~34k remaining**
- Session: 116k/200k (58%) → 84k remaining ✅

**Recommendation:**
- ⚠️ DAILY LIMIT TIGHT! (only ~34k left)
- ✅ Options:
  1. **Split:** Phase 1-2 today (~13-20k), Phase 3-8 tomorrow
  2. **Defer:** All phases tomorrow (fresh 150k budget)
  3. **Compress & Continue:** After Phase 1-2, aggressive compress, then 3-4

---

## ✅ Approval Required

**Запускаємо Phase 1 сьогодні?** [Y/n]

Або відкладаємо весь аудит на завтра з fresh budget?

**Ваше рішення?**

---

**Made in Ukraine 🇺🇦**
