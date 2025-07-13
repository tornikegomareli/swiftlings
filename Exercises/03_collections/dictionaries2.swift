// dictionaries2.swift
//
// Dictionary operations often involve optionals since keys might not exist.
// Let's practice safe dictionary access and updates.
//
// Fix the dictionary operations to handle optionals correctly.

func updateDictionary() -> [String: Int] {
    var scores = ["Alice": 90, "Bob": 85]
    
    // TODO: Update Bob's score to 95 using subscript
    scores["Bob"] += 10  // This won't compile - fix it!
    
    // TODO: Use updateValue to set Charlie to 88 and capture old value
    let oldValue = scores.updateValue(88, key: "Charlie")
    
    // TODO: Remove Alice from the dictionary
    scores.removeValue("Alice")
    
    // TODO: Use nil to remove a value (remove "David" if exists)
    scores["David"] = 0  // This adds David - use nil instead
    
    return scores
}

func safeDictionaryAccess() -> (found: String, notFound: String, withDefault: Int) {
    let inventory = ["apples": 10, "bananas": 5, "oranges": 8]
    
    // TODO: Safely unwrap the optional value for "bananas"
    let found = inventory["bananas"]  // This is Int?, need String
    
    // TODO: Provide a default message when key doesn't exist
    let notFound = inventory["grapes"] ?? 0  // Need String, not Int
    
    // TODO: Use default subscript (available in Swift 4+)
    let withDefault = inventory["pears"] ?? 0
    
    return (found: "\(found ?? 0) bananas", 
            notFound: "No grapes", 
            withDefault: withDefault)
}

func main() {
    test("Dictionary updates") {
        let scores = updateDictionary()
        assertEqual(scores["Bob"], 95, "Bob's score should be 95")
        assertEqual(scores["Charlie"], 88, "Charlie's score should be 88")
        assertNil(scores["Alice"], "Alice should be removed")
        assertNil(scores["David"], "David should not exist")
    }
    
    test("Safe dictionary access") {
        let result = safeDictionaryAccess()
        assertEqual(result.found, "5 bananas", "Should find bananas")
        assertEqual(result.notFound, "No grapes", "Should handle missing key")
        assertEqual(result.withDefault, 0, "Should use default value")
    }
    
    runTests()
}