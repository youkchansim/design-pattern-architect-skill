#!/bin/bash

# Design Pattern Architect Skill - Validation Script
# Validates the skill structure and required files

set -e

SKILL_NAME="design-pattern-architect"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)/${SKILL_NAME}"

echo "🔍 Design Pattern Architect Skill Validator"
echo "==========================================="
echo ""
echo "Validating skill at: $SKILL_DIR"
echo ""

ERRORS=0
WARNINGS=0

# Check if skill directory exists
if [ ! -d "$SKILL_DIR" ]; then
    echo "❌ Error: Skill directory not found: $SKILL_DIR"
    exit 1
fi

# Required files
REQUIRED_FILES=(
    "SKILL.md"
    "README.md"
)

echo "📋 Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "${SKILL_DIR}/${file}" ]; then
        echo "   ✅ ${file}"
    else
        echo "   ❌ Missing: ${file}"
        ((ERRORS++))
    fi
done

# Required directories
REQUIRED_DIRS=(
    "references"
    "assets/templates"
    "assets/examples"
)

echo ""
echo "📁 Checking required directories..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "${SKILL_DIR}/${dir}" ]; then
        file_count=$(find "${SKILL_DIR}/${dir}" -type f | wc -l | tr -d ' ')
        echo "   ✅ ${dir} (${file_count} files)"
    else
        echo "   ❌ Missing: ${dir}"
        ((ERRORS++))
    fi
done

# Validate SKILL.md structure
echo ""
echo "🔎 Validating SKILL.md structure..."

if [ -f "${SKILL_DIR}/SKILL.md" ]; then
    # Check for YAML frontmatter
    if head -n 1 "${SKILL_DIR}/SKILL.md" | grep -q "^---$"; then
        echo "   ✅ YAML frontmatter found"

        # Check for required fields
        if grep -q "^name:" "${SKILL_DIR}/SKILL.md"; then
            echo "   ✅ 'name' field found"
        else
            echo "   ❌ 'name' field missing in frontmatter"
            ((ERRORS++))
        fi

        if grep -q "^description:" "${SKILL_DIR}/SKILL.md"; then
            echo "   ✅ 'description' field found"
        else
            echo "   ❌ 'description' field missing in frontmatter"
            ((ERRORS++))
        fi
    else
        echo "   ❌ YAML frontmatter not found (must start with '---')"
        ((ERRORS++))
    fi

    # Check content length
    content_lines=$(wc -l < "${SKILL_DIR}/SKILL.md" | tr -d ' ')
    if [ "$content_lines" -lt 50 ]; then
        echo "   ⚠️  Warning: SKILL.md is very short (${content_lines} lines)"
        ((WARNINGS++))
    else
        echo "   ✅ Content length adequate (${content_lines} lines)"
    fi
fi

# Check reference files
echo ""
echo "📚 Checking reference files..."
REFERENCE_FILES=(
    "oop-principles.md"
    "pattern-selection.md"
    "creational-patterns.md"
    "structural-patterns.md"
    "behavioral-patterns.md"
)

for file in "${REFERENCE_FILES[@]}"; do
    if [ -f "${SKILL_DIR}/references/${file}" ]; then
        lines=$(wc -l < "${SKILL_DIR}/references/${file}" | tr -d ' ')
        echo "   ✅ ${file} (${lines} lines)"
    else
        echo "   ⚠️  Optional file missing: ${file}"
        ((WARNINGS++))
    fi
done

# Check template files
echo ""
echo "📄 Checking template files..."
TEMPLATE_FILES=(
    "design-document.md"
    "pattern-analysis.md"
)

for file in "${TEMPLATE_FILES[@]}"; do
    if [ -f "${SKILL_DIR}/assets/templates/${file}" ]; then
        lines=$(wc -l < "${SKILL_DIR}/assets/templates/${file}" | tr -d ' ')
        echo "   ✅ ${file} (${lines} lines)"
    else
        echo "   ⚠️  Optional file missing: ${file}"
        ((WARNINGS++))
    fi
done

# Check example files
echo ""
echo "📖 Checking example files..."
EXAMPLE_FILES=(
    "simple-over-pattern.md"
    "pattern-applied-modified.md"
    "over-engineering-avoided.md"
)

for file in "${EXAMPLE_FILES[@]}"; do
    if [ -f "${SKILL_DIR}/assets/examples/${file}" ]; then
        lines=$(wc -l < "${SKILL_DIR}/assets/examples/${file}" | tr -d ' ')
        echo "   ✅ ${file} (${lines} lines)"
    else
        echo "   ⚠️  Optional file missing: ${file}"
        ((WARNINGS++))
    fi
done

# Summary
echo ""
echo "============================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ Validation passed!"
    if [ $WARNINGS -gt 0 ]; then
        echo "⚠️  ${WARNINGS} warning(s) found (optional files missing)"
    fi
    echo ""
    echo "The skill is ready to be installed."
    exit 0
else
    echo "❌ Validation failed!"
    echo "   ${ERRORS} error(s) found"
    if [ $WARNINGS -gt 0 ]; then
        echo "   ${WARNINGS} warning(s) found"
    fi
    echo ""
    echo "Please fix the errors before installing the skill."
    exit 1
fi
