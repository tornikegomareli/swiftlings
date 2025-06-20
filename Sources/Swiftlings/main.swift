import ArgumentParser

@main
struct Swiftlings: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftlings",
        abstract: "A Swift learning tool inspired by Rustlings",
        version: "0.1.0"
    )
    
    func run() throws {
        print("Welcome to Swiftlings! 🦉")
        print("This tool is under construction.")
    }
}
