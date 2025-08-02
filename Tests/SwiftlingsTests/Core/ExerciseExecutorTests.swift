import Testing
import Foundation
@testable import Swiftlings

@Suite("ExerciseExecutor Tests")
struct ExerciseExecutorTests {
  @Test("ExerciseExecutor successful execution without tests")
  func testSuccessfulExecutionWithoutTests() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(exitCode: 0, stdout: "Hello, World!", stderr: ""),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: false
    )


    switch result {
      case .success(let output):
        #expect(output == "Hello, World!")
      case .testFailure:
        Issue.record("Expected success but got test failure")
    }


    #expect(mockRunner.capturedCalls.count == 1)
    let call = mockRunner.capturedCalls[0]
    #expect(call.executable == "/tmp/test/exercise")
    #expect(call.arguments.isEmpty)
    #expect(call.directory?.path == "/tmp/test")
  }

  @Test("ExerciseExecutor successful execution with tests")
  func testSuccessfulExecutionWithTests() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(exitCode: 0, stdout: "All tests passed!", stderr: ""),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: true
    )

    switch result {
      case .success(let output):
        #expect(output == "All tests passed!")
      case .testFailure:
        Issue.record("Expected success but got test failure")
    }
  }

  @Test("ExerciseExecutor test failure")
  func testExecutionWithTestFailure() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 1,
        stdout: "Test 1: Passed\nTest 2: Failed",
        stderr: "Assertion failed"
      ),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: true
    )

    switch result {
      case .success:
        Issue.record("Expected test failure but got success")
      case .testFailure(let message):
        #expect(message == "Test 1: Passed\nTest 2: Failed\nAssertion failed")
    }
  }

  @Test("ExerciseExecutor failure without tests")
  func testExecutionFailureWithoutTests() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 1,
        stdout: "",
        stderr: "Segmentation fault"
      ),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: false
    )

    switch result {
      case .success:
        Issue.record("Expected failure but got success")
      case .testFailure(let message):
        #expect(message == "Segmentation fault")
    }
  }

  @Test("ExerciseExecutor failure without stderr")
  func testExecutionFailureWithoutStderr() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 42,
        stdout: "",
        stderr: ""
      ),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: false
    )

    switch result {
      case .success:
        Issue.record("Expected failure but got success")
      case .testFailure(let message):
        #expect(message == "Exercise failed with exit code 42")
    }
  }

  @Test("ExerciseExecutor with different executable paths")
  func testExecutionWithDifferentPaths() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let testPaths = [
      "/tmp/exercise",
      "/usr/local/bin/test",
      "/home/user/swiftlings/exercise",
      "/tmp/dir with spaces/exercise",
    ]

    for path in testPaths {
      mockRunner.reset()
      mockRunner.mockResults = [
        ProcessResult(exitCode: 0, stdout: "Success", stderr: ""),
      ]

      let url = URL(fileURLWithPath: path)
      _ = try executor.execute(executablePath: url, usesTests: false)

      let call = mockRunner.capturedCalls[0]
      #expect(call.executable == path)
      #expect(call.directory?.path == url.deletingLastPathComponent().path)
    }
  }

  @Test("ExerciseExecutor with empty stdout in test mode")
  func testExecutionWithEmptyStdoutTestMode() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 1,
        stdout: "",
        stderr: "Test assertion failed at line 10"
      ),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: true
    )

    switch result {
      case .success:
        Issue.record("Expected test failure")
      case .testFailure(let message):
        #expect(message == "\nTest assertion failed at line 10")
    }
  }

  @Test("ExerciseExecutor with combined output")
  func testExecutionWithCombinedOutput() throws {
    let mockRunner = MockProcessRunner()
    let executor = ExerciseExecutor(processRunner: mockRunner)

    let executablePath = URL(fileURLWithPath: "/tmp/test/exercise")


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 1,
        stdout: "Running tests...\nTest 1: OK",
        stderr: "Fatal error: Test 2 failed"
      ),
    ]

    let result = try executor.execute(
      executablePath: executablePath,
      usesTests: true
    )

    switch result {
      case .success:
        Issue.record("Expected test failure")
      case .testFailure(let message):
        #expect(message == "Running tests...\nTest 1: OK\nFatal error: Test 2 failed")
    }
  }
}
