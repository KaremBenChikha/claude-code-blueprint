# ── scripts/install.sh ────────────────────────────────────────────────────
install = """#!/usr/bin/env bash
# =============================================================
#  Claude Code — Fresh Install + ECC Setup (macOS)
#  Run: bash scripts/install.sh
# =============================================================

set -e

BOLD=$(tput bold)
RESET=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)

echo ""
echo "${BOLD}Claude Code — Fresh Install + ECC${RESET}"
echo "───────────────────────────────────────"

# ── 1. Check prerequisites ────────────────────────────────────────────────
echo ""
echo "${CYAN}Checking prerequisites...${RESET}"

if ! command -v node &> /dev/null; then
  echo "Node.js not found. Install via: brew install node"
  exit 1
fi

if ! command -v git &> /dev/null; then
  echo "Git not found. Install via: brew install git"
  exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo "Node.js 18+ required. Found: $(node --version)"
  exit 1
fi

echo "${GREEN}✓ Node.js $(node --version)${RESET}"
echo "${GREEN}✓ Git $(git --version | awk '{print $3}')${RESET}"

# ── 2. Install Claude Code ────────────────────────────────────────────────
echo ""
echo "${CYAN}Installing Claude Code...${RESET}"
curl -fsSL https://claude.ai/install.sh | bash

echo "${GREEN}✓ Claude Code installed${RESET}"
echo ""
echo "${YELLOW}Open a new terminal tab, then run:${RESET}"
echo "  claude --version"
echo "  claude login"
echo ""
read -p "Press Enter once you have logged in and verified the install... "

# ── 3. Create ~/.claude structure ─────────────────────────────────────────
echo ""
echo "${CYAN}Creating ~/.claude directory structure...${RESET}"
mkdir -p "$HOME/.claude/agents"
mkdir -p "$HOME/.claude/rules"
mkdir -p "$HOME/.claude/commands"
mkdir -p "$HOME/.claude/skills"
echo "${GREEN}✓ Directory structure created${RESET}"

# ── 4. Clone and install ECC ──────────────────────────────────────────────
echo ""
echo "${CYAN}Cloning everything-claude-code...${RESET}"

ECC_DIR="$HOME/ecc-source"
if [ -d "$ECC_DIR" ]; then
  echo "ECC already cloned at $ECC_DIR — pulling latest..."
  cd "$ECC_DIR" && git pull && cd -
else
  git clone https://github.com/affaan-m/everything-claude-code.git "$ECC_DIR"
fi
echo "${GREEN}✓ ECC source ready at $ECC_DIR${RESET}"

# ── 5. Copy ECC agents (starter set) ──────────────────────────────────────
echo ""
echo "${CYAN}Installing ECC agents (starter set)...${RESET}"

AGENTS=(
  "planner"
  "architect"
  "code-reviewer"
  "security-reviewer"
  "tdd-guide"
  "refactor-cleaner"
  "build-error-resolver"
  "e2e-runner"
)

for AGENT in "${AGENTS[@]}"; do
  SRC="$ECC_DIR/agents/${AGENT}.md"
  DEST="$HOME/.claude/agents/${AGENT}.md"
  if [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    echo "  ${GREEN}✓${RESET} $AGENT"
  else
    echo "  ${YELLOW}⚠ $AGENT not found in ECC source — skipping${RESET}"
  fi
done

# ── 6. Copy ECC rules ─────────────────────────────────────────────────────
echo ""
echo "${CYAN}Installing ECC rules...${RESET}"

if [ -d "$ECC_DIR/rules/common" ]; then
  cp -r "$ECC_DIR/rules/common/"* "$HOME/.claude/rules/" 2>/dev/null || true
  echo "  ${GREEN}✓ Common rules${RESET}"
fi

# Python rules (adjust or comment out if you use a different language)
if [ -d "$ECC_DIR/rules/python" ]; then
  cp -r "$ECC_DIR/rules/python/"* "$HOME/.claude/rules/" 2>/dev/null || true
  echo "  ${GREEN}✓ Python rules${RESET}"
fi

# ── 7. Copy ECC commands and skills ───────────────────────────────────────
if [ -d "$ECC_DIR/commands" ]; then
  cp "$ECC_DIR/commands/"*.md "$HOME/.claude/commands/" 2>/dev/null || true
  echo ""
  echo "  ${GREEN}✓ ECC commands${RESET}"
fi

if [ -d "$ECC_DIR/skills" ]; then
  cp -r "$ECC_DIR/skills/"* "$HOME/.claude/skills/" 2>/dev/null || true
  echo "  ${GREEN}✓ ECC skills${RESET}"
fi

echo ""
echo "${BOLD}${GREEN}ECC installation complete.${RESET}"
echo ""
echo "Next step: apply your custom layer"
echo "  bash scripts/apply-global.sh"
echo ""
"""

with open(f"{base}/scripts/install.sh", "w") as f:
    f.write(install)
print("scripts/install.sh ✓")