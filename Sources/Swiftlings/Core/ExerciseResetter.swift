import Foundation

/// Handles resetting exercises to their original state
final class ExerciseResetter {
    private let processRunner: ProcessRunning
    
    init(processRunner: ProcessRunning = ProcessRunner()) {
        self.processRunner = processRunner
    }
    
    /// Reset a single exercise to its original state using git
    func resetExercise(_ exercise: Exercise) throws {
        let result = try processRunner.run(
            executable: Configuration.Executables.git,
            arguments: ["checkout", "HEAD", "--", exercise.filePath],
            currentDirectory: nil
        )
        
        if !result.isSuccess {
            throw ResetError.gitResetFailed(result.stderr)
        }
    }
    
    /// Reset multiple exercises
    func resetExercises(_ exercises: [Exercise]) throws {
        var errors: [(Exercise, Error)] = []
        
        for exercise in exercises {
            do {
                try resetExercise(exercise)
            } catch {
                errors.append((exercise, error))
            }
        }
        
        if !errors.isEmpty {
            throw ResetError.multipleErrors(
                errors.map { "Failed to reset \($0.0.name): \($0.1.localizedDescription)" }
            )
        }
    }
}

/// Reset-related errors
enum ResetError: Error, LocalizedError {
    case gitResetFailed(String)
    case multipleErrors([String])
    
    var errorDescription: String? {
        switch self {
        case .gitResetFailed(let error):
            return "Failed to reset exercise: \(error)"
        case .multipleErrors(let errors):
            return "Multiple reset errors:\n" + errors.joined(separator: "\n")
        }
    }
}