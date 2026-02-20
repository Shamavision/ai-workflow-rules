# 💰 Token Usage Guide

**TL;DR:** First-time setup costs ~66k tokens. This is **one-time**. After setup, AI uses compression and lazy loading.

> **2026 Note:** Claude Pro / Gemini Advanced / Cursor use **MODEL_3 (Fair Use Dynamic)**. No published daily/monthly limits. Session-based: 200K tokens / ~5h rolling. See [Understanding Fair Use (MODEL_3)](#understanding-fair-use-model3) below.

---

## 📊 Understanding Context Token Costs

**Important clarification:**

| Metric | Token Count | What It Includes |
|--------|-------------|------------------|
| **Context file alone** | ~2-3k tokens | Just the `.ai/contexts/[name].context.md` file |
| **Full session start** | ~10-23k tokens | Context + overhead (configs, enforcement, etc.) |

**Overhead includes (~8-10k tokens):**
- `.claude/CLAUDE.md`: ~3-4k (session instructions)
- `.ai/AI-ENFORCEMENT.md`: ~5-6k (mandatory protocols)
- `.ai/token-limits.json`: ~1k (budget tracking)
- Other configs: ~1-2k (locale, trackers, etc.)

**Why this matters:**
- Documentation shows **full session start costs** (realistic)
- Individual context files are small (~2-3k each)
- Session start MESSAGE displays total (context + overhead)

**Example:**
```
[SESSION START]
✓ Context loaded: minimal (~10k tokens, v9.1 optimized)
                          ^^^^
                          This is TOTAL (context 2k + overhead 8k)
```

---

## Setup Cost Breakdown

### Full Installation

| File Category | Files | Tokens | Required? |
|--------------|-------|--------|-----------|
| **Core Rules** | .ai/rules/core.md | ~15k | ✅ YES |
| **Product Rules** | .ai/rules/product.md | ~30k | ⚠️ Only for UA market |
| **Configuration** | `.ai/` folder (3 files) | ~6k | ✅ YES |
| **Guides** | .ai/docs/start.md, INSTALL.md, .ai/docs/compatibility.md | ~9k | ⚠️ Optional |
| **Quick Start** | quickstart.md, .ai/docs/cheatsheet.md | ~1k | ⚠️ Optional |
| **Examples** | `examples/` (3 files) | ~3k | ⚠️ Optional |
| **Templates** | .env.example, configs | ~2k | ⚠️ Optional |
| **Total** | | **~66k** | |

### Token Cost by Plan

| Plan | Model | Session Limit | Daily Limit | Setup Cost | Remaining |
|------|-------|--------------|-------------|------------|-----------|
| **Free** | MODEL_3 | 200k / ~5h | UNKNOWN† | 66k | ~134k session |
| **Pro** | MODEL_3 | 200k / ~5h | UNKNOWN† | 66k | ~134k session |
| **Team** | MODEL_3 | 200k / ~5h | UNKNOWN† | 66k | ~134k session |
| **API** | MODEL_1 | 200k | Unlimited* | 66k | Depends on tier |

† **UNKNOWN (NOT DISCLOSED)** — Fair Use Dynamic. Conservative planning estimates: Free ~20k/d, Pro ~500k/d. See `.ai/token-limits.json`.
* API: No daily cap; rate-limited by tier (grows with spend history).

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
.ai/rules/core.md           # Core rules (15k tokens)
.ai/docs/start.md                # Quick guide (2k tokens)
scripts/seo-check.sh    # Security check (3k tokens)
.git/hooks/pre-commit   # Git hook (4k tokens)
```

**Total:** ~30k tokens (~20% Pro / ~20% Free)

**Skip:**
- .ai/rules/product.md (only needed for Ukrainian market)
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
| `.ai/docs/compatibility.md` | ~4k | After choosing your AI |
| `.ai/docs/token-usage.md` | ~1k | After reading this (yes, this file!) |
| `examples/` | ~3k | After understanding patterns |

**How to delete:**
```bash
rm INSTALL.md .ai/docs/compatibility.md .ai/docs/token-usage.md
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
- .ai/rules/core.md: ~15k (737 lines × ~20 tokens/line)
- .ai/rules/product.md: ~30k (2037 lines × ~15 tokens/line)
- .ai/docs/start.md: ~2k (100 lines × ~20 tokens/line)
- INSTALL.md: ~3k (150 lines × ~20 tokens/line)
- .ai/docs/compatibility.md: ~4k (200 lines × ~20 tokens/line)
- quickstart.md: ~0.5k (25 lines × ~20 tokens/line)
- .ai/docs/cheatsheet.md: ~0.5k (25 lines × ~20 tokens/line)
- .ai/docs/token-usage.md: ~1k (50 lines × ~20 tokens/line)

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
**A:** Use `//TOKENS` command — AI shows [AI STATUS] with Context Layer (exact session usage), Rate Layer (throttling signal), and Billing Layer (N/A for subscription, cost for API). The log is written to `.ai/session-log.json`.

### Q: Are these estimates accurate?
**A:** Conservative estimates (10-20% lower than actual limits). Your actual usage may vary based on:
- Provider (Anthropic, OpenAI, Google)
- Model (Claude Sonnet, GPT-4, Gemini)
- Conversation length

---

## Understanding Fair Use (MODEL_3)

> **Added:** Phase 8.7.4 (2026-02-17) — 2026 market reality

### What is MODEL_3?

Claude Pro, Gemini Advanced, Cursor Pro, and Windsurf use **Fair Use Dynamic Limits** (MODEL_3):

- **No published daily/monthly caps** — intentional product strategy
- **Session-based budget:** 200K tokens / ~5h rolling window (Claude Pro)
- **Dynamic throttling:** System adjusts limits based on load and usage patterns
- **UNKNOWN is not missing data** — it's how providers manage elastic compute

### How to think about your budget (MODEL_3):

```
PRIMARY BUDGET: Session (200K tokens, ~5h)
SECONDARY: Daily estimate (conservative, for planning only)

Session usage → is real and predictable
Daily usage → estimate only, use as planning guide
```

### Session-based budget examples:

**Small task session (2-3h coding):**
```
Session start:  18k tokens (ukraine-full context)
Task 1:         15k tokens (refactor function)
Task 2:         12k tokens (add tests)
Task 3:          8k tokens (fix bug)
─────────────────────────────────────
Total used:     53k / 200k (26%) 🟢 Plenty remaining
```

**Heavy coding session (~5h):**
```
Session start:  18k tokens
Work:          155k tokens (multiple large tasks)
─────────────────────────────────────
Total used:    173k / 200k (86%) 🟠 Approaching limit
Recommendation: Commit work, start new session
```

**When to start a new session:**
- Used >80% of session (160k+ tokens)
- Session is ~5h old (rolling window approaching reset)
- Switching to completely different context/project

### What MODEL_3 means for token tracking:

| Metric | Reality | What to do |
|--------|---------|------------|
| Daily limit | UNKNOWN | Use session % as primary indicator |
| Monthly limit | UNKNOWN | Use session count × avg session cost |
| Session limit | 200K (real!) | Track this carefully |
| Throttling | Dynamic | No warning before it happens |

### Conservative estimates in token-limits.json:

The framework uses **VARIANT B** — numeric estimates for MODEL_3 plans, clearly marked:

```json
"pro": {
  "daily": 500000,  // ESTIMATE ONLY
  "daily_note": "ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3).",
  "session": 200000  // REAL (published by Anthropic)
}
```

Use session limit (200K) for accurate planning. Daily estimates are approximate planning guides.

---

## Recommendations by Plan

### Free Plan (MODEL_3 — Fair Use)
- ✅ Use minimal installation (30k from 200k session)
- ✅ Delete optional files after reading
- ✅ Keep sessions focused (5h rolling window)
- ⚠️ Heavy throttling possible — fair use priority is lower than Pro

### Pro Plan (MODEL_3 — Fair Use)
- ✅ Full installation recommended (66k from 200k session → 134k remaining)
- ✅ Session: 200K tokens / ~5h rolling (primary budget to track)
- ✅ Keep all files for team consistency
- ✅ Use context compression at 50% session usage
- ℹ️ Daily limit UNKNOWN — use session % as your real indicator

### Team Plan (MODEL_3 — Fair Use)
- ✅ Full installation is small fraction of session budget
- ✅ Higher priority than Free/Pro (pooled compute)
- ✅ Focus on productivity — session budget ample for most work
- ℹ️ Usage shared across team workspace + web + IDE

---

## Monitor Your Usage

Check your current token status:

**In conversation:**
```
AI: Just type "//TOKENS" and I'll show your current usage
```

**Output — 3-Layer Mental Model:**
```
[AI STATUS]
Provider: Claude Pro (subscription)

Context Layer:  ~85k / 200k (42%)   ← AI knows exactly
Rate Layer:     🟢 Normal           ← estimated from patterns
Billing Layer:  N/A (subscription)

Status: 🟢 GREEN
```

**3 layers explained:**
- **Context Layer** — session tokens vs 200k window. AI estimates this accurately.
- **Rate Layer** — behavioral signal: 🟢 Normal | 🟠 Elevated (slow responses, overloaded errors)
- **Billing Layer** — for API users: shows cost from `.ai/config.json`. For Pro/subscription: `N/A`.

**Via script:**
```bash
bash scripts/token-status.sh
```

---

## Token Control v3.0: Real-World Scenarios

**New in v8.0:** Intelligent budget management with pre-flight approval.

### How Pre-Flight Estimates Work

Before executing tasks >5k tokens, AI shows cost breakdown:

#### Example 1: Small Task (Auto-Approved)

```
User: "Update auth function to add email validation"

[QUICK ESTIMATE]
Task: "Update auth function"
Cost: ~12k tokens (6% of daily limit)
Confidence: HIGH (±15%)
Based on: 3 similar tasks (avg 11k actual)

Proceeding...
```

**What happened:**
- Estimated <15k (green zone threshold)
- Auto-approved, no interruption
- User sees cost, but no action needed

---

#### Example 2: Medium Task (User Approval)

```
User: "Refactor authentication middleware for better error handling"

[TOKEN ESTIMATE]
Request: "Refactor authentication middleware"

Cost breakdown:
┌─ Analysis phase
│  ├─ Reading files (auth.ts, middleware.ts, types.ts): ~5k
│  ├─ Error handling analysis: ~3k
│  └─ Subtotal: ~8k
│
├─ Execution phase
│  ├─ Refactoring code: ~15k
│  ├─ Adding error cases: ~8k
│  ├─ Unit tests: ~6k
│  ├─ Documentation: ~3k
│  └─ Subtotal: ~32k
│
└─ Safety buffer (15%): ~6k
   ═══════════════════════════════
   TOTAL ESTIMATE: ~46k tokens

Confidence: MEDIUM (±30%)
Based on: 5 similar refactor tasks (avg 42k actual)

Budget impact:
• Currently available: 142k
• After this task: ~96k (48% remaining)
• Status: 🟢 Green → 🟢 Green

[APPROVE SPEND?] YES / ADJUST / DECLINE
```

**User responds: "YES"**

AI executes, tracks actual usage:

```
[TASK COMPLETE]
Estimated: ~46k tokens
Actual: 51k tokens
Variance: +5k (+11%)

Reason: Additional integration tests needed

Updated budget:
• Used: 91k (45%)
• Available: 109k (54%)
• Status: 🟢 Green

✓ Variance within MEDIUM confidence range (±30%)
✓ Saving variance data for future estimates...
```

---

#### Example 3: Large Task (Alternatives Shown)

```
User: "Implement complete user dashboard with all features"

[HIGH COST ALERT]
Request: "Implement complete user dashboard"

Full implementation: ~78k tokens (39% of daily limit!)

⚠️ This will move you to 🟡 Moderate zone

Alternatives:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. FULL (~78k): Complete dashboard today
   • All widgets, data views, settings
   • Comprehensive tests
   • Full documentation
   • Status after: 🟡 Moderate (68% used)

2. STAGED (~30k today, ~48k tomorrow):
   • Day 1: Core UI + basic widgets (~30k)
   • Day 2: Advanced features + polish (~48k)
   • Stay in 🟢 Green both days

3. MINIMAL (~42k): Essential features only
   • Core dashboard layout
   • Top 3 widgets only
   • Basic tests
   • Status after: 🟢 Green (62% used)

Recommendation: Option 2 (STAGED)
Reason: Better budget control, fresh limits each day

Your choice? [1/2/3]
```

**User responds: "2"**

```
✓ Staged approach selected

Today's work: Core UI + basic widgets (~30k)
Deferred for tomorrow: Advanced features (~48k)

Proceeding with Day 1...
```

---

#### Example 4: Batch Optimization

```
User: "Update auth.ts to use bcrypt"
AI: [completes, 15k tokens]

User: "Update middleware.ts to check auth"
AI: [completes, 12k tokens]

User: "Update types.ts with auth interfaces"

[OPTIMIZATION OPPORTUNITY]

Detected pattern: You're updating 3 related files sequentially

Already spent: 27k tokens (2 separate tasks)
Remaining file: types.ts (~8k if separate)

💡 TIP: Next time, batch related updates:
Request: "Update auth.ts, middleware.ts, types.ts for bcrypt"

Cost if batched from start:
├─ Read all 3 files once: ~7k (not 3×)
├─ Plan all changes: ~5k
└─ Execute batch: ~15k
Total: ~27k (vs 35k sequential)

Savings: ~8k tokens (23%)

Continue with types.ts? [YES]
```

**Learning for next time:** User sees benefit of batching.

---

#### Example 5: Low Confidence Task

```
User: "Optimize system performance"

[TOKEN ESTIMATE - LOW CONFIDENCE]
Request: "Optimize system performance"

Initial estimate: ~35-70k tokens
Confidence: ⚠️ LOW (±50%)

Why uncertain:
✗ "Optimize" is broad scope (many approaches)
✗ "System" = unknown file count
✗ No performance baseline data
✗ No similar tasks in history

Recommended approach:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. ANALYZE FIRST (~8k tokens)
   • Profile current performance
   • Identify bottlenecks
   • Create optimization plan
   • Then provide accurate estimate

2. DEFINE SCOPE
   What specifically to optimize?
   • API response times?
   • Database queries?
   • Frontend rendering?

3. PROCEED WITH ESTIMATE
   Accept uncertainty, track actual cost

Recommendation: Option 1 (ANALYZE FIRST)
This reduces risk and improves estimate accuracy.

Your choice? [1/2/3]
```

**User responds: "1"**

```
[ANALYSIS PHASE]
Cost: ~8k tokens
Proceeding...

[8k tokens later...]

[ANALYSIS COMPLETE]

Found 3 bottlenecks:
1. N+1 query in user endpoint (~12k to fix)
2. Missing database index (~5k to add)
3. Unoptimized React rendering (~15k to fix)

Updated estimate for implementation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: ~32k tokens
Confidence: HIGH (±15%) ← Much better!

Already spent: 8k (analysis)
Remaining: ~32k (fixes)
Total project: ~40k tokens

Proceed with fixes? [YES/ADJUST]
```

**Result:** Low confidence → High confidence through analysis.

---

### Variance Learning in Action

After 20 tasks, system learns your patterns:

```
[INTELLIGENT ESTIMATE]
Request: "Refactor user service"

Base estimate: ~30k

Learning adjustments:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
├─ "Refactor" historically +32% for you
│  (Based on 8 refactor tasks: avg 38k actual vs 29k estimated)
│
├─ "Service" usually includes tests (+15%)
│  (Your style: You always add comprehensive tests)
│
└─ Similar task last week: 41k actual
   (Confidence: pattern recognized)

Adjusted estimate: ~42k tokens
Confidence: HIGH (±15%)

Historical accuracy:
• Week 1 refactors: ±45% variance (learning)
• Week 4 refactors: ±18% variance (accurate!) ✓

Proceeding with adjusted estimate of ~42k.
[APPROVE?]
```

---

### Emergency Reserve Protection

```
[BUDGET WARNING]

Request: "Implement payment gateway integration" (~65k)

Current situation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Daily limit: 200k
Used today: 142k (71% = 🟠 Caution zone)
Available: 58k
Emergency reserve: 20k (10% protected)
Safe available: 38k
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Task (65k) exceeds safe available (38k)
Would leave zero reserve (RISKY!)

Why reserves matter:
• Payment gateway = high-risk feature
• API errors need debugging
• Security testing required
• Rollback scenarios
• Emergency fixes

Options:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. CORE ONLY (~35k)
   Basic integration, skip advanced features
   Keep 23k reserve (11%)

2. SPLIT SESSIONS (~30k today, ~35k tomorrow)
   Day 1: Setup + basic flow
   Day 2: Error handling + testing
   Safe reserve both days

3. PROCEED (HIGH RISK)
   Use reserve, no safety net
   Only if urgent + deadline

4. DEFER TO TOMORROW
   Start fresh with 200k limit
   Full reserve protection

Strong recommendation: Option 2 (SPLIT)

Your choice? [1/2/3/4]
```

---

### Self-Calibration (Month 1)

```
[SYSTEM SELF-ANALYSIS] 🎉 Month 1 Complete!

Performance summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tasks completed: 52
Total tokens used: 1.85M (93% of monthly Pro limit)
Avg per task: 36k tokens

Estimate accuracy:
📊 Week 1: ±42% variance (learning phase)
📊 Week 2: ±31% variance (improving)
📊 Week 3: ±24% variance (good)
📊 Week 4: ±19% variance (excellent!) 🎯

Improvement: 55% more accurate than start!

Your work patterns:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Task size: You prefer larger batches (36k avg vs 25k typical)
• Approval rate: 91% approve as-is (high trust)
• Work style: 2-3 focused sessions per day
• Peak hours: Morning (72% of tokens before noon)
• Batching: You accept 67% of batch suggestions

Optimization achieved:
💰 Tokens saved: ~285k (13% of total)
   ├─ Batching: ~145k (51% of savings)
   ├─ Deferred tasks: ~95k (33% of savings)
   └─ Context compression: ~45k (16% of savings)

Calibration recommendations:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. ⬆️ RAISE auto-approve threshold
   From: 15k → To: 25k
   Why: You rarely adjust estimates
   Impact: ~18 fewer approvals/month

2. ✅ ENABLE batch mode by default
   Why: High acceptance rate (67%)
   Impact: Auto-suggest, faster workflow

3. ⬇️ LOWER checkpoint frequency
   Why: 94% of checkpoints = "continue"
   Impact: Smoother flow, less interruption

4. 📈 INCREASE confidence thresholds
   Why: Estimates now accurate (±19%)
   Impact: More HIGH confidence tasks

Apply these optimizations? [YES/REVIEW/NO]
```

**User responds: "YES"**

```
✓ Calibration applied

Changes:
• Auto-approve: 15k → 25k
• Batch suggestions: ON by default
• Checkpoints: Reduced for HIGH confidence
• Confidence scoring: Adjusted for your accuracy

Month 2 will be even more efficient! 🚀
```

---

### Task Size Examples (Real Costs)

Based on actual variance data:

| Task Type | Typical Cost | Confidence | Example |
|-----------|-------------|------------|---------|
| **Fix typo** | ~1-3k | HIGH (±10%) | "Fix spelling in README line 42" |
| **Update function** | ~8-15k | HIGH (±15%) | "Add validation to login function" |
| **Add feature** | ~20-40k | MEDIUM (±30%) | "Add password reset flow" |
| **Refactor module** | ~35-60k | MEDIUM (±30%) | "Refactor auth middleware" |
| **Implement system** | ~60-120k | LOW (±50%) | "Implement payment system" |
| **Architecture change** | ~100-200k | LOW (±50%) | "Migrate to microservices" |

---

### CLI Commands

```bash
# Show current budget status
//TOKENS

# Get estimate without executing (dry-run)
//ESTIMATE "refactor user authentication"

# Show variance learning statistics
//VARIANCE

# Suggest batch optimizations
//BATCH

# Adjust auto-approve threshold
//CONFIG auto_approve 25000

# Export analytics report
//EXPORT tokens-report.json
```

---

### Success Metrics (What to Expect)

**Week 1:**
- ✅ All tasks >5k show estimates BEFORE execution
- ✅ ~8-10% token savings (batching + deferring)
- ⚠️ Estimates ±40% accuracy (learning phase)

**Month 1:**
- ✅ 10-15% token savings consistently
- ✅ Estimates ±25% accuracy (good)
- ✅ Zero emergency limit hits

**Month 3:**
- ✅ 12-18% token savings
- ✅ Estimates ±20% accuracy (excellent)
- ✅ Self-calibration active
- ✅ System suggests optimizations proactively

---

## Related Files

- **[quickstart.md](quickstart.md)** - Fast setup guide
- **[INSTALL.md](../../INSTALL.md)** - Installation options (minimal vs full)
- **[.ai/token-limits.json](.ai/token-limits.json)** - Your actual token limits and usage

---

<div align="center">

**Smart token management = more productive coding**

Questions? [Open an issue](https://github.com/Shamavision/ai-workflow-rules/issues)

</div>
