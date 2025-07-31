# Concurrency

This section covers Swift's modern concurrency system with async/await, actors, and structured concurrency.

## Official Swift Documentation
- [Concurrency - The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)
- [Meet async/await in Swift (WWDC)](https://developer.apple.com/videos/play/wwdc2021/10132/)
- [Actors - Swift Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Actors)
- [Task Documentation](https://developer.apple.com/documentation/swift/task)
- [Swift Evolution: Async/Await (SE-0296)](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md)
- [Swift Evolution: Actors (SE-0306)](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md)
- [Swift Evolution: Structured Concurrency (SE-0304)](https://github.com/apple/swift-evolution/blob/main/proposals/0304-structured-concurrency.md)

## Topics Covered

### Async/Await Basics
- Async functions
- Await keyword
- Throwing async functions
- Async properties and subscripts

### Tasks and Concurrency
- Task creation
- Structured concurrency
- Task groups
- Task cancellation
- Task priorities

### Actors
- Actor types
- Actor isolation
- MainActor
- Global actors
- Nonisolated

### Advanced Patterns
- AsyncSequence
- AsyncStream
- Sendable protocol
- Continuation APIs

## Key Concepts

1. **Async/Await**: Sequential-looking asynchronous code
2. **Structured Concurrency**: Automatic task lifecycle management
3. **Actors**: Safe concurrent access to mutable state
4. **Data Isolation**: Sendable types for safe sharing
5. **Cooperative Threading**: Suspension points with await

## Basic Syntax

### Async Functions
```swift
func loadData() async throws -> Data {
    let url = URL(string: "https://example.com")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}
```

### Tasks
```swift
Task {
    let data = try await loadData()
    print(data)
}

Task.detached {
    // Unstructured concurrency
}
```

### Async Let
```swift
async let user = fetchUser()
async let posts = fetchPosts()

let (userData, userPosts) = await (user, posts)
```

## Actors

### Basic Actor
```swift
actor BankAccount {
    private var balance: Decimal
    
    func withdraw(_ amount: Decimal) -> Bool {
        if balance >= amount {
            balance -= amount
            return true
        }
        return false
    }
}
```

### MainActor
```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    func updateUI() {
        // Guaranteed to run on main thread
    }
}
```

## Task Groups

### Basic Task Group
```swift
let results = await withTaskGroup(of: Int.self) { group in
    for i in 1...10 {
        group.addTask { await process(i) }
    }
    
    var collected: [Int] = []
    for await result in group {
        collected.append(result)
    }
    return collected
}
```

### Throwing Task Group
```swift
try await withThrowingTaskGroup(of: Data.self) { group in
    // Handle errors
}
```

## AsyncSequence

### Custom AsyncSequence
```swift
struct Counter: AsyncSequence {
    typealias Element = Int
    let limit: Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        var current = 0
        let limit: Int
        
        mutating func next() async -> Int? {
            guard current < limit else { return nil }
            defer { current += 1 }
            return current
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(limit: limit)
    }
}
```

## Best Practices

- Use structured concurrency when possible
- Avoid detached tasks unless necessary
- Mark UI updates with @MainActor
- Check for cancellation in long-running tasks
- Use actors for shared mutable state

## Common Patterns

### Continuation Bridge
```swift
func oldAPI() async -> String {
    await withCheckedContinuation { continuation in
        oldAPIWithCallback { result in
            continuation.resume(returning: result)
        }
    }
}
```

### Async Properties
```swift
extension URL {
    var contents: String {
        get async throws {
            try await String(contentsOf: self)
        }
    }
}
```

## Tips

- Actors are reference types
- await is a suspension point
- Tasks inherit actor context
- Use `Task { @MainActor in }` for UI updates
- AsyncSequence works with for-await-in loops