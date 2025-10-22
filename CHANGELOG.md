# Changelog

All notable changes to the Design Pattern Architect skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-10-22

### Added
- **Multi-Language Examples Guide** (`references/language-examples.md`)
  - Pattern examples in 5 languages: Swift, TypeScript, Python, Java, Go
  - Singleton, Factory, Strategy, Observer patterns demonstrated
  - Language feature mapping table (interface, enum, async, generics)
  - Universal pattern principles (abstraction, composition, polymorphism)
  - Adaptation guidelines for any OOP language
  - 400+ lines of multi-language code examples

### Changed
- **Dynamic Output Language** - Output now matches input language
  - Korean input → Korean output (한국어)
  - English input → English output
  - Other languages → Same language output
  - Replaced hardcoded Korean output with language detection

- **Skill Description** - Clarified language-agnostic nature
  - Updated SKILL.md metadata to emphasize concepts over syntax
  - Added "Language-Agnostic Approach" section
  - Swift examples explained as reference implementations

- **README.md** - Enhanced language support section
  - Added "Language-Agnostic Design" section
  - Listed supported languages with examples
  - Emphasized patterns as concepts, not code templates

### Documentation
- Updated SKILL.md Phase 5 with language detection instructions
- Updated README.md with multi-language support details
- Added language-examples.md to reference files list
- Clarified that Swift syntax is for clarity, not exclusivity

### Metrics
- Total lines: 5,540 → 6,400+ (+860 lines, +15%)
- Reference files: 6 → 7 (+1 language examples guide)
- Supported languages: 1 (Swift) → 5 (Swift, TypeScript, Python, Java, Go)
- Output languages: 1 (Korean only) → Dynamic (any language)

### Impact
- **Language Flexibility**: Patterns applicable to any OOP language
- **Global Accessibility**: Auto-detects and responds in user's language
- **Learning Aid**: Side-by-side comparison of pattern implementations
- **Production Ready**: Language-specific idioms and best practices

---

## [1.1.0] - 2025-10-22

### Added
- **Error Handling Guide** (`references/error-handling-guide.md`)
  - Comprehensive error handling best practices for design patterns
  - `throws` vs `Result<T, E>` selection guide
  - Pattern-specific error handling examples (Factory, Builder, Strategy, Observer)
  - Error type design best practices
  - Layer-specific error handling strategies
  - Testing error paths guide

### Changed
- **Singleton Pattern** - Improved thread-safety implementation
  - Added note that `static let` is already thread-safe in Swift
  - Replaced NSLock with DispatchQueue (more idiomatic Swift)
  - Added explanation of why simple `static let` is preferred

- **Factory Method Pattern** - Enhanced type safety and error handling
  - Added type-safe enum-based factory (compile-time safety)
  - Added error handling with throws (runtime safety)
  - Added Result type example for graceful error handling
  - Removed `fatalError()` usage (crashes avoided)

- **Over-Engineering Detection** - Implemented weighted scoring system
  - Added importance weights to 5 questions:
    - YAGNI (35% - highest priority)
    - Team-Readiness (25%)
    - Necessity (20%)
    - Clarity (15%)
    - Time-Cost (5% - lowest priority)
  - Added weighted score calculation formula
  - Added decision matrix with 3 risk levels (< 35%, 35-50%, > 50%)
  - Added context-specific threshold adjustments (Startup, Enterprise, Open Source)
  - Replaced simple "3+ Yes" rule with objective scoring

### Documentation
- Updated SKILL.md to reference new error-handling-guide.md
- Updated README.md to reflect 6 reference files (was 5)
- All code examples now follow production-grade error handling

### Metrics
- Total lines: 4,953 → 5,540 (+587 lines, +12%)
- Reference files: 5 → 6 (+1 comprehensive guide)
- Improved patterns: 3 (Singleton, Factory Method, Over-Engineering Detection)
- Package size: 45KB (v1.0.0) → 53KB (v1.1.0)

### Impact
- **Code Quality**: Production-grade error handling examples
- **Type Safety**: Eliminated `fatalError()` crashes
- **Decision Making**: Objective weighted scoring for over-engineering detection
- **Best Practices**: Swift idioms (DispatchQueue over NSLock)

---

## [1.0.0] - 2025-10-22

### Initial Release

#### Core Features
- **19 Design Patterns** fully documented
  - 5 Creational patterns (Singleton, Factory Method, Abstract Factory, Builder, Prototype)
  - 7 Structural patterns (Adapter, Bridge, Composite, Decorator, Facade, Proxy, Flyweight)
  - 7 Behavioral patterns (Observer, Strategy, Command, State, Template Method, Chain of Responsibility, Iterator)

- **5-Phase Design Process**
  1. Requirements Analysis & Problem Definition
  2. Object-Oriented Principles Review
  3. Pattern Selection & Design
  4. Design Documentation
  5. Output to User (Korean)

- **Over-Engineering Prevention**
  - 5-question validation checklist
  - Pattern Evaluation Matrix (20-point scoring)
  - 3 real-world case studies with metrics

- **Reference Documentation** (5 files)
  - `oop-principles.md` - SOLID, DRY, KISS, YAGNI
  - `pattern-selection.md` - Problem-to-pattern mapping
  - `creational-patterns.md` - Creational pattern catalog
  - `structural-patterns.md` - Structural pattern catalog
  - `behavioral-patterns.md` - Behavioral pattern catalog

- **Templates** (2 files)
  - `design-document.md` - Complete design doc template
  - `pattern-analysis.md` - Pattern evaluation template

- **Real-World Examples** (3 files with metrics)
  - `simple-over-pattern.md` - Authentication: Pattern avoided (3h vs 3 weeks)
  - `pattern-applied-modified.md` - Payment: Strategy + mods (+$86K/month revenue)
  - `over-engineering-avoided.md` - Notification: 7 patterns rejected ($21.6K saved)

#### Installation
- Automated install/uninstall scripts
- Validation script for skill structure
- npm package.json configuration

#### Documentation
- Comprehensive README.md
- QUICKSTART.md for fast onboarding
- INSTALL.md with troubleshooting

#### Philosophy
- Patterns are starting points, not absolute answers
- Simplicity over complexity
- Pattern-less design is valid
- YAGNI (You Aren't Gonna Need It)

#### Language
- Documentation: English
- Communication: Korean (한국어)

---

## Version Comparison

| Metric | v1.0.0 | v1.1.0 | Change |
|--------|--------|--------|--------|
| **Total Lines** | 4,953 | 5,540 | +587 (+12%) |
| **Reference Files** | 5 | 6 | +1 |
| **Patterns Documented** | 19 | 19 | - |
| **Real-World Examples** | 3 | 3 | - |
| **Error Handling Guide** | ❌ | ✅ | NEW |
| **Weighted Scoring** | ❌ | ✅ | NEW |
| **Type-Safe Factories** | ❌ | ✅ | IMPROVED |
| **Thread-Safe Singleton** | ⚠️ (NSLock) | ✅ (DispatchQueue) | IMPROVED |
| **Package Size (zip)** | 55KB | 64KB | +9KB |

---

## Upgrade Guide

### From v1.0.0 to v1.1.0

**No breaking changes.** This is a backward-compatible enhancement release.

#### What's New
1. **Error Handling Guide**: New reference file
2. **Weighted Scoring**: More objective over-engineering detection
3. **Improved Examples**: Type-safe, error-handled code

#### How to Upgrade

**Option 1: Clean Install** (Recommended)
```bash
# Uninstall old version
bash uninstall.sh

# Install new version
bash install.sh
```

**Option 2: Overwrite**
```bash
# Install will prompt to overwrite
bash install.sh
# Answer 'y' to overwrite
```

**Option 3: Manual Update**
```bash
# Copy new files to your installation
cp -r design-pattern-architect ~/.claude/skills/
```

#### Validation
```bash
# Verify installation
bash scripts/validate.sh
# Should show: ✅ Validation passed!
```

---

## Future Roadmap

### v1.2.0 (Planned)
- [ ] async/await examples (iOS 15+)
- [ ] Combine framework integration
- [ ] SwiftUI context examples
- [ ] Quick Reference guide (1-page cheat sheet)

### v1.3.0 (Planned)
- [ ] Pattern combination guide
- [ ] Language comparison (Swift, TypeScript, Python)
- [ ] Video tutorials
- [ ] Interactive examples

### v2.0.0 (Planned)
- [ ] Claude Code Plugin integration
- [ ] AI-powered pattern recommendation
- [ ] Real-time code analysis
- [ ] Team collaboration features

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Support

- **Issues**: [GitHub Issues](https://github.com/youkchansim/design-pattern-architect-skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/youkchansim/design-pattern-architect-skill/discussions)

---

**Remember**: 최고의 패턴은 사용하지 않는 패턴입니다! 😊
