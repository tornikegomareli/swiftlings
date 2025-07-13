// functions2.swift
//
// Swift functions can have external and internal parameter names.
// External names are used when calling the function.
// Internal names are used inside the function body.
//
// Fix the function parameter names to make the tests pass.

// TODO: Fix external parameter names
// Currently: calculate(x:, y:)
// Should be: calculate(base:, exponent:)
func calculate(x base: Int, y exponent: Int) -> Int {
    var result = 1
    for _ in 0..<exponent {
        result *= base
    }
    return result
}

// TODO: Add external parameter name 'of' for better readability
func double(number: Int) -> Int {
    return number * 2
}

// TODO: Use underscore to omit external parameter name
func increment(value: Int) -> Int {
    return value + 1
}

func main() {
    test("Calculate power with labeled arguments") {
        assertEqual(calculate(base: 2, exponent: 3), 8, "2^3 = 8")
        assertEqual(calculate(base: 5, exponent: 2), 25, "5^2 = 25")
        assertEqual(calculate(base: 10, exponent: 0), 1, "10^0 = 1")
    }
    
    test("Double function with 'of' label") {
        assertEqual(double(of: 5), 10, "Double of 5 is 10")
        assertEqual(double(of: -3), -6, "Double of -3 is -6")
        assertEqual(double(of: 0), 0, "Double of 0 is 0")
    }
    
    test("Increment without external label") {
        assertEqual(increment(5), 6, "Increment 5 gives 6")
        assertEqual(increment(-1), 0, "Increment -1 gives 0")
        assertEqual(increment(99), 100, "Increment 99 gives 100")
    }
    
    runTests()
}