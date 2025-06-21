// operators2.swift
//
// Comparison and logical operators are essential for control flow.
// Fix the boolean expressions to make the assertions pass.

// I AM NOT DONE

func main() {
    let age = 18
    let hasLicense = true
    
    // TODO: Fix these boolean expressions
    let isAdult = age > 18  // Should be true when age is 18 or more
    let canDrive = hasLicense || isAdult  // Should be true only if BOTH conditions are met
    
    // These should all print "true"
    print("Is adult: \(isAdult)")  // Should print: true
    print("Can drive: \(canDrive)")  // Should print: true
    
    // TODO: Create a boolean that's true when age is between 13 and 19 (inclusive)
    let isTeenager = false  // Fix this expression
    print("Is teenager: \(isTeenager)")  // Should print: true
}