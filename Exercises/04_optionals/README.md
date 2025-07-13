# Optionals

This section covers Swift's optional types - a powerful feature for handling the absence of values safely.

## Topics Covered

### Optional Basics
- Declaring optionals with `?`
- Understanding `nil`
- Optional binding with `if let`
- Force unwrapping with `!` (use carefully!)

### Guard Statements
- Early exit with `guard let`
- Multiple optional bindings
- Combining with boolean conditions
- Scope of unwrapped values

### Optional Chaining
- Accessing properties with `?.`
- Calling methods on optionals
- Chaining multiple levels
- Result is always optional

### Nil-Coalescing
- Default values with `??`
- Chaining multiple fallbacks
- Operator precedence
- Working with different types

## Key Concepts

1. **Optional Declaration**: `Type?` creates an optional that can be nil
2. **Safe Unwrapping**: Use `if let` or `guard let` to safely access values
3. **Force Unwrapping**: `!` crashes if nil - use only when certain
4. **Chaining**: `?.` returns nil if any part is nil
5. **Defaults**: `??` provides fallback values

## Common Patterns

### If-Let Binding
```swift
if let value = optional {
    // Use unwrapped value
}
```

### Guard-Let
```swift
guard let value = optional else {
    return // Early exit
}
// Use value in rest of function
```

### Multiple Bindings
```swift
if let a = optionalA, let b = optionalB {
    // Both are unwrapped
}
```

### Chaining
```swift
let result = object?.property?.method()
```

## Tips

- Prefer `guard let` at function start for cleaner code
- Use `??` for simple defaults
- Force unwrap only for programmer errors (like array[0] when you know it's not empty)
- Optional chaining is great for deeply nested structures
- Remember: after `guard let`, the value is unwrapped for the rest of the scope