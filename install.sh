#!/bin/bash

# Design Pattern Architect Skill - Installation Script
# This script installs the skill to Claude Code's skills directory

set -e

SKILL_NAME="design-pattern-architect"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
SKILL_SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/${SKILL_NAME}"
SKILL_TARGET_DIR="${CLAUDE_SKILLS_DIR}/${SKILL_NAME}"

echo "🚀 Design Pattern Architect Skill Installer"
echo "============================================"
echo ""

# Check if source directory exists
if [ ! -d "$SKILL_SOURCE_DIR" ]; then
    echo "❌ Error: Skill source directory not found: $SKILL_SOURCE_DIR"
    exit 1
fi

# Create Claude skills directory if it doesn't exist
if [ ! -d "$CLAUDE_SKILLS_DIR" ]; then
    echo "📁 Creating Claude skills directory: $CLAUDE_SKILLS_DIR"
    mkdir -p "$CLAUDE_SKILLS_DIR"
fi

# Check if skill already exists
if [ -d "$SKILL_TARGET_DIR" ]; then
    echo "⚠️  Skill already installed at: $SKILL_TARGET_DIR"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "🗑️  Removing existing installation..."
    rm -rf "$SKILL_TARGET_DIR"
fi

# Copy skill to Claude skills directory
echo "📦 Installing skill to: $SKILL_TARGET_DIR"
cp -r "$SKILL_SOURCE_DIR" "$SKILL_TARGET_DIR"

# Verify installation
if [ -f "${SKILL_TARGET_DIR}/SKILL.md" ]; then
    echo ""
    echo "✅ Installation successful!"
    echo ""
    echo "📚 Skill installed at: $SKILL_TARGET_DIR"
    echo ""
    echo "📖 Skill Contents:"
    echo "   - SKILL.md: Main skill instructions"
    echo "   - references/: 5 reference documents (OOP, patterns)"
    echo "   - assets/templates/: 2 design document templates"
    echo "   - assets/examples/: 3 real-world examples"
    echo ""
    echo "🎯 Usage:"
    echo "   The skill will activate automatically when you work on design tasks."
    echo "   You can explicitly reference it by mentioning 'design-pattern-architect'"
    echo "   in your conversation with Claude Code."
    echo ""
    echo "📝 Examples:"
    echo "   - \"Help me design a payment processing system\""
    echo "   - \"Should I use a design pattern for this feature?\""
    echo "   - \"Review my architecture design\""
    echo ""
    echo "🌐 Language:"
    echo "   - Documentation: English"
    echo "   - Communication: Korean (한국어)"
    echo ""
else
    echo "❌ Installation failed: SKILL.md not found in target directory"
    exit 1
fi
