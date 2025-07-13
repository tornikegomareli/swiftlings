// sets1.swift
//
// Sets are unordered collections of unique values.
// They're perfect when you need to ensure uniqueness or perform set operations.
//
// Fix the set operations to make the tests pass.

func createSets() -> (numbers: Set<Int>, empty: Set<String>, fromArray: Set<Character>) {
    // TODO: Fix set literal syntax
    let numbers: Set = {1, 2, 3, 4, 5}
    
    // TODO: Create an empty Set of Strings
    let empty = Set<String>[]
    
    // TODO: Create a set from an array of characters (remove duplicates)
    let letters = ["a", "b", "c", "a", "b"]
    let fromArray = Set(letters)  // This creates Set<String>, not Set<Character>
    
    return (numbers, empty, fromArray)
}

func setOperations() -> (union: Set<Int>, intersection: Set<Int>, difference: Set<Int>) {
    let evens: Set = [2, 4, 6, 8, 10]
    let primes: Set = [2, 3, 5, 7, 11]
    
    // TODO: Find union (all elements from both sets)
    let union = evens + primes  // Wrong operator
    
    // TODO: Find intersection (common elements)
    let intersection = evens.intersect(primes)  // Wrong method name
    
    // TODO: Find difference (elements in evens but not in primes)
    let difference = evens - primes  // This might work but check method name
    
    return (union, intersection, difference)
}

func main() {
    test("Set creation") {
        let (nums, empty, chars) = createSets()
        assertEqual(nums, Set([1, 2, 3, 4, 5]), "Numbers set")
        assertTrue(empty.isEmpty, "Empty set should be empty")
        assertEqual(chars, Set(["a", "b", "c"]), "Should have unique characters")
    }
    
    test("Set operations") {
        let result = setOperations()
        assertEqual(result.union, Set([2, 3, 4, 5, 6, 7, 8, 10, 11]), "Union of sets")
        assertEqual(result.intersection, Set([2]), "Only 2 is in both sets")
        assertEqual(result.difference, Set([4, 6, 8, 10]), "Evens minus primes")
    }
    
    runTests()
}