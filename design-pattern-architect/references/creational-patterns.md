# Creational Design Patterns

Patterns that deal with object creation mechanisms.

---

## Singleton Pattern

### Problem
Need exactly one instance of a class that's globally accessible.

### When to Use
- Shared resource (configuration, logger, cache)
- Coordinate system-wide actions
- Global state is genuinely required

### When NOT to Use
- Just for convenience (use DI instead)
- Testing becomes difficult
- Creates hidden dependencies
- Can be replaced with dependency injection

### Structure
```swift
class DatabaseConnection {
    static let shared = DatabaseConnection()

    private init() {
        // Private init prevents external instantiation
    }

    func query() { }
}

// Usage
DatabaseConnection.shared.query()
```

### Variations

**Note on Thread-Safety in Swift**:
The basic `static let` implementation shown above is already thread-safe in Swift. The Swift runtime guarantees that `static let` properties are initialized lazily and atomically, making additional synchronization unnecessary in most cases.

**Custom Lazy Initialization** (if needed for complex initialization):
```swift
class ThreadSafeManager {
    private static var _shared: ThreadSafeManager?
    private static let queue = DispatchQueue(label: "singleton.queue")

    static var shared: ThreadSafeManager {
        queue.sync {
            if _shared == nil {
                _shared = ThreadSafeManager()
            }
            return _shared!
        }
    }

    private init() {
        // Complex initialization logic
    }
}
```

**Why not NSLock?** While NSLock works, DispatchQueue is more idiomatic in Swift and integrates better with GCD. For simple cases, stick with `static let`.

### Trade-offs
**Pros**:
- Controlled access to sole instance
- Lazy initialization possible
- Easy global access

**Cons**:
- Global state (testing nightmare)
- Hidden dependencies
- Violates Single Responsibility (controls instance + business logic)
- Difficult to mock in tests

### Better Alternative: Dependency Injection
```swift
class App {
    let database: Database

    init(database: Database = RealDatabase()) {
        self.database = database
    }
}

// Use single instance via DI container
let sharedDB = RealDatabase()
let app = App(database: sharedDB)
```

---

## Factory Method Pattern

### Problem
Need to create objects without specifying exact class.

### When to Use
- Object creation logic is complex
- Subclasses decide which class to instantiate
- Want to defer instantiation to subclasses

### When NOT to Use
- Simple object creation (just use initializer)
- Only one type is ever created
- No variation in creation logic

### Structure
```swift
protocol Product {
    func operation()
}

class ConcreteProductA: Product {
    func operation() { print("Product A") }
}

class ConcreteProductB: Product {
    func operation() { print("Product B") }
}

protocol Creator {
    func factoryMethod() -> Product
}

class ConcreteCreatorA: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductA()
    }
}

class ConcreteCreatorB: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductB()
    }
}
```

### Variations
**Simple Factory with Type Safety** (not official GoF pattern, but practical):
```swift
enum ShapeType {
    case circle
    case square
}

enum ShapeFactoryError: Error {
    case unknownType(String)
    case creationFailed
}

class ShapeFactory {
    // Type-safe version (recommended)
    static func create(type: ShapeType) -> Shape {
        switch type {
        case .circle: return Circle()
        case .square: return Square()
        }
    }

    // String-based version with error handling
    static func create(typeString: String) throws -> Shape {
        switch typeString.lowercased() {
        case "circle": return Circle()
        case "square": return Square()
        default: throw ShapeFactoryError.unknownType(typeString)
        }
    }
}

// Usage
let shape = ShapeFactory.create(type: .circle) // Compile-time safety
let shape2 = try? ShapeFactory.create(typeString: "circle") // Runtime safety
```

**Parameterized Factory with Result Type**:
```swift
class DocumentFactory {
    func create(type: DocumentType, config: Config) -> Result<Document, DocumentError> {
        switch type {
        case .pdf:
            guard config.isValid else {
                return .failure(.invalidConfiguration)
            }
            return .success(PDFDocument(config: config))
        case .word:
            return .success(WordDocument(config: config))
        }
    }
}

// Usage
switch factory.create(type: .pdf, config: config) {
case .success(let document):
    document.save()
case .failure(let error):
    handleError(error)
}
```

### Trade-offs
**Pros**:
- Decouples client from concrete classes
- Easier to add new product types (OCP)
- Centralizes creation logic

**Cons**:
- More classes/protocols
- Can be overkill for simple creation
- Requires subclassing

---

## Abstract Factory Pattern

### Problem
Create families of related objects without specifying concrete classes.

### When to Use
- System needs multiple families of related products
- Products must be used together (consistency required)
- Want to provide product library with only interfaces exposed

### When NOT to Use
- Only one product family exists
- Products are unrelated
- Simple Factory would suffice

### Structure
```swift
// Abstract products
protocol Button { func render() }
protocol Checkbox { func render() }

// Concrete products - iOS
class IOSButton: Button {
    func render() { print("iOS Button") }
}
class IOSCheckbox: Checkbox {
    func render() { print("iOS Checkbox") }
}

// Concrete products - Android
class AndroidButton: Button {
    func render() { print("Android Button") }
}
class AndroidCheckbox: Checkbox {
    func render() { print("Android Checkbox") }
}

// Abstract factory
protocol GUIFactory {
    func createButton() -> Button
    func createCheckbox() -> Checkbox
}

// Concrete factories
class IOSFactory: GUIFactory {
    func createButton() -> Button { IOSButton() }
    func createCheckbox() -> Checkbox { IOSCheckbox() }
}

class AndroidFactory: GUIFactory {
    func createButton() -> Button { AndroidButton() }
    func createCheckbox() -> Checkbox { AndroidCheckbox() }
}

// Client
class Application {
    let factory: GUIFactory

    init(factory: GUIFactory) {
        self.factory = factory
    }

    func createUI() {
        let button = factory.createButton()
        let checkbox = factory.createCheckbox()
        button.render()
        checkbox.render()
    }
}
```

### Trade-offs
**Pros**:
- Ensures product family consistency
- Isolates concrete classes
- Easy to swap product families

**Cons**:
- Lots of classes/protocols
- Adding new product type requires changing all factories
- Can be over-engineered for simple cases

---

## Builder Pattern

### Problem
Construct complex objects step by step with many optional parameters.

### When to Use
- Object has many parameters (especially optional ones)
- Construction process must allow different representations
- Want immutable objects with many fields

### When NOT to Use
- Object is simple (few parameters)
- Language supports default parameters well
- All parameters are required

### Structure
```swift
struct Pizza {
    let size: String
    let crust: String
    let toppings: [String]
    let cheese: String
    let sauce: String
}

class PizzaBuilder {
    private var size: String = "Medium"
    private var crust: String = "Regular"
    private var toppings: [String] = []
    private var cheese: String = "Mozzarella"
    private var sauce: String = "Tomato"

    func setSize(_ size: String) -> PizzaBuilder {
        self.size = size
        return self
    }

    func setCrust(_ crust: String) -> PizzaBuilder {
        self.crust = crust
        return self
    }

    func addTopping(_ topping: String) -> PizzaBuilder {
        self.toppings.append(topping)
        return self
    }

    func build() -> Pizza {
        return Pizza(
            size: size,
            crust: crust,
            toppings: toppings,
            cheese: cheese,
            sauce: sauce
        )
    }
}

// Usage
let pizza = PizzaBuilder()
    .setSize("Large")
    .setCrust("Thin")
    .addTopping("Pepperoni")
    .addTopping("Mushrooms")
    .build()
```

### Variations
**Director + Builder** (for complex construction steps):
```swift
class PizzaDirector {
    let builder: PizzaBuilder

    init(builder: PizzaBuilder) {
        self.builder = builder
    }

    func makeHawaiianPizza() -> Pizza {
        return builder
            .setSize("Large")
            .setCrust("Thick")
            .addTopping("Ham")
            .addTopping("Pineapple")
            .build()
    }

    func makeMargherita() -> Pizza {
        return builder
            .setSize("Medium")
            .setCrust("Thin")
            .addTopping("Basil")
            .build()
    }
}
```

**Fluent Builder** (method chaining, shown above)

**Simple Alternative** (Swift-specific):
```swift
struct Pizza {
    let size: String
    let crust: String
    let toppings: [String]

    init(
        size: String = "Medium",
        crust: String = "Regular",
        toppings: [String] = []
    ) {
        self.size = size
        self.crust = crust
        self.toppings = toppings
    }
}

// Usage - cleaner for simple cases
let pizza = Pizza(size: "Large", toppings: ["Pepperoni"])
```

### Trade-offs
**Pros**:
- Separates construction from representation
- Fine-grained control over construction
- Immutable objects with many parameters
- Readable code for complex construction

**Cons**:
- More verbose than default parameters
- Additional class overhead
- Overkill for simple objects

---

## Prototype Pattern

### Problem
Create new objects by copying existing ones.

### When to Use
- Object creation is expensive
- Need many variations of similar objects
- Want to avoid subclass explosion

### When NOT to Use
- Object creation is cheap
- Deep copying is complex (circular references)
- Language doesn't support cloning well

### Structure (Swift)
```swift
protocol Prototype {
    func clone() -> Self
}

class Shape: Prototype {
    var color: String
    var x: Int
    var y: Int

    init(color: String, x: Int, y: Int) {
        self.color = color
        self.x = x
        self.y = y
    }

    func clone() -> Self {
        return type(of: self).init(color: color, x: x, y: y)
    }

    required init(color: String, x: Int, y: Int) {
        self.color = color
        self.x = x
        self.y = y
    }
}

class Circle: Shape {
    var radius: Int

    init(color: String, x: Int, y: Int, radius: Int) {
        self.radius = radius
        super.init(color: color, x: x, y: y)
    }

    required init(color: String, x: Int, y: Int) {
        self.radius = 0
        super.init(color: color, x: x, y: y)
    }

    override func clone() -> Self {
        return Circle(color: color, x: x, y: y, radius: radius) as! Self
    }
}

// Usage
let original = Circle(color: "red", x: 10, y: 20, radius: 5)
let copy = original.clone()
```

### Trade-offs
**Pros**:
- Avoid expensive creation
- Simplify object creation
- Runtime configuration

**Cons**:
- Deep vs shallow copy complexity
- Circular references problems
- Often unnecessary in modern languages

### Better Alternative: Value Types (Swift)
```swift
struct Circle {
    var color: String
    var x: Int
    var y: Int
    var radius: Int
}

// Automatic copying
let original = Circle(color: "red", x: 10, y: 20, radius: 5)
let copy = original // Value type - automatic copy
```

---

## Pattern Comparison

| Pattern | Use Case | Complexity | When to Avoid |
|---------|----------|------------|---------------|
| Singleton | One instance | Low | Testing needed |
| Factory Method | Defer instantiation | Medium | Simple creation |
| Abstract Factory | Product families | High | Single family |
| Builder | Many parameters | Medium | Few parameters |
| Prototype | Copy expensive objects | Medium | Cheap creation |

**Rule of Thumb**: Start simple. Add patterns only when simple approach becomes painful.
