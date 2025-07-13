// classes1.swift
//
// Classes are reference types that support inheritance and other OOP features.
// Unlike structs, classes don't get automatic memberwise initializers.
//
// Fix the class definitions and usage to make the tests pass.

// TODO: Change to class and add initializer
struct Vehicle {  // Should be class
    var brand: String
    var model: String
    var year: Int
    
    // Classes need explicit initializers
}

// TODO: Define a Car class that inherits from Vehicle
class Car {  // Missing inheritance
    var numberOfDoors: Int
    
    // TODO: Add initializer that calls super.init
    init(numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors
        // Missing super.init call
    }
}

func createVehicles() -> (vehicle: Vehicle, car: Car) {
    // TODO: Create instances with proper initialization
    let vehicle = Vehicle()  // Missing arguments
    let car = Car()  // Missing arguments
    
    return (vehicle, car)
}

func testReferenceSemantics() -> (original: Int, modified: Int) {
    let car1 = Car(brand: "Toyota", model: "Camry", year: 2020, numberOfDoors: 4)
    let car2 = car1  // Reference, not copy
    
    car2.year = 2021
    
    // TODO: Return both years to show they're the same object
    return (car1.year, car2.year)
}

func main() {
    test("Class creation") {
        let (vehicle, car) = createVehicles()
        
        assertEqual(vehicle.brand, "Generic", "Vehicle brand")
        assertEqual(vehicle.model, "Model", "Vehicle model")
        assertEqual(vehicle.year, 2024, "Vehicle year")
        
        assertEqual(car.brand, "Honda", "Car brand")
        assertEqual(car.model, "Civic", "Car model")
        assertEqual(car.year, 2023, "Car year")
        assertEqual(car.numberOfDoors, 4, "Car doors")
    }
    
    test("Reference semantics") {
        let (original, modified) = testReferenceSemantics()
        assertEqual(original, 2021, "Original should be modified")
        assertEqual(modified, 2021, "Both should have same value")
    }
    
    runTests()
}