// extensions2.swift
//
// Extensions can add protocol conformance to existing types.
// They can also add initializers and subscripts.
//
// Fix the extensions to make the tests pass.

protocol Describable {
    var description: String { get }
}

// TODO: Make Int conform to Describable via extension
extension Int {  // Missing protocol conformance
    // Implement description
}

// TODO: Add a custom initializer to String
extension String {
    // Add init(repeating character: Character, count: Int)
    init(repeating character: Character, count: Int) {
        self = ""  // Wrong implementation
    }
    
    // Add subscript for safe character access
    subscript(safe index: Int) -> Character? {
        // Return character at index, or nil if out of bounds
        return nil  // Implement this
    }
}

struct Point {
    var x: Double
    var y: Double
}

// TODO: Add convenience initializers to Point
extension Point {
    // Add init(value: Double) that sets both x and y to value
    
    // Add init() that creates origin (0, 0)
    
    // Add static property for origin
    static var origin: Point {
        return Point(x: 1, y: 1)  // Wrong values
    }
}

// TODO: Make Array conform to Describable when Element is Describable
extension Array: Describable {  // Missing constraint
    var description: String {
        return "Array"  // Should describe contents
    }
}

func main() {
    test("Protocol conformance via extension") {
        let number: Describable = 42
        assertEqual(number.description, "Integer: 42", "Int description")
        
        let negative: Describable = -10
        assertEqual(negative.description, "Integer: -10", "Negative int description")
    }
    
    test("Custom initializers") {
        let stars = String(repeating: "*", count: 5)
        assertEqual(stars, "*****", "Repeated character string")
        
        let empty = String(repeating: "X", count: 0)
        assertEqual(empty, "", "Zero count gives empty string")
    }
    
    test("Subscripts in extensions") {
        let text = "Hello"
        assertEqual(text[safe: 0], "H", "First character")
        assertEqual(text[safe: 4], "o", "Last character")
        assertNil(text[safe: 5], "Out of bounds returns nil")
        assertNil(text[safe: -1], "Negative index returns nil")
    }
    
    test("Convenience initializers") {
        let square = Point(value: 5)
        assertEqual(square.x, 5.0, "Square point x")
        assertEqual(square.y, 5.0, "Square point y")
        
        let origin = Point()
        assertEqual(origin.x, 0.0, "Origin x")
        assertEqual(origin.y, 0.0, "Origin y")
        
        assertEqual(Point.origin.x, 0.0, "Static origin x")
        assertEqual(Point.origin.y, 0.0, "Static origin y")
    }
    
    test("Conditional conformance") {
        let numbers: [Describable] = [1, 2, 3]
        let array: Describable = numbers
        assertEqual(array.description, "[Integer: 1, Integer: 2, Integer: 3]", 
                   "Array of describables")
    }
    
    runTests()
}