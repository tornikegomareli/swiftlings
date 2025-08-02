import Foundation

/// Result of process execution
struct ProcessResult {
  let exitCode: Int32
  let stdout: String
  let stderr: String

  var isSuccess: Bool {
    exitCode == 0
  }
}

/// Protocol for process execution
protocol ProcessRunning {
  func run(
    executable: String,
    arguments: [String],
    currentDirectory: URL?
  ) throws -> ProcessResult
}

/// Default implementation of process runner
final class ProcessRunner: ProcessRunning {
  func run(
    executable: String,
    arguments: [String],
    currentDirectory: URL? = nil
  ) throws -> ProcessResult {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments

    if let directory = currentDirectory {
      process.currentDirectoryURL = directory
    }

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    try process.run()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    return ProcessResult(
      exitCode: process.terminationStatus,
      stdout: String(data: outputData, encoding: .utf8) ?? "",
      stderr: String(data: errorData, encoding: .utf8) ?? ""
    )
  }
}

/// Mock implementation for testing
final class MockProcessRunner: ProcessRunning {
  var mockResults: [ProcessResult] = []
  var capturedCalls: [(executable: String, arguments: [String], directory: URL?)] = []
  private var currentIndex = 0

  func run(
    executable: String,
    arguments: [String],
    currentDirectory: URL? = nil
  ) throws -> ProcessResult {
    capturedCalls.append((executable, arguments, currentDirectory))

    guard currentIndex < mockResults.count else {
      return ProcessResult(exitCode: 0, stdout: "", stderr: "")
    }

    let result = mockResults[currentIndex]
    currentIndex += 1
    return result
  }

  func reset() {
    currentIndex = 0
    capturedCalls.removeAll()
  }
}
