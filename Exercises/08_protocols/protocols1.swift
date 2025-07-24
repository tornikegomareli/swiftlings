// protocols1.swift
//
// Protocols define requirements that conforming types must implement.
// They're like contracts or interfaces in other languages.
//
// Fix the protocol definitions and conformance to make the tests pass.

// TODO: Define a protocol called Describable
protocol Describable {
    // Add a computed property requirement: description (String, get only)
}

// TODO: Define a protocol called Greetable
protocol Greetable {
    // Add a method requirement: greet() -> String
}

// TODO: Make this struct conform to Describable
struct Book {  // Missing protocol conformance
    let title: String
    let author: String
    let pages: Int
    
    // Implement required property
}

// TODO: Make this class conform to both protocols
class Person {  // Missing protocol conformance
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // Implement required members
}

// TODO: Create a function that accepts any Describable
func printDescription(of item: Any) {  // Wrong parameter type
    print(item)  // Should print description
}

func main() {
    test("Protocol conformance") {
        let book = Book(title: "1984", author: "George Orwell", pages: 328)
        assertEqual(book.description, "1984 by George Orwell (328 pages)", 
                   "Book description")
        
        let person = Person(name: "Alice", age: 30)
        assertEqual(person.description, "Alice, age 30", 
                   "Person description")
        assertEqual(person.greet(), "Hello, I'm Alice!", 
                   "Person greeting")
    }
    
    test("Protocol as type") {
        let describables: [Describable] = [
            Book(title: "Swift Guide", author: "Apple", pages: 500),
            Person(name: "Bob", age: 25)
        ]
        
        let descriptions = describables.map { $0.description }
        assertEqual(descriptions.count, 2, "Two describable items")
        assertTrue(descriptions[0].contains("Swift Guide"), "Book in array")
        assertTrue(descriptions[1].contains("Bob"), "Person in array")
    }
    
    runTests()
}