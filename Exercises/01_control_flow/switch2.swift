// switch2.swift
//
// Swift's switch statement can match ranges and use where clauses.
// This makes it very powerful for complex pattern matching.
//
// Fix the switch cases to properly categorize scores.

func gradeScore(_ score: Int) -> String {
    switch score {
    // TODO: Fix these cases to match the test expectations
    case 90:
        return "A"
    case 80:
        return "B"
    case 70:
        return "C"
    case 60:
        return "D"
    case 0:
        return "F"
    default:
        return "Invalid score"
    }
}

func main() {
    test("Correctly assigns A grades") {
        assertEqual(gradeScore(90), "A", "90 should be an A")
        assertEqual(gradeScore(95), "A", "95 should be an A")
        assertEqual(gradeScore(100), "A", "100 should be an A")
    }
    
    test("Correctly assigns B grades") {
        assertEqual(gradeScore(80), "B", "80 should be a B")
        assertEqual(gradeScore(85), "B", "85 should be a B")
        assertEqual(gradeScore(89), "B", "89 should be a B")
    }
    
    test("Correctly assigns C grades") {
        assertEqual(gradeScore(70), "C", "70 should be a C")
        assertEqual(gradeScore(75), "C", "75 should be a C")
        assertEqual(gradeScore(79), "C", "79 should be a C")
    }
    
    test("Correctly assigns D grades") {
        assertEqual(gradeScore(60), "D", "60 should be a D")
        assertEqual(gradeScore(65), "D", "65 should be a D")
        assertEqual(gradeScore(69), "D", "69 should be a D")
    }
    
    test("Correctly assigns F grades") {
        assertEqual(gradeScore(0), "F", "0 should be an F")
        assertEqual(gradeScore(30), "F", "30 should be an F")
        assertEqual(gradeScore(59), "F", "59 should be an F")
    }
    
    test("Handles invalid scores") {
        assertEqual(gradeScore(-10), "Invalid score", "Negative scores are invalid")
        assertEqual(gradeScore(101), "Invalid score", "Scores above 100 are invalid")
    }
    
    runTests()
}