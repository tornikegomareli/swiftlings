// arrays1.swift
//
// Arrays are ordered collections of values of the same type.
// Swift arrays are type-safe and always clear about what they contain.
//
// Fix the array declarations and operations to make the tests pass.

func createArrays() -> ([Int], [String], [Double]) {
    // TODO: Fix array literal syntax
    let numbers = [1 2 3 4 5]
    
    // TODO: Create an empty array of Strings
    let words: String = []
    
    // TODO: Fix the array type annotation
    let prices: Array<Int> = [9.99, 19.99, 29.99]
    
    return (numbers, words, prices)
}

func arrayOperations() -> (first: Int, count: Int, sum: Int) {
    let numbers = [10, 20, 30, 40, 50]
    
    // TODO: Access the first element (fix the index)
    let first = numbers[1]
    
    // TODO: Get the count of elements (use the right property)
    let count = numbers.length
    
    // TODO: Calculate sum using a loop
    let sum = 0  // This should be 'var' and you need to add the loop
    
    return (first, count, sum)
}

func main() {
    test("Array creation") {
        let (nums, words, prices) = createArrays()
        assertEqual(nums, [1, 2, 3, 4, 5], "Numbers array should contain 1-5")
        assertEqual(words, [], "Words should be empty array")
        assertEqual(prices, [9.99, 19.99, 29.99], "Prices should be doubles")
    }
    
    test("Array operations") {
        let result = arrayOperations()
        assertEqual(result.first, 10, "First element should be 10")
        assertEqual(result.count, 5, "Array has 5 elements")
        assertEqual(result.sum, 150, "Sum should be 150")
    }
    
    runTests()
}