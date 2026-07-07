import Foundation
import Rainbow

/// Cockpit-style bordered panel primitives: framed, labeled zones on a strict
/// 80-column grid, ANSI-16 colors only, no emoji.
enum Box {
  static let width = 80
  static let innerWidth = width - 4 // "│ " + " │"

  enum LabelColor {
    case neutral
    case success
    case failure
  }

  private static func styledLabel(_ label: String, color: LabelColor) -> String {
    let padded = " \(label) "
    switch color {
      case .neutral: return padded.cyan.bold
      case .success: return padded.green.bold
      case .failure: return padded.red.bold
    }
  }

  static func top(_ label: String, color: LabelColor = .neutral) -> String {
    let used = 2 + " \(label) ".count + 1
    let dashes = String(repeating: "─", count: max(width - used, 0))
    return "┌─".lightBlack + styledLabel(label, color: color) + dashes.lightBlack + "┐".lightBlack
  }

  static func bottom() -> String {
    ("└" + String(repeating: "─", count: width - 2) + "┘").lightBlack
  }

  /// A single content line, bordered and padded out to the panel width.
  static func line(_ text: String = "") -> String {
    let visible = text.raw.count
    let padding = max(innerWidth - visible, 0)
    return "│ ".lightBlack + text + String(repeating: " ", count: padding) + " │".lightBlack
  }

  /// Left- and right-aligned content on one bordered line, like `justify-content: space-between`.
  static func spaceBetween(_ left: String, _ right: String) -> String {
    let leftVisible = left.raw.count
    let rightVisible = right.raw.count
    let gap = max(innerWidth - leftVisible - rightVisible, 1)
    return line(left + String(repeating: " ", count: gap) + right)
  }

  /// Greedily word-wraps plain (uncolored) text to fit the panel's interior width.
  private static func wrapPlain(_ text: String, width: Int) -> [String] {
    guard text.count > width else { return [text] }

    var result: [String] = []
    var current = ""
    for word in text.split(separator: " ", omittingEmptySubsequences: true) {
      let candidate = current.isEmpty ? String(word) : current + " " + word
      if candidate.count > width, !current.isEmpty {
        result.append(current)
        current = String(word)
      } else {
        current = candidate
      }
    }
    if !current.isEmpty { result.append(current) }
    return result.isEmpty ? [""] : result
  }

  /// Word-wraps `text` to the panel width, applying `color` to each wrapped line, then borders each one.
  static func wrappedLines(_ text: String, color: ((String) -> String) = { $0 }) -> [String] {
    wrapPlain(text, width: innerWidth).map { line(color($0)) }
  }

  /// Wraps pre-built content lines (from `line`/`spaceBetween`) in a top/bottom frame.
  static func panel(label: String, color: LabelColor = .neutral, contentLines: [String]) -> String {
    var out = [top(label, color: color)]
    out.append(contentsOf: contentLines)
    out.append(bottom())
    return out.joined(separator: "\n")
  }

  /// Inline block progress bar: filled cyan blocks, empty dim blocks, count + percentage.
  static func progressBar(completed: Int, total: Int, barWidth: Int = 24) -> String {
    guard total > 0 else { return "no exercises".lightBlack }
    let ratio = Double(completed) / Double(total)
    let filled = min(barWidth, Int((Double(barWidth) * ratio).rounded()))
    let empty = barWidth - filled
    let bar = String(repeating: "█", count: filled).cyan + String(repeating: "░", count: empty).lightBlack
    let percent = Int((ratio * 100).rounded())
    let count = "\(completed)/\(total)".lightWhite.bold
    let pct = "\(percent)%".lightBlack
    return "\(bar) \(count) \(pct)"
  }

  /// The persistent footer command bar shown under every Watch Mode screen.
  static func commandBar(_ items: [(key: String, label: String)]) -> String {
    items.map { "\($0.key.cyan.bold) \($0.label.lightBlack)" }.joined(separator: "   ")
  }
}
