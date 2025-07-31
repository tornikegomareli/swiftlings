// property_wrappers2.swift
//
// Advanced property wrapper features including composition and custom projections.
// Property wrappers can be composed and work with different types.
//
// Fix the advanced property wrapper features to make the tests pass.

import Foundation

// TODO: Create a thread-safe property wrapper
@propertyWrapper
struct Atomic<Value> {
    private var value: Value
    private let queue = DispatchQueue(label: "atomic")
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get {
            // TODO: Make thread-safe
            return value
        }
        set {
            // TODO: Make thread-safe
            value = newValue
        }
    }
}

// TODO: Create a copy-on-write property wrapper
@propertyWrapper
struct CopyOnWrite<Value> {
    private var value: Value
    private var isKnownUniquelyReferenced = true
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }
        set {
            // TODO: Implement copy-on-write logic
            value = newValue
        }
    }
    
    // TODO: Add projectedValue that indicates if copied
    var projectedValue: Bool {
        return true  // Should return whether a copy was made
    }
}

// TODO: Create a property wrapper that works with optionals
@propertyWrapper
struct Trimmed {
    private var value: String?
    
    init(wrappedValue: String?) {
        self.value = wrappedValue?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var wrappedValue: String? {
        get { value }
        set { 
            // TODO: Trim on set
            value = newValue
        }
    }
}

// TODO: Create composable property wrappers
@propertyWrapper
struct Logged<Value> {
    private var value: Value
    private let key: String
    
    init(wrappedValue: Value, key: String) {
        self.value = wrappedValue
        self.key = key
        print("[\(key)] Initial value: \(value)")
    }
    
    var wrappedValue: Value {
        get {
            print("[\(key)] Get: \(value)")
            return value
        }
        set {
            print("[\(key)] Set: \(newValue)")
            value = newValue
        }
    }
}

// Test struct with composed wrappers
struct DataModel {
    @Atomic var counter: Int = 0
    
    @CopyOnWrite var largeData: [Int] = []
    
    @Trimmed var input: String?
    
    @Logged(key: "important")
    @Clamped(0...100) 
    var percentage: Int = 50
}

// TODO: Create a lazy property wrapper
@propertyWrapper
struct Lazy<Value> {
    private var storage: Value?
    private let initializer: () -> Value
    
    init(wrappedValue: @autoclosure @escaping () -> Value) {
        self.initializer = wrappedValue
    }
    
    var wrappedValue: Value {
        mutating get {
            // TODO: Lazy initialization
            return initializer()  // Should only call once
        }
    }
    
    // TODO: Add projectedValue to check if initialized
}

func main() {
    test("Thread-safe property wrapper") {
        var model = DataModel()
        let queue = DispatchQueue(label: "test", attributes: .concurrent)
        let group = DispatchGroup()
        
        // Concurrent writes
        for i in 0..<100 {
            group.enter()
            queue.async {
                model.counter += 1
                group.leave()
            }
        }
        
        group.wait()
        assertEqual(model.counter, 100, "All increments should be atomic")
    }
    
    test("Copy-on-write wrapper") {
        var model = DataModel()
        
        model.largeData = [1, 2, 3, 4, 5]
        assertFalse(model.$largeData, "No copy on initial set")
        
        model.largeData.append(6)
        assertTrue(model.$largeData, "Should copy on mutation")
    }
    
    test("Optional property wrapper") {
        var model = DataModel()
        
        model.input = "  Hello World  "
        assertEqual(model.input, "Hello World", "Should trim whitespace")
        
        model.input = nil
        assertNil(model.input, "Should handle nil")
        
        model.input = "\n\tTest\n\t"
        assertEqual(model.input, "Test", "Should trim all whitespace")
    }
    
    test("Composed property wrappers") {
        var model = DataModel()
        
        // Should log and clamp
        model.percentage = 150
        assertEqual(model.percentage, 100, "Should be clamped to 100")
        
        model.percentage = -10
        assertEqual(model.percentage, 0, "Should be clamped to 0")
    }
    
    test("Lazy property wrapper") {
        struct ExpensiveData {
            @Lazy var computed: String = {
                print("Computing expensive value...")
                return "Expensive Result"
            }()
        }
        
        var data = ExpensiveData()
        
        assertFalse(data.$computed, "Not initialized yet")
        
        let value1 = data.computed
        assertEqual(value1, "Expensive Result", "Should compute value")
        assertTrue(data.$computed, "Should be initialized")
        
        let value2 = data.computed
        assertEqual(value2, "Expensive Result", "Should return cached value")
        // Should only print "Computing..." once
    }
    
    runTests()
}