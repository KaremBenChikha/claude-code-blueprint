# ── scripts/uninstall.sh ──────────────────────────────────────────────────
uninstall = """#!/usr/bin/env bash
# =============================================================
#  Claude Code — Full Uninstall Script (macOS)
#  Run: bash scripts/uninstall.sh
# =============================================================

set -e

BOLD=$(tput bold)
RESET=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

echo ""
echo "${BOLD}Claude Code — Full Uninstall${RESET}"
echo "───────────────────────────────────────"

# ── 1. Optional backup ─────────────────────────────────────────────────────
if [ -d "$HOME/.claude" ]; then
  BACKUP="$HOME/claude-backup-$(date +%Y%m%d-%H%M%S)"
  echo "${YELLOW}Backing up ~/.claude to $BACKUP${RESET}"
  cp -R "$HOME/.claude" "$BACKUP"
  echo "${GREEN}✓ Backup created at $BACKUP${RESET}"
else
  echo "No ~/.claude directory found — skipping backup."
fi

# ── 2. Uninstall binary ────────────────────────────────────────────────────
echo ""
echo "Uninstalling Claude Code binary..."

if command -v claude &> /dev/null; then
  CLAUDE_PATH=$(which claude)
  echo "Found claude at: $CLAUDE_PATH"

  # Try native uninstaller first
  if claude uninstall 2>/dev/null; then
    echo "${GREEN}✓ Native uninstaller ran successfully${RESET}"
  else
    # Try npm
    if npm uninstall -g @anthropic-ai/claude-code 2>/dev/null; then
      echo "${GREEN}✓ npm uninstall ran successfully${RESET}"
    else
      echo "${RED}Could not auto-uninstall. Removing binary manually...${RESET}"
      rm -f "$CLAUDE_PATH"
    fi
  fi
else
  echo "claude binary not found — skipping."
fi

# ── 3. Remove all config and cache ────────────────────────────────────────
echo ""
echo "Removing config, auth tokens, and cache..."

rm -rf "$HOME/.claude"
rm -rf "$HOME/.claude-code"
rm -rf "$HOME/Library/Application Support/claude-code"
rm -rf "$HOME/Library/Caches/claude-code"
rm -rf "$HOME/Library/Preferences/com.anthropic.claude-code"*

echo "${GREEN}✓ Config and cache removed${RESET}"

# ── 4. Verify ─────────────────────────────────────────────────────────────
echo ""
echo "Verifying clean state..."

if command -v claude &> /dev/null; then
  echo "${RED}⚠ claude binary still found at $(which claude)${RESET}"
  echo "You may need to remove it manually."
else
  echo "${GREEN}✓ claude binary not found — clean uninstall confirmed${RESET}"
fi

echo ""
echo "${BOLD}${GREEN}Uninstall complete.${RESET}"
echo "You can now run: bash scripts/install.sh"
echo ""
"""

with open(f"{base}/scripts/uninstall.sh", "w") as f:
    f.write(uninstall)
print("scripts/uninstall.sh ✓")