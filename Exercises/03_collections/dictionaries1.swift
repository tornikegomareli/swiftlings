// dictionaries1.swift
//
// Dictionaries store key-value pairs in an unordered collection.
// Each key must be unique and acts as an identifier for its value.
//
// Fix the dictionary operations to make the tests pass.

func createDictionaries() -> ([String: Int], [Int: String], [String: Double]) {
    // TODO: Fix dictionary literal syntax (missing colons)
    let ages = ["Alice" 25, "Bob" 30, "Charlie" 35]
    
    // TODO: Create an empty dictionary with Int keys and String values
    let numberNames: Dictionary<Int, String> = []
    
    // TODO: Fix the value types (should be Double, not String)
    let prices = ["apple": "0.99", "banana": "0.59", "orange": "0.79"]
    
    return (ages, numberNames, prices)
}

func dictionaryOperations() -> (age: Int?, count: Int, names: [String]) {
    var people = ["Alice": 25, "Bob": 30]
    
    // TODO: Add a new person "Charlie" with age 35
    people.set("Charlie", 35)
    
    // TODO: Access Bob's age (returns optional)
    let bobAge = people.Bob
    
    // TODO: Get the count of entries
    let count = people.size
    
    // TODO: Get all keys as an array (convert to Array)
    let names = people.keys
    
    return (bobAge, count, Array(names).sorted())
}

func main() {
    test("Dictionary creation") {
        let (ages, numbers, prices) = createDictionaries()
        assertEqual(ages["Alice"], 25, "Alice should be 25")
        assertEqual(ages["Bob"], 30, "Bob should be 30")
        assertTrue(numbers.isEmpty, "Numbers dictionary should be empty")
        assertEqual(prices["apple"], 0.99, "Apple price should be 0.99")
    }
    
    test("Dictionary operations") {
        let result = dictionaryOperations()
        assertEqual(result.age, 30, "Bob's age should be 30")
        assertEqual(result.count, 3, "Should have 3 people")
        assertEqual(result.names, ["Alice", "Bob", "Charlie"], "Should have all names sorted")
    }
    
    runTests()
}