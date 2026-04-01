# ── scripts/apply-global.sh ───────────────────────────────────────────────
apply = """#!/usr/bin/env bash
# =============================================================
#  Claude Code — Apply Custom Global Layer
#  Run from the root of this repo: bash scripts/apply-global.sh
# =============================================================

set -e

BOLD=$(tput bold)
RESET=$(tput sgr0)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo ""
echo "${BOLD}Claude Code — Apply Custom Global Layer${RESET}"
echo "───────────────────────────────────────"
echo "Repo: $REPO_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# ── Ensure target directories exist ───────────────────────────────────────
mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/commands"

# ── Apply files ────────────────────────────────────────────────────────────
echo "${CYAN}Applying files...${RESET}"

cp "$REPO_DIR/global/CLAUDE.md"                 "$CLAUDE_DIR/CLAUDE.md"
echo "${GREEN}✓${RESET} global/CLAUDE.md               → ~/.claude/CLAUDE.md"

cp "$REPO_DIR/global/rules/ecc-reference.md"   "$CLAUDE_DIR/rules/ecc-reference.md"
echo "${GREEN}✓${RESET} global/rules/ecc-reference.md  → ~/.claude/rules/ecc-reference.md"

cp "$REPO_DIR/global/rules/ecc-components.md"  "$CLAUDE_DIR/rules/ecc-components.md"
echo "${GREEN}✓${RESET} global/rules/ecc-components.md → ~/.claude/rules/ecc-components.md"

cp "$REPO_DIR/global/rules/workflows.md"       "$CLAUDE_DIR/rules/workflows.md"
echo "${GREEN}✓${RESET} global/rules/workflows.md      → ~/.claude/rules/workflows.md"

cp "$REPO_DIR/global/commands/translate.md"    "$CLAUDE_DIR/commands/translate.md"
echo "${GREEN}✓${RESET} commands/translate.md          → ~/.claude/commands/translate.md"

echo ""
echo "${BOLD}${GREEN}Custom layer applied.${RESET}"
echo ""
echo "Current ~/.claude/ structure:"
find "$CLAUDE_DIR" -maxdepth 2 | sort | sed "s|$HOME|~|g"
echo ""
"""

with open(f"{base}/scripts/apply-global.sh", "w") as f:
    f.write(apply)
print("scripts/apply-global.sh ✓")

# Make all scripts executable
import stat
for script in ["uninstall.sh", "install.sh", "apply-global.sh"]:
    path = f"{base}/scripts/{script}"
    st = os.stat(path)
    os.chmod(path, st.st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)

print("\nAll scripts marked as executable ✓")