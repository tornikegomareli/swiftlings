# Structs

This section covers Swift structs - value types that encapsulate data and behavior.

## Topics Covered

### Struct Basics
- Struct definition with properties
- Automatic memberwise initializers
- Value type semantics (copy on assignment)
- Creating instances

### Methods
- Instance methods
- Static methods
- Method syntax and return types
- Accessing properties in methods

### Computed Properties
- Get and set accessors
- Read-only computed properties
- Property observers (willSet/didSet)
- Stored vs computed properties

### Mutating Methods
- The `mutating` keyword
- Modifying properties in methods
- When mutating is required
- Custom initializers

## Key Concepts

1. **Value Types**: Structs are copied when assigned or passed
2. **Memberwise Init**: Free initializer for all properties
3. **Computed Properties**: Calculate values on demand
4. **Property Observers**: React to property changes
5. **Mutating**: Required to modify properties in methods

## Struct vs Class

### Structs (Value Types)
- Copied on assignment
- No inheritance
- Automatic memberwise init
- Stored on stack (usually)
- Use for simple data

### Classes (Reference Types)
- Shared references
- Support inheritance
- No automatic init
- Stored on heap
- Use for complex objects

## Best Practices

- Prefer structs for simple data models
- Make properties private when appropriate
- Use computed properties for derived values
- Keep structs small and focused
- Consider making structs immutable when possible

## Tips

- Methods that don't modify state don't need `mutating`
- Computed properties can't have property observers
- Use `willSet` and `didSet` for side effects
- Private properties need explicit initializers
- Static methods can't access instance properties