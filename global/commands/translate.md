## What this does

Takes any plain-English description and outputs a structured Claude Code prompt
with the right agent, depth level, constraints, and verification steps.

---

## Decision map

| Problem type | Command / Agent | Depth |
|---|---|---|
| UI bug or visual issue | Bug fix + frontend agent | think |
| Backend error / API failure | Bug fix + backend agent | think-hard |
| Slow page or query | Performance analysis | think-hard |
| Security concern | Security review | ultrathink |
| New feature | Plan + implement | think |
| Code review / quality | Code reviewer | think |
| Refactor / cleanup | Refactor cleaner | think |
| Write tests | TDD guide | think |
| Architecture design | Architect | think-hard |
| Project planning | Planner | think |
| Build failure | Build error resolver | think |

---

## Universal output template

```
Task:        [clear task description]
Context:     [relevant files, modules, state]
Constraints: [what must not change, what to avoid]
Done when:   [definition of good output]

Agents:      [planner / architect / security-reviewer / etc.]
Depth:       [think / think-hard / ultrathink]
Safety:      [preview changes / safe mode if touching critical files]
```

---

## Real examples

### "My save button is not showing"

```
Task:        Save button is missing from the UI.
Context:     Form component, save handler, button rendering logic.
Expected:    Save button renders and is interactive.
Actual:      Button absent from the UI.
Constraints: Do not change behavior outside the button component.
Investigate: conditional rendering, CSS display/visibility/opacity/z-index,
             component mount state, prop drilling, feature flags, permissions.
Agent:       code-reviewer (frontend)
Depth:       think
```

### "My API is returning 500 errors"

```
Task:        API endpoint returning HTTP 500.
Context:     Route handler, controller, middleware, error handling.
Expected:    200 response with correct data.
Actual:      Server error on this endpoint.
Constraints: Minimal diff, add regression test.
Investigate: null reference, DB query failure, missing async/await,
             unhandled promise rejection, middleware order, missing env var.
Agent:       build-error-resolver
Depth:       think-hard
```

### "Add dark mode toggle"

```
Task:        Dark mode toggle accessible from the UI.
Context:     Theme system, CSS variables, AppShell, Layout component.
Constraints: Check existing theme system before building new.
             Use CSS variables + context API. Persist via localStorage.
Approach:    Plan first, then implement.
Agent:       planner → architect → code-reviewer
Depth:       think
```

### "Is my auth secure?"

```
Task:        Security review on the auth implementation.
Scope:       Token validation, secret exposure, injection points,
             session fixation, rate limiting, IDOR.
Output:      Findings by severity (critical/high/medium/low)
             with concrete fixes for each.
Agent:       security-reviewer
Depth:       ultrathink
```

### "Clean up my components folder"

```
Task:        Refactor components folder without changing behavior.
Goals:       Remove dead code, reduce duplication, improve structure.
Constraints: Preserve all public interfaces and existing test coverage.
             Show plan before making broad edits.
Agent:       refactor-cleaner
Depth:       think
```

---

## Shortcut rule

Only use `/translate` when the task is genuinely vague or complex.
For most daily tasks, write directly — your rules and agents handle the rest.