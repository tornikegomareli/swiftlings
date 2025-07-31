// concurrency4.swift
//
// Advanced concurrency patterns including AsyncSequence and sendable types.
// Understanding data isolation and safe concurrent programming.
//
// Fix the advanced concurrency patterns to make the tests pass.

import Foundation

// TODO: Create an AsyncSequence
struct Counter {  // Should conform to AsyncSequence
    let limit: Int
    
    // TODO: Add makeAsyncIterator
}

struct CounterIterator: AsyncIteratorProtocol {
    let limit: Int
    var current = 0
    
    mutating func next() async -> Int? {
        // TODO: Implement async iteration
        return nil
    }
}

// TODO: Create async stream
func numberStream() -> AsyncStream<Int> {
    // Create stream that emits numbers
    return AsyncStream { continuation in
        // TODO: Emit values
    }
}

// TODO: Make type Sendable
struct Message {  // Should be Sendable
    let id: Int
    let text: String
    var callback: (() -> Void)?  // This prevents Sendable
}

// TODO: Use @Sendable closure
func processAsync(completion: @escaping () -> Void) {  // Should be @Sendable
    Task {
        try? await Task.sleep(nanoseconds: 100_000_000)
        completion()
    }
}

// TODO: Create AsyncSequence with transformation
extension AsyncSequence {
    func square() -> AsyncMapSequence<Self, Int> {  // Wrong return type
        // Square each element
        return self.map { _ in 0 }  // Wrong implementation
    }
}

// TODO: Handle async sequence errors
struct DataStream: AsyncSequence {
    typealias Element = String
    
    struct AsyncIterator: AsyncIteratorProtocol {
        var count = 0
        
        mutating func next() async throws -> String? {
            count += 1
            if count > 3 {
                return nil
            }
            if count == 2 {
                // TODO: Throw error for testing
            }
            try? await Task.sleep(nanoseconds: 50_000_000)
            return "Data \(count)"
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator()
    }
}

// TODO: Create actor-isolated async sequence
actor DataProvider {
    private var values: [Int] = []
    
    func addValue(_ value: Int) {
        values.append(value)
    }
    
    // TODO: Provide async sequence of values
    func values() -> AsyncStream<Int> {
        // Return stream of current values
        return AsyncStream { _ in }
    }
}

func main() {
    test("Custom AsyncSequence") {
        let expectation = DispatchSemaphore(value: 0)
        var collected: [Int] = []
        
        Task {
            let counter = Counter(limit: 5)
            for await value in counter {
                collected.append(value)
            }
            
            assertEqual(collected, [0, 1, 2, 3, 4], "Should iterate to limit")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("AsyncStream creation") {
        let expectation = DispatchSemaphore(value: 0)
        var received: [Int] = []
        
        Task {
            let stream = numberStream()
            for await number in stream {
                received.append(number)
                if received.count >= 3 {
                    break
                }
            }
            
            assertEqual(received, [1, 2, 3], "Should receive streamed values")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("Sendable conformance") {
        let message = Message(id: 1, text: "Hello", callback: nil)
        
        Task {
            // This should compile if Message is properly Sendable
            await processMessage(message)
        }
        
        assertTrue(true, "Sendable type can cross concurrency boundaries")
    }
    
    test("AsyncSequence transformation") {
        let expectation = DispatchSemaphore(value: 0)
        var squared: [Int] = []
        
        Task {
            let numbers = Counter(limit: 4)
            for await value in numbers.square() {
                squared.append(value)
            }
            
            assertEqual(squared, [0, 1, 4, 9], "Values should be squared")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("AsyncSequence error handling") {
        let expectation = DispatchSemaphore(value: 0)
        var collected: [String] = []
        var errorOccurred = false
        
        Task {
            let stream = DataStream()
            do {
                for try await data in stream {
                    collected.append(data)
                }
            } catch {
                errorOccurred = true
            }
            
            assertEqual(collected, ["Data 1"], "Should collect until error")
            assertTrue(errorOccurred, "Should catch error")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("Actor-isolated AsyncSequence") {
        let expectation = DispatchSemaphore(value: 0)
        let provider = DataProvider()
        
        Task {
            // Add values
            await provider.addValue(10)
            await provider.addValue(20)
            await provider.addValue(30)
            
            // Stream values
            var streamed: [Int] = []
            for await value in await provider.values() {
                streamed.append(value)
            }
            
            assertEqual(streamed, [10, 20, 30], "Should stream actor values")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    runTests()
}

func processMessage(_ message: Message) async {
    print("Processing message: \(message.text)")
}

// Fixed Sendable conformance
struct SendableMessage: Sendable {
    let id: Int
    let text: String
    // No non-Sendable stored properties
}