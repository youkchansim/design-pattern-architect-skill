# Object-Oriented Principles Reference

## SOLID Principles

### 1. Single Responsibility Principle (SRP)

**Definition**: A class should have one, and only one, reason to change.

**Problem it Solves**:
- Reduces coupling between unrelated functionalities
- Makes code easier to understand and maintain
- Improves testability

**Violation Signs**:
- Class name contains "And", "Manager", "Handler"
- Multiple unrelated methods
- Changes in different features require modifying the same class

**Example Violation**:
```swift
class UserManager {
    func validateUser() { }
    func saveToDatabase() { }
    func sendEmail() { }
    func generateReport() { }
}
```

**Refactored**:
```swift
class UserValidator { func validate() { } }
class UserRepository { func save() { } }
class EmailService { func send() { } }
class ReportGenerator { func generate() { } }
```

**When to Violate**: Small, cohesive utilities that truly do one conceptual thing despite multiple technical operations.

---

### 2. Open/Closed Principle (OCP)

**Definition**: Software entities should be open for extension but closed for modification.

**Problem it Solves**:
- Enables adding new features without changing existing code
- Reduces risk of breaking existing functionality
- Promotes code reusability

**Violation Signs**:
- Frequent if-else or switch statements on type
- Adding new feature requires modifying existing classes
- Copy-pasting code with minor variations

**Example Violation**:
```swift
class PaymentProcessor {
    func process(type: String) {
        if type == "credit" { /* ... */ }
        else if type == "debit" { /* ... */ }
        else if type == "paypal" { /* ... */ }
        // Adding new payment method requires modifying this
    }
}
```

**Refactored**:
```swift
protocol PaymentMethod {
    func process()
}

class CreditCardPayment: PaymentMethod { }
class DebitCardPayment: PaymentMethod { }
class PayPalPayment: PaymentMethod { }
// Adding new payment method: just add new class
```

**When to Violate**: When abstraction cost exceeds benefits (e.g., truly one-off, never-changing logic).

---

### 3. Liskov Substitution Principle (LSP)

**Definition**: Subtypes must be substitutable for their base types without altering program correctness.

**Problem it Solves**:
- Ensures inheritance hierarchies are logically sound
- Prevents surprising behavior in polymorphic code
- Maintains contract integrity

**Violation Signs**:
- Subclass throws exceptions for base class methods
- Subclass returns different type or null unexpectedly
- Subclass has stricter preconditions or weaker postconditions

**Example Violation**:
```swift
class Bird {
    func fly() { /* flies */ }
}

class Penguin: Bird {
    override func fly() {
        fatalError("Penguins can't fly") // LSP violation!
    }
}
```

**Refactored**:
```swift
protocol Bird { }
protocol FlyingBird: Bird {
    func fly()
}

class Sparrow: FlyingBird { }
class Penguin: Bird { } // No fly() method
```

**When to Violate**: Rarely. LSP violations usually indicate poor abstraction design.

---

### 4. Interface Segregation Principle (ISP)

**Definition**: Clients should not be forced to depend on interfaces they don't use.

**Problem it Solves**:
- Reduces unnecessary dependencies
- Makes interfaces more focused and cohesive
- Improves code maintainability

**Violation Signs**:
- Implementing empty or throwing methods
- Interface has methods unrelated to some implementers
- "Fat interfaces" with many methods

**Example Violation**:
```swift
protocol Worker {
    func work()
    func eat()
    func sleep()
}

class RobotWorker: Worker {
    func work() { /* works */ }
    func eat() { /* robots don't eat! */ }
    func sleep() { /* robots don't sleep! */ }
}
```

**Refactored**:
```swift
protocol Workable {
    func work()
}

protocol Biological {
    func eat()
    func sleep()
}

class HumanWorker: Workable, Biological { }
class RobotWorker: Workable { }
```

**When to Violate**: When all implementers genuinely need all methods (rare for large interfaces).

---

### 5. Dependency Inversion Principle (DIP)

**Definition**: High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Problem it Solves**:
- Reduces coupling between layers
- Makes code more testable (enables mocking)
- Facilitates changing implementations

**Violation Signs**:
- Business logic directly instantiates infrastructure classes
- Hard to test without real database/network
- Changing database requires changing business logic

**Example Violation**:
```swift
class OrderService {
    let database = MySQLDatabase() // Direct dependency!

    func placeOrder() {
        database.save()
    }
}
```

**Refactored**:
```swift
protocol Database {
    func save()
}

class OrderService {
    let database: Database // Depends on abstraction

    init(database: Database) {
        self.database = database
    }
}

class MySQLDatabase: Database { }
class MongoDatabase: Database { }
```

**When to Violate**: For framework-level code or when abstractions add no value (e.g., Math.sqrt()).

---

## Additional Principles

### DRY (Don't Repeat Yourself)

**Definition**: Every piece of knowledge should have a single, unambiguous representation.

**Problem it Solves**:
- Reduces maintenance burden
- Ensures consistency
- Makes changes easier

**When to Apply**: When same logic appears in multiple places.

**When NOT to Apply**:
- Superficially similar code with different reasons to change
- Premature abstraction before patterns emerge

---

### KISS (Keep It Simple, Stupid)

**Definition**: Simplicity should be a key goal; unnecessary complexity should be avoided.

**Problem it Solves**:
- Easier to understand and maintain
- Fewer bugs
- Faster development

**When to Apply**: Always. Prefer simple solution unless there's clear need for complexity.

**Red Flags of Complexity**:
- Hard to explain design to others
- Requires extensive documentation
- Multiple levels of abstraction for simple task

---

### YAGNI (You Aren't Gonna Need It)

**Definition**: Don't add functionality until it's necessary.

**Problem it Solves**:
- Reduces over-engineering
- Saves development time
- Keeps codebase lean

**When to Apply**: When tempted to add "future-proofing" features.

**When to Ignore**: When removing feature later would be extremely costly (e.g., database schema design).

---

## Principle Selection Guide

### Problem: Hard to Test
**Apply**: DIP (Dependency Inversion)
**Why**: Enables mocking dependencies

### Problem: Fragile Code (Changes Break Things)
**Apply**: OCP (Open/Closed), SRP (Single Responsibility)
**Why**: Isolates changes to specific areas

### Problem: Confusing Inheritance
**Apply**: LSP (Liskov Substitution)
**Why**: Ensures proper subtyping

### Problem: Code Duplication
**Apply**: DRY
**Why**: Centralizes knowledge

### Problem: Over-Complicated Design
**Apply**: KISS, YAGNI
**Why**: Simplifies unnecessarily complex code

---

## Over-Engineering Warning Signs

When applying principles, watch for:
1. **Abstraction for its own sake**: Not all code needs interfaces
2. **Premature generalization**: Solve today's problem, not imaginary future ones
3. **Analysis paralysis**: Perfect design prevents shipping
4. **Principle conflicts**: Sometimes principles conflict—choose pragmatically

**Golden Rule**: Principles are guidelines, not laws. Break them when breaking them produces simpler, more maintainable code.
