---
name: brain-dump-to-app
description: >-
  Transform raw voice transcripts into production-ready app plans in 10 stages.
  Parses messy input, recommends stack by ECC coverage, estimates Indian costs in INR,
  and guides through /plan → /tdd → /code-review → /e2e → /verify.
  Built for white-label model: you build apps, clients pay via link, access gates on payment.
  TRIGGER when: user pastes a voice transcript, messy app idea, or uses /brain-dump.
  DO NOT TRIGGER when: user has clear requirements already, or is mid-implementation.
origin: ECC
---

# Brain Dump to App — 10 Stage Guide

Voice idea → structured plan → live app with paying clients.

## Business Model Context

The developer builds apps for **exclusive clients**. Each client:
- Gets a private link to access the app
- Pays monthly via Razorpay (UPI autopay / card)
- Loses access automatically when payment stops
- Their payment covers all infra costs + developer's profit margin

Every app built through this skill includes: subscription table, Razorpay webhook, and access-check middleware.

---

## The 10 Stages

### Stage 1: Brain Dump (Voice Input)

**Goal**: Get the raw idea out of the user's head.

**How**: User opens voice app on phone, talks freely, pastes transcript here.

**Transcript cleaning rules**:
- Remove filler: "um", "uh", "like", "you know", "basically"
- Split at boundaries: "and also", "oh and", "maybe", "it should"
- "maybe" / "possibly" / "would be cool" = nice-to-have
- "people can" / "companies can" / "admin should" = user roles

---

### Stage 2: Requirements Extraction

**Goal**: Turn messy text into structured requirements.

**Extract**:

| What | Look For |
|------|---------|
| App name | Infer from context |
| One-liner | What it does in one sentence |
| Core features | Stated as requirements ("it should", "users can") |
| Nice-to-haves | "maybe", "possibly", "would be cool" |
| User roles | Who uses it, what each role does |
| Technical signals | See detection table below |

**Technical Signal Detection**:

| Words in Transcript | Means You Need | ECC Skill |
|--------------------|---------------|-----------|
| "upload", "file", "pdf" | File storage + processing | backend-patterns |
| "ai", "smart", "auto" | LLM integration | cost-aware-llm-pipeline |
| "chat", "real-time", "live" | WebSocket / SSE | frontend-patterns |
| "login", "users" | Auth system | django-security |
| "pay", "subscribe" | Payment gateway | api-design |
| "mobile", "phone" | Responsive UI | frontend-patterns |
| "dashboard", "analytics" | Data viz | postgres-patterns |
| "email", "notify" | Notifications | backend-patterns |
| "search", "filter" | Search infra | postgres-patterns |
| "schedule", "cron" | Background jobs | docker-patterns |

**Always ask user to confirm** before moving to Stage 3.

---

### Stage 3: Stack Selection

**Goal**: Pick the best stack based on app needs + ECC coverage.

**Score across 5 dimensions**:

| Dimension | Weight |
|-----------|--------|
| ECC skill coverage | 30% |
| App feature fit | 25% |
| Indian ecosystem (hiring, community) | 15% |
| Hosting cost | 15% |
| Speed to MVP | 15% |

**Stack Profiles**:

| Profile | Stack | ECC Score | Best When |
|---------|-------|-----------|-----------|
| A | Django + Next.js + PostgreSQL | 9.5/10 | AI apps, multi-tenant, complex data |
| B | FastAPI + Next.js + PostgreSQL | 7/10 | API-first, streaming, solo dev |
| C | Spring Boot + React + PostgreSQL | 8/10 | Enterprise, B2B, Java team |
| D | Next.js full-stack (TypeScript) | 6.5/10 | Simple apps, content sites, quick MVP |
| E | Go + Next.js + PostgreSQL | 6/10 | High concurrency, infra tools |

**All profiles include**: Razorpay subscription + access-gating middleware + per-client usage tracking.

**Output**: Recommended stack + one alternative with trade-offs.

---

### Stage 4: Cost Estimation (INR)

**Goal**: Know exactly what it costs to run, and what to charge clients.

**Pricing reference (March 2026, INR)**:

| Service | Free Tier | Small (₹/mo) | Medium (₹/mo) |
|---------|-----------|-------------|---------------|
| Railway (hosting) | 500 hrs | ₹420 | ₹1,500-4,000 |
| Supabase (DB) | 500MB | ₹0 | ₹2,100 |
| Claude Haiku (AI) | - | ₹2,000-5,000 | ₹15,000-40,000 |
| Cloudflare (CDN) | Unlimited | ₹0 | ₹0 |
| Resend (email) | 3K/mo | ₹0 | ₹0 |
| Domain (.in) | - | ₹50/mo | ₹50/mo |

**Pricing formula for your clients**:

```
Your infra cost × 2 to 3 = Client's monthly price

Example:
  Your cost:    ₹3,400/mo
  Charge client: ₹6,000-8,000/mo
  Your profit:   ₹2,600-4,600/mo per client
```

**AI cost optimization**: Use `cost-aware-llm-pipeline` skill — route 80% to Haiku, 20% to Sonnet. Saves 60-70%.

---

### Stage 5: Plan → `/plan`

**Goal**: Detailed step-by-step build plan.

**What happens**:
- Database schema design (includes `subscriptions` table, `client_usage` table)
- API endpoints list
- Component breakdown
- Phase-by-phase build order
- Risk assessment

**You do**: Review plan, say "proceed" or "modify X".

**Always includes for your model**:
- `subscriptions` table (client_id, plan, status, razorpay_subscription_id, expires_at)
- `client_usage` table (client_id, date, api_calls, tokens_used, cost_usd)
- Razorpay webhook endpoint (`/api/webhooks/razorpay`)
- Access-check middleware (checks `subscription.active` on every request)

---

### Stage 6: Build with TDD → `/tdd`

**Goal**: Write tests first, then code.

**How it works**:
1. Write failing test for the feature
2. Write minimal code to pass
3. Refactor
4. Repeat
5. Target: 80%+ coverage

**Build order** (always):
1. Auth + subscription check (pay-gate first)
2. Core feature (#1 value prop)
3. Supporting features
4. AI integration (with cost tracking per client)
5. Frontend

---

### Stage 7: Code Review → `/code-review`

**Goal**: Catch bugs, security holes, performance issues.

**Checks**:
- No exposed API keys or secrets
- SQL injection prevention
- XSS prevention
- Razorpay webhook signature verification
- Per-client data isolation (no data leaks between clients)
- N+1 query detection

---

### Stage 8: E2E Testing → `/e2e`

**Goal**: Test like a real user.

**Critical flows to test**:
- Client visits link → sees login page
- Client signs up → makes payment → gets access
- Client uses app features → everything works
- Client's subscription expires → sees "renew" page (NOT the app)
- Client renews → access restored immediately

---

### Stage 9: Deploy → `/verify`

**Goal**: Put it live.

**Steps**:
1. Docker containerization
2. Deploy to Railway / AWS Mumbai
3. Connect domain (subdomain per client: `clientname.yourdomain.in`)
4. SSL (free, Let's Encrypt)
5. Razorpay webhooks pointed to live URL
6. Environment variables set (API keys, DB URL, Razorpay keys)

**Exit criteria**: Live URL, payments work, access gating works.

---

### Stage 10: Harden + Monitor

**Goal**: Make it safe and know when things break.

**Security** (via `security-reviewer` agent):
- Rate limiting per client
- Input validation on all forms
- Razorpay webhook signature verification
- HTTPS enforced

**Monitoring**:
- Error tracking (Sentry free tier)
- Usage dashboard (per-client API calls, cost, last login)
- Alert if any client's usage spikes beyond their plan
- Monthly cost report: actual infra cost vs client revenue

---

## Quick Reference Card

```
Stage  What               Command/Tool          Time
─────  ─────────────────  ────────────────────  ──────
  1    Brain Dump         (voice app → paste)   5 min
  2    Requirements       (Claude parses)       5 min
  3    Stack Pick         (Claude scores)       2 min
  4    Cost Estimate      (Claude calculates)   2 min
  5    Plan               /plan                 15 min
  6    Build              /tdd                  2-5 days
  7    Code Review        /code-review          30 min
  8    E2E Tests          /e2e                  1-2 hrs
  9    Deploy             /verify               1-2 hrs
 10    Harden             security-reviewer     1-2 hrs
─────────────────────────────────────────────────────────
       Total: Brain dump to live app = ~1-2 weeks
```

## Voice-to-Text (Free, India)

| Method | How |
|--------|-----|
| **Simplest** | Google Docs on phone → tap mic → talk → copy |
| **Android** | Google Recorder (offline, Hindi + English) |
| **iOS** | Voice Memos + Live Transcription |
| **Hinglish** | Google voice typing handles mixed Hindi-English |

## Anti-Patterns

| What You Said | Problem | What Claude Does |
|--------------|---------|-----------------|
| "and also X and also Y..." | Feature creep | Pushes non-core to later stages |
| "like [big company]" | Scope explosion | Extracts the specific feature, not the whole product |
| No users mentioned | Missing user model | Asks: "Who uses this?" |
| "should be scalable" | Premature optimization | Notes for Stage 10, builds simple first |
| "maybe blockchain/AI/AR" | Buzzword stacking | Only includes if it serves a real need |
