# Daily Workflow

How to use the system day to day: starting sessions, switching tools, and managing memory.

---

## Starting a New Project

```bash
~/scripts/init-project-memory.sh ~/Documents/ProjectName ProjectName
cd ~/Documents/ProjectName
claude
```

Or with OpenCode:

```bash
cd ~/Documents/ProjectName && opencode
```

On the first session, tell the AI:

> "Fill in obsidian/SESSION.md and INDEX.md with the real project state."

The AI scans the project, populates both files with accurate content, and sets the first Next Step. Every session after this loads automatically.

---

## Coming Back After a Break

```bash
cd ~/Documents/MyProject
claude
```

That is the entire step. SESSION.md loads automatically. The AI reads it, knows exactly where you stopped, what is done, and what is next. You do not re-explain anything.

If you want explicit confirmation that the AI read the session:

> "Read SESSION.md and tell me where we left off."

The AI will summarize the current state and ask how you want to proceed.

---

## Running Out of Claude Credits Mid-Session

Claude Code will stop responding or show an error when you exhaust your credits. Switch to OpenCode without losing context:

```bash
# Stay in the same project directory
opencode
```

OpenCode reads the same SESSION.md that Claude Code last updated. It picks up exactly where the session stopped. No re-explanation needed.

---

## Switching Back to Claude

```bash
cd ~/Documents/MyProject
claude
```

Claude Code reads the SESSION.md that OpenCode updated. The handoff is seamless in both directions.

---

## How the AI Updates Memory

You do not manage SESSION.md or INDEX.md manually. The AI updates them.

**When the AI updates SESSION.md:**
- After completing any task or subtask: marks it done, sets the next step
- When moving to a new in-progress item: updates the In Progress section
- When finishing a feature: adds it to Completed Features
- When making a decision: records it in Open Decisions or removes it from Open Decisions

**When the AI updates INDEX.md:**
- After creating a new file that is a module, route, service, or component: adds a row to Directory Map or Key Files
- After deleting a file: removes the relevant row
- After introducing a new key function or export: adds it to Key Functions

**When the Stop hook updates SESSION.md:**
- Every time Claude Code finishes a response: updates the `_Last updated:` timestamp
- Even if you close the terminal mid-session: the timestamp reflects the last completed turn

The memory update rules are in both the global CLAUDE.md and the project AGENTS.md. They are marked non-negotiable so the AI treats them as standing requirements, not suggestions.

---

## Viewing Memory in Obsidian

Open Obsidian and select "Open folder as vault." Point it at either:
- The project root — you see all project files including SESSION.md and INDEX.md
- The `obsidian/` subfolder — you see only the memory files and any domain notes

As the AI works during a session, SESSION.md updates in real time. Obsidian reflects changes when you switch focus to the app (or immediately if you have auto-reload configured).

You can also write your own notes in the `obsidian/` folder — database schema, auth flow diagrams, API references. These are plain markdown files. Reference them in your project CLAUDE.md with `@obsidian/Schema.md` and the AI will load them at session start.

---

## Adding Memory to an Existing Project

You can add the memory system to any project you are already working on:

```bash
~/scripts/init-project-memory.sh ~/Documents/ExistingProject ExistingProject
```

The script is safe on existing projects. It skips files that are already there. If CLAUDE.md already exists, it appends the memory imports without overwriting the file.

After running the script:

```bash
cd ~/Documents/ExistingProject && claude
```

Tell the AI:

> "Fill in obsidian/SESSION.md and INDEX.md with the current project state."

The AI will read the existing codebase and populate both files.

---

## Session Hygiene

**Keep Next Step specific.** The more precise the Next Step in SESSION.md, the faster the AI resumes. "Continue working on billing" is less useful than "Write the webhook signature verification in src/api/billing/webhook.ts."

**Completed Features is a safety net.** The AI reads this section to avoid re-implementing things. Keep it accurate. If you removed a feature, remove it from the list too.

**Blockers are early warnings.** If you know something is not configured yet (prod keys, a pending decision, a broken test command), add it to Blockers before closing the session. The AI will read it before taking any action.

**The Index is a shortcut, not a contract.** INDEX.md replaces reading source files for orientation. It does not need to be perfectly complete. A rough directory map with the key files noted is enough to save the bulk of context tokens.

---

## Working Without the AI

SESSION.md and INDEX.md are plain text. You can edit them manually at any time — during a break, when planning your next session, or when you notice something is out of date. The AI reads whatever you write.

If you make significant progress outside an AI session (pair programming, manual edits, code review changes), open SESSION.md and update Active Task and Last Completed before starting the next AI session. This keeps the AI oriented without requiring it to re-scan the codebase.

---

## Switching Projects

Each project is independent. The memory files live in the project directory.

```bash
# Close current project
# Switch to another project:
cd ~/Documents/OtherProject && claude
```

Claude Code loads the CLAUDE.md from OtherProject, which points to OtherProject's own SESSION.md and INDEX.md. There is no cross-project contamination.

---

## Reference: What to Say to the AI

| Situation | What to say |
|---|---|
| First session on a new project | "Fill in obsidian/SESSION.md and INDEX.md with the real project state" |
| Resuming after a break | Nothing — it loads automatically. Or: "Read SESSION.md and tell me where we left off" |
| SESSION.md is stale | "Update SESSION.md — here is the current state: [describe]" |
| INDEX.md is missing a file | "Add src/lib/newmodule.ts to INDEX.md — it handles [description]" |
| Switching tools | Nothing — both tools read the same files |
