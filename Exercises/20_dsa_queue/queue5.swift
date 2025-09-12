// queue5.swift
//
// Data Structures: Queue - Generic Implementation
// Make the Queue work with any type, not just Int.
// This allows Queue<String>, Queue<Double>, Queue<YourCustomType>, etc.
//
// Convert the Queue to use Swift generics.

import Foundation

// TODO: Make Queue generic
// 1. Add generic type parameter after Queue name
// 2. Replace all 'Int' types with the generic type
// 3. Update the array type and method signatures

struct Queue {  // Add <???> here
    var elements: [Int] = []  // Change Int to generic type
    
    mutating func enqueue(_ element: Int) {  // Change Int to generic type
        elements.append(element)
    }
    
    mutating func dequeue() -> Int? {  // Change Int? to generic type?
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    
    func peek() -> Int? {  // Change Int? to generic type?
        return elements.first
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
}

func main() {
    test("Generic Queue with Int") {
        var intQueue = Queue<Int>()
        intQueue.enqueue(42)
        intQueue.enqueue(99)
        
        assertEqual(intQueue.dequeue(), 42,
                   "Int queue should work correctly")
        assertEqual(intQueue.peek(), 99,
                   "Peek should return 99")
    }
    
    test("Generic Queue with String") {
        var stringQueue = Queue<String>()
        stringQueue.enqueue("Hello")
        stringQueue.enqueue("World")
        
        assertEqual(stringQueue.dequeue(), "Hello",
                   "String queue should dequeue 'Hello'")
        assertEqual(stringQueue.count, 1,
                   "Should have 1 element left")
    }
    
    test("Generic Queue with Double") {
        var doubleQueue = Queue<Double>()
        doubleQueue.enqueue(3.14)
        doubleQueue.enqueue(2.71)
        
        assertEqual(doubleQueue.peek(), 3.14,
                   "Double queue peek should return 3.14")
        assertEqual(doubleQueue.isEmpty, false,
                   "Queue should not be empty")
    }
    
    test("Generic Queue with custom struct") {
        struct Person: Equatable {
            let name: String
            let age: Int
        }
        
        var personQueue = Queue<Person>()
        let alice = Person(name: "Alice", age: 30)
        let bob = Person(name: "Bob", age: 25)
        
        personQueue.enqueue(alice)
        personQueue.enqueue(bob)
        
        assertEqual(personQueue.dequeue(), alice,
                   "Should dequeue Alice first")
        assertEqual(personQueue.peek(), bob,
                   "Bob should be at the front now")
    }
    
    runTests()
}