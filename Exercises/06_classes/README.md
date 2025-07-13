# Classes

This section covers Swift classes - reference types that support inheritance, deinitializers, and more.

## Topics Covered

### Class Basics
- Class definition and initialization
- Reference semantics (shared instances)
- Required initializers
- Designated vs convenience initializers

### Inheritance
- Subclassing with `: SuperClass`
- Overriding methods with `override`
- Overriding properties
- Calling super implementations
- `final` to prevent overriding

### Access Control
- `private` - accessible only within the class
- `fileprivate` - accessible within the same file
- `internal` - default, accessible within module
- `public` - accessible from other modules
- `open` - public and can be subclassed

### Advanced Features
- Deinitializers (`deinit`)
- Static vs class members
- Lazy properties
- Property observers in classes
- Singleton pattern

## Key Concepts

1. **Reference Types**: Classes are shared, not copied
2. **Inheritance**: Build hierarchies of related classes
3. **Polymorphism**: Use base class references for subclasses
4. **Encapsulation**: Hide implementation with access control
5. **Memory Management**: Automatic with ARC

## Class vs Struct Comparison

| Feature | Class | Struct |
|---------|-------|--------|
| Type | Reference | Value |
| Inheritance | Yes | No |
| Deinitializer | Yes | No |
| Multiple references | Yes | No (copied) |
| Memberwise init | No | Yes |

## Best Practices

- Use classes for:
  - Shared, mutable state
  - Identity is important
  - Inheritance hierarchies
  - Interop with Objective-C

- Use structs for:
  - Simple data values
  - Copy semantics desired
  - No inheritance needed
  - Thread safety important

## Memory Considerations

- Classes use ARC (Automatic Reference Counting)
- Strong references keep objects alive
- Weak/unowned prevent retain cycles
- Deinit called when last reference removed

## Tips

- Always call `super.init` in subclass initializers
- Set subclass properties before calling super
- Use `final` to prevent overriding when needed
- `class` methods can be overridden, `static` cannot
- Lazy properties are computed only once when first accessed