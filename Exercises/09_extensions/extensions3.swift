// extensions3.swift
//
// Extensions can add nested types and can be constrained with where clauses.
// Protocol extensions can provide default implementations.
//
// Fix the extensions to make the tests pass.

protocol Numeric {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
}

extension Int: Numeric {}
extension Double: Numeric {}

// TODO: Add extension to Array where Element conforms to Numeric
extension Array {  // Missing where clause
    func sum() -> Element {
        // Calculate sum of numeric elements
        return []  // Wrong return type and implementation
    }
    
    func product() -> Element? {
        // Calculate product, return nil if empty
        return nil  // Implement this
    }
}

// TODO: Add nested type to String via extension
extension String {
    // Add enum ValidationError with cases: empty, tooShort(minimum: Int), invalid
    
    // Add method to validate email format
    func validateEmail() throws {
        // Throw appropriate ValidationError
        // Basic check: not empty, contains @, has . after @
    }
}

// TODO: Create protocol with extension providing default implementation
protocol Resettable {
    mutating func reset()
}

// TODO: Add default implementation
extension Resettable {
    // Provide default reset that does nothing
}

struct Counter: Resettable {
    var value = 0
    
    // TODO: Should we implement reset? Check if default works
    mutating func reset() {
        value = 0
    }
}

struct Configuration: Resettable {
    var settings: [String: Any] = ["theme": "dark"]
    
    // Use custom implementation
    mutating func reset() {
        settings = [:]
    }
}

// TODO: Add static methods to protocols via extension
protocol Identifiable {
    var id: String { get }
}

extension Identifiable {
    // Add static method to generate random ID
    static func randomID() -> String {
        return ""  // Should return something like "ID-12345"
    }
}

func main() {
    test("Constrained array extensions") {
        assertEqual([1, 2, 3, 4, 5].sum(), 15, "Sum of integers")
        assertEqual([1.5, 2.5, 3.0].sum(), 7.0, "Sum of doubles")
        
        assertEqual([2, 3, 4].product(), 24, "Product of integers")
        assertEqual([1.5, 2.0].product(), 3.0, "Product of doubles")
        assertNil([Int]().product(), "Empty array product is nil")
    }
    
    test("Nested types in extensions") {
        do {
            try "test@example.com".validateEmail()
            assertTrue(true, "Valid email passes")
        } catch {
            assertFalse(true, "Valid email should not throw")
        }
        
        do {
            try "".validateEmail()
            assertFalse(true, "Empty email should throw")
        } catch String.ValidationError.empty {
            assertTrue(true, "Caught empty error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        do {
            try "notanemail".validateEmail()
            assertFalse(true, "Invalid email should throw")
        } catch String.ValidationError.invalid {
            assertTrue(true, "Caught invalid error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Protocol extension defaults") {
        var counter = Counter()
        counter.value = 10
        counter.reset()
        assertEqual(counter.value, 0, "Counter resets to 0")
        
        var config = Configuration()
        config.reset()
        assertTrue(config.settings.isEmpty, "Config resets to empty")
    }
    
    test("Static methods in protocol extensions") {
        struct User: Identifiable {
            let id: String
        }
        
        let randomID = User.randomID()
        assertTrue(randomID.hasPrefix("ID-"), "Random ID has prefix")
        assertTrue(randomID.count > 3, "Random ID has content")
    }
    
    runTests()
}