import Foundation


// TODO: REFACTOR!!

/// Handles resetting exercises to their original broken state
class ExerciseResetter {
    private let fileManager = FileManager.default
    
    /// Reset a single exercise to its broken state
    func resetExercise(_ exercise: Exercise) throws {
        let fullPath = URL(fileURLWithPath: fileManager.currentDirectoryPath)
            .appendingPathComponent(exercise.filePath)
        
        guard var content = try? String(contentsOf: fullPath) else {
            throw ResetError.fileNotFound(exercise.filePath)
        }
        
        /// Apply the breaking changes based on exercise name
        content = breakExercise(exercise.name, content: content)
        
        /// Write back to file
        try content.write(to: fullPath, atomically: true, encoding: .utf8)
    }
    
    /// Reset all exercises to their broken state
    func resetAllExercises(_ exercises: [Exercise]) throws {
        for exercise in exercises {
            try resetExercise(exercise)
        }
    }
    
    /// Apply breaking changes to exercise content based on exercise name
    private func breakExercise(_ name: String, content: String) -> String {
        var brokenContent = content
        
        switch name {
        case "intro2":
            // Change print to println
            brokenContent = brokenContent.replacingOccurrences(
                of: "print(\"Hello, World!\")",
                with: "println(\"Hello, World!\")"
            )
            
        case "variables1":
            // Change var to let
            brokenContent = brokenContent.replacingOccurrences(
                of: "var x = 5",
                with: "let x = 5"
            )
            
        case "variables2":
            // Change var to let
            brokenContent = brokenContent.replacingOccurrences(
                of: "var apples = 3",
                with: "let apples = 3"
            )
            
        case "variables3":
            // Change let to var for pi, and var to let for radius
            brokenContent = brokenContent.replacingOccurrences(
                of: "let pi = 3.14159",
                with: "var pi = 3.14159"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "var radius = 5.0",
                with: "let radius = 5.0"
            )
            
        case "types1":
            // Break type annotations
            brokenContent = brokenContent.replacingOccurrences(
                of: "let name: String = \"Swift\"",
                with: "let name: Int = \"Swift\""
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let year: Int = 2024",
                with: "let year: String = 2024"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let version: Double = 5.9",
                with: "let version: Int = 5.9"
            )
            
        case "types2":
            // Remove type annotations or initial values
            brokenContent = brokenContent.replacingOccurrences(
                of: "let count = 42",
                with: "let count: Int"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "var message = \"Hello, Swift!\"",
                with: "var message: String"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let price: Double = 19.99",
                with: "let price = 19.99"
            )
            
        case "operators1":
            // Break operators
            brokenContent = brokenContent.replacingOccurrences(
                of: "let sum = a + b",
                with: "let sum = a - b"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let difference = a - b",
                with: "let difference = a + b"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let product = a * b",
                with: "let product = a / b"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let quotient = a / b",
                with: "let quotient = a * b"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let remainder = a % b",
                with: "let remainder = a + b"
            )
            
        case "operators2":
            // Break boolean expressions
            brokenContent = brokenContent.replacingOccurrences(
                of: "let isAdult = age >= 18",
                with: "let isAdult = age > 18"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let canDrive = age >= 16 && hasLicense",
                with: "let canDrive = age > 16 || hasLicense"
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let isTeenager = age >= 13 && age <= 19",
                with: "let isTeenager = age > 13 || age < 19"
            )
            
        case "strings1":
            // Break string interpolation and concatenation
            brokenContent = brokenContent.replacingOccurrences(
                of: "let greeting = \"Hello, \\(name)!\"",
                with: "let greeting = \"Hello, (name)!\""
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "let fullMessage = greeting + \" Welcome to Swift.\"",
                with: "let fullMessage = greeting - \" Welcome to Swift.\""
            )
            
        case "strings2":
            // Break multi-line strings and escape sequences
            brokenContent = brokenContent.replacingOccurrences(
                of: "let poem = \"\"\"",
                with: "let poem = \"\""
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "\\\"Swiftlings\\\"",
                with: "\"Swiftlings\""
            )
            brokenContent = brokenContent.replacingOccurrences(
                of: "line1\\nline2",
                with: "line1 line2"
            )
            
        default:
            // For intro1 and any other exercises, no breaking needed
            break
        }
        
        return brokenContent
    }
}

enum ResetError: Error, LocalizedError {
    case fileNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "Exercise file not found: \(path)"
        }
    }
}
