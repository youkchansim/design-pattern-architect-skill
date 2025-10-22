# Installation Guide

Design Pattern Architect - Claude Code Skill

## Quick Installation

### Method 1: Using Install Script (Recommended)

```bash
# Download and extract the skill
cd ~/architect-skills

# Run installation
bash install.sh
```

The skill will be automatically installed to `~/.claude/skills/design-pattern-architect/`

---

### Method 2: Using npm

```bash
# Install via npm (if published)
npm install -g design-pattern-architect-skill
npm run install-skill
```

---

### Method 3: Manual Installation

```bash
# Copy the skill directory
cp -r design-pattern-architect ~/.claude/skills/

# Verify installation
ls -la ~/.claude/skills/design-pattern-architect/SKILL.md
```

---

## Installation from Archive

### From .tar.gz

```bash
# Extract archive
tar -xzf design-pattern-architect-skill-v1.0.0.tar.gz

# Navigate to extracted directory
cd architect-skills

# Run installation
bash install.sh
```

### From .zip

```bash
# Extract archive
unzip design-pattern-architect-skill-v1.0.0.zip

# Navigate to extracted directory
cd architect-skills

# Run installation
bash install.sh
```

---

## Verification

After installation, verify the skill is properly installed:

```bash
# Check skill directory exists
ls -la ~/.claude/skills/design-pattern-architect/

# Validate skill structure
cd ~/architect-skills
bash scripts/validate.sh
```

Expected output:
```
✅ Validation passed!
The skill is ready to be installed.
```

---

## Post-Installation

### Test the Skill

Open Claude Code and try:

```
"Help me design a payment processing system with multiple payment methods"
```

The skill should automatically activate and provide systematic design guidance.

### Skill Location

The skill is installed at:
```
~/.claude/skills/design-pattern-architect/
├── SKILL.md              # Main skill file
├── README.md             # Documentation
├── references/           # 5 reference documents
└── assets/               # Templates and examples
```

---

## Troubleshooting

### Issue: Install script fails

**Solution 1**: Check permissions
```bash
chmod +x install.sh
bash install.sh
```

**Solution 2**: Manual copy
```bash
mkdir -p ~/.claude/skills
cp -r design-pattern-architect ~/.claude/skills/
```

### Issue: Skill not activating

**Check 1**: Verify installation
```bash
ls ~/.claude/skills/design-pattern-architect/SKILL.md
```

**Check 2**: Verify SKILL.md format
```bash
head -n 10 ~/.claude/skills/design-pattern-architect/SKILL.md
```

Should start with:
```yaml
---
name: design-pattern-architect
description: ...
---
```

**Check 3**: Restart Claude Code
Close and reopen Claude Code application.

### Issue: Permission denied

```bash
# Fix permissions
chmod -R u+rw ~/.claude/skills/design-pattern-architect
```

---

## Updating the Skill

### Method 1: Reinstall

```bash
# Uninstall old version
bash uninstall.sh

# Install new version
bash install.sh
```

### Method 2: Overwrite

The install script will prompt you to overwrite if the skill already exists:
```
⚠️  Skill already installed at: ~/.claude/skills/design-pattern-architect
Do you want to overwrite it? (y/N):
```

---

## Uninstallation

### Using Uninstall Script

```bash
bash uninstall.sh
```

### Manual Removal

```bash
rm -rf ~/.claude/skills/design-pattern-architect
```

---

## System Requirements

- **Claude Code**: Latest version
- **Operating System**: macOS, Linux, or Windows (WSL)
- **Bash**: Version 3.0 or higher
- **Disk Space**: ~1 MB

---

## Installation Locations

### Default Installation

```
~/.claude/skills/design-pattern-architect/
```

### Alternative Location (Advanced)

If you want to install to a custom location:

```bash
# Set custom location
CLAUDE_SKILLS_DIR="/custom/path/to/skills"

# Create directory
mkdir -p "$CLAUDE_SKILLS_DIR"

# Copy skill
cp -r design-pattern-architect "$CLAUDE_SKILLS_DIR/"
```

**Note**: Claude Code looks for skills in `~/.claude/skills/` by default.

---

## Multiple Installations

You can install the skill on multiple machines:

1. Download the archive to each machine
2. Run installation script on each machine
3. Skill settings are local to each installation

---

## Network Installation

For teams, you can share the skill:

### Option 1: Shared Archive

```bash
# Create archive
tar -czf skill.tar.gz design-pattern-architect/

# Share via network/cloud
# Users extract and run install.sh
```

### Option 2: Git Repository

```bash
# Clone repository
git clone https://github.com/youkchansim/design-pattern-architect-skill

# Install
cd design-pattern-architect-skill
bash install.sh
```

---

## Getting Help

If you encounter issues:

1. **Check Documentation**: Read README.md
2. **Validate Installation**: Run `bash scripts/validate.sh`
3. **Check Logs**: Look for error messages during installation
4. **GitHub Issues**: Report issues at GitHub repository
5. **Manual Installation**: Try manual installation as fallback

---

## Next Steps

After successful installation:

1. ✅ **Read Documentation**: Check `design-pattern-architect/README.md`
2. ✅ **Try Examples**: Review examples in `assets/examples/`
3. ✅ **Use Templates**: Explore templates in `assets/templates/`
4. ✅ **Start Designing**: Open Claude Code and start a design conversation

---

## Installation Verification Checklist

- [ ] Skill directory exists at `~/.claude/skills/design-pattern-architect/`
- [ ] SKILL.md file is present and readable
- [ ] All reference files exist (5 files in `references/`)
- [ ] Template files exist (2 files in `assets/templates/`)
- [ ] Example files exist (3 files in `assets/examples/`)
- [ ] Validation script passes
- [ ] Skill activates in Claude Code conversation

---

**Installation Complete! 🎉**

The Design Pattern Architect skill is now ready to use.

Start a conversation in Claude Code about software design, and the skill will automatically provide systematic guidance.

**Remember**: 최고의 패턴은 사용하지 않는 패턴입니다! 😊
