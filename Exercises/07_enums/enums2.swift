// enums2.swift
//
// Enums can have associated values that store additional information.
// This makes them powerful for modeling data with variations.
//
// Fix the enums with associated values to make the tests pass.

enum Result<T> {
    case success(T)
    case failure(String)
}

// TODO: Define a Barcode enum with associated values
enum Barcode {
    // Add cases:
    // - upc with 4 Int values
    // - qrCode with a String value
}

// TODO: Define a NetworkResponse enum
enum NetworkResponse {
    case success(data: Data, statusCode: Int)  // Wrong - don't use labels in enum case
    case error(String)
    case timeout
}

// For this exercise, use a simple Data type
struct Data {
    let content: String
}

func createBarcode() -> Barcode {
    // TODO: Create a UPC barcode with values (8, 85909, 51226, 3)
    return Barcode.upc  // Missing associated values
}

func handleResponse(_ response: NetworkResponse) -> String {
    // TODO: Use switch with pattern matching to extract values
    switch response {
    case .success:  // Not extracting the associated values
        return "Success"
    case .error:
        return "Error"
    case .timeout:
        return "Timeout"
    }
}

func processResult<T>(_ result: Result<T>) -> String {
    switch result {
    // TODO: Extract and use the associated values
    case .success:
        return "Success"
    case .failure:
        return "Failed"
    }
}

func main() {
    test("Enums with associated values") {
        let barcode = createBarcode()
        
        switch barcode {
        case .upc(let a, let b, let c, let d):
            assertEqual(a, 8, "First UPC component")
            assertEqual(b, 85909, "Second UPC component")
            assertEqual(c, 51226, "Third UPC component")
            assertEqual(d, 3, "Fourth UPC component")
        default:
            assertFalse(true, "Should be UPC barcode")
        }
    }
    
    test("Pattern matching with associated values") {
        let successResponse = NetworkResponse.success(Data(content: "Hello"), 200)
        let errorResponse = NetworkResponse.error("Not found")
        let timeoutResponse = NetworkResponse.timeout
        
        assertEqual(handleResponse(successResponse), "Success with 200", 
                   "Should include status code")
        assertEqual(handleResponse(errorResponse), "Error: Not found", 
                   "Should include error message")
        assertEqual(handleResponse(timeoutResponse), "Request timed out", 
                   "Timeout message")
    }
    
    test("Generic enum handling") {
        let success: Result<Int> = .success(42)
        let failure: Result<Int> = .failure("Invalid input")
        
        assertEqual(processResult(success), "Success: 42", 
                   "Should include success value")
        assertEqual(processResult(failure), "Failed: Invalid input", 
                   "Should include error message")
    }
    
    runTests()
}