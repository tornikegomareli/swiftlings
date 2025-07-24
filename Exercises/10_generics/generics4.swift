// generics4.swift
//
// Advanced generics with conditional conformance and generic subscripts.
// Opaque types (some) provide reverse generics.
//
// Fix the advanced generic features to make the tests pass.

// TODO: Create a generic Result type
enum Result<Success, Failure> {  // Missing constraint on Failure
    case success(Success)
    case failure(Failure)
    
    // Add computed property isSuccess
    var isSuccess: Bool {
        return false  // Wrong implementation
    }
    
    // Add method to map success value
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value):
            return .failure(value)  // Wrong - should transform
        case .failure(let error):
            return .failure(error)
        }
    }
}

// TODO: Add conditional conformance to Equatable
extension Result {  // Missing where clause
    // Result should be Equatable when both Success and Failure are Equatable
}

// TODO: Create type with generic subscript
struct Matrix<T> {
    private var rows: [[T]]
    let rowCount: Int
    let columnCount: Int
    
    init(rows: Int, columns: Int, defaultValue: T) {
        self.rowCount = rows
        self.columnCount = columns
        self.rows = Array(repeating: Array(repeating: defaultValue, count: columns), count: rows)
    }
    
    // TODO: Add generic subscript that works with any RangeExpression
    subscript(row: Int, column: Int) -> T {
        get {
            return rows[row][column]
        }
        set {
            rows[row][column] = newValue
        }
    }
    
    // Add subscript for ranges
    subscript<R: RangeExpression>(rowRange: R) -> [[T]] 
        where R.Bound == Int {
        return []  // Should return subset of rows
    }
}

// TODO: Create function returning opaque type
protocol Shape {
    func area() -> Double
}

struct Circle: Shape {
    let radius: Double
    func area() -> Double { .pi * radius * radius }
}

struct Square: Shape {
    let side: Double
    func area() -> Double { side * side }
}

func makeShape(circular: Bool) -> Shape {  // Should return 'some Shape'
    if circular {
        return Circle(radius: 5)
    } else {
        return Square(side: 10)
    }
}

func main() {
    test("Generic Result type") {
        let success: Result<Int, String> = .success(42)
        let failure: Result<Int, String> = .failure("Error")
        
        assertTrue(success.isSuccess, "Success case")
        assertFalse(failure.isSuccess, "Failure case")
        
        let mapped = success.map { $0 * 2 }
        switch mapped {
        case .success(let value):
            assertEqual(value, 84, "Mapped value doubled")
        case .failure:
            assertFalse(true, "Should be success")
        }
    }
    
    test("Conditional conformance") {
        let result1: Result<Int, String> = .success(42)
        let result2: Result<Int, String> = .success(42)
        let result3: Result<Int, String> = .failure("Error")
        
        assertTrue(result1 == result2, "Equal success results")
        assertFalse(result1 == result3, "Success != Failure")
    }
    
    test("Generic subscripts") {
        var matrix = Matrix(rows: 3, columns: 3, defaultValue: 0)
        matrix[0, 0] = 1
        matrix[1, 1] = 5
        matrix[2, 2] = 9
        
        assertEqual(matrix[0, 0], 1, "Top-left element")
        assertEqual(matrix[1, 1], 5, "Center element")
        
        let firstTwoRows = matrix[0..<2]
        assertEqual(firstTwoRows.count, 2, "Got 2 rows")
        assertEqual(firstTwoRows[0][0], 1, "First row, first element")
    }
    
    test("Opaque return types") {
        let shape1 = makeShape(circular: true)
        let shape2 = makeShape(circular: false)
        
        assertEqual(shape1.area(), .pi * 25, accuracy: 0.001, "Circle area")
        assertEqual(shape2.area(), 100.0, "Square area")
        
        // Both return the same type ('some Shape')
        // This enables better performance and API design
    }
    
    runTests()
}

/// Helper for comparing doubles with accuracy
func assertEqual(_ actual: Double, _ expected: Double, accuracy: Double, _ message: String) {
    assertTrue(abs(actual - expected) < accuracy, 
               "\(message): expected \(expected), got \(actual)")
}