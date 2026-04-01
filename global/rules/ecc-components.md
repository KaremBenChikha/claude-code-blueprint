# ── global/rules/ecc-components.md ───────────────────────────────────────
ecc_comp = """# ECC Components — Agents, Hooks, and Skills

## Agents

Use agents when specialization reduces mistakes and improves output quality.

### planner
- Use for: new features, large changes, complex sequencing
- Output: phased plan, dependencies, acceptance criteria
- Invoke: `Plan this feature: [description]`

### architect
- Use for: system design, module boundaries, interface decisions, tradeoff analysis
- Output: recommended design, tradeoffs, migration notes
- Invoke: `Design the architecture for: [component]`

### tdd-guide
- Use for: bug fixes, behavior changes, new logic with test coverage
- Output: tests first, implementation order, regression coverage
- Invoke: `Implement this test-first: [feature or fix]`

### code-reviewer
- Use for: reviewing your own changes, PR hardening, maintainability checks
- Output: risks, missing tests, simplification opportunities
- Invoke: `Review these changes for correctness, security, and missing tests`

### security-reviewer
- Use for: auth, secrets, external input, permissions, webhooks, injection risks
- Output: vulnerability checklist, concrete fixes, risk severity
- Invoke: `Security review on this area: [describe scope]`

### refactor-cleaner
- Use for: cleanup, dead code removal, structure improvements
- Output: behavior-preserving refactor plan, smallest safe diff
- Invoke: `Refactor [area] without changing behavior`

### build-error-resolver
- Use for: build failures, CI errors, dependency issues
- Output: root cause, fix steps, prevention notes
- Invoke: automatically triggered on build errors

### e2e-runner
- Use for: E2E test setup, running and interpreting browser tests
- Output: test plan, commands, failure analysis
- Invoke: `Set up E2E tests for: [feature or flow]`

---

## Hooks

Hooks should automate friction, not create noise.

### Good hook candidates
- Format after file edits
- Remind about tests after code changes
- Warn before deleting or moving critical files
- Run lightweight lint check on task completion

### Bad hook candidates
- Huge blocking scripts on every prompt
- Noisy reminders that fire constantly
- Expensive commands triggered on every tiny edit

---

## Skills

Skills are on-demand knowledge packs. They load relevant context without polluting every session.

### When to use skills
- Framework-specific work (FastAPI, Next.js, AWS CDK)
- Security review patterns
- API design conventions
- Testing patterns and coverage strategies
- Migration playbooks
- Deployment and CI/CD conventions

---

## Component selection rule

| Component | For |
|---|---|
| Agents | Specialized judgment and output quality |
| Hooks | Low-friction, non-blocking automation |
| Skills | Contextual knowledge loaded on demand |
| Rules | Always-on behavior and standards |

Start with what you actually need. Add more when you feel a real gap, not before.
"""

with open(f"{base}/global/rules/ecc-components.md", "w") as f:
    f.write(ecc_comp)
print("global/rules/ecc-components.md ✓")