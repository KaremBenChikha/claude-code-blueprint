#!/usr/bin/env bash
# init-project-memory.sh — Initialize AI memory for a new or existing project
#
# Usage:   init-project-memory.sh <project-path> <project-name>
# Example: init-project-memory.sh ~/Documents/MyApp MyApp
#
# Creates: obsidian/SESSION.md, obsidian/INDEX.md, CLAUDE.md, AGENTS.md, opencode.json
#
# Safe to re-run — skips files that already exist, appends memory rules to existing
# CLAUDE.md and AGENTS.md if the rules are not already present.

set -e

PROJECT_PATH="${1:?Usage: $0 <project-path> <project-name>}"
PROJECT_NAME="${2:?Usage: $0 <project-path> <project-name>}"
TODAY=$(date '+%Y-%m-%d')

# Resolve to absolute path
PROJECT_PATH="$(cd "$(dirname "$PROJECT_PATH")" 2>/dev/null && pwd)/$(basename "$PROJECT_PATH")" || {
  # Directory doesn't exist yet — create it
  mkdir -p "$PROJECT_PATH"
  PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
}

echo "Initializing memory for: $PROJECT_NAME"
echo "  Path: $PROJECT_PATH"
echo ""

mkdir -p "$PROJECT_PATH/obsidian"

# ─────────────────────────────────────────────────────────────
# SESSION.md
# ─────────────────────────────────────────────────────────────
SESSION="$PROJECT_PATH/obsidian/SESSION.md"
if [ ! -f "$SESSION" ]; then
  cat > "$SESSION" << SESSIONEOF
# Session State — $PROJECT_NAME
_Last updated: ${TODAY}_

## Active Task
- [Fill in: what you are working on right now]

## Last Completed
- [Fill in: what just finished]

## Next Step
- [Fill in: exact next action when resuming — specific enough to act on immediately]

## In Progress (incomplete)
- [ ] [Fill in any work-in-progress items]

## Completed Features (do not re-implement)
- [x] Project memory system initialized

## Open Decisions
- None

## Blockers / Notes
- None
SESSIONEOF
  echo "  [created] obsidian/SESSION.md"
else
  echo "  [exists]  obsidian/SESSION.md"
fi

# ─────────────────────────────────────────────────────────────
# INDEX.md
# ─────────────────────────────────────────────────────────────
INDEX="$PROJECT_PATH/obsidian/INDEX.md"
if [ ! -f "$INDEX" ]; then
  cat > "$INDEX" << INDEXEOF
# Project Index — $PROJECT_NAME
_Last updated: ${TODAY}_

## Stack
- [Fill in: runtime, framework, database, hosting]

## Directory Map
| Path | Purpose |
|---|---|
| [Fill in] | [one-line description] |

## Key Files
| File | Does |
|---|---|
| [Fill in] | [one-line description] |

## Key Functions / Exports
| Symbol | File | Does |
|---|---|---|
| [Fill in] | [Fill in] | [one-line description] |

## External Services
| Service | Used for | Status |
|---|---|---|
| [Fill in] | [Fill in] | Planned |

## Architecture Notes
- [Fill in: key invariants and constraints to know before touching code]
INDEXEOF
  echo "  [created] obsidian/INDEX.md"
else
  echo "  [exists]  obsidian/INDEX.md"
fi

# ─────────────────────────────────────────────────────────────
# CLAUDE.md
# ─────────────────────────────────────────────────────────────
CLAUDEMD="$PROJECT_PATH/CLAUDE.md"
if [ ! -f "$CLAUDEMD" ]; then
  printf '@obsidian/SESSION.md\n@obsidian/INDEX.md\n' > "$CLAUDEMD"
  echo "  [created] CLAUDE.md"
else
  if ! grep -q "SESSION.md" "$CLAUDEMD"; then
    printf '\n@obsidian/SESSION.md\n@obsidian/INDEX.md\n' >> "$CLAUDEMD"
    echo "  [updated] CLAUDE.md (added memory imports)"
  else
    echo "  [exists]  CLAUDE.md (already has memory imports)"
  fi
fi

# ─────────────────────────────────────────────────────────────
# AGENTS.md
# ─────────────────────────────────────────────────────────────
AGENTSMD="$PROJECT_PATH/AGENTS.md"
if [ ! -f "$AGENTSMD" ]; then
  cat > "$AGENTSMD" << 'AGENTSEOF'
## Project Memory

Load and apply these files at session start:
- `obsidian/SESSION.md` — resume from last session, do not re-implement completed features
- `obsidian/INDEX.md` — use this as the project map, do not read source files to understand structure

## Memory Update Rule (non-negotiable)

After completing any task or subtask:
1. Update `obsidian/SESSION.md` — mark done, set next step, update in-progress list
2. If files were created or deleted: update `obsidian/INDEX.md`

Update continuously during work. Do not wait until session end.
AGENTSEOF
  echo "  [created] AGENTS.md"
else
  if ! grep -q "Memory Update Rule" "$AGENTSMD"; then
    cat >> "$AGENTSMD" << 'AGENTSEOF'

---

## Project Memory

Load and apply these files at session start:
- `obsidian/SESSION.md` — resume from last session, do not re-implement completed features
- `obsidian/INDEX.md` — use this as the project map, do not read source files to understand structure

## Memory Update Rule (non-negotiable)

After completing any task or subtask:
1. Update `obsidian/SESSION.md` — mark done, set next step, update in-progress list
2. If files were created or deleted: update `obsidian/INDEX.md`

Update continuously during work. Do not wait until session end.
AGENTSEOF
    echo "  [updated] AGENTS.md (added memory rules)"
  else
    echo "  [exists]  AGENTS.md (already has memory rules)"
  fi
fi

# ─────────────────────────────────────────────────────────────
# opencode.json
# ─────────────────────────────────────────────────────────────
OPENCODEJSON="$PROJECT_PATH/opencode.json"
if [ ! -f "$OPENCODEJSON" ]; then
  cat > "$OPENCODEJSON" << 'OPENCODEEOF'
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "obsidian/SESSION.md",
    "obsidian/INDEX.md"
  ]
}
OPENCODEEOF
  echo "  [created] opencode.json"
else
  echo "  [exists]  opencode.json — manually verify that SESSION.md and INDEX.md are listed in the instructions array"
fi

# ─────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────
echo ""
echo "Done. Next steps:"
echo ""
echo "  1. cd $PROJECT_PATH"
echo "  2. claude  (or: opencode)"
echo "  3. Tell the AI: 'Fill in obsidian/SESSION.md and INDEX.md with the real project state'"
echo ""
echo "Tip: add this alias to your shell profile for faster access:"
echo "  alias new-project=\"\$HOME/scripts/init-project-memory.sh\""
