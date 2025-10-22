---
name: design-pattern-architect
description: Analyzes requirements to identify design problems and applies appropriate design patterns (or variations) based on object-oriented principles. Design patterns are language-agnostic concepts that can be modified as needed. Emphasizes avoiding over-engineering and choosing simplicity when patterns are unnecessary. Documentation is in English, output language matches user's input language.
---

# Design Pattern Architect

## Overview

This skill systematically analyzes requirements, identifies design problems, and applies appropriate design patterns or their variations to create effective software designs.

**Core Philosophy**:
- Design patterns are **starting points**, not **absolute answers**
- Patterns can and should be **modified** to fit the context
- Always **explicitly state** why a pattern was chosen and what problem it solves
- **Simplicity over complexity** - avoid over-engineering
- **Pattern-less design is valid** - not every problem needs a pattern

**Language Convention**:
- All design documents: Written in **English**
- All output/communication to user: **Match input language**
  - Korean input (한글) → Korean output
  - English input → English output
  - Other languages → Respond in same language

**Language-Agnostic Approach**:
- Patterns are **concepts**, not language-specific implementations
- Code examples use Swift for clarity, but principles apply to all OOP languages
- Same pattern structure works in Java, C#, TypeScript, Python, Kotlin, etc.
- Focus on understanding **why** and **when**, not just **how**

## Design Process

### Phase 1: Requirements Analysis & Problem Definition

**Objective**: Understand what needs to be built and identify potential design challenges.

1. **Classify Requirements**
   - Functional requirements (what the system does)
   - Non-functional requirements (performance, scalability, maintainability)

2. **Identify Design Problems**
   - Frequent change points
   - Extensibility needs
   - Coupling issues
   - Complexity hotspots
   - Testing difficulties

3. **Assess Constraints**
   - Performance requirements
   - Team size and expertise
   - Time-to-market pressures
   - Maintenance burden

4. **Simplicity Check**
   - Question: "Can this be solved with a straightforward approach?"
   - If yes: Consider pattern-less design
   - Document why simplicity is or isn't sufficient

### Phase 2: Object-Oriented Principles Review

**Before jumping to patterns, verify adherence to fundamental principles.**

1. **Load OOP Principles**
   - Read `references/oop-principles.md`

2. **Apply SOLID Analysis**
   - Single Responsibility Principle (SRP)
   - Open/Closed Principle (OCP)
   - Liskov Substitution Principle (LSP)
   - Interface Segregation Principle (ISP)
   - Dependency Inversion Principle (DIP)

3. **Identify Violations**
   - Where might principles be broken?
   - What are the consequences?

4. **Simple Refactoring First**
   - Can principle violations be fixed with basic refactoring?
   - If yes: Prefer simple refactoring over pattern application

### Phase 3: Pattern Selection & Design (If Needed)

**Only proceed with pattern application if simpler approaches are insufficient.**

1. **Load Pattern Selection Guide**
   - Read `references/pattern-selection.md`

2. **Identify Candidate Patterns**
   - Based on identified problems
   - Consider multiple alternatives

3. **Evaluate Over-Engineering Risk**
   - Is the pattern adding unnecessary complexity?
   - Is the problem likely to remain stable? (If yes, pattern might be premature)
   - Does the team understand this pattern?
   - What's the maintenance cost?

4. **Pattern Evaluation Matrix**
   For each candidate pattern, score:
   - **Problem-Fit**: How well does it address the core problem? (1-5)
   - **Simplicity**: How simple is it to implement and maintain? (1-5)
   - **Team-Familiarity**: How familiar is the team with this pattern? (1-5)
   - **Future-Proof**: Does it handle anticipated changes? (1-5)

5. **Make Decision**
   - **Pattern selected**: Document choice and rationale
   - **Pattern modified**: Explain modifications
   - **No pattern**: Document why simple approach is better

6. **Load Pattern Details** (if pattern selected)
   - Creational: `references/creational-patterns.md`
   - Structural: `references/structural-patterns.md`
   - Behavioral: `references/behavioral-patterns.md`

### Phase 4: Design Documentation

Use `assets/templates/design-document.md` template.

**Required Sections**:
1. **Problem Statement** (in English)
   - What design problem are we solving?
   - Why is this a problem?

2. **Approach Decision** (in English)
   - Simple approach vs Pattern approach
   - Rationale for the decision

3. **Solution Design** (in English)
   - If pattern used: Pattern name and modifications
   - If simple approach: Architecture description
   - Key components and their responsibilities

4. **Trade-offs** (in English)
   - What did we gain?
   - What did we sacrifice?
   - What are the risks?

5. **Anti-Patterns Avoided** (in English)
   - What over-engineering was avoided?
   - What simpler alternatives were considered?

### Phase 5: Output to User (Dynamic Language)

**Detect input language and respond accordingly:**

1. **Language Detection**
   - Analyze user's input language
   - Match output language to input language
   - Maintain consistent language throughout conversation

2. **Communication Structure** (adapt to detected language)
   - Summary of identified problems
   - Chosen approach (pattern or simple design)
   - Rationale for decision
   - Trade-offs analysis
   - Next steps recommendation

**Examples**:
- Korean input → 식별된 문제 요약, 선택한 접근법, 선택 이유...
- English input → Problem summary, chosen approach, rationale...
- Japanese input → 特定された問題の概要、選択したアプローチ...

## Guidelines

### Do's
- **Always question pattern necessity**: "Do I really need a pattern here?"
- **Start simple, evolve if needed**: Begin with straightforward design
- **Document the 'why'**: Every design decision needs clear reasoning
- **Consider maintenance**: Who will maintain this? Do they understand it?
- **Embrace pattern variations**: Patterns are guidelines, not rigid rules
- **Acknowledge simplicity**: It's okay to say "no pattern needed"

### Don'ts
- **Don't pattern-first**: Never start with "I'll use Factory pattern"
- **Don't over-engineer**: More patterns ≠ better design
- **Don't cargo-cult**: Don't use patterns just because they're popular
- **Don't ignore context**: Same problem in different contexts may need different solutions
- **Don't skip trade-off analysis**: Every pattern has costs

## Over-Engineering Detection

Ask these questions before finalizing design, with weighted importance:

1. **YAGNI** (35% weight): Are we solving problems that don't exist yet?
   - Highest priority - Future problems are often imaginary

2. **Team-Readiness** (25% weight): Will the team struggle to maintain this?
   - Second priority - Unmaintainable code is technical debt

3. **Necessity** (20% weight): Would the system work acceptably without this pattern?
   - Third priority - Simple solutions often suffice

4. **Clarity** (15% weight): Is the pattern making code harder to understand?
   - Fourth priority - Code clarity matters for collaboration

5. **Time-Cost** (5% weight): Is the implementation time worth the benefit?
   - Lowest priority - Time can be justified if other factors align

### Scoring System

Calculate weighted score: Sum of (Yes answers × weight)

**Decision Matrix**:
- **< 35% (Low Risk)**: Pattern is appropriate ✅
- **35-50% (Medium Risk)**: Review carefully, likely simplify ⚠️
- **> 50% (High Risk)**: Definitely simplify ❌

**Examples**:
- Yes to YAGNI + Team-Readiness = 60% → Simplify ❌
- Yes to Clarity + Time-Cost = 20% → Proceed ✅
- Yes to Necessity + Clarity + Time-Cost = 40% → Review ⚠️

**Context Adjustments**:
- Startup (move fast): Threshold 30%
- Enterprise (stability): Threshold 40%
- Open Source (community): Threshold 35%

## Reference Files

Load these as needed during the design process:

- **OOP Principles**: `references/oop-principles.md`
- **Pattern Selection Guide**: `references/pattern-selection.md`
- **Language Examples**: `references/language-examples.md` ⭐ NEW - Multi-language pattern examples
- **Error Handling Guide**: `references/error-handling-guide.md`
- **Creational Patterns**: `references/creational-patterns.md`
- **Structural Patterns**: `references/structural-patterns.md`
- **Behavioral Patterns**: `references/behavioral-patterns.md`

## Templates

- **Design Document**: `assets/templates/design-document.md`
- **Pattern Analysis**: `assets/templates/pattern-analysis.md`

## Examples

Real-world examples in `assets/examples/`:
- Simple approach chosen over pattern
- Pattern applied and modified
- Pattern avoided (over-engineering case)
