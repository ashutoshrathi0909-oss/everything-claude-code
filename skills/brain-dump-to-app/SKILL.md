---
name: brain-dump-to-app
description: >-
  Transform raw voice transcripts or unstructured brain dumps into production-ready
  app development plans. Parses messy input, recommends optimal tech stack based on
  ECC skill coverage, estimates Indian production costs, and generates phased execution
  plans that chain into existing ECC commands (/plan, /tdd, /code-review, /e2e, /verify).
  TRIGGER when: user pastes a voice transcript, messy app idea, or uses /brain-dump.
  DO NOT TRIGGER when: user has clear requirements already, or is mid-implementation.
origin: ECC
---

# Brain Dump to App

Transform messy voice transcripts into structured, costed, phased app development plans.

## When to Activate

- User pastes a voice transcript or unstructured text about an app idea
- User says "I want to build..." followed by stream-of-consciousness description
- User uses `/brain-dump` command
- User asks "how much will it cost to build X in India?"

## Phase 1: Parse the Brain Dump

### Transcript Cleaning Rules

Voice transcripts are messy. Apply these transformations:

1. **Remove filler words**: "um", "uh", "like", "you know", "basically", "so yeah"
2. **Split run-on sentences**: Break at natural pauses (commas, "and then", "also")
3. **Detect feature boundaries**: New features usually start with "and also", "oh and", "maybe", "it should"
4. **Separate must-haves from nice-to-haves**: Words like "maybe", "possibly", "would be cool if" = nice-to-have
5. **Identify user roles**: "people can", "companies can", "admin should" = distinct roles
6. **Detect technical signals**: Keywords that imply specific tech needs

### Technical Signal Detection

| Signal in Transcript | Technical Implication | ECC Skill |
|---------------------|----------------------|-----------|
| "upload", "file", "pdf", "image" | File storage, processing | backend-patterns |
| "ai", "smart", "automatically", "generate" | LLM integration | cost-aware-llm-pipeline, claude-api |
| "chat", "real-time", "live", "instant" | WebSocket/SSE | frontend-patterns |
| "login", "users", "account" | Authentication | django-security / springboot-security |
| "pay", "subscribe", "billing" | Payment integration | api-design |
| "mobile", "phone", "app" | Responsive or native | frontend-patterns |
| "dashboard", "analytics", "chart" | Data visualization | frontend-patterns, postgres-patterns |
| "email", "notify", "alert" | Notification system | backend-patterns |
| "search", "find", "filter" | Search infrastructure | postgres-patterns |
| "api", "integrate", "webhook" | External integrations | api-design |
| "schedule", "cron", "periodic" | Background jobs | backend-patterns, docker-patterns |
| "multi-tenant", "company", "organization" | Multi-tenancy | django-patterns |

### Output Format

```markdown
## Extracted Requirements

### App Name Suggestion
[Infer from context]

### One-Line Description
[What it does in one sentence]

### Core Features (Must Have)
1. [Feature with clear scope]
2. [Feature with clear scope]

### Nice to Have
1. [Feature marked as optional]

### User Roles
- [Role]: [What they can do]

### Technical Signals
- [Signal]: [Implication]

### Ambiguities to Clarify
- [Question about unclear requirement]
```

## Phase 2: Stack Recommendation Engine

### Decision Matrix

Score each stack option across these dimensions:

| Dimension | Weight | How to Score |
|-----------|--------|-------------|
| ECC Skill Coverage | 30% | Count of matching ECC skills (more = better guidance) |
| App Fit | 25% | How well the framework suits the detected features |
| Ecosystem (India) | 15% | Hiring availability, community size in India |
| Cost Efficiency | 15% | Hosting costs for the target scale |
| Speed to MVP | 15% | Time to first working version |

### Stack Profiles

#### Profile A: Django + Next.js + PostgreSQL (Full-Stack AI App)

**ECC Coverage Score: 9.5/10** (highest)

Best when:
- Multi-tenant SaaS
- AI-heavy features (LLM integration)
- Admin panel needed
- Complex data models
- Authentication + authorization

ECC skills available: `django-patterns`, `django-security`, `django-tdd`, `django-verification`, `python-patterns`, `python-testing`, `frontend-patterns`, `postgres-patterns`, `cost-aware-llm-pipeline`, `claude-api`, `api-design`, `docker-patterns`, `deployment-patterns`, `e2e-testing`

Indian ecosystem: Django is the #1 Python web framework in India. Huge talent pool. FastAPI growing but Django still dominates job market.

#### Profile B: FastAPI + Next.js + PostgreSQL (Lightweight AI API)

**ECC Coverage Score: 7/10**

Best when:
- API-first product
- Heavy async/streaming (AI responses)
- Microservice architecture
- Real-time features are core
- Solo developer / small team

ECC skills available: `python-patterns`, `python-testing`, `frontend-patterns`, `postgres-patterns`, `cost-aware-llm-pipeline`, `claude-api`, `api-design`, `docker-patterns`

Indian ecosystem: FastAPI growing fast in Indian startups. Good for AI-first products.

#### Profile C: Spring Boot + React + PostgreSQL (Enterprise)

**ECC Coverage Score: 8/10**

Best when:
- Enterprise or B2B product
- High throughput required
- Complex business logic
- Team knows Java/Kotlin
- Microservice architecture planned

ECC skills available: `springboot-patterns`, `springboot-security`, `springboot-tdd`, `springboot-verification`, `jpa-patterns`, `frontend-patterns`, `postgres-patterns`, `api-design`, `docker-patterns`

Indian ecosystem: Java/Spring is still the #1 enterprise stack in India. Massive talent pool. Best for B2B.

#### Profile D: Next.js Full-Stack (TypeScript Monolith)

**ECC Coverage Score: 6.5/10**

Best when:
- Solo developer
- Content-heavy site with some dynamic features
- Quick MVP needed
- Team is frontend-heavy
- Simple data model

ECC skills available: `frontend-patterns`, `coding-standards`, `backend-patterns`, `postgres-patterns`, `api-design`, `e2e-testing`

Indian ecosystem: Growing fast. MERN/Next.js is the most popular bootcamp stack in India.

#### Profile E: Go + Next.js + PostgreSQL (Performance-Critical)

**ECC Coverage Score: 6/10**

Best when:
- High concurrency (100K+ simultaneous users)
- Low latency is critical
- Infrastructure/platform tool
- CLI or developer tool

ECC skills available: `golang-patterns`, `golang-testing`, `frontend-patterns`, `postgres-patterns`, `api-design`, `docker-patterns`

Indian ecosystem: Growing in Indian tech companies. Good for infra teams. Smaller hiring pool than Python/Java.

### Recommendation Output Format

```markdown
## Stack Recommendation

### Recommended: [Profile Name]
**Why**: [1-2 sentences based on detected features]

### Stack Breakdown
| Layer | Technology | ECC Skills | Rationale |
|-------|-----------|-----------|-----------|
| Backend | [Framework] | [Count] skills | [Why] |
| Frontend | [Framework] | [Count] skills | [Why] |
| Database | [DB] | [Count] skills | [Why] |
| AI | [SDK] | [Count] skills | [Why] |
| Deploy | [Platform] | [Count] skills | [Why] |

### Alternative Considered: [Profile Name]
**Trade-off**: [What you gain vs lose]
```

## Phase 3: Indian Production Cost Estimation

### Pricing Database (Updated March 2026)

All prices in INR. USD to INR rate: ~₹84.

#### Compute (Backend Hosting)

| Provider | Plan | Specs | INR/mo | Best For |
|----------|------|-------|--------|----------|
| Railway | Free | 500 hrs, 512MB | ₹0 | Prototyping |
| Railway | Starter | 8GB, $5 credits | ~₹420 | Small apps |
| Railway | Pro | Usage-based | ~₹1,500-4,000 | Medium apps |
| Render | Free | 750 hrs | ₹0 | Prototyping |
| Render | Starter | 512MB | ~₹600 | Small apps |
| AWS Mumbai (t3.micro) | On-demand | 1 vCPU, 1GB | ~₹700 | Small production |
| AWS Mumbai (t3.small) | On-demand | 2 vCPU, 2GB | ~₹1,400 | Medium production |
| AWS Mumbai (t3.medium) | On-demand | 2 vCPU, 4GB | ~₹2,800 | Larger production |
| DigitalOcean BLR | Basic | 1 vCPU, 1GB | ~₹500 | Budget production |
| Fly.io | Free | 3 shared VMs | ₹0 | Prototyping |

#### Database

| Provider | Plan | Storage | INR/mo | Best For |
|----------|------|---------|--------|----------|
| Supabase | Free | 500MB, 50K MAU | ₹0 | Prototyping + small |
| Supabase | Pro | 8GB, 100K MAU | ~₹2,100 | Medium apps |
| Neon | Free | 512MB | ₹0 | Prototyping |
| Neon | Launch | 10GB | ~₹1,600 | Small-medium |
| AWS RDS (db.t3.micro) | Mumbai | 20GB | ~₹1,200 | Small production |
| AWS RDS (db.t3.medium) | Mumbai | 100GB | ~₹6,000 | Medium production |
| PlanetScale | Free | 5GB | ₹0 | MySQL prototyping |

#### AI API Costs

| Provider | Model | Input (per 1M tokens) | Output (per 1M tokens) | INR Estimate |
|----------|-------|----------------------|----------------------|-------------|
| Anthropic | Haiku 4.5 | $0.80 | $4.00 | ₹67 / ₹336 |
| Anthropic | Sonnet 4.6 | $3.00 | $15.00 | ₹252 / ₹1,260 |
| Anthropic | Opus 4.6 | $15.00 | $75.00 | ₹1,260 / ₹6,300 |
| OpenAI | GPT-4o-mini | $0.15 | $0.60 | ₹13 / ₹50 |
| OpenAI | GPT-4o | $2.50 | $10.00 | ₹210 / ₹840 |

**Cost optimization rule**: Use `cost-aware-llm-pipeline` skill. Route 80% of calls to Haiku, 20% to Sonnet. Typical savings: 60-70%.

#### Typical Monthly AI Spend by Scale

| Scale | Calls/day | Model Mix | INR/mo |
|-------|-----------|-----------|--------|
| Prototype | 50 | 100% Haiku | ~₹200-500 |
| Small (1K users) | 500 | 80% Haiku, 20% Sonnet | ~₹2,000-5,000 |
| Medium (10K users) | 5,000 | 80% Haiku, 15% Sonnet, 5% Opus | ~₹15,000-40,000 |
| Large (100K users) | 50,000 | Batch API + caching | ~₹60,000-2,00,000 |

#### Other Services

| Service | Free Tier | Paid | INR/mo (paid) |
|---------|-----------|------|---------------|
| Vercel (frontend) | 100GB bandwidth | Pro | ~₹1,700 |
| Cloudflare CDN | Unlimited | - | ₹0 |
| Resend (email) | 3K emails/mo | - | ₹0 (small scale) |
| Upstash Redis | 10K commands/day | Pay-per-use | ~₹200-500 |
| S3 Mumbai (storage) | 5GB free tier | Pay-per-use | ~₹50-200 |
| Domain (.in) | - | Annual | ~₹600-800/yr |
| Domain (.com) | - | Annual | ~₹1,000-1,200/yr |
| SSL | Free (Let's Encrypt) | - | ₹0 |

### Cost Estimation Output Format

```markdown
## Production Costs (India)

### Your App Scale: [Small / Medium / Large]

| Category | Service | Provider | INR/mo |
|----------|---------|----------|--------|
| Compute | Backend | [Provider] | ₹X |
| Database | PostgreSQL | [Provider] | ₹X |
| AI API | Claude (Haiku-first) | Anthropic | ₹X |
| Frontend | Hosting | [Provider] | ₹X |
| Storage | Files | [Provider] | ₹X |
| Email | Transactional | [Provider] | ₹X |
| Domain | .in / .com | [Provider] | ₹X |
| **Total** | | | **₹X/mo** |

### Cost Optimization Tips
1. Use Haiku for 80% of AI calls (cost-aware-llm-pipeline)
2. Prompt caching saves 30-50% on repeated system prompts
3. Start on free tiers, upgrade only when hitting limits
4. Use Cloudflare CDN (free) to reduce bandwidth costs
5. Batch API for non-real-time processing (50% cheaper)

### Break-Even Analysis
At ₹X/mo cost, you need [Y] paying users at ₹[Z]/mo to break even.
```

## Phase 4: Phased Execution Plan

### Phase Template

Each phase maps to an ECC command sequence:

```markdown
### Phase [N]: [Name] (Day [X]-[Y])

**ECC Commands**: `/plan` → `/tdd` → `/code-review`

**What to build**:
- [Specific feature 1]
- [Specific feature 2]

**Key decisions**:
- [Decision 1 with recommendation]

**Exit criteria**:
- [ ] [Testable outcome 1]
- [ ] [Testable outcome 2]

**Cost impact**: +₹[X]/mo (adds [service])
```

### Standard Phase Sequence

Every app follows this skeleton (customize per project):

| Phase | Name | ECC Commands | What Happens |
|-------|------|-------------|-------------|
| 0 | Foundation | `/plan` | Scaffold project, DB schema, auth, CI |
| 1 | Core Feature | `/tdd` → `/code-review` | Build the #1 value proposition |
| 2 | Supporting Features | `/tdd` → `/code-review` | Build features that support the core |
| 3 | AI Integration | `/tdd` + `claude-api` skill | Connect LLM APIs with cost-aware routing |
| 4 | Frontend Polish | `/e2e` | UI/UX, responsive design, E2E tests |
| 5 | Deploy | `/build-fix` → `/verify` | Docker, CI/CD, deploy to production |
| 6 | Harden | `security-reviewer` agent | Security audit, rate limiting, monitoring |

### Phase 0 always includes:

1. `git init` + GitHub repo
2. Project scaffolding (framework-specific)
3. Database schema (PostgreSQL)
4. Authentication (JWT or session)
5. CI pipeline (GitHub Actions)
6. Docker setup (dev environment)
7. Environment variables template

## Phase 5: Interactive Guidance

After presenting the plan, guide the user through execution:

```markdown
## Ready to Start?

Your plan has [N] phases. Here's how we'll work:

1. I'll start with **Phase 0: Foundation** using `/plan`
2. After you approve the plan, I'll switch to `/tdd` mode
3. After each phase, I'll run `/code-review` automatically
4. If anything breaks, I'll use `/build-fix`
5. At the end, I'll run `/verify` for final checks

**Estimated total cost to go live**: ₹[X]/mo
**Estimated development time**: [Y] days with Claude Code

Type "start" to begin Phase 0, or ask me to modify the plan.
```

## Voice-to-Text Recommendations

Since the voice transcription happens outside Claude, recommend these free options:

### Android (India)
1. **Google Recorder** - Free, works offline, excellent Hindi + English
2. **Otter.ai** - Free tier (600 min/mo), auto-transcription
3. **Google Docs voice typing** - Open Docs, tap mic, talk, copy-paste

### iOS (India)
1. **Voice Memos + Live Transcription** (iOS 17+) - Free, on-device
2. **Google Docs voice typing** - Same as Android
3. **Otter.ai** - Free tier

### Cheapest/Simplest Method
Open Google Docs on phone → tap microphone → talk → copy text → paste into Claude Code terminal

### For Hindi/Hinglish Speakers
Google's voice typing handles Hindi and Hinglish well. Speak naturally, Claude will parse both languages.

## Anti-Patterns to Detect

When parsing brain dumps, watch for:

| Pattern | Problem | Response |
|---------|---------|----------|
| "and also X and also Y and also Z..." | Feature creep | Group into phases, push non-core to later phases |
| "it should be like [big company]" | Unrealistic scope | Extract the specific feature they mean, not the whole product |
| No mention of users/roles | Missing user model | Ask: "Who uses this? What can each type of user do?" |
| No mention of data | Missing data model | Ask: "What data does the app store? What are the main entities?" |
| "it should be fast/scalable" | Premature optimization | Start small, optimize when needed. Note it for Phase 6 |
| "maybe also blockchain/AR/ML" | Buzzword stacking | Only include if it serves a concrete user need |
