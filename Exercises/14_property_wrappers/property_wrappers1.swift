// property_wrappers1.swift
//
// Property wrappers encapsulate property storage and access logic.
// They provide a way to define reusable property behaviors.
//
// Fix the property wrapper implementations to make the tests pass.

// TODO: Create a basic property wrapper
struct Capitalized {
    private var value: String = ""
    
    var wrappedValue: String {
        get { value }
        set { value = newValue }  // Should capitalize
    }
}

// TODO: Create a property wrapper with initialization
@propertyWrapper
struct Clamped {
    private var value: Int
    private let range: ClosedRange<Int>
    
    init(wrappedValue: Int, _ range: ClosedRange<Int>) {
        self.range = range
        self.value = wrappedValue  // Should clamp to range
    }
    
    var wrappedValue: Int {
        get { value }
        set { value = newValue }  // Should clamp to range
    }
}

// TODO: Create a property wrapper with projectedValue
@propertyWrapper
struct Validated<Value> {
    private var value: Value
    private let validator: (Value) -> Bool
    private var isValid: Bool = true
    
    init(wrappedValue: Value, _ validator: @escaping (Value) -> Bool) {
        self.value = wrappedValue
        self.validator = validator
        self.isValid = validator(wrappedValue)
    }
    
    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            isValid = validator(newValue)
        }
    }
    
    // TODO: Add projectedValue
    // Should return isValid status
}

// Test structs using property wrappers
struct User {
    @Capitalized var name: String
    @Clamped(0...100) var age: Int
    @Validated({ $0.contains("@") }) var email: String
}

// TODO: Create a UserDefaults property wrapper
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            // TODO: Read from UserDefaults
            return defaultValue
        }
        set {
            // TODO: Write to UserDefaults
        }
    }
}

struct Settings {
    @UserDefault(key: "username", defaultValue: "Guest") 
    var username: String
    
    @UserDefault(key: "volume", defaultValue: 50)
    var volume: Int
}

func main() {
    test("Basic property wrapper") {
        var user = User(name: "john doe", age: 25, email: "john@example.com")
        
        assertEqual(user.name, "John Doe", "Name should be capitalized")
        
        user.name = "alice smith"
        assertEqual(user.name, "Alice Smith", "Name should be capitalized on set")
    }
    
    test("Property wrapper with constraints") {
        var user = User(name: "Test", age: 150, email: "test@test.com")
        
        assertEqual(user.age, 100, "Age should be clamped to maximum")
        
        user.age = -10
        assertEqual(user.age, 0, "Age should be clamped to minimum")
        
        user.age = 50
        assertEqual(user.age, 50, "Valid age should not be clamped")
    }
    
    test("Projected value") {
        var user = User(name: "Test", age: 30, email: "invalid-email")
        
        assertFalse(user.$email, "Invalid email should project false")
        
        user.email = "valid@email.com"
        assertTrue(user.$email, "Valid email should project true")
        
        user.email = "another-invalid"
        assertFalse(user.$email, "Invalid email should project false again")
    }
    
    test("UserDefaults wrapper") {
        // Clear UserDefaults for testing
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "volume")
        
        var settings = Settings()
        
        assertEqual(settings.username, "Guest", "Should use default value")
        assertEqual(settings.volume, 50, "Should use default volume")
        
        settings.username = "Alice"
        settings.volume = 75
        
        // Create new instance to test persistence
        let newSettings = Settings()
        assertEqual(newSettings.username, "Alice", "Should read from UserDefaults")
        assertEqual(newSettings.volume, 75, "Should read volume from UserDefaults")
    }
    
    runTests()
}