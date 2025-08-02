import Foundation

/// Custom error for compilation failures
struct CompilationError: Error {
    let message: String
}

/// Handles compilation and execution of exercises
final class ExerciseRunner {
    private let exercise: Exercise
    private let fileManager: FileManager
    private let compiler: ExerciseCompiler
    private let executor: ExerciseExecutor
    private let testDetector: TestDetector
    
    init(
        exercise: Exercise,
        fileManager: FileManager = .default,
        compiler: ExerciseCompiler = ExerciseCompiler(),
        executor: ExerciseExecutor = ExerciseExecutor(),
        testDetector: TestDetector = TestDetector()
    ) {
        self.exercise = exercise
        self.fileManager = fileManager
        self.compiler = compiler
        self.executor = executor
        self.testDetector = testDetector
    }
    
    /// Run the exercise
    func run() throws -> ExerciseResult {
        let tempDir = createTempDirectory()
        defer { cleanupTempDirectory(tempDir) }
        
        try setupExerciseFiles(in: tempDir)
        
        let sourceFile = URL(fileURLWithPath: fileManager.currentDirectoryPath)
            .appendingPathComponent(exercise.filePath)
        let usesTests = testDetector.usesTestApproach(exercisePath: sourceFile)
        
        // Compile
        Terminal.progress("Compiling \(exercise.name)...")
        let compilationResult = try compiler.compile(
            exercise: exercise,
            in: tempDir,
            includeAssert: usesTests
        )
        
        switch compilationResult {
        case .success(let output):
            if !output.isEmpty {
                Terminal.info("Compiler output: \(output)")
            }
        case .failure(let message):
            return .compilationError(message: message)
        }
        
        // Execute
        Terminal.progress("Running \(exercise.name)...")
        let executablePath = tempDir.appendingPathComponent("exercise")
        let executionResult = try executor.execute(
            executablePath: executablePath,
            usesTests: usesTests
        )
        
        switch executionResult {
        case .success(let output):
            return .success(output: output)
        case .testFailure(let message):
            return .testFailure(message: message)
        }
    }
    
    // MARK: - Private Helpers
    
    private func createTempDirectory() -> URL {
        let tempDir = fileManager.temporaryDirectory
            .appendingPathComponent("swiftlings-\(UUID().uuidString)")
        try? fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        return tempDir
    }
    
    private func cleanupTempDirectory(_ directory: URL) {
        try? fileManager.removeItem(at: directory)
    }
    
    private func setupExerciseFiles(in directory: URL) throws {
        // Copy exercise file
        let tempFile = directory.appendingPathComponent("\(exercise.name).swift")
        let sourceFile = URL(fileURLWithPath: fileManager.currentDirectoryPath)
            .appendingPathComponent(exercise.filePath)
        try fileManager.copyItem(at: sourceFile, to: tempFile)
        
        // Copy Assert.swift if needed
        let usesTests = testDetector.usesTestApproach(exercisePath: sourceFile)
        if usesTests {
            let assertSourcePath = URL(fileURLWithPath: fileManager.currentDirectoryPath)
                .appendingPathComponent("Sources/Swiftlings/Core/Assert.swift")
            let assertDestPath = directory.appendingPathComponent("Assert.swift")
            
            if fileManager.fileExists(atPath: assertSourcePath.path) {
                try fileManager.copyItem(at: assertSourcePath, to: assertDestPath)
            }
        }
        
        // Create main.swift
        let mainFile = directory.appendingPathComponent("main.swift")
        let mainContent = """
            // Call the main function from the exercise
            main()
            """
        try mainContent.write(to: mainFile, atomically: true, encoding: .utf8)
    }
}

/// Exercise execution result
enum ExerciseResult {
    case success(output: String)
    case compilationError(message: String)
    case testFailure(message: String)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}