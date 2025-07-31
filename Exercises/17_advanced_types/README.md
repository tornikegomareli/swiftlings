# Advanced Types

This section explores Swift's advanced type system features including type aliases, associated types, opaque types, existential types, phantom types, and advanced generic programming.

## Official Swift Documentation
- [Types - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/types)
- [Opaque Types - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes)
- [Generics - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics)
- [Swift Evolution: Opaque Types (SE-0244)](https://github.com/apple/swift-evolution/blob/main/proposals/0244-opaque-result-types.md)
- [Swift Evolution: Existential any (SE-0335)](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md)
- [Swift Evolution: Primary Associated Types (SE-0346)](https://github.com/apple/swift-evolution/blob/main/proposals/0346-light-weight-same-type-syntax.md)
- [Embrace Swift Type Inference (WWDC)](https://developer.apple.com/videos/play/wwdc2020/10165/)

## Topics Covered

### Type Fundamentals
- Type aliases
- Nested types
- Associated types
- Recursive enums

### Opaque and Existential Types
- `some` keyword for opaque types
- `any` keyword for existential types
- Type erasure patterns
- Primary associated types

### Phantom Types
- Type-level programming
- Compile-time state machines
- Type-safe builders
- Unit of measurement types

### Advanced Generics
- Conditional conformances
- Complex type constraints
- Recursive constraints
- Higher-kinded type patterns

## Key Concepts

1. **Type Aliases**: Create semantic names for existing types
2. **Opaque Types**: Hide implementation details while preserving type identity
3. **Existential Types**: Store values of different types conforming to a protocol
4. **Phantom Types**: Types that exist only at compile time for type safety
5. **Conditional Conformance**: Make generic types conditionally conform to protocols

## Basic Syntax

### Type Aliases
```swift
typealias UserID = Int
typealias CompletionHandler = (Result<Data, Error>) -> Void
typealias JSONDictionary = [String: Any]
```

### Nested Types
```swift
struct Database {
    struct Connection {
        var isConnected: Bool
    }
    
    enum Error: Swift.Error {
        case connectionFailed
        case queryFailed(String)
    }
}
```

### Opaque Types
```swift
func makeShape() -> some Shape {
    return Circle(radius: 5)
}
```

### Existential Types
```swift
let shapes: [any Shape] = [
    Circle(radius: 5),
    Rectangle(width: 10, height: 20)
]
```

## Advanced Patterns

### Type Erasure
```swift
struct AnyPublisher<Output>: Publisher {
    private let _publish: (Output) -> Void
    
    init<P: Publisher>(_ publisher: P) where P.Output == Output {
        self._publish = publisher.publish
    }
    
    func publish(_ value: Output) {
        _publish(value)
    }
}
```

### Phantom Types
```swift
struct Distance<Unit> {
    let value: Double
}

enum Meters {}
enum Kilometers {}

let distance = Distance<Meters>(100)
```

### State Machines with Types
```swift
struct Door<State> {
    let id: String
}

enum Open {}
enum Closed {}
enum Locked {}

extension Door where State == Closed {
    func open() -> Door<Open> {
        Door<Open>(id: id)
    }
}
```

### Conditional Conformance
```swift
extension Box: Equatable where T: Equatable {
    static func ==(lhs: Box<T>, rhs: Box<T>) -> Bool {
        lhs.value == rhs.value
    }
}
```

## Type-Level Programming

### Type-Safe Builders
```swift
struct RequestBuilder<State> {
    var url: String
}

enum URLMissing {}
enum URLSet {}

extension RequestBuilder where State == URLMissing {
    func setURL(_ url: String) -> RequestBuilder<URLSet> {
        var builder = RequestBuilder<URLSet>()
        builder.url = url
        return builder
    }
}
```

### Type Witnesses
```swift
protocol Witness {
    associatedtype Value
    static var value: Value { get }
}

func getValue<W: Witness>(_ witness: W.Type) -> W.Value {
    W.value
}
```

## Best Practices

1. **Use Type Aliases**: For clarity and semantic meaning
2. **Prefer Opaque Types**: When implementation details should be hidden
3. **Use Existentials Carefully**: They have performance implications
4. **Leverage Phantom Types**: For compile-time guarantees
5. **Document Complex Types**: Help future maintainers understand your design

## Common Patterns

### Associated Type Constraints
```swift
protocol Container {
    associatedtype Item: Equatable
    func contains(_ item: Item) -> Bool
}
```

### Primary Associated Types
```swift
protocol Collection<Element> {
    associatedtype Element
    var count: Int { get }
}
```

### Recursive Constraints
```swift
protocol TreeNode where Child: TreeNode {
    associatedtype Child
    var children: [Child] { get }
}
```

## Tips

- Opaque types preserve type identity
- Existential types allow heterogeneous collections
- Phantom types provide zero-cost abstractions
- Conditional conformances reduce boilerplate
- Type erasure hides implementation complexity