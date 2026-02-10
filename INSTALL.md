# 📦 Installation Guide

Choose the installation method that works best for your environment.

---

## ⚠️ Token Cost: Choose Your Installation Type

**First-time setup uses AI tokens** (AI reads all files automatically).

| Installation | Token Cost | Best For |
|-------------|------------|----------|
| **Minimal** | ~30k tokens | Free plan users, minimal features |
| **Full** | ~66k tokens | Pro/Team users, all features |
| **Automatic** | ~66k tokens | Everyone (script does everything) |

📖 **Details:** See [.ai/docs/token-usage.md](.ai/docs/token-usage.md)

---

## Installation Methods

### Quick Start (Recommended) 🚀

**Use automatic setup script:**

```bash
# Clone repository
git clone https://github.com/Shamavision/ai-workflow-rules.git
cd ai-workflow-rules

# Run setup script
./scripts/setup.sh  # Unix/Mac/WSL
# OR
.\scripts\setup.ps1  # Windows PowerShell

# Script will:
# - Install git hooks
# - Configure token limits (interactive)
# - Create .env from template
# - Validate installation
```

**Done!** Skip to [Verify Installation](#verify-installation) section.

---

## Option A: Simple Copy (Recommended) ✅

**Best for:** Quick start, most users, all AI assistants

### Steps:

1. **Download or clone the repository:**
   ```bash
   git clone https://github.com/Shamavision/ai-workflow-rules.git
   cd ai-workflow-rules
   ```

2. **Copy files to your project:**
   ```bash
   # Copy framework files
   cp -r .ai /path/to/your-project/
   cp -r .claude /path/to/your-project/
   cp AGENTS.md /path/to/your-project/

   # (Optional) Copy scripts for pre-deploy checks
   cp -r scripts /path/to/your-project/
   ```

3. **Install Git hooks (optional but recommended):**
   ```bash
   # Copy pre-commit hook to your project
   cp .git/hooks/pre-commit /path/to/your-project/.git/hooks/
   chmod +x /path/to/your-project/.git/hooks/pre-commit
   ```

4. **Done!** Your AI assistant will now see the rules.

---

## Option B: Git Submodule (Advanced) ⚙️

**Best for:** Teams, reusable setup across multiple projects

### Steps:

1. **Add as submodule:**
   ```bash
   cd /your-project
   git submodule add https://github.com/Shamavision/ai-workflow-rules.git .ai-rules
   ```

2. **Create symlinks:**
   ```bash
   # Link configuration files
   ln -s .ai-rules/.ai .ai
   ln -s .ai-rules/.claude .claude
   ln -s .ai-rules/AGENTS.md AGENTS.md
   ln -s .ai-rules/scripts scripts
   ```

3. **Update .gitignore:**
   ```bash
   echo ".ai-rules/" >> .gitignore
   ```

4. **Commit:**
   ```bash
   git add .gitignore .gitmodules
   git commit -m "chore: add AI workflow rules submodule"
   git push
   ```

### Clone project with submodule:
```bash
# New team member clones with rules:
git clone --recurse-submodules git@github.com:you/your-project.git

# If forgot --recurse-submodules:
git submodule update --init --recursive
```

### Update rules in all projects:
```bash
# Update submodule in one project:
cd .ai-rules
git pull origin main

# In other projects:
cd /other-project/.ai-rules
git pull origin main
```

---

## Option C: Manual Setup (ChatGPT Web, etc.) 📋

**Best for:** ChatGPT web interface, AI assistants without file access

### Steps:

1. **Download the repository** (or copy files manually)

2. **Open [`.ai/docs/start.md`](.ai/docs/start.md)** in the repository

3. **Copy the content** of the following files:
   - `.ai/docs/start.md` — quick start guide
   - `.ai/rules/core.md` — full rules
   - `.ai/rules/product.md` — product-specific rules (if needed)

4. **Paste into your AI chat:**
   ```
   [Paste .ai/docs/start.md content]

   Please read and follow these rules throughout our conversation.
   ```

5. **Start working** — the AI will remember the rules for this session

**Note:** You'll need to do this for each new ChatGPT conversation (history resets).

---

## Platform-Specific Instructions

### Windows Users

**Git Bash / WSL (recommended):**
```bash
# Use Unix commands (Option A or B above)
cp -r .ai /path/to/project/
```

**PowerShell:**
```powershell
# Copy framework files
Copy-Item -Recurse -Path ".ai" -Destination "C:\path\to\project\"
Copy-Item -Recurse -Path ".claude" -Destination "C:\path\to\project\"
Copy-Item "AGENTS.md" -Destination "C:\path\to\project\"
```

**Pre-commit hooks on Windows:**
- Use Git Bash (comes with Git for Windows)
- Or use WSL (Windows Subsystem for Linux)

### macOS / Linux Users

Use Option A or B (standard Unix commands).

### JetBrains IDEs (WebStorm, PyCharm, etc.)

1. Use **Option A** to copy files
2. Install **AI Assistant** plugin (if available)
3. Configure the plugin to read `RULES_CORE.md` at project startup
4. Pre-commit hooks work natively

### Cursor IDE

**Fully automatic!** Just use Option A or B — Cursor will detect rules automatically.

### VS Code with Claude Code

**Fully automatic!** Just use Option A or B — Claude Code will read RULES automatically.

---

## Verify Installation

After installation, verify everything works:

### 1. Check files are in place:
```bash
ls -la .ai/
# Should show: forbidden-trackers.json, locale-context.json, token-limits.json

ls -la AGENTS.md .claude/
# Should show: AGENTS.md, .claude/CLAUDE.md
```

### 2. Test pre-commit hook (if installed):
```bash
# Make a test change
echo "test" >> test.txt
git add test.txt
git commit -m "test"

# Hook should run and check for violations
# (Will pass if no russian trackers detected)
```

### 3. Run security check:
```bash
./scripts/seo-check.sh .

# Should output:
# ✅ [1] Checking robots.txt...
# ✅ [2] Checking HTML meta tags...
# ... (9 checks total)
```

### 4. Customize token limits:
```bash
nano .ai/token-limits.json

# Set your provider and plan:
{
  "provider": "anthropic",  # or "openai", "google", "cursor", etc.
  "plan": "pro",            # or "free", "team", etc.
  ...
}
```

---

## Troubleshooting

### "AI doesn't see the rules"

**Claude Code / Cursor:**
- Rules should be detected automatically via AGENTS.md
- Try restarting the IDE
- Check that `AGENTS.md` is in project root

**ChatGPT:**
- Use Option C (manual copy-paste)
- ChatGPT web doesn't have file access

**GitHub Copilot:**
- Limited context, may not read external files
- Copy key rules into code comments

### "Pre-commit hook doesn't work"

**On Windows:**
- Use Git Bash (not CMD or PowerShell)
- Or use WSL

**On Unix:**
- Make sure hook is executable: `chmod +x .git/hooks/pre-commit`
- Check shebang line: `#!/bin/bash`

### "Git submodule not updating"

```bash
# Pull latest changes in submodule:
cd .ai-rules
git pull origin main
cd ..
git add .ai-rules
git commit -m "chore: update AI rules submodule"
```

---

## Next Steps

After installation:

1. **Read [`.ai/docs/start.md`](.ai/docs/start.md)** — quick onboarding for AI assistants
2. **Read [`.ai/docs/compatibility.md`](.ai/docs/compatibility.md)** — check which features work with your AI
3. **Customize `.ai/token-limits.json`** — set your provider and plan
4. **Run `./scripts/seo-check.sh`** — verify your project is clean
5. **Start working** with your AI assistant!

---

## Need Help?

- **Documentation:** [README.md](README.md)
- **Issues:** [GitHub Issues](https://github.com/Shamavision/ai-workflow-rules/issues)
- **Examples:** Check the repository for real-world usage

---

<div align="center">

**AI Workflow Rules Framework v9.1.1**
*Made in Ukraine 🇺🇦 • Open Source (GPL-3.0 License)*

[GitHub](https://github.com/Shamavision/ai-workflow-rules) • [Website](https://wellme.ua)

</div>
