// codable1.swift
//
// Basic Codable protocol for JSON encoding and decoding.
// Understanding automatic synthesis and simple customization.
//
// Fix the Codable implementations to make the tests pass.

import Foundation

// TODO: Make struct Codable
struct User {  // Should conform to Codable
    let id: Int
    let name: String
    let email: String
}

// TODO: Handle optional properties
struct Product {  // Should be Codable
    let id: Int
    let name: String
    let price: Double
    let description: String?  // Optional
}

// TODO: Custom property names
struct Article {  // Should be Codable with custom keys
    let id: Int
    let title: String
    let authorName: String  // JSON key is "author_name"
    let publishDate: Date  // JSON key is "publish_date"
    
    // TODO: Add CodingKeys
}

// TODO: Nested Codable types
struct Order {  // Should be Codable
    let id: Int
    let items: [OrderItem]
    let totalAmount: Double  // JSON key is "total_amount"
}

struct OrderItem {  // Should be Codable
    let productId: Int  // JSON key is "product_id"
    let quantity: Int
    let price: Double
}

// TODO: Enum with raw values
enum Status {  // Should be Codable
    case pending
    case processing
    case completed
    case cancelled
}

// TODO: Handle dates
struct Event {  // Should be Codable
    let id: Int
    let name: String
    let startDate: Date  // JSON key is "start_date"
    let endDate: Date    // JSON key is "end_date"
}

func main() {
    test("Basic Codable") {
        let user = User(id: 1, name: "Alice", email: "alice@example.com")
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(user)
        let json = String(data: data, encoding: .utf8)!
        
        assertTrue(json.contains("\"id\":1"), "Contains id")
        assertTrue(json.contains("\"name\":\"Alice\""), "Contains name")
        assertTrue(json.contains("\"email\":\"alice@example.com\""), "Contains email")
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(User.self, from: data)
        
        assertEqual(decoded.id, 1, "Decoded id")
        assertEqual(decoded.name, "Alice", "Decoded name")
        assertEqual(decoded.email, "alice@example.com", "Decoded email")
    }
    
    test("Optional properties") {
        let jsonWithDescription = """
        {"id": 1, "name": "iPhone", "price": 999.99, "description": "Latest model"}
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let product1 = try! decoder.decode(Product.self, from: jsonWithDescription)
        
        assertEqual(product1.description, "Latest model", "Has description")
        
        let jsonWithoutDescription = """
        {"id": 2, "name": "iPad", "price": 799.99}
        """.data(using: .utf8)!
        
        let product2 = try! decoder.decode(Product.self, from: jsonWithoutDescription)
        assertNil(product2.description, "No description")
    }
    
    test("Custom property names") {
        let json = """
        {
            "id": 1,
            "title": "Swift Codable",
            "author_name": "John Doe",
            "publish_date": "2024-01-15T10:00:00Z"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let article = try! decoder.decode(Article.self, from: json)
        
        assertEqual(article.id, 1, "Article id")
        assertEqual(article.title, "Swift Codable", "Article title")
        assertEqual(article.authorName, "John Doe", "Author name")
        assertNotNil(article.publishDate, "Publish date decoded")
    }
    
    test("Nested Codable types") {
        let json = """
        {
            "id": 100,
            "items": [
                {"product_id": 1, "quantity": 2, "price": 29.99},
                {"product_id": 2, "quantity": 1, "price": 49.99}
            ],
            "total_amount": 109.97
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let order = try! decoder.decode(Order.self, from: json)
        
        assertEqual(order.id, 100, "Order id")
        assertEqual(order.items.count, 2, "Number of items")
        assertEqual(order.items[0].productId, 1, "First item product id")
        assertEqual(order.totalAmount, 109.97, "Total amount")
    }
    
    test("Enum encoding") {
        let statuses: [Status] = [.pending, .processing, .completed, .cancelled]
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(statuses)
        let json = String(data: data, encoding: .utf8)!
        
        assertTrue(json.contains("\"pending\""), "Contains pending")
        assertTrue(json.contains("\"completed\""), "Contains completed")
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode([Status].self, from: data)
        
        assertEqual(decoded.count, 4, "All statuses decoded")
        assertEqual(decoded[0], .pending, "First status")
        assertEqual(decoded[2], .completed, "Third status")
    }
    
    test("Date handling") {
        let formatter = ISO8601DateFormatter()
        let startDate = formatter.date(from: "2024-01-01T09:00:00Z")!
        let endDate = formatter.date(from: "2024-01-01T17:00:00Z")!
        
        let event = Event(id: 1, name: "Conference", startDate: startDate, endDate: endDate)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let data = try! encoder.encode(event)
        let json = String(data: data, encoding: .utf8)!
        
        assertTrue(json.contains("\"start_date\""), "Snake case key")
        assertTrue(json.contains("2024-01-01T09:00:00Z"), "ISO8601 date")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoded = try! decoder.decode(Event.self, from: data)
        assertEqual(decoded.name, "Conference", "Event name")
        assertEqual(decoded.startDate, startDate, "Start date")
    }
    
    runTests()
}