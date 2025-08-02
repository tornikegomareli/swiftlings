import Testing
import Foundation
@testable import Swiftlings

@Suite("ProgressTracker Tests")
struct ProgressTrackerTests {

  func withTemporaryDirectory(_ test: (URL) throws -> Void) throws {
    let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

    let originalDir = FileManager.default.currentDirectoryPath
    FileManager.default.changeCurrentDirectoryPath(tempDir.path)

    defer {
      FileManager.default.changeCurrentDirectoryPath(originalDir)
      try? FileManager.default.removeItem(at: tempDir)
    }

    try test(tempDir)
  }

  @Test("ProgressTracker initialization with no existing state")
  func testInitializationWithNoState() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()

      #expect(tracker.getCurrentExercise() == nil)
      #expect(!tracker.isCompleted("any_exercise"))

      let stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 0)
      #expect(stats.percentage == 0.0)
    }
  }

  @Test("Mark exercise as completed")
  func testMarkCompleted() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()

      #expect(!tracker.isCompleted("variables1"))

      tracker.markCompleted("variables1")

      #expect(tracker.isCompleted("variables1"))
      #expect(!tracker.isCompleted("variables2"))
    }
  }

  @Test("Set and get current exercise")
  func testCurrentExercise() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()

      #expect(tracker.getCurrentExercise() == nil)

      tracker.setCurrentExercise("functions1")
      #expect(tracker.getCurrentExercise() == "functions1")

      tracker.setCurrentExercise("functions2")
      #expect(tracker.getCurrentExercise() == "functions2")
    }
  }

  @Test("Progress statistics calculation")
  func testProgressStatistics() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()


      var stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 0)
      #expect(stats.percentage == 0.0)


      tracker.markCompleted("ex1")
      tracker.markCompleted("ex2")
      tracker.markCompleted("ex3")

      stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 3)
      #expect(stats.percentage == 30.0)


      for i in 4 ... 10 {
        tracker.markCompleted("ex\(i)")
      }

      stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 10)
      #expect(stats.percentage == 100.0)


      stats = tracker.getStats(totalExercises: 0)
      #expect(stats.completed == 10)
      #expect(stats.percentage == 0.0)
    }
  }

  @Test("Reset progress")
  func testResetProgress() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()


      tracker.markCompleted("ex1")
      tracker.markCompleted("ex2")
      tracker.setCurrentExercise("ex3")

      #expect(tracker.isCompleted("ex1"))
      #expect(tracker.isCompleted("ex2"))
      #expect(tracker.getCurrentExercise() == "ex3")


      tracker.resetProgress()

      #expect(!tracker.isCompleted("ex1"))
      #expect(!tracker.isCompleted("ex2"))
      #expect(tracker.getCurrentExercise() == nil)

      let stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 0)
      #expect(stats.percentage == 0.0)
    }
  }

  @Test("State persistence across instances")
  func testStatePersistence() throws {
    try withTemporaryDirectory { tempDir in

      let stateFile = tempDir.appendingPathComponent(".swiftlings-state.json")


      var state1 = ProgressTracker.ProgressState()
      state1.completedExercises.insert("persistent1")
      state1.completedExercises.insert("persistent2")
      state1.currentExercise = "persistent3"

      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      let data = try encoder.encode(state1)
      try data.write(to: stateFile)





      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let loadedState = try decoder.decode(ProgressTracker.ProgressState.self, from: data)

      #expect(loadedState.completedExercises.contains("persistent1"))
      #expect(loadedState.completedExercises.contains("persistent2"))
      #expect(loadedState.currentExercise == "persistent3")
    }
  }

  @Test("Multiple exercises marked as completed")
  func testMultipleCompletions() throws {
    try withTemporaryDirectory { _ in
      let tracker = ProgressTracker()
      let exercises = ["intro1", "variables1", "functions1", "arrays1", "structs1"]

      for exercise in exercises {
        #expect(!tracker.isCompleted(exercise))
        tracker.markCompleted(exercise)
        #expect(tracker.isCompleted(exercise))
      }

      let stats = tracker.getStats(totalExercises: 10)
      #expect(stats.completed == 5)
      #expect(stats.percentage == 50.0)


      tracker.markCompleted("intro1")
      tracker.markCompleted("intro1")

      let statsAfter = tracker.getStats(totalExercises: 10)
      #expect(statsAfter.completed == 5)
    }
  }

  @Test("State file JSON format")
  func testStateFileFormat() throws {


    var state = ProgressTracker.ProgressState()
    state.completedExercises.insert("test1")
    state.currentExercise = "test2"
    state.lastUpdated = Date()

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(state)

    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    #expect(json != nil)
    #expect(json?["currentExercise"] as? String == "test2")
    #expect((json?["completedExercises"] as? [String])?.contains("test1") == true)
    #expect(json?["lastUpdated"] != nil)
  }
}
