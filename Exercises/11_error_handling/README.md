# Error Handling

This section covers Swift's error handling system for dealing with recoverable errors at runtime.

## Official Swift Documentation
- [Error Handling - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling)
- [Error Protocol - Swift Standard Library](https://developer.apple.com/documentation/swift/error)
- [Result Type - Swift Standard Library](https://developer.apple.com/documentation/swift/result)
- [LocalizedError Protocol](https://developer.apple.com/documentation/foundation/localizederror)
- [Swift Evolution: Result Type (SE-0235)](https://github.com/apple/swift-evolution/blob/main/proposals/0235-add-result.md)

## Topics Covered

### Basic Error Handling
- Error protocol
- Throwing functions with `throws`
- Error propagation
- do-catch blocks

### Error Types
- Custom error enums
- Associated values in errors
- LocalizedError protocol
- NSError bridging

### Try Variations
- `try` - must handle error
- `try?` - converts to optional
- `try!` - force unwrap (crashes on error)

### Advanced Patterns
- Rethrowing functions
- Error type conversion
- Result type
- Defer statements

## Key Concepts

1. **Throwing Functions**: Mark with `throws` keyword
2. **Error Propagation**: Errors bubble up the call stack
3. **Exhaustive Handling**: Must handle all errors or rethrow
4. **Defer Blocks**: Execute regardless of how scope exits
5. **Result Type**: Encapsulates success or failure

## Error Handling Syntax

### Throwing and Catching
```swift
func risky() throws -> String {
    throw MyError.failed
}

do {
    let result = try risky()
} catch MyError.failed {
    // Handle specific error
} catch {
    // Handle any error
}
```

### Try Variations
```swift
// Must handle
let result1 = try risky()

// Optional
let result2 = try? risky()

// Force (dangerous!)
let result3 = try! risky()
```

### Defer
```swift
func process() throws {
    defer {
        // Always executes
        cleanup()
    }
    try riskyOperation()
}
```

## Common Patterns

### Error Types
```swift
enum ValidationError: Error {
    case tooShort(minLength: Int)
    case tooLong(maxLength: Int)
    case invalid(reason: String)
}
```

### Result Type
```swift
func fetch() -> Result<Data, Error> {
    // Return .success(data) or .failure(error)
}
```

### Error Conversion
```swift
do {
    try someOperation()
} catch let error as NetworkError {
    throw AppError.network(error)
}
```

## Best Practices

- Use specific error types, not just Error
- Provide meaningful error messages
- Don't use try! in production code
- Consider Result for async operations
- Use defer for cleanup code

## Error Design Guidelines

1. **Be Specific**: Create domain-specific errors
2. **Add Context**: Include relevant information
3. **Recoverable**: Only throw for recoverable errors
4. **Documentation**: Document what errors a function throws

## Tips

- Errors are values, not exceptions
- Swift uses error return, not exception unwinding
- Throwing functions can't be @objc without NSError
- Use LocalizedError for user-facing messages
- Result is great for functional error handling