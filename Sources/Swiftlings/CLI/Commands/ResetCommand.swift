import ArgumentParser
import Foundation

struct ResetCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "reset",
    abstract: "Reset exercises and/or progress"
  )

  @Argument(help: "The name of the exercise to reset (omit to reset all)")
  var exercise: String?

  @Flag(help: "Reset all exercises to their broken state")
  var all = false
  
  @Flag(help: "Only reset progress, not exercise files")
  var progressOnly = false

  @Flag(help: "Reset without confirmation")
  var force = false

  func run() throws {
    let metadata = try ExerciseMetadata.load()
    let progressTracker = ProgressTracker()
    let resetter = ExerciseResetter()
    
    // Determine what to reset
    let resetExercises = all || exercise != nil
    let resetProgress = all || progressOnly || exercise == nil
    
    // Build confirmation message
    var confirmationParts: [String] = []
    if all {
      confirmationParts.append("all exercises to their broken state")
      confirmationParts.append("all progress")
    } else if let exerciseName = exercise {
      confirmationParts.append("exercise '\(exerciseName)' to its broken state")
    } else if progressOnly {
      confirmationParts.append("all progress")
    }
    
    if !force && !confirmationParts.isEmpty {
      print("Are you sure you want to reset \(confirmationParts.joined(separator: " and "))? This will lose any changes.")
      print("Use --force to skip this confirmation.")
      return
    }
    
    // Reset exercises
    if resetExercises && !progressOnly {
      if let exerciseName = exercise {
        // Reset single exercise
        guard let exerciseToReset = metadata.exercises.first(where: { $0.name == exerciseName }) else {
          Terminal.error("Exercise '\(exerciseName)' not found")
          throw ExitCode.failure
        }
        
        Terminal.progress("Resetting exercise: \(exerciseName)...")
        try resetter.resetExercise(exerciseToReset)
        Terminal.success("Exercise '\(exerciseName)' reset to original state")
      } else if all {
        // Reset all exercises
        Terminal.progress("Resetting all exercises...")
        try resetter.resetAllExercises(metadata.exercises)
        Terminal.success("All exercises reset to original state")
      }
    }
    
    // Reset progress
    if resetProgress {
      Terminal.progress("Resetting progress...")
      progressTracker.resetProgress()
      Terminal.success("Progress reset")
    }
    
    print("")
    Terminal.info("Ready to start over! Run 'swiftlings' to begin.")
  }
}
