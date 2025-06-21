# Swift Learning Categories for Exercise-Based Learning

## Course Structure
This syllabus is organized into progressive categories, each containing multiple exercises that build upon previous concepts. Perfect for creating a rustlings-style learning experience.

---

## 1. BASICS

### 1.1 Variables and Constants
- Variable declarations with `var`
- Constant declarations with `let`
- Type inference vs explicit typing
- Mutable vs immutable concepts

### 1.2 Data Types
- Integers (`Int`, `Int8`, `Int16`, `Int32`, `Int64`)
- Floating point (`Float`, `Double`)
- Booleans (`Bool`)
- Strings (`String`)
- Characters (`Character`)
- Type conversion and casting

### 1.3 Operators
- Arithmetic operators (`+`, `-`, `*`, `/`, `%`)
- Comparison operators (`==`, `!=`, `<`, `>`, `<=`, `>=`)
- Logical operators (`&&`, `||`, `!`)
- Assignment operators (`=`, `+=`, `-=`, etc.)
- Range operators (`...`, `..<`)

### 1.4 String Manipulation
- String interpolation
- String concatenation
- String properties and methods
- Multi-line strings
- Escape sequences

---

## 2. CONTROL_FLOW

### 2.1 Conditionals
- `if` statements
- `else if` and `else`
- Ternary operator (`? :`)
- Nested conditionals

### 2.2 Switch Statements
- Basic switch syntax
- Multiple case values
- Range matching
- Where clauses
- Fallthrough behavior

### 2.3 Loops
- `for-in` loops
- `while` loops
- `repeat-while` loops
- Loop control (`break`, `continue`)
- Labeled statements

---

## 3. FUNCTIONS

### 3.1 Function Basics
- Function declaration and syntax
- Parameters and arguments
- Return types
- Calling functions

### 3.2 Function Parameters
- External and internal parameter names
- Default parameter values
- Variadic parameters
- `inout` parameters

### 3.3 Function Types
- Functions as types
- Function types as parameters
- Function types as return types
- Nested functions

---

## 4. COLLECTIONS

### 4.1 Arrays
- Array creation and initialization
- Array access and modification
- Array properties and methods
- Array iteration
- Multi-dimensional arrays

### 4.2 Sets
- Set creation and initialization
- Set operations (union, intersection, subtraction)
- Set membership and equality
- Set iteration

### 4.3 Dictionaries
- Dictionary creation and initialization
- Dictionary access and modification
- Dictionary properties and methods
- Dictionary iteration
- Nested dictionaries

---

## 5. OPTIONALS

### 5.1 Optional Basics
- Understanding nil and optionals
- Optional declaration
- Optional binding with `if let`
- Optional binding with `guard let`

### 5.2 Optional Handling
- Nil coalescing operator (`??`)
- Optional chaining
- Forced unwrapping (`!`)
- Implicitly unwrapped optionals

### 5.3 Optional Patterns
- Multiple optional binding
- Optional map and flatMap
- Combining optionals
- Optional protocol methods

---

## 6. STRUCTS

### 6.1 Struct Basics
- Struct definition and syntax
- Creating struct instances
- Accessing struct properties
- Struct methods

### 6.2 Struct Features
- Initializers
- Computed properties
- Property observers
- Static properties and methods
- Mutating methods

---

## 7. CLASSES

### 7.1 Class Basics
- Class definition and syntax
- Creating class instances
- Reference vs value types
- Class properties and methods

### 7.2 Class Features
- Initializers and deinitializers
- Inheritance
- Method overriding
- Property overriding
- Super keyword

### 7.3 Access Control
- Private, internal, public
- File-private access
- Open access
- Access control patterns

---

## 8. ENUMS

### 8.1 Enum Basics
- Enum definition and syntax
- Enum cases
- Raw values
- Switch statements with enums

### 8.2 Associated Values
- Enums with associated values
- Pattern matching with associated values
- Recursive enumerations
- Enum methods and computed properties

### 8.3 Advanced Enums
- CaseIterable protocol
- Comparable enums
- Custom raw value types
- Enum extensions

---

## 9. PROTOCOLS

### 9.1 Protocol Basics
- Protocol definition and syntax
- Protocol conformance
- Protocol requirements
- Protocol inheritance

### 9.2 Protocol Features
- Optional protocol requirements
- Protocol extensions
- Default implementations
- Protocol composition

### 9.3 Protocol Patterns
- Delegation pattern
- Protocol-oriented programming
- Associated types
- Generic protocols

---

## 10. EXTENSIONS

### 10.1 Extension Basics
- Adding computed properties
- Adding methods
- Adding initializers
- Extending built-in types

### 10.2 Extension Features
- Extensions with protocols
- Conditional extensions
- Generic extensions
- Extension access control

---

## 11. GENERICS

### 11.1 Generic Functions
- Generic function syntax
- Type parameters
- Generic function calls
- Multiple type parameters

### 11.2 Generic Types
- Generic structures
- Generic classes
- Generic enumerations
- Type constraints

### 11.3 Advanced Generics
- Where clauses
- Associated types
- Generic subscripts
- Type erasure patterns

---

## 12. ERROR_HANDLING

### 12.1 Error Basics
- Error protocol
- Throwing functions
- Do-catch blocks
- Error propagation

### 12.2 Error Patterns
- Try variants (`try?`, `try!`)
- Custom error types
- Error handling strategies
- Defer statements

---

## 13. CLOSURES

### 13.1 Closure Basics
- Closure syntax
- Closure expressions
- Trailing closures
- Shorthand argument names

### 13.2 Closure Features
- Capturing values
- Escaping closures
- Autoclosures
- Closure as function parameters

### 13.3 Higher-Order Functions
- Map, filter, reduce
- CompactMap and flatMap
- Sort and sorted
- Custom higher-order functions

---

## 14. MEMORY_MANAGEMENT

### 14.1 ARC Basics
- Automatic Reference Counting
- Strong references
- Reference cycles
- Instance lifecycle

### 14.2 Weak and Unowned
- Weak references
- Unowned references
- Breaking retain cycles
- Capture lists in closures

---

## 15. PROPERTY_WRAPPERS

### 15.1 Property Wrapper Basics
- Property wrapper syntax
- Wrapped value
- Projected value
- Built-in property wrappers

### 15.2 Custom Property Wrappers
- Creating property wrappers
- Property wrapper composition
- Property wrapper parameters
- Advanced property wrapper patterns

---

## 16. CONCURRENCY

### 16.1 Async/Await Basics
- Async functions
- Await keyword
- Async sequences
- Async throwing functions

### 16.2 Tasks and Actors
- Task creation
- Task cancellation
- Actor isolation
- MainActor

### 16.3 Structured Concurrency
- Task groups
- Async let
- Unstructured tasks
- Task priorities

---

## 17. RESULT_BUILDERS

### 17.1 Result Builder Basics
- Result builder syntax
- Build methods
- Build blocks
- Simple DSLs

### 17.2 Advanced Result Builders
- Conditional building
- Loop building
- Component building
- Complex DSL patterns

---

## 18. ADVANCED_TYPES

### 18.1 Type System
- Type aliases
- Opaque types (`some`)
- Existential types (`any`)
- Metatypes

### 18.2 Advanced Patterns
- Pattern matching
- Custom operators
- Subscripts
- Key paths

---

## 19. CODABLE

### 19.1 Codable Basics
- Encoding and decoding
- JSON serialization
- Automatic synthesis
- Custom coding keys

### 19.2 Advanced Codable
- Custom encoding/decoding
- Nested codable types
- Date and data handling
- Error handling in codable

---

## 20. TESTING

### 20.1 Unit Testing
- XCTest framework
- Test methods and assertions
- Test lifecycle
- Test organization

### 20.2 Advanced Testing
- Async testing
- Performance testing
- Mock objects
- Test doubles

---

## Implementation Guidelines

### Exercise Structure
Each category should contain 5-15 exercises that:
- Start with failing tests
- Gradually increase in complexity
- Include clear error messages
- Provide hints when needed
- Build upon previous exercises

### Progression Logic
- Linear progression within categories
- Some categories depend on others (e.g., GENERICS needs FUNCTIONS)
- Advanced categories combine multiple concepts
- Final categories prepare for real-world development

### Exercise Types
- **Fill-in-the-blank:** Complete missing code
- **Fix-the-bug:** Identify and correct errors
- **Implementation:** Write functions/types from scratch
- **Refactoring:** Improve existing code
- **Testing:** Write tests for given code

This structure provides a comprehensive foundation for creating Swift exercises that progressively build programming skills.
