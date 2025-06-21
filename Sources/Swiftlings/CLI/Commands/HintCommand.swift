import ArgumentParser
import Foundation

struct HintCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "hint",
        abstract: "Show a hint for an exercise"
    )
    
    @Argument(help: "The name of the exercise to get a hint for")
    var exercise: String?
    
    func run() throws {
        do {
            let manager = try ExerciseManager()
            
            // Determine which exercise to show hint for
            let exerciseForHint: Exercise
            if let exerciseName = exercise {
                guard let ex = manager.getExercise(named: exerciseName) else {
                    Terminal.error("Exercise '\(exerciseName)' not found")
                    throw ExitCode.failure
                }
                exerciseForHint = ex
            } else {
                guard let ex = manager.getCurrentExercise() else {
                    Terminal.info("No current exercise. Use 'swiftlings run' to start!")
                    return
                }
                exerciseForHint = ex
            }
            
            // Display hint
            Terminal.info("Hint for '\(exerciseForHint.name)':")
            print("")
            print("💡 \(exerciseForHint.hint)")
            print("")
            
        } catch {
            Terminal.error("Failed to show hint: \(error)")
            throw ExitCode.failure
        }
    }
}