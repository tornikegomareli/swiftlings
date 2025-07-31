// advanced_types3.swift
//
// Phantom types, type-level programming, and compile-time guarantees.
// Using Swift's type system for advanced patterns.
//
// Fix the advanced type patterns to make the tests pass.

// TODO: Create phantom types for units
struct Distance<Unit> {
    let value: Double
    
    // TODO: Add conversion initializer
    init(_ value: Double) {
        self.value = value
    }
}

// Phantom type markers
enum Meters {}
enum Kilometers {}
enum Miles {}

// TODO: Add type-safe operations
extension Distance {
    static func +<U>(lhs: Distance<U>, rhs: Distance<U>) -> Distance<U> {
        // TODO: Add distances with same unit
        return Distance<U>(0)
    }
    
    // TODO: Add conversion methods
    func converted<ToUnit>(to unit: ToUnit.Type) -> Distance<ToUnit> {
        // Need to handle conversions
        return Distance<ToUnit>(0)
    }
}

// TODO: Create state machine with phantom types
struct Door<State> {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
}

// States as phantom types
enum Open {}
enum Closed {}
enum Locked {}

// TODO: State transitions
extension Door where State == Closed {
    func open() -> Door<Open> {
        // TODO: Return opened door
        return Door<Open>(id: "")
    }
    
    func lock() -> Door<Locked> {
        // TODO: Return locked door  
        return Door<Locked>(id: "")
    }
}

extension Door where State == Open {
    func close() -> Door<Closed> {
        // TODO: Return closed door
        return Door<Closed>(id: "")
    }
}

extension Door where State == Locked {
    func unlock() -> Door<Closed> {
        // TODO: Return unlocked (closed) door
        return Door<Closed>(id: "")
    }
}

// TODO: Builder pattern with type state
struct RequestBuilder<State> {
    var url: String = ""
    var method: String = "GET"
    var headers: [String: String] = [:]
    var body: Data?
}

// Builder states
enum URLMissing {}
enum URLSet {}
enum Ready {}

// TODO: Type-safe builder
extension RequestBuilder where State == URLMissing {
    func setURL(_ url: String) -> RequestBuilder<URLSet> {
        // TODO: Return builder with URL set
        return RequestBuilder<URLSet>()
    }
}

extension RequestBuilder where State == URLSet {
    func setMethod(_ method: String) -> RequestBuilder<URLSet> {
        // TODO: Set method and return same state
        return self
    }
    
    func setHeader(_ key: String, value: String) -> RequestBuilder<URLSet> {
        // TODO: Add header and return
        return self
    }
    
    func build() -> RequestBuilder<Ready> {
        // TODO: Return ready request
        return RequestBuilder<Ready>()
    }
}

extension RequestBuilder where State == Ready {
    func send() -> String {
        // TODO: Send request (simulated)
        return "Response"
    }
}

// TODO: Type-level numbers
struct Vector<N> {
    let elements: [Double]
    
    init(_ elements: Double...) {
        self.elements = Array(elements)
    }
}

// Type-level numbers
struct Zero {}
struct Succ<N> {}
typealias One = Succ<Zero>
typealias Two = Succ<One>
typealias Three = Succ<Two>

// TODO: Type-safe vector operations
extension Vector {
    func dot<N>(_ other: Vector<N>) -> Double where N == Three {
        // TODO: Compute dot product for 3D vectors only
        return 0
    }
}

// TODO: Witness types
protocol Witness {
    associatedtype Value
    static var value: Value { get }
}

struct IntWitness: Witness {
    static var value: Int { 42 }
}

struct StringWitness: Witness {
    static var value: String { "Hello" }
}

// TODO: Use witness types
func getValue<W: Witness>(_ witness: W.Type) -> W.Value {
    // TODO: Return witnessed value
    return witness.value
}

func main() {
    test("Phantom types for units") {
        let meters = Distance<Meters>(100)
        let moreMeters = Distance<Meters>(50)
        
        let total = meters + moreMeters
        assertEqual(total.value, 150, "Added distances")
        
        // Conversion
        let km: Distance<Kilometers> = meters.converted(to: Kilometers.self)
        assertEqual(km.value, 0.1, "100m = 0.1km")
        
        let miles: Distance<Miles> = km.converted(to: Miles.self)
        assertEqual(miles.value, 0.062137, "0.1km ≈ 0.062137 miles", accuracy: 0.000001)
    }
    
    test("State machine with phantom types") {
        let closedDoor = Door<Closed>(id: "front")
        let openDoor = closedDoor.open()
        let closedAgain = openDoor.close()
        let lockedDoor = closedAgain.lock()
        let unlockedDoor = lockedDoor.unlock()
        
        // These should not compile:
        // closedDoor.close()  // Can't close a closed door
        // openDoor.lock()     // Can't lock an open door
        // lockedDoor.open()   // Can't open a locked door
        
        assertTrue(true, "State transitions enforced at compile time")
    }
    
    test("Type-safe builder") {
        let request = RequestBuilder<URLMissing>()
            .setURL("https://api.example.com/data")
            .setMethod("POST")
            .setHeader("Content-Type", value: "application/json")
            .setHeader("Authorization", value: "Bearer token")
            .build()
        
        let response = request.send()
        assertEqual(response, "POST https://api.example.com/data", "Request sent")
        
        // Can't send without URL:
        // RequestBuilder<URLMissing>().send()  // Won't compile
    }
    
    test("Type-level numbers") {
        let vec3a = Vector<Three>(1, 2, 3)
        let vec3b = Vector<Three>(4, 5, 6)
        
        let dotProduct = vec3a.dot(vec3b)
        assertEqual(dotProduct, 32, "1*4 + 2*5 + 3*6 = 32")
        
        // Can't compute dot product of different dimensions:
        // let vec2 = Vector<Two>(1, 2)
        // vec3a.dot(vec2)  // Won't compile
    }
    
    test("Witness types") {
        let intValue = getValue(IntWitness.self)
        assertEqual(intValue, 42, "Int witness value")
        
        let stringValue = getValue(StringWitness.self)
        assertEqual(stringValue, "Hello", "String witness value")
        
        // Type is inferred from witness
        let value: Int = getValue(IntWitness.self)
        assertEqual(value, 42, "Type inferred correctly")
    }
    
    test("Complex phantom type usage") {
        // Temperature with phantom types
        struct Temperature<Scale> {
            let value: Double
        }
        
        enum Celsius {}
        enum Fahrenheit {}
        
        let celsius = Temperature<Celsius>(value: 25)
        let fahrenheit = Temperature<Fahrenheit>(value: 77)
        
        // Can't accidentally mix scales:
        // celsius + fahrenheit  // Won't compile
        
        assertTrue(true, "Temperature scales type-safe")
    }
    
    runTests()
}

// Conversion implementations
extension Distance where Unit == Meters {
    func converted<ToUnit>(to unit: ToUnit.Type) -> Distance<ToUnit> {
        if unit == Kilometers.self {
            return Distance<ToUnit>(value / 1000)
        } else if unit == Miles.self {
            return Distance<ToUnit>(value / 1609.344)
        }
        return Distance<ToUnit>(value)
    }
}

extension Distance where Unit == Kilometers {
    func converted<ToUnit>(to unit: ToUnit.Type) -> Distance<ToUnit> {
        if unit == Meters.self {
            return Distance<ToUnit>(value * 1000)
        } else if unit == Miles.self {
            return Distance<ToUnit>(value * 0.621371)
        }
        return Distance<ToUnit>(value)
    }
}