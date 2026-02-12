# npm Publish Workflow

> **Guide for maintaining and publishing @shamavision/ai-workflow-rules**
> **Last Updated:** 2026-02-12

---

## 🎯 Overview

This framework is published to npm as `@shamavision/ai-workflow-rules`. This guide ensures **safe, consistent, and error-free** releases.

**Critical Rule:** ALWAYS verify template sync before publishing!

---

## 📋 Pre-Publish Checklist

**Before ANY publish, complete ALL steps:**

### 1. **Structure Validation** ✅

```bash
npm run validate-structure
```

**Expected:** All checks pass (0 errors)

**If errors:** Fix structure issues first

---

### 2. **Template Sync Verification** ⚠️ CRITICAL!

```bash
npm run verify-templates
```

**Expected:** All files in sync

**If out of sync:**
- Identify changed files
- Sync manually OR run `npm run sync-rules`
- Re-verify until 100% sync

**Why critical:** npm-templates/ is what users get. Desync = broken package!

---

### 3. **Link Validation**

```bash
npm run check-links
```

**Expected:** All internal links valid

**If broken:** Fix links in documentation

---

### 4. **Version Bump Strategy**

**Follow Semantic Versioning (semver):**

| Change Type | Version | Example | Command |
|-------------|---------|---------|---------|
| **Bug fixes** | PATCH | 9.1.1 → 9.1.2 | `npm version patch` |
| **New features** | MINOR | 9.1.2 → 9.2.0 | `npm version minor` |
| **Breaking changes** | MAJOR | 9.2.0 → 10.0.0 | `npm version major` |

**Current version:** Check `package.json`

**Update version:**

```bash
# Choose one:
npm version patch -m "fix: description"
npm version minor -m "feat: description"
npm version major -m "BREAKING: description"
```

This will:
- Update `package.json`
- Create git tag
- Create commit

---

### 5. **CHANGELOG Update**

Edit `CHANGELOG.md`:

```markdown
## [9.1.2] - 2026-02-12

### Added
- New utility scripts for automation
- Token tracking improvements

### Fixed
- Template sync issues

### Changed
- npm publish workflow documentation
```

**Format:** [Keep a Changelog](https://keepachangelog.com/)

---

### 6. **Git Status Check**

```bash
git status
```

**Expected:** Clean working directory (or only version-related changes)

**If dirty:** Commit or stash changes first

---

### 7. **Test Package Installation** (Local Test)

```bash
# Pack locally (doesn't publish)
npm pack

# Test in another directory
mkdir /tmp/test-install
cd /tmp/test-install
npm install /path/to/ai-workflow-rules-9.1.2.tgz

# Verify files
ls -la node_modules/@shamavision/ai-workflow-rules/

# Test CLI
npx ai-workflow-rules --help
```

**Expected:** All files present, CLI works

---

### 8. **Commit Everything**

```bash
git add .
git commit -m "chore: prepare v9.1.2 release"
git push origin main
git push --tags
```

---

## 🚀 Publishing

### Production Release

```bash
# Ensure you're logged in
npm whoami

# If not logged in:
npm login

# Publish
npm publish --access public

# Verify on npm
open https://www.npmjs.com/package/@shamavision/ai-workflow-rules
```

**Expected:**
- ✅ Publish succeeds
- ✅ Package visible on npm within 1-2 minutes
- ✅ Version updated on npm page

---

### Beta Release (Testing)

For pre-release testing:

```bash
# Version as beta
npm version prerelease --preid=beta
# Creates: 9.1.2-beta.0

# Publish with beta tag
npm publish --tag beta --access public
```

**Install beta:**
```bash
npm install @shamavision/ai-workflow-rules@beta
```

---

## 🛡️ Post-Publish Verification

### 1. **Test Fresh Install**

```bash
mkdir /tmp/verify-publish
cd /tmp/verify-publish
npm init -y
npm install @shamavision/ai-workflow-rules

# Verify structure
ls -la node_modules/@shamavision/ai-workflow-rules/
ls -la node_modules/@shamavision/ai-workflow-rules/npm-templates/

# Test CLI
npx ai-workflow-rules
```

---

### 2. **Verify npm Package Page**

Visit: https://www.npmjs.com/package/@shamavision/ai-workflow-rules

**Check:**
- ✅ Correct version displayed
- ✅ README renders correctly
- ✅ Files listed in "Explore" tab
- ✅ Download stats updating

---

### 3. **Test Installation in Real Project**

```bash
cd /path/to/test/project
npm install @shamavision/ai-workflow-rules@latest
npx ai-workflow-rules  # Follow setup wizard
```

**Verify:**
- ✅ Files copied correctly
- ✅ Contexts load properly
- ✅ AI assistants recognize rules

---

## 🔄 Rollback Procedure

**If published version is broken:**

### Option 1: Publish Fixed Version (Recommended)

```bash
# Fix the issue
# ...

# Bump patch version
npm version patch -m "fix: critical bug in v9.1.2"

# Publish fix
npm publish --access public
```

**Deprecate broken version:**
```bash
npm deprecate @shamavision/ai-workflow-rules@9.1.2 "Broken, use 9.1.3 instead"
```

---

### Option 2: Unpublish (⚠️ Use with Caution!)

**npm unpublish rules:**
- Only within 72 hours of publish
- If no other packages depend on it
- Leaves a permanent "unpublished" marker

```bash
# Unpublish specific version
npm unpublish @shamavision/ai-workflow-rules@9.1.2

# Or unpublish entire package (DANGEROUS!)
npm unpublish @shamavision/ai-workflow-rules --force
```

**⚠️ Warning:** Unpublishing is discouraged. Prefer deprecate + patch.

---

## 📊 Maintenance Tasks

### Monthly

- [ ] Review and close resolved issues
- [ ] Update dependencies (`npm outdated`, `npm update`)
- [ ] Check for security vulnerabilities (`npm audit`)
- [ ] Review and merge community PRs

### Quarterly

- [ ] Major version planning
- [ ] Breaking changes assessment
- [ ] Documentation review
- [ ] Performance optimization

### Before Major Releases

- [ ] Migration guide for breaking changes
- [ ] Announcement on GitHub
- [ ] Update examples/
- [ ] Comprehensive testing across all supported IDEs

---

## 🧪 Testing Matrix

**Test on all platforms before major releases:**

| IDE | Version | Platform | Status |
|-----|---------|----------|--------|
| VSCode | Latest | macOS | ⬜ |
| VSCode | Latest | Windows | ⬜ |
| VSCode | Latest | Linux | ⬜ |
| Cursor | Latest | macOS | ⬜ |
| Cursor | Latest | Windows | ⬜ |
| Windsurf | Latest | macOS | ⬜ |
| Windsurf | Latest | Windows | ⬜ |
| CLI | Latest | All | ⬜ |

---

## 🐛 Common Issues & Fixes

### Issue: Template Sync Failed

**Symptom:** `npm run verify-templates` shows errors

**Fix:**
```bash
# Option 1: Re-sync all
npm run sync-rules

# Option 2: Manual sync
cp .ai/AI-ENFORCEMENT.md npm-templates/.ai/
cp .ai/contexts/*.context.md npm-templates/.ai/contexts/
# ... etc

# Verify
npm run verify-templates
```

---

### Issue: Published Package Missing Files

**Symptom:** Files present locally but missing on npm

**Cause:** `.npmignore` or `package.json` "files" field

**Fix:**

Check `package.json`:
```json
{
  "files": [
    "bin/",
    "npm-templates/"
  ]
}
```

Ensure critical directories included!

---

### Issue: CLI Not Working After Install

**Symptom:** `npx ai-workflow-rules` fails

**Debug:**
```bash
# Check if bin exists
ls -la node_modules/@shamavision/ai-workflow-rules/bin/

# Check permissions
ls -la node_modules/@shamavision/ai-workflow-rules/bin/cli.js

# Check shebang
head -1 node_modules/@shamavision/ai-workflow-rules/bin/cli.js
# Should be: #!/usr/bin/env node
```

**Fix:** Ensure `bin/cli.js` has:
- Correct shebang
- Execute permissions
- Listed in `package.json` "bin" field

---

## 📚 Resources

- **npm Docs:** https://docs.npmjs.com/
- **Semantic Versioning:** https://semver.org/
- **Keep a Changelog:** https://keepachangelog.com/
- **npm CLI Reference:** https://docs.npmjs.com/cli/v10/commands

---

## ✅ Quick Publish Checklist (TL;DR)

```bash
# 1. Validate
npm run validate-structure
npm run verify-templates  # CRITICAL!
npm run check-links

# 2. Version
npm version patch  # or minor/major

# 3. Update CHANGELOG.md
# ... manual edit ...

# 4. Test locally
npm pack
# test in /tmp/

# 5. Commit
git add .
git commit -m "chore: prepare vX.X.X release"
git push origin main --tags

# 6. Publish
npm publish --access public

# 7. Verify
# Check npm page + test fresh install
```

---

**Made in Ukraine 🇺🇦**
