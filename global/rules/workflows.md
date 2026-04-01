# ── global/rules/workflows.md ─────────────────────────────────────────────
workflows = """# Prompt Patterns and Workflows

## Universal prompt shape (use for complex asks)

```
Task:       [what you want]
Context:    [relevant files, modules, or state]
Constraints:[what must stay unchanged, what to avoid]
Done when:  [what good output looks like]
```

---

## Session start

Run once per session or when switching projects.

```
New session. Read the project instructions, detect the stack,
list the main test/lint/build commands, and summarize the
architecture in 8 bullets.
```

---

## Bug fix workflow

```
Investigate and fix this bug.
Context:     [what is happening]
Expected:    [what should happen]
Actual:      [what is happening instead]
Constraints: preserve behavior outside the bug, minimal diff,
             add or update regression tests.
Start by identifying root cause, then propose the smallest safe fix.
```

---

## New feature workflow

```
Plan and implement this feature.
Feature:     [description]
Context:     [relevant files or module]
Constraints: match existing patterns, avoid unnecessary abstractions,
             keep changes reviewable.
Give a short implementation plan first, then execute step by step.
```

---

## Code review workflow

Use before merge or after a large task.

```
Review these changes for:
- Correctness
- Security
- Maintainability
- Performance
- Missing tests
Be concrete. Prioritize must-fix issues first.
```

---

## Security workflow

Use when touching auth, tokens, webhooks, external APIs, file access, or user input.

```
Security review on this implementation.
List findings by severity (critical / high / medium / low)
with concrete remediations for each.
```

---

## Refactor workflow

Use for cleanup without product changes.

```
Refactor this area without changing behavior.
Preserve interfaces. Reduce duplication.
Keep the diff reviewable. Show the plan before making broad edits.
```

---

## Architecture decision workflow

```
I need to decide: [decision].
Consider: tradeoffs, long-term maintainability, complexity cost,
          and fit with the existing architecture.
Give me a clear recommendation with reasoning.
```

---

## Anti-patterns to avoid

- Forcing planner/reviewer/security flows on tiny edits
- Writing giant prompts when 2 lines will do
- Using a separate translator chat for every task
- Duplicating project instructions inside each prompt
- Installing every agent/skill just because it exists

---

## Shortcut rule

If the task is small → skip the template and ask directly.

Examples:
- `Review this diff for security and missing tests.`
- `Fix this failing test with the smallest safe change.`
- `Plan this feature before coding anything.`
- `Is this auth implementation secure? List risks.`
"""

with open(f"{base}/global/rules/workflows.md", "w") as f:
    f.write(workflows)
print("global/rules/workflows.md ✓")