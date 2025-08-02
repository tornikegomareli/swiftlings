import Foundation

/// A terminal progress bar component similar to Rustlings
struct ProgressBar {
  let completed: Int
  let total: Int
  let width: Int
  
  init(completed: Int, total: Int, width: Int = 80) {
    self.completed = completed
    self.total = total
    self.width = width
  }
  
  /// Generate the progress bar string
  func render() -> String {
    guard total > 0 else { return "[No exercises]" }
    
    let percentage = Double(completed) / Double(total)
    let filledWidth = Int(Double(width) * percentage)
    let emptyWidth = width - filledWidth
    
    var bar = "["
    
    if filledWidth > 0 {
      bar += String(repeating: "#", count: filledWidth - 1)
      if filledWidth < width {
        bar += ">"
      } else {
        bar += "#"
      }
    }
    
    if emptyWidth > 0 {
      bar += String(repeating: "-", count: emptyWidth)
    }
    
    bar += "]"
    
    return bar
  }
  
  /// Get a formatted progress string with bar and percentage
  func formattedProgress() -> String {
    let bar = render()
    let percentageStr = String(format: "%.0f%%", Double(completed) / Double(total) * 100)
    return "Progress: \(bar) \(completed)/\(total) (\(percentageStr))"
  }
}

struct SwiftlingsUI {
  private let manager: ExerciseManager
  private let terminal = Terminal()
  
  init(manager: ExerciseManager) {
    self.manager = manager
  }
  
  func renderWatchMode(currentExercise: Exercise, result: ExerciseResult? = nil, showError: Bool = false) {
    Terminal.clear()
    
    renderHeader(currentExercise: currentExercise, showError: showError)
    
    renderProgressBar()
    
    renderCurrentExercise(currentExercise)
    
    if let result = result {
      renderResult(result)
    }
    
    renderCommandsFooter()
  }
  
  private func renderHeader(currentExercise: Exercise, showError: Bool) {
    if showError {
      print("\(Terminal.colored("⚠️  Exercise failed", color: .red))")
    } else {
      print("\(Terminal.colored("✓ Exercise done", color: .green))")
      print("When done experimenting, enter `n` to move on to the next exercise 🎉")
    }
    print("")
  }
  
  private func renderProgressBar() {
    let stats = manager.getProgressStats()
    let progressBar = ProgressBar(completed: stats.completed, total: stats.total, width: 120)
    
    print(progressBar.formattedProgress())
    print("Current exercise: \(Terminal.colored(manager.getCurrentExercise()?.filePath ?? "", color: .cyan))")
    print("")
  }
  
  private func renderCurrentExercise(_ exercise: Exercise) {
    print("// \(exercise.name).swift")
    print("// \(exercise.hint)")
    print("")
  }
  
  private func renderResult(_ result: ExerciseResult) {
    switch result {
    case .success(let output):
      print("Output")
      print("")
      if !output.isEmpty {
        print(output)
      }
      
    case .compilationError(let message):
      Terminal.error("Compilation error:")
      print(message)
      
    case .testFailure(let message):
      Terminal.error("Test failure:")
      print(message)
    }
    print("")
  }
  
  private func renderCommandsFooter() {
    print("n:next / h:hint / l:list / c:check all / x:reset / q:quit")
  }
}

extension Terminal {
  static func colored(_ text: String, color: Color) -> String {
    switch color {
    case .blue:
      return "\u{001B}[34m\(text)\u{001B}[0m"
    case .cyan:
      return "\u{001B}[36m\(text)\u{001B}[0m"
    case .green:
      return "\u{001B}[32m\(text)\u{001B}[0m"
    case .red:
      return "\u{001B}[31m\(text)\u{001B}[0m"
    case .yellow:
      return "\u{001B}[33m\(text)\u{001B}[0m"
    }
  }
  
  enum Color {
    case blue, cyan, green, red, yellow
  }
}
