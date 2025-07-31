# Property Wrappers

This section covers Swift property wrappers - a powerful feature for encapsulating property behavior.

## Official Swift Documentation
- [Property Wrappers - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties#Property-Wrappers)
- [Swift Evolution: Property Wrappers (SE-0258)](https://github.com/apple/swift-evolution/blob/main/proposals/0258-property-wrappers.md)
- [Swift Evolution: Property Wrapper Local Parameters (SE-0293)](https://github.com/apple/swift-evolution/blob/main/proposals/0293-extend-property-wrappers-to-function-and-closure-parameters.md)
- [SwiftUI Property Wrappers](https://developer.apple.com/documentation/swiftui/managing-user-interface-state)
- [Modern Swift API Design (WWDC)](https://developer.apple.com/videos/play/wwdc2019/415/)

## Topics Covered

### Basic Property Wrappers
- @propertyWrapper attribute
- wrappedValue property
- Initialization
- Property wrapper types

### Advanced Features
- projectedValue ($syntax)
- Property wrapper composition
- Wrappers with arguments
- Generic property wrappers

### Special Patterns
- Enclosing type access
- Static subscripts
- Wrapper initialization
- Performance considerations

## Key Concepts

1. **Encapsulation**: Reusable property behavior
2. **Wrapped Value**: The actual property value
3. **Projected Value**: Additional functionality via $
4. **Composition**: Multiple wrappers on one property
5. **Type Safety**: Compile-time guarantees

## Basic Syntax

### Simple Wrapper
```swift
@propertyWrapper
struct Wrapper {
    var wrappedValue: Int
}

struct Example {
    @Wrapper var value: Int = 0
}
```

### With Projected Value
```swift
@propertyWrapper
struct Wrapper {
    var wrappedValue: Int
    var projectedValue: Bool { 
        wrappedValue > 0 
    }
}

// Usage: instance.$value
```

### With Arguments
```swift
@propertyWrapper
struct Clamped {
    let range: ClosedRange<Int>
    var value: Int
    
    init(wrappedValue: Int, _ range: ClosedRange<Int>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
    
    var wrappedValue: Int {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}
```

## Common Use Cases

### UserDefaults
```swift
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
```

### Thread Safety
```swift
@propertyWrapper
struct Atomic<T> {
    private let queue = DispatchQueue(label: "atomic")
    private var value: T
    
    var wrappedValue: T {
        get { queue.sync { value } }
        set { queue.sync { value = newValue } }
    }
}
```

### Validation
```swift
@propertyWrapper
struct Validated<Value> {
    private var value: Value
    private let validation: (Value) -> Bool
    
    var wrappedValue: Value {
        get { value }
        set {
            precondition(validation(newValue))
            value = newValue
        }
    }
}
```

## Advanced Patterns

### Enclosing Type Access
```swift
@propertyWrapper
struct Wrapper {
    static subscript<T>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: KeyPath<T, Value>,
        storage storageKeyPath: KeyPath<T, Self>
    ) -> Value {
        // Access enclosing instance
    }
}
```

### Composition
```swift
struct Model {
    @Logged 
    @Clamped(0...100) 
    var percentage: Int = 50
}
```

## Best Practices

- Keep wrappers focused on single responsibility
- Use projectedValue for metadata
- Consider performance implications
- Document wrapper behavior clearly
- Test edge cases thoroughly

## Built-in Property Wrappers

### SwiftUI
- @State
- @Binding
- @ObservedObject
- @EnvironmentObject
- @Environment

### Combine
- @Published

## Tips

- Property wrappers are structs (usually)
- Can't be used on computed properties
- Can't be used on lazy properties
- Initialization order matters
- Great for cross-cutting concerns