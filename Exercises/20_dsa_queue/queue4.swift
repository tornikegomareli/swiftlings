// queue4.swift
//
// Data Structures: Queue - Peek and Helper Methods
// Peek lets you see what's at the front without removing it.
// isEmpty and count are helpful utilities for queue management.
//
// Implement peek, isEmpty, and count for the Queue.

import Foundation

struct Queue {
    var elements: [Int] = []
    
    mutating func enqueue(_ element: Int) {
        elements.append(element)
    }
    
    mutating func dequeue() -> Int? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    
    // TODO: Implement peek method
    // 1. Returns an Optional Int (Int?)
    // 2. Returns the first element without removing it
    // 3. Returns nil if queue is empty
    
    // func peek() -> ??? {
    //     return elements.???
    // }
    
    // TODO: Implement isEmpty computed property
    // Returns true if the queue has no elements
    
    // var isEmpty: Bool {
    //     return elements.???
    // }
    
    // TODO: Implement count computed property
    // Returns the number of elements in the queue
    
    // var count: Int {
    //     return ???
    // }
}

func main() {
    test("Peek on empty queue") {
        let queue = Queue()
        
        assertEqual(queue.peek(), nil,
                   "Peek on empty queue should return nil")
    }
    
    test("Peek doesn't remove element") {
        var queue = Queue()
        queue.enqueue(10)
        queue.enqueue(20)
        
        assertEqual(queue.peek(), 10, "Peek should return 10")
        assertEqual(queue.peek(), 10, "Peek again should still return 10")
        assertEqual(queue.elements, [10, 20], "Elements should remain unchanged")
    }
    
    test("isEmpty property") {
        var queue = Queue()
        
        assertEqual(queue.isEmpty, true, "New queue should be empty")
        
        queue.enqueue(1)
        assertEqual(queue.isEmpty, false, "Queue with element should not be empty")
        
        _ = queue.dequeue()
        assertEqual(queue.isEmpty, true, "Queue should be empty after dequeuing last element")
    }
    
    test("Count property") {
        var queue = Queue()
        
        assertEqual(queue.count, 0, "Empty queue should have count 0")
        
        queue.enqueue(1)
        assertEqual(queue.count, 1, "Count should be 1")
        
        queue.enqueue(2)
        queue.enqueue(3)
        assertEqual(queue.count, 3, "Count should be 3")
        
        _ = queue.dequeue()
        assertEqual(queue.count, 2, "Count should be 2 after dequeue")
    }
    
    runTests()
}
