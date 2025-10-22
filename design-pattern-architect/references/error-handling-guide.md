# Error Handling in Design Patterns

Best practices for error handling when implementing design patterns.

---

## Choosing Error Handling Strategy

### throws vs Result Type

**Use `throws` when:**
- Error is exceptional and rare
- Want to propagate errors up call stack
- Using async/await
- Simple error path

```swift
protocol PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult
}

class CreditCardStrategy: PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult {
        guard amount > 0 else {
            throw PaymentError.invalidAmount
        }

        return try await gateway.charge(amount: amount)
    }
}

// Usage
do {
    let result = try await strategy.pay(amount: 100.0)
    print("Success: \(result)")
} catch PaymentError.invalidAmount {
    print("Invalid amount")
} catch {
    print("Unknown error: \(error)")
}
```

**Use `Result<T, E>` when:**
- Error is expected part of business logic
- Want to defer error handling
- Composing multiple operations
- Want to transform errors

```swift
protocol DocumentFactory {
    func create(type: DocumentType) -> Result<Document, DocumentError>
}

class PDFFactory: DocumentFactory {
    func create(type: DocumentType) -> Result<Document, DocumentError> {
        switch type {
        case .pdf:
            return .success(PDFDocument())
        case .word:
            return .failure(.unsupportedType)
        }
    }
}

// Usage
let result = factory.create(type: .pdf)
    .map { $0.render() }
    .mapError { .renderingFailed($0) }

switch result {
case .success(let output):
    print(output)
case .failure(let error):
    handleError(error)
}
```

---

## Pattern-Specific Error Handling

### Factory Method Pattern

**Bad** (crashes):
```swift
class ShapeFactory {
    static func create(type: String) -> Shape {
        switch type {
        case "circle": return Circle()
        default: fatalError("Unknown shape") // ❌ Crashes
        }
    }
}
```

**Good** (type-safe):
```swift
enum ShapeType {
    case circle, square
}

class ShapeFactory {
    static func create(type: ShapeType) -> Shape {
        switch type {
        case .circle: return Circle()
        case .square: return Square()
        }
    }
}
```

**Good** (error handling):
```swift
enum ShapeFactoryError: Error {
    case unknownType(String)
}

class ShapeFactory {
    static func create(typeString: String) throws -> Shape {
        switch typeString.lowercased() {
        case "circle": return Circle()
        case "square": return Square()
        default: throw ShapeFactoryError.unknownType(typeString)
        }
    }
}
```

---

### Builder Pattern

**Validation at Build Time**:
```swift
struct Pizza {
    let size: String
    let crust: String
    let toppings: [String]
}

enum BuilderError: Error {
    case invalidSize
    case noToppings
    case tooManyToppings
}

class PizzaBuilder {
    private var size: String?
    private var crust: String = "Regular"
    private var toppings: [String] = []

    func setSize(_ size: String) -> PizzaBuilder {
        self.size = size
        return self
    }

    func addTopping(_ topping: String) -> PizzaBuilder {
        toppings.append(topping)
        return self
    }

    func build() throws -> Pizza {
        guard let size = size, !size.isEmpty else {
            throw BuilderError.invalidSize
        }

        guard !toppings.isEmpty else {
            throw BuilderError.noToppings
        }

        guard toppings.count <= 10 else {
            throw BuilderError.tooManyToppings
        }

        return Pizza(size: size, crust: crust, toppings: toppings)
    }
}

// Usage
do {
    let pizza = try PizzaBuilder()
        .setSize("Large")
        .addTopping("Pepperoni")
        .build()
} catch BuilderError.invalidSize {
    print("Please specify a size")
} catch BuilderError.noToppings {
    print("Please add at least one topping")
} catch {
    print("Build failed: \(error)")
}
```

---

### Strategy Pattern

**Async Error Handling**:
```swift
enum PaymentError: Error {
    case invalidAmount
    case insufficientFunds
    case networkError(Error)
    case gatewayTimeout
}

protocol PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult
}

class CreditCardStrategy: PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult {
        // Validation
        guard amount > 0 else {
            throw PaymentError.invalidAmount
        }

        // Network call with timeout
        do {
            return try await withTimeout(30) {
                try await self.gateway.charge(amount: amount)
            }
        } catch is TimeoutError {
            throw PaymentError.gatewayTimeout
        } catch {
            throw PaymentError.networkError(error)
        }
    }
}

// Usage with retry logic
func processPayment(strategy: PaymentStrategy, amount: Double) async throws -> PaymentResult {
    var attempts = 0
    let maxAttempts = 3

    while attempts < maxAttempts {
        do {
            return try await strategy.pay(amount: amount)
        } catch PaymentError.gatewayTimeout {
            attempts += 1
            if attempts < maxAttempts {
                try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempts))) * 1_000_000_000)
                continue
            }
            throw PaymentError.gatewayTimeout
        } catch {
            throw error // Non-retryable error
        }
    }

    throw PaymentError.gatewayTimeout
}
```

---

### Observer Pattern

**Error Propagation in Observations**:
```swift
protocol Observer: AnyObject {
    func update(subject: Subject) throws
}

class NewsAgency {
    private var observers: [Observer] = []
    var news: String = ""

    func attach(observer: Observer) {
        observers.append(observer)
    }

    func setNews(_ news: String) {
        self.news = news
        notifyObservers()
    }

    private func notifyObservers() {
        for observer in observers {
            do {
                try observer.update(subject: self)
            } catch {
                print("Observer notification failed: \(error)")
                // Decide: continue or stop?
                // Usually continue to notify others
            }
        }
    }
}
```

---

## Error Handling Best Practices

### 1. Define Meaningful Error Types

**Bad**:
```swift
enum Error: Swift.Error {
    case error
    case failed
}
```

**Good**:
```swift
enum PaymentError: Error {
    case invalidAmount(Double)
    case insufficientFunds(required: Double, available: Double)
    case cardExpired(expiryDate: Date)
    case gatewayError(code: String, message: String)
}
```

### 2. Provide Recovery Information

```swift
enum DocumentError: Error {
    case notFound(path: String)
    case invalidFormat(expected: String, got: String)
    case accessDenied(requiredPermission: String)

    var recoverySuggestion: String {
        switch self {
        case .notFound(let path):
            return "Check if file exists at: \(path)"
        case .invalidFormat(let expected, let got):
            return "Convert \(got) to \(expected) format"
        case .accessDenied(let permission):
            return "Request \(permission) permission from administrator"
        }
    }
}
```

### 3. Layer-Specific Error Handling

```swift
// Domain layer errors
enum PaymentDomainError: Error {
    case invalidAmount
    case insufficientFunds
}

// Infrastructure layer errors
enum PaymentGatewayError: Error {
    case networkError(Error)
    case invalidResponse
}

// Convert infrastructure to domain errors
class PaymentService {
    func processPayment(amount: Double) async throws -> PaymentResult {
        do {
            return try await gateway.charge(amount: amount)
        } catch PaymentGatewayError.networkError {
            throw PaymentDomainError.insufficientFunds // Map to domain
        } catch {
            throw PaymentDomainError.invalidAmount
        }
    }
}
```

### 4. Combine with Logging

```swift
class PaymentProcessor {
    func process(strategy: PaymentStrategy, amount: Double) async throws -> PaymentResult {
        logger.info("Processing payment", metadata: [
            "strategy": "\(type(of: strategy))",
            "amount": "\(amount)"
        ])

        do {
            let result = try await strategy.pay(amount: amount)
            logger.info("Payment successful", metadata: ["result": "\(result)"])
            return result
        } catch {
            logger.error("Payment failed", error: error, metadata: [
                "strategy": "\(type(of: strategy))",
                "amount": "\(amount)"
            ])
            throw error
        }
    }
}
```

---

## Common Pitfalls

### 1. Swallowing Errors

**Bad**:
```swift
func processPayment() {
    do {
        try payment.process()
    } catch {
        // Silently fail ❌
    }
}
```

**Good**:
```swift
func processPayment() throws {
    do {
        try payment.process()
    } catch {
        logger.error("Payment processing failed", error: error)
        throw PaymentError.processingFailed(underlying: error)
    }
}
```

### 2. Generic Error Messages

**Bad**:
```swift
throw NSError(domain: "Error", code: -1, userInfo: nil)
```

**Good**:
```swift
enum ValidationError: LocalizedError {
    case invalidEmail(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail(let email):
            return "Invalid email format: \(email). Expected format: user@domain.com"
        }
    }
}
```

### 3. Not Handling Async Errors

**Bad**:
```swift
Task {
    let result = try await strategy.pay(amount: 100) // Unhandled error ❌
}
```

**Good**:
```swift
Task {
    do {
        let result = try await strategy.pay(amount: 100)
        await updateUI(result)
    } catch {
        await showError(error)
    }
}
```

---

## Testing Error Paths

```swift
class PaymentStrategyTests: XCTestCase {
    func testInvalidAmount() async throws {
        let strategy = CreditCardStrategy()

        do {
            _ = try await strategy.pay(amount: -100)
            XCTFail("Should throw invalidAmount error")
        } catch PaymentError.invalidAmount {
            // Expected
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func testNetworkError() async throws {
        let mockGateway = MockGateway()
        mockGateway.shouldFailWith = NetworkError.timeout

        let strategy = CreditCardStrategy(gateway: mockGateway)

        do {
            _ = try await strategy.pay(amount: 100)
            XCTFail("Should throw network error")
        } catch PaymentError.networkError {
            // Expected
        }
    }
}
```

---

## Summary

**Quick Reference**:
- Use `throws` for exceptional errors and async code
- Use `Result` for expected errors and composition
- Always provide meaningful error types
- Include recovery suggestions
- Test error paths thoroughly
- Never swallow errors silently
- Log errors appropriately

**Pattern Selection**:
- Factory → Type-safe enums + throws for invalid inputs
- Builder → Validation at build() with throws
- Strategy → async throws for I/O operations
- Observer → try in notification loop, decide on failure handling
- Singleton → Usually no errors (initialization only)
