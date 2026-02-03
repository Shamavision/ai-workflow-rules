# Dialog Example: Legacy Code Refactoring

## 📋 Context
Task: Refactor 2-year-old React component (1200 lines, no types, mixed languages)
Pain: Hard to maintain, adding features breaks existing code
Goal: Make it maintainable without breaking production

---

## ❌ Bad Approach (Dangerous)

```markdown
User: "Refactor UserDashboard.jsx, it's a mess"

AI: [reads file, immediately suggests complete rewrite to TypeScript + hooks + new architecture]

User: "OK, do it"

AI: [rewrites 1200 lines]

Result:
- 15 bugs introduced
- Production broken for 2 days
- Lost $5k in revenue
- Team morale destroyed
- 80k tokens wasted
```

**Why it failed:** No safety protocol, big-bang rewrite, no incremental validation.

---

## ✅ Good Approach (Professional Refactoring)

### User's First Message:
```markdown
//START
Context: Legacy React component, needs refactoring
File: components/UserDashboard.jsx (1200 lines)
Problem: Hard to add features, no types, bugs on every change
Goal: Make maintainable WITHOUT breaking production
Risk tolerance: ZERO (production system)

Can you help me create a safe refactoring plan?
```

### AI Response:
```markdown
[DISCUSSION NEEDED]

Context: Legacy 1200-line component, production risk

Before we start, I need to understand:
1. **Test coverage** - Are there tests? (unit/e2e)
2. **User impact** - How many active users?
3. **Deployment** - Can we deploy incrementally or big-bang?
4. **Timeline** - Urgent or can take 2-3 weeks?

Refactoring strategy depends on answers.
```

### User:
```markdown
1. No tests (legacy code)
2. 5000 active users, critical system
3. Can deploy daily (CI/CD exists)
4. Not urgent, quality > speed

What's the safest approach?
```

### AI:
```markdown
[REFACTORING STRATEGY]

Given: No tests, 5000 users, zero tolerance for bugs

Recommendation: **Strangler Fig Pattern** (incremental replacement)

Why NOT big-bang rewrite:
- ❌ High risk (no tests to validate)
- ❌ Long feedback loop (find bugs in production)
- ❌ Can't rollback partially

Why Strangler Fig:
- ✅ Refactor one piece at a time
- ✅ Each piece fully tested before deploy
- ✅ Old code runs alongside new (fallback ready)
- ✅ Can stop/pause anytime
- ✅ Users see gradual improvements

Stages:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Stage 1: Add tests to EXISTING code (~8k tokens)
  - Snapshot tests for current behavior
  - Critical path coverage
  - Safety net for refactoring

Stage 2: Extract pure functions (~5k tokens)
  - Move logic out of component
  - Add TypeScript types
  - Unit test each function

Stage 3: Split into smaller components (~10k tokens)
  - UserProfile, UserStats, UserActivity (separate)
  - Props interfaces
  - Each component independently testable

Stage 4: Replace old with new (incremental, ~8k per piece)
  - Feature flag: old vs new
  - A/B test with 5% users
  - Monitor errors, rollback if needed

Stage 5: Remove old code (~2k tokens)
  - When new code proven stable
  - Clean up, remove feature flags

Total: ~40k tokens over 2-3 weeks
Risk: MINIMAL (incremental, tested, rollback-ready)

Alternative (if urgent): Just add types + split file (~15k tokens, 1 week)

Your choice? [STRANGLER / QUICK_SPLIT / ADJUST]
```

### User:
```markdown
STRANGLER - let's do it right. Start with Stage 1.
```

### AI:
```markdown
[STAGE 1: Add Tests to Existing Code]

Goal: Create safety net BEFORE touching code
Approach: Snapshot + critical path tests

Files to create:
- __tests__/UserDashboard.test.jsx
- __tests__/UserDashboard.critical.test.jsx

Tests will cover:
1. Renders without crash
2. Shows user data correctly
3. Handles loading/error states
4. Critical buttons work (save, delete, etc.)

Estimated: ~8k tokens
Time: 2-3 hours

This gives us confidence that refactoring doesn't break behavior.

Ready? [YES/ADJUST]
```

### User:
```markdown
YES
```

### AI creates tests...

### After Stage 1:
```markdown
[STAGE 1 COMPLETE]

Created:
- UserDashboard.test.jsx (snapshot + basic tests)
- UserDashboard.critical.test.jsx (user flows)

Coverage: 65% of critical paths
All tests: ✅ PASSING

Suggested commit:
git add __tests__/
git commit -m "test(dashboard): add safety tests before refactoring"

Ready for Stage 2 (extract functions)? [YES/PAUSE]
```

### 2 weeks later (all stages done):
```markdown
[REFACTORING COMPLETE] 🎉

Metrics:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Before:
- 1 file, 1200 lines, 0 types
- Test coverage: 0%
- Bugs per week: 3-4
- Time to add feature: 1-2 days

After:
- 6 small components, 1000 lines total, 100% typed
- Test coverage: 85%
- Bugs per week: 0 (3 weeks running)
- Time to add feature: 2-4 hours

Production issues: 0
Rollbacks: 0
User complaints: 0

Tokens used: 38k (vs estimated 40k)
Time: 2.5 weeks (as planned)
```

---

## 🔑 Key Takeaways

1. **Tests BEFORE refactoring** - Safety net is not optional
2. **Incremental > Big-bang** - Small steps, constant validation
3. **Feature flags** - Deploy new code alongside old, gradual rollout
4. **Strangler Fig Pattern** - Replace piece by piece, not all at once
5. **Monitor metrics** - Track bugs/performance, rollback if needed

---

## 🚨 Red Flags (when AI suggests)

- ❌ "Let's rewrite from scratch" (for production code)
- ❌ "This will be quick" (for >500 line refactor)
- ❌ "We don't need tests for refactoring" (YOU DO!)
- ❌ "Deploy all changes at once" (incremental is safer)

**Correct response:** "No. Show me incremental plan with tests."

---

## 📊 Comparison

| Approach | Risk | Time | Token Cost | Production Issues |
|----------|------|------|------------|-------------------|
| **Big-bang rewrite** | 🔴 High | 1 week | 80k+ | 15+ bugs |
| **Strangler Fig** | 🟢 Low | 2-3 weeks | 40k | 0 bugs |
| **Quick split only** | 🟡 Medium | 1 week | 15k | 2-3 bugs |

---

**Made with ❤️ in Ukraine 🇺🇦**
