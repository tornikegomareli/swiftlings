// operators2.swift
//
// Comparison and logical operators are essential for control flow.
// Fix the boolean expressions to make the assertions pass.


/// Function that checks various conditions using comparison and logical operators
/// Fix the boolean expressions to return the correct results
func checkConditions(age: Int, hasLicense: Bool) -> (isAdult: Bool, canDrive: Bool, isTeenager: Bool) {
    // TODO: Fix these boolean expressions
    let isAdult = age > 18  // Should be true when age is 18 or more
    let canDrive = hasLicense || isAdult  // Should be true only if BOTH conditions are met
    
    // TODO: Create a boolean that's true when age is between 13 and 19 (inclusive)
    let isTeenager = false  // Fix this expression
    
    return (isAdult, canDrive, isTeenager)
}

func test() {
    // Test case 1: 18 year old with license
    let result1 = checkConditions(age: 18, hasLicense: true)
    assertTrue(result1.isAdult, "18 year old should be considered an adult")
    assertTrue(result1.canDrive, "18 year old with license should be able to drive")
    assertTrue(result1.isTeenager, "18 year old should be considered a teenager")
    
    // Test case 2: 16 year old with license
    let result2 = checkConditions(age: 16, hasLicense: true)
    assertFalse(result2.isAdult, "16 year old should not be considered an adult")
    assertFalse(result2.canDrive, "16 year old should not be able to drive (even with license)")
    assertTrue(result2.isTeenager, "16 year old should be considered a teenager")
    
    // Test case 3: 21 year old without license
    let result3 = checkConditions(age: 21, hasLicense: false)
    assertTrue(result3.isAdult, "21 year old should be considered an adult")
    assertFalse(result3.canDrive, "21 year old without license should not be able to drive")
    assertFalse(result3.isTeenager, "21 year old should not be considered a teenager")
    
    // Test case 4: 13 year old
    let result4 = checkConditions(age: 13, hasLicense: false)
    assertTrue(result4.isTeenager, "13 year old should be considered a teenager")
    
    // Test case 5: 19 year old
    let result5 = checkConditions(age: 19, hasLicense: true)
    assertTrue(result5.isTeenager, "19 year old should be considered a teenager")
    assertTrue(result5.canDrive, "19 year old with license should be able to drive")
}

func main() {
    test()
    runTests()
}