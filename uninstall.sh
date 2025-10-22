#!/bin/bash

# Design Pattern Architect Skill - Uninstallation Script

set -e

SKILL_NAME="design-pattern-architect"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
SKILL_TARGET_DIR="${CLAUDE_SKILLS_DIR}/${SKILL_NAME}"

echo "🗑️  Design Pattern Architect Skill Uninstaller"
echo "=============================================="
echo ""

# Check if skill is installed
if [ ! -d "$SKILL_TARGET_DIR" ]; then
    echo "⚠️  Skill is not installed at: $SKILL_TARGET_DIR"
    exit 0
fi

# Confirm uninstallation
echo "📍 Skill location: $SKILL_TARGET_DIR"
read -p "Are you sure you want to uninstall? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove skill directory
echo "🗑️  Removing skill..."
rm -rf "$SKILL_TARGET_DIR"

# Verify removal
if [ ! -d "$SKILL_TARGET_DIR" ]; then
    echo ""
    echo "✅ Uninstallation successful!"
    echo ""
    echo "The design-pattern-architect skill has been removed from:"
    echo "$SKILL_TARGET_DIR"
    echo ""
else
    echo "❌ Uninstallation failed: Directory still exists"
    exit 1
fi
