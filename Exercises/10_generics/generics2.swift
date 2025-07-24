// generics2.swift
//
// Generic types can have constraints that specify requirements for type parameters.
// Where clauses provide additional constraints.
//
// Fix the generic constraints to make the tests pass.

// TODO: Add constraint that T must be Equatable
func findIndex<T>(of value: T, in array: [T]) -> Int? {
    for (index, item) in array.enumerated() {
        if item == value {  // Won't compile without constraint
            return index
        }
    }
    return nil
}

// TODO: Add constraint that T must be Numeric
struct Calculator<T> {  // Missing constraint
    func add(_ a: T, _ b: T) -> T {
        return a + b  // Won't work without constraint
    }
    
    func multiply(_ a: T, _ b: T) -> T {
        return a * b
    }
}

// TODO: Create a generic function with multiple constraints
// T should be both Comparable and CustomStringConvertible
func describeLargest<T>(in array: [T]) -> String? {  // Missing constraints
    guard let max = array.max() else { return nil }
    return "Largest: \(max.description)"  // Needs CustomStringConvertible
}

// TODO: Add where clause constraint
struct Container<T> {
    private var items: [T] = []
    
    mutating func append(_ item: T) {
        items.append(item)
    }
    
    // Add a method that only works when T is Comparable
    func sorted() -> [T] {  // Missing where clause
        return items.sorted()
    }
}

// Protocol for testing
protocol Describable {
    var description: String { get }
}

// TODO: Create generic function with associated type constraint
func process<C>(container: C) -> String  // Missing constraints
    where C: Collection {  // Add constraint for Element
    return container.map { $0.description }.joined(separator: ", ")
}

func main() {
    test("Equatable constraint") {
        let numbers = [1, 2, 3, 4, 5]
        assertEqual(findIndex(of: 3, in: numbers), 2, "Find index of 3")
        assertNil(findIndex(of: 10, in: numbers), "10 not found")
        
        let strings = ["apple", "banana", "cherry"]
        assertEqual(findIndex(of: "banana", in: strings), 1, "Find string index")
    }
    
    test("Numeric constraint") {
        let intCalc = Calculator<Int>()
        assertEqual(intCalc.add(5, 3), 8, "Add integers")
        assertEqual(intCalc.multiply(4, 7), 28, "Multiply integers")
        
        let doubleCalc = Calculator<Double>()
        assertEqual(doubleCalc.add(1.5, 2.5), 4.0, "Add doubles")
        assertEqual(doubleCalc.multiply(3.0, 2.0), 6.0, "Multiply doubles")
    }
    
    test("Multiple constraints") {
        let numbers = [3, 1, 4, 1, 5]
        assertEqual(describeLargest(in: numbers), "Largest: 5", "Largest number")
        
        let words = ["apple", "zebra", "banana"]
        assertEqual(describeLargest(in: words), "Largest: zebra", "Largest string")
        
        let empty: [Int] = []
        assertNil(describeLargest(in: empty), "Empty array returns nil")
    }
    
    test("Where clause constraints") {
        var container = Container<Int>()
        container.append(3)
        container.append(1)
        container.append(4)
        
        let sorted = container.sorted()
        assertEqual(sorted, [1, 3, 4], "Sorted container")
    }
    
    test("Associated type constraints") {
        struct Item: Describable {
            let name: String
            var description: String { name }
        }
        
        let items = [Item(name: "A"), Item(name: "B"), Item(name: "C")]
        assertEqual(process(container: items), "A, B, C", "Process describable items")
    }
    
    runTests()
}