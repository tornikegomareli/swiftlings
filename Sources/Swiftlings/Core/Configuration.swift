import Foundation

/// Central configuration for Swiftlings
enum Configuration {
  /// Executable paths
  enum Executables {
    static let git = "/usr/bin/git"
    static let swiftc = "/usr/bin/swiftc"
  }

  /// File paths
  enum Paths {
    static let stateFileName = ".swiftlings-state.json"
    static let exerciseInfoFile = "Exercises/info.json"
    static let assertSourcePath = "Sources/Swiftlings/Core/Assert.swift"
  }

  /// UI Configuration
  enum UI {
    static let progressBarWidth = 120
    static let defaultTerminalWidth = 80
  }

  /// Exercise Configuration
  enum Exercise {
    static let tempDirectoryPrefix = "swiftlings"
    static let compiledExecutableName = "exercise"
    static let mainFileName = "main.swift"
  }
}
