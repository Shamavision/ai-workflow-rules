# AI Provider Comparison Guide

> **Last Updated:** 2026-02-20
> **Data Source:** ChatGPT-compiled from official docs + community reports (Feb 2026)
> **Coverage:** 10 providers, 30+ plans
> **2026 Reality:** Most consumer plans (MODEL_3) use Fair Use Dynamic limits. No published daily/monthly caps.
> **Legend:** NOT DISCLOSED = provider intentionally hides. UNCONFIRMED = community estimate only.

---

## 📊 Quick Comparison Table

| Provider | Best Free | Best Paid | API Cost (input/output per 1M) | Session Limit |
|----------|-----------|-----------|-------------------------------|---------------|
| **Anthropic** | claude.ai Free | Claude Pro ($20) / Max ($100-200) | $3/$15 (Sonnet 4.5) | 200k tokens |
| **OpenAI** | ChatGPT Free | Plus ($20) / Pro ($200) | $5/$20 (GPT-4o) | 128k tokens |
| **Google** | Gemini Free | Advanced (~$20) | $0.30/$2.50 (Flash 2.5) | 1M+ tokens |
| **Cursor** | Free (limited) | Pro ($20) | Included | NOT DISCLOSED |
| **GitHub Copilot** | Free (2000/day) | Individual ($10) | Included | NOT DISCLOSED |
| **Windsurf** | Free | Paid (~$15, UNCONFIRMED) | Included | NOT DISCLOSED |
| **Mistral** | N/A | API only | $2/$6 (Large) | 128k tokens |
| **Groq** | Free (14.4k req/day) | API pay-as-go | $0.59/$0.79 (Llama3-70B) | 128k tokens |
| **DeepSeek** | N/A | API only | $0.07–$0.28 / $1.10 (chat) | 64-128k tokens |
| **Perplexity** | Free | Pro ($20) | Included | Model-dependent |

---

## 🤖 Supported AI Tools (this framework)

| Tool | Rule File | Status |
|------|-----------|--------|
| Claude Code (CLI/VSCode) | `.claude/CLAUDE.md` | ✅ Full support |
| Cursor | `.cursorrules` | ✅ Full support |
| Windsurf | `.windsurfrules` | ✅ Full support |
| Any AI (web) | `AGENTS.md` | ✅ Via `//START` |
| Continue.dev | `.continuerules` | ❌ File missing — planned |

---

## 📋 Detailed Provider Breakdown

### 1. Anthropic (Claude)

**🌟 Strengths:** Best-in-class context understanding, 200k+ context, Ukrainian market friendly, VSCode Extension included with Pro.

**⚠️ Considerations:** Pro/Free/Team/Max = MODEL_3 (Fair Use Dynamic) — daily/monthly NOT DISCLOSED by design.

**Plans:**

| Plan | Cost | Context | Access Type | Daily | Notes |
|------|------|---------|-------------|-------|-------|
| claude.ai Free | $0 | 200k | subscription | NOT DISCLOSED | Fair use |
| **Claude Pro** | **$20/mo** | **200k** | **subscription** | **NOT DISCLOSED** | **Recommended** |
| Claude Max | $100-200/mo | 200k | subscription | NOT DISCLOSED | 5× or 20× usage vs Pro (unquantified officially) |
| Claude Team | $25-30/user | 200k | subscription | NOT DISCLOSED | Pooled workspace |
| API — Sonnet 4.5 | pay-as-go | 200k | billing | unlimited* | $3/$15 per 1M |
| API — Opus 4.5 | pay-as-go | 200k | billing | unlimited* | $5/$25 per 1M (Nov 2025) |
| API — Haiku 4.5 | pay-as-go | 200k | billing | unlimited* | $1/$5 per 1M |

† NOT DISCLOSED — Fair Use Dynamic (MODEL_3). No official daily/monthly quota published.
* Metered billing, no hard daily cap.

**Sources:** anthropic.com/pricing, Anthropic API docs Nov 2025

---

### 2. OpenAI (ChatGPT)

**🌟 Strengths:** Most widely used, strong coding with GPT-4o, large ecosystem.

**⚠️ Considerations:** All subscription plans = MODEL_3. Daily limits NOT DISCLOSED by OpenAI.

**Plans:**

| Plan | Cost | Context | Access Type | Daily | Notes |
|------|------|---------|-------------|-------|-------|
| ChatGPT Free | $0 | NOT DISCLOSED | subscription | NOT DISCLOSED | ~10 msgs/5h (community) |
| **ChatGPT Plus** | **$20/mo** | **NOT DISCLOSED** | **subscription** | **NOT DISCLOSED** | **~160 msgs/3h (community)** |
| ChatGPT Pro | $200/mo | NOT DISCLOSED | subscription | NOT DISCLOSED | "Unlimited" subject to fair use |
| ChatGPT Team | $25-30/user | NOT DISCLOSED | subscription | NOT DISCLOSED | Business plan |
| ChatGPT Enterprise | custom | NOT DISCLOSED | subscription | NOT DISCLOSED | Contract-based |
| API — GPT-4o | pay-as-go | 128k | billing | unlimited* | $5/$20 per 1M |
| API — GPT-4o mini | pay-as-go | 128k | billing | unlimited* | $0.30/$1.25 per 1M |

**Sources:** openai.com/chatgpt-pricing, openai.com/api/pricing

---

### 3. Google (Gemini)

**🌟 Strengths:** Massive context (1M-2M), Google ecosystem integration, competitive 2.5 Flash pricing.

**⚠️ Considerations:** Gemini 2.5 series is current (2026). Old 1.5 pricing no longer relevant.

**Plans:**

| Plan | Cost | Context | Access Type | Daily | Notes |
|------|------|---------|-------------|-------|-------|
| Gemini Free | $0 | NOT DISCLOSED | subscription | NOT DISCLOSED | CLI: ~1000 req/day (preview) |
| **Gemini Advanced** | **~$20/mo** | **1M** | **subscription** | **NOT DISCLOSED** | **Google One AI Premium** |
| API — Flash-Lite 2.5 | pay-as-go | 1M | billing | unlimited* | $0.10/$0.40 per 1M |
| API — Flash 2.5 | pay-as-go | 1M | billing | unlimited* | $0.30/$2.50 per 1M |
| API — Pro 2.5 | pay-as-go | 2M | billing | unlimited* | $1.25-2.50 / $10-15 per 1M (tiered) |

**Sources:** ai.google.dev/pricing, Google Cloud (2026)

---

### 4. Cursor

**🌟 Strengths:** Best native IDE experience, access to GPT-4 + Claude models, fast autocomplete.

**⚠️ Considerations:** Token limits NOT DISCLOSED. Soft caps after heavy use.

**Plans:**

| Plan | Cost | Access Type | Daily | Notes |
|------|------|-------------|-------|-------|
| Free | $0 | subscription | NOT DISCLOSED | Limited fast requests |
| **Pro** | **$20/mo** | **subscription** | **NOT DISCLOSED** | **~500 premium req/mo (community, UNCONFIRMED)** |
| Business | $40/user | subscription | NOT DISCLOSED | Team management |

**Sources:** cursor.sh/pricing (community estimates for limits)

---

### 5. GitHub Copilot

**🌟 Strengths:** Cheapest coding assistant, deep GitHub integration, now has free tier.

**⚠️ Considerations:** No token-level limits published. Fair use applies.

**Plans:**

| Plan | Cost | Daily Limit | Notes |
|------|------|-------------|-------|
| **Free** | **$0** | **2000 completions + 50 chat/day** | **Officially documented limits** |
| Individual (Pro) | $10/mo | 300 premium req/mo | Unlimited completions |
| Pro+ | $39/mo | NOT DISCLOSED | Higher limits (UNCONFIRMED — community) |
| Business | $19/user | NOT DISCLOSED | Organization controls |
| Enterprise | custom | NOT DISCLOSED | Contract-based |

**Sources:** github.com/features/copilot (official docs for Free tier limits)

---

### 6. Windsurf (Codeium)

**🌟 Strengths:** AI IDE competing with Cursor, free tier available.

**⚠️ Considerations:** Pricing mostly UNCONFIRMED. No official docs for limits.

**Plans:**

| Plan | Cost | Daily | Notes |
|------|------|-------|-------|
| Free | $0 | NOT DISCLOSED | Fair use |
| Paid | ~$15/mo | NOT DISCLOSED | UNCONFIRMED — community estimates |
| Enterprise | custom | NOT DISCLOSED | Contract-based |

**Sources:** codeium.com/windsurf (official pricing not publicly detailed as of 2026-02-20)

---

### 7. Mistral

**🌟 Strengths:** Strong EU alternative, prices dropped significantly in 2026, open-weight ecosystem.

**⚠️ Considerations:** API only (no subscription plans). Prices from community comparison — verify at mistral.ai.

**Pricing (API):**

| Model | Input/1M | Output/1M | Context |
|-------|----------|-----------|---------|
| Mistral Large | $2.00 | $6.00 | 128k |
| Mistral Medium | $1.00 | $3.00 | 128k |
| Mistral Small | $0.10 | $0.10 | 128k |
| Codestral | $0.15 | $0.15 | 128k (UNCONFIRMED) |

**Sources:** mistral.ai/technology/#pricing (community comparison 2026 — verify directly)

---

### 8. DeepSeek

**🌟 Strengths:** Ultra-cheap with confirmed official pricing, strong coding, cache-aware billing.

**⚠️ Considerations:** Cache-hit vs cache-miss pricing — plan accordingly.

**Pricing (API — Official):**

| Model | Input cache-hit | Input cache-miss | Output/1M | Context |
|-------|----------------|-----------------|-----------|---------|
| DeepSeek-chat | $0.07 | $0.28 | $1.10 | 64-128k |
| DeepSeek-reasoner (R1) | $0.14 | $0.55 | $2.19 | 64k |

**Sources:** api-docs.deepseek.com/quick_start/pricing (official, confirmed)

---

### 9. Groq

**🌟 Strengths:** Extremely fast inference, free tier with hard daily limits, low API cost.

**⚠️ Considerations:** Uses open models (Llama, Mixtral). Quality below GPT-4/Claude.

**Plans:**

| Plan | Cost | Daily Limit | Notes |
|------|------|-------------|-------|
| Free | $0 | 14,400 req/day; 6,000 tokens/min | Fast inference, capacity-based |
| API — Llama3-70B | pay-as-go | unlimited* | $0.59/$0.79 per 1M |
| API — Llama3-8B | pay-as-go | unlimited* | $0.05/$0.08 per 1M |
| API — Mixtral-8x7B | pay-as-go | unlimited* | $0.27/$0.27 per 1M (32k ctx) |

**Sources:** groq.com/pricing (community data aggregators, 2026)

---

### 10. Perplexity

**🌟 Strengths:** Search-first UX, good for research, free tier available.

**⚠️ Considerations:** Not a pure LLM — search-focused. Less suitable for coding.

**Plans:**

| Plan | Cost | Daily | Notes |
|------|------|-------|-------|
| Free | $0 | NOT DISCLOSED | Limited Pro searches |
| **Pro** | **$20/mo** | **NOT DISCLOSED** | Higher allowance |

**Sources:** perplexity.ai/pro

---

## 💰 API Cost Comparison (per 1M tokens input)

| Provider / Model | Input | Output | Context |
|-----------------|-------|--------|---------|
| DeepSeek-chat (cache hit) | **$0.07** | $1.10 | 64k |
| Groq Llama3-8B | $0.05 | $0.08 | 128k |
| Gemini Flash-Lite 2.5 | $0.10 | $0.40 | 1M |
| Mistral Small | $0.10 | $0.10 | 128k |
| GPT-4o mini | $0.30 | $1.25 | 128k |
| Gemini Flash 2.5 | $0.30 | $2.50 | 1M |
| Groq Llama3-70B | $0.59 | $0.79 | 128k |
| Gemini Pro 2.5 | $1.25 | $10.00 | 2M |
| Mistral Large | $2.00 | $6.00 | 128k |
| Claude Sonnet 4.5 | $3.00 | $15.00 | 200k |
| GPT-4o | $5.00 | $20.00 | 128k |
| Claude Opus 4.5 | $5.00 | $25.00 | 200k |

---

## 📊 Token Limit Reality Check (2026)

**⚠️ Critical 2026 Market Shift:** Industry moved from fixed quotas → elastic compute. Most providers stopped publishing daily/monthly limits.

### Architecture Models (3 types):

| Model | Used By | Daily/Monthly Limits |
|-------|---------|----------------------|
| **MODEL_1** (Hard Billing) | Anthropic API, OpenAI API, Mistral, DeepSeek, Google API, Groq API | Published, metered |
| **MODEL_2** (Request Quota) | GitHub Copilot | Monthly request caps (300/month individual) |
| **MODEL_3** (Fair Use Dynamic) | Claude Pro/Max/Team, ChatGPT Plus/Pro/Team, Gemini Advanced, Cursor, Windsurf | **NOT DISCLOSED** |

> **VARIANT B:** Framework uses conservative estimates for planning (clearly marked ESTIMATE ONLY). See `.ai/token-limits.json` for per-plan values.

---

## 🎯 Decision Matrix

**Choose Claude Pro ($20) if:**
- ✅ Long-context conversations (200k, best in class)
- ✅ Quality is priority
- ✅ Ukrainian market compliance required
- ✅ You use VSCode or Claude Code CLI

**Choose ChatGPT Plus ($20) if:**
- ✅ Broad ecosystem / plugins / DALL-E
- ✅ GPT-4o preferred
- ✅ OpenAI integrations needed

**Choose Cursor Pro ($20) if:**
- ✅ Full-time developer needing native IDE
- ✅ Fast autocomplete + multi-model access

**Choose GitHub Copilot ($10) if:**
- ✅ Budget is primary concern
- ✅ GitHub-heavy workflow
- ✅ Basic code assistance sufficient

**Choose DeepSeek API if:**
- ✅ Cost is critical (cheapest confirmed pricing)
- ✅ High-volume usage
- ✅ Coding is primary use case

**Choose Gemini Flash 2.5 API if:**
- ✅ Need 1M context at low cost
- ✅ Google ecosystem integration

---

## 📚 Additional Resources

- `.ai/token-limits.json` — full PRESETS database with all plans
- `npm run token-status` — usage dashboard
- `.ai/docs/session-mgmt.md` — session best practices

---

**Made in Ukraine 🇺🇦**
**Last Updated:** 2026-02-20 | **v9.1.1 + Phase data refresh**
