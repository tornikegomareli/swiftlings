import Foundation
import Rainbow

/// A terminal progress bar component, rendered via `Box.progressBar`.
struct ProgressBar {
  let completed: Int
  let total: Int
  let width: Int

  init(completed: Int, total: Int, width: Int = 80) {
    self.completed = completed
    self.total = total
    self.width = width
  }

  /// Get a formatted progress string with bar and percentage
  func formattedProgress() -> String {
    "Progress: " + Box.progressBar(completed: completed, total: total)
  }
}

struct SwiftlingsUI {
  private let manager: ExerciseManager

  init(manager: ExerciseManager) {
    self.manager = manager
  }

  private static let footer = Box.commandBar([
    ("n", "next"),
    ("h", "hint"),
    ("l", "list"),
    ("c", "check all"),
    ("x", "reset"),
    ("q", "quit"),
  ])

  func renderWatchMode(
    currentExercise: Exercise,
    result: ExerciseResult? = nil,
    showError: Bool = false,
    duration: TimeInterval? = nil
  ) {
    Terminal.clear()

    print(headerPanel(currentExercise))
    print("")
    print(exercisePanel(currentExercise))

    if let result {
      print("")
      print(outputPanel(result: result, duration: duration))
    }

    print("")
    print(Self.footer)
  }

  private func headerPanel(_ exercise: Exercise) -> String {
    let stats = manager.getProgressStats()
    let identity = exercise.name.lightWhite.bold + " · ".lightBlack + exercise.dir.lightBlack
    let bar = Box.progressBar(completed: stats.completed, total: stats.total)
    return Box.panel(label: "swiftlings", contentLines: [Box.spaceBetween(identity, bar)])
  }

  private func exercisePanel(_ exercise: Exercise) -> String {
    var lines = [Box.line(exercise.filePath.cyan)]
    lines.append(contentsOf: Box.wrappedLines("// \(exercise.hint)") { $0.lightBlack })
    return Box.panel(label: "exercise", contentLines: lines)
  }

  private func outputPanel(result: ExerciseResult, duration: TimeInterval?) -> String {
    switch result {
      case .success(let output):
        return Box.panel(label: "output · pass", color: .success, contentLines: successLines(output: output, duration: duration))

      case .compilationError(let message):
        return Box.panel(label: "output · fail", color: .failure, contentLines: failureLines(heading: "compile error", body: message))

      case .testFailure(let message):
        return Box.panel(label: "output · fail", color: .failure, contentLines: failureLines(heading: "tests failed", body: message))
    }
  }

  private func successLines(output: String, duration: TimeInterval?) -> [String] {
    let timing = duration.map { String(format: "%.1fs", $0).lightBlack } ?? ""
    var lines = [Box.line("✓ compiled".green + "   " + "✓ ran".green + "   " + timing)]
    lines.append(Box.line())

    let outputLines = output.split(separator: "\n", omittingEmptySubsequences: false)
    if !output.isEmpty {
      for outputLine in outputLines {
        lines.append(contentsOf: Box.wrappedLines(String(outputLine)))
      }
      lines.append(Box.line())
    }

    lines.append(Box.line(
      "✓ Exercise done".green.bold + " — press ".lightBlack + "n".cyan.bold + " for the next exercise".lightBlack
    ))
    return lines
  }

  private func failureLines(heading: String, body: String) -> [String] {
    var lines = [Box.line("✗ \(heading)".red.bold), Box.line()]
    lines.append(contentsOf: colorizedLines(body))
    lines.append(Box.line())
    lines.append(Box.line("waiting — fix the file and save; swiftlings re-runs automatically".lightBlack))
    return lines
  }

  /// Highlights `path:line:col: error|warning: message` lines and dims caret/underline markers;
  /// everything else (raw stdout/compiler context) passes through unstyled.
  private func colorizedLines(_ text: String) -> [String] {
    let locationPattern = try? NSRegularExpression(pattern: #"^(.*?:\d+:\d+):\s*(error|warning):\s*(.*)$"#)

    return text.split(separator: "\n", omittingEmptySubsequences: false).flatMap { rawLine -> [String] in
      let line = String(rawLine)

      if line.count > Box.innerWidth {
        return Box.wrappedLines(line)
      }

      let fullRange = NSRange(line.startIndex..., in: line)
      if let match = locationPattern?.firstMatch(in: line, range: fullRange),
        let locationRange = Range(match.range(at: 1), in: line),
        let kindRange = Range(match.range(at: 2), in: line),
        let messageRange = Range(match.range(at: 3), in: line)
      {
        let location = String(line[locationRange]).yellow
        let kind = String(line[kindRange])
        let kindStyled = kind == "error" ? "error:".red.bold : "warning:".yellow.bold
        let rest = String(line[messageRange])
        return [Box.line("\(location): \(kindStyled) \(rest)")]
      }

      let trimmed = line.trimmingCharacters(in: .whitespaces)
      if !trimmed.isEmpty, trimmed.allSatisfy({ $0 == "^" || $0 == "~" }) {
        return [Box.line(line.lightBlack)]
      }

      return [Box.line(line)]
    }
  }
}
