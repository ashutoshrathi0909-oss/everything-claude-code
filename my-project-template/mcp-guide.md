# MCP Server Setup Guide

MCP (Model Context Protocol) servers extend Claude Code with external integrations.
Add the servers you need to `~/.claude.json` under the `mcpServers` key.

> **Rule of thumb:** Keep under 10 MCPs enabled to preserve context window quality.

---

## Essential (Recommended for All Projects)

### GitHub — PR, Issue, and Repo Management
```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
  }
}
```
**Setup:** Create a PAT at https://github.com/settings/tokens with `repo` scope.
**Use case:** Claude can create PRs, manage issues, search code across repos.

### Memory — Persistent Memory Across Sessions
```json
"memory": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-memory"]
}
```
**Setup:** No API key needed. Works immediately.
**Use case:** Claude remembers decisions, architecture choices, and patterns across sessions. Great for maintaining project context over days/weeks.

### Context7 — Live Documentation Lookup
```json
"context7": {
  "command": "npx",
  "args": ["-y", "@context7/mcp-server"]
}
```
**Setup:** No API key needed. Works immediately.
**Use case:** Claude gets up-to-date library documentation instead of relying on training data. Reduces hallucinated API calls.

### Sequential Thinking — Better Reasoning
```json
"sequential-thinking": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
}
```
**Setup:** No API key needed. Works immediately.
**Use case:** Helps Claude think through complex architectural decisions step-by-step.

---

## Deployment (Pick Based on Your Platform)

### Vercel — Deploy Next.js Frontend
```json
"vercel": {
  "type": "http",
  "url": "https://mcp.vercel.com"
}
```
**Setup:** Authenticate via browser when first used.
**Use case:** Deploy frontend, manage environment variables, check build logs.

### Railway — Deploy Python Backend
```json
"railway": {
  "command": "npx",
  "args": ["-y", "@railway/mcp-server"]
}
```
**Setup:** Authenticate via `railway login` CLI.
**Use case:** Deploy FastAPI backend, manage databases, view logs.

### Supabase — Database Operations
```json
"supabase": {
  "command": "npx",
  "args": ["-y", "@supabase/mcp-server-supabase@latest", "--project-ref=YOUR_PROJECT_REF"]
}
```
**Setup:** Get project ref from Supabase dashboard → Project Settings.
**Use case:** Claude can run migrations, query data, manage auth users directly.

---

## Research (Optional, Great for Planning Phase)

### Exa Web Search — Deep Web Research
```json
"exa-web-search": {
  "command": "npx",
  "args": ["-y", "exa-mcp-server"],
  "env": {
    "EXA_API_KEY": "your_exa_key_here"
  }
}
```
**Setup:** Get API key from https://exa.ai
**Use case:** Claude researches existing solutions, libraries, and patterns before building. Reduces "reinventing the wheel".

### Firecrawl — Web Scraping
```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp"],
  "env": {
    "FIRECRAWL_API_KEY": "your_firecrawl_key_here"
  }
}
```
**Setup:** Get API key from https://firecrawl.dev
**Use case:** Analyze competitor websites, extract content for AI training data, scrape documentation.

### Magic UI — Component Library
```json
"magic": {
  "command": "npx",
  "args": ["-y", "@magicuidesign/mcp@latest"]
}
```
**Setup:** No API key needed.
**Use case:** Access pre-built, beautiful UI components. Saves time on frontend development.

---

## How to Install

1. Open or create `~/.claude.json`
2. Add an `mcpServers` key if it doesn't exist
3. Paste the server configs you want inside it
4. Restart Claude Code

**Example ~/.claude.json:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

## Disabling Per-Project

If a project doesn't need certain MCPs, add to your project's `.claude/settings.json`:
```json
{
  "disabledMcpServers": ["firecrawl", "railway"]
}
```
