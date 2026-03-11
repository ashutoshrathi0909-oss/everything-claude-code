---
description: Paste a voice transcript or messy brain dump about an app idea. Get a 10-stage pocket guide from idea to paid users — with stack pick, INR costs, and what to do at each stage.
---

# /brain-dump — Voice Idea to Live App in 10 Stages

Open your phone voice app, dump your brain, paste here. Claude handles the rest.

## Your Business Model

You build apps for **exclusive clients**. Each client gets a private link, pays monthly, and when payment stops — access stops. Your pricing covers all infra costs + your profit.

```
You build it → Client gets link → Client pays via Razorpay → App works
                                   Payment stops → "Renew" page shown
```

---

## The 10 Stages

### Stage 1: Brain Dump
**What**: Open Google Docs on phone → tap mic → talk about your app idea → copy-paste here
**You say**: Everything in your head — messy is fine
**Claude does**: Nothing yet, just receives your words

> **Tip**: Don't filter yourself. Say "maybe", "also", "oh and" — Claude will sort it.

---

### Stage 2: Requirements Extraction
**What**: Claude cleans your transcript and extracts structure
**You get**:
- Core features (must-have) vs nice-to-have
- User roles (who uses this, what can they do)
- Technical signals (AI, file uploads, payments, real-time, etc.)
- Questions about anything unclear

**You do**: Confirm or correct. Takes 2 minutes.

---

### Stage 3: Stack Selection
**What**: Claude picks the best tech stack for YOUR app
**Based on**:
- What features you need (AI? real-time? file uploads?)
- Which stack has the most ECC skill coverage (= better Claude guidance)
- Indian hiring pool (if you ever need help)
- Cost at your scale

**You get**: Recommended stack + one alternative with trade-offs

> **Your model note**: All stacks include Razorpay + access-gating middleware for your pay-to-access model.

---

### Stage 4: Cost Estimation (INR)
**What**: Monthly production cost breakdown in Rupees
**You get**:
- Per-service cost (hosting, database, AI API, domain, email)
- Three tiers: Prototype (free-₹500), Small (₹2,500-5,500), Medium (₹12,000-22,000)
- AI cost optimization tips (Haiku-first routing saves 60-70%)
- **Pricing formula**: What to charge your client so their payment covers infra + your margin

**Example**:
```
Your cost per client:  ~₹3,400/mo
You charge client:     ₹6,000-8,000/mo
Your profit:           ₹2,600-4,600/mo per client
```

---

### Stage 5: Plan → `/plan`
**What**: Turn requirements into a step-by-step build plan
**ECC command**: `/plan`
**You get**:
- Database schema design
- API endpoints list
- Component breakdown
- Phase-by-phase build order
- Risk assessment

**You do**: Review the plan, say "proceed" or "modify X"

> **Your model note**: Plan includes `subscription` table, Razorpay webhook endpoint, and access-check middleware from the start.

---

### Stage 6: Build with TDD → `/tdd`
**What**: Write tests first, then code — for each feature
**ECC command**: `/tdd`
**How it works**:
- Claude writes a failing test for the feature
- Claude writes minimal code to pass the test
- Claude refactors
- Repeat for next feature
- Target: 80%+ test coverage

**You do**: Watch, approve, or redirect. Each feature takes 15-60 mins with Claude.

---

### Stage 7: Code Review → `/code-review`
**What**: Claude reviews its own code for quality, security, performance
**ECC command**: `/code-review`
**Catches**:
- Security issues (SQL injection, XSS, exposed secrets)
- Performance problems (N+1 queries, missing indexes)
- Code quality (naming, structure, duplication)

**You do**: Review the findings, approve fixes.

---

### Stage 8: E2E Testing → `/e2e`
**What**: Test the app like a real user would
**ECC command**: `/e2e`
**Tests**:
- Client signs up → pays → gets access → uses app
- Client's payment expires → sees "renew" page
- Core features work end-to-end
- Mobile responsiveness

**You do**: Verify the tests match your expected user flows.

---

### Stage 9: Deploy → `/verify`
**What**: Put it live on the internet
**ECC command**: `/build-fix` (if errors) → `/verify`
**Steps**:
- Docker containerization
- Deploy to Railway / AWS Mumbai
- Connect custom domain
- SSL certificate (free via Let's Encrypt)
- Set up Razorpay webhooks for live payments

**You get**: A live URL you can share with your first client.

---

### Stage 10: Harden + Monitor
**What**: Make it production-safe and track everything
**ECC agent**: `security-reviewer`
**Includes**:
- Rate limiting (prevent abuse)
- Input validation (prevent attacks)
- Error monitoring (know when things break)
- Usage tracking per client (know your real cost per client)
- Auto-alerts if a client's usage spikes

**You do**: Run security scan, set up alerts, then hand the link to your client.

---

## Quick Reference Card

```
Stage  What               Command/Agent         Time
─────  ─────────────────  ────────────────────  ──────
  1    Brain Dump         (voice app → paste)   5 min
  2    Requirements       (Claude parses)       5 min
  3    Stack Pick         (Claude recommends)   2 min
  4    Cost Estimate      (Claude calculates)   2 min
  5    Plan               /plan                 15 min
  6    Build              /tdd                  2-5 days
  7    Code Review        /code-review          30 min
  8    E2E Tests          /e2e                  1-2 hrs
  9    Deploy             /verify               1-2 hrs
 10    Harden             security-reviewer     1-2 hrs
```

**Total**: From brain dump to live app with paying client = ~1-2 weeks with Claude Code

---

## Voice-to-Text (Free)

| Method | How |
|--------|-----|
| **Simplest** | Google Docs on phone → tap mic → talk → copy text |
| **Android** | Google Recorder (free, offline, Hindi + English) |
| **iOS** | Voice Memos + Live Transcription (iOS 17+) |
| **Hinglish** | Google voice typing handles mixed Hindi-English well |

---

## Your Pricing Cheat Sheet

| App Complexity | Your Infra Cost | Charge Client | Your Profit |
|---------------|----------------|---------------|-------------|
| Simple (no AI) | ₹400-1,000/mo | ₹2,000-3,000/mo | ₹1,000-2,000 |
| AI-powered (Haiku) | ₹3,000-5,500/mo | ₹6,000-8,000/mo | ₹2,500-4,500 |
| AI-heavy (Sonnet mix) | ₹8,000-15,000/mo | ₹15,000-25,000/mo | ₹7,000-10,000 |

> Rule of thumb: Charge 2-3x your infra cost. The AI API is always your biggest expense — use `cost-aware-llm-pipeline` skill to keep it down.

---

## Related Commands

| Command | When to Use |
|---------|------------|
| `/plan` | Stage 5 — detailed planning |
| `/tdd` | Stage 6 — test-driven building |
| `/code-review` | Stage 7 — quality check |
| `/e2e` | Stage 8 — end-to-end tests |
| `/build-fix` | Stage 9 — fix deploy errors |
| `/verify` | Stage 9 — final verification |
