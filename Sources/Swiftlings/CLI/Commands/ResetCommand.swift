import ArgumentParser
import Foundation

struct ResetCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "reset",
    abstract: "Reset an exercise to its original state"
  )

  @Argument(help: "The name of the exercise to reset")
  var exercise: String

  @Flag(help: "Reset without confirmation")
  var force = false

  func run() throws {
    if !force {
      print(
        "Are you sure you want to reset exercise '\(exercise)'? This will lose any changes you've made."
      )
      print("Use --force to skip this confirmation.")
      return
    }

    print("Resetting exercise: \(exercise)")
    print("This feature is not yet implemented.")
  }
}
