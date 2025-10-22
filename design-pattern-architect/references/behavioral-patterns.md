# Behavioral Design Patterns

Patterns that deal with object collaboration and responsibility distribution.

---

## Observer Pattern

### Problem
Define one-to-many dependency so when one object changes state, all dependents are notified.

### When to Use
- Object state changes need to notify other objects
- Don't know how many observers there are
- Want loose coupling between subject and observers

### When NOT to Use
- Platform already provides it (Combine, NotificationCenter, RxSwift)
- One-to-one relationship (use delegate)
- Performance critical (many notifications)

### Structure
```swift
// Subject
protocol Subject {
    func attach(observer: Observer)
    func detach(observer: Observer)
    func notify()
}

// Observer
protocol Observer: AnyObject {
    func update(subject: Subject)
}

// Concrete subject
class NewsAgency: Subject {
    private var observers: [Observer] = []
    var news: String = "" {
        didSet {
            notify()
        }
    }

    func attach(observer: Observer) {
        observers.append(observer)
    }

    func detach(observer: Observer) {
        observers.removeAll { $0 === observer }
    }

    func notify() {
        for observer in observers {
            observer.update(subject: self)
        }
    }
}

// Concrete observers
class NewsChannel: Observer {
    let name: String

    init(name: String) {
        self.name = name
    }

    func update(subject: Subject) {
        if let agency = subject as? NewsAgency {
            print("\(name) received: \(agency.news)")
        }
    }
}

// Usage
let agency = NewsAgency()
let channel1 = NewsChannel(name: "Channel 1")
let channel2 = NewsChannel(name: "Channel 2")

agency.attach(observer: channel1)
agency.attach(observer: channel2)

agency.news = "Breaking news!"
// Both channels notified
```

### Better Alternative: Platform Features
```swift
// Swift Combine (iOS 13+)
import Combine

class NewsAgency {
    @Published var news: String = ""
}

let agency = NewsAgency()
let cancellable = agency.$news
    .sink { news in
        print("Received: \(news)")
    }

agency.news = "Breaking news!" // Automatic notification
```

### Trade-offs
**Pros**:
- Loose coupling between subject and observers
- Dynamic relationships (add/remove at runtime)
- Broadcast communication

**Cons**:
- Unexpected updates
- Memory leaks if not detached properly
- Order of notification is undefined

---

## Strategy Pattern

### Problem
Define family of algorithms, encapsulate each, and make them interchangeable.

### When to Use
- Multiple algorithms for specific task
- Need to switch algorithms at runtime
- Want to eliminate conditional statements

### When NOT to Use
- Only one or two algorithms
- Algorithms don't vary at runtime
- Simple if-else is clearer

### Structure
```swift
// Strategy protocol
protocol PaymentStrategy {
    func pay(amount: Double)
}

// Concrete strategies
class CreditCardStrategy: PaymentStrategy {
    let cardNumber: String

    init(cardNumber: String) {
        self.cardNumber = cardNumber
    }

    func pay(amount: Double) {
        print("Paid $\(amount) using credit card: \(cardNumber)")
    }
}

class PayPalStrategy: PaymentStrategy {
    let email: String

    init(email: String) {
        self.email = email
    }

    func pay(amount: Double) {
        print("Paid $\(amount) using PayPal: \(email)")
    }
}

class CryptoStrategy: PaymentStrategy {
    let walletAddress: String

    init(walletAddress: String) {
        self.walletAddress = walletAddress
    }

    func pay(amount: Double) {
        print("Paid $\(amount) using crypto: \(walletAddress)")
    }
}

// Context
class ShoppingCart {
    private var paymentStrategy: PaymentStrategy?

    func setPaymentStrategy(_ strategy: PaymentStrategy) {
        self.paymentStrategy = strategy
    }

    func checkout(amount: Double) {
        paymentStrategy?.pay(amount: amount)
    }
}

// Usage
let cart = ShoppingCart()

cart.setPaymentStrategy(CreditCardStrategy(cardNumber: "1234-5678"))
cart.checkout(amount: 100.0)

cart.setPaymentStrategy(PayPalStrategy(email: "user@example.com"))
cart.checkout(amount: 50.0)
```

### Variations
**Function-Based Strategy** (simpler):
```swift
typealias PaymentStrategy = (Double) -> Void

class ShoppingCart {
    var paymentStrategy: PaymentStrategy?

    func checkout(amount: Double) {
        paymentStrategy?(amount)
    }
}

// Usage
let cart = ShoppingCart()
cart.paymentStrategy = { amount in
    print("Paid $\(amount) with credit card")
}
cart.checkout(amount: 100.0)
```

### Trade-offs
**Pros**:
- Eliminates conditional statements
- Easy to add new strategies (OCP)
- Runtime algorithm selection

**Cons**:
- Increased number of objects
- Clients must know different strategies
- Communication overhead between strategy and context

---

## Command Pattern

### Problem
Encapsulate request as object to parameterize clients, queue requests, or support undo.

### When to Use
- Need to parameterize objects with operations
- Queue operations, schedule execution
- Support undo/redo
- Log operations

### When NOT to Use
- Simple callbacks suffice
- No undo/redo needed
- No queuing/logging needed

### Structure
```swift
// Command protocol
protocol Command {
    func execute()
    func undo()
}

// Receiver
class Light {
    var isOn = false

    func turnOn() {
        isOn = true
        print("Light is ON")
    }

    func turnOff() {
        isOn = false
        print("Light is OFF")
    }
}

// Concrete commands
class TurnOnCommand: Command {
    let light: Light

    init(light: Light) {
        self.light = light
    }

    func execute() {
        light.turnOn()
    }

    func undo() {
        light.turnOff()
    }
}

class TurnOffCommand: Command {
    let light: Light

    init(light: Light) {
        self.light = light
    }

    func execute() {
        light.turnOff()
    }

    func undo() {
        light.turnOn()
    }
}

// Invoker
class RemoteControl {
    private var history: [Command] = []

    func executeCommand(_ command: Command) {
        command.execute()
        history.append(command)
    }

    func undo() {
        guard let command = history.popLast() else { return }
        command.undo()
    }
}

// Usage
let light = Light()
let remote = RemoteControl()

remote.executeCommand(TurnOnCommand(light: light))  // Light ON
remote.executeCommand(TurnOffCommand(light: light)) // Light OFF
remote.undo()                                       // Light ON (undo OFF)
remote.undo()                                       // Light OFF (undo ON)
```

### Variations
**Macro Command** (composite):
```swift
class MacroCommand: Command {
    private let commands: [Command]

    init(commands: [Command]) {
        self.commands = commands
    }

    func execute() {
        commands.forEach { $0.execute() }
    }

    func undo() {
        commands.reversed().forEach { $0.undo() }
    }
}
```

### Trade-offs
**Pros**:
- Decouples invoker from receiver
- Easy to add new commands (OCP)
- Supports undo/redo
- Supports command queuing/logging

**Cons**:
- Increases number of classes
- Can be overkill for simple operations

---

## State Pattern

### Problem
Allow object to alter behavior when internal state changes.

### When to Use
- Object behavior depends on state
- Large conditionals based on state
- State transitions are explicit

### When NOT to Use
- Few states (simple if-else is clearer)
- State transitions are trivial
- No state-specific behavior

### Structure
```swift
// State protocol
protocol State {
    func insertCoin(context: VendingMachine)
    func selectItem(context: VendingMachine)
    func dispense(context: VendingMachine)
}

// Context
class VendingMachine {
    var state: State

    init() {
        self.state = NoCoinState()
    }

    func setState(_ state: State) {
        self.state = state
    }

    func insertCoin() {
        state.insertCoin(context: self)
    }

    func selectItem() {
        state.selectItem(context: self)
    }

    func dispense() {
        state.dispense(context: self)
    }
}

// Concrete states
class NoCoinState: State {
    func insertCoin(context: VendingMachine) {
        print("Coin inserted")
        context.setState(HasCoinState())
    }

    func selectItem(context: VendingMachine) {
        print("Insert coin first")
    }

    func dispense(context: VendingMachine) {
        print("Insert coin first")
    }
}

class HasCoinState: State {
    func insertCoin(context: VendingMachine) {
        print("Coin already inserted")
    }

    func selectItem(context: VendingMachine) {
        print("Item selected")
        context.setState(DispensingState())
    }

    func dispense(context: VendingMachine) {
        print("Select item first")
    }
}

class DispensingState: State {
    func insertCoin(context: VendingMachine) {
        print("Please wait, dispensing item")
    }

    func selectItem(context: VendingMachine) {
        print("Please wait, dispensing item")
    }

    func dispense(context: VendingMachine) {
        print("Item dispensed")
        context.setState(NoCoinState())
    }
}

// Usage
let machine = VendingMachine()
machine.insertCoin()    // Transitions to HasCoinState
machine.selectItem()    // Transitions to DispensingState
machine.dispense()      // Transitions to NoCoinState
```

### Trade-offs
**Pros**:
- Eliminates large conditional statements
- State-specific behavior is localized
- Makes state transitions explicit
- Easy to add new states (OCP)

**Cons**:
- Increases number of classes
- Can be overkill for simple state machines

---

## Template Method Pattern

### Problem
Define skeleton of algorithm, deferring some steps to subclasses.

### When to Use
- Invariant parts of algorithm should be implemented once
- Subclasses should implement varying behavior
- Common behavior should be localized

### When NOT to Use
- No common algorithm structure
- Subclasses need full control
- Composition would be clearer

### Structure
```swift
// Abstract class (or protocol with default implementation)
class DataProcessor {
    // Template method
    final func process() {
        loadData()
        processData()
        saveData()
    }

    func loadData() {
        // Default implementation or abstract
        fatalError("Must override")
    }

    func processData() {
        fatalError("Must override")
    }

    func saveData() {
        print("Saving data to database")
    }
}

// Concrete implementations
class CSVProcessor: DataProcessor {
    override func loadData() {
        print("Loading CSV file")
    }

    override func processData() {
        print("Processing CSV data")
    }
}

class JSONProcessor: DataProcessor {
    override func loadData() {
        print("Loading JSON file")
    }

    override func processData() {
        print("Processing JSON data")
    }
}

// Usage
let csvProcessor = CSVProcessor()
csvProcessor.process()
// Loads CSV -> Processes CSV -> Saves

let jsonProcessor = JSONProcessor()
jsonProcessor.process()
// Loads JSON -> Processes JSON -> Saves
```

### Swift Alternative (Protocol Extensions):
```swift
protocol DataProcessor {
    func loadData()
    func processData()
    func saveData()
}

extension DataProcessor {
    func process() {
        loadData()
        processData()
        saveData()
    }

    func saveData() {
        print("Saving data to database")
    }
}

struct CSVProcessor: DataProcessor {
    func loadData() { print("Loading CSV") }
    func processData() { print("Processing CSV") }
}
```

### Trade-offs
**Pros**:
- Reuses common code
- Controls algorithm structure
- Lets subclasses override specific steps

**Cons**:
- Requires inheritance (less flexible)
- Can violate Liskov Substitution
- Difficult to understand flow

---

## Chain of Responsibility Pattern

### Problem
Pass request along chain of handlers until one handles it.

### When to Use
- Multiple objects can handle request
- Handler not known in advance
- Want to decouple sender from receivers

### When NOT to Use
- Only one handler
- Request must be handled (no guarantee in chain)
- Simple if-else is clearer

### Structure
```swift
// Handler protocol
protocol SupportHandler {
    var next: SupportHandler? { get set }
    func handleRequest(request: SupportRequest)
}

// Support request
struct SupportRequest {
    enum Priority {
        case low, medium, high, critical
    }

    let priority: Priority
    let description: String
}

// Concrete handlers
class Level1Support: SupportHandler {
    var next: SupportHandler?

    func handleRequest(request: SupportRequest) {
        if request.priority == .low {
            print("Level 1: Handling request - \(request.description)")
        } else {
            print("Level 1: Escalating...")
            next?.handleRequest(request: request)
        }
    }
}

class Level2Support: SupportHandler {
    var next: SupportHandler?

    func handleRequest(request: SupportRequest) {
        if request.priority == .medium {
            print("Level 2: Handling request - \(request.description)")
        } else {
            print("Level 2: Escalating...")
            next?.handleRequest(request: request)
        }
    }
}

class ManagerSupport: SupportHandler {
    var next: SupportHandler?

    func handleRequest(request: SupportRequest) {
        print("Manager: Handling critical request - \(request.description)")
    }
}

// Usage
let level1 = Level1Support()
let level2 = Level2Support()
let manager = ManagerSupport()

level1.next = level2
level2.next = manager

let request1 = SupportRequest(priority: .low, description: "Password reset")
level1.handleRequest(request: request1) // Handled by Level 1

let request2 = SupportRequest(priority: .critical, description: "Server down")
level1.handleRequest(request: request2) // Escalates to Manager
```

### Simple Alternative (Array of Handlers):
```swift
typealias Handler = (SupportRequest) -> Bool

let handlers: [Handler] = [
    { request in
        guard request.priority == .low else { return false }
        print("Level 1 handled")
        return true
    },
    { request in
        guard request.priority == .medium else { return false }
        print("Level 2 handled")
        return true
    },
    { request in
        print("Manager handled")
        return true
    }
]

func handleRequest(_ request: SupportRequest) {
    for handler in handlers {
        if handler(request) { break }
    }
}
```

### Trade-offs
**Pros**:
- Decouples sender from receiver
- Easy to add new handlers
- Flexible responsibility assignment

**Cons**:
- No guarantee request will be handled
- Can be hard to debug
- Performance overhead

---

## Iterator Pattern

### Problem
Access elements of collection without exposing underlying representation.

### When to Use
- Need uniform way to traverse collection
- Support multiple traversal methods
- Hide internal structure

### When NOT to Use
- Language provides iterators built-in (most modern languages)
- Simple array access suffices
- Only one traversal method needed

### Structure
```swift
// Swift already provides iterators via Sequence protocol
// But here's custom implementation for learning

protocol Iterator {
    associatedtype Element
    func hasNext() -> Bool
    func next() -> Element?
}

protocol Collection {
    associatedtype IteratorType: Iterator
    func createIterator() -> IteratorType
}

class BookCollection: Collection {
    private var books: [String] = []

    func addBook(_ book: String) {
        books.append(book)
    }

    func createIterator() -> BookIterator {
        return BookIterator(books: books)
    }
}

class BookIterator: Iterator {
    private let books: [String]
    private var index = 0

    init(books: [String]) {
        self.books = books
    }

    func hasNext() -> Bool {
        return index < books.count
    }

    func next() -> String? {
        guard hasNext() else { return nil }
        let book = books[index]
        index += 1
        return book
    }
}

// Usage
let collection = BookCollection()
collection.addBook("Design Patterns")
collection.addBook("Clean Code")

let iterator = collection.createIterator()
while iterator.hasNext() {
    if let book = iterator.next() {
        print(book)
    }
}
```

### Swift Built-In (Preferred):
```swift
struct BookCollection: Sequence {
    private var books: [String] = []

    mutating func addBook(_ book: String) {
        books.append(book)
    }

    func makeIterator() -> Array<String>.Iterator {
        return books.makeIterator()
    }
}

// Usage
var collection = BookCollection()
collection.addBook("Design Patterns")

for book in collection {
    print(book)
}
```

### Trade-offs
**Pros**:
- Hides internal structure
- Multiple simultaneous traversals
- Uniform interface for different collections

**Cons**:
- More complex than direct access
- Usually unnecessary (use built-in iterators)

---

## Pattern Comparison

| Pattern | Problem | When to Use | Complexity |
|---------|---------|-------------|------------|
| Observer | One-to-many notification | State change broadcasts | Medium |
| Strategy | Swap algorithms | Runtime algorithm selection | Low |
| Command | Encapsulate operations | Undo/redo, queuing | Medium |
| State | State-dependent behavior | Explicit state transitions | Medium |
| Template Method | Algorithm skeleton | Common algorithm structure | Low |
| Chain of Responsibility | Handle request in chain | Multiple potential handlers | Medium |
| Iterator | Traverse collection | Uniform traversal | Low |

**Rule of Thumb**: Prefer platform features (Combine, Closures) over implementing patterns from scratch.
