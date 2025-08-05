import ArgumentParser
import Foundation

struct InitCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "init",
    abstract: "Initialize a new Swiftlings project with exercises"
  )
  
  @Option(name: .shortAndLong, help: "The name of the directory to create")
  var projectName: String = "swiftlings"
  
  @Flag(name: .long, help: "Force overwrite if directory already exists")
  var force: Bool = false
  
  mutating func run() throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let projectPath = "\(currentPath)/\(projectName)"
    
    /// Check if directory already exists
    if fileManager.fileExists(atPath: projectPath) && !force {
      print("❌ Directory '\(projectName)' already exists!")
      print("💡 Use --force to overwrite or choose a different name with --project-name")
      throw ExitCode.failure
    }
    
    print("🚀 Initializing Swiftlings project...")
    
    /// Remove existing directory if force flag is set
    if force && fileManager.fileExists(atPath: projectPath) {
      try fileManager.removeItem(atPath: projectPath)
    }
    
    /// Clone the exercises repository
    let cloneResult = Process.execute(
      "/usr/bin/git",
      arguments: [
        "clone",
        "--depth", "1",
        "--branch", "main",
        "https://github.com/tornikegomareli/swiftlings.git",
        projectName
      ]
    )
    
    guard cloneResult.exitCode == 0 else {
      print("❌ Failed to clone exercises repository")
      print("Error: \(cloneResult.stderr)")
      throw ExitCode.failure
    }
    
    /// Remove .git directory to disconnect from the original repo
    let gitPath = "\(projectPath)/.git"
    if fileManager.fileExists(atPath: gitPath) {
      try fileManager.removeItem(atPath: gitPath)
    }
    
    print("✅ Successfully initialized Swiftlings project in '\(projectName)'!")
    print("")
    print("To get started:")
    print("  cd \(projectName)")
    print("  swiftlings")
    print("")
    print("Or run a specific exercise:")
    print("  swiftlings run <exercise-name>")
    print("")
    print("For help:")
    print("  swiftlings --help")
  }
}

/// Helper extension for Process
extension Process {
  static func execute(
    _ executablePath: String,
    arguments: [String] = [],
    currentDirectoryPath: String? = nil
  ) -> (exitCode: Int32, stdout: String, stderr: String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executablePath)
    process.arguments = arguments
    
    if let currentPath = currentDirectoryPath {
      process.currentDirectoryURL = URL(fileURLWithPath: currentPath)
    }
    
    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    process.standardOutput = stdoutPipe
    process.standardError = stderrPipe
    
    do {
      try process.run()
      process.waitUntilExit()
      
      let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
      let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
      
      let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
      let stderr = String(data: stderrData, encoding: .utf8) ?? ""
      
      return (process.terminationStatus, stdout, stderr)
    } catch {
      return (-1, "", error.localizedDescription)
    }
  }
}