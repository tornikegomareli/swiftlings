import Foundation

/// Handles exercise execution
final class ExerciseExecutor {
  private let processRunner: ProcessRunning

  init(processRunner: ProcessRunning = ProcessRunner()) {
    self.processRunner = processRunner
  }

  /// Execute compiled exercise
  func execute(
    executablePath: URL,
    usesTests: Bool
  ) throws -> ExecutionResult {
    let result = try processRunner.run(
      executable: executablePath.path,
      arguments: [],
      currentDirectory: executablePath.deletingLastPathComponent()
    )

    if usesTests {
      if result.isSuccess {
        return .success(output: result.stdout)
      } else {
        let combinedOutput = result.stdout + (result.stderr.isEmpty ? "" : "\n\(result.stderr)")
        return .testFailure(message: combinedOutput)
      }
    } else {
      if result.isSuccess {
        return .success(output: result.stdout)
      } else {
        let errorMessage = result.stderr.isEmpty
          ? "Exercise failed with exit code \(result.exitCode)"
          : result.stderr
        return .testFailure(message: errorMessage)
      }
    }
  }
}

/// Result of execution
enum ExecutionResult {
  case success(output: String)
  case testFailure(message: String)
}
