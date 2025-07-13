// variables3.swift
//
// Constants in Swift are declared using the `let` keyword.
// They cannot be changed after they're created.
//
// Fix this code to use the appropriate declaration.

func calculateCircleArea() -> (smallArea: Double, largeArea: Double) {
    // TODO: This value will never change, so it should be a constant
    let pi = 3.14159
    
    // TODO: This value needs to change, so it should be a variable
    var radius = 5.0
    
    let smallArea = pi * radius * radius
    
    // We need to change the radius for a larger circle
    radius = 10.0
    
    let largeArea = pi * radius * radius
    
    return (smallArea: smallArea, largeArea: largeArea)
}

func main() {
    test("Calculate circle areas with constant pi and variable radius") {
        let result = calculateCircleArea()
        
        // Check small circle area (radius = 5)
        let expectedSmall = 3.14159 * 5.0 * 5.0
        assertTrue(abs(result.smallArea - expectedSmall) < 0.0001, "Small circle area should be approximately \(expectedSmall)")
        
        // Check large circle area (radius = 10)
        let expectedLarge = 3.14159 * 10.0 * 10.0
        assertTrue(abs(result.largeArea - expectedLarge) < 0.0001, "Large circle area should be approximately \(expectedLarge)")
    }
    
    runTests()
}
