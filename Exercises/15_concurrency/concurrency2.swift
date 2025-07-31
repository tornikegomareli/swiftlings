// concurrency2.swift
//
// Tasks and structured concurrency allow concurrent execution.
// Task groups enable dynamic concurrency with automatic management.
//
// Fix the task and task group usage to make the tests pass.

import Foundation

// TODO: Create concurrent tasks
func performConcurrentOperations() async -> (Int, Int) {
    // Start two tasks concurrently
    let task1 = Task {
        return 42  // Should have delay
    }
    
    let task2 = Task {
        return 100  // Should have delay
    }
    
    // TODO: Wait for both tasks
    let result1 = task1  // Missing await
    let result2 = task2  // Missing await
    
    return (result1, result2)
}

// TODO: Use async let for concurrent execution
func fetchMultipleUsers(ids: [Int]) async -> [String] {
    // Fetch first 3 users concurrently
    guard ids.count >= 3 else { return [] }
    
    // TODO: Use async let
    let user1 = fetchUser(id: ids[0])  // Should be async let
    let user2 = fetchUser(id: ids[1])
    let user3 = fetchUser(id: ids[2])
    
    // TODO: Await all results
    return [user1, user2, user3]
}

func fetchUser(id: Int) async -> String {
    try? await Task.sleep(nanoseconds: 100_000_000)
    return "User \(id)"
}

// TODO: Create task group
func processItemsConcurrently(_ items: [Int]) async -> [Int] {
    // Process all items concurrently and collect results
    var results: [Int] = []
    
    // TODO: Use withTaskGroup
    for item in items {
        let processed = await processItem(item)  // Sequential, not concurrent
        results.append(processed)
    }
    
    return results
}

func processItem(_ item: Int) async -> Int {
    try? await Task.sleep(nanoseconds: 50_000_000)
    return item * 2
}

// TODO: Handle task cancellation
func longRunningTask() async throws -> String {
    var result = ""
    
    for i in 0..<10 {
        // TODO: Check for cancellation
        try? await Task.sleep(nanoseconds: 100_000_000)
        result += "\(i)"
    }
    
    return result
}

// TODO: Create throwing task group
func fetchDataWithErrors(urls: [String]) async throws -> [String] {
    // Fetch from URLs, some might fail
    return try await withThrowingTaskGroup(of: String.self) { group in
        for url in urls {
            group.addTask {
                // TODO: Implement fetch that might throw
                return "Data from \(url)"
            }
        }
        
        // TODO: Collect results
        var results: [String] = []
        for try await result in group {
            results.append(result)
        }
        
        return results
    }
}

func main() {
    test("Concurrent task execution") {
        let expectation = DispatchSemaphore(value: 0)
        var result: (Int, Int)?
        
        Task {
            let start = Date()
            result = await performConcurrentOperations()
            let elapsed = Date().timeIntervalSince(start)
            
            // Should run concurrently, not sequentially
            assertTrue(elapsed < 0.3, "Tasks should run concurrently")
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(result?.0, 42, "First task result")
        assertEqual(result?.1, 100, "Second task result")
    }
    
    test("Async let bindings") {
        let expectation = DispatchSemaphore(value: 0)
        var users: [String] = []
        
        Task {
            let start = Date()
            users = await fetchMultipleUsers(ids: [1, 2, 3])
            let elapsed = Date().timeIntervalSince(start)
            
            assertTrue(elapsed < 0.2, "Should fetch concurrently")
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(users, ["User 1", "User 2", "User 3"], "All users fetched")
    }
    
    test("Task groups") {
        let expectation = DispatchSemaphore(value: 0)
        var results: [Int] = []
        
        Task {
            let start = Date()
            results = await processItemsConcurrently([1, 2, 3, 4, 5])
            let elapsed = Date().timeIntervalSince(start)
            
            assertTrue(elapsed < 0.15, "Should process concurrently")
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(results.sorted(), [2, 4, 6, 8, 10], "All items processed")
    }
    
    test("Task cancellation") {
        let expectation = DispatchSemaphore(value: 0)
        var result: Result<String, Error>?
        
        let task = Task {
            do {
                let value = try await longRunningTask()
                result = .success(value)
            } catch {
                result = .failure(error)
            }
            expectation.signal()
        }
        
        // Cancel after short delay
        Task {
            try? await Task.sleep(nanoseconds: 250_000_000)
            task.cancel()
        }
        
        expectation.wait()
        
        switch result {
        case .failure(let error):
            assertTrue(error is CancellationError, "Should be cancelled")
        case .success, .none:
            assertFalse(true, "Task should be cancelled")
        }
    }
    
    test("Throwing task groups") {
        let expectation = DispatchSemaphore(value: 0)
        var results: Result<[String], Error>?
        
        Task {
            do {
                let data = try await fetchDataWithErrors(urls: [
                    "https://api.example.com/1",
                    "https://api.example.com/2",
                    "error://invalid"
                ])
                results = .success(data)
            } catch {
                results = .failure(error)
            }
            expectation.signal()
        }
        
        expectation.wait()
        
        switch results {
        case .success(let data):
            assertEqual(data.count, 2, "Should fetch valid URLs")
        case .failure, .none:
            assertTrue(true, "Error handling works")
        }
    }
    
    runTests()
}