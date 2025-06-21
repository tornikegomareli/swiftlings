import Foundation

/// Root structure for the exercise metadata JSON file
struct ExerciseMetadata: Codable {
    /// Format version for future compatibility
    let formatVersion: Int
    
    /// Welcome message shown when starting Swiftlings
    let welcomeMessage: String
    
    /// Final message shown when all exercises are completed
    let finalMessage: String
    
    /// List of all exercises
    let exercises: [Exercise]
    
    private enum CodingKeys: String, CodingKey {
        case formatVersion = "format_version"
        case welcomeMessage = "welcome_message"
        case finalMessage = "final_message"
        case exercises
    }
}

/// Extension to load metadata from JSON file
extension ExerciseMetadata {
    /// Load exercise metadata from the info.json file
    static func load(from path: String = "Exercises/info.json") throws -> ExerciseMetadata {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(ExerciseMetadata.self, from: data)
    }
}