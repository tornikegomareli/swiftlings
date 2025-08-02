import Foundation

/// Root structure for the exercise metadata JSON file
struct ExerciseMetadata: Codable {
  let formatVersion: Int

  let welcomeMessage: String

  let finalMessage: String

  let exercises: [Exercise]

  private enum CodingKeys: String, CodingKey {
    case formatVersion = "format_version"
    case welcomeMessage = "welcome_message"
    case finalMessage = "final_message"
    case exercises
  }
}

extension ExerciseMetadata {
  static func load(from path: String = "Exercises/info.json") throws -> ExerciseMetadata {
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(ExerciseMetadata.self, from: data)
  }
}
