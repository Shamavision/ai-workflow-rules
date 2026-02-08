# 💰 Token Usage Guide

**TL;DR:** First-time setup costs ~66k tokens (~33% Pro / ~44% Free daily limit). This is **one-time**. After setup, AI uses compression and lazy loading.

---

## Setup Cost Breakdown

### Full Installation

| File Category | Files | Tokens | Required? |
|--------------|-------|--------|-----------|
| **Core Rules** | RULES_CORE.md | ~15k | ✅ YES |
| **Product Rules** | RULES_PRODUCT.md | ~30k | ⚠️ Only for UA market |
| **Configuration** | `.ai/` folder (3 files) | ~6k | ✅ YES |
| **Guides** | START.md, INSTALL.md, AI_COMPATIBILITY.md | ~9k | ⚠️ Optional |
| **Quick Start** | QUICKSTART.md, CHEATSHEET.md | ~1k | ⚠️ Optional |
| **Examples** | `examples/` (3 files) | ~3k | ⚠️ Optional |
| **Templates** | .env.example, configs | ~2k | ⚠️ Optional |
| **Total** | | **~66k** | |

### Token Cost by Plan

| Plan | Daily Limit | Setup Cost | % of Daily | Remaining |
|------|------------|------------|------------|-----------|
| **Free** | 150k | 66k | 44% | ~84k |
| **Pro** | 200k | 66k | 33% | ~134k |
| **Team** | 800k | 66k | 8% | ~734k |

**Note:** Conservative estimates based on `.ai/token-limits.json` PRESETS.

---

## Why So Many Tokens?

AI assistants (Claude Code, Cursor) **automatically read** all markdown files and configs in your project to understand context.

**What AI reads at startup:**
- All `*.md` files in root (RULES, guides, docs)
- All files in `.ai/` folder (configs, blacklists)
- Examples in `examples/` folder
- VS Code configs (`.vscode/`, `.editorconfig`)

**This happens once per session.** After initial reading, AI uses:
- Context compression (~40-60% token savings)
- Lazy loading (reads files only when needed)
- Session checkpoints (for multi-day projects)

---

## Minimize Token Usage

### Option A: Minimal Installation (30k tokens)

**Copy only essential files:**
```bash
.ai/                    # Configs (6k tokens)
RULES_CORE.md           # Core rules (15k tokens)
START.md                # Quick guide (2k tokens)
scripts/seo-check.sh    # Security check (3k tokens)
.git/hooks/pre-commit   # Git hook (4k tokens)
```

**Total:** ~30k tokens (~20% Pro / ~20% Free)

**Skip:**
- RULES_PRODUCT.md (only needed for Ukrainian market)
- Examples (you can add later)
- Guides (read online if needed)

---

### Option B: Full Installation (66k tokens)

**Copy everything** - recommended for:
- ✅ Pro/Team plan users (plenty of tokens)
- ✅ First-time users (need examples and guides)
- ✅ Teams (consistency across members)

---

### Option C: Progressive Installation

1. **Start minimal** (30k tokens)
2. **Work for a few days**
3. **Add examples when needed** (+3k tokens)
4. **Add guides if stuck** (+9k tokens)

This spreads token cost across multiple sessions.

---

## Delete After Reading

Some files are only needed during setup. **Safe to delete after reading:**

| File | Tokens Saved | When to Delete |
|------|-------------|----------------|
| `INSTALL.md` | ~3k | After installation complete |
| `AI_COMPATIBILITY.md` | ~4k | After choosing your AI |
| `TOKEN_USAGE.md` | ~1k | After reading this (yes, this file!) |
| `examples/` | ~3k | After understanding patterns |

**How to delete:**
```bash
rm INSTALL.md AI_COMPATIBILITY.md TOKEN_USAGE.md
rm -rf examples/
```

AI won't read deleted files in future sessions.

---

## Token Optimization in Action

### First Session (today):
```
AI reads: 66k tokens (setup)
Your work: 50k tokens (coding, discussions)
Total: 116k / 200k (58% used)
```

### Second Session (tomorrow):
```
AI reads: 10k tokens (compressed context from yesterday)
Your work: 80k tokens (more productive!)
Total: 90k / 200k (45% used)
```

**Key insight:** Token cost drops ~85% after first session due to compression!

---

## Per-File Token Estimates

**For reference if you want to customize:**

### Documentation (Markdown)
- RULES_CORE.md: ~15k (737 lines × ~20 tokens/line)
- RULES_PRODUCT.md: ~30k (2037 lines × ~15 tokens/line)
- START.md: ~2k (100 lines × ~20 tokens/line)
- INSTALL.md: ~3k (150 lines × ~20 tokens/line)
- AI_COMPATIBILITY.md: ~4k (200 lines × ~20 tokens/line)
- QUICKSTART.md: ~0.5k (25 lines × ~20 tokens/line)
- CHEATSHEET.md: ~0.5k (25 lines × ~20 tokens/line)
- TOKEN_USAGE.md: ~1k (50 lines × ~20 tokens/line)

### Configuration (JSON)
- `.ai/token-limits.json`: ~1k (structured data)
- `.ai/forbidden-trackers.json`: ~5k (large blacklist)
- `.ai/locale-context.json`: ~0.3k (small config)

### Code Examples (TypeScript/JavaScript)
- `examples/react-i18n.tsx`: ~1k (50 lines × ~20 tokens/line)
- `examples/api-security.ts`: ~1k (50 lines × ~20 tokens/line)
- `examples/env-usage.ts`: ~1k (50 lines × ~20 tokens/line)

### Scripts (Bash/PowerShell)
- `scripts/seo-check.sh`: ~3k (large script)
- `scripts/setup.sh`: ~0.5k (small automation)
- `scripts/validate-setup.sh`: ~0.3k (validation)
- `.git/hooks/pre-commit`: ~4k (security checks)

---

## FAQ

### Q: Can I use this on Free plan?
**A:** Yes, but you'll use ~44% daily limit on setup. Recommended:
- Install minimal version (30k tokens)
- OR wait until you upgrade to Pro
- OR delete optional files after reading

### Q: Do I pay tokens every session?
**A:** No! Only first session reads everything (~66k). Next sessions use compression (~10k).

### Q: What if I hit token limit?
**A:**
1. Delete optional files (INSTALL.md, examples/, etc.)
2. Use `//COMPACT` command to compress context
3. Restart session (fresh context)
4. Upgrade to Pro plan

### Q: How do I track my token usage?
**A:** Check `.ai/token-limits.json` - AI updates it automatically. Or use `//TOKENS` command.

### Q: Are these estimates accurate?
**A:** Conservative estimates (10-20% lower than actual limits). Your actual usage may vary based on:
- Provider (Anthropic, OpenAI, Google)
- Model (Claude Sonnet, GPT-4, Gemini)
- Conversation length

---

## Recommendations by Plan

### Free Plan (150k/day)
- ✅ Use minimal installation (30k)
- ✅ Delete optional files after reading
- ✅ Avoid long conversations (keep sessions focused)
- ⚠️ Full installation leaves only ~84k for work

### Pro Plan (200k/day)
- ✅ Full installation recommended (66k)
- ✅ Plenty of tokens for productive work (~134k remaining)
- ✅ Keep all files for team consistency
- ✅ Use context compression at 50%

### Team Plan (800k/day)
- ✅ Full installation is negligible (8% of daily limit)
- ✅ No need to optimize token usage
- ✅ Focus on productivity, not token counting

---

## Monitor Your Usage

Check your current token status:

**In conversation:**
```
AI: Just type "//TOKENS" and I'll show your current usage
```

**In file:**
```bash
cat .ai/token-limits.json | grep "daily_percentage"
```

**Output example:**
```json
"daily_percentage": 35,  // You've used 35% today
"current_status": "green"  // 🟢 You're good!
```

---

## Related Files

- **[QUICKSTART.md](QUICKSTART.md)** - Fast setup guide
- **[INSTALL.md](INSTALL.md)** - Installation options (minimal vs full)
- **[.ai/token-limits.json](.ai/token-limits.json)** - Your actual token limits and usage

---

<div align="center">

**Smart token management = more productive coding**

Questions? [Open an issue](https://github.com/Shamavision/ai-workflow-rules/issues)

</div>
