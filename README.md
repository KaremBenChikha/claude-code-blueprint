# 🧠 Claude Code Blueprint

> A clean, opinionated setup guide for Claude Code on macOS — from zero to a production-grade AI coding environment using [everything-claude-code (ECC)](https://github.com/affaan-m/everything-claude-code).

---

## 📐 Philosophy

This repo is a **living blueprint**, not a framework dump.  
The goal is a minimal but powerful setup that:

- Stays fast and friction-free for daily use
- Uses the official Claude Code directory system correctly
- Leverages ECC selectively (not the whole kitchen sink)
- Replaces the "translate-in-a-side-chat" habit with built-in rules and agents
- Scales from solo side projects to larger production repos

```
Less ceremony → More actual coding
```

---

## 🗂️ Repo Structure

```
claude-code-blueprint/
│
├── README.md                        ← You are here
│
├── global/                          ← Mirrors ~/.claude/
│   ├── CLAUDE.md                    ← Global system prompt
│   └── rules/
│       ├── ecc-reference.md         ← ECC framework reference
│       ├── ecc-components.md        ← Agents, hooks, skills guide
│       └── workflows.md             ← Prompt patterns & workflows
│
├── commands/
│   └── translate.md                 ← /translate slash command
│
├── project-template/
│   └── .claude/
│       └── CLAUDE.md                ← Per-project template (copy into each repo)
│
└── scripts/
    ├── uninstall.sh                 ← Full Mac uninstall script
    ├── install.sh                   ← Fresh install + ECC setup
    └── apply-global.sh              ← Apply global/ files to ~/.claude/
```

---

## 🚦 Prerequisites

| Requirement | Version | Check |
|---|---|---|
| macOS | 12+ Monterey or later | `sw_vers` |
| Node.js | 18+ | `node --version` |
| npm | 9+ | `npm --version` |
| Git | Any recent | `git --version` |
| Anthropic account | Paid API or Claude Pro/Max | [console.anthropic.com](https://console.anthropic.com) |

---

## 🧹 Step 0 — Clean Uninstall (skip if fresh machine)

> Run this if you have a previous Claude Code install you want to fully wipe.

```bash
# Optional: back up your existing config first
cp -R ~/.claude ~/claude-backup-$(date +%Y%m%d)

# Uninstall — native installer (most common since 2025)
claude uninstall

# If you used npm instead
# npm uninstall -g @anthropic-ai/claude-code

# Nuke all config, auth tokens, and cache
rm -rf ~/.claude
rm -rf ~/.claude-code
rm -rf ~/Library/Application\ Support/claude-code
rm -rf ~/Library/Caches/claude-code
rm -rf ~/Library/Preferences/com.anthropic.claude-code*

# Confirm clean
which claude       # should return: not found
claude --version   # should return: command not found
```

Or run the helper script:

```bash
bash scripts/uninstall.sh
```

---

## ⚡ Step 1 — Fresh Install

```bash
# Official installer (not npm — native is preferred)
curl -fsSL https://claude.ai/install.sh | bash

# Open a new terminal tab, then verify
claude --version

# Log in
claude login
```

Or run the helper script:

```bash
bash scripts/install.sh
```

---

## 🧩 Step 2 — Install ECC Selectively

[everything-claude-code](https://github.com/affaan-m/everything-claude-code) is an open agent harness built for Claude Code.  
Install **only what you will use**. A leaner install is faster and easier to maintain.

```bash
# Clone ECC source
git clone https://github.com/affaan-m/everything-claude-code.git ~/ecc-source

# Create the ~/.claude directory structure
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/rules
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/skills

# ── AGENTS (starter set of 8) ──
cp ~/ecc-source/agents/planner.md            ~/.claude/agents/
cp ~/ecc-source/agents/architect.md          ~/.claude/agents/
cp ~/ecc-source/agents/code-reviewer.md      ~/.claude/agents/
cp ~/ecc-source/agents/security-reviewer.md  ~/.claude/agents/
cp ~/ecc-source/agents/tdd-guide.md          ~/.claude/agents/
cp ~/ecc-source/agents/refactor-cleaner.md   ~/.claude/agents/
cp ~/ecc-source/agents/build-error-resolver.md ~/.claude/agents/
cp ~/ecc-source/agents/e2e-runner.md         ~/.claude/agents/

# ── RULES (always-on defaults) ──
cp -r ~/ecc-source/rules/common/* ~/.claude/rules/

# Add your language-specific rules (pick what fits your stack)
cp -r ~/ecc-source/rules/python/*     ~/.claude/rules/   # Python / FastAPI / Lambda
# cp -r ~/ecc-source/rules/typescript/* ~/.claude/rules/ # TypeScript / Node

# ── COMMANDS ──
cp ~/ecc-source/commands/*.md ~/.claude/commands/

# ── SKILLS ──
cp -r ~/ecc-source/skills/* ~/.claude/skills/
```

> **Note:** You can always add more agents or skills later. Start lean.

---

## 🛠️ Step 3 — Apply the Custom Layer (this repo's files)

These 5 files form your **personal operating layer** on top of ECC.  
They tell Claude how *you* work, not just how Claude Code works in general.

### Global `.claude/` structure after this step

```
~/.claude/
├── CLAUDE.md            ← global system prompt (your "always-on brain")
├── rules/
│   ├── ecc-reference.md        ← ECC framework reference
│   ├── ecc-components.md       ← agents, hooks, skills reference
│   └── workflows.md            ← prompt patterns & workflows
├── commands/
│   └── translate.md            ← /translate slash command
├── agents/              ← ECC agents (from Step 2)
├── skills/              ← ECC skills (from Step 2)
└── settings.json
```

### Apply with one command

```bash
bash scripts/apply-global.sh
```

### Or apply manually

```bash
# 1 — Global system prompt
cp global/CLAUDE.md ~/.claude/CLAUDE.md

# 2 — ECC framework reference (rule)
cp global/rules/ecc-reference.md ~/.claude/rules/ecc-reference.md

# 3 — Agents/hooks/skills reference (rule)
cp global/rules/ecc-components.md ~/.claude/rules/ecc-components.md

# 4 — Workflows & prompt patterns (rule)
cp global/rules/workflows.md ~/.claude/rules/workflows.md

# 5 — Command translator (slash command)
cp commands/translate.md ~/.claude/commands/translate.md
```

### What each file does

| File | Location | Claude reads it… |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Every session, every project, automatically |
| `ecc-reference.md` | `~/.claude/rules/` | As ambient context — always active |
| `ecc-components.md` | `~/.claude/rules/` | As ambient context — always active |
| `workflows.md` | `~/.claude/rules/` | As ambient context — always active |
| `translate.md` | `~/.claude/commands/` | When you type `/translate` in Claude Code |

---

## 📁 Step 4 — Per-Project Setup

Every repo gets its own instruction layer at `.claude/CLAUDE.md`.  
This is **project-specific** and overrides nothing globally — it adds context.

```bash
# Inside your project root
cp path/to/claude-code-blueprint/project-template/.claude/CLAUDE.md .claude/CLAUDE.md

# Then edit it with your project specifics
```

**What to put in it:**
- Stack and key dependencies
- Test / lint / build commands
- Architecture notes (key decisions, file map)
- Constraints ("never modify X without Y")
- Known gotchas

---

## 💡 Step 5 — Daily Workflow

### No more side-chat translator

Previously you would copy a task to a separate AI chat → get a formatted command → paste it into Claude Code.  
**That step is gone.** Your rules and agents handle the translation automatically.

### How to work now

| Task type | What to type in Claude Code |
|---|---|
| Bug fix | `Fix: [describe the bug]. Find root cause first, then smallest safe fix.` |
| New feature | `Plan and implement: [feature]. Match existing patterns.` |
| Code review | `Review these changes for correctness, security, and missing tests.` |
| Refactor | `Refactor [area] without changing behavior. Show plan before editing.` |
| Security check | `Security review on [area]. List findings by severity.` |
| Architect decision | `I need to decide: [decision]. What are the tradeoffs?` |
| /translate command | Type `/translate` then describe your task in plain English |

### Use agents explicitly when it helps

```
Plan this feature → planner agent kicks in
Review this PR → code-reviewer + security-reviewer
Debug this test → tdd-guide + build-error-resolver
```

You do **not** need to invoke them manually — your rules prime Claude to use the right agent. But you can also call them explicitly:

```
Use the security-reviewer agent to audit this auth flow.
```

---

## 📏 Best Practices

### ✅ Do

- Keep `~/.claude/CLAUDE.md` short and opinionated (under 100 lines)
- Update your per-project `.claude/CLAUDE.md` as the project evolves
- Use `/translate` only for vague or unusually complex asks
- Keep ECC agents minimal — add only when you feel a real gap
- Run `claude --version` monthly and update when a new version drops

### ❌ Don't

- Copy all ECC agents blindly — you'll never use most of them
- Put implementation details in your global `CLAUDE.md` — that belongs per-project
- Use a side-chat translator for every task — trust your rules
- Duplicate your project instructions in every prompt
- Install new agents when a direct prompt would work just as well

---

## 🔁 Updating Your Setup

```bash
# Pull latest ECC
cd ~/ecc-source && git pull

# Selectively copy any updated agents or rules you care about
cp ~/ecc-source/agents/planner.md ~/.claude/agents/planner.md

# Pull this blueprint
cd path/to/claude-code-blueprint && git pull

# Re-apply global layer
bash scripts/apply-global.sh
```

---

## 🧩 Optional Add-ons

| Tool | What it does | When to add |
|---|---|---|
| [code-review-graph](https://github.com/tirth8205/code-review-graph) | Persistent AST graph, semantic search, minimal-context review | Large codebases (500+ files) where token waste is noticeable |
| MCP servers (Context7, Playwright, etc.) | Live docs, browser testing, bulk transforms | When a specific workflow clearly needs it |
| Per-team shared `.claude/` | Commit `.claude/CLAUDE.md` to the repo | Team projects where shared conventions matter |

---

## 📚 References

- [Claude Code official docs](https://code.claude.com/docs/en/overview)
- [Claude directory structure](https://code.claude.com/docs/en/claude-directory)
- [Claude memory & instructions](https://code.claude.com/docs/en/memory)
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [code-review-graph](https://github.com/tirth8205/code-review-graph)

---

*Built by Karem BenChikha — maintained as a personal blueprint for Claude Code setups.*