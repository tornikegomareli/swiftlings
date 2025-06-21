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
            
            // Set as current exercise
            manager.setCurrentExercise(exerciseToRun)
            
            // Display exercise info
            Terminal.info("Running: \(exerciseToRun.name)")
            print("File: \(exerciseToRun.filePath)")
            print("")
            
            // Run the exercise
            let runner = ExerciseRunner(exercise: exerciseToRun)
            let result = try runner.run()
            
            switch result {
            case .success(let output):
                if !output.isEmpty {
                    print("Output:")
                    print(output)
                }
                
                // Automatically remove "I AM NOT DONE" marker if it exists
                if !runner.checkIfDone() {
                    try? runner.removeDoneMarker()
                    Terminal.info("✓ Automatically removed 'I AM NOT DONE' marker")
                }
                
                Terminal.success("Exercise \(exerciseToRun.name) completed successfully!")
                
                // Mark as completed
                manager.markCompleted(exerciseToRun)
                
                // Show next exercise
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
                
            case .notDone:
                Terminal.warning("Remove the 'I AM NOT DONE' comment when you're ready!")
                Terminal.info("File: \(exerciseToRun.filePath)")
                print("\nWhen you're done editing, run this command again.")
            }
            
        } catch {
            Terminal.error("Failed to run exercise: \(error)")
            throw ExitCode.failure
        }
    }
}