// variables2.swift
//
// Variables can be changed after they're declared.
// Fix the code to properly modify the variable.

func countApples() -> (initial: Int, final: Int) {
    // TODO: Fix this declaration so we can modify the apple count
    var apples = 3
    let initialCount = apples
    
    // I just bought 2 more apples! Update the count.
    // Hint: What's the difference between 'let' and 'var'?
    apples = apples + 2
    
    return (initial: initialCount, final: apples)
}

func main() {
    test("Can modify apple count") {
        let result = countApples()
        assertEqual(result.initial, 3, "Should start with 3 apples")
        assertEqual(result.final, 5, "Should end with 5 apples after buying 2 more")
    }
    
    runTests()
}
