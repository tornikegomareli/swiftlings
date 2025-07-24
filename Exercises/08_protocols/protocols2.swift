// protocols2.swift
//
// Protocols can inherit from other protocols and have optional requirements.
// Protocol extensions provide default implementations.
//
// Fix the protocol inheritance and extensions to make the tests pass.

protocol Vehicle {
    var numberOfWheels: Int { get }
    var maxSpeed: Double { get }
}

// TODO: Make this protocol inherit from Vehicle
protocol MotorVehicle {  // Missing inheritance
    var engineSize: Double { get }
    func startEngine() -> String
}

// TODO: Add protocol extension with default implementation
extension Vehicle {
    // Add default implementation for description
}

// TODO: Add protocol extension for MotorVehicle
extension MotorVehicle {
    // Add default implementation for startEngine
}

struct Bicycle: Vehicle {
    let numberOfWheels = 2
    let maxSpeed = 30.0
}

struct Car: MotorVehicle {
    let numberOfWheels = 4
    let maxSpeed = 200.0
    let engineSize = 2.0
    
    // TODO: Should we implement startEngine? Check the extension!
    func startEngine() -> String {
        return "Car engine started"
    }
}

struct Motorcycle: MotorVehicle {
    // TODO: Implement all requirements
    // Remember: MotorVehicle inherits from Vehicle
}

// TODO: Create a generic function constrained to Vehicle
func race<T>(vehicle: T) -> String {  // Missing constraint
    return "Racing at \(vehicle.maxSpeed) km/h"  // Won't compile without constraint
}

func main() {
    test("Protocol inheritance") {
        let car = Car()
        assertEqual(car.numberOfWheels, 4, "Car has 4 wheels")
        assertEqual(car.engineSize, 2.0, "Car engine size")
        
        let moto = Motorcycle()
        assertEqual(moto.numberOfWheels, 2, "Motorcycle has 2 wheels")
        assertEqual(moto.maxSpeed, 180.0, "Motorcycle max speed")
        assertEqual(moto.engineSize, 1.0, "Motorcycle engine size")
    }
    
    test("Protocol extensions") {
        let bike = Bicycle()
        assertEqual(bike.description, "Vehicle with 2 wheels, max speed: 30.0 km/h", 
                   "Default description")
        
        let car = Car()
        assertEqual(car.startEngine(), "Vroom! Engine size: 2.0L", 
                   "Default engine start")
        
        let moto = Motorcycle()
        assertEqual(moto.startEngine(), "Vroom! Engine size: 1.0L", 
                   "Uses default implementation")
    }
    
    test("Generic constraints") {
        let bike = Bicycle()
        assertEqual(race(vehicle: bike), "Racing at 30.0 km/h", "Race bicycle")
        
        let car = Car()
        assertEqual(race(vehicle: car), "Racing at 200.0 km/h", "Race car")
    }
    
    runTests()
}