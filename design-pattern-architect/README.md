# Design Pattern Architect Skill

A comprehensive skill for systematic software design using object-oriented principles and design patterns.

## Overview

This skill helps analyze requirements, identify design problems, and apply appropriate design patterns (or choose simpler approaches when patterns aren't necessary). It emphasizes avoiding over-engineering and choosing simplicity when appropriate.

**Core Philosophy**:
- Design patterns are **starting points**, not **absolute answers**
- Patterns can and should be **modified** to fit the context
- **Simplicity over complexity** - avoid over-engineering
- **Pattern-less design is valid** - not every problem needs a pattern

## Language Convention

- **Documentation**: English
- **Communication/Output**: Matches your input language
  - Korean input → Korean output (한국어)
  - English input → English output
  - Other languages → Same language output

## Language-Agnostic Design

**Code examples use Swift, but patterns work in any OOP language:**
- Java, C#, TypeScript, Python, Kotlin, Go, Rust, etc.
- Patterns are **concepts**, not code templates
- Focus on **why** and **when**, not just **how**
- Adapt syntax to your language while keeping structure

## Skill Structure

```
design-pattern-architect/
├── SKILL.md                           # Main skill instructions
├── README.md                          # This file
├── references/                        # Reference documentation
│   ├── oop-principles.md             # SOLID, DRY, KISS, YAGNI
│   ├── pattern-selection.md          # Problem-to-pattern mapping guide
│   ├── creational-patterns.md        # Singleton, Factory, Builder, etc.
│   ├── structural-patterns.md        # Adapter, Decorator, Facade, etc.
│   └── behavioral-patterns.md        # Observer, Strategy, Command, etc.
└── assets/
    ├── templates/                    # Document templates
    │   ├── design-document.md       # Complete design document template
    │   └── pattern-analysis.md      # Pattern evaluation template
    └── examples/                     # Real-world examples
        ├── simple-over-pattern.md   # Choosing simple approach
        ├── pattern-applied-modified.md  # Pattern with modifications
        └── over-engineering-avoided.md  # Avoiding complexity
```

## How to Use

### 1. Activate the Skill

In Claude Code or Claude.ai, reference this skill when working on software design tasks:

```
"Use the design-pattern-architect skill to help me design a [feature/system]"
```

### 2. Design Process

The skill follows a systematic 5-phase process:

1. **Requirements Analysis** - Identify design problems
2. **OOP Principles Review** - Apply SOLID, DRY, KISS, YAGNI
3. **Pattern Selection** (if needed) - Choose and evaluate patterns
4. **Design Documentation** - Document decisions and trade-offs
5. **Output** - Communicate in Korean

### 3. Key Features

- **Over-Engineering Detection**: Built-in checks to avoid unnecessary complexity
- **Pattern Modifications**: Guidance on adapting patterns to your context
- **Real-World Examples**: Three detailed case studies
- **Template Documents**: Ready-to-use design documentation templates
- **Language Separation**: English docs, Korean communication

## When to Use This Skill

✅ **Use when**:
- Designing new features or systems
- Refactoring complex code
- Evaluating architectural decisions
- Need systematic approach to design problems
- Want to avoid over-engineering

❌ **Don't use when**:
- Writing simple utility functions
- Making trivial code changes
- Time-critical quick fixes
- Problem is already well-understood

## Core Principles

### 1. Simplicity First
Start with the simplest solution. Add patterns only when:
- Problem actually exists (not hypothetical)
- Simple approach becomes painful
- Benefits clearly outweigh costs

### 2. Pattern Modification
Patterns are guidelines, not rigid rules:
- Adapt to your context
- Add production concerns (async, monitoring, retry)
- Remove unnecessary complexity

### 3. Over-Engineering Awareness
Built-in assessment with 5 key questions:
- Would system work without this pattern?
- Does it make code harder to understand?
- Are we solving non-existent problems?
- Can team maintain this?
- Is implementation time worth it?

3+ "Yes" answers = Simplify!

## Reference Files

### Core Principles
- **oop-principles.md**: SOLID principles with examples, when to apply/violate
- **pattern-selection.md**: Problem-to-pattern mapping, decision trees
- **language-examples.md**: ⭐ NEW - Multi-language pattern examples (Swift, TypeScript, Python, Java, Go)

### Error Handling
- **error-handling-guide.md**: Production-grade error handling best practices

### Pattern Catalogs
- **creational-patterns.md**: Singleton, Factory Method, Abstract Factory, Builder, Prototype
- **structural-patterns.md**: Adapter, Bridge, Composite, Decorator, Facade, Proxy, Flyweight
- **behavioral-patterns.md**: Observer, Strategy, Command, State, Template Method, Chain of Responsibility, Iterator

Each pattern includes:
- Problem it solves
- When to use / when NOT to use
- Standard structure
- Variations
- Trade-offs
- Language-specific alternatives

### Templates
- **design-document.md**: Complete design doc with all sections
- **pattern-analysis.md**: Detailed pattern evaluation template

### Examples
- **simple-over-pattern.md**: Authentication system - pattern avoided
- **pattern-applied-modified.md**: Payment system - Strategy pattern with modifications
- **over-engineering-avoided.md**: Notification system - 7 patterns rejected

## Quick Start Example

```
User: "I need to design a payment processing system that supports
       multiple payment methods (credit card, PayPal, Apple Pay)"

Claude (with this skill):
1. Analyzes requirements
2. Identifies design problem: multiple algorithms with runtime selection
3. Evaluates pattern necessity (yes, 3+ methods)
4. Recommends Strategy pattern with practical modifications (async, validation, retry)
5. Provides design document in English
6. Explains decision in Korean to user

Output (Korean):
"3가지 결제 수단이 실제로 필요하므로 Strategy 패턴이 적합합니다.
단, 표준 패턴을 다음과 같이 수정했습니다:
1. async/await 지원 (비동기 결제 API)
2. 검증 로직 추가 (비용 절감)
3. 재시도 메커니즘 (성공률 향상)
..."
```

## Tips

### Do's
✅ Start simple, evolve if needed
✅ Document the "why" behind decisions
✅ Embrace pattern variations
✅ Question pattern necessity
✅ Consider maintenance burden

### Don'ts
❌ Don't pattern-first (problem-first!)
❌ Don't over-engineer for hypothetical futures
❌ Don't cargo-cult patterns
❌ Don't skip trade-off analysis
❌ Don't ignore team familiarity

## Success Metrics

Good design with this skill:
- **Clear problem-solution mapping**: Every pattern addresses specific problem
- **Appropriate complexity**: Complexity matches problem size
- **Team understanding**: Team can explain design in 5 minutes
- **Easy to modify**: Changes are localized and safe
- **Production-ready**: Includes monitoring, error handling, timeouts

## Contributing

To extend this skill:
1. Add new patterns to appropriate reference file
2. Include real-world examples with metrics
3. Update pattern-selection.md with new mappings
4. Follow existing format and language conventions

## Version History

- **v1.0** (2025-10-22): Initial release
  - Complete pattern catalog (Creational, Structural, Behavioral)
  - OOP principles reference
  - Pattern selection guide
  - Over-engineering detection
  - Real-world examples
  - Documentation templates

## License

This skill is provided as-is for educational and professional use.

---

**Remember**: The best pattern is often the one you don't need.

**철학**: 최고의 패턴은 사용하지 않는 패턴입니다.
