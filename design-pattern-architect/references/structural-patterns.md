# Structural Design Patterns

Patterns that deal with object composition and relationships between entities.

---

## Adapter Pattern

### Problem
Make incompatible interfaces work together.

### When to Use
- Integrating third-party library with different interface
- Legacy code doesn't match new interface
- Want to use existing class with incompatible interface

### When NOT to Use
- Interfaces are already compatible
- Can modify source code directly
- Simple wrapper function would suffice

### Structure
```swift
// Target interface (what client expects)
protocol MediaPlayer {
    func play(fileName: String)
}

// Adaptee (existing interface that's incompatible)
class AdvancedMediaPlayer {
    func playVlc(fileName: String) {
        print("Playing VLC file: \(fileName)")
    }

    func playMp4(fileName: String) {
        print("Playing MP4 file: \(fileName)")
    }
}

// Adapter (makes Adaptee compatible with Target)
class MediaAdapter: MediaPlayer {
    let advancedPlayer = AdvancedMediaPlayer()

    func play(fileName: String) {
        if fileName.hasSuffix(".vlc") {
            advancedPlayer.playVlc(fileName: fileName)
        } else if fileName.hasSuffix(".mp4") {
            advancedPlayer.playMp4(fileName: fileName)
        }
    }
}

// Client
class AudioPlayer: MediaPlayer {
    let adapter = MediaAdapter()

    func play(fileName: String) {
        adapter.play(fileName: fileName)
    }
}
```

### Variations
**Class Adapter** (using inheritance):
```swift
// When inheritance is possible
class MediaAdapter: AdvancedMediaPlayer, MediaPlayer {
    func play(fileName: String) {
        if fileName.hasSuffix(".vlc") {
            playVlc(fileName: fileName)
        } else if fileName.hasSuffix(".mp4") {
            playMp4(fileName: fileName)
        }
    }
}
```

**Two-Way Adapter**:
```swift
protocol TargetA { func requestA() }
protocol TargetB { func requestB() }

class TwoWayAdapter: TargetA, TargetB {
    let adapteeA: AdapteeA
    let adapteeB: AdapteeB

    func requestA() { adapteeA.specificRequestA() }
    func requestB() { adapteeB.specificRequestB() }
}
```

### Trade-offs
**Pros**:
- Reuse existing code without modification
- Decouples client from adaptee
- Single Responsibility (conversion logic isolated)

**Cons**:
- Increased complexity
- Sometimes simpler to just change interface
- Extra indirection

---

## Bridge Pattern

### Problem
Decouple abstraction from implementation so both can vary independently.

### When to Use
- Want to avoid permanent binding between abstraction and implementation
- Both abstraction and implementation should be extensible
- Changes in implementation shouldn't affect client code

### When NOT to Use
- Simple hierarchy suffices
- Abstraction and implementation don't vary independently
- Only one implementation exists

### Structure
```swift
// Implementation interface
protocol DrawingAPI {
    func drawCircle(x: Int, y: Int, radius: Int)
}

// Concrete implementations
class DrawingAPI1: DrawingAPI {
    func drawCircle(x: Int, y: Int, radius: Int) {
        print("API1: Circle at (\(x),\(y)) radius \(radius)")
    }
}

class DrawingAPI2: DrawingAPI {
    func drawCircle(x: Int, y: Int, radius: Int) {
        print("API2: Circle at (\(x),\(y)) radius \(radius)")
    }
}

// Abstraction
protocol Shape {
    var drawingAPI: DrawingAPI { get }
    func draw()
}

// Refined abstraction
class CircleShape: Shape {
    let drawingAPI: DrawingAPI
    let x: Int
    let y: Int
    let radius: Int

    init(x: Int, y: Int, radius: Int, drawingAPI: DrawingAPI) {
        self.x = x
        self.y = y
        self.radius = radius
        self.drawingAPI = drawingAPI
    }

    func draw() {
        drawingAPI.drawCircle(x: x, y: y, radius: radius)
    }
}

// Usage
let circle1 = CircleShape(x: 1, y: 2, radius: 3, drawingAPI: DrawingAPI1())
let circle2 = CircleShape(x: 5, y: 7, radius: 11, drawingAPI: DrawingAPI2())
circle1.draw() // Uses API1
circle2.draw() // Uses API2
```

### Trade-offs
**Pros**:
- Decouples interface from implementation
- Improved extensibility (both sides vary independently)
- Hides implementation details from client

**Cons**:
- Increased complexity
- More classes
- May be overkill for simple scenarios

---

## Composite Pattern

### Problem
Treat individual objects and compositions uniformly.

### When to Use
- Part-whole hierarchies (tree structures)
- Want to treat leaf and composite objects uniformly
- Recursive structures (files/folders, UI components)

### When NOT to Use
- Flat structure (no hierarchy)
- Different operations for leaf vs composite
- Performance critical (extra indirection)

### Structure
```swift
// Component
protocol FileSystemComponent {
    var name: String { get }
    func getSize() -> Int
    func display(indent: String)
}

// Leaf
class File: FileSystemComponent {
    let name: String
    let size: Int

    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }

    func getSize() -> Int {
        return size
    }

    func display(indent: String = "") {
        print("\(indent)- \(name) (\(size) bytes)")
    }
}

// Composite
class Folder: FileSystemComponent {
    let name: String
    private var children: [FileSystemComponent] = []

    init(name: String) {
        self.name = name
    }

    func add(_ component: FileSystemComponent) {
        children.append(component)
    }

    func remove(_ component: FileSystemComponent) {
        children.removeAll { $0.name == component.name }
    }

    func getSize() -> Int {
        return children.reduce(0) { $0 + $1.getSize() }
    }

    func display(indent: String = "") {
        print("\(indent)+ \(name)/")
        for child in children {
            child.display(indent: indent + "  ")
        }
    }
}

// Usage
let root = Folder(name: "root")
let documents = Folder(name: "documents")
documents.add(File(name: "resume.pdf", size: 1024))
documents.add(File(name: "cover.docx", size: 512))

root.add(documents)
root.add(File(name: "readme.txt", size: 256))

root.display()
print("Total size: \(root.getSize())")
```

### Trade-offs
**Pros**:
- Simplifies client code (uniform treatment)
- Easy to add new component types
- Natural tree structure representation

**Cons**:
- Can make design overly general
- Type safety challenges (leaf vs composite)
- May make it harder to restrict component types

---

## Decorator Pattern

### Problem
Add responsibilities to objects dynamically without subclassing.

### When to Use
- Need to add responsibilities to individual objects, not entire class
- Responsibilities should be addable/removable at runtime
- Subclassing would lead to class explosion

### When NOT to Use
- Simple inheritance suffices
- Decorators would create confusion
- Need to remove decorations (complex)

### Structure
```swift
// Component
protocol Coffee {
    func cost() -> Double
    func description() -> String
}

// Concrete component
class SimpleCoffee: Coffee {
    func cost() -> Double { 2.0 }
    func description() -> String { "Simple coffee" }
}

// Decorator base
class CoffeeDecorator: Coffee {
    let decoratedCoffee: Coffee

    init(_ coffee: Coffee) {
        self.decoratedCoffee = coffee
    }

    func cost() -> Double {
        decoratedCoffee.cost()
    }

    func description() -> String {
        decoratedCoffee.description()
    }
}

// Concrete decorators
class MilkDecorator: CoffeeDecorator {
    override func cost() -> Double {
        decoratedCoffee.cost() + 0.5
    }

    override func description() -> String {
        decoratedCoffee.description() + ", milk"
    }
}

class SugarDecorator: CoffeeDecorator {
    override func cost() -> Double {
        decoratedCoffee.cost() + 0.2
    }

    override func description() -> String {
        decoratedCoffee.description() + ", sugar"
    }
}

// Usage
var coffee: Coffee = SimpleCoffee()
print("\(coffee.description()): $\(coffee.cost())")

coffee = MilkDecorator(coffee)
print("\(coffee.description()): $\(coffee.cost())")

coffee = SugarDecorator(coffee)
print("\(coffee.description()): $\(coffee.cost())")
```

### Variations
**Swift-Specific (Protocol Extensions)**:
```swift
protocol Coffee {
    var cost: Double { get }
    var description: String { get }
}

extension Coffee {
    func withMilk() -> Coffee {
        return MilkCoffee(base: self)
    }

    func withSugar() -> Coffee {
        return SugarCoffee(base: self)
    }
}

// Usage with method chaining
let coffee = SimpleCoffee()
    .withMilk()
    .withSugar()
```

### Trade-offs
**Pros**:
- More flexible than inheritance
- Responsibilities added/removed at runtime
- Avoids feature-laden classes at top of hierarchy

**Cons**:
- Lots of small objects
- Can be confusing (many layers)
- Decorators aren't transparent to component

---

## Facade Pattern

### Problem
Provide simplified interface to complex subsystem.

### When to Use
- Complex subsystem with many classes
- Want to reduce dependencies on subsystem
- Layer your subsystems

### When NOT to Use
- Subsystem is already simple
- Clients need fine-grained control
- Facade would just delegate everything

### Structure
```swift
// Complex subsystem classes
class CPU {
    func freeze() { print("CPU: Freeze") }
    func jump(position: Int) { print("CPU: Jump to \(position)") }
    func execute() { print("CPU: Execute") }
}

class Memory {
    func load(position: Int, data: [Byte]) {
        print("Memory: Load data at \(position)")
    }
}

class HardDrive {
    func read(sector: Int, size: Int) -> [Byte] {
        print("HardDrive: Read sector \(sector)")
        return []
    }
}

// Facade
class ComputerFacade {
    private let cpu = CPU()
    private let memory = Memory()
    private let hardDrive = HardDrive()

    func start() {
        print("Computer starting...")
        cpu.freeze()
        let bootData = hardDrive.read(sector: 0, size: 1024)
        memory.load(position: 0, data: bootData)
        cpu.jump(position: 0)
        cpu.execute()
        print("Computer started!")
    }
}

// Usage
let computer = ComputerFacade()
computer.start() // Simple interface to complex process
```

### Trade-offs
**Pros**:
- Simplifies complex subsystem
- Reduces client dependencies
- Promotes loose coupling

**Cons**:
- Can become god object
- May limit access to advanced features
- Extra layer of abstraction

---

## Proxy Pattern

### Problem
Provide surrogate or placeholder for another object to control access.

### When to Use
- **Virtual Proxy**: Expensive object creation (lazy loading)
- **Protection Proxy**: Access control
- **Remote Proxy**: Remote object representation
- **Caching Proxy**: Cache expensive operations

### When NOT to Use
- Direct access is simpler and sufficient
- Overhead isn't justified
- Adds unnecessary indirection

### Structure
```swift
// Subject interface
protocol Image {
    func display()
}

// Real subject
class RealImage: Image {
    let filename: String

    init(filename: String) {
        self.filename = filename
        loadFromDisk()
    }

    func loadFromDisk() {
        print("Loading image: \(filename)")
    }

    func display() {
        print("Displaying image: \(filename)")
    }
}

// Proxy
class ImageProxy: Image {
    private let filename: String
    private var realImage: RealImage?

    init(filename: String) {
        self.filename = filename
    }

    func display() {
        if realImage == nil {
            realImage = RealImage(filename: filename) // Lazy loading
        }
        realImage?.display()
    }
}

// Usage
let image: Image = ImageProxy(filename: "photo.jpg")
// Image not loaded yet
image.display() // Now it's loaded
image.display() // Uses already loaded image
```

### Variations
**Protection Proxy** (access control):
```swift
class ProtectedDocument: Document {
    let realDocument: RealDocument
    let userRole: UserRole

    func read() -> String {
        guard userRole.hasReadPermission else {
            return "Access denied"
        }
        return realDocument.read()
    }

    func write(content: String) {
        guard userRole.hasWritePermission else {
            print("Access denied")
            return
        }
        realDocument.write(content: content)
    }
}
```

**Caching Proxy**:
```swift
class CachingProxy: DataService {
    let realService: RealDataService
    var cache: [String: Data] = [:]

    func fetchData(key: String) -> Data? {
        if let cached = cache[key] {
            return cached
        }
        let data = realService.fetchData(key: key)
        cache[key] = data
        return data
    }
}
```

### Trade-offs
**Pros**:
- Controls access to object
- Lazy initialization
- Additional functionality without changing object
- Caching, logging, access control

**Cons**:
- Increased complexity
- Potential performance overhead
- May make code harder to understand

---

## Flyweight Pattern

### Problem
Support large numbers of fine-grained objects efficiently by sharing.

### When to Use
- Application uses large number of objects
- Storage costs are high due to quantity
- Most object state can be made extrinsic
- Many groups of objects can be replaced by few shared objects

### When NOT to Use
- Few objects in total
- Object state cannot be externalized
- Memory isn't a concern (premature optimization)

### Structure
```swift
// Flyweight
class CharacterStyle {
    let font: String
    let size: Int
    let color: String

    init(font: String, size: Int, color: String) {
        self.font = font
        self.size = size
        self.color = color
    }
}

// Flyweight factory
class StyleFactory {
    private var styles: [String: CharacterStyle] = [:]

    func getStyle(font: String, size: Int, color: String) -> CharacterStyle {
        let key = "\(font)-\(size)-\(color)"
        if let style = styles[key] {
            return style
        }
        let style = CharacterStyle(font: font, size: size, color: color)
        styles[key] = style
        return style
    }
}

// Context (uses flyweight)
class Character {
    let char: String
    let style: CharacterStyle // Shared flyweight
    let position: Int // Extrinsic state

    init(char: String, style: CharacterStyle, position: Int) {
        self.char = char
        self.style = style
        self.position = position
    }
}

// Usage
let factory = StyleFactory()
let defaultStyle = factory.getStyle(font: "Arial", size: 12, color: "Black")

let characters = [
    Character(char: "H", style: defaultStyle, position: 0),
    Character(char: "e", style: defaultStyle, position: 1),
    Character(char: "l", style: defaultStyle, position: 2),
    // All share same style object!
]
```

### Trade-offs
**Pros**:
- Reduces memory usage
- Improves performance (less allocation)

**Cons**:
- Complexity increases
- Extrinsic state must be computed/stored separately
- Only beneficial with large numbers of objects

**Warning**: Measure first! Don't apply Flyweight prematurely.

---

## Pattern Comparison

| Pattern | Problem | When to Use | Complexity |
|---------|---------|-------------|------------|
| Adapter | Interface mismatch | Integrating incompatible code | Low |
| Bridge | Decouple abstraction/implementation | Both vary independently | High |
| Composite | Tree structures | Part-whole hierarchy | Medium |
| Decorator | Add responsibilities | Dynamic feature addition | Medium |
| Facade | Simplify complex system | Reduce subsystem dependencies | Low |
| Proxy | Control access | Lazy loading, access control | Low |
| Flyweight | Memory optimization | Many similar objects | High |

**Rule of Thumb**: Start with simplest pattern (Adapter, Facade, Proxy) before complex ones (Bridge, Flyweight).
