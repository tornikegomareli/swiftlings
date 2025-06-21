// variables3.swift
//
// Constants in Swift are declared using the `let` keyword.
// They cannot be changed after they're created.
//
// Fix this code to use the appropriate declaration.

// I AM NOT DONE

func main() {
    // TODO: This value will never change, so it should be a constant
    var pi = 3.14159
    
    // TODO: This value needs to change, so it should be a variable
    let radius = 5.0
    
    print("Initial radius: \(radius)")
    radius = 10.0  // We need to change the radius
    
    let area = pi * radius * radius
    print("Area of circle: \(area)")
}