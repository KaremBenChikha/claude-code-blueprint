# Project Index — [Project Name]
_Last updated: YYYY-MM-DD_

## Stack
<!-- One line per layer. Include version where it matters. -->
- **Frontend:** [e.g. Next.js 14, React 18, Tailwind CSS 3]
- **Backend:** [e.g. Node.js 20, tRPC v11]
- **Database:** [e.g. PostgreSQL 16, Drizzle ORM]
- **Auth:** [e.g. NextAuth.js v5, GitHub + Google OAuth]
- **Payments:** [e.g. Stripe — checkout sessions and webhooks]
- **Email:** [e.g. Resend — transactional only]
- **Deploy:** [e.g. Vercel (frontend + API), Supabase (database)]
- **Tests:** [e.g. Vitest — run with: npx vitest]

## Directory Map
<!-- What lives where. One line per path. Prefer directories over individual files here. -->
| Path | Purpose |
|---|---|
| `src/app/` | Next.js App Router pages and layouts |
| `src/api/` | Server-side API route handlers |
| `src/components/` | Shared React components |
| `src/lib/` | Shared utilities and service clients |
| `src/lib/db/` | Database client, queries, and helpers |
| `src/lib/auth.ts` | Auth configuration and session helpers |
| `db/migrations/` | SQL migration files |
| `obsidian/` | AI memory files and domain notes |

## Key Files
<!-- Files that are unusually important to know about — entry points, config, middleware, etc. -->
| File | Does |
|---|---|
| `src/middleware.ts` | Protects authenticated routes, redirects unauthenticated users |
| `src/lib/auth.ts` | NextAuth config — providers, callbacks, session shape |
| `src/lib/db/client.ts` | Drizzle client singleton — import this, not the raw pool |
| `src/lib/stripe.ts` | Stripe client singleton and price constants |
| `src/app/api/webhooks/stripe/route.ts` | Stripe webhook receiver |
| `drizzle.config.ts` | Drizzle ORM config — points to db/migrations/ |
| `.env.example` | All required environment variables with descriptions |

## Key Functions / Exports
<!-- High-value symbols: functions that get called from many places, auth utilities, DB helpers. -->
| Symbol | File | Does |
|---|---|---|
| `getSession()` | `src/lib/auth.ts` | Returns the current user session or null |
| `requireAuth()` | `src/lib/auth.ts` | Throws 401 if no session — use in server actions |
| `db` | `src/lib/db/client.ts` | Drizzle ORM instance — use for all DB operations |
| `stripe` | `src/lib/stripe.ts` | Stripe client — do not instantiate separately |
| `createCheckoutSession()` | `src/lib/stripe.ts` | Creates a Stripe checkout session for a given price ID |

## External Services
<!-- Third-party integrations. Note what they are used for and current status. -->
| Service | Used for | Status |
|---|---|---|
| Stripe | Payments — checkout and subscriptions | Test mode |
| Resend | Transactional email | Planned |
| Vercel | Hosting and deployment | Live |
| Supabase | Managed PostgreSQL | Live |

## Architecture Notes
<!-- Key invariants, constraints, and patterns that apply across the codebase. Read before touching anything. -->
- Never call the database directly from React components — always go through `src/lib/db/`
- Auth is server-side only — session tokens never reach the client
- All Stripe amounts are in cents (integer) — never use floats for money
- Environment variables are validated at startup in `src/lib/env.ts` — add new vars there first
- API routes return `{ data, error }` shape consistently — do not break this convention
