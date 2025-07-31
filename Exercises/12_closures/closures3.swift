// closures3.swift
//
// Higher-order functions and functional programming with closures.
// Custom operators and function composition.
//
// Fix the functional programming patterns to make the tests pass.

// TODO: Implement map for optionals
extension Optional {
    func map<U>(_ transform: (Wrapped) -> U) -> U? {
        // Apply transform if not nil
        return nil  // Wrong implementation
    }
    
    func flatMap<U>(_ transform: (Wrapped) -> U?) -> U? {
        // Apply transform and flatten result
        return nil  // Wrong implementation
    }
}

// TODO: Create function composition operator
infix operator >>>: CompositionPrecedence
precedencegroup CompositionPrecedence {
    associativity: left
}

func >>> <A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C
) -> (A) -> C {
    // Compose two functions
    return { a in a }  // Wrong implementation
}

// TODO: Implement curry function
func curry<A, B, C>(
    _ function: @escaping (A, B) -> C
) -> (A) -> (B) -> C {
    // Convert function to curried form
    return { a in
        return { b in
            return function(a, b)  // This is close but check syntax
        }
    }
}

// TODO: Create pipe operator
infix operator |>: PipePrecedence
precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

func |> <A, B>(value: A, function: (A) -> B) -> B {
    // Apply function to value
    return value  // Wrong - should apply function
}

// TODO: Implement memoization
func memoize<Input: Hashable, Output>(
    _ function: @escaping (Input) -> Output
) -> (Input) -> Output {
    var cache: [Input: Output] = [:]
    
    return { input in
        // Check cache first
        return function(input)  // Not using cache
    }
}

// Test functions for composition
func double(_ x: Int) -> Int { x * 2 }
func addTen(_ x: Int) -> Int { x + 10 }
func toString(_ x: Int) -> String { String(x) }

func main() {
    test("Optional map and flatMap") {
        let value: Int? = 5
        let none: Int? = nil
        
        let mapped = value.map { $0 * 2 }
        assertEqual(mapped, 10, "Map on Some")
        
        let mappedNil = none.map { $0 * 2 }
        assertNil(mappedNil, "Map on None")
        
        let flatMapped = value.flatMap { $0 > 0 ? $0 * 3 : nil }
        assertEqual(flatMapped, 15, "FlatMap with Some result")
        
        let flatMappedNil = value.flatMap { _ in nil as Int? }
        assertNil(flatMappedNil, "FlatMap with nil result")
    }
    
    test("Function composition") {
        let doubleThenAddTen = double >>> addTen
        assertEqual(doubleThenAddTen(5), 20, "5 * 2 + 10 = 20")
        
        let addTenThenDouble = addTen >>> double
        assertEqual(addTenThenDouble(5), 30, "(5 + 10) * 2 = 30")
        
        let allThree = double >>> addTen >>> toString
        assertEqual(allThree(5), "20", "Compose three functions")
    }
    
    test("Currying") {
        func add(_ a: Int, _ b: Int) -> Int { a + b }
        let curriedAdd = curry(add)
        
        let addFive = curriedAdd(5)
        assertEqual(addFive(3), 8, "Partial application")
        assertEqual(addFive(10), 15, "Reuse partial function")
        
        func multiply(_ a: Int, _ b: Int) -> Int { a * b }
        let multiplyByTwo = curry(multiply)(2)
        assertEqual(multiplyByTwo(7), 14, "Curried multiply")
    }
    
    test("Pipe operator") {
        let result = 5 |> double |> addTen |> toString
        assertEqual(result, "20", "Pipeline operations")
        
        let complex = 3
            |> { $0 * $0 }
            |> { $0 + 1 }
            |> { "Result: \($0)" }
        assertEqual(complex, "Result: 10", "Pipeline with closures")
    }
    
    test("Memoization") {
        var callCount = 0
        func expensiveOperation(_ n: Int) -> Int {
            callCount += 1
            return n * n * n
        }
        
        let memoized = memoize(expensiveOperation)
        
        assertEqual(memoized(5), 125, "First call")
        assertEqual(callCount, 1, "Function called once")
        
        assertEqual(memoized(5), 125, "Second call same input")
        assertEqual(callCount, 1, "Function not called again")
        
        assertEqual(memoized(3), 27, "Different input")
        assertEqual(callCount, 2, "Function called for new input")
    }
    
    runTests()
}