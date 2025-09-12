// queue2.swift
//
// Data Structures: Queue - Enqueue Operation
// Enqueue adds elements to the rear (end) of the queue.
// This is the "getting in line" operation.
//
// Implement the enqueue method to add elements to the queue.

import Foundation

struct Queue {
    var elements: [Int] = []
    
    // TODO: Implement the enqueue method
    // 1. It should be a mutating function (modifies the struct)
    // 2. Takes an Int parameter called 'element'
    // 3. Adds the element to the end of the elements array
    
    // mutating func enqueue(_ element: ???) {
    //     ???
    // }
}

func main() {
    test("Enqueue single element") {
        var queue = Queue()
        queue.enqueue(10)
        
        assertEqual(queue.elements, [10],
                   "Queue should contain [10] after enqueueing 10")
    }
    
    test("Enqueue multiple elements") {
        var queue = Queue()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        
        assertEqual(queue.elements, [1, 2, 3],
                   "Elements should be in order [1, 2, 3]")
        assertEqual(queue.elements.count, 3,
                   "Queue should have 3 elements")
    }
    
    test("Enqueue maintains FIFO order") {
        var queue = Queue()
        queue.enqueue(100)
        queue.enqueue(200)
        queue.enqueue(300)
        
        assertEqual(queue.elements.first, 100,
                   "First element should be 100 (first in)")
        assertEqual(queue.elements.last, 300,
                   "Last element should be 300 (last in)")
    }
    
    runTests()
}
