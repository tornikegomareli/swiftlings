import Testing
import Foundation
@testable import Swiftlings

@Suite("SwiftlingsError Tests")
struct SwiftlingsErrorTests {
  @Test("SwiftlingsError protocol conformance")
  func testSwiftlingsErrorProtocol() {
    let error: SwiftlingsError = ExerciseError.notFound(name: "test")
    #expect(error.errorDescription == "Exercise 'test' not found")
    #expect(error.userMessage == "Exercise 'test' not found")
  }

  @Test("ExerciseError cases")
  func testExerciseError() {

    let notFound = ExerciseError.notFound(name: "variables1")
    #expect(notFound.userMessage == "Exercise 'variables1' not found")


    let compilationFailed = ExerciseError.compilationFailed(
      message: "error: use of unresolved identifier 'foo'"
    )
    #expect(compilationFailed.userMessage == "Compilation failed:\nerror: use of unresolved identifier 'foo'")


    let testsFailed = ExerciseError.testsFailed(
      message: "Test case 'testAddition' failed: Expected 4 but got 5"
    )
    #expect(testsFailed.userMessage == "Tests failed:\nTest case 'testAddition' failed: Expected 4 but got 5")


    let executionFailed = ExerciseError.executionFailed(exitCode: 127)
    #expect(executionFailed.userMessage == "Exercise failed with exit code 127")


    let underlyingError = NSError(domain: "TestDomain", code: 1, userInfo: [
      NSLocalizedDescriptionKey: "Permission denied",
    ])
    let fileReadError = ExerciseError.fileReadError(
      path: "/path/to/file.swift",
      underlying: underlyingError
    )
    #expect(fileReadError.userMessage == "Failed to read file '/path/to/file.swift': Permission denied")
  }

  @Test("ProgressError cases")
  func testProgressError() {
    let underlyingError = NSError(domain: "TestDomain", code: 2, userInfo: [
      NSLocalizedDescriptionKey: "File not found",
    ])


    let failedToLoad = ProgressError.failedToLoad(underlying: underlyingError)
    #expect(failedToLoad.userMessage == "Failed to load progress: File not found")


    let failedToSave = ProgressError.failedToSave(underlying: underlyingError)
    #expect(failedToSave.userMessage == "Failed to save progress: File not found")


    let corrupted = ProgressError.corrupted(message: "Invalid JSON structure")
    #expect(corrupted.userMessage == "Progress file corrupted: Invalid JSON structure")
  }

  @Test("ProcessError cases")
  func testProcessError() {

    let execNotFound = ProcessError.executableNotFound(path: "/usr/bin/nonexistent")
    #expect(execNotFound.userMessage == "Executable not found: /usr/bin/nonexistent")


    let execFailed = ProcessError.executionFailed(
      executable: "swiftc",
      exitCode: 1,
      stderr: "error: module 'Foundation' not found"
    )
    #expect(execFailed.userMessage == "swiftc failed (exit code 1):\nerror: module 'Foundation' not found")


    let timeout = ProcessError.timeout(executable: "swift")
    #expect(timeout.userMessage == "swift timed out")
  }

  @Test("FileSystemError cases")
  func testFileSystemError() {

    let fileNotFound = FileSystemError.fileNotFound(path: "/path/to/missing.swift")
    #expect(fileNotFound.userMessage == "File not found: /path/to/missing.swift")


    let dirNotFound = FileSystemError.directoryNotFound(path: "/missing/directory")
    #expect(dirNotFound.userMessage == "Directory not found: /missing/directory")


    let permDenied = FileSystemError.permissionDenied(path: "/root/protected.file")
    #expect(permDenied.userMessage == "Permission denied: /root/protected.file")


    let createError = NSError(domain: "TestDomain", code: 3, userInfo: [
      NSLocalizedDescriptionKey: "Disk full",
    ])
    let failedCreate = FileSystemError.failedToCreateDirectory(
      path: "/new/dir",
      underlying: createError
    )
    #expect(failedCreate.userMessage == "Failed to create directory '/new/dir': Disk full")


    let copyError = NSError(domain: "TestDomain", code: 4, userInfo: [
      NSLocalizedDescriptionKey: "Source file missing",
    ])
    let failedCopy = FileSystemError.failedToCopyFile(
      from: "/source.txt",
      to: "/dest.txt",
      underlying: copyError
    )
    #expect(failedCopy.userMessage == "Failed to copy '/source.txt' to '/dest.txt': Source file missing")
  }

  @Test("ConfigurationError cases")
  func testConfigurationError() {

    let missingInfo = ConfigurationError.missingInfoFile
    #expect(missingInfo.userMessage == "Exercise info file not found. Are you in a Swiftlings directory?")


    let invalidInfo = ConfigurationError.invalidInfoFile(message: "Missing 'exercises' key")
    #expect(invalidInfo.userMessage == "Invalid exercise info file: Missing 'exercises' key")


    let incompatible = ConfigurationError.incompatibleVersion(found: "2.0", required: "1.0")
    #expect(incompatible.userMessage == "Incompatible version: found 2.0, required 1.0")
  }

  @Test("Error with special characters and formatting")
  func testErrorsWithSpecialCharacters() {

    let specialName = ExerciseError.notFound(name: "test-exercise_123")
    #expect(specialName.userMessage == "Exercise 'test-exercise_123' not found")


    let complexMessage = ExerciseError.compilationFailed(
      message: "error: \"string\" literal\n\tat line 10: unexpected character '🎯'"
    )
    #expect(complexMessage.userMessage.contains("\"string\" literal"))
    #expect(complexMessage.userMessage.contains("🎯"))


    let pathWithSpaces = FileSystemError.fileNotFound(
      path: "/Users/John Doe/My Documents/file.swift"
    )
    #expect(pathWithSpaces.userMessage == "File not found: /Users/John Doe/My Documents/file.swift")
  }

  @Test("Error as LocalizedError")
  func testErrorAsLocalizedError() {
    let errors: [LocalizedError] = [
      ExerciseError.notFound(name: "test"),
      ProgressError.corrupted(message: "test"),
      ProcessError.timeout(executable: "test"),
      FileSystemError.fileNotFound(path: "test"),
      ConfigurationError.missingInfoFile,
    ]

    for error in errors {
      #expect(error.errorDescription != nil)
      #expect(!error.errorDescription!.isEmpty)
    }
  }
}
