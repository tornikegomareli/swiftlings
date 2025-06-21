import Foundation
import Rainbow

/// Terminal utilities for formatted output
struct Terminal {
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
    
    /// Print a progress message
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
}