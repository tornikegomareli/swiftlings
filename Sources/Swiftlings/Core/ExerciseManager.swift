import Foundation

/// Manages exercises and their metadata
class ExerciseManager {
  private let metadata: ExerciseMetadata
  private let progressTracker: ProgressTracker
  private let exerciseResetter: ExerciseResetter
  
  /// Optional category filter to restrict exercises to specific directories
  var categoryFilter: String?

  init() throws {
    self.metadata = try ExerciseMetadata.load()
    self.progressTracker = ProgressTracker()

    // Initialize resetter
    self.exerciseResetter = ExerciseResetter()
    
    /// Check for category filter from environment
    if let filter = ProcessInfo.processInfo.environment["SWIFTLINGS_CATEGORY_FILTER"] {
      self.categoryFilter = filter
    }
  }
  
  /// Returns filtered exercises based on categoryFilter if set
  private var filteredExercises: [Exercise] {
    if let filter = categoryFilter {
      return metadata.exercises.filter { $0.dir == filter }
    }
    return metadata.exercises
  }

  var allExercises: [Exercise] {
    filteredExercises
  }

  func getAllExercises() -> [Exercise] {
    filteredExercises
  }

  func getExercise(named name: String) -> Exercise? {
    filteredExercises.first { $0.name == name }
  }

  func getNextPendingExercise() -> Exercise? {
    for exercise in filteredExercises {
      if !progressTracker.isCompleted(exercise.name) {
        return exercise
      }
    }
    return nil
  }

  func getExercises(completed: Bool? = nil) -> [Exercise] {
    if let completed = completed {
      return filteredExercises.filter { exercise in
        progressTracker.isCompleted(exercise.name) == completed
      }
    }
    return filteredExercises
  }

  func getPendingExercises() -> [Exercise] {
    return getExercises(completed: false)
  }

  func getExerciseStatus(_ exercise: Exercise) -> String {
    progressTracker.isCompleted(exercise.name) ? "✅" : "❌"
  }

  func isCompleted(_ exerciseName: String) -> Bool {
    progressTracker.isCompleted(exerciseName)
  }

  func markCompleted(_ exercise: Exercise) {
    progressTracker.markCompleted(exercise.name)
  }

  func getCurrentExercise() -> Exercise? {
    if let currentName = progressTracker.getCurrentExercise() {
      return getExercise(named: currentName)
    }
    return getNextPendingExercise()
  }

  func setCurrentExercise(_ exercise: Exercise) {
    progressTracker.setCurrentExercise(exercise.name)
  }

  func getProgressStats() -> (completed: Int, total: Int, percentage: Double) {
    let exercises = filteredExercises
    let total = exercises.count
    let completed = exercises.filter { progressTracker.isCompleted($0.name) }.count
    let percentage = total > 0 ? Double(completed) / Double(total) * 100 : 0
    return (completed, total, percentage)
  }

  var welcomeMessage: String {
    metadata.welcomeMessage
  }

  var finalMessage: String {
    metadata.finalMessage
  }

  /// Reset an exercise to its original broken state
  func resetExercise(_ exercise: Exercise) throws {
    try exerciseResetter.resetExercise(exercise)
  }

  /// Reset all progress
  func resetAllProgress() {
    progressTracker.resetProgress()
  }
  
  /// Reset progress for DSA exercises (current category filter)
  func resetDSAProgress() {
    if let filter = categoryFilter {
      /// Reset progress for all exercises in the filtered category
      let dsaExercises = metadata.exercises.filter { $0.dir == filter }
      for exercise in dsaExercises {
        progressTracker.resetExercise(exercise.name)
        /// Also reset the actual exercise files
        do {
          try exerciseResetter.resetExercise(exercise)
        } catch {
          print("Failed to reset exercise \(exercise.name): \(error)")
        }
      }
      /// Set current exercise to the first one in the category
      if let firstExercise = filteredExercises.first {
        setCurrentExercise(firstExercise)
      }
    }
  }
}
