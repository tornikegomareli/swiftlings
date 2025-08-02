import Testing
import Foundation
@testable import Swiftlings

@Suite("Configuration Tests")
struct ConfigurationTests {
  @Test("Executable paths")
  func testExecutablePaths() {
    #expect(Configuration.Executables.git == "/usr/bin/git")
    #expect(Configuration.Executables.swiftc == "/usr/bin/swiftc")
  }

  @Test("File paths")
  func testFilePaths() {
    #expect(Configuration.Paths.stateFileName == ".swiftlings-state.json")
    #expect(Configuration.Paths.exerciseInfoFile == "Exercises/info.json")
    #expect(Configuration.Paths.assertSourcePath == "Sources/Swiftlings/Core/Assert.swift")
  }

  @Test("UI configuration")
  func testUIConfiguration() {
    #expect(Configuration.UI.progressBarWidth == 120)
    #expect(Configuration.UI.defaultTerminalWidth == 80)
  }

  @Test("Exercise configuration")
  func testExerciseConfiguration() {
    #expect(Configuration.Exercise.tempDirectoryPrefix == "swiftlings")
    #expect(Configuration.Exercise.compiledExecutableName == "exercise")
    #expect(Configuration.Exercise.mainFileName == "main.swift")
  }

  @Test("Configuration values are reasonable")
  func testConfigurationValuesAreReasonable() {

    #expect(Configuration.Executables.git.hasPrefix("/"))
    #expect(Configuration.Executables.swiftc.hasPrefix("/"))


    #expect(Configuration.UI.progressBarWidth > 0)
    #expect(Configuration.UI.defaultTerminalWidth > 0)


    #expect(!Configuration.Paths.stateFileName.isEmpty)
    #expect(!Configuration.Paths.exerciseInfoFile.isEmpty)
    #expect(!Configuration.Paths.assertSourcePath.isEmpty)


    #expect(!Configuration.Exercise.tempDirectoryPrefix.isEmpty)
    #expect(!Configuration.Exercise.compiledExecutableName.isEmpty)
    #expect(!Configuration.Exercise.mainFileName.isEmpty)


    #expect(Configuration.Paths.stateFileName.hasPrefix("."))


    #expect(Configuration.Exercise.mainFileName.hasSuffix(".swift"))
  }

  @Test("Path consistency")
  func testPathConsistency() {

    #expect(Configuration.Paths.assertSourcePath.hasSuffix("Assert.swift"))


    #expect(Configuration.Paths.exerciseInfoFile.hasPrefix("Exercises/"))


    #expect(Configuration.Paths.exerciseInfoFile.hasSuffix(".json"))
  }
}
