# Generics

This section covers Swift generics - one of the most powerful features for writing flexible, reusable code.

## Official Swift Documentation
- [Generics - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics)
- [Generic Parameters and Arguments](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics#Generic-Parameters-and-Arguments)
- [Type Constraints - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics#Type-Constraints)
- [Associated Types - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics#Associated-Types)
- [Swift Generics (WWDC)](https://developer.apple.com/videos/play/wwdc2018/406/)

## Topics Covered

### Generic Functions
- Type parameters with angle brackets `<T>`
- Multiple type parameters
- Generic parameter naming conventions
- Type inference with generics

### Generic Types
- Generic structs and classes
- Generic enums
- Type parameters in properties
- Generic initializers

### Type Constraints
- Protocol constraints
- Class constraints
- Multiple constraints with `&`
- Where clauses for complex requirements

### Associated Types
- Protocols with associated types
- Type erasure patterns
- Conditional conformance
- Generic subscripts

### Advanced Generics
- Opaque types with `some`
- Generic type aliases
- Recursive constraints
- Variance and type relationships

## Key Concepts

1. **Type Parameters**: Placeholders for actual types
2. **Type Constraints**: Requirements that type parameters must satisfy
3. **Type Inference**: Swift deduces concrete types when possible
4. **Associated Types**: Generic protocols
5. **Type Erasure**: Working around protocol limitations

## Generic Syntax

### Functions
```swift
func swap<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}
```

### Types
```swift
struct Stack<Element> {
    var items: [Element] = []
}
```

### Constraints
```swift
func max<T: Comparable>(_ a: T, _ b: T) -> T {
    return a > b ? a : b
}
```

### Where Clauses
```swift
func allEqual<C>(_ container: C) -> Bool 
    where C: Container, C.Element: Equatable {
    // Implementation
}
```

## Common Generic Patterns

### Optional (simplified)
```swift
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

### Result
```swift
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
```

### Container Protocol
```swift
protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```

## Type Erasure

When protocols have associated types:
```swift
struct AnyContainer<Element>: Container {
    // Type-erased wrapper implementation
}
```

## Best Practices

- Use meaningful type parameter names (not just T)
- Add constraints only when needed
- Consider protocol-oriented design first
- Use opaque types for simpler APIs
- Avoid overcomplicating with generics

## Tips

- `T` is conventional for single type parameter
- `Element` for collections, `Key/Value` for dictionaries
- Constraints make generic code more powerful
- Associated types can't be used as standalone types
- Opaque types (`some`) hide implementation details