import Testing
import Foundation
@testable import Swiftlings

@Suite("Exercise Tests")
struct ExerciseTests {
  @Test("Exercise initialization and properties")
  func testExerciseInitialization() {
    let exercise = Exercise(
      name: "variables1",
      dir: "01_variables",
      hint: "This is a hint",
      dependencies: ["Foundation"]
    )

    #expect(exercise.name == "variables1")
    #expect(exercise.dir == "01_variables")
    #expect(exercise.hint == "This is a hint")
    #expect(exercise.dependencies == ["Foundation"])
    #expect(exercise.filePath == "Exercises/01_variables/variables1.swift")
  }

  @Test("Exercise without dependencies")
  func testExerciseWithoutDependencies() {
    let exercise = Exercise(
      name: "intro1",
      dir: "00_basics",
      hint: "Simple intro",
      dependencies: nil
    )

    #expect(exercise.dependencies == nil)
  }

  @Test("Exercise file path construction")
  func testFilePathConstruction() {
    let testCases = [
      (name: "test1", dir: "00_basics", expected: "Exercises/00_basics/test1.swift"),
      (name: "functions1", dir: "02_functions", expected: "Exercises/02_functions/functions1.swift"),
      (name: "complex_name", dir: "deep/nested/dir", expected: "Exercises/deep/nested/dir/complex_name.swift"),
    ]

    for testCase in testCases {
      let exercise = Exercise(
        name: testCase.name,
        dir: testCase.dir,
        hint: "",
        dependencies: nil
      )
      #expect(exercise.filePath == testCase.expected)
    }
  }

  @Test("Exercise equality")
  func testExerciseEquality() {
    let exercise1 = Exercise(
      name: "test",
      dir: "dir",
      hint: "hint",
      dependencies: ["A", "B"]
    )

    let exercise2 = Exercise(
      name: "test",
      dir: "dir",
      hint: "hint",
      dependencies: ["A", "B"]
    )

    let exercise3 = Exercise(
      name: "different",
      dir: "dir",
      hint: "hint",
      dependencies: ["A", "B"]
    )

    #expect(exercise1 == exercise2)
    #expect(exercise1 != exercise3)
  }

  @Test("Exercise Codable conformance")
  func testExerciseCodable() throws {
    let original = Exercise(
      name: "codable_test",
      dir: "test_dir",
      hint: "Test hint with special chars: 🎯 \"quotes\" and 'apostrophes'",
      dependencies: ["Foundation", "UIKit"]
    )

    let encoder = JSONEncoder()
    let data = try encoder.encode(original)

    let decoder = JSONDecoder()
    let decoded = try decoder.decode(Exercise.self, from: data)

    #expect(decoded == original)
    #expect(decoded.name == original.name)
    #expect(decoded.dir == original.dir)
    #expect(decoded.hint == original.hint)
    #expect(decoded.dependencies == original.dependencies)
  }
}
