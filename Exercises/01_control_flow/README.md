# Control Flow

This section covers Swift's control flow structures that allow you to control the execution flow of your program.

## Topics Covered

### Conditionals
- `if` statements - Basic conditional execution
- `else if` and `else` - Multiple conditions
- Logical operators (`&&`, `||`) - Combining conditions

### Switch Statements
- Basic pattern matching with strings
- Range matching for numeric values
- Multiple cases in one branch
- Exhaustive matching requirements

### Loops
- `for-in` loops - Iterating over ranges and collections
- `while` loops - Conditional repetition
- Loop control with `break` and `continue`

## Key Concepts

1. **Boolean Conditions**: All conditions must evaluate to a Bool type
2. **Switch Exhaustiveness**: Every possible value must be handled
3. **Range Operators**: `...` (closed) includes both bounds, `..<` (half-open) excludes the upper bound
4. **Loop Control**: `break` exits the loop, `continue` skips to the next iteration

## Tips

- Remember that Swift requires explicit boolean conditions (no implicit conversions)
- Switch statements don't need `break` - there's no fallthrough by default
- Use `where` clauses in switch statements for additional conditions
- Be careful with while loops to avoid infinite loops