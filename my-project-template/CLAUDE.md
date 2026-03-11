# CLAUDE.md — Project Instructions

> Drop this file into the root of any new project. Claude Code reads it automatically.
> Customize the sections marked with [EDIT] for your specific project.

## Project Overview

<!-- [EDIT] Describe your project in 2-3 sentences -->
**Name:** [Your Project Name]
**Stack:** Next.js (frontend) + Python/FastAPI (backend) + PostgreSQL (database)
**Description:** [What does this app do?]

## Tech Stack

<!-- [EDIT] Remove or add based on your actual stack -->
- **Frontend:** Next.js 15, React 19, TypeScript, Tailwind CSS
- **Backend:** Python 3.12, FastAPI, Pydantic
- **Database:** PostgreSQL via Supabase
- **Auth:** Supabase Auth
- **Deployment:** Vercel (frontend), Railway (backend)
- **Testing:** Vitest (frontend), pytest (backend), Playwright (E2E)

## Development Commands

<!-- [EDIT] Update these to match your project's actual commands -->
```bash
# Frontend
npm run dev          # Start Next.js dev server
npm run build        # Production build
npm run test         # Run Vitest tests
npm run test:e2e     # Run Playwright E2E tests
npm run lint         # ESLint + Prettier check

# Backend
cd backend
uvicorn main:app --reload    # Start FastAPI dev server
pytest                       # Run Python tests
pytest --cov=app --cov-report=term-missing  # Tests with coverage
```

---

## Workflow Rules (MANDATORY)

### 1. ALWAYS Plan Before Coding
- Use `/plan` for any feature that touches 2+ files
- WAIT for my explicit approval before writing code
- Break large features into independently deliverable phases

### 2. ALWAYS Write Tests First (TDD)
- Use `/tdd` for all new features and bug fixes
- Follow RED → GREEN → REFACTOR cycle strictly
- Minimum 80% test coverage, 100% for auth/payment/security code
- Never skip the RED phase — write the failing test first

### 3. ALWAYS Review Before Committing
- Use `/code-review` before every commit
- Fix all CRITICAL and HIGH issues before committing
- No hardcoded secrets, no console.logs, no mutation patterns

### 4. Keep Code Small and Focused
- Functions: < 50 lines, single responsibility
- Files: 200-400 lines typical, 800 max
- Nesting: < 4 levels deep
- Many small files > few large files

### 5. Immutability is Non-Negotiable
- NEVER mutate objects or arrays in place
- ALWAYS use spread operators, map, filter, reduce
- ALWAYS return new objects from state updates

### 6. Security Before Everything
Before ANY commit, verify:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML output)
- [ ] Auth/authorization on every route
- [ ] Error messages don't leak internal details

---

## Code Style

### TypeScript/React
- Use TypeScript strict mode — no `any` types
- Prefer named exports over default exports
- Use React Server Components where possible (Next.js)
- Client components only when you need interactivity
- Use `interface` for object shapes, `type` for unions/intersections
- Error boundaries around async components

### Python/FastAPI
- Use type hints everywhere
- Use Pydantic models for request/response validation
- Use async/await for I/O operations
- Use dependency injection for services
- Use `@router` decorators, keep routes thin
- Business logic in service layer, not in route handlers

### Git Commits
- Format: `<type>: <description>` (e.g., `feat: add user signup flow`)
- Types: feat, fix, refactor, docs, test, chore, perf
- Keep commits atomic — one logical change per commit

---

## Project Structure

<!-- [EDIT] Update to match your actual project structure -->
```
project-root/
├── CLAUDE.md              # This file (project instructions)
├── src/                   # Next.js frontend
│   ├── app/              # App router pages
│   ├── components/       # React components
│   ├── lib/              # Shared utilities
│   └── hooks/            # Custom React hooks
├── backend/              # Python backend
│   ├── app/              # FastAPI application
│   │   ├── api/          # Route handlers
│   │   ├── models/       # Pydantic models
│   │   ├── services/     # Business logic
│   │   └── core/         # Config, auth, deps
│   └── tests/            # pytest tests
├── tests/                # Frontend tests (Vitest)
├── e2e/                  # Playwright E2E tests
└── supabase/             # Database migrations
    └── migrations/
```

---

## Anti-Slop Rules

These rules specifically prevent common AI code generation problems:

1. **No boilerplate comments** — Don't add "This function does X" comments when the code is self-explanatory
2. **No unnecessary abstractions** — Don't create a utility for something used once. Three similar lines > premature abstraction
3. **No over-engineering** — Don't add feature flags, config options, or extensibility points unless explicitly asked
4. **No placeholder code** — Don't write `// TODO: implement later` — either implement it or don't include it
5. **No defensive coding against impossible states** — Trust internal code. Only validate at system boundaries (user input, external APIs)
6. **No verbose error handling** — Use try/catch at appropriate levels, not around every single line
7. **No re-exporting** — Don't create barrel files (index.ts) unless the project already uses them
8. **No over-typing** — Don't add types to variables where TypeScript can infer them
9. **No emoji in code** — No emoji in comments, variable names, or log messages unless explicitly requested
10. **Keep it simple** — The right amount of code is the minimum needed for the current task

---

## Available Commands

| Command | When to Use |
|---------|------------|
| `/plan` | Starting any new feature or significant change |
| `/tdd` | Implementing features, fixing bugs, writing tests |
| `/code-review` | Before committing — security + quality review |
| `/build-fix` | When build/type errors occur |
| `/e2e` | Testing critical user flows end-to-end |
| `/learn` | End of session — extract patterns for future use |
