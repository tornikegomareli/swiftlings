import Testing
import Foundation
@testable import Swiftlings

@Suite("ProcessRunner Tests")
struct ProcessRunnerTests {
  @Test("ProcessResult properties")
  func testProcessResultProperties() {
    let successResult = ProcessResult(
      exitCode: 0,
      stdout: "Success output",
      stderr: ""
    )
    #expect(successResult.isSuccess == true)
    #expect(successResult.exitCode == 0)
    #expect(successResult.stdout == "Success output")
    #expect(successResult.stderr.isEmpty)

    let failureResult = ProcessResult(
      exitCode: 1,
      stdout: "",
      stderr: "Error occurred"
    )
    #expect(failureResult.isSuccess == false)
    #expect(failureResult.exitCode == 1)
    #expect(failureResult.stdout.isEmpty)
    #expect(failureResult.stderr == "Error occurred")
  }

  @Test("ProcessRunner executes echo command")
  func testProcessRunnerEcho() throws {
    let runner = ProcessRunner()
    let result = try runner.run(
      executable: "/bin/echo",
      arguments: ["Hello, World!"],
      currentDirectory: nil
    )

    #expect(result.isSuccess)
    #expect(result.exitCode == 0)
    #expect(result.stdout.trimmingCharacters(in: .whitespacesAndNewlines) == "Hello, World!")
    #expect(result.stderr.isEmpty)
  }

  @Test("ProcessRunner executes with working directory")
  func testProcessRunnerWithDirectory() throws {
    let runner = ProcessRunner()
    let tempDir = FileManager.default.temporaryDirectory

    let result = try runner.run(
      executable: "/bin/pwd",
      arguments: [],
      currentDirectory: tempDir
    )

    #expect(result.isSuccess)

    let outputPath = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
    let expectedPath = tempDir.path
    #expect(outputPath.hasSuffix(expectedPath.split(separator: "/").suffix(3).joined(separator: "/")) || outputPath == expectedPath)
  }

  @Test("ProcessRunner handles command failure")
  func testProcessRunnerFailure() throws {
    let runner = ProcessRunner()
    let result = try runner.run(
      executable: "/bin/ls",
      arguments: ["/nonexistent/directory/that/should/not/exist"],
      currentDirectory: nil
    )

    #expect(!result.isSuccess)
    #expect(result.exitCode != 0)
    #expect(!result.stderr.isEmpty)
  }

  @Test("ProcessRunner executes swift command")
  func testProcessRunnerSwift() throws {
    let runner = ProcessRunner()
    let result = try runner.run(
      executable: "/usr/bin/swift",
      arguments: ["--version"],
      currentDirectory: nil
    )

    #expect(result.isSuccess)
    #expect(result.stdout.contains("Swift") || result.stderr.contains("Swift"))
  }

  @Test("MockProcessRunner basic functionality")
  func testMockProcessRunner() throws {
    let mock = MockProcessRunner()


    mock.mockResults = [
      ProcessResult(exitCode: 0, stdout: "First result", stderr: ""),
      ProcessResult(exitCode: 1, stdout: "", stderr: "Second error"),
    ]


    let result1 = try mock.run(
      executable: "/bin/test",
      arguments: ["arg1", "arg2"],
      currentDirectory: nil
    )

    #expect(result1.exitCode == 0)
    #expect(result1.stdout == "First result")
    #expect(result1.stderr.isEmpty)


    let result2 = try mock.run(
      executable: "/bin/test2",
      arguments: ["arg3"],
      currentDirectory: URL(fileURLWithPath: "/tmp")
    )

    #expect(result2.exitCode == 1)
    #expect(result2.stdout.isEmpty)
    #expect(result2.stderr == "Second error")


    #expect(mock.capturedCalls.count == 2)
    #expect(mock.capturedCalls[0].executable == "/bin/test")
    #expect(mock.capturedCalls[0].arguments == ["arg1", "arg2"])
    #expect(mock.capturedCalls[0].directory == nil)
    #expect(mock.capturedCalls[1].executable == "/bin/test2")
    #expect(mock.capturedCalls[1].arguments == ["arg3"])
    #expect(mock.capturedCalls[1].directory?.path == "/tmp")
  }

  @Test("MockProcessRunner returns default when no mock results")
  func testMockProcessRunnerDefault() throws {
    let mock = MockProcessRunner()

    let result = try mock.run(
      executable: "/bin/test",
      arguments: [],
      currentDirectory: nil
    )

    #expect(result.exitCode == 0)
    #expect(result.stdout.isEmpty)
    #expect(result.stderr.isEmpty)
  }

  @Test("MockProcessRunner reset functionality")
  func testMockProcessRunnerReset() throws {
    let mock = MockProcessRunner()

    mock.mockResults = [ProcessResult(exitCode: 42, stdout: "Test", stderr: "")]

    _ = try mock.run(executable: "/bin/test", arguments: [], currentDirectory: nil)
    #expect(mock.capturedCalls.count == 1)

    mock.reset()

    #expect(mock.capturedCalls.isEmpty)


    let result = try mock.run(executable: "/bin/test", arguments: [], currentDirectory: nil)
    #expect(result.exitCode == 42)
  }

  @Test("ProcessRunner with multiple arguments")
  func testProcessRunnerMultipleArguments() throws {
    let runner = ProcessRunner()
    let result = try runner.run(
      executable: "/bin/echo",
      arguments: ["-n", "arg1", "arg2", "arg3"],
      currentDirectory: nil
    )

    #expect(result.isSuccess)
    #expect(result.stdout == "arg1 arg2 arg3")
  }
}
