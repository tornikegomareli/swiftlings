// if1.swift
//
// The `if` statement is one of the most basic control flow structures in Swift.
// It allows you to execute code based on a condition.
//
// Fix the condition in the if statement to make the tests pass.

func checkAge(_ age: Int) -> String {
    var status: String
    
    // TODO: Fix the condition - it should check if age is greater than or equal to 18
    if age {
        status = "Adult"
    } else {
        status = "Minor"
    }
    
    return status
}

func main() {
    test("Age checker correctly identifies adults") {
        assertEqual(checkAge(18), "Adult", "Age 18 should be adult")
        assertEqual(checkAge(21), "Adult", "Age 21 should be adult")
        assertEqual(checkAge(65), "Adult", "Age 65 should be adult")
    }
    
    test("Age checker correctly identifies minors") {
        assertEqual(checkAge(5), "Minor", "Age 5 should be minor")
        assertEqual(checkAge(12), "Minor", "Age 12 should be minor")
        assertEqual(checkAge(17), "Minor", "Age 17 should be minor")
    }
    
    runTests()
}