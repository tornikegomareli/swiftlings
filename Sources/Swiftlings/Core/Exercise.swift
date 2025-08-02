import Foundation

/// Represents a single exercise in Swiftlings
struct Exercise: Codable, Equatable {
  let name: String

  let dir: String

  let hint: String

  let dependencies: [String]?

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
