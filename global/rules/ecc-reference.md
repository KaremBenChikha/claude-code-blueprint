## What ECC is

Everything Claude Code is a Claude Code harness ecosystem organized around five pillars:

| Pillar | What it is | How Claude uses it |
|---|---|---|
| **Rules** | Always-on defaults and quality standards | Read automatically every session |
| **Skills** | Domain knowledge packs | Loaded on-demand when relevant |
| **Agents** | Specialized workers (planner, security, TDD, etc.) | Invoked by task type |
| **Commands** | Fast entry points for common workflows | Called via `/command-name` |
| **Hooks** | Automatic guardrails or actions around events | Run on tool use / file save |

---

## Installed agents (starter set)

| Agent | Use for |
|---|---|
| `planner` | New features, large changes, sequencing work |
| `architect` | System design, module boundaries, interface decisions |
| `code-reviewer` | Review your own diffs, PR hardening, maintainability |
| `security-reviewer` | Auth, secrets, external input, permissions, webhooks |
| `tdd-guide` | Test-first implementation, regression coverage |
| `refactor-cleaner` | Cleanup, dead code, behavior-preserving restructure |
| `build-error-resolver` | Build failures, dependency issues, CI errors |
| `e2e-runner` | End-to-end test setup and execution |

---

## Mental model

```
Global ~/.claude/CLAUDE.md     → your identity and preferences (always on)
Global ~/.claude/rules/        → framework knowledge and workflow patterns (always on)
Global ~/.claude/agents/       → specialist workers (invoked by task type)
Global ~/.claude/commands/     → slash commands for explicit workflows
Project .claude/CLAUDE.md      → repo-specific context, stack, commands
```

---

## When to use ECC

- Feature planning and phased implementation
- Code and PR review
- Test-first implementation (TDD)
- Security audit on sensitive areas
- Bug triage and root cause analysis
- Repetitive engineering workflows

## When NOT to over-engineer it

- Tiny one-line edits
- Obvious single-file fixes
- Quick copy or label changes
- Simple documentation updates

---

## Operating rule

Use ECC to improve judgment and consistency — not to force every task through a ceremony.
The best harness is the one that disappears while work gets done.
