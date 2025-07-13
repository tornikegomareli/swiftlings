import ArgumentParser
import Foundation

struct ListCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "list",
    abstract: "List all exercises and their status"
  )

  @Flag(help: "Show only pending exercises")
  var pending = false

  @Flag(help: "Show only completed exercises")
  var completed = false

  func run() throws {
    do {
      let manager = try ExerciseManager()

      let exercises: [Exercise]
      if pending {
        exercises = manager.getExercises(completed: false)
      } else if completed {
        exercises = manager.getExercises(completed: true)
      } else {
        exercises = manager.allExercises
      }

      if exercises.isEmpty {
        Terminal.info("No exercises found matching your criteria.")
        return
      }

      let stats = manager.getProgressStats()

      print("\n")
      Terminal.info(
        "Progress: \(stats.completed)/\(stats.total) (\(String(format: "%.1f", stats.percentage))%)"
      )
      print("\n")

      for exercise in exercises {
        let status = manager.getExerciseStatus(exercise)
        let name = exercise.name.padding(toLength: 20, withPad: " ", startingAt: 0)
        let dir = exercise.dir.padding(toLength: 15, withPad: " ", startingAt: 0)

        print("\(status) \(name) \(dir) \(exercise.test ? "test" : "compile")")
      }

      print("\n")

      if pending {
        Terminal.info("Showing only pending exercises")
      } else if completed {
        Terminal.info("Showing only completed exercises")
      }

      Terminal.info("Run 'swiftlings run <exercise-name>' to run a specific exercise")
    } catch {
      Terminal.error("Failed to load exercises: \(error)")
      throw ExitCode.failure
    }
  }
}
