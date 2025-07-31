// concurrency1.swift
//
// Swift's modern concurrency system uses async/await for asynchronous code.
// Functions can be marked async and called with await.
//
// Fix the async/await syntax to make the tests pass.

import Foundation

// TODO: Make this function async
func fetchUserData(id: Int) -> String {  // Missing async
    // Simulate network delay
    Thread.sleep(forTimeInterval: 0.1)
    return "User \(id)"
}

// TODO: Create an async function that throws
func validateUser(id: Int) -> Bool {  // Should be async throws
    if id < 0 {
        throw ValidationError.invalidID
    }
    // Simulate async validation
    Thread.sleep(forTimeInterval: 0.1)
    return id > 0
}

enum ValidationError: Error {
    case invalidID
}

// TODO: Fix async function calls
func loadUserProfile(id: Int) async throws -> String {
    // Call async functions
    let userData = fetchUserData(id: id)  // Missing await
    let isValid = validateUser(id: id)    // Missing try await
    
    if isValid {
        return "Profile: \(userData)"
    } else {
        throw ValidationError.invalidID
    }
}

// TODO: Create async computed property
struct DataLoader {
    let url: String
    
    // TODO: This should be an async function, not property
    var data: String {  // Can't have async properties
        get async {
            // Simulate loading
            Thread.sleep(forTimeInterval: 0.1)
            return "Data from \(url)"
        }
    }
}

// TODO: Convert callback-based API to async
func oldFetchData(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        completion("Legacy data")
    }
}

func fetchDataAsync() async -> String {
    // TODO: Use withCheckedContinuation
    return "Not implemented"
}

func main() {
    test("Basic async/await") {
        let expectation = DispatchSemaphore(value: 0)
        var result = ""
        
        Task {
            result = await fetchUserData(id: 42)
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(result, "User 42", "Should fetch user data")
    }
    
    test("Async throwing functions") {
        let expectation = DispatchSemaphore(value: 0)
        var result: Result<Bool, Error>?
        
        Task {
            do {
                let isValid = try await validateUser(id: 5)
                result = .success(isValid)
            } catch {
                result = .failure(error)
            }
            expectation.signal()
        }
        
        expectation.wait()
        
        switch result {
        case .success(let isValid):
            assertTrue(isValid, "User 5 should be valid")
        case .failure, .none:
            assertFalse(true, "Should not fail for valid ID")
        }
    }
    
    test("Composed async functions") {
        let expectation = DispatchSemaphore(value: 0)
        var profile: String?
        
        Task {
            do {
                profile = try await loadUserProfile(id: 10)
            } catch {
                profile = "Error: \(error)"
            }
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(profile, "Profile: User 10", "Should load user profile")
    }
    
    test("Async methods") {
        let expectation = DispatchSemaphore(value: 0)
        let loader = DataLoader(url: "https://example.com")
        var data = ""
        
        Task {
            data = await loader.loadData()
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(data, "Data from https://example.com", "Should load data")
    }
    
    test("Continuation bridge") {
        let expectation = DispatchSemaphore(value: 0)
        var result = ""
        
        Task {
            result = await fetchDataAsync()
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(result, "Legacy data", "Should bridge callback to async")
    }
    
    runTests()
}

// Extension to fix async property issue
extension DataLoader {
    func loadData() async -> String {
        // Simulate loading
        try? await Task.sleep(nanoseconds: 100_000_000)
        return "Data from \(url)"
    }
}