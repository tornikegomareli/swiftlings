# Collections

This section covers Swift's collection types: Arrays, Dictionaries, and Sets.

## Topics Covered

### Arrays
- Ordered collections of values
- Array literals and type annotations
- Accessing elements by index
- Array methods: append, insert, remove
- Functional operations: map, filter, reduce

### Dictionaries
- Unordered key-value pairs
- Dictionary literals and empty dictionaries
- Accessing values with subscripts (returns optionals)
- Adding, updating, and removing entries
- Safe access with nil-coalescing

### Sets
- Unordered collections of unique values
- Set literals and type requirements
- Set operations: union, intersection, difference
- Checking membership and uniqueness

## Key Concepts

1. **Type Safety**: Collections are generic and type-safe
2. **Optionals**: Dictionary subscripts return optionals
3. **Value Semantics**: Collections are value types (copied on assignment)
4. **Uniqueness**: Sets automatically remove duplicates
5. **Index Safety**: Array indices must be valid (0..<count)

## Common Methods

### Array
- `append(_:)` - Add element to end
- `insert(_:at:)` - Insert at specific index
- `remove(at:)` - Remove at index
- `removeLast()` - Remove last element
- `count`, `isEmpty` - Check size

### Dictionary
- `updateValue(_:forKey:)` - Update and return old value
- `removeValue(forKey:)` - Remove entry
- `keys`, `values` - Access all keys/values
- Subscript with nil to remove

### Set
- `insert(_:)` - Add element
- `remove(_:)` - Remove element
- `union(_:)` - Combine sets
- `intersection(_:)` - Common elements
- `subtracting(_:)` - Difference

## Tips

- Use `[Type]()` or `Array<Type>()` for empty arrays
- Dictionary access always returns optionals
- Sets require elements to be Hashable
- Prefer higher-order functions (map, filter) over manual loops
- Check bounds before accessing array indices