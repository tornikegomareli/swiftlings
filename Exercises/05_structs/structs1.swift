// structs1.swift
//
// Structs are value types that encapsulate data and functionality.
// They're one of the most important building blocks in Swift.
//
// Fix the struct definition and usage to make the tests pass.

// TODO: Define a struct called 'Point' with x and y properties
class Point {  // Wrong keyword - should be struct
    var x: Int
    var y: Int
}

// TODO: Define a struct called 'Person' with name (String) and age (Int)
struct Person {
    // Add properties here
}

func createStructs() -> (point: Point, person: Person) {
    // TODO: Create a Point at (10, 20)
    let point = Point()  // Missing initializer arguments
    
    // TODO: Create a Person named "Alice" aged 30
    let person = Person()  // Missing initializer arguments
    
    return (point, person)
}

func main() {
    test("Struct creation and properties") {
        let (point, person) = createStructs()
        
        assertEqual(point.x, 10, "Point x should be 10")
        assertEqual(point.y, 20, "Point y should be 20")
        assertEqual(person.name, "Alice", "Person name should be Alice")
        assertEqual(person.age, 30, "Person age should be 30")
    }
    
    test("Structs are value types") {
        var p1 = Point(x: 5, y: 10)
        var p2 = p1  // This creates a copy
        p2.x = 15
        
        assertEqual(p1.x, 5, "Original point should not change")
        assertEqual(p2.x, 15, "Copy should have new value")
    }
    
    runTests()
}