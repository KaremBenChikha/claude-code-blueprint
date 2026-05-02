# Setup: Windows

There are two approaches to running this system on Windows. WSL is strongly recommended.

---

## Which Option to Choose

| | WSL (Recommended) | Native Windows |
|---|---|---|
| Shell | Bash (full Unix) | PowerShell + Git Bash |
| Path format | `/home/username/` | `C:\Users\username\` |
| Script compatibility | Full | Requires adaptation |
| sed/awk/curl | Native | Git Bash only |
| Effort | One-time WSL setup | Ongoing compatibility work |

WSL gives you a complete Linux environment inside Windows. Every command in this guide works without modification. Use native Windows only if WSL is unavailable on your machine (rare — it works on Windows 10 version 2004 and later).

---

## Option A: WSL (Recommended)

### Install WSL

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

This installs WSL 2 with Ubuntu. Restart your computer when prompted.

After restarting, Ubuntu opens automatically on first launch. Create a Unix username and password when prompted. These are separate from your Windows credentials.

Verify WSL is running correctly:

```powershell
wsl --list --verbose
```

You should see Ubuntu listed with VERSION 2.

### Follow the Linux Guide

Once WSL is installed and Ubuntu is running, follow [setup-linux.md](setup-linux.md) exactly.

All commands are identical. All config paths are identical (`~/.claude/`, `~/.config/opencode/`, `~/scripts/`).

### Accessing WSL Files from Windows

WSL files are accessible in Windows Explorer at:

```
\\wsl$\Ubuntu\home\<your-username>\
```

Or open File Explorer and look for "Linux" in the left sidebar.

You can open any WSL folder in VS Code from the WSL terminal:

```bash
code .
```

### Running the Init Script on a Windows Path

If your projects are stored under a Windows path (e.g., `C:\Users\you\Documents\MyProject`), access it from WSL as:

```bash
~/scripts/init-project-memory.sh /mnt/c/Users/you/Documents/MyProject MyProject
```

WSL mounts Windows drives under `/mnt/`. The `C:\` drive is at `/mnt/c/`.

### Opening Claude Code from WSL

Install Claude Code inside the WSL environment (not on the Windows host):

```bash
# Inside WSL Ubuntu terminal:
npm install -g @anthropic-ai/claude-code
claude --version
claude login
```

Then open projects from WSL:

```bash
cd ~/Documents/MyProject && claude
```

---

## Option B: Native Windows

Use this only if you cannot install WSL.

### Prerequisites

**Node.js:**

Download and install the LTS version from https://nodejs.org. Use the Windows installer (`.msi`). During installation, check "Add to PATH."

Verify in PowerShell:

```powershell
node --version
npm --version
```

**Git:**

Download from https://git-scm.com/download/win. During installation:
- Select "Git from the command line and also from 3rd-party software"
- Select "Use bundled OpenSSH"
- Select "Use the native Windows Secure Channel library"

Git Bash is installed alongside Git. Use Git Bash (not PowerShell) to run `.sh` scripts.

### Install Claude Code

Open PowerShell:

```powershell
npm install -g @anthropic-ai/claude-code
claude --version
claude login
```

### Config Paths on Windows

| Unix path | Windows equivalent |
|---|---|
| `~/.claude/` | `%USERPROFILE%\.claude\` |
| `~/.config/opencode/` | `%APPDATA%\opencode\` (verify with `opencode --help`) |
| `~/scripts/` | `%USERPROFILE%\scripts\` |

Create the Claude config directory:

```powershell
mkdir "$env:USERPROFILE\.claude"
mkdir "$env:USERPROFILE\.claude\rules"
```

Copy the global CLAUDE.md template:

```powershell
copy templates\global-CLAUDE.md "$env:USERPROFILE\.claude\CLAUDE.md"
```

### Install Superpowers Plugin

```powershell
claude plugins install superpowers@superpowers-marketplace
```

### Configure Hooks

Copy the settings template:

```powershell
copy templates\global-settings.json "$env:USERPROFILE\.claude\settings.json"
```

**Important — Stop hook on Windows:**

The Stop hook uses `sed -i ''` (BSD syntax). This does not work on native Windows. The hook will silently fail unless you adapt it.

Options:
1. Skip the Stop hook by removing it from `settings.json`. The timestamp in SESSION.md will not update automatically, but everything else works.
2. Replace the sed command with a PowerShell equivalent (requires additional setup).
3. Install WSL and use Option A instead.

### Install OpenCode

```powershell
npm install -g opencode
opencode --version
```

The OpenCode config directory on Windows may differ from `~/.config/opencode/`. Run:

```powershell
opencode --help
```

Look for a line mentioning the config directory path. It is typically `%APPDATA%\opencode\`.

Create the config directory and copy the global AGENTS.md:

```powershell
mkdir "$env:APPDATA\opencode"
copy templates\global-opencode-AGENTS.md "$env:APPDATA\opencode\AGENTS.md"
```

Install the Superpowers plugin:

```powershell
cd "$env:APPDATA\opencode"
npm install superpowers@git+https://github.com/obra/superpowers.git
```

Create the OpenCode config:

```powershell
@'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["superpowers@git+https://github.com/obra/superpowers.git"]
}
'@ | Set-Content "$env:APPDATA\opencode\opencode.json"
```

### Running the Init Script on Windows

The init script is a bash script. Run it in Git Bash (not PowerShell):

```bash
# In Git Bash:
bash ~/scripts/init-project-memory.sh "C:/Users/you/Documents/MyProject" MyProject
```

Git Bash uses forward slashes. Windows paths with backslashes need to be converted or quoted carefully.

Alternatively, create the memory files manually by copying from the templates:

```powershell
mkdir "C:\Users\you\Documents\MyProject\obsidian"
copy templates\SESSION.md "C:\Users\you\Documents\MyProject\obsidian\SESSION.md"
copy templates\INDEX.md "C:\Users\you\Documents\MyProject\obsidian\INDEX.md"
copy templates\project-CLAUDE.md "C:\Users\you\Documents\MyProject\CLAUDE.md"
copy templates\project-AGENTS.md "C:\Users\you\Documents\MyProject\AGENTS.md"
copy templates\project-opencode.json "C:\Users\you\Documents\MyProject\opencode.json"
```

### Install Obsidian (Optional)

Download the Windows installer from https://obsidian.md/download and run it.

### Verification

Run in PowerShell:

```powershell
claude --version
opencode --version
node --version
git --version
```

Run in Git Bash to check Claude config:

```bash
grep -q "Memory update rule" ~/.claude/CLAUDE.md && echo "PASS" || echo "FAIL: memory rule missing"
```

---

## Troubleshooting (Windows)

**`claude` not found after npm install -g**

npm global binaries may not be in PATH. Check:

```powershell
npm config get prefix
```

Add the result to your system PATH via Settings > System > Advanced system settings > Environment Variables.

**Script runs but sed produces errors**

The Stop hook uses BSD sed syntax that does not work on Windows. Either remove the Stop hook from `settings.json` or switch to WSL.

**Git Bash does not find `~/scripts/`**

Git Bash maps `~` to `C:\Users\<username>`. Create the scripts directory:

```bash
mkdir -p ~/scripts
```

**OpenCode config path not found**

Run `opencode --help` or `opencode config` to see the exact config directory for your installation. The path varies by OpenCode version and installation method.

**Windows Defender blocks the npm install**

This is a known issue with some antivirus configurations. Temporarily disable real-time protection during installation, or add the npm global directory to the antivirus exclusion list.
