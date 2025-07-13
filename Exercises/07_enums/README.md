# Enums

This section covers Swift enumerations - powerful types for modeling data with a fixed set of cases.

## Topics Covered

### Basic Enums
- Enum syntax and cases
- Using enums in switch statements
- Comparing enum values
- Dot syntax shorthand

### Raw Values
- Int raw values (auto-incrementing)
- String raw values (default to case name)
- Custom raw values
- Creating from raw values

### Associated Values
- Storing different values per case
- Pattern matching to extract values
- Multiple associated values
- Different types per case

### Methods and Properties
- Instance methods on enums
- Computed properties
- Static properties and methods
- Protocol conformance

### Advanced Features
- Recursive/indirect enums
- CaseIterable protocol
- Generic enums
- Nested types

## Key Concepts

1. **Type Safety**: Enums ensure only valid cases are used
2. **Pattern Matching**: Switch must be exhaustive
3. **Associated Values**: Store data with each case
4. **Raw Values**: Provide default values for cases
5. **Value Type**: Enums are copied like structs

## Raw Values vs Associated Values

### Raw Values
```swift
enum Status: Int {
    case pending = 1
    case approved = 2
}
```
- Same type for all cases
- Set at compile time
- Access with `.rawValue`

### Associated Values
```swift
enum Status {
    case pending
    case approved(by: String, at: Date)
}
```
- Different per instance
- Set at runtime
- Extract with pattern matching

## Common Patterns

### Result Type
```swift
enum Result<T> {
    case success(T)
    case failure(Error)
}
```

### Optional Implementation
```swift
enum Optional<T> {
    case none
    case some(T)
}
```

### State Machine
```swift
enum State {
    case idle
    case loading
    case loaded(Data)
    case error(Error)
}
```

## Tips

- Use enums for fixed sets of values
- Prefer enums over string/int constants
- Associated values make enums very flexible
- CaseIterable provides automatic `.allCases`
- Indirect enums allow recursive structures
- Enums can't have stored properties (only computed)