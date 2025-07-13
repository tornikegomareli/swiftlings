// variables1.swift
//
// Variables in Swift are declared using the `var` keyword.
// They can be changed after they're created.
//
// Fix the function below to make the tests pass.

func createVariable() -> Int {
    // TODO: Declare a variable named 'x' with the value 5
    // Fix the line below - it currently uses 'let' instead of 'var'
    var x = 5
    
    // This line tries to change x, which won't work with 'let'
    x = x + 1
    
    return x
}

func main() {
    test("Variable can be created and modified") {
        let result = createVariable()
        assertEqual(result, 6, "Variable should be incremented to 6")
    }
    
    runTests()
}
