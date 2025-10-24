# Design Pattern Architect - Claude Code Skill

A comprehensive Claude Code skill for systematic software design using object-oriented principles and design patterns, with built-in over-engineering prevention.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue.svg)](https://claude.ai)

## 🎯 Overview

This skill helps you analyze requirements, identify design problems, and apply appropriate design patterns (or choose simpler approaches when patterns aren't necessary). It emphasizes avoiding over-engineering and choosing simplicity when appropriate.

**Core Philosophy**:
- Design patterns are **starting points**, not **absolute answers**
- Patterns can and should be **modified** to fit the context
- **Simplicity over complexity** - avoid over-engineering
- **Pattern-less design is valid** - not every problem needs a pattern

## ✨ Features

### 🛡️ Over-Engineering Prevention
- Built-in 5-question validation to assess pattern necessity
- YAGNI principle enforcement
- Complexity cost-benefit analysis

### 🎨 Pattern Modification Support
- Guidance on adapting patterns to your context
- Production-ready enhancements (async, monitoring, retry logic)
- Pragmatic vs dogmatic approach

### 📚 Comprehensive Pattern Catalog
- **19 Design Patterns** fully documented
  - 5 Creational patterns
  - 7 Structural patterns
  - 7 Behavioral patterns
- Each pattern includes:
  - When to use / when NOT to use
  - Standard structure
  - Variations and alternatives
  - Trade-offs
  - Language-specific implementations

### 📖 Real-World Examples
- **3 Detailed Case Studies** with metrics:
  1. Choosing simple approach over patterns (Authentication)
  2. Pattern applied with modifications (Payment Processing)
  3. Avoiding over-engineering (Notification System)

### 🗂️ Complete Documentation
- **5 Reference Documents**: OOP principles, pattern selection guides, pattern catalogs
- **2 Templates**: Design document, Pattern analysis
- **Systematic 5-Phase Process**: From requirements to implementation

### 🌐 Language Convention
- **Documentation**: English
- **Communication/Output**: Korean (한국어)

## 📦 Installation

### Plugin Marketplace (Recommended)

Install directly from Claude Code:

```
/plugin marketplace add youkchansim/design-pattern-architect-skill
/plugin install design-pattern-architect@design-pattern-architect-skills
```

**Benefits:**
- ✓ One-command installation
- ✓ Automatic updates
- ✓ Clean uninstallation
- ✓ Version management

### Manual Install (Alternative)

If you prefer manual installation:

```bash
# Clone the repository
git clone https://github.com/youkchansim/design-pattern-architect-skill.git
cd design-pattern-architect-skill

# Copy skill directory
cp -r design-pattern-architect ~/.claude/skills/

# Verify installation
ls -la ~/.claude/skills/design-pattern-architect/
```

## 🚀 Usage

The skill activates automatically when you work on design-related tasks in Claude Code.

### Automatic Activation

Claude Code will automatically use this skill when you:
- Design new features or systems
- Discuss architecture decisions
- Ask about design patterns
- Request code review for design quality

### Example Conversations

#### Example 1: Payment System Design
```
User: "여러 결제 수단(신용카드, PayPal, Apple Pay)을
       지원하는 결제 시스템을 설계해줘"

Claude (with skill):
"3가지 결제 수단이 실제로 필요하므로 Strategy 패턴이 적합합니다.

패턴 평가 (19/20점):
- 문제 적합성: 5/5 (여러 알고리즘, 런타임 선택)
- 단순성: 4/5 (잘 알려진 패턴)
- 팀 친숙도: 5/5
- 미래 대응: 5/5 (2개 추가 예정)

표준 Strategy 패턴에 다음 수정사항을 추가합니다:

1. async/await 지원
   - 이유: 결제 API는 비동기
   - 효과: 깔끔한 코드, 높은 성능

2. 사전 검증 로직
   - 이유: 실패한 결제는 비용 발생 ($0.10/건)
   - 효과: 월 $1,000 절감 (10,000건 기준)

3. 재시도 메커니즘
   - 이유: 일시적 실패 5%, 재시도시 80% 성공
   - 효과: 성공률 4% 향상 → 월 $86K 추가 매출

[설계 문서 작성...]"
```

#### Example 2: Simple Feature
```
User: "이메일 검증 기능을 만들어줘"

Claude (with skill):
"이메일 검증은 단순한 기능이므로 패턴이 필요하지 않습니다.

오버엔지니어링 체크:
- 패턴 없이 작동? YES (정규식으로 충분)
- 이해하기 어려워짐? NO
- 가상의 문제 해결? NO
- 구현 시간 대비 효과? 단순 접근이 나음

권장 접근법:
[간단한 구현 제시...]"
```

## 📖 Skill Structure

```
design-pattern-architect/
├── SKILL.md                          # Main skill instructions
├── README.md                         # Skill usage guide
│
├── references/                       # Reference documentation
│   ├── oop-principles.md            # SOLID, DRY, KISS, YAGNI
│   ├── pattern-selection.md         # Problem-to-pattern mapping
│   ├── creational-patterns.md       # 5 Creational patterns
│   ├── structural-patterns.md       # 7 Structural patterns
│   └── behavioral-patterns.md       # 7 Behavioral patterns
│
└── assets/
    ├── templates/                   # Document templates
    │   ├── design-document.md      # Complete design doc template
    │   └── pattern-analysis.md     # Pattern evaluation template
    │
    └── examples/                    # Real-world examples
        ├── simple-over-pattern.md  # Pattern unnecessary case
        ├── pattern-applied-modified.md  # Pattern with modifications
        └── over-engineering-avoided.md  # Over-engineering case
```

## 🎓 Design Process

The skill follows a systematic 5-phase process:

### Phase 1: Requirements Analysis
- Classify functional/non-functional requirements
- Identify design problems
- Assess constraints
- **Simplicity check**: Can this be solved simply?

### Phase 2: OOP Principles Review
- Apply SOLID principles
- Check for DRY, KISS, YAGNI violations
- Identify simple refactoring opportunities

### Phase 3: Pattern Selection (If Needed)
- Load pattern selection guide
- Evaluate candidate patterns
- **Over-engineering risk assessment**
- Pattern evaluation matrix (Problem-Fit, Simplicity, Team-Familiarity, Future-Proof)

### Phase 4: Design Documentation
- Problem statement
- Approach decision (simple vs pattern)
- Solution design
- Trade-offs analysis
- Anti-patterns avoided

### Phase 5: Output to User (Korean)
- Summarize identified problems
- Explain chosen approach
- Justify decision
- Present trade-offs
- Suggest next steps

## 🛠️ Over-Engineering Detection

Built-in checklist with 5 key questions:

1. ❓ Would the system work acceptably without this pattern?
2. ❓ Is the pattern making code harder to understand?
3. ❓ Are we solving problems that don't exist yet? (YAGNI)
4. ❓ Will the team struggle to maintain this?
5. ❓ Is the implementation time worth the benefit?

**Scoring**:
- 0-1 "Yes": ✅ Low risk, proceed
- 2 "Yes": ⚠️ Medium risk, proceed with caution
- 3+ "Yes": ❌ High risk, simplify!

## 📚 Pattern Catalog

### Creational Patterns (5)
- Singleton
- Factory Method
- Abstract Factory
- Builder
- Prototype

### Structural Patterns (7)
- Adapter
- Bridge
- Composite
- Decorator
- Facade
- Proxy
- Flyweight

### Behavioral Patterns (7)
- Observer
- Strategy
- Command
- State
- Template Method
- Chain of Responsibility
- Iterator

Each pattern includes:
- ✅ When to use
- ❌ When NOT to use
- 📐 Standard structure
- 🔄 Variations
- ⚖️ Trade-offs
- 🔧 Better alternatives (when applicable)

## 📊 Real-World Examples

### Example 1: Authentication System
**Decision**: Simple approach chosen over Strategy pattern

**Metrics**:
- Development time: 1 day (vs 3 weeks with pattern)
- Lines of code: 50 (vs 500+ with pattern)
- Time to understand: 5 minutes (vs 2 hours)
- Bugs in 6 months: 0

**ROI**: $8,000+ saved, faster delivery

### Example 2: Payment Processing
**Decision**: Strategy pattern with practical modifications

**Metrics**:
- Success rate improvement: +4.3%
- Time to add new method: 4 hours (vs 2-3 days before)
- Bug reduction: 85%
- Monthly revenue impact: +$86K

**ROI**: Pattern paid for itself in first month

### Example 3: Notification System
**Decision**: Rejected 7 patterns, chose simple design

**Metrics**:
- Development time saved: 14 days
- Code reduction: 10x less code
- Understanding time: 24x faster
- Test coverage: +33%

**ROI**: $21,600 saved

## 🎯 When to Use This Skill

### ✅ Use When
- Designing new features or systems
- Refactoring complex code
- Evaluating architectural decisions
- Need systematic approach to design problems
- Want to avoid over-engineering

### ❌ Don't Use When
- Writing simple utility functions
- Making trivial code changes
- Time-critical quick fixes
- Problem is already well-understood and simple

## 📝 Contributing

Contributions are welcome! To extend this skill:

1. Fork the repository
2. Add new patterns to appropriate reference file
3. Include real-world examples with metrics
4. Update `pattern-selection.md` with new mappings
5. Follow existing format and language conventions
6. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Gang of Four (GoF) Design Patterns
- SOLID Principles
- Claude Code Skills system
- Software design community

## 📮 Support

- **Issues**: [GitHub Issues](https://github.com/youkchansim/design-pattern-architect-skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/youkchansim/design-pattern-architect-skill/discussions)

## 🔗 Links

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Design Patterns Resources](https://refactoring.guru/design-patterns)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

## 💡 Philosophy

> **"The best pattern is often the one you don't need."**
>
> **"최고의 패턴은 사용하지 않는 패턴이다."**

Patterns are tools, not goals. Start simple. Add complexity only when:
1. Problem actually exists
2. Simple approach becomes painful
3. Benefits clearly outweigh costs

Trust your ability to refactor later. The best time to add a pattern is when you need it, not before.

---

**Version**: 1.0.0
**Author**: youkchansim
**Created**: 2025-10-22
