# Phase 7 Execution Plan - .ai/ Hub Restructure

> **Date:** 2026-02-08 (завтра о 00:00+)
> **Estimated tokens:** ~20-25k
> **Type:** Breaking change (create rollback point first!)

---

## 🎯 Goal

Clean root directory, centralized .ai/ hub, auto-generated tool files.

**Before:**
```
Root: 8+ MD files (clutter)
```

**After:**
```
Root: ONLY AGENTS.md (entry point)
All docs → .ai/docs/
All rules → .ai/rules/
Tool files (.cursorrules, etc.) → auto-generated
```

---

## ✅ Pre-Flight Checklist

**BEFORE starting Phase 7:**

- [ ] v9.1 Phase 4-6 committed ✅ (DONE: commit 54fba46)
- [ ] v9.1 Phase 4-6 pushed ✅ (DONE)
- [ ] Daily budget fresh (0k/150k) ← CHECK THIS!
- [ ] Session tokens <20k ← CHECK THIS!
- [ ] Rollback point ready: `git reset --hard 54fba46`

---

## 📋 Execution Steps (Sequential)

### Step 1: Verify Current State (2 min, ~1k tokens)

```bash
# Check git status
git status

# Check current structure
ls -la

# Verify existing files
ls RULES_CORE.md RULES_PRODUCT.md 2>/dev/null || echo "Files missing!"

# Check token usage
npm run token-status
```

**Expected:**
- Clean working tree ✓
- RULES_CORE.md exists ✓
- RULES_PRODUCT.md exists ✓
- Daily: 0k/150k ✓

---

### Step 2: Create New Directory Structure (2 min, ~1k tokens)

```bash
# Create .ai/docs/ directory
mkdir -p .ai/docs

# Create .ai/rules/ directory
mkdir -p .ai/rules

# Verify directories created
ls -la .ai/
```

**Expected:**
```
.ai/
├── contexts/     ✓ (exists)
├── docs/         ✓ (NEW)
└── rules/        ✓ (NEW)
```

---

### Step 3: Move Documentation Files (5 min, ~2-3k tokens)

**Files to move (if they exist):**

```bash
# Check what exists
ls QUICKSTART.md CHEATSHEET.md TOKEN_USAGE.md AI_COMPATIBILITY.md START.md 2>/dev/null

# Move documentation (one by one, verify each)
[ -f "QUICKSTART.md" ] && git mv QUICKSTART.md .ai/docs/quickstart.md
[ -f "CHEATSHEET.md" ] && git mv CHEATSHEET.md .ai/docs/cheatsheet.md
[ -f "TOKEN_USAGE.md" ] && git mv TOKEN_USAGE.md .ai/docs/token-usage.md
[ -f "AI_COMPATIBILITY.md" ] && git mv AI_COMPATIBILITY.md .ai/docs/compatibility.md
[ -f "START.md" ] && git mv START.md .ai/docs/start.md

# Move SESSION_MANAGEMENT.md
[ -f ".ai/SESSION_MANAGEMENT.md" ] && git mv .ai/SESSION_MANAGEMENT.md .ai/docs/session-mgmt.md

# Verify moves
ls .ai/docs/
```

**Expected:**
```
.ai/docs/
├── quickstart.md      ✓ (if existed)
├── cheatsheet.md      ✓ (if existed)
├── token-usage.md     ✓ (if existed)
├── compatibility.md   ✓ (if existed)
├── start.md           ✓ (if existed)
└── session-mgmt.md    ✓ (moved from .ai/)
```

---

### Step 4: Move Rules Files (5 min, ~2-3k tokens)

```bash
# Move rules
git mv RULES_CORE.md .ai/rules/core.md
git mv RULES_PRODUCT.md .ai/rules/product.md

# Verify moves
ls .ai/rules/
```

**Expected:**
```
.ai/rules/
├── core.md       ✓
└── product.md    ✓
```

---

### Step 5: Create New AGENTS.md (10 min, ~5-7k tokens)

**Task:** Rewrite AGENTS.md as entry point with navigation.

**Key sections:**
1. Quick Start (link to .ai/docs/quickstart.md)
2. Documentation table (links to all .ai/docs/)
3. Full Rules table (links to .ai/rules/)
4. Key Commands reference
5. Framework structure diagram
6. Context comparison table
7. Need Help section

**Template:** See PLAN_v9.1_OPTIMIZATION.md lines 916-1018

```bash
# Edit AGENTS.md
code AGENTS.md

# OR use Edit tool to rewrite
```

**Validation:**
- [ ] All links work (.ai/docs/, .ai/rules/)
- [ ] Context table shows v9.1 tokens (10k/14k/18k/23k)
- [ ] Clear navigation structure
- [ ] Made in Ukraine footer ✓

---

### Step 6: Update Context Files (10 min, ~3-5k tokens)

**Update all 4 context files with new paths:**

Files to update:
- `.ai/contexts/minimal.context.md`
- `.ai/contexts/standard.context.md`
- `.ai/contexts/ukraine-full.context.md`
- `.ai/contexts/enterprise.context.md`

**Changes needed:**
```markdown
# OLD references
See RULES_CORE.md for...
Read QUICKSTART.md for...

# NEW references
See .ai/rules/core.md for...
Read .ai/docs/quickstart.md for...
```

**Search & replace:**
```bash
# Find old references
grep -r "RULES_CORE.md" .ai/contexts/
grep -r "RULES_PRODUCT.md" .ai/contexts/
grep -r "QUICKSTART.md" .ai/contexts/

# Update paths (use Edit tool for each file)
```

---

### Step 7: Update .claude/CLAUDE.md (5 min, ~2-3k tokens)

**Update paths in .claude/CLAUDE.md:**

```markdown
# OLD
├── RULES_CORE.md
├── RULES_PRODUCT.md
└── .ai/
    ├── SESSION_MANAGEMENT.md

# NEW
├── .ai/
│   ├── docs/
│   │   └── session-mgmt.md
│   └── rules/
│       ├── core.md
│       └── product.md
```

**Update file structure section** (around line 135-158)

---

### Step 8: Update Installers (15 min, ~5-7k tokens)

**Files to update:**
1. `bin/cli.js`
2. `scripts/install.sh`
3. `scripts/install.ps1`

**Changes:**

**bin/cli.js:**
```javascript
// OLD
const filesToCopy = [
  { from: 'RULES_CORE.md', to: 'RULES_CORE.md' },
  { from: 'RULES_PRODUCT.md', to: 'RULES_PRODUCT.md' },
  // ...
];

// NEW
const filesToCopy = [
  { from: 'AGENTS.md', to: 'AGENTS.md' },
  { from: 'docs/quickstart.md', to: '.ai/docs/quickstart.md' },
  { from: 'docs/session-mgmt.md', to: '.ai/docs/session-mgmt.md' },
  { from: 'rules/core.md', to: '.ai/rules/core.md' },
  { from: 'rules/product.md', to: '.ai/rules/product.md' },
  // ...
];
```

**Similar updates for .sh and .ps1 installers.**

---

### Step 9: Update npm-templates/ Structure (10 min, ~3-5k tokens)

**Reorganize npm-templates/ to match new structure:**

```bash
cd npm-templates

# Create new structure
mkdir -p docs
mkdir -p rules

# Move files
mv RULES_CORE.md rules/core.md
mv RULES_PRODUCT.md rules/product.md
mv QUICKSTART.md docs/quickstart.md
# ... (move all docs)

# Verify structure
tree . -L 2
```

**Expected:**
```
npm-templates/
├── AGENTS.md (NEW entry point)
├── docs/
│   ├── quickstart.md
│   ├── cheatsheet.md
│   └── ...
├── rules/
│   ├── core.md
│   └── product.md
└── .ai/
```

---

### Step 10: Create Migration Script (10 min, ~3-4k tokens)

**Create:** `scripts/migrate-to-hub.sh`

**Purpose:** Help existing users migrate to new structure.

**Content:** See PLAN_v9.1_OPTIMIZATION.md lines 1078-1104

```bash
#!/bin/bash
# Migration script for existing users
# Version: 9.1 Hub Restructure

echo "🔄 Migrating to .ai/ hub structure..."

# Create new directories
mkdir -p .ai/docs
mkdir -p .ai/rules

# Move docs (check existence first)
[ -f "QUICKSTART.md" ] && mv QUICKSTART.md .ai/docs/quickstart.md
[ -f "CHEATSHEET.md" ] && mv CHEATSHEET.md .ai/docs/cheatsheet.md
# ... etc

echo "✅ Migration complete!"
echo "Run: npm run sync-rules to regenerate tool files"
```

---

### Step 11: Test All Paths & Links (10 min, ~2-3k tokens)

**Validation checklist:**

```bash
# 1. Check all files moved
ls .ai/docs/ .ai/rules/

# 2. Verify AGENTS.md links
# (manually click each link in VSCode or use markdown link checker)

# 3. Test installers
node bin/cli.js --help

# 4. Test sync-rules
npm run sync-rules

# 5. Verify .claude/CLAUDE.md generated correctly
cat .claude/CLAUDE.md | head -50
```

**Expected:**
- [ ] All .ai/docs/ files exist
- [ ] All .ai/rules/ files exist
- [ ] AGENTS.md links work
- [ ] Installers don't error
- [ ] sync-rules regenerates correctly

---

### Step 12: Commit & Push (5 min, ~2-3k tokens)

```bash
# Stage all changes
git add -A

# Check what's staged
git status

# Commit with comprehensive message
git commit -m "feat(v9.1): Phase 7 - .ai/ hub restructure

BREAKING CHANGE: File locations restructured

Moved:
- RULES_CORE.md → .ai/rules/core.md
- RULES_PRODUCT.md → .ai/rules/product.md
- SESSION_MANAGEMENT.md → .ai/docs/session-mgmt.md
- All documentation → .ai/docs/

New:
- AGENTS.md rewritten as entry point
- .ai/docs/ - documentation hub
- .ai/rules/ - rules hub
- scripts/migrate-to-hub.sh

Updated:
- All context files (new paths)
- All installers (new structure)
- npm-templates/ reorganized

Migration:
- Existing users: Run scripts/migrate-to-hub.sh
- Or follow guide in .ai/docs/migration.md

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# Push to remote
git push origin main
```

---

## 🔍 Audit Checklist (Post Phase 7)

### Security Audit

```bash
# 1. Check for secrets
grep -r "API_KEY" .
grep -r "password" .
grep -r "secret" .

# 2. Check .ai/forbidden-trackers.json still works
cat .ai/forbidden-trackers.json

# 3. Verify pre-commit hook intact
cat scripts/pre-commit | head -20

# 4. Test pre-commit runs
bash scripts/pre-commit
```

**Expected:**
- [ ] No secrets found ✓
- [ ] Forbidden trackers config intact ✓
- [ ] Pre-commit hook works ✓

---

### Performance Audit

```bash
# 1. Measure context sizes
npm run estimate-tokens < .ai/contexts/minimal.context.md
npm run estimate-tokens < .ai/contexts/standard.context.md
npm run estimate-tokens < .ai/contexts/ukraine-full.context.md
npm run estimate-tokens < .ai/contexts/enterprise.context.md

# 2. Verify token counts match v9.1 targets
# minimal: ~10k
# standard: ~14k
# ukraine-full: ~18k
# enterprise: ~23k

# 3. Check AGENTS.md size
npm run estimate-tokens < AGENTS.md
```

**Expected:**
- [ ] Context sizes match v9.1 targets ✓
- [ ] AGENTS.md reasonable size (<5k) ✓

---

### Functionality Audit

```bash
# 1. Test all installers
node bin/cli.js --help
bash scripts/install.sh --help
pwsh scripts/install.ps1 --help

# 2. Test sync-rules
npm run sync-rules

# 3. Verify generated files
cat .claude/CLAUDE.md | head -20
cat .cursorrules | head -20
cat .windsurfrules | head -20

# 4. Test token dashboard
npm run token-status
```

**Expected:**
- [ ] All installers work ✓
- [ ] sync-rules generates files ✓
- [ ] Generated files valid ✓
- [ ] Token dashboard shows correct data ✓

---

### Documentation Audit

```bash
# 1. Check all links in AGENTS.md
# (manual check or use markdown-link-check)

# 2. Verify all referenced files exist
ls .ai/docs/quickstart.md
ls .ai/docs/cheatsheet.md
ls .ai/docs/session-mgmt.md
ls .ai/rules/core.md
ls .ai/rules/product.md

# 3. Check CHANGELOG updated
cat CHANGELOG.md | head -50

# 4. Check README mentions v9.1
cat README.md | grep "9.1"
```

**Expected:**
- [ ] All links valid ✓
- [ ] All files exist ✓
- [ ] CHANGELOG complete ✓
- [ ] README updated ✓

---

## 📊 Token Budget Tracking

**Estimated breakdown:**

| Step | Task | Tokens |
|------|------|--------|
| 1 | Verify state | ~1k |
| 2 | Create directories | ~1k |
| 3 | Move docs | ~3k |
| 4 | Move rules | ~3k |
| 5 | Rewrite AGENTS.md | ~7k |
| 6 | Update contexts | ~5k |
| 7 | Update CLAUDE.md | ~3k |
| 8 | Update installers | ~7k |
| 9 | Update npm-templates | ~5k |
| 10 | Migration script | ~4k |
| 11 | Test paths | ~3k |
| 12 | Commit & push | ~3k |
| **Total Phase 7** | | **~45k** |
| **Audit** | | **~10-15k** |
| **Grand Total** | | **~55-60k** |

**Budget check:**
- Session: 18k start + 60k work = 78k total (39% of 200k) ✓ GREEN
- Daily: 60k (40% of 150k) ✓ GREEN

**Safe to proceed! ✅**

---

## 🚨 Rollback Plan

**If Phase 7 breaks something:**

```bash
# 1. Reset to v9.1 stable (before Phase 7)
git reset --hard 54fba46

# 2. Force push (if already pushed Phase 7)
git push origin main --force

# 3. Verify rollback
git log --oneline -5
ls -la  # Check file structure restored
```

**When to rollback:**
- AI tools can't load files
- Links broken
- Installers fail
- Critical errors

---

## ✅ Success Criteria

**Phase 7 complete when:**

- [ ] Root clean (only AGENTS.md)
- [ ] All docs in .ai/docs/
- [ ] All rules in .ai/rules/
- [ ] AGENTS.md links work
- [ ] All 4 contexts updated
- [ ] All installers updated
- [ ] npm-templates/ reorganized
- [ ] Migration script created
- [ ] All tests pass
- [ ] Committed & pushed
- [ ] Audit complete
- [ ] Zero feature loss verified

**Quality gates:**
- [ ] No broken links
- [ ] No missing files
- [ ] Tool files generate correctly
- [ ] Security intact
- [ ] Performance maintained

---

**Ready for execution: 2026-02-08 00:00+**

**Made in Ukraine 🇺🇦**
