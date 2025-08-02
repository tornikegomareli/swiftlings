import Foundation

class FileWatcher {
  private var watchedPath: String
  private var lastModificationDate: Date?
  private var timer: Timer?
  private let onChange: () -> Void
  
  init(path: String, onChange: @escaping () -> Void) {
    self.watchedPath = path
    self.onChange = onChange
    self.lastModificationDate = getModificationDate()
  }
  
  func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
      self?.checkForChanges()
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
  }
  
  private func getModificationDate() -> Date? {
    do {
      let attributes = try FileManager.default.attributesOfItem(atPath: watchedPath)
      return attributes[.modificationDate] as? Date
    } catch {
      return nil
    }
  }
  
  private func checkForChanges() {
    guard let currentModDate = getModificationDate() else { return }
    
    if let lastModDate = lastModificationDate {
      if currentModDate > lastModDate {
        lastModificationDate = currentModDate
        onChange()
      }
    } else {
      lastModificationDate = currentModDate
    }
  }
}
