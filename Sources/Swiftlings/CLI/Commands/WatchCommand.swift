import ArgumentParser
import Foundation
import Rainbow

struct WatchCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "watch",
    abstract: "Watch exercises"
  )

  func run() throws {
    do {
      let manager = try ExerciseManager()
      let ui = SwiftlingsUI(manager: manager)

      if manager.getProgressStats().completed == 0 {
        Terminal.clear()
        print(manager.welcomeMessage)
        print("\nPress any key to start...")
        fflush(stdout)
        let tempRawInput = RawTerminalInput()
        tempRawInput.enableRawMode()
        _ = tempRawInput.readKey()
        tempRawInput.disableRawMode()
      }

      guard var currentExercise = manager.getCurrentExercise() else {
        Terminal.clear()
        Terminal.success("Congratulations! You've completed all Swiftlings exercises!")
        print("\n\(manager.finalMessage)")
        return
      }

      var watcher: FileWatcher?
      var isRunning = true
      var lastResult: ExerciseResult?
      let inputQueue = DispatchQueue(label: "input-queue")
      let rawInput = RawTerminalInput()

      func runCurrentExercise(clearFirst: Bool = true) {
        if clearFirst {
          Terminal.clear()
        }

        let runner = ExerciseRunner(exercise: currentExercise)
        do {
          let startedAt = Date()
          let result = try runner.run()
          let elapsed = Date().timeIntervalSince(startedAt)
          lastResult = result

          switch result {
            case .success:
              manager.markCompleted(currentExercise)

              ui.renderWatchMode(currentExercise: currentExercise, result: result, showError: false, duration: elapsed)

              if manager.getNextPendingExercise() == nil {
                print("\n")
                Terminal.success("All exercises completed!")
                print(manager.finalMessage)
                watcher?.stop()
                isRunning = false
                return
              }

            case .compilationError, .testFailure:
              ui.renderWatchMode(currentExercise: currentExercise, result: result, showError: true, duration: elapsed)
          }
        } catch {
          Terminal.error("Failed to run exercise: \(error)")
        }
      }

      func switchToNextExercise() {
        watcher?.stop()

        guard let nextExercise = manager.getNextPendingExercise() else {
          Terminal.success("All exercises completed!")
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

      rawInput.enableRawMode()

      inputQueue.async {
        while isRunning {
          if let char = rawInput.readKey() {
            let input = String(char).lowercased()
            DispatchQueue.main.async {
              switch input {
                case "h":
                  Terminal.clear()
                  print(Box.panel(
                    label: "hint · \(currentExercise.name)",
                    contentLines: [Box.line(currentExercise.hint.lightWhite)]
                  ))
                  print("")
                  print("press any key to continue".lightBlack)
                  fflush(stdout)
                  _ = rawInput.readKey()
                  runCurrentExercise()

                case "l":
                  Terminal.clear()
                  let stats = manager.getProgressStats()

                  print("exercises".cyan.bold + "  " + Box.progressBar(completed: stats.completed, total: stats.total))
                  print("")

                  // Show exercises grouped by directory
                  let exercisesByDir = Dictionary(grouping: manager.getAllExercises()) { $0.dir }
                  for (dir, exercises) in exercisesByDir.sorted(by: { $0.key < $1.key }) {
                    print(dir.lightBlack.bold)
                    for exercise in exercises {
                      let status = manager.isCompleted(exercise.name) ? "✓".green : "○".lightBlack
                      let current = exercise.name == currentExercise.name ? " ← current".cyan : ""
                      print("  \(status) \(exercise.name)\(current)")
                    }
                    print("")
                  }

                  print("press any key to continue".lightBlack)
                  fflush(stdout)
                  _ = rawInput.readKey()
                  runCurrentExercise()

                case "n":
                  if let result = lastResult, result.isSuccess {
                    Terminal.info("Moving to next exercise...")
                    switchToNextExercise()
                  } else {
                    Terminal.warning("Complete the current exercise first")
                    Thread.sleep(forTimeInterval: 1.5)
                    runCurrentExercise()
                  }

                case "c":
                  Terminal.clear()
                  Terminal.progress("Checking all exercises...")
                  print("")

                  var failed = 0
                  for exercise in manager.getPendingExercises() {
                    let runner = ExerciseRunner(exercise: exercise)
                    do {
                      let result = try runner.run()
                      switch result {
                        case .success:
                          print("✓ \(exercise.name)".green)
                          manager.markCompleted(exercise)
                        case .compilationError:
                          print("✗ \(exercise.name) - compilation error".red)
                          failed += 1
                        case .testFailure:
                          print("✗ \(exercise.name) - test failure".red)
                          failed += 1
                      }
                    } catch {
                      print("✗ \(exercise.name) - error: \(error)".red)
                      failed += 1
                    }
                  }

                  print("")
                  print("Summary: \(failed) exercises need work")
                  print("press any key to continue".lightBlack)
                  fflush(stdout)
                  _ = rawInput.readKey()

                  if let newCurrent = manager.getCurrentExercise() {
                    currentExercise = newCurrent
                  }
                  runCurrentExercise()

                case "x":
                  /// Check if we're in DSA mode
                  if manager.categoryFilter != nil {
                    print("Reset all DSA exercises? (y/n): ".yellow.bold, terminator: "")
                    fflush(stdout)
                    if let confirm = rawInput.readKey()?.lowercased(), confirm == "y" {
                      Terminal.info("Resetting all DSA exercises...")
                      manager.resetDSAProgress()
                      Terminal.success("All DSA exercises reset!")
                      Thread.sleep(forTimeInterval: 1)
                      /// Reset to first exercise
                      if let firstExercise = manager.getAllExercises().first {
                        currentExercise = firstExercise
                        runCurrentExercise()
                      }
                    } else {
                      runCurrentExercise()
                    }
                  } else {
                    Terminal.info("Resetting \(currentExercise.name)...")
                    do {
                      try manager.resetExercise(currentExercise)
                      Terminal.success("Exercise reset!")
                      Thread.sleep(forTimeInterval: 1)
                      runCurrentExercise()
                    } catch {
                      Terminal.error("Failed to reset: \(error)")
                      Thread.sleep(forTimeInterval: 2)
                      runCurrentExercise()
                    }
                  }

                case "q":
                  watcher?.stop()
                  isRunning = false
                  rawInput.disableRawMode()
                  Foundation.exit(0)

                default:
                  break
              }
            }
          }
          Thread.sleep(forTimeInterval: 0.01)
        }
      }

      while isRunning {
        RunLoop.main.run()
      }

      rawInput.disableRawMode()

    } catch {
      Terminal.error("Failed to start watch mode: \(error)")
      throw ExitCode.failure
    }
  }
}
