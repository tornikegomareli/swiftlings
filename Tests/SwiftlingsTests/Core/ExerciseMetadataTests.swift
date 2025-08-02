import Testing
import Foundation
@testable import Swiftlings

@Suite("ExerciseMetadata Tests")
struct ExerciseMetadataTests {
  @Test("ExerciseMetadata initialization")
  func testExerciseMetadataInitialization() {
    let exercises = [
      Exercise(name: "intro1", dir: "00_basics", hint: "Intro hint", dependencies: nil),
      Exercise(name: "variables1", dir: "01_variables", hint: "Variables hint", dependencies: ["Foundation"]),
    ]

    let metadata = ExerciseMetadata(
      formatVersion: 1,
      welcomeMessage: "Welcome to Swiftlings!",
      finalMessage: "Congratulations!",
      exercises: exercises
    )

    #expect(metadata.formatVersion == 1)
    #expect(metadata.welcomeMessage == "Welcome to Swiftlings!")
    #expect(metadata.finalMessage == "Congratulations!")
    #expect(metadata.exercises.count == 2)
    #expect(metadata.exercises[0].name == "intro1")
    #expect(metadata.exercises[1].name == "variables1")
  }

  @Test("ExerciseMetadata Codable conformance")
  func testExerciseMetadataCodable() throws {
    let exercises = [
      Exercise(name: "test1", dir: "test", hint: "Hint 1", dependencies: nil),
      Exercise(name: "test2", dir: "test", hint: "Hint 2", dependencies: ["Foundation", "UIKit"]),
    ]

    let original = ExerciseMetadata(
      formatVersion: 2,
      welcomeMessage: "Welcome message with special chars: 🎯 \"quotes\"",
      finalMessage: "Final message with newline\nand more text",
      exercises: exercises
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(original)

    let decoder = JSONDecoder()
    let decoded = try decoder.decode(ExerciseMetadata.self, from: data)

    #expect(decoded.formatVersion == original.formatVersion)
    #expect(decoded.welcomeMessage == original.welcomeMessage)
    #expect(decoded.finalMessage == original.finalMessage)
    #expect(decoded.exercises.count == original.exercises.count)
    #expect(decoded.exercises == original.exercises)
  }

  @Test("ExerciseMetadata JSON key mapping")
  func testJSONKeyMapping() throws {
    let jsonString = """
      {
        "format_version": 3,
        "welcome_message": "Test welcome",
        "final_message": "Test final",
        "exercises": [
          {
            "name": "exercise1",
            "dir": "dir1",
            "hint": "hint1"
          }
        ]
      }
      """

    let data = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()
    let metadata = try decoder.decode(ExerciseMetadata.self, from: data)

    #expect(metadata.formatVersion == 3)
    #expect(metadata.welcomeMessage == "Test welcome")
    #expect(metadata.finalMessage == "Test final")
    #expect(metadata.exercises.count == 1)
  }

  @Test("Load ExerciseMetadata from file")
  func testLoadFromFile() throws {

    let tempDir = FileManager.default.temporaryDirectory
    let tempFile = tempDir.appendingPathComponent("test_info.json")

    let testMetadata = ExerciseMetadata(
      formatVersion: 1,
      welcomeMessage: "Welcome from file",
      finalMessage: "Final from file",
      exercises: [
        Exercise(name: "file_test", dir: "test_dir", hint: "File test hint", dependencies: nil),
      ]
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(testMetadata)
    try data.write(to: tempFile)

    defer {
      try? FileManager.default.removeItem(at: tempFile)
    }


    let loaded = try ExerciseMetadata.load(from: tempFile.path)

    #expect(loaded.formatVersion == 1)
    #expect(loaded.welcomeMessage == "Welcome from file")
    #expect(loaded.finalMessage == "Final from file")
    #expect(loaded.exercises.count == 1)
    #expect(loaded.exercises[0].name == "file_test")
  }

  @Test("Load ExerciseMetadata handles missing file")
  func testLoadFromMissingFile() {
    #expect(throws: Error.self) {
      _ = try ExerciseMetadata.load(from: "/nonexistent/path/info.json")
    }
  }

  @Test("ExerciseMetadata with empty exercises")
  func testEmptyExercises() throws {
    let metadata = ExerciseMetadata(
      formatVersion: 1,
      welcomeMessage: "Welcome",
      finalMessage: "Final",
      exercises: []
    )

    #expect(metadata.exercises.isEmpty)


    let encoder = JSONEncoder()
    let data = try encoder.encode(metadata)

    let decoder = JSONDecoder()
    let decoded = try decoder.decode(ExerciseMetadata.self, from: data)

    #expect(decoded.exercises.isEmpty)
  }

  @Test("ExerciseMetadata with malformed JSON")
  func testMalformedJSON() {
    let malformedJSON = """
      {
        "format_version": "not a number",
        "welcome_message": "Test",
        "final_message": "Test",
        "exercises": []
      }
      """

    let data = malformedJSON.data(using: .utf8)!
    let decoder = JSONDecoder()

    #expect(throws: Error.self) {
      _ = try decoder.decode(ExerciseMetadata.self, from: data)
    }
  }
}
