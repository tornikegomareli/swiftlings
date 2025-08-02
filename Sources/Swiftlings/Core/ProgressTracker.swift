import Foundation

/// Tracks user progress through exercises
class ProgressTracker {
  /// Structure to store progress state
  struct ProgressState: Codable {
    /// Names of completed exercises
    var completedExercises: Set<String>

    /// Name of the current exercise
    var currentExercise: String?

    /// Timestamp of last update
    var lastUpdated: Date

    init() {
      self.completedExercises = []
      self.currentExercise = nil
      self.lastUpdated = Date()
    }
  }

  private let stateFilePath = ".swiftlings-state.json"
  private var state: ProgressState

  init() {
    self.state = ProgressTracker.loadState() ?? ProgressState()
  }

  /// Load progress state from disk
  private static func loadState() -> ProgressState? {
    guard FileManager.default.fileExists(atPath: ".swiftlings-state.json") else {
      return nil
    }

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: ".swiftlings-state.json"))
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode(ProgressState.self, from: data)
    } catch {
      Terminal.warning("Failed to load progress state: \(error)")
      return nil
    }
  }

  /// Save progress state to disk
  private func saveState() {
    do {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      encoder.outputFormatting = .prettyPrinted
      let data = try encoder.encode(state)
      try data.write(to: URL(fileURLWithPath: stateFilePath))
    } catch {
      Terminal.error("Failed to save progress state: \(error)")
    }
  }

  /// Mark an exercise as completed
  func markCompleted(_ exerciseName: String) {
    state.completedExercises.insert(exerciseName)
    state.lastUpdated = Date()
    saveState()
  }

  /// Check if an exercise is completed
  func isCompleted(_ exerciseName: String) -> Bool {
    state.completedExercises.contains(exerciseName)
  }

  /// Get the current exercise
  func getCurrentExercise() -> String? {
    state.currentExercise
  }

  /// Set the current exercise
  func setCurrentExercise(_ exerciseName: String) {
    state.currentExercise = exerciseName
    state.lastUpdated = Date()
    saveState()
  }

  /// Get completion statistics
  func getStats(totalExercises: Int) -> (completed: Int, percentage: Double) {
    let completed = state.completedExercises.count
    let percentage = totalExercises > 0 ? Double(completed) / Double(totalExercises) * 100 : 0
    return (completed, percentage)
  }

  /// Reset all progress
  func resetProgress() {
    state = ProgressState()
    saveState()
  }
}
