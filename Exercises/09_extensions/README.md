# Extensions

This section covers Swift extensions - a powerful feature for adding functionality to existing types.

## Official Swift Documentation
- [Extensions - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions)
- [Adding Protocol Conformance with Extensions](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions#Adding-Protocol-Conformance-with-an-Extension)
- [Conditional Conformance - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions#Conditional-Conformance)
- [Swift Evolution: Conditional Conformances (SE-0143)](https://github.com/apple/swift-evolution/blob/main/proposals/0143-conditional-conformances.md)
- [Extending a Protocol (WWDC)](https://developer.apple.com/videos/play/wwdc2015/408/)

## Topics Covered

### Basic Extensions
- Adding computed properties
- Adding methods
- Adding initializers
- Extending built-in types

### Protocol Conformance
- Making types conform via extension
- Conditional conformance
- Default implementations
- Protocol-oriented programming

### Advanced Extensions
- Subscripts in extensions
- Nested types via extension
- Generic extensions
- Constrained extensions

### Extension Constraints
- Where clauses
- Type constraints
- Protocol constraints
- Multiple constraints

## Key Concepts

1. **Retroactive Modeling**: Add functionality to any type
2. **No Stored Properties**: Only computed properties allowed
3. **Access Control**: Can't access private members
4. **Organization**: Group related functionality
5. **Protocol Conformance**: Add protocols after the fact

## What Extensions Can Add

✅ **Can Add:**
- Computed properties
- Instance methods
- Type methods
- Initializers
- Subscripts
- Nested types
- Protocol conformance

❌ **Cannot Add:**
- Stored properties
- Property observers to existing properties
- Override existing functionality

## Common Patterns

### Extending Collections
```swift
extension Array where Element: Numeric {
    var sum: Element { ... }
}
```

### Protocol Extensions
```swift
extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}
```

### Organizing Code
```swift
// Main type
struct User { ... }

// Validation logic
extension User {
    func validate() -> Bool { ... }
}

// Codable conformance
extension User: Codable { }
```

## Best Practices

- Use extensions to organize code by functionality
- Group protocol conformance in extensions
- Keep extensions focused and cohesive
- Use access control appropriately
- Consider retroactive modeling carefully

## Conditional Conformance

Extensions can make types conform to protocols conditionally:

```swift
extension Array: Describable where Element: Describable {
    var description: String { ... }
}
```

## Tips

- Extensions work on all types (class, struct, enum, protocol)
- Generic type extensions can be constrained
- Protocol extensions provide "free" functionality
- Use private extensions for internal organization
- Extensions can't be overridden (not virtual)