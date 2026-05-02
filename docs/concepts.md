# Concepts

Read this before touching any setup step. It explains every component, how they connect, and why the system works the way it does.

---

## Claude Code

Claude Code is Anthropic's official AI coding CLI. It runs in your terminal alongside your editor. You describe what you want, and it reads, edits, and creates files directly in your project.

**Install:**
- Desktop app (includes CLI): https://claude.ai/download
- CLI only: `npm install -g @anthropic-ai/claude-code`

**How it loads configuration:**

Claude Code reads two layers of config when it starts:

1. **Global:** `~/.claude/CLAUDE.md` — loaded every time, in every project
2. **Project:** `CLAUDE.md` in the current directory — loaded when you open Claude Code from that directory

Both files are plain markdown. You write rules, constraints, and instructions. The AI treats them as standing orders.

Claude Code also reads `settings.json` from `~/.claude/settings.json` for hooks, plugins, and model preferences.

**Requires:** An Anthropic account with Claude Pro, Max, or API access. Sign up at https://console.anthropic.com.

---

## OpenCode

OpenCode is an open-source AI coding CLI built by SST. It works the same way as Claude Code — terminal-based, reads and edits files — but it supports multiple AI providers.

**Install:** https://opencode.ai

**How it loads configuration:**

1. **Global:** `~/.config/opencode/AGENTS.md` — loaded every time, in every project
2. **Project (instructions file):** Any markdown files listed in the `instructions` array in `opencode.json`
3. **Project (rules file):** `AGENTS.md` in the current directory

**Supported providers:**

| Provider | Notes |
|---|---|
| Anthropic (Claude) | Same models as Claude Code |
| OpenAI (GPT-4, o-series) | Requires OpenAI API key |
| Google Gemini | Requires Gemini API key |
| DeepSeek | Inexpensive option |
| Ollama | Runs models locally, no API key |
| Others | See `opencode providers` for the full list |

**Key advantage:** OpenCode keeps working when Anthropic is unavailable, when you exhaust Claude credits, or when you prefer a different model for a specific task. Because it reads the same memory files as Claude Code, switching tools mid-project costs nothing in terms of context.

---

## Superpowers Plugin

Superpowers is a skill enforcement system that runs inside both Claude Code and OpenCode. Without it, both tools answer your question directly. With it, both tools first check whether your request should trigger a structured workflow.

**What it changes:**

Without Superpowers, if you ask "add a Stripe webhook handler," the AI starts writing code immediately.

With Superpowers, the AI first checks: should I brainstorm this? plan it? write tests first? review when done? It invokes the appropriate skill, then proceeds.

**Skills included:**

| Skill | Triggers when |
|---|---|
| `brainstorming` | You are designing a new feature or component |
| `writing-plans` | You have a spec and need a step-by-step plan |
| `executing-plans` | You are implementing a written plan |
| `test-driven-development` | You are about to write implementation code |
| `systematic-debugging` | You are investigating a bug or test failure |
| `requesting-code-review` | You are finishing a feature or task |
| `receiving-code-review` | You are responding to code review feedback |

**For Claude Code:** Installed as a marketplace plugin via `claude plugins install`.

**For OpenCode:** Installed as an npm package in `~/.config/opencode/`.

The plugin does not change what the AI can do. It changes the order in which the AI does it — adding the right checks before diving into implementation.

---

## The Memory System

This is the central idea of the blueprint.

Every project gets an `obsidian/` folder containing two files:

### obsidian/SESSION.md

A living document of the current session state. It answers: where did we stop?

Key sections:
- **Active Task** — what is being worked on right now
- **Last Completed** — the most recently finished piece of work
- **Next Step** — the exact action to take when resuming
- **In Progress** — started but not finished
- **Completed Features** — everything shipped (AI reads this to avoid rebuilding things)
- **Open Decisions** — unresolved choices
- **Blockers / Notes** — warnings and important context

The AI updates SESSION.md continuously as it works, not just at session end. Sessions can be interrupted at any moment.

### obsidian/INDEX.md

A structural map of the project. It answers: what is this codebase?

Key sections:
- **Stack** — runtime, framework, database, hosting
- **Directory Map** — what each folder contains
- **Key Files** — important files and what they do
- **Key Functions / Exports** — important symbols and where to find them
- **External Services** — third-party integrations
- **Architecture Notes** — invariants, patterns, constraints

### Why This Works

Both Claude Code and OpenCode load markdown files from the project directory at startup. By writing SESSION.md and INDEX.md and keeping them current, the AI arrives at each session already oriented.

**Token comparison:**

| Approach | Tokens used |
|---|---|
| Reading source files to understand the project | 5,000 – 15,000 |
| Reading SESSION.md + INDEX.md | 800 – 1,500 |
| Savings | 70 – 90% |

### How Tools Share Context

Both Claude Code and OpenCode are configured to load the same two files:

- Claude Code: `CLAUDE.md` contains `@obsidian/SESSION.md` and `@obsidian/INDEX.md`
- OpenCode: `opencode.json` lists `obsidian/SESSION.md` and `obsidian/INDEX.md` in its `instructions` array

When you switch from Claude Code to OpenCode mid-session, OpenCode reads the same SESSION.md that Claude Code last updated. You get the full context with no re-explanation.

---

## Obsidian (Optional)

Obsidian is a desktop markdown editor built around a local knowledge base called a vault.

**Install:** https://obsidian.md/download

**How to use it with this system:**

Point Obsidian's vault at your project root or at the `obsidian/` subfolder. SESSION.md and INDEX.md appear as regular notes. As the AI updates them during a session, Obsidian shows the live state.

The `obsidian/` folder can also hold hand-written domain notes: database schema, auth flow, API reference, feature designs. These live alongside SESSION.md and INDEX.md and can be referenced in the project's CLAUDE.md or AGENTS.md if you want the AI to load them at startup.

Obsidian adds no technical requirement. SESSION.md and INDEX.md are plain markdown files that work with or without the desktop app.

---

## The Init Script

`~/scripts/init-project-memory.sh` is a shell script that sets up the memory system for any project in one command.

**Usage:**
```bash
~/scripts/init-project-memory.sh <project-path> <project-name>
```

**What it creates:**

| File | Action if file exists |
|---|---|
| `obsidian/SESSION.md` | Skipped |
| `obsidian/INDEX.md` | Skipped |
| `CLAUDE.md` | Memory imports appended if missing |
| `AGENTS.md` | Memory rules appended if missing |
| `opencode.json` | Skipped with a note |

The script is idempotent. Running it twice on the same project does not overwrite anything.

---

## How Everything Connects

```
Global config (~/.claude/CLAUDE.md)
  └── Rules that apply to every project

Project directory
  ├── CLAUDE.md          → tells Claude Code to load SESSION.md + INDEX.md
  ├── AGENTS.md          → tells OpenCode to load SESSION.md + INDEX.md
  ├── opencode.json      → tells OpenCode which instruction files to load
  └── obsidian/
        ├── SESSION.md   → where we stopped, what is next
        └── INDEX.md     → project map, stack, key files

Claude Code                OpenCode
  reads CLAUDE.md   ←→    reads AGENTS.md + opencode.json
  reads SESSION.md  ←→    reads SESSION.md
  reads INDEX.md    ←→    reads INDEX.md
  updates SESSION.md ←→   updates SESSION.md
```

The two tools are interchangeable from the memory system's perspective. The AI that picks up a session always starts with the same state the previous AI left behind.
