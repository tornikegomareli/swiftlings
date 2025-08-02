import Foundation

/// Detects if an exercise uses the test approach
final class TestDetector {
  private let fileManager: FileManager

  init(fileManager: FileManager = .default) {
    self.fileManager = fileManager
  }

  /// Determine if the exercise uses the test-based approach
  func usesTestApproach(exercisePath: URL) -> Bool {
    guard let content = try? String(contentsOf: exercisePath) else {
      return false
    }

    // Check if the file imports our assert framework or calls runTests()
    return content.contains("runTests()") ||
      content.contains("SwiftlingsAssert") ||
      content.contains("assertEqual") ||
      content.contains("assertTrue")
  }
}
