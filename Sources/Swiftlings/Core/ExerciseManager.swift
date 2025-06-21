import Foundation

/// Manages exercises and their metadata
class ExerciseManager {
    private let metadata: ExerciseMetadata
    private let progressTracker: ProgressTracker
    
    init() throws {
        self.metadata = try ExerciseMetadata.load()
        self.progressTracker = ProgressTracker()
    }
    
    /// Get all exercises
    var allExercises: [Exercise] {
        metadata.exercises
    }
    
    /// Get exercise by name
    func getExercise(named name: String) -> Exercise? {
        metadata.exercises.first { $0.name == name }
    }
    
    /// Get next pending exercise
    func getNextPendingExercise() -> Exercise? {
        for exercise in metadata.exercises {
            if !progressTracker.isCompleted(exercise.name) {
                return exercise
            }
        }
        return nil
    }
    
    /// Get exercises filtered by status
    func getExercises(completed: Bool? = nil) -> [Exercise] {
        if let completed = completed {
            return metadata.exercises.filter { exercise in
                progressTracker.isCompleted(exercise.name) == completed
            }
        }
        return metadata.exercises
    }
    
    /// Get exercise status
    func getExerciseStatus(_ exercise: Exercise) -> String {
        progressTracker.isCompleted(exercise.name) ? "✅" : "❌"
    }
    
    /// Mark exercise as completed
    func markCompleted(_ exercise: Exercise) {
        progressTracker.markCompleted(exercise.name)
    }
    
    /// Get current exercise
    func getCurrentExercise() -> Exercise? {
        if let currentName = progressTracker.getCurrentExercise() {
            return getExercise(named: currentName)
        }
        return getNextPendingExercise()
    }
    
    /// Set current exercise
    func setCurrentExercise(_ exercise: Exercise) {
        progressTracker.setCurrentExercise(exercise.name)
    }
    
    /// Get progress statistics
    func getProgressStats() -> (completed: Int, total: Int, percentage: Double) {
        let total = metadata.exercises.count
        let stats = progressTracker.getStats(totalExercises: total)
        return (stats.completed, total, stats.percentage)
    }
    
    /// Get welcome message
    var welcomeMessage: String {
        metadata.welcomeMessage
    }
    
    /// Get final message
    var finalMessage: String {
        metadata.finalMessage
    }
}