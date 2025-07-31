# Memory Management

This section covers Swift's memory management system using Automatic Reference Counting (ARC).

## Official Swift Documentation
- [Automatic Reference Counting - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting)
- [Memory Safety - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety)
- [Weak References - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Weak-References)
- [Unowned References - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Unowned-References)
- [Understanding Swift Performance (WWDC)](https://developer.apple.com/videos/play/wwdc2016/416/)

## Topics Covered

### Reference Counting Basics
- Strong references
- Weak references
- Unowned references
- Reference cycles

### Memory Management Patterns
- Delegate patterns
- Closure capture lists
- Parent-child relationships
- Observer patterns

### Advanced Topics
- Value vs reference semantics
- Copy-on-write optimization
- Memory debugging
- Performance considerations

## Key Concepts

1. **ARC**: Automatic Reference Counting tracks object references
2. **Strong References**: Keep objects alive
3. **Weak References**: Don't keep objects alive, become nil
4. **Unowned References**: Don't keep objects alive, assume non-nil
5. **Reference Cycles**: Two objects keeping each other alive

## Reference Types

### Strong (default)
```swift
var reference = MyClass()  // Strong reference
```

### Weak
```swift
weak var delegate: MyDelegate?  // Optional, can be nil
```

### Unowned
```swift
unowned let parent: Parent  // Non-optional, assumes exists
```

## Common Memory Issues

### Retain Cycles
```swift
class A {
    var b: B?
}
class B {
    var a: A?  // Creates cycle!
}
```

### Closure Captures
```swift
self.closure = {
    self.doSomething()  // Captures self strongly
}
```

### Solutions
```swift
self.closure = { [weak self] in
    self?.doSomething()  // Weak capture
}
```

## Best Practices

### Delegates
```swift
protocol MyDelegate: AnyObject { }
class MyClass {
    weak var delegate: MyDelegate?
}
```

### Closures
```swift
{ [weak self] in
    guard let self = self else { return }
    // Use self safely
}
```

### Parent-Child
```swift
class Parent {
    var children: [Child] = []  // Strong
}
class Child {
    weak var parent: Parent?    // Weak
}
```

## When to Use Each

### Weak
- Delegates
- IBOutlets (usually)
- Back references
- Optional relationships

### Unowned
- Non-optional relationships
- Parent always outlives child
- Performance critical (no optional overhead)

### Strong
- Forward references
- Ownership relationships
- Temporary references

## Debugging Memory Issues

1. **Deinit**: Add print statements
2. **Instruments**: Use Leaks and Allocations
3. **Memory Graph**: Debug navigator in Xcode
4. **Static Analysis**: Build and Analyze

## Value Types vs Reference Types

### Value Types (Struct, Enum)
- No reference counting
- Copied on assignment
- No memory leaks
- Thread safe

### Reference Types (Class)
- Reference counting
- Shared on assignment
- Can have cycles
- Need synchronization

## Tips

- Prefer value types when possible
- Use weak for delegates
- Be careful with closures in classes
- Test deinit is called
- Avoid unowned unless certain about lifetime