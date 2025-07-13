// optionals1.swift
//
// Optionals represent values that might be missing (nil).
// They're Swift's way of handling the absence of a value safely.
//
// Fix the optional declarations and unwrapping to make the tests pass.

func optionalBasics() -> (name: String, age: String, city: String) {
    // TODO: Fix the optional declaration syntax
    let name: String? = "Alice"
    let age: Int? = 25
    let city: String? = nil
    
    // TODO: Safely unwrap name using if-let
    var unwrappedName = "Unknown"
    if name {  // This needs proper optional binding
        unwrappedName = name
    }
    
    // TODO: Force unwrap age (only do this when you're certain it's not nil!)
    let unwrappedAge = age  // Missing force unwrap operator
    
    // TODO: Use nil-coalescing operator for city
    let unwrappedCity = city  // Should provide default value
    
    return (unwrappedName, "Age: \(unwrappedAge)", unwrappedCity)
}

func findInArray() -> (found: Int, notFound: Int) {
    let numbers = [10, 20, 30, 40, 50]
    
    // TODO: firstIndex returns optional - handle it correctly
    let index1 = numbers.firstIndex(of: 30)  // This is Int?
    let foundValue = index1  // Need to unwrap and handle
    
    // TODO: Handle the case when value is not found
    let index2 = numbers.firstIndex(of: 99)
    let notFoundValue = index2 ?? -1  // This gives index, not value
    
    return (foundValue, notFoundValue)
}

func main() {
    test("Optional basics") {
        let result = optionalBasics()
        assertEqual(result.name, "Alice", "Name should be unwrapped")
        assertEqual(result.age, "Age: 25", "Age should be force unwrapped")
        assertEqual(result.city, "Unknown", "City should use default value")
    }
    
    test("Array optional returns") {
        let result = findInArray()
        assertEqual(result.found, 30, "Should find value 30")
        assertEqual(result.notFound, -1, "Should return -1 when not found")
    }
    
    runTests()
}