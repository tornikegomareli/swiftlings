import Foundation

/// Custom error for compilation failures
struct CompilationError: Error {
  let message: String
}

/// Handles compilation and execution of exercises
class ExerciseRunner {
  private let exercise: Exercise
  private let fileManager = FileManager.default

  init(exercise: Exercise) {
    self.exercise = exercise
  }

  /// Determine if the exercise uses the new test-based approach
  private func usesTestApproach() -> Bool {
    let fullPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      .appendingPathComponent(exercise.filePath)
    
    guard let content = try? String(contentsOf: fullPath) else {
      return false
    }
    
    // Check if the file imports our assert framework or calls runTests()
    return content.contains("runTests()") || content.contains("SwiftlingsAssert") || 
           content.contains("assertEqual") || content.contains("assertTrue")
  }

  /// Run the exercise
  func run() throws -> ExerciseResult {

    // Create a temporary directory for compilation
    let tempDir = FileManager.default.temporaryDirectory
      .appendingPathComponent("swiftlings-\(UUID().uuidString)")
    try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)

    defer {
      // Clean up temporary directory
      try? fileManager.removeItem(at: tempDir)
    }

    // Copy exercise file to temp directory
    let tempFile = tempDir.appendingPathComponent("\(exercise.name).swift")
    let sourceFile = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      .appendingPathComponent(exercise.filePath)
    try fileManager.copyItem(at: sourceFile, to: tempFile)

    // Copy Assert.swift to temp directory if exercise uses test approach
    let usesTests = usesTestApproach()
    if usesTests {
      let assertSourcePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources/Swiftlings/Core/Assert.swift")
      let assertDestPath = tempDir.appendingPathComponent("Assert.swift")
      
      if fileManager.fileExists(atPath: assertSourcePath.path) {
        try fileManager.copyItem(at: assertSourcePath, to: assertDestPath)
      }
    }
    
    // Create a main.swift that calls the exercise
    let mainFile = tempDir.appendingPathComponent("main.swift")
    let mainContent = """
      // Call the main function from the exercise
      main()
      """
    try mainContent.write(to: mainFile, atomically: true, encoding: .utf8)

    do {
      // Use Process instead of shellOut to capture stderr
      let process = Process()
      process.currentDirectoryURL = tempDir
      process.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
      var compileArgs = ["-o", "exercise", "main.swift", "\(exercise.name).swift"]
      if usesTests && fileManager.fileExists(atPath: tempDir.appendingPathComponent("Assert.swift").path) {
        compileArgs.append("Assert.swift")
      }
      process.arguments = compileArgs

      let errorPipe = Pipe()
      let outputPipe = Pipe()
      process.standardError = errorPipe
      process.standardOutput = outputPipe

      try process.run()
      process.waitUntilExit()

      let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()

      if process.terminationStatus != 0 {
        let errorOutput = String(data: errorData, encoding: .utf8) ?? ""
        let standardOutput = String(data: outputData, encoding: .utf8) ?? ""
        let combinedOutput = errorOutput.isEmpty ? standardOutput : errorOutput
        throw CompilationError(message: combinedOutput)
      }

      let compileOutput = String(data: outputData, encoding: .utf8) ?? ""

      if !compileOutput.isEmpty {
        Terminal.info("Compiler output: \(compileOutput)")
      }

      // Run the compiled exercise
      Terminal.progress("Running \(exercise.name)...")

      let runProcess = Process()
      runProcess.currentDirectoryURL = tempDir
      runProcess.executableURL = tempDir.appendingPathComponent("exercise")

      let runOutputPipe = Pipe()
      let runErrorPipe = Pipe()
      runProcess.standardOutput = runOutputPipe
      runProcess.standardError = runErrorPipe

      try runProcess.run()
      runProcess.waitUntilExit()

      let runOutputData = runOutputPipe.fileHandleForReading.readDataToEndOfFile()
      let runErrorData = runErrorPipe.fileHandleForReading.readDataToEndOfFile()

      let runOutput = String(data: runOutputData, encoding: .utf8) ?? ""
      let runError = String(data: runErrorData, encoding: .utf8) ?? ""

      // For test-based exercises, check the exit code and output
      if usesTests {
        if runProcess.terminationStatus != 0 {
          // Test failure - tests didn't pass
          let combinedOutput = runOutput + (runError.isEmpty ? "" : "\n\(runError)")
          return .testFailure(message: combinedOutput)
        } else {
          // Tests passed
          return .success(output: runOutput)
        }
      } else {
        // For non-test exercises, any non-zero exit code is a failure
        if runProcess.terminationStatus != 0 {
          let errorMessage =
            runError.isEmpty
            ? "Exercise failed with exit code \(runProcess.terminationStatus)" : runError
          return .testFailure(message: errorMessage)
        }
        return .success(output: runOutput)
      }

    } catch let error as CompilationError {
      return .compilationError(message: error.message)
    }
  }
}

/// Result of running an exercise
enum ExerciseResult {
  case success(output: String)
  case compilationError(message: String)
  case testFailure(message: String)

  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    default:
      return false
    }
  }
}
