#!/usr/bin/env bash
# my-setup.sh — One-command setup for the App Development Framework
#
# Usage:
#   bash my-setup.sh
#
# What it does:
#   1. Installs ECC rules globally (~/.claude/rules/) for TypeScript + Python
#   2. Copies core agents to ~/.claude/agents/
#   3. Copies core commands to ~/.claude/commands/
#   4. Prints a summary of what was installed
#
# Prerequisites:
#   - Node.js >= 18
#   - Claude Code installed
#   - This repo cloned locally

set -euo pipefail

# Resolve the directory where this script lives (ECC repo root)
ECC_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "  App Development Framework Setup"
echo "  Powered by Everything Claude Code (ECC)"
echo "=========================================="
echo ""

# Step 1: Install rules globally
echo "[1/3] Installing rules (typescript + python)..."
if [ -f "$ECC_ROOT/install.sh" ]; then
    bash "$ECC_ROOT/install.sh" typescript python
else
    echo "ERROR: install.sh not found at $ECC_ROOT/install.sh"
    exit 1
fi
echo ""

# Step 2: Copy core agents
echo "[2/3] Installing core agents..."
AGENTS_DIR="$HOME/.claude/agents"
mkdir -p "$AGENTS_DIR"

CORE_AGENTS=(
    "planner.md"
    "architect.md"
    "tdd-guide.md"
    "code-reviewer.md"
    "security-reviewer.md"
    "build-error-resolver.md"
    "e2e-runner.md"
)

for agent in "${CORE_AGENTS[@]}"; do
    if [ -f "$ECC_ROOT/agents/$agent" ]; then
        cp "$ECC_ROOT/agents/$agent" "$AGENTS_DIR/$agent"
        echo "  Installed: $agent"
    else
        echo "  WARNING: $agent not found, skipping"
    fi
done
echo ""

# Step 3: Copy core commands
echo "[3/3] Installing core commands..."
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

CORE_COMMANDS=(
    "plan.md"
    "tdd.md"
    "code-review.md"
    "build-fix.md"
    "e2e.md"
    "learn.md"
)

for cmd in "${CORE_COMMANDS[@]}"; do
    if [ -f "$ECC_ROOT/commands/$cmd" ]; then
        cp "$ECC_ROOT/commands/$cmd" "$COMMANDS_DIR/$cmd"
        echo "  Installed: $cmd"
    else
        echo "  WARNING: $cmd not found, skipping"
    fi
done
echo ""

# Summary
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "What was installed:"
echo "  Rules:    ~/.claude/rules/ (common + typescript + python)"
echo "  Agents:   ~/.claude/agents/ (${#CORE_AGENTS[@]} agents)"
echo "  Commands: ~/.claude/commands/ (${#CORE_COMMANDS[@]} commands)"
echo ""
echo "Next steps:"
echo "  1. Copy my-project-template/ into your new projects"
echo "  2. Edit the CLAUDE.md to match your project"
echo "  3. Set up MCP servers (see my-project-template/mcp-guide.md)"
echo "  4. Start building with: /plan → /tdd → /code-review"
echo ""
echo "Available commands in Claude Code:"
echo "  /plan        — Create implementation plan (waits for approval)"
echo "  /tdd         — Test-driven development (write tests first)"
echo "  /code-review — Security + quality review"
echo "  /build-fix   — Fix build/type errors"
echo "  /e2e         — Generate E2E tests"
echo "  /learn       — Extract patterns from sessions"
echo ""
