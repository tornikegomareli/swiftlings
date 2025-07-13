// strings1.swift
//
// String interpolation is a powerful feature in Swift.
// It allows you to insert values into strings easily.
//
// Fix the string interpolation to display the correct message.


/// Function that creates formatted messages using string interpolation and concatenation
/// Fix the string operations to return the correct messages
func createMessages(name: String, age: Int, city: String) -> (message: String, greeting: String) {
    // TODO: Use string interpolation to create the message
    // Expected: "Hello, my name is Alice. I am 25 years old and I live in New York."
    let message = "Hello, my name is name. I am age years old and I live in city."
    
    // TODO: Create a string using concatenation - add the name to this greeting
    let greeting = "Welcome, "  // Should be "Welcome, " + name
    
    return (message, greeting)
}

func test() {
    // Test case 1
    let result1 = createMessages(name: "Alice", age: 25, city: "New York")
    assertEqual(result1.message, "Hello, my name is Alice. I am 25 years old and I live in New York.", 
                "Message should use proper string interpolation")
    assertEqual(result1.greeting, "Welcome, Alice", 
                "Greeting should concatenate the name")
    
    // Test case 2
    let result2 = createMessages(name: "Bob", age: 30, city: "San Francisco")
    assertEqual(result2.message, "Hello, my name is Bob. I am 30 years old and I live in San Francisco.", 
                "Message should use proper string interpolation with different values")
    assertEqual(result2.greeting, "Welcome, Bob", 
                "Greeting should concatenate different name")
    
    // Test case 3
    let result3 = createMessages(name: "Charlie", age: 18, city: "London")
    assertEqual(result3.message, "Hello, my name is Charlie. I am 18 years old and I live in London.", 
                "Message should work with any valid inputs")
    assertEqual(result3.greeting, "Welcome, Charlie", 
                "Greeting concatenation should work with any name")
}

func main() {
    test()
    runTests()
}