# Visual Content Creation Guide

> **Instructions for creating GIF demos and screenshots for README**

This guide helps anyone (you, contributors, future maintainers) create professional visual content for the README.

---

## 🎯 What We Need

### 1. **Main Demo GIF** (30 seconds)
- **Purpose:** Show complete workflow from install to protection
- **Location in README:** Hero section "See It Work"
- **File:** `public/demo-main.gif`
- **Max size:** 5MB (optimize for GitHub)

### 2. **Secret Detection Screenshot** (static)
- **Purpose:** Show pre-commit hook blocking secret
- **Location in README:** "Security Protection" feature
- **File:** `public/screenshot-secret-blocked.png`

### 3. **Token Status Screenshot** (static)
- **Purpose:** Show token budget tracking
- **Location in README:** "Token Control" feature
- **File:** `public/screenshot-token-status.png`

---

## 🛠️ Tools (Free & Easy)

### For Screen Recording (GIF)

**Mac:**
- **Kap** (recommended) - https://getkap.co
  - Free, open-source
  - Built-in GIF export
  - Trim, crop, resize

**Windows:**
- **ScreenToGif** (recommended) - https://www.screentogif.com
  - Free, open-source
  - Record → Edit → Export GIF
  - Excellent quality

**Linux:**
- **Peek** - https://github.com/phw/peek
  - Simple GIF recorder
  - GNOME/KDE compatible

**Cross-platform:**
- **OBS Studio** → Record MP4 → Convert to GIF
  - https://obsproject.com

### For GIF Optimization

- **ezgif.com** - https://ezgif.com/optimize
  - Online, free
  - Reduce file size without quality loss
  - Target: <5MB for GitHub

### For Screenshots

**Mac:**
- Built-in: `Cmd + Shift + 4` → drag to select area
- Save to desktop automatically

**Windows:**
- Built-in: `Win + Shift + S` → Snipping Tool
- Save as PNG

**Linux:**
- GNOME: `PrtScn` or `Shift + PrtScn` (area)
- KDE: Spectacle

---

## 📝 Recording Instructions

### GIF 1: Main Demo (30 seconds)

**Setup:**
1. Clean terminal (clear history: `clear`)
2. Simple project folder (empty or minimal files)
3. Terminal font size: 14-16pt (readable)
4. Window size: 1200x700px (landscape)

**Recording Steps:**

**Frame 1 (0-5 sec): Installation**
```bash
# Type slowly, let viewers read
$ npx github:Shamavision/ai-workflow-rules init

# Show output
✓ Downloading framework...
✓ Copying files...
✓ Configuring hooks...
✓ Installation complete!
```

**Frame 2 (5-10 sec): Start AI Session**
```bash
# Open Claude Code (or any AI assistant)
$ claude code

# In AI chat, type:
//START

# AI responds:
[SESSION START]
✓ Context loaded: ukraine-full (v8.1)
✓ Token budget: ~25k for rules (16.7% of daily)
✓ Language: Adaptive
✓ Token limit: 150k daily (Anthropic Pro)
✓ Current usage: 29k (19.3%) | Remaining: ~121k
✓ Status: 🟢 Green - Full capacity

Чим я можу вам допомогти?
```

**Frame 3 (10-20 sec): Secret Detection**
```bash
# Create .env file with fake API key (DEMO ONLY - not real)
$ echo "SECRET_API_KEY=demo_fake_key_12345" > .env

# Try to commit
$ git add .env
$ git commit -m "Add config"

# Pre-commit hook blocks it:
[PRE-COMMIT HOOK] Scanning for secrets...

❌ COMMIT BLOCKED: Secret detected!

File: .env
Line: 1
Pattern: SECRET_API_KEY=demo_fake_key_12345
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Risk: API key exposure (DEMO)

Fix: Use environment variables instead
Example: SECRET_API_KEY=${SECRET_API_KEY}

Commit aborted.
```

**Frame 4 (20-25 sec): Token Status**
```bash
# In AI chat:
//TOKENS

# AI responds:
[TOKEN STATUS]
Session: 45k/150k (30%)
Remaining: ~105k
Zone: 🟢 Green - Full capacity

Budget breakdown:
- Rules loaded: 25k (one-time)
- Current task: 20k
- Available: 105k

Optimizations available at 50% (75k).
```

**Frame 5 (25-30 sec): Success Message**
```bash
# Show final screen with text:

✅ Protected in 30 seconds!

Your project now has:
→ Secret detection (automatic)
→ Token optimization (40-60% savings)
→ Ukrainian compliance (built-in)

Ready to work safely with AI.
```

**Recording Tips:**
- Type slowly (viewers need to read)
- Pause 1-2 seconds between commands
- Use fake/demo credentials (NEVER real secrets!)
- Clear terminal before starting
- Use high contrast theme (light bg + dark text or vice versa)

---

### Screenshot 1: Secret Blocked (static)

**What to capture:**
```
Terminal showing:

$ git commit -m "Add API keys"

[PRE-COMMIT HOOK] Scanning for secrets...

❌ COMMIT BLOCKED: Secret detected!

File: config/api.ts
Line: 12
Pattern: const API_KEY = "sk_live_xxx..."
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Risk: API key exposure (Stripe/OpenAI)

Fix: Use environment variables
Example: const API_KEY = process.env.API_KEY

Commit aborted. Fix the issue and try again.
```

**Setup:**
- Terminal width: 800-1000px
- Font: 14-16pt
- Color scheme: High contrast
- Crop: Show only relevant terminal output (no menu bars)

---

### Screenshot 2: Token Status (static)

**What to capture:**
```
AI chat showing:

User: //TOKENS

AI: [TOKEN STATUS]
    Session: 92k/200k (46%)
    Daily: 115k/200k (57.5%)
    Remaining: ~85k
    Zone: 🟡 Moderate - Optimizations active

    Budget breakdown:
    ├─ Rules loaded: 25k (one-time)
    ├─ Tasks completed: 45k
    ├─ Current task: 22k
    └─ Available: 85k

    💡 Tips:
    - Context compression available (saves 40-60%)
    - Diff-only mode activated automatically
    - Use //COMPACT to compress manually
```

**Setup:**
- IDE or AI chat window
- Font: 13-15pt
- Crop: Show only AI response (relevant part)

---

## 🎨 Visual Style Guidelines

### Colors
- Use project colors:
  - Yellow: `#FAAF0D` (success, highlights)
  - Blue: `#0099CC` (info, links)
  - Black: `#1D1D1B` (background, labels)
- High contrast for readability

### Typography
- Terminal font: Monospace (Fira Code, JetBrains Mono, Consolas)
- Size: 14-16pt (must be readable on GitHub)

### Quality
- Resolution: 1200px width minimum
- Format: GIF (animated) or PNG (static)
- File size: <5MB for GIF, <500KB for PNG
- Optimize with ezgif.com or tinypng.com

---

## 📦 File Organization

```
public/
  ├── demo-main.gif              # Main 30-second demo
  ├── screenshot-secret-blocked.png  # Secret detection
  └── screenshot-token-status.png    # Token tracking
```

After creating files:
1. Move to `public/` folder
2. Update README.md placeholders
3. Test on GitHub (file sizes, loading speed)

---

## 🚀 Quick Recording Workflow

**Total time: 15-20 minutes**

1. **Prepare (5 min)**
   - Clean terminal
   - Simple test project
   - Install framework fresh

2. **Record (5 min)**
   - Run through steps 1-5
   - Don't worry about mistakes, you can trim later

3. **Edit (5 min)**
   - Trim beginning/end
   - Crop to relevant area
   - Add 1-2 second pause at end

4. **Optimize (2 min)**
   - Export as GIF
   - Upload to ezgif.com
   - Reduce to <5MB
   - Download optimized version

5. **Test (3 min)**
   - Add to README
   - Preview locally
   - Push to GitHub
   - Verify loads correctly

---

## 🤝 Contributing Visuals

**Don't have time to create?** No problem!

**Option 1: Request from community**
- Open GitHub Issue: "Help needed: Record demo GIF"
- Label: `help wanted`, `documentation`
- Someone will help!

**Option 2: Use placeholder**
- ASCII art diagram (temporary)
- Text description with "GIF coming soon"
- Link to Loom/YouTube video (external)

**Option 3: Hire someone**
- Fiverr: $10-20 for simple screen recording
- Upwork: $15-30/hour
- Local freelancer

---

## 📋 Checklist

Before publishing visuals, verify:

- [ ] GIF plays smoothly on GitHub
- [ ] File size <5MB
- [ ] No real secrets/credentials shown
- [ ] Terminal text is readable (not too small)
- [ ] Steps match README description exactly
- [ ] Colors match project branding
- [ ] Files named correctly (`demo-main.gif`, etc.)
- [ ] Committed to `public/` folder
- [ ] README updated with correct paths

---

## 💡 Pro Tips

1. **Record in 1080p, export in 720p** - Better quality after compression
2. **Use fake data** - Generate random API keys, never real ones
3. **Slow down** - Type 50% slower than normal, viewers need to read
4. **Pause between steps** - 1-2 seconds, let viewers process
5. **Test on GitHub** - Preview before final commit
6. **Keep it short** - 30 seconds max, attention spans are short
7. **Show success** - End with positive confirmation message

---

## ❓ FAQ

### Q: I don't have recording software

**A:** Use built-in tools:
- Mac: QuickTime Player (File → New Screen Recording) → Export → Convert to GIF
- Windows: Xbox Game Bar (Win + G) → Record → Convert to GIF
- Online: Loom.com (free, browser-based, can download MP4)

### Q: GIF is too large (>10MB)

**A:** Optimize:
1. Reduce resolution (1200px → 800px width)
2. Lower frame rate (30fps → 15fps)
3. Reduce colors (256 → 128)
4. Use ezgif.com optimizer

### Q: Can I use video instead of GIF?

**A:** Yes, but:
- GitHub doesn't auto-play videos
- GIF is better for README (instant preview)
- Video better for docs/ folder (detailed tutorial)

---

**Need help?** Open issue with `documentation` label or ask in discussions!

---

**Made with ❤️ in Ukraine 🇺🇦**
