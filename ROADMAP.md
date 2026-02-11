# Roadmap - AI Workflow Rules v9.1.1

> **План покращень для версії 9.1.1**
> Версія НЕ змінюється до major update. Всі зміни - incremental improvements.

**Last Updated:** 2026-02-11
**Status:** v9.1.1 - Phases 5, 6, Item [14] completed today ✅

---

## 🟡 PENDING (Phase 3 - Automation & Tools)

> **Reason:** Phase 3 потребує ~45-65k tokens
> **Decision:** Виконати з fresh daily limit завтра (2026-02-12)

### Phase 3: Automation & Tools

#### [6] Utility Scripts для автоматизації якості
- [ ] **Status:** NOT STARTED
- **Proposed scripts:**
  1. `scripts/cleanup-root.sh` - Auto-cleanup застарілих файлів
  2. `scripts/validate-structure.sh` - Structure validator
  3. `scripts/check-links.sh` - ✅ EXISTS! (verify + enhance)
  4. `scripts/verify-templates.sh` - Template sync checker
  5. `scripts/context-diff.sh` - Context comparison tool
- **Estimated:** ~30-40k tokens
- **Priority:** HIGH - prevents npm-templates desync issues

#### [7] Daily token tracking improvement
- [ ] **Status:** NOT STARTED
- **Ideas:**
  - CLI tool: `npm run token-log <amount>`
  - Wrapper script для AI sessions
  - Provider API integration (if available)
- **Estimated:** ~10-15k tokens
- **Priority:** HIGH - critical for budget management

#### [8] npm publish workflow documentation
- [ ] **Status:** NOT STARTED
- **Include:**
  - Pre-publish checklist
  - Version bumping strategy
  - Testing before publish
  - Rollback procedure
  - Use verify-templates.sh before publish!
- **Estimated:** ~5-10k tokens
- **Priority:** MEDIUM-HIGH - needed for releases

**Phase 3 Total:** ~45-65k tokens

---

## 💡 ADDITIONAL TASKS (Optional)

### [10] Update CHANGELOG.md with today's changes
- [ ] **Status:** NOT STARTED
- **Action:** Додати запис про виконані Phases 5, 6, Item [14]
- **Format:** v9.1.1 incremental improvements (не новий release!)
- **Estimated:** ~5-10k tokens
- **Priority:** MEDIUM - good practice to document

### [11] Verify all changes work correctly
- [ ] **Status:** NOT STARTED
- **Actions:**
  - Test pre-commit hook works faster with progress indicator
  - Verify all IDE configs load без помилок
  - Check documentation links
  - Quick smoke test
- **Estimated:** ~10-15k tokens
- **Priority:** HIGH - ensure quality

### [12] Archive completed ROADMAP items
- [ ] **Status:** PARTIALLY DONE
- **Action:** ✅ Today's items removed from ROADMAP (archived via git history)
- **Reason:** Keep ROADMAP clean with only active tasks
- **Estimated:** ~0k tokens (done manually)
- **Priority:** LOW - organizational

### [13] Review and update CONTRIBUTING.md
- [ ] **Status:** NOT STARTED
- **Action:** Додати guidelines about:
  - AI Behavior Rules adherence
  - Token budget considerations
  - Commit message format
  - Testing requirements
- **Estimated:** ~10-15k tokens
- **Priority:** MEDIUM - helps contributors

---

## 📊 Token Budget Summary

**Today (2026-02-11) - Summary:**
- ✅ Phase 6: Ukrainian Language Quality (~3.8k)
- ✅ Phase 5: Rule Refresh & Anti-Amnesia (~22k)
- ✅ Item [14]: Fix pre-commit hook progress indicator (~5k)
- ✅ Daily: ~105k / 150k (70%)
- ✅ Session: ~116k / 200k (58%)
- 🟡 Status: MODERATE ZONE

**Tomorrow (2026-02-12) - Fresh 150k limit! 🟢:**
- Phase 3: Automation & Tools [6-8] (~45-65k) - PRIMARY GOAL
- Optional items [10-13] (~30-55k) - if tokens permit

**Total estimate tomorrow:** ~45-120k tokens (safe within 150k)

---

## 🎯 Recommended Next Steps (Tomorrow)

1. **Phase 3: Automation & Tools [6-8]** (~45-65k tokens) - **START HERE**
   - Utility scripts для автоматизації
   - Token tracking improvement
   - npm publish workflow docs

2. **Optional enhancements** (if tokens permit):
   - Item [10]: Update CHANGELOG (~5-10k)
   - Item [11]: Verify changes (~10-15k)
   - Item [13]: Update CONTRIBUTING (~10-15k)

---

## 💭 Future Considerations (v10.0+)

> Ідеї для майбутніх major versions

- [ ] **MCP (Model Context Protocol) integration** - structured data exchange
- [ ] **Multi-provider token tracking** - unified API across providers
- [ ] **AI session analytics** - track productivity metrics
- [ ] **Auto-generate context diffs** - what changed between contexts
- [ ] **CI/CD integration templates** - GitHub Actions, GitLab CI
- [ ] **VSCode extension** - native integration
- [ ] **Token estimation API** - accurate pre-flight estimates

---

**Made in Ukraine 🇺🇦**
