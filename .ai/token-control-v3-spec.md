# Token Control v3.0 — Architecture Specification

> **Status:** Implementation complete
> **Author:** AI Financial Analyst with 10 years experience (fictional persona)
> **Date:** 2026-02-17
> **Version:** 3.0.0 (Phase 8.7.3 — MODEL_3 session-based support added)

---

## Executive Summary

Token Control v3.0 introduces **intelligent, confidence-based budget management** for AI coding sessions. Unlike v2.0 (reactive monitoring), v3.0 is **proactive** — showing cost estimates BEFORE execution and learning from actual usage to improve accuracy over time.

**Key Innovation:** Control without dictatorship. Inform, don't restrict.

---

## Philosophy

### Core Principles

1. **Default to YES** — System helps, doesn't block
2. **Inform, don't restrict** — Show cost, offer alternatives, let user decide
3. **Learn and adapt** — Improve accuracy with variance tracking
4. **Graceful degradation** — Work even if tracking disabled
5. **Zero overhead** — Don't add friction to simple tasks

### The 10-15% Rule

Save 10-15% tokens per session by **eliminating waste**, not cutting quality:
- Redundant file reads
- Exploratory reads "just in case"
- Over-explanation of obvious things
- Premature execution before clarification
- Sequential operations that could be batched

---

## Architecture (4 Layers)

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 4: Budget Management (Safety Net)                    │
│ • Emergency reserve protection (10-15%)                     │
│ • Zone monitoring & transitions                             │
│ • Multi-session forecasting                                 │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ Layer 3: Learning Engine (Intelligence)                    │
│ • Variance tracking (estimate vs actual)                    │
│ • Pattern recognition (similar tasks)                       │
│ • Confidence scoring (HIGH/MEDIUM/LOW)                      │
│ • Self-calibration (adjust thresholds)                      │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ Layer 2: Approval Flow (User Experience)                   │
│ • Progressive disclosure (show details when needed)         │
│ • Smart auto-approve (safe operations)                      │
│ • Batch optimization suggestions                            │
│ • Deferred execution queue                                  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: Estimation Engine (Core)                          │
│ • Request complexity analysis                               │
│ • Task type classification                                  │
│ • Historical pattern matching                               │
│ • Risk factor scoring                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## MODEL_3: Session-Based Support (v3.0 Dual-Mode)

> **Added:** Phase 8.7.3 (2026-02-17) | **Why:** 2026 market reality — most consumer AI plans use Fair Use Dynamic limits (no fixed daily/monthly numbers)

### The Problem v3.0 Solves

Original v3.0 was designed for **MODEL_1** (Hard Token Billing — API providers with fixed daily limits). But Claude Pro, Gemini Advanced, Cursor, and most consumer plans use **MODEL_3** (Fair Use Dynamic), where:

- Daily/monthly limits = **UNKNOWN (NOT DISCLOSED)** — intentional product strategy
- Limits are session-based: `200K tokens / ~5h rolling window`
- Provider uses dynamic throttling based on system load

### Dual-Mode Architecture

Token Control v3.0 now operates in two modes automatically:

```
[AUTO-DETECT on startup]
   ↓
Read: .ai/token-limits.json
   → daily_limit_type == "fair_use_dynamic" ?
   ↓ YES                       ↓ NO
[SESSION MODE]            [DAILY MODE]
(MODEL_3)                 (MODEL_1/2)
   ↓                           ↓
Session % zones           Daily % zones
Session estimates         Daily estimates
"ESTIMATE ONLY" labels    Hard limit labels
```

**Detection logic:**
```bash
# Auto-detect from token-limits.json
if daily_limit_type == "fair_use_dynamic":
    mode = SESSION_MODE   # MODEL_3: Claude Pro, Gemini Advanced, etc.
elif _architecture_model == "MODEL_3":
    mode = SESSION_MODE
else:
    mode = DAILY_MODE     # MODEL_1/2: API providers, Copilot
```

### SESSION MODE — Behavior Differences

| Feature | DAILY MODE (MODEL_1/2) | SESSION MODE (MODEL_3) |
|---------|----------------------|----------------------|
| **Primary budget** | Daily limit (hard) | Session limit (200K) |
| **Zone thresholds** | % of daily_limit | % of session_limit |
| **Estimate labels** | "Daily budget: Xk" | "ESTIMATE ONLY: Xk (not a real limit)" |
| **Remaining calc** | daily_limit - daily_used | session_limit - session_used |
| **Reset info** | "Daily limit resets at midnight" | "Session resets after ~5h" |
| **Risk warning** | ">90% daily = CRITICAL" | ">80% session = start new session" |

### VARIANT B: Estimates for Planning

Since MODEL_3 limits are UNKNOWN, v3.0 uses **VARIANT B** — conservative estimates:

```json
// PRESETS entry for Claude Pro:
{
  "_architecture_model": "MODEL_3",
  "daily": 500000,           // ESTIMATE (not real)
  "daily_note": "ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3).",
  "session": 200000,         // REAL (published by Anthropic)
  "session_duration_hours": 5,
  "approx_messages_per_session": 45
}
```

**Philosophy:** Use session_limit (200K) as primary, daily estimate as secondary planning tool.

### Session-Based Examples

#### SESSION MODE: SMALL task (5k tokens)

```markdown
[QUICK ESTIMATE]
Task: "Fix null check in auth.ts"
Cost: ~5k tokens (2.5% of session)

Session: 45k/200k used (22%) 🟢
Session budget: ~155k remaining

Proceeding...
```

#### SESSION MODE: MEDIUM task (30k tokens)

```markdown
[TOKEN ESTIMATE]
Task: "Refactor authentication middleware"

Cost: ~30k tokens
Session impact: 45k → 75k used (37%)
Status: 🟢 Green → 🟢 Green (safe)

⚠️ Using ESTIMATE budget (Claude Pro MODEL_3):
   Daily estimate: ~30k of ~500k (conservative)
   Note: Real daily limit UNKNOWN. Session limit is what matters.

Approve? [YES/no]
```

#### SESSION MODE: When approaching session limit

```markdown
[SESSION WARNING]
Session: 165k/200k used (82%) 🟠

⚠️ Approaching session limit (~5h rolling window)
   Remaining: ~35k tokens

Options:
1. CONTINUE: ~35k available for small tasks
2. COMMIT + COMPRESS: Save work, compress context, continue
3. NEW SESSION: Fresh 200K budget (after current session expires)

Recommendation: Option 2 if >50k task planned
```

### Emergency Reserve — Session Adaptation

For MODEL_3, the 10% reserve rule applies to **session**, not daily:

```
Session limit: 200K tokens
Reserve (10%): 20K (protected)
Safe available: 180K per session

[BUDGET WARNING — SESSION MODE]
Task: ~45k tokens
Session used: 145k/200k (72%)
Safe remaining: 200k - 145k - 20k(reserve) = 35k

⚠️ Task (45k) exceeds safe remaining (35k)
Recommendation: Commit current work, start new session
```

### Model Information Display

When presenting token status in SESSION MODE:

```markdown
🤖 Provider: anthropic (pro) [MODEL_3 - Fair Use Dynamic]

⚠️ FAIR USE DYNAMIC LIMITS
   Real limits: UNKNOWN (NOT DISCLOSED) — product strategy
   Using conservative estimates for planning

💬 Session: 200,000 tokens | ~5h rolling | ~45 msgs/session
📅 Daily (ESTIMATE): 500,000 tokens | Note: ESTIMATE ONLY
```

---

## Layer 1: Estimation Engine

### Request Analysis Pipeline

```
User Request
    ↓
[1. Parse & Classify]
    • Task type: read/write/refactor/analyze/implement
    • Scope: micro/small/medium/large/critical
    • Complexity: simple/moderate/complex/unknown
    ↓
[2. Base Estimation]
    • Analysis phase tokens
    • Execution phase tokens
    • Safety buffer (15%)
    ↓
[3. Historical Matching]
    • Find similar tasks in variance_history
    • Calculate average actual cost
    • Compute typical variance
    ↓
[4. Risk Assessment]
    • Unknown scope? +30%
    • Multiple files? +20%
    • External dependencies? +25%
    • User said "just/simple"? +40% (ironic but true)
    ↓
[5. Confidence Scoring]
    • HIGH (±15%): Known task, clear scope, history available
    • MEDIUM (±30%): Moderate unknowns, some history
    • LOW (±50%): Many unknowns, no history
    ↓
[OUTPUT: Estimate + Confidence]
```

### Task Size Classification

| Size | Token Range | Auto-Approve | Checkpoint Strategy |
|------|-------------|--------------|---------------------|
| **MICRO** | <5k | ✅ Yes (silent) | None |
| **SMALL** | 5-15k | ✅ Yes (brief) | None |
| **MEDIUM** | 15-40k | ⚠️ User approval | 1 at 50% (if MEDIUM confidence) |
| **LARGE** | 40-80k | 🟠 Mandatory discussion | 2 at 33% and 66% (if LOW confidence) |
| **CRITICAL** | >80k | 🔴 Full breakdown + alternatives | After analysis + every 25k |

---

## Layer 2: Approval Flow

### Progressive Cost Gates

#### MICRO Tasks (<5k tokens)
```markdown
✅ Auto-approve, silent execution
No estimate shown unless //VERBOSE mode

Example:
User: "Fix typo in README line 42"
AI: [executes silently, shows result]
```

#### SMALL Tasks (5-15k tokens)
```markdown
⚠️ Brief estimate, auto-approve in Green zone

[QUICK ESTIMATE]
Task: "Update auth function"
Cost: ~12k tokens (6% of daily limit)
Confidence: HIGH (±15%)

Proceeding... [or show "Approve? YES/no" if user.preference.confirm_small = true]
```

#### MEDIUM Tasks (15-40k tokens)
```markdown
🟡 MANDATORY full breakdown & explicit approval

[TOKEN ESTIMATE]
Request: "Refactor authentication middleware"

Cost breakdown:
┌─ Analysis phase
│  ├─ Reading files (auth.ts, middleware.ts, types.ts): ~5k
│  ├─ Dependency analysis: ~3k
│  └─ Subtotal: ~8k
│
├─ Execution phase
│  ├─ Refactoring: ~18k
│  ├─ Testing: ~6k
│  ├─ Documentation: ~3k
│  └─ Subtotal: ~27k
│
└─ Safety buffer (15%): ~5k
   ═══════════════════════════════
   TOTAL: ~40k tokens

Confidence: MEDIUM (±30%)
Based on: 3 similar refactor tasks (avg 38k actual)

Budget impact:
• Available: 149k
• After task: ~109k (54% remaining)
• Status: 🟢 Green → 🟢 Green

[APPROVE SPEND?] YES / ADJUST / DECLINE
```

#### LARGE Tasks (40-80k tokens)
```markdown
🟠 Detailed breakdown + alternatives + staging

[HIGH COST ALERT]
Request: "Implement complete user dashboard"

Full implementation: ~65k tokens

⚠️ This will consume 33% of your daily limit

Alternatives:
1. FULL (~65k): Complete implementation today
   • All features, tests, docs
   • Will move to 🟡 Moderate zone

2. STAGED (~25k today, ~40k tomorrow):
   • Today: Core UI components + basic data
   • Tomorrow: Advanced features + optimization
   • Stay in 🟢 Green zone both days

3. MINIMAL (~35k): Essential features only
   • Core dashboard, skip advanced features
   • Stay in 🟢 Green zone

Recommendation: Option 2 (STAGED) for better budget control

Your choice? [1/2/3]
```

#### CRITICAL Tasks (>80k or zone transition to Red)
```markdown
🔴 MANDATORY discussion + risk analysis

[CRITICAL COST WARNING]
Request: "Complete system architecture refactor"

Estimated cost: ~120k tokens (60% of daily limit!)

⚠️ RISKS:
• Will move to 🔴 Critical zone (>90%)
• Emergency reserve will be exhausted
• No budget for unexpected issues
• Forces end-of-day commit

This should be split across multiple sessions.

Recommended approach:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Day 1: Analysis + Planning (~30k)
• Review current architecture
• Create detailed refactor plan
• Identify critical paths

Day 2: Core Implementation (~50k)
• Implement main components
• Unit tests

Day 3: Integration + Polish (~40k)
• Integration tests
• Documentation
• Final validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: 120k across 3 days (safe budget each day)

Proceed with Day 1 planning? [YES/MODIFY/DECLINE]
```

### Smart Batching Detection

AI automatically detects batch opportunities:

```markdown
[OPTIMIZATION OPPORTUNITY]

Detected pattern: Multiple related file updates

You asked:
├─ "Update auth.ts"
├─ "Update middleware.ts"
└─ "Update types.ts" (all related to auth)

Cost analysis:
• Sequential: 15k + 12k + 8k = 35k tokens
• Batched: 7k (read all) + 4k (plan) + 12k (execute) = 23k

💰 SAVE 12k tokens (34%)

Batch them? [YES] / [NO, keep separate]
```

### Deferred Execution Queue

Allow postponing non-critical work:

```markdown
[STAGE COMPLETE] Core implementation done
Used: 28k tokens (estimate was 25k, +12% variance)

Next in queue:
┌─ Unit tests (~8k)
├─ Integration tests (~12k)
├─ Documentation (~5k)
└─ Total remaining: ~25k

Your budget:
• Used today: 78k (39%)
• Available: 122k (61%)
• After queue: ~97k (48%) 🟢 Green

Options:
1. CONTINUE ALL: Execute full queue (~25k)
2. TESTS ONLY: Unit + integration, defer docs (~20k)
3. ESSENTIAL: Unit tests only, defer rest (~8k)
4. DEFER ALL: Commit current work, queue for tomorrow

Recommendation: Option 1 (you have good budget remaining)

Your choice? [1/2/3/4]
```

---

## Layer 3: Learning Engine

### Variance Tracking

After each task, record:

```json
{
  "task_id": "uuid",
  "date": "2026-02-03T14:30:00Z",
  "request_brief": "Refactor auth middleware",
  "task_type": "refactor",
  "scope": "medium",
  "estimated_tokens": 40000,
  "actual_tokens": 45000,
  "variance_tokens": 5000,
  "variance_percent": 12.5,
  "confidence_level": "medium",
  "reason": "Additional type definitions needed",
  "files_involved": 4,
  "files_estimated": 3
}
```

### Pattern Recognition

After 10+ tasks, AI learns patterns:

```python
# Pseudocode
patterns = {
    "refactor": {
        "avg_variance": +35%,
        "reason": "Scope creep, additional files discovered"
    },
    "simple_fix": {
        "avg_variance": +5%,
        "reason": "Usually accurate"
    },
    "implement_feature": {
        "avg_variance": +40%,
        "reason": "Requirements clarification during work"
    }
}

# When estimating new "refactor" task:
base_estimate = 30k
adjusted = base_estimate * 1.35  # Apply learned +35%
confidence = "MEDIUM" if history.count > 5 else "LOW"
```

### Confidence Calculation

```python
def calculate_confidence(request, history):
    score = 100

    # Deductions
    if "refactor" in request.lower():
        score -= 20  # Scope uncertainty
    if "system" in request.lower():
        score -= 15  # Multiple files likely
    if not history.similar_tasks:
        score -= 25  # No learning data
    if request.words < 5:
        score -= 20  # Vague requirement

    # Bonuses
    if history.similar_tasks > 5:
        score += 15  # Good data
    if "fix typo" in request.lower():
        score += 20  # Very specific
    if files_known and files_count == 1:
        score += 10  # Limited scope

    # Map to levels
    if score >= 85: return "HIGH", "±15%"
    if score >= 65: return "MEDIUM", "±30%"
    return "LOW", "±50%"
```

### Self-Calibration

After 30 days, system analyzes user patterns:

```markdown
[SYSTEM SELF-ANALYSIS] Month 1 Complete

Your patterns:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tasks completed: 47
Total tokens: 1.8M (90% of monthly limit)
Avg per task: 38k

Approval behavior:
• Auto-approved: 89% (42 tasks)
• Modified: 8% (4 tasks)
• Declined: 3% (1 task)

Work style:
• Prefer larger batches (avg 38k/task vs 25k typical)
• Morning sessions: 68% of daily tokens
• Rarely adjust estimates (high trust)
• Complete work in 2-3 focused sessions/day

Variance accuracy:
• Month start: ±45% (learning phase)
• Month end: ±22% (improved!)
• Current confidence: 74% of tasks HIGH

Optimization opportunities:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. RAISE auto-approve threshold
   From: 15k → To: 25k
   Reason: You trust estimates, reduce interruptions
   Impact: 15 fewer approvals/month

2. ENABLE batch mode default
   Reason: You prefer larger tasks
   Impact: ~12% token savings detected

3. LOWER checkpoint frequency
   Reason: 95% of checkpoints you say "continue"
   Impact: Smoother workflow

Apply suggestions? [YES/REVIEW/NO]
```

---

## Layer 4: Budget Management

### Emergency Reserve Protection

Always keep 10-15% for unexpected issues:

```markdown
[BUDGET WARNING]

Request: Large implementation (~70k tokens)

Current situation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total daily: 200k
Used: 135k (67%)
Available: 65k (33%)
Emergency reserve: 20k (10% protected)
Safe available: 45k
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ Task (70k) exceeds safe available (45k)

Why reserves matter:
• Bug fixes during implementation
• User clarifications mid-work
• Testing reveals issues
• Documentation updates
• Rollback scenarios

Options:
1. REDUCE SCOPE: Fit in 40k, keep reserve
2. SPLIT: 35k today, 35k tomorrow
3. PROCEED (RISKY): Use reserve, no safety net
4. DEFER: Start tomorrow with fresh 200k

Recommendation: Option 2 (SPLIT)

Your choice? [1/2/3/4]
```

### Zone Transition Warnings

```markdown
[ZONE TRANSITION ALERT]

Current: 🟢 Green (48% used)
After task: 🟡 Moderate (63% used)

What changes in Moderate zone:
• Auto-approve threshold: 15k → 8k
• Verbosity: Normal → Brief
• Diff-only mode: Activates
• Context compression: More aggressive

This is normal progression. Continue? [YES/NO]
```

### Multi-Session Forecasting

```markdown
[SESSION FORECAST]

Today's plan:
├─ Task A: ~35k (approved)
├─ Task B: ~28k (in queue)
└─ Task C: ~40k (proposed)
Total: ~103k tokens

Budget projection:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Current: 52k used (26%)
After A: ~87k (43%) 🟢
After B: ~115k (57%) 🟡 ← Zone change
After C: ~155k (77%) 🟠

Recommendation:
• Complete A + B today (~115k total)
• Defer C to tomorrow (fresh budget)
• Keeps you in 🟡 Moderate, not 🟠 Caution

Proceed with A + B only? [YES/NO/ADJUST]
```

---

## Integration with v2.0

### Backwards Compatibility

v3.0 gracefully extends v2.0:

```json
// Old v2.0 token-limits.json still works
{
  "provider": "anthropic",
  "plan": "pro",
  "daily_limit": 150000,
  "tracking_enabled": true
}

// v3.0 adds optional fields (MODEL_1/2 — hard caps)
{
  "provider": "anthropic",
  "plan": "pro",
  "daily_limit": 150000,
  "tracking_enabled": true,

  // NEW in v3.0 (optional)
  "auto_approve_thresholds": {
    "green_zone": 15000,
    "moderate_zone": 8000,
    "caution_zone": 3000,
    "critical_zone": 0
  },
  "session_tracking": {
    "used": 0,
    "committed": 0,
    "available": 150000
  },
  "variance_history": [],
  "learning_enabled": true
}

// VARIANT B: MODEL_3 (Claude Pro, Gemini Advanced, etc.)
// Phase 8.7.1.1 (2026-02-17) — Conservative estimates + notes
{
  "provider": "anthropic",
  "plan": "pro",
  "session_limit": 200000,
  "daily_limit": 500000,                   // ESTIMATE (not real)
  "daily_limit_type": "fair_use_dynamic",  // NEW: triggers SESSION MODE
  "daily_limit_note": "Conservative estimate. Real limit UNKNOWN (MODEL_3).",
  "monthly_limit": 5000000,                // ESTIMATE
  "monthly_limit_note": "Conservative estimate. Real limit UNKNOWN (MODEL_3).",
  "tracking_enabled": true
  // PRESETS[provider][plan] contains:
  //   _architecture_model: "MODEL_3"
  //   session_duration_hours: 5
  //   approx_messages_per_session: 45
  //   daily_note: "ESTIMATE ONLY. Real limit UNKNOWN (MODEL_3)."
}
```

### Migration Path

1. **Day 1:** System works with old schema, no estimates shown
2. **User updates schema:** v3.0 features activate
3. **Weeks 1-2:** Learning phase, LOW confidence estimates
4. **Week 3+:** Improved accuracy, self-calibration kicks in

No breaking changes. Pure enhancement.

---

## CLI Commands (Power Users)

```bash
# Show detailed budget status
//TOKENS
[OUTPUT]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SESSION BUDGET
Used:      52k ███████████░░░░░░░░░ (26%)
Committed: 35k ████████░░░░░░░░░░░░ (17%)
Available: 113k ██████████████████░░ (56%)
Reserve:   20k (10% protected)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Get estimate without executing
//ESTIMATE "refactor user authentication"
[OUTPUT]
Task: "refactor user authentication"
Estimate: ~42k tokens
Confidence: MEDIUM (±30%)
Based on: 5 similar tasks

# Show variance learning statistics
//VARIANCE
[OUTPUT]
Variance Analysis (last 30 days)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total tasks: 34
Avg variance: +18%
Best estimate: "fix bug" (+3%)
Worst estimate: "refactor system" (+52%)

Improving: ✓ (was ±35%, now ±22%)

# Suggest batch optimizations
//BATCH
[OUTPUT]
Potential batching opportunities:
• update_auth.ts + update_middleware.ts
  Save: ~8k tokens (28%)

# Adjust auto-approve threshold
//CONFIG auto_approve 20000
[OUTPUT]
✓ Auto-approve threshold: 15k → 20k
Impact: ~10 fewer approvals/month

# Export analytics
//EXPORT tokens-report.json
[OUTPUT]
✓ Exported to .ai/tokens-report.json
Contains: 34 tasks, variance data, patterns
```

---

## Success Metrics

### Week 1
- ✅ 100% of tasks >5k show pre-flight estimate
- ✅ User approves/declines, not surprised by costs
- ✅ Variance tracking active
- ✅ At least 8% tokens saved (batching + deferring)

### Month 1
- ✅ Variance <30% on medium tasks
- ✅ Confidence HIGH for 50%+ tasks
- ✅ Zero emergency limit hits
- ✅ 10-15% tokens saved vs v2.0 baseline

### Month 3
- ✅ Variance <20% on familiar task types
- ✅ Confidence HIGH for 70%+ tasks
- ✅ Self-calibration active
- ✅ System suggests optimizations proactively

---

## Implementation Roadmap

### Stage 1: Architecture (DONE)
✓ This specification document

### Stage 2: RULES_CORE.md Update
Update Section 2 (Token Management):
- 2.14: Pre-Flight Token Approval Protocol
- 2.15: Confidence-Based Estimation
- 2.16: Learning Engine & Variance Tracking
- 2.17: Emergency Reserve Management
- 2.18: Optimization Strategies

### Stage 3: token-limits.json v3.0
Add new schema fields:
- auto_approve_thresholds
- session_tracking
- variance_history
- learning_enabled

### Stage 4: Documentation
- TOKEN_USAGE.md: Real scenarios
- CHEATSHEET.md: CLI commands
- Examples for each task size

### Stage 5: Validation
- Test all flows
- Verify backwards compatibility
- Validate learning algorithm logic

---

## Appendix: Waste Types & Fixes

| Waste Type | Example | Fix | Savings |
|------------|---------|-----|---------|
| **Redundant reads** | Reading same file 3x in one session | Session cache | ~40% |
| **Exploratory reads** | "Let me check 5 files to understand..." | Targeted reads only | ~60% |
| **Over-explanation** | Explaining obvious typo fixes | Brief mode for simple tasks | ~30% |
| **Premature execution** | Implementing before clarification | Discuss → Approve → Execute | ~100% on wrong path |
| **Sequential ops** | Update A, then B, then C separately | Batch operations | ~35% |

Total potential savings: **10-15% per session** without quality loss.

---

**End of Specification**
**Version:** 3.0.0
**Status:** Complete (dual-mode: MODEL_1/2 daily + MODEL_3 session)
**Updated:** Phase 8.7.3 (2026-02-17) — MODEL_3 session-based support, VARIANT B schema
