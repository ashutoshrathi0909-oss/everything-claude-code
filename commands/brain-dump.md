---
description: Paste a voice transcript or messy brain dump about an app idea. Get a structured plan with stack recommendation, Indian production costs, and phase-by-phase guidance using ECC workflows.
---

# Brain Dump Command

This command takes a raw voice transcript or unstructured brain dump and transforms it into a complete, actionable app development plan.

## What This Command Does

1. **Parse the Brain Dump** - Extract requirements from messy voice transcript
2. **Recommend Stack** - Pick the best tech stack based on your app's needs and ECC skill coverage
3. **Estimate Costs** - Monthly production costs in INR for Indian deployment
4. **Generate Phased Plan** - Step-by-step phases that chain into existing ECC commands
5. **Guide Execution** - Walk you through each phase interactively

## When to Use

Use `/brain-dump` when:
- You have a voice recording transcript of your app idea
- You have scattered notes about what you want to build
- You want to go from zero to a structured plan without writing anything formal
- You need cost estimates before committing to a project

## How It Works

### Step 1: Paste Your Brain Dump

Just paste your raw voice transcript or notes. It can be messy. Example:

```
ok so i want to build this app where people can upload their resumes
and then ai reads the resume and matches them with jobs and also like
companies can post jobs and the ai scores how good the match is
and maybe a chat feature where candidates can talk to recruiters
oh and it should work on mobile too
```

### Step 2: Structured Requirements Extraction

The agent will parse your dump and output:

```markdown
## Extracted Requirements

### Core Features (Must Have)
1. Resume upload and AI parsing
2. Job posting by companies
3. AI-powered job-candidate matching with scores
4. Recruiter-candidate chat

### Nice to Have
1. Mobile-responsive or native app

### User Roles
- Candidates (upload resume, browse jobs, chat)
- Recruiters/Companies (post jobs, view matches, chat)
- Admin (manage platform)

### Technical Signals Detected
- File upload (PDF parsing)
- AI/LLM integration (resume parsing, matching)
- Real-time features (chat)
- Multi-tenant (companies)
```

### Step 3: Stack Recommendation

Based on extracted requirements, the agent recommends the optimal stack mapped to ECC skill coverage:

```markdown
## Recommended Stack

| Layer | Technology | ECC Skills Available | Why |
|-------|-----------|---------------------|-----|
| Backend | Django + DRF | 6 skills (patterns, security, tdd, verification) | Best ECC coverage, great for multi-tenant |
| Frontend | Next.js | 3 skills (frontend-patterns, coding-standards, e2e) | SSR for SEO, streaming for AI responses |
| AI Layer | Anthropic SDK | cost-aware-llm-pipeline, claude-api | Resume parsing, matching logic |
| Database | PostgreSQL + pgvector | postgres-patterns, database-migrations | Embeddings for semantic matching |
| Chat | Supabase Realtime | postgres-patterns | Real-time with zero infra |
| Deploy | Railway or AWS Mumbai | docker-patterns, deployment-patterns | Cheapest India region |
```

### Step 4: Cost Estimation (India)

```markdown
## Monthly Production Costs (INR)

### Small Scale (0-1000 users)
| Service | Provider | Plan | Cost/mo |
|---------|----------|------|---------|
| Backend hosting | Railway | Starter | ~₹400 (free tier) |
| Database | Supabase | Free | ₹0 |
| AI API (Claude) | Anthropic | Pay-as-you-go | ~₹2,000-5,000 |
| Domain (.in) | GoDaddy | Annual | ~₹100/mo |
| Email (transactional) | Resend | Free tier | ₹0 |
| File storage | Supabase Storage | Free tier | ₹0 |
| **Total** | | | **₹2,500-5,500/mo** |

### Medium Scale (1K-10K users)
| Service | Provider | Plan | Cost/mo |
|---------|----------|------|---------|
| Backend hosting | Railway / AWS Mumbai | Pro | ~₹1,500-4,000 |
| Database | Supabase Pro | 25GB | ~₹2,000 |
| AI API (Claude) | Anthropic | Haiku-first routing | ~₹8,000-15,000 |
| CDN | Cloudflare | Free | ₹0 |
| Domain | Route53 | Annual | ~₹100/mo |
| Redis (cache/queue) | Upstash | Pay-as-you-go | ~₹500 |
| File storage | S3 Mumbai | Pay-as-you-go | ~₹200 |
| **Total** | | | **₹12,000-22,000/mo** |

### Large Scale (10K-100K users)
| Service | Provider | Plan | Cost/mo |
|---------|----------|------|---------|
| Backend hosting | AWS Mumbai (ECS) | t3.medium+ | ~₹8,000-15,000 |
| Database | RDS PostgreSQL | db.t3.medium | ~₹6,000 |
| AI API (Claude) | Anthropic | Batch + caching | ~₹25,000-80,000 |
| CDN + WAF | Cloudflare Pro | | ~₹1,500 |
| Redis | ElastiCache | cache.t3.micro | ~₹2,500 |
| Monitoring | Grafana Cloud | Free tier | ₹0 |
| **Total** | | | **₹43,000-1,05,000/mo** |
```

### Step 5: Phased Execution Plan

The agent generates phases that chain directly into ECC commands:

```markdown
## Execution Phases

### Phase 0: Foundation (Day 1)
> Run: `/plan` with the structured requirements above
- Project scaffolding (Django + Next.js)
- Database schema design
- Authentication setup
- **Exit criteria**: Can register, login, see empty dashboard

### Phase 1: Core Feature - AI Resume Parsing (Days 2-4)
> Run: `/tdd` for backend, then `/code-review`
- Resume upload endpoint
- PDF text extraction
- Claude API integration for structured parsing
- Store parsed data in PostgreSQL
- **Exit criteria**: Upload PDF → get structured JSON back

### Phase 2: Job Posting & Matching (Days 5-7)
> Run: `/tdd` for matching algorithm, then `/code-review`
- Job CRUD for companies
- Embedding generation (pgvector)
- AI matching + scoring
- **Exit criteria**: Post job → see ranked candidates with scores

### Phase 3: Chat & Real-time (Days 8-9)
> Run: `/tdd` then `/e2e` for chat flows
- Supabase Realtime integration
- Chat UI components
- Notification system
- **Exit criteria**: Recruiter can message candidate in real-time

### Phase 4: Polish & Deploy (Days 10-12)
> Run: `/build-fix`, `/e2e`, then `/verify`
- Mobile responsiveness
- Error handling & edge cases
- Docker containerization
- Deploy to Railway/AWS Mumbai
- **Exit criteria**: Live URL, all E2E tests pass

### Phase 5: Production Hardening
> Run: `/code-review` + security-reviewer agent
- Rate limiting
- Input validation
- Security audit
- Monitoring setup
- **Exit criteria**: Security scan clean, monitoring active
```

## Example Usage

```
User: /brain-dump

ok so i want to make a tool where freelancers can track their invoices
and clients and it should automatically generate invoices as pdf
and maybe send them via email and also track which invoices are paid
or pending and show some analytics like monthly revenue and top clients
and it should be cheap to run because im just starting out

Agent:
[Parses transcript]
[Recommends: FastAPI + Next.js + Supabase (lightest stack for solo dev)]
[Estimates: ₹400-2,500/mo at small scale]
[Generates 4-phase plan with /tdd → /code-review → /e2e → /verify chain]
```

## Integration with ECC Workflow

This command orchestrates the complete ECC pipeline:

```
/brain-dump (this command)
    ↓ extracts requirements
    ↓ recommends stack + estimates cost
    ↓ generates phased plan
    ↓
/plan (refine each phase)
    ↓
/tdd (implement with tests first)
    ↓
/code-review (review implementation)
    ↓
/build-fix (fix any build errors)
    ↓
/e2e (end-to-end tests)
    ↓
/verify (final verification)
```

## Voice-to-Text Setup

Use any free voice app on your phone to transcribe, then paste:

| Platform | App | Cost |
|----------|-----|------|
| Android | Google Recorder / Otter.ai | Free |
| iOS | Voice Memos + Live Transcription | Free |
| Any | WhatsApp voice → transcribe | Free |
| Any | Whisper (OpenAI) via app | Free |

**Pro tip**: Just open Google Docs on your phone, tap the microphone icon, and talk. Copy-paste the text into Claude.

## Related

- `/plan` - Detailed implementation planning
- `/tdd` - Test-driven development
- `/blueprint` - Multi-session project planning
- `cost-aware-llm-pipeline` skill - Optimize AI API costs
- `app-inception` agent - Powers this command
