# Session State — [Project Name]
_Last updated: YYYY-MM-DD HH:MM_

## Active Task
<!-- What you are working on RIGHT NOW. One or two lines. Be specific enough that returning to this after a week still makes sense. -->
- [e.g. "Implementing Stripe webhook handler for subscription events"]

## Last Completed
<!-- The most recently finished piece of work. One line, precise. -->
- [e.g. "Added Stripe checkout session creation endpoint at src/api/billing/checkout.ts"]

## Next Step
<!-- The EXACT next action when resuming. Specific enough to act on immediately without re-reading source files. -->
- [e.g. "Write the webhook signature verification in src/api/billing/webhook.ts — use stripe.webhooks.constructEvent()"]

## In Progress (incomplete)
<!-- Work that has been started but is not finished. Each line is a mini-status with what is done and what is not. -->
- [ ] [e.g. "Stripe billing — checkout endpoint done, webhook handler pending, customer portal not started"]
- [ ] [e.g. "Email notification system — design decided (Resend), implementation not started"]

## Completed Features (do not re-implement)
<!-- Everything that is fully shipped and working. The AI reads this section to avoid rebuilding things. Keep it accurate. -->
- [x] Authentication — [provider], session middleware at [path]
- [x] Database schema — migrations at db/migrations/, schema notes at obsidian/Database Schema.md
- [x] [Feature name] — [one line description, file path if relevant]

## Open Decisions
<!-- Unresolved choices or questions that affect what gets built next. -->
- [e.g. "Whether to use Resend or SendGrid for transactional email — leaning Resend based on pricing"]
- [e.g. "Rate limiting strategy — per-user vs per-IP, not decided"]

## Blockers / Notes
<!-- Anything stuck, known problems, configuration gaps, or important warnings before the AI takes action. -->
- [e.g. "Stripe test mode only — production keys not yet obtained from client"]
- [e.g. "npm test does NOT exist — use npx vitest to run tests"]
- [e.g. "DATABASE_URL env var is required but not in .env.example — check with team"]
