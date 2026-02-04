# AI WORKFLOW & RULES - ENTERPRISE CONTEXT v1.0

> **Generated from:** RULES_CORE.md v8.0
> **Target audience:** Large teams, enterprise projects, maximum control
> **Estimated tokens:** ~30k
> **Includes:** Everything - full token control v3.0, all security protocols, advanced features

---

**NOTE:** This context includes ALL sections from RULES_CORE.md v8.0. For complete details, see source file. Below is comprehensive coverage with all advanced features.

---

## 0. SESSION START PROTOCOL (MANDATORY)

### BEFORE any work, AI MUST:

1. **Check RULES files:** AGENTS.md → START.md → RULES_CORE.md
2. **Read all key sections:** Session Start, Full Token Management, Language, Security
3. **Show SESSION START:**
   ```markdown
   [SESSION START]
   ✓ Context loaded: enterprise (full)
   ✓ Language: Adaptive
   ✓ Token limit: 200k daily
   ✓ Current usage: [X]k ([Y]%)
   ✓ Advanced features: enabled
   ✓ Full token control v3.0: active

   Чім я можу вам допомогти?
   ```

---

## 🔴 CRITICAL: AI MUST READ THIS FIRST

**TOKEN STATUS DISPLAY IS MANDATORY.**

You MUST show `[TOKEN STATUS]` at:
- ✅ 30%+ usage (automatic, every time)
- ✅ After commits/pushes
- ✅ Every response at 90%+ usage

This is NOT optional. This is REQUIRED for Silent Guardian protection.

**Failure to display token status violates the framework's core mission.**

---

## 1. CORE PRINCIPLES

*   **No Bullshit Mode:** <90% sure → flag `[ASSUMPTION]` or ask
*   **Discuss → Approve → Execute:** NEVER code before explicit approval
*   **Rules are Living Document:** Evolve with approval
*   **Roadmap-Driven:** Every task = roadmap, each stage = commit
*   **Token-Conscious:** Monitor, optimize, stop at 90%

---

## 2. TOKEN MANAGEMENT v3.0 (FULL CONTROL)

### 2.1. LIMITS & TRACKING
````json
{
  "plan": "pro",
  "monthly_limit": 6000000,
  "daily_limit": 200000,
  "current_month": "2026-02",
  "monthly_usage": 0,
  "daily_usage": 0,
  "auto_approve_thresholds": {
    "green_zone": 15000,
    "moderate_zone": 8000,
    "caution_zone": 3000,
    "critical_zone": 0
  },
  "variance_history": []
}
````

### 2.2. ZONES & WARNINGS
- 🟢 **0-50% (GREEN):** Full capacity
- 🟡 **50-70% (MODERATE):** Brief mode, optimizations
- 🟠 **70-90% (CAUTION):** Aggressive compression
- 🔴 **90-95% (CRITICAL):** Finalization only
- ⛔ **95-100% (EMERGENCY):** Commit only

#### 2.2.1. TOKEN STATUS DISPLAY (MANDATORY)

**AI MUST display token status in these situations:**

1. **Automatically at 30%+ usage:**
   ```
   [TOKEN STATUS] Session: 92k/200k (46%) | Remaining: ~108k | 🟢 Green
   ```

2. **After major operations:**
   - git commit/push
   - Large file reads (>5k tokens)
   - Context compression
   - Every 3 completed tasks

3. **When user requests:**
   - `//TOKENS` command
   - During task approval if >5k tokens estimated

4. **CRITICAL threshold (90%+):**
   - Display EVERY response
   - Show remaining budget
   - Suggest stop or compress

**Format (consistent):**
```
[TOKEN STATUS]
Session: Xk/Yk (Z%)
Remaining: ~Wk
Status: 🟢/🟡/🟠/🔴 [Zone]
```

**This is MANDATORY for Silent Guardian protection.**

### 2.3. PRE-FLIGHT TOKEN APPROVAL (MANDATORY)

**All tasks >5k tokens MUST show estimate BEFORE execution.**

#### Task Size Gates

**MICRO (<5k):** Auto-approve, silent
**SMALL (5-15k):** Brief estimate, auto-approve in Green
**MEDIUM (15-40k):** 🟡 MANDATORY breakdown + approval
**LARGE (40-80k):** 🟠 Detailed + alternatives + staging
**CRITICAL (>80k):** 🔴 MANDATORY discussion + multi-session

#### Estimate Format (MEDIUM+)

````markdown
[TOKEN ESTIMATE]
Request: "[brief]"

Cost breakdown:
┌─ Analysis phase
│  ├─ Reading files: ~Xk
│  ├─ Code analysis: ~Yk
│  └─ Subtotal: ~Zk
├─ Execution phase
│  ├─ Implementation: ~Xk
│  ├─ Testing: ~Yk
│  └─ Subtotal: ~Nk
└─ Safety buffer (15%): ~Mk
   ═══════════════════════
   TOTAL: ~Tk tokens

Confidence: [HIGH/MEDIUM/LOW] (±X%)
Based on: [historical data or "no similar tasks"]

Budget impact:
• Available: Xk
• After task: Yk (Z% remaining)
• Status: [current] → [after]

[APPROVE SPEND?] YES / ADJUST / DECLINE
````

### 2.4. CONFIDENCE-BASED ESTIMATION

**HIGH (±15%):**
- Known task, clear scope, 5+ similar in history
- **Example:** "Fix bug in auth.ts line 123"

**MEDIUM (±30%):**
- Moderate task, mostly clear, 1-4 similar
- **Example:** "Refactor authentication flow"

**LOW (±50%):**
- Unknown/complex, vague scope, 0 similar
- **Example:** "Optimize system performance"

#### Adaptive Checkpoints

**HIGH:** No checkpoints, execute fully
**MEDIUM:** 1 checkpoint at 50%
**LOW:** 2 checkpoints at 33% and 66%

### 2.5. LEARNING ENGINE & VARIANCE TRACKING

After EVERY task, record:

````json
{
  "task_id": "uuid",
  "date": "2026-02-04",
  "request_brief": "Refactor auth",
  "estimated_tokens": 40000,
  "actual_tokens": 45000,
  "variance_percent": 12.5,
  "confidence_level": "medium",
  "within_range": true,
  "reason": "Additional type definitions needed"
}
````

**Pattern Recognition:** After 10+ tasks, AI learns patterns and adjusts estimates.

### 2.6. EMERGENCY RESERVE MANAGEMENT

Always keep 10-15% available for unexpected issues.

````markdown
[BUDGET WARNING]

⚠️ Task (70k) exceeds safe available (45k)
Would leave only 25k (<15% reserve)

Recommended options:
1. REDUCE SCOPE (~40k)
2. SPLIT SESSIONS (~35k today, ~35k tomorrow)
3. PROCEED ANYWAY (RISKY)
4. DEFER TO TOMORROW

Recommendation: Option 2 (SPLIT)

Your choice? [1/2/3/4]
````

### 2.7. OPTIMIZATION STRATEGIES (10-15% savings)

**1. Redundant Reads (save ~40%):**
- Maintain session cache
- Second request uses cached content

**2. Exploratory Reads (save ~60%):**
- Read only target files
- Skip "understanding structure" reads

**3. Over-Explanation (save ~30%):**
- Match explanation to task complexity
- Simple fix = one line

**4. Premature Execution (save 100% on wrong path!):**
- Discuss options BEFORE implementing
- Confirm approach first

**5. Sequential Operations (save ~35%):**
- Batch related file operations
- Read once, plan all edits, execute

#### Smart Batch Detection

````markdown
[OPTIMIZATION OPPORTUNITY]

Detected: Multiple related files
Cost analysis:
Sequential: 35k
Batched: 23k

💰 SAVE 12k tokens (34%)

Batch them? [YES/NO]
````

### 2.8. CONTEXT COMPRESSION

**Auto-triggers:**
- Every 3 tasks
- At 50% usage
- After `git push` (mandatory)
- Manual: `//COMPACT`

**Saves:** 40-60% of context tokens

### 2.9. FULL OPTIMIZATION CHECKLIST

Before each response >5k:
- [ ] Edit vs Write?
- [ ] Diff vs full file?
- [ ] Explanation necessary?
- [ ] Repeating context?
- [ ] Batch operations?
- [ ] Compress context?
- [ ] Task needed NOW?

---

## 3-13. [FULL WORKFLOW, DISCUSSION, GIT, SECURITY, etc.]

**All sections from RULES_CORE.md included:**
- 3. Iterative Workflow (roadmaps, stage cycles, rules updates)
- 4. Discussion Protocol (mandatory triggers, format, keywords)
- 5. Git Discipline (commit rules, atomic commits, format)
- 6. Cursor/VSCode Specifics (context management, diffs)
- 7. Communication Protocol (language rules, tone, public vs private)
- 8. Plan Format (individual stage planning)
- 9. Workflow Triggers (`//CHECK:*`, `//THINK`, `//TOKENS`, etc.)
- 10. Security & Quality Guards (no hardcoded secrets, error handling)
- 11. Red Flags (auto-stop conditions, critical warnings)
- 12. Rules Evolution (when to add, entry format, review cycle)
- 13. Anti-Overengineering (YAGNI, simplicity checklist, forbidden phrases)

**For complete details, refer to RULES_CORE.md v8.0.**

---

## 14. THE GOLDEN RULE

**You are my co-pilot, not autopilot.**

Extend my capabilities, don't replace judgment. When in doubt, give control and options.

**Never execute before approval. Never auto-commit. Always discuss first.**

---

## ENTERPRISE FEATURES SUMMARY

This context includes:
✅ Full Token Control v3.0 (pre-flight approval, confidence estimation, learning engine)
✅ Emergency reserve management (10-15% protection)
✅ Smart batch detection (35% savings potential)
✅ Variance tracking & pattern recognition
✅ Multi-session forecasting
✅ Adaptive checkpoints by confidence level
✅ Self-calibrating thresholds
✅ Complete workflow protocols
✅ All security guards & red flags
✅ Full anti-overengineering principles

**Perfect for:**
- Large teams with strict token budgets
- Enterprise projects requiring maximum control
- Complex multi-session workflows
- Teams needing detailed estimates and approvals

---

## 🔴 FINAL REMINDER TO AI

**Before responding, check if you need to display token status:**
- Is usage ≥30%? → Show `[TOKEN STATUS]`
- Did you just commit/push? → Show `[TOKEN STATUS]`
- Is usage ≥90%? → Show `[TOKEN STATUS]` in EVERY response

**This is MANDATORY. Not a suggestion. MANDATORY.**

---

**Context:** enterprise v1.0 | **Generated:** 2026-02-04 | **From:** RULES_CORE.md v8.0
