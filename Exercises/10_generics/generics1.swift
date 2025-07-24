// generics1.swift
//
// Generics allow you to write flexible, reusable code that works with any type.
// Generic functions and types use type parameters in angle brackets.
//
// Fix the generic functions and types to make the tests pass.

// TODO: Make this function generic
func swapValues(a: inout Int, b: inout Int) {  // Only works with Int
    let temp = a
    a = b
    b = temp
}

// TODO: Create a generic function to find the larger of two values
func larger(a: Int, b: Int) -> Int {  // Should work with any Comparable type
    return a > b ? a : b
}

// TODO: Create a generic Stack struct
struct Stack {  // Missing generic parameter
    private var items: [Int] = []  // Should work with any type
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int? {
        return items.popLast()
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    var count: Int {
        return items.count
    }
}

// TODO: Create a generic function with multiple type parameters
func makePair(first: String, second: Int) -> (String, Int) {  // Should be generic
    return (first, second)
}

func main() {
    test("Generic swap function") {
        var x = 10
        var y = 20
        swapValues(a: &x, b: &y)
        assertEqual(x, 20, "x should be 20 after swap")
        assertEqual(y, 10, "y should be 10 after swap")
        
        var str1 = "Hello"
        var str2 = "World"
        swapValues(a: &str1, b: &str2)
        assertEqual(str1, "World", "str1 should be World after swap")
        assertEqual(str2, "Hello", "str2 should be Hello after swap")
    }
    
    test("Generic comparison function") {
        assertEqual(larger(a: 5, b: 3), 5, "5 is larger than 3")
        assertEqual(larger(a: "apple", b: "banana"), "banana", "banana > apple alphabetically")
        assertEqual(larger(a: 3.14, b: 2.71), 3.14, "3.14 is larger than 2.71")
    }
    
    test("Generic Stack") {
        var intStack = Stack<Int>()
        intStack.push(10)
        intStack.push(20)
        assertEqual(intStack.pop(), 20, "Pop returns last pushed")
        assertEqual(intStack.count, 1, "One item remains")
        
        var stringStack = Stack<String>()
        stringStack.push("first")
        stringStack.push("second")
        assertEqual(stringStack.pop(), "second", "String stack works")
        assertFalse(stringStack.isEmpty, "Stack not empty")
    }
    
    test("Multiple type parameters") {
        let pair1 = makePair(first: "Age", second: 25)
        assertEqual(pair1.0, "Age", "First element")
        assertEqual(pair1.1, 25, "Second element")
        
        let pair2 = makePair(first: 3.14, second: true)
        assertEqual(pair2.0, 3.14, "First is Double")
        assertEqual(pair2.1, true, "Second is Bool")
    }
    
    runTests()
}