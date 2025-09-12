# Data Structures: Queue

A Queue is a fundamental data structure that follows the First-In-First-Out (FIFO) principle. Think of it like a line at a coffee shop - the first person to join the line is the first person to be served.

## Official Documentation & References
- [Swift Algorithm Club - Queue](https://github.com/kodecocodes/swift-algorithm-club/tree/master/Queue)
- [Apple Developer - Swift Standard Library](https://developer.apple.com/documentation/swift/swift_standard_library)
- [Data Structures in Swift - Queue Implementation](https://www.kodeco.com/books/data-structures-algorithms-in-swift/v4.0/chapters/8-queues)
- [Swift Collections Documentation](https://developer.apple.com/documentation/swift/collections)
- [Generic Programming in Swift](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics)
- [Protocol-Oriented Programming](https://developer.apple.com/videos/play/wwdc2015/408/)

## Queue Characteristics

### Key Properties
- **FIFO (First-In-First-Out)**: Elements are processed in the order they were added
- **Two main operations**: Enqueue (add to rear) and Dequeue (remove from front)
- **Linear data structure**: Elements are arranged in a sequence

### When to Use Queues
- Task scheduling (process tasks in order received)
- Breadth-first search algorithms
- Message queuing systems
- Print spoolers
- Call center phone systems

## Core Operations

### Essential Methods
1. **enqueue(_:)** - Add an element to the rear of the queue
2. **dequeue()** - Remove and return the element from the front
3. **peek()** - View the front element without removing it
4. **isEmpty** - Check if the queue has no elements
5. **count** - Get the number of elements in the queue

## Implementation Approaches

### Array-Based Queue
```swift
struct Queue<Element> {
    private var elements: [Element] = []
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
}
```
**Pros**: Simple implementation
**Cons**: O(n) dequeue operation due to array shifting

### Optimized Array-Based Queue
Uses two arrays or a circular buffer to achieve O(1) amortized operations.

### Linked List-Based Queue
Uses nodes with references to achieve true O(1) operations for both enqueue and dequeue.

## Time Complexity

| Operation | Array-Based | Optimized | Linked List |
|-----------|------------|-----------|-------------|
| Enqueue   | O(1)*      | O(1)      | O(1)        |
| Dequeue   | O(n)       | O(1)*     | O(1)        |
| Peek      | O(1)       | O(1)      | O(1)        |
| Space     | O(n)       | O(n)      | O(n)        |

*Amortized time complexity

## Exercise Progression

1. **queue1.swift** - Basic Structure
   - Create a Queue struct with storage array
   - Understand the basic structure

2. **queue2.swift** - Enqueue Operation
   - Implement adding elements to the queue
   - Understand rear insertion

3. **queue3.swift** - Dequeue Operation
   - Implement removing elements from the queue
   - Handle empty queue cases

4. **queue4.swift** - Peek and Helper Methods
   - Implement peek to view without removing
   - Add isEmpty and count properties

5. **queue5.swift** - Generic Queue
   - Convert to generic implementation
   - Work with any type, not just Int

6. **queue6.swift** - Protocol Conformance
   - Make Queue conform to Collection
   - Enable iteration and standard collection operations

## Tips for Success

1. **Visualize the Queue**: Draw out the queue operations on paper
2. **Handle Edge Cases**: Always check for empty queue before dequeue/peek
3. **Think About Efficiency**: Consider time complexity of operations
4. **Use Optionals**: Return nil for operations on empty queues
5. **Test Thoroughly**: Try edge cases like single element, empty queue

## Advanced Topics (Beyond These Exercises)

- **Priority Queues**: Elements are dequeued based on priority
- **Deque (Double-ended Queue)**: Can add/remove from both ends
- **Circular Queues**: Fixed-size queue that wraps around
- **Concurrent Queues**: Thread-safe queue implementations

## Real-World Applications

- **iOS Development**: DispatchQueue for managing tasks
- **Networking**: Request queuing and rate limiting
- **Gaming**: Turn-based game mechanics
- **UI**: Animation queues and event handling

## Further Reading

- [Algorithms, 4th Edition - Queues](https://algs4.cs.princeton.edu/13stacks/)
- [Introduction to Algorithms - CLRS](https://mitpress.mit.edu/books/introduction-algorithms-third-edition)
- [Swift Forums - Data Structures Discussion](https://forums.swift.org/c/related-projects/swift-collections/72)