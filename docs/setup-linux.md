# Setup: Linux

Complete installation guide for Ubuntu 20.04+, Debian 11+, Fedora 35+, and equivalents.

All commands run in a standard bash shell. Config paths are identical to macOS.

---

## Prerequisites

| Requirement | Version | Check |
|---|---|---|
| Linux distro | Ubuntu 20.04+ / Debian 11+ / Fedora 35+ | `cat /etc/os-release` |
| Node.js | 18 or later | `node --version` |
| Git | Any recent version | `git --version` |
| curl | Pre-installed on most distros | `curl --version` |
| Anthropic account | Claude Pro / Max / API | https://console.anthropic.com |

### Install Node.js via nvm (recommended)

nvm lets you install and switch Node.js versions without root access. It is the most reliable method across Linux distributions.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
node --version   # should print v20.x
```

Full nvm documentation: https://github.com/nvm-sh/nvm

**Alternative — system package (Ubuntu/Debian):**

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version
```

**Alternative — system package (Fedora/RHEL):**

```bash
sudo dnf install nodejs npm
node --version
```

### Install Git

**Ubuntu/Debian:**

```bash
sudo apt update && sudo apt install git
```

**Fedora:**

```bash
sudo dnf install git
```

Verify:

```bash
git --version
```

---

## Step 1: Install Claude Code

**Option A — CLI via npm:**

```bash
npm install -g @anthropic-ai/claude-code
```

**Option B — Desktop app (if running a GUI environment):**

Download from https://claude.ai/download. Extract and run the installer.

Verify and authenticate:

```bash
claude --version
claude login
```

`claude login` opens a browser window (in a GUI environment) or prints a URL to open manually. Complete OAuth with your Anthropic account. You need Claude Pro, Max, or API access.

For headless servers or systems without a browser:

```bash
claude login --no-browser
```

Copy and paste the printed URL into a browser on another device.

---

## Step 2: Create Global CLAUDE.md

```bash
mkdir -p ~/.claude/rules
cp templates/global-CLAUDE.md ~/.claude/CLAUDE.md
```

What the file contains and what each section does: see [setup-mac.md Step 2](setup-mac.md#step-2-create-global-claudemd). The file is identical on Linux and macOS.

---

## Step 3: Install Superpowers Plugin for Claude Code

```bash
claude plugins install superpowers@superpowers-marketplace
```

Verify:

```bash
python3 -c "
import json, os
path = os.path.expanduser('~/.claude/settings.json')
try:
    d = json.load(open(path))
    print(d.get('enabledPlugins', {}))
except FileNotFoundError:
    print('settings.json not yet created — continue to Step 4')
"
```

---

## Step 4: Configure Claude Code Hooks

```bash
cp templates/global-settings.json ~/.claude/settings.json
```

**Linux-specific note on the Stop hook:**

The Stop hook uses `sed -i ''` which is BSD syntax (macOS). On Linux, `sed -i` does not accept an empty string argument. The hook command in `global-settings.json` uses the BSD form. To make it work on Linux, edit the Stop hook command:

Open `~/.claude/settings.json` and find the Stop hook command. Change:

```
sed -i '' "s/^_Last updated:.*/_Last updated: $ts/" "$sess"
```

To:

```
sed -i "s/^_Last updated:.*/_Last updated: $ts/" "$sess"
```

Or run this command to make the edit automatically:

```bash
python3 << 'EOF'
import json, os

path = os.path.expanduser('~/.claude/settings.json')
with open(path) as f:
    content = f.read()

content = content.replace("sed -i '' \"", "sed -i \"")

with open(path, 'w') as f:
    f.write(content)

print("Stop hook updated for Linux sed syntax")
EOF
```

What each hook does: see [setup-mac.md Step 4](setup-mac.md#step-4-configure-claude-code-hooks). Behavior is identical on Linux once the sed syntax is corrected.

---

## Step 5: Install OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
```

If curl is not available:

```bash
npm install -g opencode
```

Verify:

```bash
opencode --version
```

If the `opencode` binary is not found after installation, the installer may have placed it in `~/.local/bin`. Add it to your PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Configure providers:

```bash
opencode providers
```

---

## Step 6: Create Global OpenCode Config

```bash
mkdir -p ~/.config/opencode
cp templates/global-opencode-AGENTS.md ~/.config/opencode/AGENTS.md
```

Install the Superpowers plugin:

```bash
cd ~/.config/opencode
npm install superpowers@git+https://github.com/obra/superpowers.git
```

Create the global OpenCode config:

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

Download the AppImage from https://obsidian.md/download.

```bash
chmod +x Obsidian-*.AppImage
./Obsidian-*.AppImage
```

On systems with Snap:

```bash
sudo snap install obsidian --classic
```

On systems with Flatpak:

```bash
flatpak install flathub md.obsidian.Obsidian
```

---

## Step 8: Create the Init Script

```bash
mkdir -p ~/scripts
cp scripts/init-project-memory.sh ~/scripts/
chmod +x ~/scripts/init-project-memory.sh
```

Add `~/scripts` to your PATH so you can run the script from anywhere:

```bash
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Optional alias:

```bash
echo 'alias new-project="$HOME/scripts/init-project-memory.sh"' >> ~/.bashrc
source ~/.bashrc
```

---

## Step 9: Initialize Your First Project

```bash
~/scripts/init-project-memory.sh ~/Documents/MyProject MyProject
cd ~/Documents/MyProject && claude
```

Or with OpenCode:

```bash
cd ~/Documents/MyProject && opencode
```

Tell the AI on first open:

> "Fill in obsidian/SESSION.md and INDEX.md with the real project state."

---

## Verification

```bash
# Claude Code version
claude --version

# Memory rule in global CLAUDE.md
grep -q "Memory update rule" ~/.claude/CLAUDE.md && echo "PASS: memory rule found" || echo "FAIL: memory rule missing"

# OpenCode version
opencode --version

# Memory rule in global OpenCode AGENTS.md
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

# PATH includes ~/scripts
echo $PATH | grep -q "$HOME/scripts" && echo "PASS: ~/scripts in PATH" || echo "WARN: ~/scripts not in PATH (run the script with full path)"
```

---

## Troubleshooting

**Node.js not found after nvm install**

nvm modifies `~/.bashrc` during install. Open a new terminal or run `source ~/.bashrc` before using `node` or `npm`.

**Permission errors during npm install -g**

Using nvm avoids global permission issues entirely. If you installed Node.js via the system package manager, you may need to configure npm's global prefix:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**opencode binary not found after install**

Check where opencode was installed:

```bash
npm list -g opencode 2>/dev/null
which opencode 2>/dev/null || echo "not in PATH"
```

Add the npm global bin to PATH if needed:

```bash
echo 'export PATH="$(npm bin -g):$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**sed error in Stop hook**

Follow the Linux sed fix in Step 4 above. The BSD `sed -i ''` syntax does not work on GNU sed (the Linux default).

**Headless server with no browser for `claude login`**

```bash
claude login --no-browser
```

Copy the URL from the output, open it on any device with a browser, complete the OAuth flow, and the CLI will detect the token automatically.

**AppImage does not run on older Ubuntu**

Install FUSE:

```bash
sudo apt install libfuse2
```
