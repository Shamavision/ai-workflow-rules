# 🤖 AI Assistant Compatibility

**Framework Version:** 7.1 Universal

This framework supports multiple AI assistants through **AGENTS.md universal standard** (auto-loaded by 90%+ modern AI coding tools).

---

## Compatibility Matrix

| AI Assistant | AGENTS.md | Auto-Load | Config File | Token Tracking | Recommended |
|-------------|-----------|-----------|-------------|----------------|-------------|
| **Claude Code** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐⭐ |
| **Cursor** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐⭐ |
| **Windsurf** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐⭐ |
| **Aider** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐ |
| **Continue.dev** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐ |
| **OpenAI Codex** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐ |
| **Google Jules** | ✅ Yes | ✅ Automatic | AGENTS.md | ✅ Full | ⭐⭐⭐⭐ |
| **ChatGPT (Web)** | ❌ No | ❌ Manual | START.md (copy-paste) | ⚠️ Basic | ⭐⭐⭐ |
| **GitHub Copilot** | ⚠️ Limited | ⚠️ Partial | AGENTS.md (limited context) | ❌ None | ⭐⭐ |
| **Gemini (Web)** | ❌ No | ❌ Manual | START.md (copy-paste) | ⚠️ Basic | ⭐⭐⭐ |

**✨ New in v7.1:** AGENTS.md universal standard support = automatic rule loading in 90%+ AI coding tools!

---

## What is AGENTS.md?

**AGENTS.md** is an open, universal format for guiding AI coding agents, supported by 60,000+ open-source projects.

**Key Benefits:**
- ✅ **Auto-loaded** by most modern AI coding tools
- ✅ **Markdown-based** - human-readable, easy to edit
- ✅ **Cross-platform** - works with Claude, Cursor, Windsurf, Aider, Continue, Codex, etc.
- ✅ **Standardized** - collaborative effort by OpenAI, Sourcegraph, Google, Anthropic

**How It Works:**
1. Place `AGENTS.md` in project root
2. AI tool automatically reads it at session start
3. Rules applied automatically - no manual action needed

**Fallback:**
- `START.md` - Manual trigger for old versions or web-based AI (ChatGPT, Gemini)

**Learn More:**
- [AGENTS.md Official Site](https://agents.md/)
- [GitHub Spec](https://github.com/agentsmd/agents.md)

---

## Feature Support Details

### Claude Code (Anthropic)
**Status:** ✅ Fully Supported (Primary Target)

**What Works:**
- ✅ Automatic RULES detection in project
- ✅ Full token tracking with `.ai/token-limits.json`
- ✅ Context compression at 50% tokens
- ✅ Graduated warning system (Green → Moderate → Caution → Critical)
- ✅ Session checkpoints for multi-day projects
- ✅ Russian service detection via forbidden-trackers.json
- ✅ Pre-commit hooks (bash)
- ✅ All 9 security checks in `seo-check.sh`

**Installation:**
- Copy `.ai/`, `RULES_*.md`, `START.md` to project root
- Git hooks install automatically

**Notes:**
- This framework was built specifically for Claude Code
- Best experience guaranteed

---

### Cursor IDE
**Status:** ✅ Fully Supported

**What Works:**
- ✅ Same as Claude Code (Cursor is built on VS Code)
- ✅ Automatic RULES detection
- ✅ Full token tracking
- ✅ All security features

**Installation:**
- Same as Claude Code (copy files)

**Notes:**
- Cursor uses Claude/GPT-4 under the hood
- Token tracking works for both providers
- Set `provider` in `.ai/token-limits.json` accordingly

---

### ChatGPT (Web Interface)
**Status:** ⚠️ Partially Supported

**What Works:**
- ✅ Basic RULES following (if manually provided)
- ✅ Security guidelines (russian service detection)
- ⚠️ Basic token awareness (no automatic tracking)

**What Doesn't Work:**
- ❌ Automatic file reading (no file access in web UI)
- ❌ Token tracking (no API access to usage data)
- ❌ Context preservation (history may reset when uploading files)
- ❌ Pre-commit hooks (no git integration)

**Installation:**
1. Open [`START.md`](START.md)
2. Copy content into ChatGPT
3. Tell ChatGPT: "Follow these rules throughout our conversation"

**Workarounds:**
- Copy `.ai/rules/core.md` content at session start
- Manually check `.ai/forbidden-trackers.json` before adding services
- Re-paste rules if ChatGPT forgets (long conversations)

**Known Issues:**
- ChatGPT may clear history when you upload project files
- No persistence between sessions
- Limited context window (shorter than Claude)

---

### ChatGPT (API/Plugins)
**Status:** ✅ Well Supported

**What Works:**
- ✅ RULES injection via system prompt
- ✅ Token tracking (via API response)
- ✅ Persistent context (if configured)
- ✅ Security checks

**What Doesn't Work:**
- ⚠️ Requires manual prompt engineering (inject RULES into system message)
- ❌ Pre-commit hooks (unless running locally)

**Installation:**
- Include `.ai/rules/core.md` content in API system prompt
- Use `.ai/token-limits.json` to track API usage

**Example API Usage:**
```javascript
const response = await openai.chat.completions.create({
  model: "gpt-4",
  messages: [
    {
      role: "system",
      content: fs.readFileSync('.ai/rules/core.md', 'utf8') // Inject rules
    },
    { role: "user", content: "Your task here" }
  ]
});
```

---

### GitHub Copilot
**Status:** ⚠️ Limited Support

**What Works:**
- ⚠️ Basic code completion following nearby code patterns
- ⚠️ Security rules (if added as comments in code)

**What Doesn't Work:**
- ❌ RULES file reading (Copilot doesn't read external files)
- ❌ Token tracking (no usage API)
- ❌ Complex workflow (Copilot is autocomplete, not conversational)
- ❌ Russian service detection (unless hardcoded in comments)

**Installation:**
- Copy key rules into code comments:
  ```javascript
  // SECURITY RULE: Never use Yandex Metrika, VK Pixel, or other russian trackers
  // SECURITY RULE: Always use process.env for secrets
  ```

**Recommendation:**
- Use GitHub Copilot for **autocomplete only**
- Use Claude Code / Cursor for **complex tasks and refactoring**

---

### Gemini (Google AI)
**Status:** ⚠️ Partially Supported (Experimental)

**What Works:**
- ✅ Basic RULES following (if manually provided)
- ✅ Security guidelines
- ⚠️ Basic token awareness

**What Doesn't Work:**
- ❌ Automatic file reading (similar to ChatGPT web)
- ⚠️ Token tracking (limited API access)
- ❌ Pre-commit hooks

**Installation:**
- Similar to ChatGPT Web (copy-paste `START.md`)

**Notes:**
- Gemini support is experimental
- Set `provider: "google"` in `.ai/token-limits.json` if using API

---

### JetBrains AI Assistant
**Status:** ⚠️ Basic Support

**What Works:**
- ⚠️ Basic code assistance
- ⚠️ RULES reading (if AI Assistant plugin configured)

**What Doesn't Work:**
- ❌ Automatic RULES detection (requires manual plugin config)
- ❌ Token tracking
- ⚠️ Pre-commit hooks (may work, not tested)

**Installation:**
1. Install **AI Assistant** plugin in JetBrains IDE
2. Copy `.ai/` and `RULES_*.md` to project
3. Configure plugin to read `.ai/rules/core.md` at startup (if supported)

**Notes:**
- JetBrains AI support varies by IDE version and plugin
- Not extensively tested

---

## Common Issues & Solutions

### Issue: "AI doesn't read the rules"

**Solution:**
- **Claude Code / Cursor:** Rules should be auto-detected. Restart IDE if needed.
- **ChatGPT Web:** You must manually copy-paste `START.md` content
- **GitHub Copilot:** Add key rules as code comments

---

### Issue: "Token tracking doesn't work"

**Solution:**
- **ChatGPT Web / Gemini Web:** Token tracking requires API access. Not available in web UI.
- **Claude Code / Cursor:** Check that `.ai/token-limits.json` exists and has correct `provider` set
- **GitHub Copilot:** No token tracking available (Copilot doesn't expose usage metrics)

---

### Issue: "History resets in ChatGPT"

**Cause:** ChatGPT web clears conversation when you upload project files

**Solution:**
- Use ChatGPT API (with RULES in system prompt) for persistent context
- Or re-paste rules after uploading files

---

### Issue: "Pre-commit hooks don't work"

**Cause:** Git hooks require bash (Unix shell)

**Solution:**
- **Windows:** Use Git Bash or WSL (Windows Subsystem for Linux)
- **macOS/Linux:** Make sure hook is executable (`chmod +x .git/hooks/pre-commit`)

---

## Recommended AI for Different Use Cases

| Use Case | Recommended AI | Why |
|----------|---------------|-----|
| **Full project development** | Claude Code | Best RULES support, token management, security |
| **Quick prototyping** | Cursor | Fast, full-featured, multi-model support |
| **Code completion only** | GitHub Copilot | Excellent autocomplete, but limited for complex tasks |
| **Web-based work** | ChatGPT Web + Claude.ai | Good for quick tasks, discussions |
| **API integration** | Claude API / ChatGPT API | Full control, RULES injection via system prompt |

---

## Testing Checklist

To verify compatibility with your AI assistant:

- [ ] AI reads `.ai/rules/core.md` (automatic or manual)
- [ ] AI follows Russian service prohibition (check `.ai/forbidden-trackers.json`)
- [ ] AI respects language rules (Russian dialogue, English code)
- [ ] Token tracking works (if applicable)
- [ ] Pre-commit hooks block violations (if installed)
- [ ] `./scripts/seo-check.sh` runs successfully

---

## Provider Token Limits Reference

See `.ai/token-limits.json` PRESETS section for up-to-date limits:

| Provider | Free Plan | Paid Plan | Docs |
|----------|-----------|-----------|------|
| **Anthropic (Claude)** | ~250k/month | ~5M/month (Pro) | [console.anthropic.com](https://console.anthropic.com/settings/limits) |
| **OpenAI (ChatGPT)** | ~80k/month | ~800k/month (Plus) | [platform.openai.com](https://platform.openai.com/account/limits) |
| **Google (Gemini)** | ~400k/month | ~1.5M/month (Pro) | [ai.google.dev/pricing](https://ai.google.dev/pricing) |
| **Cursor** | ~150k/month | ~1.5M/month (Pro) | [cursor.sh/pricing](https://cursor.sh/pricing) |
| **GitHub Copilot** | ~100k/month | ~500k/month (Individual) | [github.com/features/copilot](https://github.com/features/copilot) |

**Note:** Limits are conservative estimates (10-20% lower than actual). Always check official docs.

---

## Future Support Plans

### Coming Soon:
- 🔄 **VS Code Extension** — visual RULES management
- 🔄 **GitHub Action** — automatic checks in CI/CD
- 🔄 **PowerShell pre-commit** — native Windows support

### Under Consideration:
- ❓ **JetBrains Plugin** — deep IDE integration
- ❓ **Slack Bot** — team workflow integration
- ❓ **Web Dashboard** — token usage analytics

**Want to help?** [Contribute on GitHub](https://github.com/Shamavision/ai-workflow-rules)

---

## Need Help?

- **Quick Start:** [`START.md`](START.md)
- **Installation:** [`INSTALL.md`](../../INSTALL.md)
- **Documentation:** [`README.md`](README.md)
- **Issues:** [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)

---

<div align="center">

**AI Workflow Rules Framework v7.0**
*Made in Ukraine 🇺🇦 • Open Source (MIT License)*

[GitHub](https://github.com/Shamavision/ai-workflow-rules) • [Website](https://wellme.ua)

</div>
