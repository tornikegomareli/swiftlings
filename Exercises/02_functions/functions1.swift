// functions1.swift
//
// Functions are self-contained chunks of code that perform a specific task.
// In Swift, functions are declared with the `func` keyword.
//
// Fix the function declarations to make the tests pass.

// TODO: Fix this function - it needs a return type
func greet(name: String) {
    return "Hello, \(name)!"
}

// TODO: Fix this function - it's missing parameters
func add() -> Int {
    return a + b
}

// TODO: Fix this function - parameter names don't match usage
func multiply(x: Int, y: Int) -> Int {
    return first * second
}

func main() {
    test("Greeting function works correctly") {
        assertEqual(greet(name: "Alice"), "Hello, Alice!", "Should greet Alice")
        assertEqual(greet(name: "Bob"), "Hello, Bob!", "Should greet Bob")
    }
    
    test("Addition function works correctly") {
        assertEqual(add(5, 3), 8, "5 + 3 = 8")
        assertEqual(add(10, -5), 5, "10 + (-5) = 5")
        assertEqual(add(0, 0), 0, "0 + 0 = 0")
    }
    
    test("Multiplication function works correctly") {
        assertEqual(multiply(x: 4, y: 5), 20, "4 * 5 = 20")
        assertEqual(multiply(x: -3, y: 2), -6, "-3 * 2 = -6")
        assertEqual(multiply(x: 0, y: 100), 0, "0 * 100 = 0")
    }
    
    runTests()
}