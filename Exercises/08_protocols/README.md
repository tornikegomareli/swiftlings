# Protocols

This section covers Swift protocols - blueprints that define requirements for types to implement.

## Topics Covered

### Protocol Basics
- Protocol syntax and requirements
- Property requirements (get/set)
- Method requirements
- Conforming types to protocols

### Protocol Inheritance
- Protocols inheriting from other protocols
- Multiple protocol inheritance
- Protocol composition with `&`
- Type aliases for protocol combinations

### Protocol Extensions
- Default implementations
- Adding functionality to protocols
- Conditional extensions
- Protocol-oriented programming

### Advanced Features
- Associated types
- Self requirements
- Class-only protocols (`: AnyObject`)
- Delegation pattern
- Generic constraints

## Key Concepts

1. **Requirements**: Protocols specify what, not how
2. **Conformance**: Types must implement all requirements
3. **Composition**: Combine protocols with `&`
4. **Extensions**: Provide default implementations
5. **Associated Types**: Generic protocols

## Protocol vs Other Languages

| Swift Protocol | Java | C# | C++ |
|---------------|------|----|----|
| Protocol | Interface | Interface | Abstract class |
| Extension | Default methods | Extension methods | - |
| Associated type | Generic interface | Generic interface | Template |
| Class-only | - | - | - |

## Common Patterns

### Delegation
```swift
protocol SomeDelegate: AnyObject {
    func didSomething()
}

class SomeClass {
    weak var delegate: SomeDelegate?
}
```

### Protocol-Oriented Programming
```swift
protocol Flyable {
    func fly()
}

extension Flyable {
    func fly() {
        print("Flying!")
    }
}
```

### Associated Types
```swift
protocol Container {
    associatedtype Item
    func add(_ item: Item)
}
```

## Best Practices

- Start with protocols, not classes
- Use protocol extensions for shared code
- Prefer composition over inheritance
- Make delegates weak and class-only
- Use associated types for generic protocols

## Tips

- Property requirements need `{ get }` or `{ get set }`
- Methods in protocols don't have bodies
- Extensions can't add stored properties
- Use `AnyObject` for class-only protocols
- Protocol names often end in -able, -ible, or -ing