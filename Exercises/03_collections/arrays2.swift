// arrays2.swift
//
// Arrays in Swift have many useful methods for manipulation.
// Let's explore adding, removing, and modifying array elements.
//
// Fix the array methods to make the tests pass.

func modifyArray() -> [String] {
    var fruits = ["apple", "banana"]
    
    // TODO: Use the correct method to add "orange" to the end
    fruits.add("orange")
    
    // TODO: Insert "mango" at index 1
    fruits.insert("mango", index: 1)
    
    // TODO: Remove the last element
    fruits.remove()
    
    // TODO: Change "banana" to "berry" (it's now at index 2)
    fruits[2] = "berry"
    
    return fruits
}

func arrayTransformations() -> (doubled: [Int], filtered: [Int], mapped: [String]) {
    let numbers = [1, 2, 3, 4, 5]
    
    // TODO: Fix the map syntax to double each number
    let doubled = numbers.map { $0 * 2 }
    
    // TODO: Fix the filter to keep only even numbers
    let filtered = numbers.filter { $0 % 2 }
    
    // TODO: Map numbers to strings with "Item: " prefix
    let mapped = numbers.map { "Item: ($0)" }
    
    return (doubled, filtered, mapped)
}

func main() {
    test("Array modifications") {
        let result = modifyArray()
        assertEqual(result, ["apple", "mango", "berry"], "Array should be modified correctly")
    }
    
    test("Array transformations") {
        let (doubled, filtered, mapped) = arrayTransformations()
        assertEqual(doubled, [2, 4, 6, 8, 10], "Numbers should be doubled")
        assertEqual(filtered, [2, 4], "Only even numbers should remain")
        assertEqual(mapped, ["Item: 1", "Item: 2", "Item: 3", "Item: 4", "Item: 5"], 
                   "Numbers should be mapped to strings")
    }
    
    runTests()
}