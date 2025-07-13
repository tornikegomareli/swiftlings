// intro2.swift
//
// Now let's learn to fix compiler errors!
//
// Swift uses the `print()` function to output text to the console.
// This is one of the most basic operations in any programming language.
//
// Fix the code below to make it compile and return "Hello, World!"

func greet() -> String {
    // TODO: Fix this line - Swift doesn't have a println function
    // Change 'println' to 'print' to make it compile
    println("Hello, World!")
    
    return "Hello, World!"
}

func main() {
    test("Greeting function returns correct message") {
        let message = greet()
        assertEqual(message, "Hello, World!", "Should return the greeting message")
    }
    
    runTests()
}
