import Foundation

/// Represents a single exercise in Swiftlings
struct Exercise: Codable, Equatable {
    /// Unique name of the exercise (e.g., "intro1", "variables1")
    let name: String
    
    /// Directory category (e.g., "00_intro", "01_variables")
    let dir: String
    
    /// Hint text to help the user solve the exercise
    let hint: String
    
    /// Optional dependencies - exercises that should be completed before this one
    let dependencies: [String]?
    
    /// Computed property for the full file path
    var filePath: String {
        "Exercises/\(dir)/\(name).swift"
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case dir
        case hint
        case dependencies
    }
}