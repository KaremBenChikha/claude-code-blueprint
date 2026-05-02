# AI Coding Environment Blueprint

A complete, portable setup that gives any developer a persistent AI coding environment across tools, machines, and sessions.

## What This Is

This blueprint configures two AI coding CLIs — Claude Code and OpenCode — to share a lightweight memory system. Every project gets two markdown files that the AI reads at session start. The AI knows exactly where you stopped, what is built, and what is next. You never re-explain your codebase.

When one tool is unavailable (credits exhausted, API down, personal preference), you switch to the other. Both tools read the same files. Context transfers instantly.

## The Core Insight

Both Claude Code and OpenCode load plain markdown files from your project directory. By keeping two files current — `obsidian/SESSION.md` (what we are doing) and `obsidian/INDEX.md` (what the project is) — the AI can resume any project in under 30 seconds without reading source files. That saves 70-90% of the tokens normally spent on context loading.

## What You Get After Setup

- Claude Code configured with global rules, skill enforcement, and memory hooks
- OpenCode configured as a full fallback with the same memory system
- A one-command project initializer that creates all memory files
- Seamless handoff between tools mid-session with no re-explanation
- Optional Obsidian integration for viewing memory files in a desktop UI
- Token savings of roughly 4,000-14,000 tokens per session resume

## System Requirements

| Requirement | Minimum | Notes |
|---|---|---|
| Operating system | macOS 12, Ubuntu 20.04, Windows 10 | Windows requires WSL or Node.js |
| Node.js | 18.0 | 20 LTS recommended |
| Git | 2.30 | Pre-installed on most systems |
| Anthropic account | Claude Pro, Max, or API | Required for Claude Code |
| Second AI provider | Optional | Enables OpenCode as fallback |

## Quick Start

Pick your platform and follow the guide:

1. [Mac setup](docs/setup-mac.md)
2. [Linux setup](docs/setup-linux.md)
3. [Windows setup](docs/setup-windows.md)

Once set up, initialize any project with:

```bash
~/scripts/init-project-memory.sh ~/Documents/MyProject MyProject
cd ~/Documents/MyProject && claude
```

## Documentation

| Document | What it covers |
|---|---|
| [docs/concepts.md](docs/concepts.md) | How every component works before you touch anything |
| [docs/setup-mac.md](docs/setup-mac.md) | Complete Mac installation, step by step |
| [docs/setup-linux.md](docs/setup-linux.md) | Complete Linux installation, step by step |
| [docs/setup-windows.md](docs/setup-windows.md) | Windows via WSL (recommended) or native |
| [docs/daily-workflow.md](docs/daily-workflow.md) | Day-to-day usage: resuming, switching tools, managing memory |

## Templates

| Template | Purpose |
|---|---|
| [templates/global-CLAUDE.md](templates/global-CLAUDE.md) | Copy to `~/.claude/CLAUDE.md` — global rules for Claude Code |
| [templates/global-settings.json](templates/global-settings.json) | Copy to `~/.claude/settings.json` — hooks and plugin config |
| [templates/global-opencode-AGENTS.md](templates/global-opencode-AGENTS.md) | Copy to `~/.config/opencode/AGENTS.md` — global rules for OpenCode |
| [templates/project-CLAUDE.md](templates/project-CLAUDE.md) | Auto-created per project by the init script |
| [templates/project-AGENTS.md](templates/project-AGENTS.md) | Auto-created per project by the init script |
| [templates/project-opencode.json](templates/project-opencode.json) | Auto-created per project by the init script |
| [templates/SESSION.md](templates/SESSION.md) | Reference for what a populated session file looks like |
| [templates/INDEX.md](templates/INDEX.md) | Reference for what a populated index file looks like |

## Scripts

| Script | Purpose |
|---|---|
| [scripts/init-project-memory.sh](scripts/init-project-memory.sh) | Initialize memory files for a new or existing project |
