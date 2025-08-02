import Testing
import Foundation
@testable import Swiftlings

@Suite("ExerciseResetter Tests")
struct ExerciseResetterTests {
  @Test("ResetError descriptions")
  func testResetErrorDescriptions() {
    let gitError = ResetError.gitResetFailed("fatal: pathspec 'file.swift' did not match any files")
    #expect(gitError.errorDescription == "Failed to reset exercise: fatal: pathspec 'file.swift' did not match any files")

    let multipleErrors = ResetError.multipleErrors([
      "Failed to reset intro1: File not found",
      "Failed to reset variables1: Permission denied",
    ])
    #expect(multipleErrors.errorDescription == "Multiple reset errors:\nFailed to reset intro1: File not found\nFailed to reset variables1: Permission denied")
  }

  @Test("ExerciseResetter successful reset")
  func testSuccessfulReset() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let exercise = Exercise(
      name: "test_exercise",
      dir: "test_dir",
      hint: "Test hint",
      dependencies: nil
    )


    mockRunner.mockResults = [
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
    ]

    try resetter.resetExercise(exercise)


    #expect(mockRunner.capturedCalls.count == 1)
    let call = mockRunner.capturedCalls[0]
    #expect(call.executable == "/usr/bin/git")
    #expect(call.arguments == ["checkout", "HEAD", "--", "Exercises/test_dir/test_exercise.swift"])
    #expect(call.directory == nil)
  }

  @Test("ExerciseResetter git reset failure")
  func testGitResetFailure() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let exercise = Exercise(
      name: "failing_exercise",
      dir: "test_dir",
      hint: "Test hint",
      dependencies: nil
    )


    mockRunner.mockResults = [
      ProcessResult(
        exitCode: 1,
        stdout: "",
        stderr: "error: pathspec 'Exercises/test_dir/failing_exercise.swift' did not match any file(s) known to git"
      ),
    ]

    #expect(throws: (any Error).self) {
      try resetter.resetExercise(exercise)
    }
  }

  @Test("ExerciseResetter reset multiple exercises successfully")
  func testResetMultipleExercisesSuccess() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let exercises = [
      Exercise(name: "ex1", dir: "dir1", hint: "hint1", dependencies: nil),
      Exercise(name: "ex2", dir: "dir2", hint: "hint2", dependencies: nil),
      Exercise(name: "ex3", dir: "dir3", hint: "hint3", dependencies: nil),
    ]


    mockRunner.mockResults = [
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
    ]

    try resetter.resetExercises(exercises)


    #expect(mockRunner.capturedCalls.count == 3)
    #expect(mockRunner.capturedCalls[0].arguments.contains("Exercises/dir1/ex1.swift"))
    #expect(mockRunner.capturedCalls[1].arguments.contains("Exercises/dir2/ex2.swift"))
    #expect(mockRunner.capturedCalls[2].arguments.contains("Exercises/dir3/ex3.swift"))
  }

  @Test("ExerciseResetter reset multiple exercises with failures")
  func testResetMultipleExercisesWithFailures() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let exercises = [
      Exercise(name: "ex1", dir: "dir1", hint: "hint1", dependencies: nil),
      Exercise(name: "ex2", dir: "dir2", hint: "hint2", dependencies: nil),
      Exercise(name: "ex3", dir: "dir3", hint: "hint3", dependencies: nil),
    ]


    mockRunner.mockResults = [
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
      ProcessResult(exitCode: 1, stdout: "", stderr: "Permission denied"),
      ProcessResult(exitCode: 0, stdout: "", stderr: ""),
    ]

    #expect(throws: (any Error).self) {
      try resetter.resetExercises(exercises)
    }


    #expect(mockRunner.capturedCalls.count == 3)
  }

  @Test("ExerciseResetter reset empty list")
  func testResetEmptyList() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)


    try resetter.resetExercises([])


    #expect(mockRunner.capturedCalls.isEmpty)
  }

  @Test("ExerciseResetter with different exercise paths")
  func testResetWithDifferentPaths() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let testCases = [
      (name: "simple", dir: "basics", expected: "Exercises/basics/simple.swift"),
      (name: "complex_name", dir: "advanced/nested", expected: "Exercises/advanced/nested/complex_name.swift"),
      (name: "test-123", dir: "00_intro", expected: "Exercises/00_intro/test-123.swift"),
    ]

    for testCase in testCases {
      mockRunner.reset()
      mockRunner.mockResults = [
        ProcessResult(exitCode: 0, stdout: "", stderr: ""),
      ]

      let exercise = Exercise(
        name: testCase.name,
        dir: testCase.dir,
        hint: "hint",
        dependencies: nil
      )

      try resetter.resetExercise(exercise)

      let call = mockRunner.capturedCalls[0]
      #expect(call.arguments.last == testCase.expected)
    }
  }

  @Test("ExerciseResetter multiple errors formatting")
  func testMultipleErrorsFormatting() throws {
    let mockRunner = MockProcessRunner()
    let resetter = ExerciseResetter(processRunner: mockRunner)

    let exercises = [
      Exercise(name: "ex1", dir: "dir1", hint: "hint1", dependencies: nil),
      Exercise(name: "ex2", dir: "dir2", hint: "hint2", dependencies: nil),
      Exercise(name: "ex3", dir: "dir3", hint: "hint3", dependencies: nil),
    ]


    mockRunner.mockResults = [
      ProcessResult(exitCode: 1, stdout: "", stderr: "Error 1"),
      ProcessResult(exitCode: 1, stdout: "", stderr: "Error 2"),
      ProcessResult(exitCode: 1, stdout: "", stderr: "Error 3"),
    ]

    #expect(throws: (any Error).self) {
      try resetter.resetExercises(exercises)
    }
  }
}
