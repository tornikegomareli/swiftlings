// enums3.swift
//
// Enums can have methods, computed properties, and conform to protocols.
// They're full-fledged types in Swift.
//
// Fix the enum methods and properties to make the tests pass.

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    
    // TODO: Add computed property for name
    var name: String {
        switch self {
        case .mercury: return "Mercury"
        // Add remaining cases...
        }
    }
    
    // TODO: Add computed property for isInner (Mercury through Mars)
    var isInner: Bool {
        return true  // Wrong - should check which planet
    }
    
    // TODO: Add method to get distance from sun (in AU)
    func distanceFromSun() -> Double {
        switch self {
        case .mercury: return 0.39
        case .venus: return 0.72
        case .earth: return 1.0
        case .mars: return 1.52
        case .jupiter: return 5.20
        case .saturn: return 9.54
        case .uranus: return 19.19
        case .neptune: return 30.07
        }
    }
    
    // TODO: Add static property for all planets
    var allCases: [Planet] {  // Should be static
        return [.mercury, .venus, .earth, .mars, .jupiter, .saturn, .uranus, .neptune]
    }
}

enum Calculator {
    case number(Double)
    case operation(String)
    
    // TODO: Add method to evaluate
    func evaluate(with value: Double) -> Double? {
        switch self {
        case .number(let n):
            return n  // Just return the number
        case .operation(let op):
            // Apply operation to value
            switch op {
            case "+": return nil  // Should perform addition
            case "-": return nil  // Should perform subtraction
            case "*": return nil  // Should perform multiplication
            case "/": return nil  // Should perform division
            default: return nil
            }
        }
    }
    
    // TODO: Add static factory methods
    func add(_ value: Double) -> Calculator {  // Should be static
        return .operation("+")  // Wrong - should include the value
    }
}

func main() {
    test("Enum properties") {
        let earth = Planet.earth
        assertEqual(earth.name, "Earth", "Planet name")
        assertTrue(earth.isInner, "Earth is inner planet")
        assertEqual(earth.distanceFromSun(), 1.0, "Earth is 1 AU from sun")
        
        let jupiter = Planet.jupiter
        assertEqual(jupiter.name, "Jupiter", "Jupiter name")
        assertFalse(jupiter.isInner, "Jupiter is outer planet")
        assertEqual(jupiter.distanceFromSun(), 5.20, "Jupiter distance")
    }
    
    test("Static enum properties") {
        let allPlanets = Planet.allCases
        assertEqual(allPlanets.count, 8, "8 planets")
        assertEqual(allPlanets.first, .mercury, "First planet")
        assertEqual(allPlanets.last, .neptune, "Last planet")
    }
    
    test("Enum methods") {
        let num = Calculator.number(10)
        assertEqual(num.evaluate(with: 5), 10.0, "Number returns itself")
        
        let add = Calculator.operation("+")
        assertEqual(add.evaluate(with: 5), 5.0, "5 + current = 5")
        
        let multiply = Calculator.operation("*")
        assertEqual(multiply.evaluate(with: 3), 0.0, "3 * current = 0")
    }
    
    test("Static factory methods") {
        let addFive = Calculator.add(5)
        
        switch addFive {
        case .operation(let op):
            assertEqual(op, "+5", "Should store operation with value")
        default:
            assertFalse(true, "Should be operation")
        }
    }
    
    runTests()
}