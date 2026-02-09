# AI Provider Comparison Guide

> **Last Updated:** 2026-02-07
> **Data Source:** Official documentation + verified user reports
> **Coverage:** 9 providers, 25+ plans

---

## 📊 Quick Comparison Table

| Provider | Best Free | Best Paid | API Cost (input/output per 1M) | Session Limit |
|----------|-----------|-----------|--------------------------------|---------------|
| **Anthropic** | claude.ai Free | Claude Pro ($20/mo) | $3/$15 (Sonnet) | 200k tokens |
| **Google** | Gemini Free | Gemini Advanced ($20/mo) | $3.50/$10.50 (Pro) | 1M tokens (Pro) |
| **Cursor** | Free (limited fast) | Pro ($20/mo) | Included in subscription | Model-dependent |
| **GitHub Copilot** | N/A | Individual ($10/mo) | Included in subscription | Not disclosed |
| **Mistral** | N/A | API only | $2.70/$8.10 (Medium) | 128k tokens |
| **Groq** | Free tier | API pay-as-go | Very low (model-dependent) | Model-dependent |
| **DeepSeek** | N/A | API only | ~$0.50/$1.50 (estimated) | Large context |
| **Perplexity** | Free (limited) | Pro ($20/mo) | Included in subscription | Model-dependent |
| **Windsurf** | Free | Enterprise (custom) | Included in subscription | Not disclosed |

---

## 🎯 Provider Recommendations by Use Case

### For Chat & General AI Work
**Winner: Anthropic Claude Pro ($20/mo)**
- ✅ 200k session context (great for long conversations)
- ✅ Fair use ~500k-1M daily (unofficial)
- ✅ VSCode Extension included
- ✅ Priority access, all models
- ✅ Best for: Ukrainian businesses, RAG, long documents

**Runner-up: Google Gemini Advanced ($20/mo)**
- ✅ Up to 1M context (best for massive docs)
- ✅ Google ecosystem integration
- ✅ Included in Google One AI Premium

### For Coding (IDE Integration)
**Winner: Cursor Pro ($20/mo)**
- ✅ Native IDE experience
- ✅ GPT-4 + Claude models
- ✅ Fast autocomplete + chat
- ✅ Best for: Full-time developers

**Runner-up: GitHub Copilot Individual ($10/mo)**
- ✅ Cheapest coding assistant
- ✅ Deep GitHub integration
- ✅ Code completions + chat
- ✅ Best for: GitHub-heavy workflows

### For API Integration
**Winner: DeepSeek API**
- ✅ Ultra-cheap (~$0.50/$1.50 per 1M)
- ✅ Strong coding performance
- ✅ Large context available
- ✅ Best for: High-volume, cost-sensitive

**Runner-up: Anthropic API**
- ✅ Best quality (Sonnet/Opus)
- ✅ $3/$15 per 1M (Sonnet)
- ✅ 200k context, prompt caching
- ✅ Best for: Quality-first applications

### For Budget-Conscious Users
**Winner: DeepSeek API**
- ✅ Sub-$1 per 1M input
- ✅ Strong performance
- ✅ Growing rapidly

**Runner-up: Groq Free Tier**
- ✅ Completely free (with limits)
- ✅ Extremely fast inference
- ✅ Good for real-time apps

---

## 📋 Detailed Provider Breakdown

### 1. Anthropic (Claude)

**🌟 Strengths:**
- Best-in-class context understanding
- Strong long-document performance
- Ukrainian market friendly (no .ru services)
- VSCode Extension for Pro subscribers

**⚠️ Considerations:**
- API: No published daily limits (tier-based)
- Pro subscription: Daily limits not publicly disclosed (~500k-1M estimated)
- Fair use policy (not hard limits)

**Plans:**

| Plan | Cost | Context | Daily | Best For |
|------|------|---------|-------|----------|
| API | Pay-as-go | 200k | Unlimited* | High-volume apps |
| claude.ai Free | Free | 200k | ~8k est. | Testing, light use |
| **Claude Pro** | **$20/mo** | **200k** | **~500k est.** | **Recommended** |
| Claude Team | $25-30/user | 200k | ~800k est. | Teams 3+ |

**Pricing (API):**
- Sonnet: $3/$15 per 1M tokens (input/output)
- Opus: $15/$75 per 1M tokens
- Haiku: $0.25/$1.25 per 1M tokens
- Prompt caching available (90% discount)

**Sources:**
- https://www.anthropic.com/pricing
- https://console.anthropic.com/settings/limits

---

### 2. Google (Gemini)

**🌟 Strengths:**
- Massive 1M context window (Pro model)
- Google ecosystem integration
- Competitive API pricing
- Free tier generous

**⚠️ Considerations:**
- Quality varies by model
- Pricing differs: AI Studio vs Vertex AI
- Fair use limits not publicly detailed

**Plans:**

| Plan | Cost | Context | Daily | Best For |
|------|------|---------|-------|----------|
| API | Pay-as-go | 1M (Pro) | Unlimited* | API users |
| Gemini Free | Free | 32k | ~15k est. | Testing |
| **Gemini Advanced** | **$20/mo** | **1M** | **~80k est.** | **Google users** |

**Pricing (API):**
- Gemini 1.5 Pro: $3.50/$10.50 per 1M tokens
- Gemini 1.5 Flash: $0.35/$1.05 per 1M tokens

**Sources:**
- https://ai.google.dev/pricing
- https://gemini.google.com/advanced

---

### 3. Cursor

**🌟 Strengths:**
- Best native IDE experience for AI
- Access to multiple models (GPT-4, Claude)
- Fast autocomplete + powerful chat
- Growing rapidly

**⚠️ Considerations:**
- Token limits not publicly disclosed
- Soft caps (priority reduced after heavy use)
- Requires switching from existing IDE

**Plans:**

| Plan | Cost | Features | Best For |
|------|------|----------|----------|
| Free | Free | Limited fast requests | Testing |
| **Pro** | **$20/mo** | **Large fast request allowance** | **Full-time devs** |
| Business | $40/user | Priority + team features | Teams |

**Sources:**
- https://cursor.sh/pricing

---

### 4. GitHub Copilot

**🌟 Strengths:**
- Cheapest coding assistant ($10/mo)
- Deep GitHub integration
- Code completions + chat
- Trusted by millions

**⚠️ Considerations:**
- Token limits not published
- Fair use throttling
- Less transparent than competitors

**Plans:**

| Plan | Cost | Features | Best For |
|------|------|----------|----------|
| **Individual** | **$10/mo** or **$100/yr** | **Code + chat** | **Budget-conscious** |
| Business | $19/user | Org controls | Teams |
| Enterprise | Custom | Full integration | Large orgs |

**Sources:**
- https://github.com/features/copilot

---

### 5. Mistral

**🌟 Strengths:**
- Strong EU-based alternative
- Often cheaper than GPT-4 class
- Open-weight ecosystem
- Good performance

**⚠️ Considerations:**
- API only (no subscription plans)
- Smaller context (32k-128k typical)
- Less known in US market

**Pricing (API):**
- Mistral Large: $8/$24 per 1M tokens
- Mistral Medium: $2.70/$8.10 per 1M tokens
- Mistral Small: $1/$3 per 1M tokens

**Sources:**
- https://mistral.ai/technology/#pricing

---

### 6. Groq

**🌟 Strengths:**
- **Extremely fast inference** (key differentiator)
- Free tier available
- Popular for real-time apps
- Low-cost paid tier

**⚠️ Considerations:**
- Uses open models (LLaMA, Mixtral variants)
- Quality below GPT-4/Claude
- Free tier has hard daily caps

**Plans:**

| Plan | Cost | Features | Best For |
|------|------|----------|----------|
| **Free** | **Free** | **Limited daily** | **Real-time apps** |
| Paid | Pay-as-go | Very low pricing | High-volume |

**Sources:**
- https://groq.com/

---

### 7. DeepSeek

**🌟 Strengths:**
- **Ultra-cheap** (sub-$1 per 1M input)
- Strong coding performance
- Rapid adoption 2025-2026
- Large context models

**⚠️ Considerations:**
- New player (less track record)
- Limited public documentation
- Pricing estimates (not fully confirmed)

**Pricing (API - Estimated):**
- Input: ~$0.50 per 1M tokens
- Output: ~$1.50 per 1M tokens

**Sources:**
- https://www.deepseek.com/

---

### 8. Perplexity

**🌟 Strengths:**
- Search-first UX
- Mix of models (OpenAI, Anthropic)
- Good for research
- Free tier available

**⚠️ Considerations:**
- Not a pure LLM (search-focused)
- Token limits measured in "searches"
- Less suitable for coding

**Plans:**

| Plan | Cost | Features | Best For |
|------|------|----------|----------|
| Free | Free | Limited Pro searches | Light research |
| **Pro** | **$20/mo** | **Higher allowance** | **Heavy research** |

**Sources:**
- https://www.perplexity.ai/pro

---

### 9. Windsurf (Codeium)

**🌟 Strengths:**
- AI IDE (competes with Cursor)
- Built-in models
- Free tier available
- Enterprise focus

**⚠️ Considerations:**
- Token limits not publicly quantified
- Newer player
- Less documentation than Cursor

**Plans:**

| Plan | Cost | Features | Best For |
|------|------|----------|----------|
| Free | Free | Fair use | Testing |
| Enterprise | Custom | Per-seat pricing | Large teams |

**Sources:**
- https://codeium.com/windsurf

---

## 💰 Cost Comparison Calculator

### Example: 1M tokens/month usage

| Provider | Plan | Monthly Cost | Cost per 1M Tokens |
|----------|------|--------------|---------------------|
| DeepSeek | API | ~$2.00 | $0.50 (in) + $1.50 (out) |
| Mistral Small | API | ~$4.00 | $1 (in) + $3 (out) |
| Anthropic Sonnet | API | ~$18.00 | $3 (in) + $15 (out) |
| Google Pro | API | ~$14.00 | $3.50 (in) + $10.50 (out) |
| Mistral Large | API | ~$32.00 | $8 (in) + $24 (out) |
| Anthropic Opus | API | ~$90.00 | $15 (in) + $75 (out) |

**Subscriptions (included usage):**
- Claude Pro: $20/mo (includes VSCode Extension, ~500k-1M daily)
- Cursor Pro: $20/mo (includes IDE, large fast request allowance)
- GitHub Copilot: $10/mo (includes code + chat)
- Gemini Advanced: $20/mo (includes Google ecosystem)

---

## 🎯 Decision Matrix

**Choose Anthropic Claude Pro if:**
- ✅ You need long-context conversations (200k)
- ✅ You value quality over cost
- ✅ You work with long documents/RAG
- ✅ You use VSCode
- ✅ You need Ukrainian market compliance

**Choose Cursor Pro if:**
- ✅ You're a full-time developer
- ✅ You need fast autocomplete + chat
- ✅ You want native IDE experience
- ✅ You use multiple models

**Choose GitHub Copilot if:**
- ✅ Budget is primary concern ($10/mo)
- ✅ You live in GitHub
- ✅ You need basic code assistance
- ✅ You trust Microsoft ecosystem

**Choose DeepSeek API if:**
- ✅ Cost is CRITICAL
- ✅ High-volume usage (1M+ tokens/month)
- ✅ Coding is primary use case
- ✅ You can handle API integration

---

## 📊 Token Limit Reality Check

**⚠️ Important Notes:**

1. **Subscription Plans:** Most don't publish exact token limits
   - Claude Pro: ~500k-1M daily (estimated, fair use)
   - Cursor Pro: "Large allowance" (not quantified)
   - GitHub Copilot: Not disclosed

2. **API Plans:** Usually no hard limits, tier-based rate limiting
   - Anthropic API: Grows with spend history
   - Google API: GCP quota management
   - Mistral API: Tiered quotas

3. **"Fair Use" means:**
   - No exact hard limit published
   - Rate limiting kicks in with heavy use
   - Priority reduced, not blocked
   - Designed for normal human usage patterns

4. **How to check real usage:**
   - Anthropic API: https://console.anthropic.com/settings/limits
   - Claude Pro: https://claude.ai/settings/usage
   - Google API: Google Cloud Console
   - Cursor/Copilot: No public usage dashboard

---

## 🔄 Migration Tips

### From ChatGPT Plus → Claude Pro
- ✅ Similar price ($20/mo)
- ✅ Better long-context
- ✅ VSCode Extension included
- ⚠️ Different UX

### From Copilot → Cursor Pro
- ✅ More powerful chat
- ✅ Multiple models
- ⚠️ 2x price ($20 vs $10)
- ⚠️ IDE switch required

### From Any Subscription → API
- ✅ More control
- ✅ Transparent pricing
- ⚠️ Need to handle integration
- ⚠️ May cost more at high volume

---

## 📚 Additional Resources

**Token Management:**
- See `.ai/token-limits.json` for comprehensive PRESETS
- Run `npm run token-status` for usage dashboard

**Session Management:**
- See `.ai/docs/session-mgmt.md` for best practices
- Continue vs restart decision guide

**Framework:**
- See `AGENTS.md` for project overview
- See `.ai/contexts/` for AI context presets

---

**Made in Ukraine 🇺🇦**
**Last Updated:** 2026-02-07
**v9.1 Optimization Release**
