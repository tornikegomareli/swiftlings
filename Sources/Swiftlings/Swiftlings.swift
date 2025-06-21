import ArgumentParser

public struct Swiftlings: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "swiftlings",
        abstract: "A Swift learning tool inspired by Rustlings",
        version: "0.1.0",
        subcommands: [
            RunCommand.self,
            HintCommand.self,
            ListCommand.self,
            ResetCommand.self,
            WatchCommand.self
        ],
        defaultSubcommand: WatchCommand.self
    )
    
    public init() {}
}