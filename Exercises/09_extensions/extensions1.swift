// extensions1.swift
//
// Extensions add new functionality to existing types.
// You can extend types you don't own, including built-in types.
//
// Fix the extensions to make the tests pass.

// TODO: Add an extension to Int
extension Int {
    // Add a computed property 'isEven'
    
    // Add a method 'squared() -> Int'
}

// TODO: Add an extension to String
extension String {
    // Add a method to remove whitespace: trimmed() -> String
    
    // Add a computed property 'wordCount' that counts words
}

// TODO: Add an extension to Array where Element is Int
extension Array {  // Missing constraint
    // Add a computed property 'sum' that returns the sum of elements
    var sum: Int {
        return 0  // Wrong implementation
    }
    
    // Add a method 'average() -> Double?'
    func average() -> Double? {
        return nil  // Implement this
    }
}

// TODO: Add an extension to Double
extension Double {
    // Add a method to round to N decimal places
    func rounded(to places: Int) -> Double {
        return self  // Wrong implementation
    }
}

func main() {
    test("Int extensions") {
        assertEqual(4.isEven, true, "4 is even")
        assertEqual(7.isEven, false, "7 is odd")
        assertEqual(5.squared(), 25, "5 squared is 25")
        assertEqual((-3).squared(), 9, "-3 squared is 9")
    }
    
    test("String extensions") {
        assertEqual("  Hello World  ".trimmed(), "Hello World", "Trimmed string")
        assertEqual("".trimmed(), "", "Empty string trimmed")
        
        assertEqual("Hello world from Swift".wordCount, 4, "Four words")
        assertEqual("".wordCount, 0, "Empty string has 0 words")
        assertEqual("   Multiple   spaces   ".wordCount, 2, "Two words with extra spaces")
    }
    
    test("Array<Int> extensions") {
        assertEqual([1, 2, 3, 4, 5].sum, 15, "Sum of 1-5")
        assertEqual([].sum, 0, "Empty array sum is 0")
        assertEqual([-1, -2, -3].sum, -6, "Sum of negatives")
        
        assertEqual([10, 20, 30].average(), 20.0, "Average of 10,20,30")
        assertEqual([5].average(), 5.0, "Average of single element")
        assertNil([].average(), "Empty array average is nil")
    }
    
    test("Double extensions") {
        assertEqual(3.14159.rounded(to: 2), 3.14, "Round to 2 places")
        assertEqual(3.14159.rounded(to: 4), 3.1416, "Round to 4 places")
        assertEqual(2.5.rounded(to: 0), 3.0, "Round to whole number")
    }
    
    runTests()
}