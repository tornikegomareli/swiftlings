// error_handling3.swift
//
// Converting between error types and using Result type.
// Rethrowing functions can propagate errors from their function parameters.
//
// Fix the error conversions and rethrowing to make the tests pass.

enum NetworkError: Error {
    case noConnection
    case timeout
    case serverError(code: Int)
}

enum DataError: Error {
    case invalidFormat
    case missingData
}

// TODO: Create a function that converts error types
func fetchAndParse(url: String) throws -> String {
    // Simulate network fetch
    if url.isEmpty {
        throw NetworkError.noConnection
    }
    
    let data = try fetchData(from: url)
    
    // TODO: Handle the parsing error and convert to DataError
    let parsed = parseData(data)  // This returns Result type
    
    return parsed  // Need to extract value or throw
}

func fetchData(from url: String) throws -> String {
    if url == "timeout" {
        throw NetworkError.timeout
    }
    if url.hasPrefix("error") {
        throw NetworkError.serverError(code: 500)
    }
    return "raw_data_from_\(url)"
}

func parseData(_ data: String) -> Result<String, DataError> {
    if data.isEmpty {
        return .failure(.missingData)
    }
    if !data.hasPrefix("raw_data") {
        return .failure(.invalidFormat)
    }
    return .success("parsed: \(data)")
}

// TODO: Create a rethrowing function
func performOperation<T>(_ operation: () throws -> T) -> T? {  // Should be rethrowing
    do {
        return try operation()
    } catch {
        return nil  // Should rethrow, not swallow errors
    }
}

// TODO: Use Result type with map and flatMap
func processMultipleUrls(_ urls: [String]) -> [Result<String, Error>] {
    return urls.map { url in
        // Convert throwing function to Result
        do {
            let result = try fetchAndParse(url: url)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}

// TODO: Create custom error with associated values
enum ValidationError: Error {
    case outOfRange(value: Int, range: ClosedRange<Int>)
    case invalidInput(String)
    
    // Add computed property for error description
    var description: String {
        return ""  // Implement based on case
    }
}

func validateAge(_ age: Int) throws {
    let validRange = 0...150
    if !validRange.contains(age) {
        // TODO: Throw appropriate error with associated values
    }
}

func main() {
    test("Error type conversion") {
        do {
            let result = try fetchAndParse(url: "valid.com")
            assertEqual(result, "parsed: raw_data_from_valid.com", "Valid URL parsed")
        } catch {
            assertFalse(true, "Should not throw for valid URL")
        }
        
        do {
            _ = try fetchAndParse(url: "")
            assertFalse(true, "Should throw noConnection")
        } catch NetworkError.noConnection {
            assertTrue(true, "Caught network error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Rethrowing functions") {
        // Test with non-throwing closure
        let result1 = performOperation { "success" }
        assertEqual(result1, "success", "Non-throwing operation")
        
        // Test with throwing closure
        do {
            _ = try performOperation { 
                throw NetworkError.timeout 
            }
            assertFalse(true, "Should rethrow error")
        } catch NetworkError.timeout {
            assertTrue(true, "Error was rethrown")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Result type usage") {
        let urls = ["good.com", "", "timeout", "another.com"]
        let results = processMultipleUrls(urls)
        
        assertEqual(results.count, 4, "All URLs processed")
        
        // Check first result (success)
        switch results[0] {
        case .success(let value):
            assertTrue(value.contains("parsed"), "First URL succeeded")
        case .failure:
            assertFalse(true, "First URL should succeed")
        }
        
        // Check second result (failure)
        switch results[1] {
        case .success:
            assertFalse(true, "Empty URL should fail")
        case .failure(let error):
            assertTrue(error is NetworkError, "Should be network error")
        }
    }
    
    test("Custom error with associated values") {
        do {
            try validateAge(200)
            assertFalse(true, "Should throw outOfRange")
        } catch let ValidationError.outOfRange(value, range) {
            assertEqual(value, 200, "Error contains value")
            assertEqual(range, 0...150, "Error contains range")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        let error = ValidationError.invalidInput("test")
        assertEqual(error.description, "Invalid input: test", "Error description")
    }
    
    runTests()
}