#!/usr/bin/env bash
# my-setup.sh — One-command setup for the FULL App Development Framework
#
# Usage:
#   bash my-setup.sh
#
# What it does:
#   1. Installs ALL ECC rules globally (~/.claude/rules/) for TypeScript + Python
#   2. Copies ALL 17 agents to ~/.claude/agents/
#   3. Copies ALL 43 commands to ~/.claude/commands/
#   4. Copies ALL 90 skills to ~/.claude/skills/
#   5. Copies hooks configuration
#   6. Prints a summary of what was installed
#
# Prerequisites:
#   - Node.js >= 18
#   - Claude Code installed
#   - This repo cloned locally

set -euo pipefail

# Resolve the directory where this script lives (ECC repo root)
ECC_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "  App Development Framework — FULL Setup"
echo "  Powered by Everything Claude Code (ECC)"
echo "=========================================="
echo ""

# Step 1: Install rules globally
echo "[1/5] Installing rules (typescript + python)..."
if [ -f "$ECC_ROOT/install.sh" ]; then
    bash "$ECC_ROOT/install.sh" typescript python
else
    echo "ERROR: install.sh not found at $ECC_ROOT/install.sh"
    exit 1
fi
echo ""

# Step 2: Copy ALL agents
echo "[2/5] Installing ALL agents..."
AGENTS_DIR="$HOME/.claude/agents"
mkdir -p "$AGENTS_DIR"

agent_count=0
for agent in "$ECC_ROOT"/agents/*.md; do
    if [ -f "$agent" ]; then
        filename="$(basename "$agent")"
        cp "$agent" "$AGENTS_DIR/$filename"
        echo "  Installed: $filename"
        agent_count=$((agent_count + 1))
    fi
done
echo "  Total: $agent_count agents"
echo ""

# Step 3: Copy ALL commands
echo "[3/5] Installing ALL commands..."
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

cmd_count=0
for cmd in "$ECC_ROOT"/commands/*.md; do
    if [ -f "$cmd" ]; then
        filename="$(basename "$cmd")"
        cp "$cmd" "$COMMANDS_DIR/$filename"
        echo "  Installed: $filename"
        cmd_count=$((cmd_count + 1))
    fi
done
echo "  Total: $cmd_count commands"
echo ""

# Step 4: Copy ALL skills
echo "[4/5] Installing ALL skills..."
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

skill_count=0
for skill_dir in "$ECC_ROOT"/skills/*/; do
    if [ -d "$skill_dir" ]; then
        dirname="$(basename "$skill_dir")"
        mkdir -p "$SKILLS_DIR/$dirname"
        cp -r "$skill_dir"* "$SKILLS_DIR/$dirname/" 2>/dev/null || true
        echo "  Installed: $dirname/"
        skill_count=$((skill_count + 1))
    fi
done
echo "  Total: $skill_count skills"
echo ""

# Step 5: Copy hooks configuration and scripts
echo "[5/5] Installing hooks and scripts..."
HOOKS_DIR="$HOME/.claude/hooks"
SCRIPTS_DIR="$HOME/.claude/scripts"
mkdir -p "$HOOKS_DIR" "$SCRIPTS_DIR"

# Copy hooks.json
if [ -f "$ECC_ROOT/hooks/hooks.json" ]; then
    cp "$ECC_ROOT/hooks/hooks.json" "$HOOKS_DIR/hooks.json"
    echo "  Installed: hooks/hooks.json"
fi

# Copy all hook scripts
if [ -d "$ECC_ROOT/scripts/hooks" ]; then
    cp -r "$ECC_ROOT/scripts/hooks" "$SCRIPTS_DIR/"
    echo "  Installed: scripts/hooks/ (all hook scripts)"
fi

# Copy lib utilities (needed by hooks)
if [ -d "$ECC_ROOT/scripts/lib" ]; then
    cp -r "$ECC_ROOT/scripts/lib" "$SCRIPTS_DIR/"
    echo "  Installed: scripts/lib/ (shared utilities)"
fi

# Copy other script utilities
for script in "$ECC_ROOT"/scripts/*.js "$ECC_ROOT"/scripts/*.sh; do
    if [ -f "$script" ]; then
        filename="$(basename "$script")"
        cp "$script" "$SCRIPTS_DIR/$filename"
        echo "  Installed: scripts/$filename"
    fi
done
echo ""

# Summary
echo "=========================================="
echo "  FULL Setup Complete!"
echo "=========================================="
echo ""
echo "What was installed:"
echo "  Rules:    ~/.claude/rules/    (common + typescript + python)"
echo "  Agents:   ~/.claude/agents/   ($agent_count agents)"
echo "  Commands: ~/.claude/commands/  ($cmd_count commands)"
echo "  Skills:   ~/.claude/skills/   ($skill_count skills)"
echo "  Hooks:    ~/.claude/hooks/    (hooks.json + all scripts)"
echo "  Scripts:  ~/.claude/scripts/  (utilities + hook scripts)"
echo ""
echo "=========================================="
echo "  Your Anti-Slop Workflow"
echo "=========================================="
echo ""
echo "  /plan          — Create implementation plan (waits for approval)"
echo "  /tdd           — Test-driven development (write tests first)"
echo "  /code-review   — Security + quality review"
echo "  /build-fix     — Fix build/type errors"
echo "  /e2e           — Generate and run E2E tests"
echo "  /learn         — Extract patterns from sessions"
echo ""
echo "  /save-session  — Save session state"
echo "  /resume-session — Resume from saved state"
echo "  /checkpoint    — Create a session checkpoint"
echo ""
echo "  /multi-plan    — Plan across multiple targets"
echo "  /orchestrate   — Orchestrate complex workflows"
echo "  /skill-create  — Generate skills from git history"
echo "  /quality-gate  — Run quality gate checks"
echo "  /eval          — Run capability evaluations"
echo ""
echo "  /go-review, /python-review, /kotlin-review — Language-specific reviews"
echo ""
echo "Next steps:"
echo "  1. Copy my-project-template/ into your new projects"
echo "  2. Edit the CLAUDE.md to match your project"
echo "  3. Set up MCP servers (see my-project-template/mcp-guide.md)"
echo "  4. Start building with: /plan → /tdd → /code-review"
echo ""
