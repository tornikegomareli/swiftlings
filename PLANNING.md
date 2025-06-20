# Swiftlings - Project Planning

## Project Overview

Swiftlings is an interactive Swift learning system inspired by Rustlings. It provides a collection of small exercises designed to help users learn Swift programming through hands-on practice. The system features:

- A command-line interface for running and managing exercises
- Progressive exercises covering Swift fundamentals
- Automatic compilation and test validation
- Interactive watch mode with real-time feedback
- Progress tracking and hints system

## Architecture

### Core Components

1. **CLI Application**
   - Command parser and router
   - Exercise runner and validator
   - Watch mode with file monitoring
   - Progress state manager
   - User interface and output formatting

2. **Exercise System**
   - Exercise metadata management (similar to info.toml)
   - Exercise file structure and organization
   - Solution validation framework
   - Hint system

3. **Compilation & Testing**
   - Swift compiler integration
   - Test runner integration
   - Error capture and formatting
   - Output parsing and display

4. **State Management**
   - Progress tracking
   - Current exercise tracking
   - Exercise completion status

### Data Model

```
Exercise:
  - name: String
  - category: String (e.g., "basics", "optionals", "classes")
  - filePath: String
  - testMode: Bool
  - hint: String
  - dependencies: [String] (other exercises that should be completed first)

UserProgress:
  - completedExercises: [String]
  - currentExercise: String
  - lastUpdated: Date
```

## API Endpoints

N/A - This is a CLI application without web API endpoints.

## Technology Stack

- **Language**: Swift 5.9+
- **Build System**: Swift Package Manager (SPM)
- **CLI Framework**: Swift Argument Parser
- **File Watching**: FSWatch or similar Swift-compatible solution
- **Testing**: XCTest for exercise validation
- **Terminal UI**: ANSI escape codes for colored output

## Project Structure

```
Swiftling/
├── Package.swift
├── Sources/
│   └── Swiftling/
│       ├── CLI/
│       │   ├── Commands/
│       │   │   ├── RunCommand.swift
│       │   │   ├── HintCommand.swift
│       │   │   ├── ListCommand.swift
│       │   │   ├── ResetCommand.swift
│       │   │   └── WatchCommand.swift
│       │   └── ArgumentParser.swift
│       ├── Core/
│       │   ├── Exercise.swift
│       │   ├── ExerciseRunner.swift
│       │   ├── ExerciseValidator.swift
│       │   └── ProgressTracker.swift
│       ├── Utils/
│       │   ├── FileWatcher.swift
│       │   ├── Terminal.swift
│       │   └── SwiftCompiler.swift
│       └── main.swift
├── Exercises/
│   ├── info.json (exercise metadata)
│   ├── 00_basics/
│   │   ├── basics1.swift
│   │   ├── basics2.swift
│   │   └── README.md
│   ├── 01_variables/
│   │   ├── variables1.swift
│   │   ├── variables2.swift
│   │   └── README.md
│   └── ... (more categories)
├── Solutions/
│   └── (mirror structure of Exercises)
└── Tests/
    └── SwiftlingTests/
        ├── ExerciseValidationTests.swift
        └── CLITests.swift
```

## Testing Strategy

1. **Unit Tests**
   - Test individual components (ExerciseRunner, ProgressTracker, etc.)
   - Test CLI command parsing
   - Test exercise validation logic

2. **Integration Tests**
   - Test full exercise execution flow
   - Test watch mode functionality
   - Test state persistence

3. **Exercise Tests**
   - Each exercise includes embedded test cases
   - Exercises are validated by compiling and running tests
   - Solution files are tested to ensure they pass

## Development Commands

```bash
# Build the project
swift build

# Run tests
swift test

# Build release version
swift build -c release

# Run Swiftlings CLI
swift run swiftling [command]

# Install globally (after building)
cp .build/release/swiftling /usr/local/bin/

# Format code
swift-format -i -r Sources/ Tests/

# Lint code
swiftlint
```

## Environment Setup

1. **Requirements**
   - macOS 13.0+ or Linux (Ubuntu 20.04+)
   - Swift 5.9+
   - Xcode 15.0+ (for macOS development)

2. **Development Setup**
   ```bash
   # Clone repository
   git clone [repository-url]
   cd Swiftling
   
   # Build project
   swift build
   
   # Run tests
   swift test
   ```

3. **VS Code Setup** (optional)
   - Install Swift extension
   - Configure `.vscode/settings.json` for Swift development

## Development Guidelines

1. **Code Style**
   - Follow Swift API Design Guidelines
   - Use Swift-format for consistent formatting
   - Write self-documenting code with clear naming

2. **Exercise Guidelines**
   - Each exercise should focus on a single concept
   - Include clear instructions as comments
   - Provide helpful compilation errors when possible
   - Test exercises against their solutions

3. **Git Workflow**
   - Use feature branches for new exercises or features
   - Write clear commit messages
   - Test all changes before committing

4. **Documentation**
   - Document all public APIs with DocC-style comments
   - Keep exercise README files up to date
   - Maintain clear user documentation

## Security Considerations

1. **Exercise Execution**
   - Run Swift compiler in sandboxed environment if possible
   - Validate exercise files before execution
   - Limit resource usage (CPU, memory, disk)

2. **File System Access**
   - Restrict file operations to designated directories
   - Validate all file paths
   - Prevent path traversal attacks

3. **User Input**
   - Sanitize all command-line inputs
   - Validate exercise names and paths
   - Handle errors gracefully without exposing system details

## Future Considerations

1. **Web Interface**
   - Browser-based exercise viewer and editor
   - Online progress tracking
   - Community exercise sharing

2. **Advanced Features**
   - Difficulty levels for exercises
   - Achievement system
   - Time tracking and statistics
   - Multi-language support

3. **Content Expansion**
   - iOS/macOS specific exercises
   - SwiftUI exercises
   - Async/await exercises
   - Advanced Swift features (property wrappers, result builders, etc.)

4. **Integration**
   - VS Code extension
   - Xcode plugin
   - CI/CD integration for automated learning paths

5. **Community Features**
   - Exercise submission system
   - User-contributed exercises
   - Discussion forums for each exercise