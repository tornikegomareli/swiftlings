// queue1.swift
//
// Data Structures: Queue - Basic Structure
// A Queue is a FIFO (First-In-First-Out) data structure.
// Like a line at a store - first person in line is first to be served.
//
// Create a basic Queue structure with storage for integers.

import Foundation

// TODO: Define a Queue struct with:
// 1. A property called 'elements' that is an array of Int
// 2. Initialize it as an empty array

struct Queue {
    // var elements: ??? = ???
}

func main() {
    test("Queue initialization") {
        let queue = Queue()
        
        assertEqual(queue.elements.isEmpty, true, 
                   "Queue should be empty when initialized")
        assertEqual(queue.elements.count, 0, 
                   "New queue should have 0 elements")
    }
    
    test("Queue can store elements array") {
        var queue = Queue()
        queue.elements = [1, 2, 3]
        
        assertEqual(queue.elements, [1, 2, 3],
                   "Should be able to set elements directly")
        assertEqual(queue.elements.count, 3,
                   "Queue should have 3 elements")
    }
    
    runTests()
}
