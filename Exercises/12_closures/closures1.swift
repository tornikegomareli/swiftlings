// closures1.swift
//
// Closures are self-contained blocks of functionality.
// They can capture and store references to constants and variables.
//
// Fix the closure syntax and usage to make the tests pass.

// TODO: Fix closure syntax
let addClosure = { (a: Int, b: Int) in Int
    return a + b
}

// TODO: Create a closure with shorthand syntax
let multiplyClosure: (Int, Int) -> Int = { a, b in
    a * b  // Missing return type inference
}

// TODO: Use trailing closure syntax
func performOperation(on a: Int, and b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

func calculate() -> (sum: Int, product: Int) {
    let x = 5
    let y = 3
    
    // TODO: Call performOperation with trailing closure
    let sum = performOperation(on: x, and: y, operation: { $0 + $1 })  // Use trailing closure
    
    // TODO: Use closure shorthand with $0, $1
    let product = performOperation(on: x, and: y) { (a, b) in
        return a * b  // Simplify this
    }
    
    return (sum, product)
}

// TODO: Create a function that returns a closure
func makeIncrementer(by amount: Int) -> () -> Int {
    var total = 0
    
    // Return a closure that captures 'amount' and 'total'
    return {
        return 0  // Wrong implementation
    }
}

// TODO: Use closures with map, filter, reduce
func processNumbers(_ numbers: [Int]) -> (doubled: [Int], evens: [Int], sum: Int) {
    // Use closure expressions
    let doubled = numbers.map({ $0 * 2 })  // Can be simplified
    
    let evens = numbers.filter { number in
        return number % 2 == 0  // Can be simplified
    }
    
    let sum = numbers.reduce(0) { result, number in
        return result + number  // Can be simplified
    }
    
    return (doubled, evens, sum)
}

func main() {
    test("Basic closure syntax") {
        assertEqual(addClosure(3, 5), 8, "Closure addition")
        assertEqual(multiplyClosure(4, 7), 28, "Closure multiplication")
    }
    
    test("Trailing closure syntax") {
        let (sum, product) = calculate()
        assertEqual(sum, 8, "Sum using trailing closure")
        assertEqual(product, 15, "Product using shorthand")
    }
    
    test("Capturing values") {
        let incrementByTwo = makeIncrementer(by: 2)
        assertEqual(incrementByTwo(), 2, "First increment")
        assertEqual(incrementByTwo(), 4, "Second increment")
        assertEqual(incrementByTwo(), 6, "Third increment")
        
        let incrementByFive = makeIncrementer(by: 5)
        assertEqual(incrementByFive(), 5, "Different incrementer")
        assertEqual(incrementByTwo(), 8, "Original still works")
    }
    
    test("Higher-order functions") {
        let numbers = [1, 2, 3, 4, 5]
        let (doubled, evens, sum) = processNumbers(numbers)
        
        assertEqual(doubled, [2, 4, 6, 8, 10], "Map doubles numbers")
        assertEqual(evens, [2, 4], "Filter finds evens")
        assertEqual(sum, 15, "Reduce calculates sum")
    }
    
    runTests()
}