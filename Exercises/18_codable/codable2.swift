// codable2.swift
//
// Custom encoding and decoding strategies with Codable.
// Handling complex JSON structures and transformations.
//
// Fix the custom Codable implementations to make the tests pass.

import Foundation

// TODO: Custom encoding/decoding
struct Color: Codable {
    let red: Double
    let green: Double
    let blue: Double
    
    // TODO: Encode as hex string "#RRGGBB"
    enum CodingKeys: CodingKey {
        case hex
    }
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(from decoder: Decoder) throws {
        // TODO: Decode from hex string
        self.red = 0
        self.green = 0
        self.blue = 0
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO: Encode as hex string
    }
}

// TODO: Polymorphic decoding
protocol Animal: Codable {
    var name: String { get }
    var type: String { get }
}

struct Dog: Animal {
    let name: String
    let breed: String
    let type = "dog"
}

struct Cat: Animal {
    let name: String
    let lives: Int
    let type = "cat"
}

// TODO: Type-erased wrapper for polymorphic decoding
struct AnyAnimal: Codable {
    let animal: Animal
    
    init(from decoder: Decoder) throws {
        // TODO: Decode based on "type" field
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [], debugDescription: "Not implemented")
        )
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO: Encode the wrapped animal
    }
}

// TODO: Flattening nested JSON
struct UserProfile: Codable {
    let id: Int
    let username: String
    let firstName: String  // From nested "profile.first_name"
    let lastName: String   // From nested "profile.last_name"
    let email: String      // From nested "contact.email"
    
    // TODO: Custom decoding to flatten structure
}

// TODO: Handle different date formats
struct MultiDateEvent: Codable {
    let id: Int
    let createdAt: Date    // Unix timestamp
    let scheduledFor: Date // ISO8601 string
    let reminder: Date     // Custom format "dd/MM/yyyy HH:mm"
    
    // TODO: Custom decoding for different formats
}

// TODO: Conditional encoding
struct APIResponse: Codable {
    let status: String
    let data: Data?
    let error: APIError?
    
    // TODO: Only encode non-nil properties
}

struct APIError: Codable {
    let code: Int
    let message: String
}

// TODO: Transform during encoding/decoding
struct Temperature: Codable {
    let celsius: Double
    
    // TODO: JSON uses fahrenheit
    enum CodingKeys: String, CodingKey {
        case fahrenheit
    }
    
    init(celsius: Double) {
        self.celsius = celsius
    }
    
    init(from decoder: Decoder) throws {
        // TODO: Convert from fahrenheit
        self.celsius = 0
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO: Convert to fahrenheit
    }
}

func main() {
    test("Custom color encoding") {
        let color = Color(red: 1.0, green: 0.5, blue: 0.0)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(color)
        let json = String(data: data, encoding: .utf8)!
        
        assertEqual(json, "{\"hex\":\"#FF7F00\"}", "Color as hex")
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(Color.self, from: data)
        
        assertEqual(decoded.red, 1.0, "Red component")
        assertEqual(decoded.green, 0.5, "Green component", accuracy: 0.01)
        assertEqual(decoded.blue, 0.0, "Blue component")
    }
    
    test("Polymorphic decoding") {
        let dogJSON = """
        {"type": "dog", "name": "Buddy", "breed": "Golden Retriever"}
        """.data(using: .utf8)!
        
        let catJSON = """
        {"type": "cat", "name": "Whiskers", "lives": 9}
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        let dogWrapper = try! decoder.decode(AnyAnimal.self, from: dogJSON)
        if let dog = dogWrapper.animal as? Dog {
            assertEqual(dog.name, "Buddy", "Dog name")
            assertEqual(dog.breed, "Golden Retriever", "Dog breed")
        } else {
            assertFalse(true, "Should decode as Dog")
        }
        
        let catWrapper = try! decoder.decode(AnyAnimal.self, from: catJSON)
        if let cat = catWrapper.animal as? Cat {
            assertEqual(cat.name, "Whiskers", "Cat name")
            assertEqual(cat.lives, 9, "Cat lives")
        } else {
            assertFalse(true, "Should decode as Cat")
        }
    }
    
    test("Flattening nested JSON") {
        let json = """
        {
            "id": 123,
            "username": "johndoe",
            "profile": {
                "first_name": "John",
                "last_name": "Doe"
            },
            "contact": {
                "email": "john@example.com",
                "phone": "555-1234"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let profile = try! decoder.decode(UserProfile.self, from: json)
        
        assertEqual(profile.id, 123, "User ID")
        assertEqual(profile.username, "johndoe", "Username")
        assertEqual(profile.firstName, "John", "First name")
        assertEqual(profile.lastName, "Doe", "Last name")
        assertEqual(profile.email, "john@example.com", "Email")
    }
    
    test("Multiple date formats") {
        let json = """
        {
            "id": 1,
            "createdAt": 1704067200,
            "scheduledFor": "2024-01-15T14:30:00Z",
            "reminder": "20/01/2024 10:00"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let event = try! decoder.decode(MultiDateEvent.self, from: json)
        
        assertEqual(event.id, 1, "Event ID")
        
        // Check dates are parsed correctly
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        assertEqual(formatter.string(from: event.createdAt), "2024-01-01", "Created date")
        assertEqual(formatter.string(from: event.scheduledFor), "2024-01-15", "Scheduled date")
        assertEqual(formatter.string(from: event.reminder), "2024-01-20", "Reminder date")
    }
    
    test("Conditional encoding") {
        let successResponse = APIResponse(
            status: "success",
            data: "Result".data(using: .utf8),
            error: nil
        )
        
        let encoder = JSONEncoder()
        let successData = try! encoder.encode(successResponse)
        let successJSON = String(data: successData, encoding: .utf8)!
        
        assertTrue(successJSON.contains("\"status\":\"success\""), "Has status")
        assertTrue(successJSON.contains("\"data\""), "Has data")
        assertFalse(successJSON.contains("\"error\""), "No error field")
        
        let errorResponse = APIResponse(
            status: "error",
            data: nil,
            error: APIError(code: 404, message: "Not found")
        )
        
        let errorData = try! encoder.encode(errorResponse)
        let errorJSON = String(data: errorData, encoding: .utf8)!
        
        assertFalse(errorJSON.contains("\"data\""), "No data field")
        assertTrue(errorJSON.contains("\"error\""), "Has error")
        assertTrue(errorJSON.contains("\"code\":404"), "Error code")
    }
    
    test("Temperature conversion") {
        let temp = Temperature(celsius: 25.0)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(temp)
        let json = String(data: data, encoding: .utf8)!
        
        assertEqual(json, "{\"fahrenheit\":77}", "Celsius to Fahrenheit")
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(Temperature.self, from: data)
        
        assertEqual(decoded.celsius, 25.0, "Fahrenheit to Celsius")
    }
    
    runTests()
}