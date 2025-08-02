import ArgumentParser
import Foundation

struct RunCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "run",
    abstract: "Run an exercise"
  )
  
  @Argument(help: "The name of the exercise to run")
  var exercise: String?
  
  func run() throws {
    do {
      let manager = try ExerciseManager()
      
      // Determine which exercise to run
      let exerciseToRun: Exercise
      if let exerciseName = exercise {
        guard let ex = manager.getExercise(named: exerciseName) else {
          Terminal.error("Exercise '\(exerciseName)' not found")
          throw ExitCode.failure
        }
        exerciseToRun = ex
      } else {
        guard let ex = manager.getCurrentExercise() else {
          Terminal.success("Congratulations! You've completed all exercises! 🎉")
          print("\n\(manager.finalMessage)")
          return
        }
        exerciseToRun = ex
      }
      
      manager.setCurrentExercise(exerciseToRun)
      
      Terminal.info("Running: \(exerciseToRun.name)")
      print("File: \(exerciseToRun.filePath)")
      print("")
      
      let runner = ExerciseRunner(exercise: exerciseToRun)
      let result = try runner.run()
      
      switch result {
      case .success(let output):
        if !output.isEmpty {
          print("Output:")
          print(output)
        }
        
        
        Terminal.success("Exercise \(exerciseToRun.name) completed successfully!")
        
        manager.markCompleted(exerciseToRun)
        
        if let nextExercise = manager.getNextPendingExercise() {
          Terminal.info("Next exercise: \(nextExercise.name)")
        } else {
          Terminal.success("All exercises completed! 🎉")
        }
        
      case .compilationError(let message):
        Terminal.error("Compilation failed:")
        print("")
        print(message)
        print("")
        Terminal.info("Try again after fixing the errors!")
        
      case .testFailure(let message):
        Terminal.error("Tests failed:")
        print(message)
        Terminal.info("Keep trying!")
      }
      
    } catch {
      Terminal.error("Failed to run exercise: \(error)")
      throw ExitCode.failure
    }
  }
}
