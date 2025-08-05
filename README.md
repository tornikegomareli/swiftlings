## Overview 🦉

Swiftlings is an interactive learning tool for Swift, inspired by Rustlings. It provides a structured path through Swift programming concepts. Each exercise is a small, focused problem designed to teach specific Swift features through hands-on practice.

### ⚠️ Early Development Notice

**This project is in very early development.** While it has been tested and works well on macOS, it still requires proper testing and validation on Windows and Linux platforms. Features may change, and you might encounter bugs. Please report any issues you find!

## Installation

### Install via Homebrew

```bash
brew tap tornikegomareli/swiftlings
brew install swiftlings
```

## Getting Started

1. Initialize a new Swiftlings project:

```bash
swiftlings init
```

This creates a new directory with all exercises.

2. Navigate to the project directory:

```bash
cd swiftlings
```

3. Start the interactive learning mode:

```bash
swiftlings
```

## Usage

### Interactive Mode

Interactive mode is default mode when u run

```bash
swiftlings
```

The default mode monitors your exercise files and automatically builds it and runs tests when you save changes.

#### Interactive Commands

While in watch mode, you can use these keyboard shortcuts:

- `n` - Move to next exercise
- `h` - Show hint for current exercise
- `l` - List all exercises
- `q` - Quit
- `r` - Re-run current exercise
- `c` - Clear terminal

### Manual Mode

Run specific exercises directly:

```bash
swiftlings run variables1
```

### Other Commands

**List all exercises:**
```bash
swiftlings list
```

Shows all exercises with their completion status and categories.

**Get hints:**
```bash
swiftlings hint variables1
```

Displays helpful hints for solving specific exercises.

**Reset an exercise and its state:**
```bash
swiftlings reset variables1
```

Restores an exercise to its original state.

## Exercise Structure

Exercises are organized into 19 progressive categories:

1. **00_basics** - Introduction and basic syntax
2. **01_control_flow** - if/else, switch, loops
3. **02_functions** - Function declaration and usage
4. **03_collections** - Arrays, sets, dictionaries
5. **04_optionals** - Swift's optional types
6. **05_structs** - Value types and structures
7. **06_classes** - Reference types and inheritance
8. **07_enums** - Enumerations and associated values
9. **08_protocols** - Protocol-oriented programming
10. **09_extensions** - Extending existing types
11. **10_generics** - Generic programming
12. **11_error_handling** - Error handling patterns
13. **12_closures** - Closures and functional programming
14. **13_memory_management** - ARC and memory management
15. **14_property_wrappers** - Property wrappers and observation
16. **15_concurrency** - Modern Swift concurrency
17. **16_result_builders** - DSL and result builders
18. **17_advanced_types** - Advanced type system features
19. **18_codable** - Encoding and decoding

## How It Works

Each exercise file contains:

- Instructions in comments explaining what to implement
- Code with `// TODO` markers indicating what needs to be fixed
- Test cases that verify your solution

Your goal is to make all tests pass and solution to be compilable for each exercise. The CLI provides instant feedback as you work.

## Progress Tracking

Swiftlings automatically tracks your progress through exercises. Your progress is saved locally and persists between sessions.

## Updating

To update to the latest version:

```bash
brew update
brew upgrade swiftlings
```

## Development

### Building from Source

```bash
git clone https://github.com/tornikegomareli/swiftlings.git
cd swiftlings
make build-release
```

### Running Tests

```bash
make test
```

### Code Formatting

```bash
make format
```

## Contributing

I love contributions! Swiftlings is a community-driven project, and I welcome improvements from developers of all skill levels.

### Ways to Contribute

#### Found a Bug in an Exercise?

If you encounter an exercise that:
- Has incorrect test cases
- Contains compilation errors unrelated to the learning objective
- Has misleading or unclear instructions

Please open a PR with the fix! Even small corrections are valuable.

#### Have a Better Explanation?

Learning is personal, and sometimes an exercise explanation doesn't click. If you can explain a concept more clearly:
- Fork the repository
- Improve the exercise comments and instructions
- Submit a PR with your improvements

I especially value contributions that make complex concepts more approachable for beginners.

#### Found a CLI Bug or Technical Issue?

The CLI itself is also open for improvements! If you encounter:
- Bugs in the watch mode, file detection, or command execution
- Issues with progress tracking or state management
- Problems with the build system or test runner
- Any crashes or unexpected behavior
- Performance issues or resource problems

Please report them or better yet, submit a fix! Technical contributions to the core tool are extremely valuable.

#### New Exercise Ideas

Got an idea for teaching a Swift concept better? I'd love to see it!

1. Create a new Swift file in the appropriate category directory
2. Add the exercise metadata to `exercises.json`
3. Include:
   - Clear learning objectives
   - Step-by-step instructions
   - Helpful hints
   - Test cases that guide learning
4. Submit a pull request

#### Improving Documentation

- Found a typo?
- Have a clearer way to explain something?
- Want to add examples?

Documentation improvements are always welcome!

### Contribution Guidelines

1. **Test Your Changes**: Make sure all exercises compile and run correctly
2. **Follow Existing Patterns**: Look at existing exercises for style and structure
3. **Keep It Focused**: Each exercise should teach one concept clearly
4. **Be Encouraging**: Write hints and messages that encourage learners
5. **Consider Difficulty**: Place exercises appropriately in the progression

### Submitting a Pull Request

1. Fork the repository
2. Create a feature branch (`git checkout -b improve-optionals-exercise`)
3. Make your changes
4. Test thoroughly (`make test`)
5. Commit with clear messages
6. Push to your fork
7. Open a PR with a description of what you changed and why

### Report Issues

Not ready to fix it yourself? No problem! Open an issue describing:
- Which exercise has the problem (if exercise-related)
- What you expected to happen
- What actually happened
- Any error messages you saw
- Your environment (macOS version, Swift version, etc.)

Every contribution, no matter how small, helps make Swiftlings better for everyone learning Swift!

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

Inspired by [Rustlings](https://github.com/rust-lang/rustlings), the fantastic Rust learning tool.
