import Foundation
import Rainbow

struct Terminal {
  static func success(_ message: String) {
    print("✅ \(message)".green)
  }
  
  static func error(_ message: String) {
    print("❌ \(message)".red)
  }
  
  static func warning(_ message: String) {
    print("⚠️  \(message)".yellow)
  }
  
  static func info(_ message: String) {
    print("\(message)".blue)
  }
  
  static func progress(_ message: String) {
    print("🔄 \(message)".cyan)
  }
  
  static func clear() {
    print("\u{001B}[2J\u{001B}[H", terminator: "")
  }
  
  static func moveCursor(to position: (row: Int, column: Int)) {
    print("\u{001B}[\(position.row);\(position.column)H", terminator: "")
  }
}
