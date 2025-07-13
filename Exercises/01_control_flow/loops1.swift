// loops1.swift
//
// The `for-in` loop is the most common way to iterate in Swift.
// It can iterate over ranges, arrays, and other sequences.
//
// Fix the loops to make the tests pass.

func sumNumbers(from start: Int, to end: Int) -> Int {
    var sum = 0
    
    // TODO: Fix this loop to include both start and end values
    // Hint: Use the closed range operator
    for i in start..<end {
        sum += i
    }
    
    return sum
}

func countEvens(in numbers: [Int]) -> Int {
    var count = 0
    
    // TODO: Add a condition to count only even numbers
    // Hint: Use the modulo operator (%) to check if divisible by 2
    for number in numbers {
        count += 1
    }
    
    return count
}

func main() {
    test("Sum includes both start and end") {
        assertEqual(sumNumbers(from: 1, to: 5), 15, "1+2+3+4+5 = 15")
        assertEqual(sumNumbers(from: 10, to: 10), 10, "Single number range")
        assertEqual(sumNumbers(from: 0, to: 3), 6, "0+1+2+3 = 6")
    }
    
    test("Count even numbers correctly") {
        assertEqual(countEvens(in: [1, 2, 3, 4, 5]), 2, "2 and 4 are even")
        assertEqual(countEvens(in: [2, 4, 6, 8]), 4, "All numbers are even")
        assertEqual(countEvens(in: [1, 3, 5, 7]), 0, "No even numbers")
        assertEqual(countEvens(in: []), 0, "Empty array has no evens")
    }
    
    runTests()
}