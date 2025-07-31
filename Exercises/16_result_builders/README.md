# Result Builders

This section explores Swift's result builders (formerly function builders), which enable building values using declarative syntax. They're the foundation of SwiftUI and other domain-specific languages (DSLs).

## Official Swift Documentation
- [Result Builders - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advanced-operators#Result-Builders)
- [Swift Evolution: Result Builders (SE-0289)](https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md)
- [SwiftUI's Use of Result Builders](https://developer.apple.com/documentation/swiftui/viewbuilder)
- [Writing DSLs in Swift (WWDC)](https://developer.apple.com/videos/play/wwdc2021/10253/)
- [Result Builder Transformations](https://github.com/apple/swift/blob/main/docs/ResultBuilders.md)

## Topics Covered

### Basic Result Builders
- @resultBuilder attribute
- buildBlock method
- Basic DSL creation
- String and array builders

### Control Flow Support
- buildOptional for if statements
- buildEither for if-else
- buildArray for loops
- buildExpression for transformations

### Advanced Features
- buildFinalResult for post-processing
- buildLimitedAvailability
- Type-safe builders
- Nested builders

### Real-World Applications
- HTML/UI builders
- Configuration DSLs
- Query builders
- Validation frameworks

## Key Concepts

1. **Result Builder Protocol**: Methods that transform code blocks into values
2. **Declarative Syntax**: Write code that describes what you want
3. **Type Safety**: Maintain type information through transformations
4. **Composability**: Combine builders for complex structures
5. **DSL Design**: Create intuitive APIs for specific domains

## Basic Syntax

### Simple Result Builder
```swift
@resultBuilder
struct StringBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined()
    }
}

func build(@StringBuilder _ content: () -> String) -> String {
    return content()
}

let result = build {
    "Hello"
    " "
    "World"
}  // "Hello World"
```

### Supporting Optionals
```swift
@resultBuilder
struct ArrayBuilder<T> {
    static func buildBlock(_ components: [T]...) -> [T] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [T]?) -> [T] {
        return component ?? []
    }
    
    static func buildExpression(_ expression: T) -> [T] {
        return [expression]
    }
}
```

### Supporting Loops
```swift
static func buildArray(_ components: [[T]]) -> [T] {
    return components.flatMap { $0 }
}

// Usage
let items = build {
    for i in 1...5 {
        i * 2
    }
}  // [2, 4, 6, 8, 10]
```

## Advanced Patterns

### Type-Safe Builders
```swift
@resultBuilder
struct TupleBuilder {
    static func buildBlock<T1, T2>(_ t1: T1, _ t2: T2) -> (T1, T2) {
        return (t1, t2)
    }
    
    static func buildBlock<T1, T2, T3>(_ t1: T1, _ t2: T2, _ t3: T3) -> (T1, T2, T3) {
        return (t1, t2, t3)
    }
}
```

### HTML DSL Example
```swift
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: HTML...) -> HTML {
        return HTML(children: components)
    }
}

func div(@HTMLBuilder _ content: () -> HTML) -> HTML {
    return HTML(tag: "div", children: content().children)
}

let page = div {
    h1("Welcome")
    p("This is a paragraph")
    if showDetails {
        p("Additional details")
    }
}
```

### Query Builder
```swift
@resultBuilder
struct QueryBuilder {
    static func buildBlock(_ components: QueryComponent...) -> Query {
        return Query(components: components)
    }
}

let query = Query {
    select("id", "name")
    from("users")
    where("age > 18")
    orderBy("name")
}
```

## Best Practices

1. **Keep It Simple**: Start with basic buildBlock
2. **Add Features Gradually**: Only implement what you need
3. **Type Safety**: Preserve type information when possible
4. **Clear DSL Design**: Make the syntax intuitive
5. **Documentation**: Document the available DSL methods

## Common Patterns

### Modifier Pattern
```swift
struct View {
    var modifiers: [Modifier] = []
    
    func padding(_ value: Int) -> View {
        var copy = self
        copy.modifiers.append(.padding(value))
        return copy
    }
}
```

### Expression Building
```swift
static func buildExpression<T>(_ expression: T) -> Component {
    return Component(value: expression)
}

static func buildExpression(_ string: String) -> Component {
    return Component(text: string)
}
```

### Final Result Transformation
```swift
static func buildFinalResult(_ component: [Component]) -> Result {
    return Result(components: component, 
                  metadata: generateMetadata(component))
}
```

## Tips

- Result builders work at compile time
- Each method handles specific syntax
- buildBlock is the only required method
- Use buildExpression for type conversions
- Combine multiple builders for complex DSLs