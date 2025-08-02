import Testing
import Foundation
@testable import Swiftlings

@Suite("ExerciseRunner Simplified Tests")
struct ExerciseRunnerSimplifiedTests {
  @Test("CompilationError description")
  func testCompilationError() {
    let error = CompilationError(message: "Failed to compile")
    #expect(error.message == "Failed to compile")
  }

  @Test("ExerciseResult properties")
  func testExerciseResultProperties() {
    let success = ExerciseResult.success(output: "Test passed")
    #expect(success.isSuccess == true)

    let compilationError = ExerciseResult.compilationError(message: "Syntax error")
    #expect(compilationError.isSuccess == false)

    let testFailure = ExerciseResult.testFailure(message: "Assertion failed")
    #expect(testFailure.isSuccess == false)
  }

  @Test("ExerciseResult switch patterns")
  func testExerciseResultPatterns() {
    let results: [ExerciseResult] = [
      .success(output: "Output"),
      .compilationError(message: "Error"),
      .testFailure(message: "Failure"),
    ]

    for result in results {
      switch result {
        case .success(let output):
          #expect(result.isSuccess)
          #expect(!output.isEmpty)
        case .compilationError(let message):
          #expect(!result.isSuccess)
          #expect(!message.isEmpty)
        case .testFailure(let message):
          #expect(!result.isSuccess)
          #expect(!message.isEmpty)
      }
    }
  }
}
