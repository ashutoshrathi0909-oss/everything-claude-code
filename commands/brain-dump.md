---
description: Paste a voice brain dump. Get coached through 12 stages — from idea to deployed app with paying clients. Each stage tells you exactly what to run, what to expect, and when to move on.
---

# /brain-dump — Your App Building Coach

Drop your voice transcript. Claude becomes your coach — guiding you through every stage, telling you what command to run, what output to expect, and when to move to the next stage.

## How to Use

1. Open Google Docs on phone → tap mic → talk about your app → copy text
2. Come here, type `/brain-dump`, paste your text
3. Claude walks you through 12 stages — one at a time

---

## The 12 Stages

```
 Stage  Name                        You Run             What You Get
 ─────  ──────────────────────────  ──────────────────  ─────────────────────────────
   1    Brain Dump                  (paste transcript)  Raw idea captured
   2    Requirements                (Claude does it)    Structured features + roles
   3    Full Stack Decision         (Claude decides)    Stack + DB + MCP + API models
   4    Cost + Pricing              (Claude calculates) INR costs + client pricing
   5    Research & Discovery        /search-first       Existing solutions found
   6    Plan                        /plan               Step-by-step build plan
   7    Phase 1: Build (TDD)        /tdd                Tested core features
   8    Code Review                 /code-review        Clean, secure code
   9    E2E Testing                 /e2e                All user flows tested
  10    Deploy                      /verify             Live URL working
  11    Harden + Monitor            security-reviewer   Production-safe app
  12    Advanced Workflow (if needed) /orchestrate or /multi-workflow  Multi-agent execution
```

---

## Stage 1: Brain Dump

**What you do**: Paste your voice transcript. Messy is fine.

**What Claude does**: Reads it, acknowledges, moves to Stage 2.

---

## Stage 2: Requirements Extraction

**What Claude does**: Parses your dump into structured requirements.

**What you should see**:
```
✅ App Name: [suggested]
✅ One-liner: [what it does]
✅ Core Features: [numbered list]
✅ Nice-to-haves: [separate list]
✅ User Roles: [who uses it + what they can do]
✅ Technical Signals: [AI, uploads, real-time, etc.]
✅ Questions: [anything unclear]
```

**What you do**: Confirm or correct. Say "looks good" to move on.

---

## Stage 3: Full Stack Decision

**What Claude decides** (everything, not just framework):

```
✅ Backend:     [Django / FastAPI / Spring Boot / Next.js / Go]
✅ Frontend:    [Next.js / React / Vue]
✅ Database:    [PostgreSQL + pgvector / Supabase / MySQL]
✅ AI Models:   [Which Claude/OpenAI models + why]
✅ Payments:    [Razorpay — UPI autopay, subscription API]
✅ Auth:        [JWT / Session / Supabase Auth]
✅ File Storage: [S3 Mumbai / Supabase Storage]
✅ Cache:       [Upstash Redis / ElastiCache]
✅ Email:       [Resend / SES]
✅ Hosting:     [Railway / AWS Mumbai / Vercel]
✅ CDN:         [Cloudflare free]
✅ Domain:      [.in / .com recommendation]
✅ MCP Servers: [Which to enable for this project]
```

**MCP Servers Claude picks from**:

| MCP Server | When Claude Enables It |
|------------|----------------------|
| `github` | Always (PRs, issues) |
| `supabase` | If using Supabase for DB/auth/storage |
| `exa-web-search` | For Stage 5 research |
| `memory` | If multi-session project |
| `sequential-thinking` | If complex architecture decisions |
| `vercel` | If deploying frontend to Vercel |
| `railway` | If deploying backend to Railway |
| `context7` | If using unfamiliar libraries |
| `magic` | If need UI components |
| `insaits` | If security-critical app |
| `firecrawl` | If app needs web scraping |

**AI Model Recommendations** Claude gives you:

```
✅ Primary model:    [Haiku 4.5 / Sonnet 4.6 — for your app's API calls]
✅ Complex tasks:    [Sonnet 4.6 / Opus 4.6 — for heavy reasoning]
✅ Model routing:    [80% Haiku / 20% Sonnet — cost breakdown]
✅ Estimated AI cost: [₹X/mo at your scale]
✅ Alternative:      [GPT-4o-mini if you want multi-provider fallback]
```

**What you do**: Review the full stack. Say "approved" or ask to swap anything.

---

## Stage 4: Cost + Client Pricing

**What Claude shows you**:
```
✅ Per-service cost breakdown (INR/mo)
✅ Total infra cost per client
✅ Recommended client price (2-3x your cost)
✅ Your profit per client
✅ Break-even: how many clients you need
✅ Free tier strategy for MVP phase
```

**What you do**: Note down the pricing. Move on.

---

## Stage 5: Research & Discovery

> **Claude reminds you:**
> "Before we write any code, let's check if someone already built this. Run `/search-first` or I'll use `exa-web-search` MCP to find existing solutions, templates, and libraries."

**What you should expect**:
```
✅ Similar open-source projects found
✅ Useful libraries/packages identified
✅ Patterns we can reuse
✅ Things we DON'T need to build from scratch
```

**What you do**: Review findings. Say "let's build" to move on.

---

## Stage 6: Plan

> **Claude reminds you:**
> "Now run `/plan` — I'll create a step-by-step build plan. You MUST approve it before any code is written."

**What the plan output should look like**:
```
✅ Database schema (tables, relationships, indexes)
✅ API endpoints list (method, path, description)
✅ Component tree (frontend)
✅ Build order (what gets built first → last)
✅ Phase breakdown with exit criteria per phase
✅ Risk assessment (high/medium/low)
✅ Subscription + access-gating included from Phase 1
```

**What you do**: Read the plan carefully. Say "proceed" or "modify [X]".

---

## Stage 7: Phase 1 Build (TDD)

> **Claude reminds you:**
> "Now run `/tdd` — I'll write tests FIRST, then implement. Build order: auth + payment gate → core feature → supporting features → AI integration → frontend."

**What /tdd results should look like**:
```
✅ Test file created BEFORE implementation
✅ Test runs and FAILS (red) — this is correct
✅ Implementation written to pass the test
✅ Test runs and PASSES (green)
✅ Code refactored (improve)
✅ Coverage report: 80%+ target
✅ Repeat for each feature
```

**Features built in order**:
1. Auth + Razorpay subscription (pay-gate)
2. Core feature (your app's #1 value)
3. Supporting features
4. AI integration (with model routing + cost tracking)
5. Frontend components

**What you do**: Watch the TDD cycle. Intervene if something looks wrong. When all features pass, say "done with build".

---

## Stage 8: Code Review

> **Claude reminds you:**
> "Build complete. Now run `/code-review` — I'll review everything for quality, security, and performance."

**What code review output should look like**:
```
✅ CRITICAL issues: [must fix before deploy]
✅ HIGH issues: [should fix]
✅ MEDIUM issues: [fix if time allows]
✅ Security: no exposed keys, injection safe, XSS prevented
✅ Razorpay webhook signature verification: ✓
✅ Per-client data isolation: ✓
✅ Performance: no N+1 queries, proper indexes
```

**What you do**: Fix all CRITICAL and HIGH issues. Then say "review done, moving on".

---

## Stage 9: E2E Testing

> **Claude reminds you:**
> "Now run `/e2e` — I'll test the app like a real user."

**What E2E results should look like**:
```
✅ Client visits link → login page shown
✅ Client signs up → payment page shown
✅ Client pays (Razorpay test mode) → app access granted
✅ Client uses core features → all work correctly
✅ Client's subscription expires → "renew" page shown (NOT the app)
✅ Client renews → access restored
✅ All test screenshots captured
```

**What you do**: Review the test results. If all pass, say "ready to deploy".

---

## Stage 10: Deploy

> **Claude reminds you:**
> "Time to go live. I'll walk you through deployment step by step."

**Deployment walkthrough**:
```
Step 1: Docker
  → Claude creates Dockerfile + docker-compose.yml
  → You verify: `docker compose up` works locally

Step 2: Push to hosting
  → Railway: `railway up` or connect GitHub repo
  → AWS: Push to ECR → deploy to ECS
  → Vercel (frontend): `vercel deploy`

Step 3: Database
  → Supabase: Already hosted, just connect URL
  → RDS: Claude gives you the setup commands

Step 4: Domain
  → Buy .in domain (~₹600/yr)
  → Point DNS to your hosting
  → SSL auto-configured (Let's Encrypt)

Step 5: Environment variables
  → Set all API keys, DB URL, Razorpay keys in hosting dashboard

Step 6: Razorpay webhooks
  → Point to: https://yourdomain.in/api/webhooks/razorpay
  → Verify signature checking works

Step 7: Smoke test
  → Visit live URL
  → Create test account
  → Make test payment
  → Verify access gating works
```

**What you do**: Follow each step. Say "live" when the URL works.

---

## Stage 11: Harden + Monitor

> **Claude reminds you:**
> "App is live. Now let's secure it. I'll run the security reviewer."

**What gets done**:
```
✅ Rate limiting on all endpoints
✅ Input validation on all forms
✅ HTTPS enforced
✅ Error monitoring (Sentry free tier)
✅ Per-client usage dashboard
✅ Cost alert: notify if any client's AI usage spikes
✅ Monthly report: infra cost vs client revenue
```

**What you do**: Verify security scan is clean. Set up alerts. Then your app is **production-ready**.

---

## Stage 12: Advanced Multi-Agent Workflow (Optional)

> **Claude analyzes your project and tells you:**
> "Based on your project's complexity, here's whether you need advanced workflows."

**Claude recommends one of these**:

| Project Size | Recommendation | Command |
|-------------|---------------|---------|
| **Small** (1-2 features, solo dev) | Skip Stage 12. The 11 stages above are enough. | — |
| **Medium** (3-5 features, some AI) | Use `/orchestrate` — runs planner → tdd → reviewer → security in sequence automatically. | `/orchestrate feature "your feature"` |
| **Large** (6+ features, complex AI) | Use `/multi-plan` then `/multi-execute` — parallel planning with multiple models, then parallel execution. | `/multi-plan` → review → `/multi-execute` |
| **Very Large** (multi-week, multi-PR) | Use `/multi-workflow` — full 6-phase pipeline with quality gates, or `/blueprint` for multi-session planning. | `/multi-workflow` or `/blueprint` |

**When Claude suggests Stage 12**:
```
✅ "Your project has [N] features across [M] modules"
✅ "Estimated complexity: [Small/Medium/Large/Very Large]"
✅ "Recommended workflow: [command] because [reason]"
✅ "This will: [what the advanced workflow does for you]"
✅ "Skip this if: [when it's overkill]"
```

**What the advanced commands do**:

| Command | What It Does |
|---------|-------------|
| `/orchestrate` | Chains agents automatically: planner → tdd-guide → code-reviewer → security-reviewer. You just watch. |
| `/multi-plan` | Uses multiple AI models in parallel to create the best plan. Saves to file. |
| `/multi-execute` | Reads the plan file, routes frontend/backend work to different models in parallel, then audits. |
| `/multi-workflow` | Full 6-phase workflow: Research → Ideation → Plan → Execute → Optimize → Review with quality gates. |
| `/blueprint` | Multi-session planning for projects that span multiple days/PRs. Each step is self-contained so a fresh Claude session can pick it up. |
| `/model-route` | Quick check: which AI model tier (Haiku/Sonnet/Opus) for this specific task? |

---

## Voice-to-Text (Free)

| Method | How |
|--------|-----|
| **Simplest** | Google Docs on phone → tap mic → talk → copy |
| **Android** | Google Recorder (offline, Hindi + English) |
| **iOS** | Voice Memos + Live Transcription |
| **Hinglish** | Google voice typing handles Hindi-English mix |

---

## Related Commands

| Command | When |
|---------|------|
| `/plan` | Stage 6 |
| `/tdd` | Stage 7 |
| `/code-review` | Stage 8 |
| `/e2e` | Stage 9 |
| `/verify` | Stage 10 |
| `/build-fix` | If build breaks at any stage |
| `/orchestrate` | Stage 12 (medium projects) |
| `/multi-workflow` | Stage 12 (large projects) |
| `/model-route` | Anytime — which AI model for this task? |
