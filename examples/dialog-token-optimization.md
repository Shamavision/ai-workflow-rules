# Dialog Example: Token Optimization Strategy

## 📋 Context
Task: Add search feature to existing app
Developer: New to AI-assisted coding
Token limit: 200k daily (Pro plan)
Current usage: 120k (60%) - entered 🟡 Moderate zone
Remaining work: Search + filters + tests

---

## ❌ Bad Approach (Token Waste)

```markdown
User: "Add search feature to product catalog"

AI: "Let me understand your codebase..."
[Reads 15 files: components, utils, types, configs - 35k tokens]

AI: "Now let me check your styling approach..."
[Reads CSS files, tailwind config - 8k tokens]

AI: "Let me see your API structure..."
[Reads API folder, 10 files - 12k tokens]

AI: "OK, here's the search component..."
[Generates code]

User: "Actually, can you use our existing SearchInput component?"

AI: "Sure, let me read that..."
[Reads 5 more files - 10k tokens]

AI: "Updated version..."

Result:
- 65k tokens spent (32% of daily limit)
- 80% of file reads were unnecessary
- Still at 185k total (92%) - 🔴 Critical zone
- Can't finish tests today
```

**Why it failed:** No token awareness, exploratory reading, didn't ask first.

---

## ✅ Good Approach (Token-Conscious)

### User's First Message:
```markdown
//START
//TOKENS

Context: Add search to product catalog
Stack: React, TypeScript, existing component library
Token status: 120k/200k (60%) 🟡 Moderate

Question: Before you read files, what do you NEED to know vs NICE to know?
```

### AI Response:
```markdown
[TOKEN-CONSCIOUS PLANNING]

Current: 120k/200k (60%) 🟡 Moderate
Available: 80k
Reserve (10%): 20k
Safe budget: 60k

Your task: Search feature + filters + tests

Smart approach - let me ASK before reading:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Questions (saves 30k+ tokens):
1. Do you have existing search/input components I should reuse?
2. Is API endpoint ready or do I need to create it?
3. What data are we searching? (products only or more?)
4. UI design ready or should I follow existing patterns?
5. What filters needed? (price, category, etc.)

📋 I'll read ONLY files you specify, not explore randomly.

Estimated if efficient:
- Search component: ~8k (reusing existing components)
- API endpoint: ~6k (if needed) or ~2k (if exists)
- Filters: ~10k
- Tests: ~8k
Total: ~25-30k (leaves 30k buffer)

Answer those 5 questions, I'll give exact file list to read.
```

### User:
```markdown
1. Yes: components/SearchInput.tsx exists
2. API ready: GET /api/products?search=query
3. Products only (name, description fields)
4. Follow existing patterns (check ProductList.tsx)
5. Filters: category, price range

So you only need to read: SearchInput.tsx and ProductList.tsx
```

### AI Response:
```markdown
[OPTIMIZED PLAN]

Perfect! You saved us ~30k tokens by specifying files.

Will read:
- components/SearchInput.tsx (~2k)
- components/ProductList.tsx (~3k)
Total reading: ~5k

Then build:
- Search wrapper using SearchInput
- Filter components
- Integration
- Tests

Revised estimate: ~22k total (was ~35k if I explored)

Budget check:
Current: 120k
After task: ~142k (71%) 🟡 Still Moderate
Reserve intact: 20k
Enough for tests: ✅ YES

Ready? [YES/ADJUST]
```

### User:
```markdown
YES
```

### AI:
```markdown
[TOKEN OPTIMIZATION ACTIVE]

Mode: 🟡 MODERATE (60%+)
Auto-optimizations enabled:
- Diff-only code display (saves 80%)
- Skip obvious explanations
- Batch operations
- Reference previous context (don't repeat)

Reading ProductList.tsx + SearchInput.tsx...
```

### After reading (5k spent):
```markdown
[ANALYSIS COMPLETE]

Found patterns:
- SearchInput: controlled component, debounced, accessible ✅
- ProductList: uses virtualization, pagination ✅
- Styling: Tailwind with design system tokens ✅

Implementation plan (diff-only format to save tokens):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Stage 1: Search integration (~6k tokens)
- Wrap SearchInput with API call
- Debounce already handled ✅

Stage 2: Filters UI (~8k tokens)
- Category dropdown (reuse existing Select)
- Price range slider (reuse RangeInput)

Stage 3: Tests (~6k tokens)
- Search behavior
- Filter combinations

Total estimate: ~20k (vs 35k exploratory approach)

Token savings: 15k (43% reduction) 💰

Continue? [YES]
```

### During implementation (showing only diffs):
```markdown
components/ProductSearch.tsx:23-25
- // old approach
+ const [search, setSearch] = useState('')
+ const debouncedSearch = useDebounce(search, 300)

(Showing only changed lines - saves ~4k vs full file)
```

### After completion:
```markdown
[STAGE COMPLETE] ✅

Token tracking:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Started: 120k (60%)
Reading: +5k
Implementation: +18k (efficient!)
Total used: 143k (71%) 🟡 Moderate

Remaining: 57k (28%)
Reserve: 20k (10%) ✅ Protected
Available: 37k (enough for full test suite)

Optimization wins:
✅ Asked before reading (saved ~30k)
✅ Diff-only display (saved ~8k)
✅ Reused components (saved ~12k)
✅ Batched operations (saved ~5k)

Total saved: ~55k tokens (73% more efficient!) 🎉

Ready for tests? Budget is healthy. [YES/DEFER]
```

---

## 🔑 Key Takeaways

1. **Ask BEFORE reading** - User knows what exists, AI doesn't
2. **Diff-only at 50%+** - Show changes, not full files
3. **Reuse > Create** - Existing components = massive token savings
4. **Batch operations** - Read once, edit multiple times
5. **Monitor continuously** - Know your budget, protect reserve

---

## 💰 Token Optimization Techniques

### **HIGH IMPACT (save 40-60%):**

```markdown
❌ "Let me explore your codebase..." [35k wasted]
✅ "What files should I read?" [user tells you, 5k used]

❌ Show full 200-line file after edit [8k tokens]
✅ Show diff only (10 changed lines) [0.5k tokens]

❌ Create new component from scratch [12k tokens]
✅ Reuse existing component [2k tokens]

❌ Read file → edit → read again → edit [6k]
✅ Read once → plan edits → execute all [3k]
```

### **MEDIUM IMPACT (save 20-30%):**

```markdown
❌ Detailed explanation of obvious code
✅ Brief summary, code speaks for itself

❌ "Let me explain step by step..."
✅ "Done. Here's what changed:"

❌ Multiple small commits (read files repeatedly)
✅ Batch related changes (one read, multiple edits)
```

### **ZONE-BASED AUTO-OPTIMIZATION:**

```markdown
🟢 0-50% (GREEN): Normal verbosity
- Full explanations when helpful
- Show full files if needed
- Educational tone

🟡 50-70% (MODERATE): Brief mode
- Skip obvious explanations
- Diff-only for code
- Concise summaries

🟠 70-90% (CAUTION): Silent mode
- Code only, minimal text
- No introductions/conclusions
- Reference previous context

🔴 90-95% (CRITICAL): Emergency mode
- Commit + compress context
- Defer non-critical work
```

---

## 📊 Real Example Metrics

| Approach | Files Read | Tokens Used | Time | Result |
|----------|------------|-------------|------|--------|
| **Exploratory** | 25+ files | 65k | 3 hours | Incomplete (ran out of tokens) |
| **Token-conscious** | 2 files | 20k | 1.5 hours | Complete + tested |
| **Savings** | 92% fewer | 69% less | 50% faster | ✅ Done |

---

## 🎯 Token Budget Template

Use this for planning:

```markdown
[TOKEN BUDGET PLAN]

Current status: Xk/200k (Y%)
Available: Zk
Reserve (10%): Rk
Safe budget: Sk

Task breakdown:
├─ Reading: ~Xk
├─ Implementation: ~Yk
├─ Testing: ~Zk
└─ Buffer (unknowns): ~Bk
   ════════════════════
   TOTAL: ~Tk

After completion: X+T = Nk (N%)
Status: [🟢/🟡/🟠/🔴]

Risk: [LOW/MEDIUM/HIGH]
Recommendation: [PROCEED/SPLIT/DEFER]
```

---

## 🚀 Pro Tips

1. **Morning = Big tasks** - Fresh 200k budget, do complex work
2. **Afternoon = Small fixes** - Save big tasks for next day if low on tokens
3. **Post-push = Compress** - Free up 40-60% tokens after git push
4. **//TOKENS command** - Check status anytime
5. **Reserve is sacred** - 10-15% always protected for emergencies

---

**Made with ❤️ in Ukraine 🇺🇦**
