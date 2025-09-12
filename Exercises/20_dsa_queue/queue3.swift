// queue3.swift
//
// Data Structures: Queue - Dequeue Operation
// Dequeue removes and returns the element from the front of the queue.
// This is the "being served and leaving the line" operation.
//
// Implement the dequeue method to remove elements from the queue.

import Foundation

struct Queue {
    var elements: [Int] = []
    
    mutating func enqueue(_ element: Int) {
        elements.append(element)
    }
    
    // TODO: Implement the dequeue method
    // 1. It should be a mutating function
    // 2. Returns an Optional Int (Int?)
    // 3. If queue is empty, return nil
    // 4. Otherwise, remove and return the first element
    
    // mutating func dequeue() -> ??? {
    //     guard !elements.??? else { return ??? }
    //     return elements.???
    // }
}

func main() {
    test("Dequeue from empty queue") {
        var queue = Queue()
        let result = queue.dequeue()
        
        assertEqual(result, nil,
                   "Dequeue from empty queue should return nil")
    }
    
    test("Dequeue single element") {
        var queue = Queue()
        queue.enqueue(42)
        
        let result = queue.dequeue()
        assertEqual(result, 42,
                   "Should dequeue 42")
        assertEqual(queue.elements.isEmpty, true,
                   "Queue should be empty after dequeuing last element")
    }
    
    test("Dequeue maintains FIFO order") {
        var queue = Queue()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        
        assertEqual(queue.dequeue(), 1, "First dequeue should return 1")
        assertEqual(queue.dequeue(), 2, "Second dequeue should return 2")
        assertEqual(queue.elements, [3], "Queue should contain [3]")
        assertEqual(queue.dequeue(), 3, "Third dequeue should return 3")
        assertEqual(queue.dequeue(), nil, "Fourth dequeue should return nil")
    }
    
    runTests()
}
