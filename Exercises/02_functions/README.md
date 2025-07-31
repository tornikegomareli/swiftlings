# Functions

This section covers Swift functions - the building blocks of any Swift program.

## Official Swift Documentation
- [Functions - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions)
- [Function Parameter Names - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions#Function-Argument-Labels-and-Parameter-Names)
- [Function Types - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions#Function-Types)
- [In-Out Parameters - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions#In-Out-Parameters)
- [Variadic Parameters - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions#Variadic-Parameters)

## Topics Covered

### Function Basics
- Function declaration with `func` keyword
- Parameters and return types
- Calling functions with arguments

### Function Parameters
- External and internal parameter names
- Using `_` to omit external names
- Default parameter values
- Variadic parameters (`...`)
- `inout` parameters for modifying values

### Function Types
- Functions as first-class types
- Function type annotations
- Passing functions as parameters
- Returning functions from functions

## Key Concepts

1. **Parameter Names**: Swift uses both external (for calling) and internal (for implementation) parameter names
2. **Default Values**: Parameters can have default values, making them optional when calling
3. **Variadic Parameters**: Accept zero or more values using `...` syntax
4. **inout Parameters**: Allow functions to modify the original value (pass with `&`)
5. **Function Types**: Written as `(ParamTypes) -> ReturnType`

## Tips

- Use descriptive external parameter names for clarity
- Place parameters with default values at the end of the parameter list
- Only one variadic parameter is allowed per function
- Be careful with `inout` parameters - they can't be constants
- Function types must match exactly (parameter types and return type)