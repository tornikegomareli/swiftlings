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
            
            // Get current exercise
            guard let currentExercise = manager.getCurrentExercise() else {
                Terminal.success("Congratulations! You've completed all exercises! 🎉")
                print("\n\(manager.finalMessage)")
                return
            }
            
            // Create file watcher for the current exercise
            var watcher: FileWatcher?
            let exercisePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent(currentExercise.filePath).path
            
            // Function to run the current exercise
            func runCurrentExercise() {
                Terminal.clear()
                Terminal.info("Watching: \(currentExercise.name)")
                print("File: \(currentExercise.filePath)")
                print("")
                
                let runner = ExerciseRunner(exercise: currentExercise)
                do {
                    let result = try runner.run()
                    
                    switch result {
                    case .success(let output):
                        if !output.isEmpty {
                            print("Output:")
                            print(output)
                        }
                        Terminal.success("Exercise \(currentExercise.name) completed successfully!")
                        print("")
                        print("When you are ready, remove the 'I AM NOT DONE' comment and save.")
                        print("")
                        
                        // Check if truly done
                        if runner.checkIfDone() {
                            manager.markCompleted(currentExercise)
                            
                            if let nextExercise = manager.getNextPendingExercise() {
                                Terminal.info("Great job! Moving to the next exercise: \(nextExercise.name)")
                                // Would need to restart watch with new exercise
                            } else {
                                Terminal.success("All exercises completed! 🎉")
                                print(manager.finalMessage)
                                watcher?.stop()
                                return
                            }
                        }
                        
                    case .compilationError(let message):
                        Terminal.error("Compilation failed:")
                        print("")
                        print(message)
                        print("")
                        
                    case .testFailure(let message):
                        Terminal.error("Tests failed:")
                        print(message)
                        
                    case .notDone:
                        Terminal.warning("Remove the 'I AM NOT DONE' comment when you're ready!")
                    }
                } catch {
                    Terminal.error("Failed to run exercise: \(error)")
                }
                
                print("")
                Terminal.info("I'll keep watching for changes...")
                print("")
                print("Commands:")
                print("  h - hint")
                print("  l - list")
                print("  q - quit")
                print("  n - next exercise (if current is completed)")
                print("  r - run again")
            }
            
            // Initial run
            runCurrentExercise()
            
            // Start watching for changes
            watcher = FileWatcher(path: exercisePath) {
                runCurrentExercise()
            }
            watcher?.start()
            
            // Keep the command running
            print("\nPress Ctrl+C to exit watch mode")
            RunLoop.main.run()
            
        } catch {
            Terminal.error("Failed to start watch mode: \(error)")
            throw ExitCode.failure
        }
    }
}