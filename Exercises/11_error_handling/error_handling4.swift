// error_handling4.swift
//
// Advanced error handling with do-catch patterns and error transformation.
// LocalizedError protocol provides user-friendly error messages.
//
// Fix the error handling patterns to make the tests pass.

import Foundation

// TODO: Make this conform to LocalizedError
enum AppError: Error {
    case networkUnavailable
    case invalidCredentials
    case serverError(message: String)
    case unknown
    
    // Add LocalizedError properties
}

// TODO: Create a generic Result extension
extension Result {
    // Add method to get value or throw
    func get() throws -> Success {
        return try!  // Wrong implementation
    }
    
    // Add method to map errors
    func mapError<NewFailure>(_ transform: (Failure) -> NewFailure) -> Result<Success, NewFailure> {
        return .failure(transform(NewFailure))  // Wrong implementation
    }
}

// TODO: Handle multiple error types in one catch
func performComplexOperation() throws {
    let random = Int.random(in: 1...4)
    
    switch random {
    case 1: throw AppError.networkUnavailable
    case 2: throw AppError.invalidCredentials
    case 3: throw NSError(domain: "TestDomain", code: 42)
    default: return
    }
}

func handleComplexOperation() -> String {
    do {
        try performComplexOperation()
        return "Success"
    } catch {
        // TODO: Handle different error types
        return "Error"  // Should return specific messages
    }
}

// TODO: Create async throwing function pattern
func fetchUserData(id: Int, completion: @escaping (Result<String, AppError>) -> Void) {
    // Simulate async operation
    DispatchQueue.global().async {
        if id < 0 {
            completion(.failure(.invalidCredentials))
        } else if id == 0 {
            completion(.failure(.serverError(message: "User not found")))
        } else {
            completion(.success("User \(id)"))
        }
    }
}

// TODO: Convert callback-based API to throwing
func getUserSync(id: Int) throws -> String {
    var result: Result<String, AppError>?
    let semaphore = DispatchSemaphore(value: 0)
    
    fetchUserData(id: id) { fetchResult in
        result = fetchResult
        semaphore.signal()
    }
    
    semaphore.wait()
    
    // TODO: Extract value or throw error
    return result!.get()  // This needs proper implementation
}

func main() {
    test("LocalizedError implementation") {
        let error1 = AppError.networkUnavailable
        assertEqual(error1.errorDescription, "Network connection is unavailable", 
                   "Network error description")
        
        let error2 = AppError.invalidCredentials
        assertEqual(error2.errorDescription, "Invalid username or password", 
                   "Credentials error description")
        
        let error3 = AppError.serverError(message: "Database offline")
        assertEqual(error3.errorDescription, "Server error: Database offline", 
                   "Server error with message")
    }
    
    test("Result extensions") {
        let success: Result<Int, AppError> = .success(42)
        do {
            let value = try success.get()
            assertEqual(value, 42, "Get success value")
        } catch {
            assertFalse(true, "Should not throw for success")
        }
        
        let failure: Result<Int, AppError> = .failure(.unknown)
        do {
            _ = try failure.get()
            assertFalse(true, "Should throw for failure")
        } catch AppError.unknown {
            assertTrue(true, "Threw correct error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        // Test mapError
        let mappedError = failure.mapError { _ in "String error" }
        switch mappedError {
        case .success:
            assertFalse(true, "Should still be failure")
        case .failure(let error):
            assertEqual(error, "String error", "Error transformed")
        }
    }
    
    test("Multiple error handling") {
        var results: [String] = []
        
        // Run multiple times to test different errors
        for _ in 1...10 {
            results.append(handleComplexOperation())
        }
        
        // Should have specific error messages
        assertTrue(results.contains("Network unavailable"), "Should handle network error")
        assertTrue(results.contains("Invalid credentials"), "Should handle credentials error")
        assertTrue(results.contains("Unknown error: 42"), "Should handle NSError")
        assertTrue(results.contains("Success"), "Should handle success case")
    }
    
    test("Async to sync conversion") {
        do {
            let user = try getUserSync(id: 1)
            assertEqual(user, "User 1", "Valid user fetched")
        } catch {
            assertFalse(true, "Should not throw for valid ID")
        }
        
        do {
            _ = try getUserSync(id: -1)
            assertFalse(true, "Should throw for negative ID")
        } catch AppError.invalidCredentials {
            assertTrue(true, "Caught credentials error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        do {
            _ = try getUserSync(id: 0)
            assertFalse(true, "Should throw for zero ID")
        } catch AppError.serverError(let message) {
            assertEqual(message, "User not found", "Server error message")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    runTests()
}

// LocalizedError extension
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Network connection is unavailable"
        case .invalidCredentials:
            return "Invalid username or password"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}