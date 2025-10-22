# Multi-Language Pattern Examples

This guide demonstrates how the same design pattern concepts apply across different programming languages.

---

## Singleton Pattern

### Swift
```swift
class DatabaseConnection {
    static let shared = DatabaseConnection()
    private init() { }

    func query(_ sql: String) {
        print("Executing: \(sql)")
    }
}

// Usage
DatabaseConnection.shared.query("SELECT * FROM users")
```

### TypeScript
```typescript
class DatabaseConnection {
    private static instance: DatabaseConnection;

    private constructor() { }

    public static getInstance(): DatabaseConnection {
        if (!DatabaseConnection.instance) {
            DatabaseConnection.instance = new DatabaseConnection();
        }
        return DatabaseConnection.instance;
    }

    public query(sql: string): void {
        console.log(`Executing: ${sql}`);
    }
}

// Usage
DatabaseConnection.getInstance().query("SELECT * FROM users");
```

### Python
```python
class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def query(self, sql: str):
        print(f"Executing: {sql}")

# Usage
db = DatabaseConnection()
db.query("SELECT * FROM users")
```

### Java
```java
public class DatabaseConnection {
    private static DatabaseConnection instance;

    private DatabaseConnection() { }

    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    public void query(String sql) {
        System.out.println("Executing: " + sql);
    }
}

// Usage
DatabaseConnection.getInstance().query("SELECT * FROM users");
```

**Key Insight**: Same structure (private constructor, static instance) works in all languages.

---

## Factory Method Pattern

### Swift
```swift
enum ShapeType { case circle, square }

protocol Shape {
    func draw()
}

class Circle: Shape {
    func draw() { print("Drawing circle") }
}

class Square: Shape {
    func draw() { print("Drawing square") }
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

### TypeScript
```typescript
enum ShapeType { Circle, Square }

interface Shape {
    draw(): void;
}

class Circle implements Shape {
    draw(): void { console.log("Drawing circle"); }
}

class Square implements Shape {
    draw(): void { console.log("Drawing square"); }
}

class ShapeFactory {
    static create(type: ShapeType): Shape {
        switch (type) {
            case ShapeType.Circle: return new Circle();
            case ShapeType.Square: return new Square();
        }
    }
}
```

### Python
```python
from enum import Enum
from abc import ABC, abstractmethod

class ShapeType(Enum):
    CIRCLE = 1
    SQUARE = 2

class Shape(ABC):
    @abstractmethod
    def draw(self):
        pass

class Circle(Shape):
    def draw(self):
        print("Drawing circle")

class Square(Shape):
    def draw(self):
        print("Drawing square")

class ShapeFactory:
    @staticmethod
    def create(shape_type: ShapeType) -> Shape:
        if shape_type == ShapeType.CIRCLE:
            return Circle()
        elif shape_type == ShapeType.SQUARE:
            return Square()
```

**Key Insight**: Interface/protocol + enum for type safety works universally.

---

## Strategy Pattern

### Swift
```swift
protocol PaymentStrategy {
    func pay(amount: Double) async throws -> String
}

class CreditCardStrategy: PaymentStrategy {
    func pay(amount: Double) async throws -> String {
        return "Paid \(amount) with Credit Card"
    }
}

class PayPalStrategy: PaymentStrategy {
    func pay(amount: Double) async throws -> String {
        return "Paid \(amount) with PayPal"
    }
}

class PaymentProcessor {
    let strategy: PaymentStrategy

    init(strategy: PaymentStrategy) {
        self.strategy = strategy
    }

    func processPayment(amount: Double) async throws {
        let result = try await strategy.pay(amount: amount)
        print(result)
    }
}
```

### TypeScript
```typescript
interface PaymentStrategy {
    pay(amount: number): Promise<string>;
}

class CreditCardStrategy implements PaymentStrategy {
    async pay(amount: number): Promise<string> {
        return `Paid ${amount} with Credit Card`;
    }
}

class PayPalStrategy implements PaymentStrategy {
    async pay(amount: number): Promise<string> {
        return `Paid ${amount} with PayPal`;
    }
}

class PaymentProcessor {
    constructor(private strategy: PaymentStrategy) {}

    async processPayment(amount: number): Promise<void> {
        const result = await this.strategy.pay(amount);
        console.log(result);
    }
}
```

### Python
```python
from abc import ABC, abstractmethod

class PaymentStrategy(ABC):
    @abstractmethod
    async def pay(self, amount: float) -> str:
        pass

class CreditCardStrategy(PaymentStrategy):
    async def pay(self, amount: float) -> str:
        return f"Paid {amount} with Credit Card"

class PayPalStrategy(PaymentStrategy):
    async def pay(self, amount: float) -> str:
        return f"Paid {amount} with PayPal"

class PaymentProcessor:
    def __init__(self, strategy: PaymentStrategy):
        self.strategy = strategy

    async def process_payment(self, amount: float):
        result = await self.strategy.pay(amount)
        print(result)
```

### Go
```go
package main

type PaymentStrategy interface {
    Pay(amount float64) (string, error)
}

type CreditCardStrategy struct{}

func (c *CreditCardStrategy) Pay(amount float64) (string, error) {
    return fmt.Sprintf("Paid %.2f with Credit Card", amount), nil
}

type PayPalStrategy struct{}

func (p *PayPalStrategy) Pay(amount float64) (string, error) {
    return fmt.Sprintf("Paid %.2f with PayPal", amount), nil
}

type PaymentProcessor struct {
    strategy PaymentStrategy
}

func (p *PaymentProcessor) ProcessPayment(amount float64) error {
    result, err := p.strategy.Pay(amount)
    if err != nil {
        return err
    }
    fmt.Println(result)
    return nil
}
```

**Key Insight**: Interface-based polymorphism is the core concept, syntax varies but structure remains identical.

---

## Observer Pattern

### Swift
```swift
protocol Observer: AnyObject {
    func update(temperature: Double)
}

class WeatherStation {
    private var observers: [Observer] = []
    private var temperature: Double = 0.0

    func attach(observer: Observer) {
        observers.append(observer)
    }

    func setTemperature(_ temp: Double) {
        temperature = temp
        notifyObservers()
    }

    private func notifyObservers() {
        observers.forEach { $0.update(temperature: temperature) }
    }
}

class PhoneDisplay: Observer {
    func update(temperature: Double) {
        print("Phone: Temperature is \(temperature)°C")
    }
}
```

### TypeScript
```typescript
interface Observer {
    update(temperature: number): void;
}

class WeatherStation {
    private observers: Observer[] = [];
    private temperature: number = 0;

    attach(observer: Observer): void {
        this.observers.push(observer);
    }

    setTemperature(temp: number): void {
        this.temperature = temp;
        this.notifyObservers();
    }

    private notifyObservers(): void {
        this.observers.forEach(o => o.update(this.temperature));
    }
}

class PhoneDisplay implements Observer {
    update(temperature: number): void {
        console.log(`Phone: Temperature is ${temperature}°C`);
    }
}
```

### Java
```java
interface Observer {
    void update(double temperature);
}

class WeatherStation {
    private List<Observer> observers = new ArrayList<>();
    private double temperature;

    public void attach(Observer observer) {
        observers.add(observer);
    }

    public void setTemperature(double temp) {
        this.temperature = temp;
        notifyObservers();
    }

    private void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(temperature);
        }
    }
}

class PhoneDisplay implements Observer {
    public void update(double temperature) {
        System.out.println("Phone: Temperature is " + temperature + "°C");
    }
}
```

**Key Insight**: Subject maintains observer list, notifies on state change—universal across languages.

---

## Language Feature Mapping

| Pattern Concept | Swift | TypeScript | Python | Java | Go |
|----------------|-------|------------|--------|------|-----|
| **Interface** | `protocol` | `interface` | `ABC` | `interface` | `interface` |
| **Abstract Class** | `class` (not enforced) | `abstract class` | `ABC` | `abstract class` | N/A (use interface) |
| **Singleton** | `static let` | `static` field | `__new__` | `static` field | `sync.Once` |
| **Enum** | `enum` | `enum` | `Enum` | `enum` | `const` + `iota` |
| **Generics** | `<T>` | `<T>` | `[T]` (type hints) | `<T>` | `[T]` (Go 1.18+) |
| **Async** | `async/await` | `async/await` | `async/await` | `CompletableFuture` | `goroutines` |

---

## Universal Pattern Principles

Regardless of language, all patterns share these core elements:

### 1. Abstraction
- Define contracts (interfaces/protocols)
- Separate what from how
- Hide implementation details

### 2. Composition
- Favor composition over inheritance
- Build complex behavior from simple parts
- Runtime flexibility

### 3. Polymorphism
- Same interface, different implementations
- Runtime selection of behavior
- Extensibility without modification

### 4. Encapsulation
- Control access to internals
- Maintain invariants
- Reduce coupling

---

## Adaptation Guidelines

When translating patterns to your language:

1. **Identify the Core Structure**
   - What interfaces exist?
   - What are the key relationships?
   - What behavior varies?

2. **Map to Language Features**
   - Interface → Your language's abstraction mechanism
   - Static → Your language's class-level concept
   - Async → Your language's concurrency model

3. **Follow Language Idioms**
   - Swift: Value types, protocols, extensions
   - TypeScript: Duck typing, type guards
   - Python: Duck typing, decorators, context managers
   - Java: Explicit interfaces, checked exceptions
   - Go: Implicit interfaces, channels, goroutines

4. **Keep the "Why"**
   - Pattern solves same problem regardless of syntax
   - Structure addresses same design forces
   - Trade-offs remain consistent

---

## Real-World Example: Strategy Pattern in Different Contexts

### Mobile App (Swift/Kotlin)
```swift
protocol NavigationStrategy {
    func navigate(from: Location, to: Location) -> Route
}

class DrivingStrategy: NavigationStrategy { }
class WalkingStrategy: NavigationStrategy { }
class PublicTransitStrategy: NavigationStrategy { }
```

### Web Backend (TypeScript/Node)
```typescript
interface CompressionStrategy {
    compress(data: Buffer): Promise<Buffer>;
}

class GzipStrategy implements CompressionStrategy { }
class BrotliStrategy implements CompressionStrategy { }
```

### Data Pipeline (Python)
```python
class DataProcessingStrategy(ABC):
    @abstractmethod
    def process(self, data: DataFrame) -> DataFrame:
        pass

class BatchStrategy(DataProcessingStrategy): pass
class StreamStrategy(DataProcessingStrategy): pass
```

**Same pattern, different domains, different languages—concept remains consistent.**

---

## Summary

**Design patterns are language-agnostic because:**
- They describe **relationships** between objects, not syntax
- They address **universal design problems** (coupling, extensibility, complexity)
- They rely on **fundamental OOP concepts** (abstraction, polymorphism, encapsulation)

**When learning a pattern:**
1. Focus on the **problem** it solves
2. Understand the **structure** (what components, how they relate)
3. Grasp the **consequences** (trade-offs)
4. Adapt the **syntax** to your language

**Code examples in this skill use Swift for:**
- Modern, clean syntax
- Strong type safety
- Clear expression of intent

**But the principles apply to any OOP language you use.**
