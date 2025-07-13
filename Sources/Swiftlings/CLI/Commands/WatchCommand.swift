import ArgumentParser
import Foundation

struct WatchCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "watch",
    abstract: "Watch exercises and run them automatically when files change"
  )

  func run() throws {
    do {
      let manager = try ExerciseManager()

      Terminal.clear()
      print("Welcome to Swiftlings watch mode! 👀")
      print("")
      print(manager.welcomeMessage)
      print("")

      guard var currentExercise = manager.getCurrentExercise() else {
        Terminal.success("Congratulations! You've completed all exercises! 🎉")
        print("\n\(manager.finalMessage)")
        return
      }

      var watcher: FileWatcher?
      var isRunning = true
      var lastResult: ExerciseResult?
      let inputQueue = DispatchQueue(label: "input-queue")

      func runCurrentExercise() {
        Terminal.clear()
        Terminal.info("Watching: \(currentExercise.name)")
        print("File: \(currentExercise.filePath)")
        print("")

        let runner = ExerciseRunner(exercise: currentExercise)
        do {
          let result = try runner.run()
          lastResult = result

          switch result {
          case .success(let output):
            if !output.isEmpty {
              print("Output:")
              print(output)
            }


            Terminal.success("Exercise \(currentExercise.name) completed successfully!")
            print("")

            manager.markCompleted(currentExercise)

            if let nextExercise = manager.getNextPendingExercise() {
              Terminal.info("Great job! Next exercise: \(nextExercise.name)")
              print("Type 'n' and press Enter to move to the next exercise")
            } else {
              Terminal.success("All exercises completed! 🎉")
              print(manager.finalMessage)
              watcher?.stop()
              isRunning = false
              return
            }

          case .compilationError(let message):
            Terminal.error("Compilation failed:")
            print("")
            print(message)
            print("")

          case .testFailure(let message):
            Terminal.error("Tests failed:")
            print(message)
          }
        } catch {
          Terminal.error("Failed to run exercise: \(error)")
        }

        if isRunning {
          print("Commands (type and press Enter):")
          print("  h - hint")
          print("  l - list")
          print("  q - quit")
          print("  n - next exercise (if current is completed)")
          print("  r - run again")
          print("")
          print("> ", terminator: "")
          fflush(stdout)
        }
      }

      // Function to switch to next exercise
      func switchToNextExercise() {
        watcher?.stop()

        guard let nextExercise = manager.getNextPendingExercise() else {
          Terminal.success("All exercises completed! 🎉")
          print(manager.finalMessage)
          isRunning = false
          return
        }

        currentExercise = nextExercise
        manager.setCurrentExercise(nextExercise)

        let exercisePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
          .appendingPathComponent(currentExercise.filePath).path

        watcher = FileWatcher(path: exercisePath) {
          runCurrentExercise()
        }
        watcher?.start()

        runCurrentExercise()
      }

      runCurrentExercise()

      let exercisePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent(currentExercise.filePath).path
      watcher = FileWatcher(path: exercisePath) {
        runCurrentExercise()
      }
      watcher?.start()

      inputQueue.async {
        while isRunning {
          if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            !input.isEmpty
          {
            let char = input.first!
            DispatchQueue.main.async {
              switch char {
              case "h":
                Terminal.clear()
                Terminal.info("Hint for \(currentExercise.name):")
                print("")
                print(currentExercise.hint)
                print("")
                print("Press Enter to continue...")
                _ = readLine()
                runCurrentExercise()

              case "l":
                Terminal.clear()
                let stats = manager.getProgressStats()

                Terminal.info("Exercise Progress:")
                print("")
                Terminal.success(
                  "Completed: \(stats.completed)/\(stats.total) (\(Int(stats.percentage))%)")
                print("")
                print("Current exercise: \(currentExercise.name)")
                print("")
                print("Press Enter to continue...")
                _ = readLine()
                runCurrentExercise()

              case "n":
                if let result = lastResult, result.isSuccess {
                  Terminal.info("Moving to next exercise...")
                  switchToNextExercise()
                } else {
                  Terminal.warning("Complete the current exercise first!")
                  Thread.sleep(forTimeInterval: 2)
                  runCurrentExercise()
                }

              case "r":
                runCurrentExercise()

              case "q":
                Terminal.info("Exiting watch mode...")
                watcher?.stop()
                isRunning = false
                Foundation.exit(0)

              default:
                print("Unknown command: '\(input)'")
                print("> ", terminator: "")
                fflush(stdout)
              }
            }
          }
        }
      }

      while isRunning {
        RunLoop.main.run()
      }

    } catch {
      Terminal.error("Failed to start watch mode: \(error)")
      throw ExitCode.failure
    }
  }
}
