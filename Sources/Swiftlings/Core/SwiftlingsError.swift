import Foundation

/// Base error type for all Swiftlings errors
protocol SwiftlingsError: Error, LocalizedError {
    var userMessage: String { get }
}

extension SwiftlingsError {
    var errorDescription: String? {
        userMessage
    }
}

/// Exercise-related errors
enum ExerciseError: SwiftlingsError {
    case notFound(name: String)
    case compilationFailed(message: String)
    case testsFailed(message: String)
    case executionFailed(exitCode: Int32)
    case fileReadError(path: String, underlying: Error)
    
    var userMessage: String {
        switch self {
        case .notFound(let name):
            return "Exercise '\(name)' not found"
        case .compilationFailed(let message):
            return "Compilation failed:\n\(message)"
        case .testsFailed(let message):
            return "Tests failed:\n\(message)"
        case .executionFailed(let exitCode):
            return "Exercise failed with exit code \(exitCode)"
        case .fileReadError(let path, let error):
            return "Failed to read file '\(path)': \(error.localizedDescription)"
        }
    }
}

/// Progress tracking errors
enum ProgressError: SwiftlingsError {
    case failedToLoad(underlying: Error)
    case failedToSave(underlying: Error)
    case corrupted(message: String)
    
    var userMessage: String {
        switch self {
        case .failedToLoad(let error):
            return "Failed to load progress: \(error.localizedDescription)"
        case .failedToSave(let error):
            return "Failed to save progress: \(error.localizedDescription)"
        case .corrupted(let message):
            return "Progress file corrupted: \(message)"
        }
    }
}

/// Process execution errors
enum ProcessError: SwiftlingsError {
    case executableNotFound(path: String)
    case executionFailed(executable: String, exitCode: Int32, stderr: String)
    case timeout(executable: String)
    
    var userMessage: String {
        switch self {
        case .executableNotFound(let path):
            return "Executable not found: \(path)"
        case .executionFailed(let executable, let exitCode, let stderr):
            return "\(executable) failed (exit code \(exitCode)):\n\(stderr)"
        case .timeout(let executable):
            return "\(executable) timed out"
        }
    }
}

/// File system errors
enum FileSystemError: SwiftlingsError {
    case fileNotFound(path: String)
    case directoryNotFound(path: String)
    case permissionDenied(path: String)
    case failedToCreateDirectory(path: String, underlying: Error)
    case failedToCopyFile(from: String, to: String, underlying: Error)
    
    var userMessage: String {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .directoryNotFound(let path):
            return "Directory not found: \(path)"
        case .permissionDenied(let path):
            return "Permission denied: \(path)"
        case .failedToCreateDirectory(let path, let error):
            return "Failed to create directory '\(path)': \(error.localizedDescription)"
        case .failedToCopyFile(let from, let to, let error):
            return "Failed to copy '\(from)' to '\(to)': \(error.localizedDescription)"
        }
    }
}

/// Configuration errors
enum ConfigurationError: SwiftlingsError {
    case missingInfoFile
    case invalidInfoFile(message: String)
    case incompatibleVersion(found: String, required: String)
    
    var userMessage: String {
        switch self {
        case .missingInfoFile:
            return "Exercise info file not found. Are you in a Swiftlings directory?"
        case .invalidInfoFile(let message):
            return "Invalid exercise info file: \(message)"
        case .incompatibleVersion(let found, let required):
            return "Incompatible version: found \(found), required \(required)"
        }
    }
}