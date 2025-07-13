import ArgumentParser
import Foundation

/// Enhanced watch command with Rustlings-style UI
struct WatchCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "watch",
        abstract: "Watch exercises with enhanced Rustlings-style UI"
    )
    
    func run() throws {
        do {
            let manager = try ExerciseManager()
            let ui = SwiftlingsUI(manager: manager)
            
            // Show welcome message only on first run
            if manager.getProgressStats().completed == 0 {
                Terminal.clear()
                print(manager.welcomeMessage)
                print("\nPress Enter to start...")
                _ = readLine()
            }
            
            guard var currentExercise = manager.getCurrentExercise() else {
                Terminal.clear()
                Terminal.success("🎉 Congratulations! You've completed all Swiftlings exercises!")
                print("\n\(manager.finalMessage)")
                return
            }
            
            var watcher: FileWatcher?
            var isRunning = true
            var lastResult: ExerciseResult?
            let inputQueue = DispatchQueue(label: "input-queue")
            
            func runCurrentExercise(clearFirst: Bool = true) {
                if clearFirst {
                    Terminal.clear()
                }
                
                let runner = ExerciseRunner(exercise: currentExercise)
                do {
                    let result = try runner.run()
                    lastResult = result
                    
                    switch result {
                    case .success:
                        manager.markCompleted(currentExercise)
                        
                        // Render success UI
                        ui.renderWatchMode(currentExercise: currentExercise, result: result, showError: false)
                        
                        if manager.getNextPendingExercise() == nil {
                            print("\n")
                            Terminal.success("🎉 All exercises completed!")
                            print(manager.finalMessage)
                            watcher?.stop()
                            isRunning = false
                            return
                        }
                        
                    case .compilationError, .testFailure:
                        // Render error UI
                        ui.renderWatchMode(currentExercise: currentExercise, result: result, showError: true)
                    }
                } catch {
                    Terminal.error("Failed to run exercise: \(error)")
                }
                
                if isRunning {
                    print("\n> ", terminator: "")
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
            
            // Initial run
            runCurrentExercise()
            
            // Set up file watcher
            let exercisePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent(currentExercise.filePath).path
            watcher = FileWatcher(path: exercisePath) {
                runCurrentExercise()
            }
            watcher?.start()
            
            // Handle keyboard input
            inputQueue.async {
                while isRunning {
                    if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                       !input.isEmpty {
                        let char = input.first!
                        DispatchQueue.main.async {
                            switch char {
                            case "h":
                                Terminal.clear()
                                Terminal.info("💡 Hint for \(currentExercise.name):")
                                print("\n\(currentExercise.hint)\n")
                                print("Press Enter to continue...")
                                _ = readLine()
                                runCurrentExercise()
                                
                            case "l":
                                Terminal.clear()
                                let stats = manager.getProgressStats()
                                let progressBar = ProgressBar(completed: stats.completed, total: stats.total, width: 80)
                                
                                Terminal.info("📊 Exercise List")
                                print("\n\(progressBar.formattedProgress())\n")
                                
                                // Show exercises grouped by directory
                                let exercisesByDir = Dictionary(grouping: manager.getAllExercises()) { $0.dir }
                                for (dir, exercises) in exercisesByDir.sorted(by: { $0.key < $1.key }) {
                                    print("\n[\(dir)]")
                                    for exercise in exercises {
                                        let status = manager.isCompleted(exercise.name) ? "✓" : "○"
                                        let current = exercise.name == currentExercise.name ? " ← current" : ""
                                        print("  \(status) \(exercise.name)\(current)")
                                    }
                                }
                                
                                print("\nPress Enter to continue...")
                                _ = readLine()
                                runCurrentExercise()
                                
                            case "n":
                                if let result = lastResult, result.isSuccess {
                                    Terminal.info("Moving to next exercise...")
                                    switchToNextExercise()
                                } else {
                                    Terminal.warning("⚠️  Complete the current exercise first!")
                                    Thread.sleep(forTimeInterval: 1.5)
                                    runCurrentExercise()
                                }
                                
                            case "c":
                                Terminal.clear()
                                Terminal.info("🔍 Checking all exercises...")
                                print("")
                                
                                var failed = 0
                                for exercise in manager.getPendingExercises() {
                                    let runner = ExerciseRunner(exercise: exercise)
                                    do {
                                        let result = try runner.run()
                                        switch result {
                                        case .success:
                                            print("✅ \(exercise.name)")
                                            manager.markCompleted(exercise)
                                        case .compilationError:
                                            print("❌ \(exercise.name) - compilation error")
                                            failed += 1
                                        case .testFailure:
                                            print("❌ \(exercise.name) - test failure")
                                            failed += 1
                                        }
                                    } catch {
                                        print("❌ \(exercise.name) - error: \(error)")
                                        failed += 1
                                    }
                                }
                                
                                print("\nSummary: \(failed) exercises need work")
                                print("Press Enter to continue...")
                                _ = readLine()
                                
                                // Update current exercise if needed
                                if let newCurrent = manager.getCurrentExercise() {
                                    currentExercise = newCurrent
                                }
                                runCurrentExercise()
                                
                            case "x":
                                Terminal.info("🔄 Resetting \(currentExercise.name)...")
                                let resetter = ExerciseResetter()
                                do {
                                    try resetter.resetExercise(currentExercise)
                                    Terminal.success("Exercise reset!")
                                    Thread.sleep(forTimeInterval: 1)
                                    runCurrentExercise()
                                } catch {
                                    Terminal.error("Failed to reset: \(error)")
                                    Thread.sleep(forTimeInterval: 2)
                                    runCurrentExercise()
                                }
                                
                            case "q":
                                Terminal.info("👋 Exiting watch mode...")
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
            
            // Keep the main thread alive
            while isRunning {
                RunLoop.main.run()
            }
            
        } catch {
            Terminal.error("Failed to start watch mode: \(error)")
            throw ExitCode.failure
        }
    }
}