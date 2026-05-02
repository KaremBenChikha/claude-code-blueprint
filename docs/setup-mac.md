# Setup: macOS

Complete installation guide for macOS 12 Monterey and later.

All commands are copy-pasteable. Run them in Terminal unless noted otherwise.

---

## Prerequisites

| Requirement | Version | Check |
|---|---|---|
| macOS | 12 Monterey or later | `sw_vers -productVersion` |
| Node.js | 18 or later | `node --version` |
| Git | Any recent version | `git --version` |
| Anthropic account | Claude Pro / Max / API | https://console.anthropic.com |

### Install Homebrew (if not installed)

Homebrew is the standard Mac package manager. Skip if you already have it.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Full instructions: https://brew.sh

### Install Node.js

```bash
brew install node
node --version   # should print v18.x or higher
```

Node.js 20 LTS is recommended. If you need to manage multiple Node versions, use nvm: https://github.com/nvm-sh/nvm

### Verify Git

Git ships with macOS via Xcode Command Line Tools. If it is not present:

```bash
brew install git
git --version
```

---

## Step 1: Install Claude Code

**Option A — Desktop app (includes CLI):**

Download from https://claude.ai/download and follow the installer. The CLI becomes available at `claude` after installation.

**Option B — CLI only via npm:**

```bash
npm install -g @anthropic-ai/claude-code
```

Verify the installation and authenticate:

```bash
claude --version
claude login
```

`claude login` opens a browser window to complete OAuth with your Anthropic account. You need a Claude Pro, Max, or API account.

---

## Step 2: Create Global CLAUDE.md

The global CLAUDE.md applies to every project you open with Claude Code.

```bash
mkdir -p ~/.claude/rules
```

Copy the template from this repo:

```bash
cp templates/global-CLAUDE.md ~/.claude/CLAUDE.md
```

**What the global CLAUDE.md contains:**

| Section | What it does |
|---|---|
| Core behavior | Sets defaults: agent-first, test-driven, security-aware, small diffs |
| Execution defaults | Directs the AI to understand before changing, plan then implement |
| Output style | Keeps responses concise with a short plan for non-trivial tasks |
| Tooling behavior | Enables agents and skills; avoids heavy workflows for small tasks |
| Quality bar | Prohibits invented APIs, enforces minimal diffs |
| Decision rule | Simple task = act simply; complex = use appropriate skill |
| Post-task updates | Requires Obsidian vault and GitHub updates after non-trivial tasks |
| Memory update rule | Non-negotiable: update SESSION.md and INDEX.md as work progresses |

---

## Step 3: Install Superpowers Plugin for Claude Code

```bash
claude plugins install superpowers@superpowers-marketplace
```

Verify the plugin is active:

```bash
cat ~/.claude/settings.json | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('enabledPlugins', {}))"
```

You should see `superpowers@superpowers-marketplace` in the output.

If `settings.json` does not exist yet, proceed to Step 4 — the template creates it.

---

## Step 4: Configure Claude Code Hooks

Copy the settings template:

```bash
cp templates/global-settings.json ~/.claude/settings.json
```

**What each hook does:**

**PostToolUse — Edit|Write (console.log warning)**
Runs after any file edit or write. Checks if the file is TypeScript or JavaScript. If it finds `console.log` calls, prints a warning with the line numbers. Catches debug statements before they reach production.

**PostToolUse — Write (INDEX.md reminder)**
Runs after any file write. If the project has a SESSION.md and the file written is not SESSION.md or INDEX.md itself, prints a reminder to update INDEX.md. Keeps the project map current without requiring the AI to remember.

**Stop (timestamp update)**
Runs when Claude Code closes or finishes responding. Finds SESSION.md and updates the `_Last updated:` line with the current timestamp. Ensures the timestamp is accurate even when a session is interrupted.

---

## Step 5: Install OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
```

Or via npm:

```bash
npm install -g opencode
```

Verify:

```bash
opencode --version
```

Configure your AI providers:

```bash
opencode providers
```

This opens an interactive menu where you add API keys for Anthropic, OpenAI, Gemini, or other providers. You need at least one provider configured for OpenCode to work.

---

## Step 6: Create Global OpenCode Config

```bash
mkdir -p ~/.config/opencode
```

Copy the global AGENTS.md template:

```bash
cp templates/global-opencode-AGENTS.md ~/.config/opencode/AGENTS.md
```

Install the Superpowers plugin for OpenCode:

```bash
cd ~/.config/opencode
npm install superpowers@git+https://github.com/obra/superpowers.git
```

Create the global OpenCode config file:

```bash
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["superpowers@git+https://github.com/obra/superpowers.git"]
}
EOF
```

---

## Step 7: Install Obsidian (Optional)

Obsidian is not required for the memory system to work. Install it if you want a desktop UI for viewing SESSION.md and INDEX.md alongside your notes.

Download from https://obsidian.md/download and drag it to your Applications folder.

To connect it to a project: open Obsidian, choose "Open folder as vault," and select either the project root or the `obsidian/` subfolder within a project.

---

## Step 8: Create the Init Script

```bash
mkdir -p ~/scripts
cp scripts/init-project-memory.sh ~/scripts/
chmod +x ~/scripts/init-project-memory.sh
```

Optional — add an alias to avoid typing the full path:

```bash
echo 'alias new-project="$HOME/scripts/init-project-memory.sh"' >> ~/.zshrc
source ~/.zshrc
```

---

## Step 9: Initialize Your First Project

```bash
~/scripts/init-project-memory.sh ~/Documents/MyProject MyProject
```

The script creates:
- `obsidian/SESSION.md`
- `obsidian/INDEX.md`
- `CLAUDE.md` (with memory imports)
- `AGENTS.md` (with memory rules)
- `opencode.json` (with instruction file list)

Open the project with Claude Code:

```bash
cd ~/Documents/MyProject && claude
```

Or with OpenCode:

```bash
cd ~/Documents/MyProject && opencode
```

On the first session, tell the AI:

> "Fill in obsidian/SESSION.md and INDEX.md with the real project state."

The AI will scan the project and populate both files with accurate content. After that, every subsequent session starts with full context loaded automatically.

---

## Verification

Run these checks to confirm everything is working:

```bash
# Claude Code version
claude --version

# Global CLAUDE.md has memory rule
grep -q "Memory update rule" ~/.claude/CLAUDE.md && echo "PASS: memory rule found" || echo "FAIL: memory rule missing"

# OpenCode version
opencode --version

# Global OpenCode AGENTS.md has memory rule
grep -q "Memory Update Rule" ~/.config/opencode/AGENTS.md && echo "PASS: memory rule found" || echo "FAIL: memory rule missing"

# Hooks configured
python3 -c "
import json, os
path = os.path.expanduser('~/.claude/settings.json')
d = json.load(open(path))
stop = len(d.get('hooks', {}).get('Stop', []))
post = len(d.get('hooks', {}).get('PostToolUse', []))
print(f'Stop hooks: {stop}')
print(f'PostToolUse hooks: {post}')
print('PASS' if stop >= 1 and post >= 2 else 'FAIL: expected at least 1 Stop and 2 PostToolUse hooks')
"

# Init script executable
[ -x ~/scripts/init-project-memory.sh ] && echo "PASS: init script ready" || echo "FAIL: init script not found or not executable"
```

All checks should print PASS. If any fail, revisit the step for that component.

---

## Troubleshooting

**`claude login` fails or does not open a browser**

Try: `claude login --no-browser`. It will print a URL you can open manually.

**Superpowers plugin not found**

Ensure `enabledPlugins` in `~/.claude/settings.json` matches exactly:
```json
"enabledPlugins": {
  "superpowers@superpowers-marketplace": true
}
```

**OpenCode cannot find a provider**

Run `opencode providers` and verify at least one provider has a valid API key set.

**`sed -i ''` error in the Stop hook**

The Stop hook uses BSD `sed` syntax (`sed -i ''`). This is correct for macOS. If you see an error, verify you copied `global-settings.json` from this repo and did not modify the hook command.

**Init script fails on an existing project**

The script is designed to be safe on existing projects. It skips files that already exist. If it errors, check that `$PROJECT_PATH` is an absolute path and the directory is writable.
