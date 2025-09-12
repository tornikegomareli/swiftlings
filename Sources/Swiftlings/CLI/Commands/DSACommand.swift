import ArgumentParser
import Foundation

struct DSACommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "dsa",
    abstract: "Start Data Structures & Algorithms learning mode"
  )
  
  func run() throws {
    let manager = try ExerciseManager()
    
    Terminal.clear()
    print("Welcome to Swiftlings DSA Mode! 🎯")
    print("=====================================")
    print("\nMaster Data Structures & Algorithms through hands-on implementation.\n")
    
    /// Get DSA exercises grouped by category
    let dsaCategories = [
      ("Queue", "20_dsa_queue", "FIFO data structure - First In, First Out")
      // Future: ("Stack", "21_dsa_stack", "LIFO data structure - Last In, First Out"),
      // Future: ("Linked List", "22_dsa_linkedlist", "Linear data structure with nodes"),
      // Future: ("Binary Tree", "23_dsa_tree", "Hierarchical data structure"),
      // Future: ("Graph", "24_dsa_graph", "Network data structure")
    ]
    
    print("Available Data Structures:")
    print("")
    
    for (index, (name, dir, description)) in dsaCategories.enumerated() {
      let exercises = manager.allExercises.filter { $0.dir == dir }
      let completed = exercises.filter { manager.isCompleted($0.name) }.count
      let total = exercises.count
      
      let progressBar = createProgressBar(completed: completed, total: total)
      print("  \(index + 1). \(name) \(progressBar)")
      print("     \(description)")
      print("     \(total) exercises")
      print("")
    }
    
    print("\nSelect a data structure (1-\(dsaCategories.count)) or 'q' to quit: ", terminator: "")
    
    guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
      return
    }
    
    if input.lowercased() == "q" {
      return
    }
    
    guard let selection = Int(input),
          selection > 0,
          selection <= dsaCategories.count else {
      Terminal.error("Invalid selection. Please try again.")
      return
    }
    
    let selectedCategory = dsaCategories[selection - 1]
    let categoryExercises = manager.allExercises.filter { $0.dir == selectedCategory.1 }
    
    /// Find first incomplete exercise or start from beginning
    let firstIncomplete = categoryExercises.first { !manager.isCompleted($0.name) } ?? categoryExercises.first
    
    if let exercise = firstIncomplete {
      /// Set current exercise and launch watch mode
      manager.setCurrentExercise(exercise)
      
      Terminal.clear()
      print("Starting \(selectedCategory.0) exercises...")
      print("\nYou'll be working through \(categoryExercises.count) exercises.")
      print("The watch mode will guide you through each one.\n")
      print("Press any key to begin...")
      
      let tempInput = RawTerminalInput()
      tempInput.enableRawMode()
      _ = tempInput.readKey()
      tempInput.disableRawMode()
      
      /// Set environment variable to filter exercises in watch mode
      setenv("SWIFTLINGS_CATEGORY_FILTER", selectedCategory.1, 1)
      
      /// Launch watch mode
      let watchCommand = WatchCommand()
      try watchCommand.run()
      
      /// Clean up environment variable
      unsetenv("SWIFTLINGS_CATEGORY_FILTER")
    } else {
      Terminal.error("No exercises found for this data structure.")
    }
  }
  
  private func createProgressBar(completed: Int, total: Int) -> String {
    let percentage = total > 0 ? Double(completed) / Double(total) : 0
    let filled = Int(percentage * 10)
    let empty = 10 - filled
    
    let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: empty)
    let percentageText = String(format: "%.0f%%", percentage * 100)
    
    return "[\(bar)] \(percentageText) (\(completed)/\(total))"
  }
}