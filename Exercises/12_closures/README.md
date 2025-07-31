# Closures

This section covers Swift closures - self-contained blocks of functionality that can be passed around and used in your code.

## Official Swift Documentation
- [Closures - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures)
- [Capturing Values - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Capturing-Values)
- [Escaping Closures - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Escaping-Closures)
- [Autoclosures - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Autoclosures)
- [Swift Evolution: Multiple Trailing Closures (SE-0279)](https://github.com/apple/swift-evolution/blob/main/proposals/0279-multiple-trailing-closures.md)

## Topics Covered

### Closure Basics
- Closure expressions
- Syntax optimizations
- Trailing closure syntax
- Capturing values

### Closure Types
- Escaping closures
- Non-escaping closures
- Autoclosures
- Multiple closures

### Functional Programming
- Higher-order functions
- Function composition
- Currying
- Memoization

### Advanced Patterns
- DSL creation
- Result builders
- Multiple trailing closures
- Capture lists

## Key Concepts

1. **Closure Expressions**: Anonymous functions
2. **Capturing**: Closures capture values from context
3. **Escaping**: Outlive the function they're passed to
4. **Trailing Syntax**: Clean syntax for last parameter
5. **Type Inference**: Swift infers closure types

## Closure Syntax Evolution

### Full Syntax
```swift
{ (parameters) -> ReturnType in
    statements
}
```

### Type Inference
```swift
{ parameters in
    statements
}
```

### Implicit Return
```swift
{ parameters in expression }
```

### Shorthand Arguments
```swift
{ $0 + $1 }
```

### Operator Methods
```swift
strings.sorted(by: >)
```

## Common Patterns

### Map, Filter, Reduce
```swift
let doubled = numbers.map { $0 * 2 }
let evens = numbers.filter { $0 % 2 == 0 }
let sum = numbers.reduce(0, +)
```

### Completion Handlers
```swift
func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
    // Async operation
}
```

### Capture Lists
```swift
{ [weak self, unowned object] in
    self?.doSomething()
}
```

## Escaping vs Non-Escaping

### Non-Escaping (default)
- Must be called before function returns
- Can't be stored
- No retain cycles risk

### Escaping
- Can be stored and called later
- Used for async operations
- Risk of retain cycles

## Best Practices

- Use trailing closure syntax when possible
- Prefer shorthand for simple operations
- Be explicit with capture lists
- Use `@escaping` only when needed
- Consider readability over brevity

## Common Pitfalls

1. **Retain Cycles**: Use weak/unowned references
2. **Escaping Confusion**: Understand when needed
3. **Complex Closures**: Extract to named functions
4. **Capture Semantics**: Values vs references

## Tips

- Closures are reference types
- Non-escaping is safer and more performant
- Use autoclosure for lazy evaluation
- Multiple trailing closures improve readability
- Type annotations help with complex closures