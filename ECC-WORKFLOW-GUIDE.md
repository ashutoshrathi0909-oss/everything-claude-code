# The Complete ECC Workflow — From Idea to Delivery

> A comprehensive guide showing exactly what fires under the hood at every stage of the Everything Claude Code (ECC) development lifecycle.

---

## The Scenario

You're building **"TaskFlow"** — a full-stack task management app with real-time collaboration.

**Tech stack:** Next.js frontend, Node.js/Express backend, PostgreSQL database, deployed via Docker.

You open VS Code, open the terminal, and type `claude` to start a Claude Code session.

---

## Table of Contents

1. [Stage 0: Session Initialization](#stage-0-session-initialization-automatic)
2. [Stage 1: Research & Discovery](#stage-1-research--discovery)
3. [Stage 2: Planning (`/plan`)](#stage-2-planning-plan)
4. [Stage 3: Project Scaffolding](#stage-3-project-scaffolding)
5. [Stage 4: Test-Driven Development (`/tdd`)](#stage-4-test-driven-development-tdd)
6. [Stage 5: Implementation (Feature by Feature)](#stage-5-implementation-feature-by-feature)
7. [Stage 6: Code Review (`/code-review`)](#stage-6-code-review-code-review)
8. [Stage 7: Database Work](#stage-7-database-work)
9. [Stage 8: Frontend Development](#stage-8-frontend-development)
10. [Stage 9: Continuous Quality Gates (`/quality-gate`)](#stage-9-continuous-quality-gates-quality-gate)
11. [Stage 10: Session Management](#stage-10-session-management)
12. [Stage 11: Learning & Pattern Extraction (`/learn`)](#stage-11-learning--pattern-extraction-learn)
13. [Stage 12: Advanced Multi-Agent Workflows](#stage-12-advanced-multi-agent-workflows)
14. [Stage 13: Deployment](#stage-13-deployment-build-fix-if-needed)
15. [Stage 14: Documentation](#stage-14-documentation-update-docs)
16. [Stage 15: Final Verification (`/verify`)](#stage-15-final-verification-verify)
17. [Stage 16: Git & PR Workflow](#stage-16-git--pr-workflow)
18. [Complete Lifecycle Map](#the-complete-picture)
19. [The Anti-Slop Guarantee](#the-anti-slop-guarantee)

---

## Stage 0: Session Initialization (Automatic)

**What happens the moment you type `claude`:**

Hooks fire automatically before you even type anything.

### Hooks That Fire

| Hook | What It Does |
|------|-------------|
| `session-start` hook | Reads your `~/.claude/rules/` directory. Loads ALL your rules (common, typescript, python). These become Claude's "always follow" instructions for the entire session. |
| `PreToolUse` hooks | Register themselves to intercept every tool call Claude makes. Before Claude writes a file, the hook can validate it. Before Claude runs a bash command, it can check for dangerous operations. |
| `PostToolUse` hooks | Register to run AFTER tool calls. Auto-formatting code after edits. Running linters after file writes. |

### Rules That Load

From `~/.claude/rules/common/`:

| Rule File | What It Enforces |
|-----------|-----------------|
| `security.md` | Check for hardcoded secrets, SQL injection, XSS on every piece of code |
| `coding-style.md` | Immutability enforced. Small files. No deep nesting. Error handling required |
| `testing.md` | 80% coverage minimum. TDD mandatory |
| `performance.md` | Model routing strategy. Context window management |
| `agents.md` | All 17 agents and when to deploy each one |
| `development-workflow.md` | Full pipeline: research -> plan -> TDD -> review -> commit |
| `git-workflow.md` | Commit message format, PR workflow |
| `hooks.md` | TodoWrite best practices, auto-accept permissions guidance |
| `patterns.md` | Repository pattern, API response format, skeleton project approach |

> **What you see:** Just the Claude Code prompt. But behind the scenes, Claude is now operating with ~10 rule files loaded as permanent instructions. Every response it gives will be filtered through these rules.

---

## Stage 1: Research & Discovery

**You type:**
```
I want to build TaskFlow — a real-time collaborative task management app
with Next.js, Express, PostgreSQL, and Docker. Help me plan this.
```

### What Claude Does Internally

Claude's `development-workflow.md` rule says: *"Research & Reuse is MANDATORY before any new implementation."* So before writing a single line of planning, Claude activates:

| Skill | What It Provides |
|-------|-----------------|
| `search-first` | Research-before-coding workflow. Runs `gh search repos`, searches npm for battle-tested libraries |
| `api-design` | REST API design patterns — resource naming, status codes, pagination, error formats |
| `frontend-patterns` | React/Next.js architecture patterns — state management, component composition, performance |
| `backend-patterns` | Express/Node.js patterns — layered architecture, middleware, database optimization |
| `postgres-patterns` | PostgreSQL-specific patterns — indexing, query optimization, schema design |
| `docker-patterns` | Docker Compose patterns for local dev, container security, networking, volumes |

> **What you see:** Claude reports back with findings — existing templates it found, recommended libraries, architectural options. It asks clarifying questions before moving to planning.

---

## Stage 2: Planning (`/plan`)

**You type:**
```
/plan
```

### What Fires

#### Agent: `planner`
The planner agent is spawned as a subagent. It has access to `Read`, `Grep`, `Glob` tools but **NOT** `Edit` or `Write` — it can only research and think, not modify code. This is intentional: planning should be pure analysis.

The planner agent:
1. Restates your requirements back to you (to verify understanding)
2. Assesses risks — what could go wrong?
3. Creates a step-by-step implementation plan organized into phases
4. Enters Plan Mode — writes the plan and calls `ExitPlanMode`

#### Skill: `blueprint`
Turns your one-line objective into a structured construction plan. Generates:
- PRD (Product Requirements Document)
- Architecture document
- System design
- Tech doc
- Task list broken into phases

#### Agent: `architect` (spawned in parallel)
Handles system design decisions:
- WebSockets vs Server-Sent Events for real-time?
- Monorepo or separate repos?
- Auth strategy (JWT, sessions, OAuth)?
- Database schema design

### What You See

```
Phase 1: Foundation (Days 1-2)
  ├── Project scaffolding (Next.js + Express monorepo)
  ├── Database schema design (users, tasks, boards, comments)
  ├── Docker Compose setup (postgres, redis, app)
  └── CI pipeline skeleton

Phase 2: Core API (Days 3-5)
  ├── Auth endpoints (register, login, refresh)
  ├── Task CRUD endpoints
  ├── Board management endpoints
  └── Database migrations

Phase 3: Real-time Layer (Days 6-7)
  ├── WebSocket server setup
  ├── Event broadcasting (task updates, comments)
  └── Presence indicators

Phase 4: Frontend (Days 8-12)
  ├── Auth pages (login, register)
  ├── Dashboard with board list
  ├── Kanban board with drag-and-drop
  ├── Real-time sync integration
  └── Task detail modal

Phase 5: Polish & Deploy (Days 13-15)
  ├── E2E tests for critical flows
  ├── Docker production build
  ├── Error handling & loading states
  └── Documentation
```

> **CRITICAL:** Claude **WAITS** here. The plan command explicitly says *"WAIT for user CONFIRMATION before writing any code."* You review, suggest changes, and approve.

#### TodoWrite Tool
Claude creates a todo list tracking every phase and task. This is visible in your VS Code status bar. As work progresses, items move from `pending` -> `in_progress` -> `completed`.

---

## Stage 3: Project Scaffolding

You approve the plan. Claude begins Phase 1.

### Skills Active

| Skill | What It Does |
|-------|-------------|
| `coding-standards` | TypeScript strict mode, ESLint + Prettier, import ordering, naming conventions |
| `docker-patterns` | Multi-stage builds, named volumes, health checks, env var management |
| `database-migrations` | Reversible migrations, zero-downtime patterns, seed data setup |

### Hooks Active

| Hook | When | What |
|------|------|------|
| `PostToolUse` | After file writes | Auto-format (prettier/eslint --fix), validate structure, security check |

### Rules Enforced

- **`coding-style.md`:** Files under 800 lines. Functions under 50 lines. No deep nesting.
- **`security.md`:** No hardcoded secrets. Environment variables for all config.
- **`patterns.md`:** Repository pattern for data access. Consistent API response envelope.

---

## Stage 4: Test-Driven Development (`/tdd`)

**You type:**
```
/tdd
```

### Agent: `tdd-guide`

Enforces a strict **RED -> GREEN -> REFACTOR** cycle:

#### Step 1: RED (Write failing tests)

Claude writes tests **FIRST**, before any implementation:

```
TaskService.test.ts
├── should create a task with valid data
├── should reject task without title
├── should assign task to user
├── should update task status
├── should soft-delete task
└── should list tasks with pagination
```

Claude runs the tests — they all **FAIL**. This is expected and required. The tdd-guide agent verifies the tests actually fail.

#### Step 2: GREEN (Minimal implementation)

Claude writes the **MINIMUM** code needed to make tests pass. Not elegant. Not complete. Just enough to turn red tests green.

#### Step 3: REFACTOR (Improve)

Now Claude refactors — extracting utilities, improving naming, adding proper error handling — while keeping all tests green.

### Skills Used During TDD

| Skill | What It Provides |
|-------|-----------------|
| `tdd-workflow` | Core TDD methodology, test scaffolding patterns |
| `backend-patterns` | Service layer patterns, middleware patterns |
| `api-design` | Endpoint naming, status codes, error format |
| `postgres-patterns` | Query patterns, transaction handling |
| `security-review` | Input validation patterns, auth checks |

### Hooks Active

| Hook | When | What |
|------|------|------|
| `PreToolUse` | Before running tests | Verify test file exists, check isolation, ensure no external state dependency |

### Rules Enforced

- **`testing.md`:** 80% coverage minimum. All three test types required (unit, integration, E2E).
- **`coding-style.md`:** Immutable data patterns. No mutation.
- **`security.md`:** Input validation at system boundaries. Parameterized queries.

---

## Stage 5: Implementation (Feature by Feature)

For each feature in the plan, Claude follows the same cycle. Here's the **Auth Module** as an example:

### Multi-Model Routing (`/model-route`)

The `cost-aware-llm-pipeline` skill activates:

| Task | Model | Why |
|------|-------|-----|
| Auth architecture decisions | **Opus** (deepest reasoning) | Security-critical, needs thorough analysis |
| Writing auth middleware | **Sonnet** (best coding) | Complex but well-defined coding task |
| Writing test boilerplate | **Haiku** (fast, cheap) | Repetitive, template-based work |

### Parallel Agent Execution

Claude's `agents.md` rule says: *"ALWAYS use parallel execution for independent operations."*

```
Launched in parallel:
├── Agent 1 (security-reviewer): Analyzing auth flow for vulnerabilities
├── Agent 2 (tdd-guide): Writing auth tests
└── Agent 3 (architect): Designing token refresh strategy
```

All three run simultaneously. Results are merged.

### Skill: `security-review`

For auth specifically, comprehensive checks:
- Password hashing (bcrypt, not MD5)
- JWT token expiry and refresh rotation
- Rate limiting on login endpoints
- CSRF protection
- Session fixation prevention

---

## Stage 6: Code Review (`/code-review`)

**You type:**
```
/code-review
```

### Agent: `code-reviewer`

Reviews all changed files with a structured rubric:

| Category | Examples |
|----------|---------|
| **Security** | SQL injection, XSS, hardcoded secrets, missing auth checks |
| **Quality** | Code duplication, function length, naming clarity |
| **Performance** | N+1 queries, missing indexes, unnecessary re-renders |
| **Correctness** | Edge cases, error handling, race conditions |
| **Style** | Consistent patterns, immutability, file organization |

### Issue Severity

| Level | Action |
|-------|--------|
| **CRITICAL** | Must fix before commit (security vulnerabilities, data loss risks) |
| **HIGH** | Should fix before commit (bugs, significant performance issues) |
| **MEDIUM** | Fix when possible (code smells, minor improvements) |
| **LOW** | Nice to have (style preferences, minor optimizations) |

### Agent: `security-reviewer` (spawned in parallel)

For code touching auth, user input, or API endpoints:
- OWASP Top 10 vulnerability scan
- Secrets detection
- Input validation verification
- Authorization check verification

> **What you see:** A structured report with findings, severity levels, and suggested fixes. Claude fixes CRITICAL and HIGH issues automatically, asks about MEDIUM issues.

---

## Stage 7: Database Work

### Skill: `postgres-patterns`
- Proper indexing strategies (B-tree vs GIN vs GiST)
- Query optimization (`EXPLAIN ANALYZE` patterns)
- Connection pooling configuration
- Row-level security policies

### Skill: `database-migrations`
- Reversible migrations with up/down
- Zero-downtime migration patterns (add column -> backfill -> add constraint)
- Seed data management

### Agent: `database-reviewer`
- Schema design (normalization, denormalization trade-offs)
- Query performance
- Index coverage
- Security (RLS policies, grants)

---

## Stage 8: Frontend Development

### Skill: `frontend-patterns`
- React component composition
- State management (Context, Zustand, or Redux based on complexity)
- Performance optimization (`React.memo`, `useMemo`, `useCallback`)
- Accessibility patterns

### Skill: `coding-standards`

TypeScript-specific standards:
- Strict mode enabled
- Proper type definitions (no `any`)
- Interface over type for public APIs
- Discriminated unions for state machines

### Agent: `e2e-runner`

Generates Playwright tests for critical user flows:
- Login -> Create Board -> Add Task -> Drag to Done -> Logout
- Real-time: User A creates task -> User B sees it appear

### Skill: `e2e-testing`

Playwright patterns:
- Page Object Model
- Test isolation
- Artifact management (screenshots, videos, traces)
- CI/CD integration

---

## Stage 9: Continuous Quality Gates (`/quality-gate`)

**You type:**
```
/quality-gate
```

### Checks Run

| Check | Pass Criteria |
|-------|--------------|
| Build | `npm run build` succeeds with zero errors |
| Lint | Zero ESLint errors, zero warnings |
| Type Check | `tsc --noEmit` passes |
| Unit Tests | All pass, 80%+ coverage |
| Integration Tests | All pass |
| E2E Tests | Critical flows pass |
| Security Scan | Zero CRITICAL/HIGH findings |
| Bundle Size | Under configured threshold |

### Skills Active

| Skill | What It Does |
|-------|-------------|
| `verification-loop` | Iterative verification — fix and re-run until green |
| `plankton-code-quality` | Write-time enforcement — auto-formatting, linting, Claude-powered fixes |

---

## Stage 10: Session Management

### Mid-Session: `/checkpoint`

Creates a snapshot of your current progress. If VS Code crashes or you need to context-switch, you don't lose your place.

### End of Day: `/save-session`

Saves the full session state to `~/.claude/sessions/` with:
- What was accomplished
- What's in progress
- What's remaining
- Full context of decisions made

### Next Morning: `/resume-session`

Loads the saved session. Claude picks up exactly where you left off — with full context.

### What Powers This

| Component | What It Does |
|-----------|-------------|
| Skill: `strategic-compact` | Suggests context compaction at logical intervals. When 80% through the context window, Claude intelligently summarizes completed work and preserves what matters. |
| Hook: `Stop` hook | When a session ends, auto-saves state and runs final verification. |

---

## Stage 11: Learning & Pattern Extraction (`/learn`)

**You type:**
```
/learn
```

### Skill: `continuous-learning`

Claude analyzes the entire session and extracts reusable patterns:
- "We used a specific WebSocket event pattern for real-time updates — save this"
- "The auth middleware pattern worked well — extract as a skill"
- "The Prisma schema pattern for soft deletes was useful — save this"

### Skill: `continuous-learning-v2` (Instinct System)

Creates **atomic instincts** — small, focused learnings with confidence scores:

```
Instinct: "Use discriminated unions for task status"
Confidence: 0.85
Context: TypeScript, state machines
Source: TaskFlow session, 2026-03-11
```

These instincts are saved and loaded in future sessions. Over time, Claude gets better at YOUR specific patterns.

### Related Commands

| Command | Purpose |
|---------|---------|
| `/instinct-status` | See all learned instincts with confidence levels |
| `/instinct-export` | Export instincts to share with team |
| `/instinct-import` | Import instincts from a teammate or URL |
| `/promote` | Promote project-specific instincts to global (all projects) |
| `/learn-eval` | Extract patterns WITH self-evaluation quality check |

---

## Stage 12: Advanced Multi-Agent Workflows

### `/multi-plan` — Collaborative Planning

Spawns multiple agents with different perspectives:
- **Factual reviewer** — Checks feasibility
- **Senior engineer** — Evaluates architecture
- **Security expert** — Identifies risks
- **Consistency reviewer** — Checks against existing patterns

### `/multi-execute` — Collaborative Execution

Multiple agents work on different parts simultaneously:
- Agent 1 works on the API endpoint
- Agent 2 works on the database migration
- Agent 3 works on the frontend component
- Agent 4 writes the tests

### `/orchestrate` — Complex Workflow Orchestration

For multi-step workflows that need coordination:

```
Build the feature -> Run tests -> Review code -> Fix issues -> Re-test -> Commit
```

### `/loop-start` — Autonomous Agent Loop

For long-running tasks:
- Claude works through a task list independently
- Quality gates prevent bad code from accumulating
- `/loop-status` lets you check progress

### Skill: `autonomous-loops`

Patterns for safe autonomous execution:
- Recovery controls (what to do when stuck)
- Quality gates between iterations
- Human checkpoint intervals

---

## Stage 13: Deployment (`/build-fix` if needed)

### Skill: `deployment-patterns`
- Docker production builds (multi-stage, minimal images)
- CI/CD pipeline configuration
- Health checks and readiness probes
- Rollback strategies

### Skill: `docker-patterns`
- Production-optimized Dockerfiles
- Docker Compose for staging environments
- Container security hardening

### Agent: `build-error-resolver`

If the production build fails:
1. Analyzes error messages
2. Fixes incrementally (one error at a time)
3. Verifies after each fix
4. Doesn't change architecture — just gets the build green

### Command: `/build-fix`

Shortcut to invoke the build-error-resolver when things break.

---

## Stage 14: Documentation (`/update-docs`)

### Agent: `doc-updater`

Generates/updates:
- API documentation
- README with setup instructions
- Architecture decision records
- Code maps (visual overview of the codebase)

### Command: `/update-codemaps`

Generates visual code maps showing how modules connect.

---

## Stage 15: Final Verification (`/verify`)

**You type:**
```
/verify
```

Runs the **FULL** verification loop:

1. Build passes
2. All tests pass (unit + integration + E2E)
3. Coverage meets 80%+ threshold
4. Security scan clean
5. Lint clean
6. Type check clean
7. No TODO/FIXME left unaddressed
8. Documentation up to date

### Hook: `Stop` Hook

When you end the session, the Stop hook runs final verification automatically — catching anything you might have missed.

---

## Stage 16: Git & PR Workflow

### Rules: `git-workflow.md`

Claude follows conventional commits:

```
feat: add real-time task synchronization via WebSocket
fix: resolve race condition in concurrent task updates
test: add E2E tests for kanban drag-and-drop flow
```

### What Claude Does for PRs

1. Analyzes the **FULL** diff (`git diff main...HEAD`)
2. Reviews **ALL** commits (not just the latest)
3. Drafts a PR with:
   - Summary (what changed and why)
   - Test plan (what was tested and how)
   - Screenshots if UI changed

---

## The Complete Picture

Every component mapped to the development lifecycle:

```
STAGE               COMMANDS          AGENTS                SKILLS                      HOOKS
─────────────────────────────────────────────────────────────────────────────────────────────────
Session Start       (auto)            —                     —                           session-start
                                                                                        PreToolUse register
                                                                                        PostToolUse register

Research            —                 architect             search-first                —
                                                            api-design
                                                            frontend-patterns
                                                            backend-patterns

Planning            /plan             planner               blueprint                   —
                                      architect             cost-aware-llm-pipeline

Scaffolding         —                 —                     coding-standards             PostToolUse (format)
                                                            docker-patterns
                                                            database-migrations

TDD Loop            /tdd              tdd-guide             tdd-workflow                 PreToolUse (validate)
                                                            python-testing               PostToolUse (lint)
                                                            e2e-testing

Implementation      /model-route      security-reviewer     security-review              PreToolUse (security)
                                      code-reviewer         postgres-patterns            PostToolUse (format)
                                      database-reviewer     frontend-patterns

Code Review         /code-review      code-reviewer         coding-standards             —
                                      security-reviewer     security-review

Quality Gate        /quality-gate     build-error-resolver  verification-loop            —
                    /verify                                 plankton-code-quality

Session Mgmt        /checkpoint       —                     strategic-compact            Stop hook
                    /save-session                                                        (auto-save)
                    /resume-session

Learning            /learn            —                     continuous-learning          —
                    /learn-eval                             continuous-learning-v2
                    /instinct-*

Multi-Agent         /multi-plan       planner (xN)          autonomous-loops             —
                    /multi-execute    architect (xN)        ralphinho-rfc-pipeline
                    /orchestrate      code-reviewer (xN)
                    /loop-start       loop-operator

Deployment          /build-fix        build-error-resolver  deployment-patterns          —
                                                            docker-patterns

Documentation       /update-docs      doc-updater           —                            —
                    /update-codemaps

Git & PR            (git commands)    —                     —                            PreToolUse (git safety)
```

---

## The Anti-Slop Guarantee

Every layer reinforces the others:

1. **Rules** set the baseline — Claude can't ignore them
2. **Skills** provide domain expertise — Claude doesn't hallucinate patterns
3. **Agents** provide specialized review — no blind spots
4. **Commands** give you control — you decide when each phase runs
5. **Hooks** automate quality — things happen even when you forget
6. **Instincts** improve over time — Claude learns YOUR preferences

This is why it produces production-quality code instead of AI slop. There's no single magic trick — it's **17 agents, 43 commands, 81 skills, and hooks** all working together as a system.

---

> **Generated from the Everything Claude Code project**
> **Date:** 2026-03-15
