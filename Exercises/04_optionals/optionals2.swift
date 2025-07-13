// optionals2.swift
//
// Guard statements provide early exit when optionals are nil.
// They're perfect for validating preconditions at the start of a function.
//
// Fix the guard statements to make the tests pass.

func validateUser(name: String?, age: Int?, email: String?) -> String {
    // TODO: Fix guard statement syntax - use guard-let
    guard name else {
        return "Error: Name is required"
    }
    
    // TODO: Guard with multiple optional bindings
    guard age, email else {  // Need proper syntax for multiple bindings
        return "Error: Age and email are required"
    }
    
    // TODO: Add condition to guard statement (age must be >= 18)
    guard age >= 18 else {  // 'age' is already unwrapped above, fix variable name
        return "Error: Must be 18 or older"
    }
    
    // All validations passed
    return "Welcome \(name)! Confirmation sent to \(email)"
}

func processNumbers(_ numbers: [Int]?) -> Int {
    // TODO: Guard against nil array
    guard numbers != nil else {  // Should use optional binding
        return 0
    }
    
    // TODO: Guard against empty array (use the unwrapped value)
    guard !numbers.isEmpty else {  // 'numbers' is still optional here
        return 0
    }
    
    // TODO: Calculate sum of unwrapped array
    return numbers.reduce(0, +)  // Still using optional
}

func main() {
    test("User validation with guard") {
        assertEqual(validateUser(name: nil, age: 25, email: "test@example.com"), 
                   "Error: Name is required", "Should fail on nil name")
        assertEqual(validateUser(name: "Alice", age: nil, email: nil), 
                   "Error: Age and email are required", "Should fail on nil age/email")
        assertEqual(validateUser(name: "Bob", age: 16, email: "bob@example.com"), 
                   "Error: Must be 18 or older", "Should fail on underage")
        assertEqual(validateUser(name: "Charlie", age: 21, email: "charlie@example.com"), 
                   "Welcome Charlie! Confirmation sent to charlie@example.com", "Should succeed")
    }
    
    test("Process optional array") {
        assertEqual(processNumbers(nil), 0, "Nil array returns 0")
        assertEqual(processNumbers([]), 0, "Empty array returns 0")
        assertEqual(processNumbers([1, 2, 3, 4, 5]), 15, "Sum of 1-5 is 15")
    }
    
    runTests()
}