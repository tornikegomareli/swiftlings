import Foundation
import Rainbow

/// Color options for terminal output
enum TerminalColor {
  case blue, cyan, green, red, yellow
}

/// Terminal utilities for formatted output
enum Terminal {
  /// Print success message in green
  static func success(_ message: String) {
    print("✅ \(message)".green)
  }

  /// Print error message in red
  static func error(_ message: String) {
    print("❌ \(message)".red)
  }

  /// Print warning message in yellow
  static func warning(_ message: String) {
    print("⚠️  \(message)".yellow)
  }

  /// Print info message in blue
  static func info(_ message: String) {
    print("ℹ️  \(message)".blue)
  }

  /// Print a progress message in cyan
  static func progress(_ message: String) {
    print("🔄 \(message)".cyan)
  }

  /// Clear the terminal screen
  static func clear() {
    print("\u{001B}[2J\u{001B}[H", terminator: "")
  }

  /// Move cursor to specific position
  static func moveCursor(to position: (row: Int, column: Int)) {
    print("\u{001B}[\(position.row);\(position.column)H", terminator: "")
  }

  /// Print colored text using Rainbow
  static func colored(_ text: String, color: TerminalColor) -> String {
    switch color {
      case .blue:
        return text.blue
      case .cyan:
        return text.cyan
      case .green:
        return text.green
      case .red:
        return text.red
      case .yellow:
        return text.yellow
    }
  }
}
