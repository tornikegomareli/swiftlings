// functions3.swift
//
// Functions can have default parameter values and variadic parameters.
// Default values allow parameters to be omitted when calling the function.
// Variadic parameters accept zero or more values of a specified type.
//
// Fix the functions to use these features correctly.

// TODO: Add a default value of 1.0 for the rate parameter
func calculateInterest(principal: Double, rate: Double, years: Int) -> Double {
    return principal * rate * Double(years)
}

// TODO: Make 'numbers' a variadic parameter that accepts multiple integers
func sum(numbers: Int) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}

// TODO: Add default values: separator = ", " and terminator = "!"
func joinWords(words: [String], separator: String, terminator: String) -> String {
    return words.joined(separator: separator) + terminator
}

func main() {
    test("Calculate interest with and without default rate") {
        assertEqual(calculateInterest(principal: 1000, rate: 0.05, years: 2), 100.0, 
                   "1000 * 0.05 * 2 = 100")
        assertEqual(calculateInterest(principal: 1000, years: 2), 2000.0, 
                   "Should use default rate of 1.0")
    }
    
    test("Sum variadic parameters") {
        assertEqual(sum(numbers: 1, 2, 3, 4, 5), 15, "Sum of 1,2,3,4,5")
        assertEqual(sum(numbers: 10), 10, "Single number")
        assertEqual(sum(numbers: ), 0, "No numbers should return 0")
    }
    
    test("Join words with default parameters") {
        assertEqual(joinWords(words: ["Hello", "World"]), "Hello, World!", 
                   "Should use default separator and terminator")
        assertEqual(joinWords(words: ["A", "B", "C"], separator: "-"), "A-B-C!", 
                   "Custom separator, default terminator")
        assertEqual(joinWords(words: ["Hi"], separator: " ", terminator: "?"), "Hi?", 
                   "Custom terminator")
    }
    
    runTests()
}