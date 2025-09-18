// switch1.swift
//
// The `switch` statement in Swift is powerful and exhaustive.
// Every possible value must be handled, either explicitly or with a default case.
//
// Fix the switch statement to make the tests pass.

func getDayType(_ day: String) -> String {
    // TODO: Add the missing return type for each case
    switch day {
    case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
        // Add return statement
    case "Saturday", "Sunday":
        // Add return statement
    default:
    }
}

func main() {
    test("Correctly identifies weekdays") {
        assertEqual(getDayType("Monday"), "Weekday", "Monday is a weekday")
        assertEqual(getDayType("Wednesday"), "Weekday", "Wednesday is a weekday")
        assertEqual(getDayType("Friday"), "Weekday", "Friday is a weekday")
    }
    
    test("Correctly identifies weekends") {
        assertEqual(getDayType("Saturday"), "Weekend", "Saturday is weekend")
        assertEqual(getDayType("Sunday"), "Weekend", "Sunday is weekend")
    }
    
    test("Handles invalid input") {
        assertEqual(getDayType("Funday"), "Invalid day", "Invalid day name")
        assertEqual(getDayType(""), "Invalid day", "Empty string is invalid")
    }
    
    runTests()
}
