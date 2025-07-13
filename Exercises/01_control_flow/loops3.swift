// loops3.swift
//
// Loop control statements `break` and `continue` allow you to
// alter the flow of loops.
// - `break` exits the loop entirely
// - `continue` skips to the next iteration
//
// Fix the loops to use break and continue correctly.

func findFirstNegative(in numbers: [Int]) -> Int? {
    for number in numbers {
        if number < 0 {
            // TODO: We found a negative number! What should we do?
            // Hint: We want to stop searching and return this number
        }
    }
    return nil
}

func sumPositiveNumbers(in numbers: [Int]) -> Int {
    var sum = 0
    
    for number in numbers {
        if number < 0 {
            // TODO: Skip negative numbers
            // Hint: Use a control statement to skip to the next iteration
        }
        sum += number
    }
    
    return sum
}

func main() {
    test("Find first negative number") {
        assertEqual(findFirstNegative(in: [1, 2, -3, 4, -5]), -3, "First negative is -3")
        assertEqual(findFirstNegative(in: [-1, -2, -3]), -1, "First negative is -1")
        assertNil(findFirstNegative(in: [1, 2, 3, 4]), "No negative numbers")
        assertNil(findFirstNegative(in: []), "Empty array has no negatives")
    }
    
    test("Sum only positive numbers") {
        assertEqual(sumPositiveNumbers(in: [1, -2, 3, -4, 5]), 9, "1 + 3 + 5 = 9")
        assertEqual(sumPositiveNumbers(in: [-1, -2, -3]), 0, "No positive numbers")
        assertEqual(sumPositiveNumbers(in: [10, 20, 30]), 60, "All positive numbers")
        assertEqual(sumPositiveNumbers(in: [5, -5, 10, -10]), 15, "5 + 10 = 15")
    }
    
    runTests()
}