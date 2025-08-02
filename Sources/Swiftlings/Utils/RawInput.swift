import Foundation

/// Utility for handling raw terminal input without requiring Enter key
class RawTerminalInput {
    private var originalTerminalSettings: termios?
    
    init() {
        // Save original terminal settings
        originalTerminalSettings = termios()
        if var settings = originalTerminalSettings {
            tcgetattr(STDIN_FILENO, &settings)
            originalTerminalSettings = settings
        }
    }
    
    deinit {
        // Restore original terminal settings
        if var original = originalTerminalSettings {
            tcsetattr(STDIN_FILENO, TCSANOW, &original)
        }
    }
    
    /// Enable raw mode for immediate keypress detection
    func enableRawMode() {
        var raw = termios()
        tcgetattr(STDIN_FILENO, &raw)
        
        // Disable canonical mode (line buffering) and echo
        raw.c_lflag &= ~(UInt(ICANON) | UInt(ECHO))
        
        // Set minimum characters to read - handle tuple-based c_cc on macOS
        withUnsafeMutableBytes(of: &raw.c_cc) { ptr in
            ptr[Int(VMIN)] = 1
            ptr[Int(VTIME)] = 0
        }
        
        tcsetattr(STDIN_FILENO, TCSANOW, &raw)
    }
    
    /// Disable raw mode and restore normal terminal settings
    func disableRawMode() {
        if var original = originalTerminalSettings {
            tcsetattr(STDIN_FILENO, TCSANOW, &original)
        }
    }
    
    /// Read a single character without waiting for Enter
    func readKey() -> Character? {
        var buffer = [UInt8](repeating: 0, count: 1)
        let bytesRead = read(STDIN_FILENO, &buffer, 1)
        
        if bytesRead > 0 {
            return Character(UnicodeScalar(buffer[0]))
        }
        
        return nil
    }
    
    /// Read a single character with timeout
    func readKey(timeout: TimeInterval) -> Character? {
        var readfds = fd_set()
        readfds.zero()
        readfds.setFD(STDIN_FILENO)
        
        var tv = timeval()
        tv.tv_sec = Int(timeout)
        tv.tv_usec = Int32((timeout - Double(tv.tv_sec)) * 1_000_000)
        
        let result = select(STDIN_FILENO + 1, &readfds, nil, nil, &tv)
        
        if result > 0 {
            return readKey()
        }
        
        return nil
    }
}

// Helper extensions for fd_set
extension fd_set {
    mutating func zero() {
        withUnsafeMutableBytes(of: &self) { ptr in
            _ = memset(ptr.baseAddress, 0, MemoryLayout<fd_set>.size)
        }
    }
    
    mutating func setFD(_ fd: Int32) {
        let intOffset = Int(fd / 32)
        let bitOffset = Int(fd % 32)
        let mask = 1 << bitOffset
        
        withUnsafeMutableBytes(of: &self.fds_bits) { ptr in
            guard let baseAddress = ptr.baseAddress else { return }
            let int32Ptr = baseAddress.assumingMemoryBound(to: Int32.self)
            int32Ptr[intOffset] |= Int32(mask)
        }
    }
}