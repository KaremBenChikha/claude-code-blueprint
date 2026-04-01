# ── project-template/.claude/CLAUDE.md ───────────────────────────────────
project_template = """# Project: [Project Name]

> Copy this file to .claude/CLAUDE.md in any new repo and fill in the sections below.
> Delete these instructions once you have filled everything in.

---

## Stack

- Language: [Python / TypeScript / etc.]
- Framework: [FastAPI / Express / Next.js / etc.]
- Infrastructure: [AWS Lambda / EC2 / Vercel / etc.]
- Database: [PostgreSQL / DynamoDB / SQLite / etc.]
- Key libraries: [list the most important ones]

---

## Commands

```bash
# Tests
[e.g. pytest / npm test / yarn test]

# Lint
[e.g. ruff check . / eslint src/]

# Build
[e.g. npm run build / docker build .]

# Local dev
[e.g. uvicorn main:app --reload / npm run dev]

# Deploy
[e.g. serverless deploy / cdk deploy]
```

---

## Architecture

[Write 6-10 bullets describing the main modules, data flow, or key decisions]

- e.g. All Lambda functions live in `functions/` and share a common `utils/` layer
- e.g. Auth is handled by a JWT middleware in `middleware/auth.py`
- e.g. DB access goes through `repositories/` — never query directly from handlers
- e.g. Environment config loaded from SSM Parameter Store at cold start

---

## Key files and folders

| Path | Purpose |
|---|---|
| `[path]` | [what it does] |
| `[path]` | [what it does] |

---

## Constraints and rules

[List anything Claude must respect when working on this repo]

- e.g. Never modify `migrations/` — always generate new migration files
- e.g. All public API changes require an updated OpenAPI spec
- e.g. Secrets must never be hardcoded — use env vars or SSM
- e.g. All new endpoints need unit tests before merging

---

## Known gotchas

[List tricky areas, common mistakes, or things that surprised you]

- e.g. The `scraper/` module uses rotating proxies — don't bypass the pool
- e.g. Lambda cold starts are sensitive — keep imports minimal
- e.g. The test DB resets between each test run — don't rely on seeded state

---

## Contacts and docs

- Repo: [GitHub URL]
- Docs: [internal wiki / Notion / Confluence link]
- Runbook: [link if exists]
"""

with open(f"{base}/project-template/.claude/CLAUDE.md", "w") as f:
    f.write(project_template)
print("project-template/.claude/CLAUDE.md ✓")