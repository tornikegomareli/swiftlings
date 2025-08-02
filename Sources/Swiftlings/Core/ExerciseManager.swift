import Foundation

/// Manages exercises and their metadata
class ExerciseManager {
  private let metadata: ExerciseMetadata
  private let progressTracker: ProgressTracker
  private let exerciseResetter: ExerciseResetter

  init() throws {
    self.metadata = try ExerciseMetadata.load()
    self.progressTracker = ProgressTracker()

    // Initialize resetter
    self.exerciseResetter = ExerciseResetter()
  }

  var allExercises: [Exercise] {
    metadata.exercises
  }

  func getAllExercises() -> [Exercise] {
    metadata.exercises
  }

  func getExercise(named name: String) -> Exercise? {
    metadata.exercises.first { $0.name == name }
  }

  func getNextPendingExercise() -> Exercise? {
    for exercise in metadata.exercises {
      if !progressTracker.isCompleted(exercise.name) {
        return exercise
      }
    }
    return nil
  }

  func getExercises(completed: Bool? = nil) -> [Exercise] {
    if let completed = completed {
      return metadata.exercises.filter { exercise in
        progressTracker.isCompleted(exercise.name) == completed
      }
    }
    return metadata.exercises
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
    let total = metadata.exercises.count
    let stats = progressTracker.getStats(totalExercises: total)
    return (stats.completed, total, stats.percentage)
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
}
