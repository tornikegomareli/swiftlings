// result_builders4.swift
//
// Advanced result builder patterns including custom transformations and type erasure.
// Building production-ready DSLs with result builders.
//
// Fix the advanced result builder patterns to make the tests pass.

// TODO: Create a type-safe configuration builder
@resultBuilder
struct ConfigBuilder {
    static func buildBlock<C0, C1>(_ c0: Config<C0>, _ c1: Config<C1>) -> Config<(C0, C1)> {
        // TODO: Combine configs preserving types
        return Config { _ in (c0.defaultValue, c1.defaultValue) }
    }
    
    static func buildBlock<C0, C1, C2>(_ c0: Config<C0>, _ c1: Config<C1>, _ c2: Config<C2>) -> Config<(C0, C1, C2)> {
        // TODO: Combine three configs
        return Config { _ in (c0.defaultValue, c1.defaultValue, c2.defaultValue) }
    }
}

struct Config<Value> {
    let key: String
    let defaultValue: Value
    let parse: (String) -> Value?
    
    init(key: String, defaultValue: Value, parse: @escaping (String) -> Value? = { _ in nil }) {
        self.key = key
        self.defaultValue = defaultValue
        self.parse = parse
    }
}

// Config DSL
func string(_ key: String, default: String = "") -> Config<String> {
    return Config(key: key, defaultValue: default) { $0 }
}

func int(_ key: String, default: Int = 0) -> Config<Int> {
    return Config(key: key, defaultValue: default) { Int($0) }
}

func bool(_ key: String, default: Bool = false) -> Config<Bool> {
    return Config(key: key, defaultValue: default) { Bool($0) }
}

// TODO: Create a pipeline builder
@resultBuilder
struct PipelineBuilder {
    static func buildBlock(_ stages: Stage...) -> Pipeline {
        return Pipeline(stages: [])  // Should use stages
    }
    
    static func buildExpression<Input, Output>(_ transform: @escaping (Input) -> Output) -> Stage {
        // TODO: Type-erase the transform
        return Stage { _ in nil }
    }
    
    static func buildArray(_ stages: [Stage]) -> Pipeline {
        return Pipeline(stages: stages)
    }
}

struct Stage {
    let transform: (Any) -> Any?
    
    func execute<T>(_ input: Any) -> T? {
        // TODO: Execute with type safety
        return nil
    }
}

struct Pipeline {
    let stages: [Stage]
    
    func execute<Input, Output>(_ input: Input) -> Output? {
        // TODO: Execute all stages in sequence
        return nil
    }
}

// Pipeline DSL
func map<Input, Output>(_ transform: @escaping (Input) -> Output) -> Stage {
    return Stage { input in
        guard let typedInput = input as? Input else { return nil }
        return transform(typedInput)
    }
}

func filter<T>(_ predicate: @escaping (T) -> Bool) -> Stage {
    return Stage { input in
        guard let typedInput = input as? T else { return nil }
        return predicate(typedInput) ? typedInput : nil
    }
}

// TODO: Create a declarative UI builder
@resultBuilder
struct UIBuilder {
    static func buildBlock(_ views: UIView...) -> UIView {
        // TODO: Create container with all views
        return UIView(type: .container, children: [])
    }
    
    static func buildIf(_ view: UIView?) -> UIView {
        return view ?? UIView(type: .empty)
    }
    
    static func buildEither(first: UIView) -> UIView {
        return first
    }
    
    static func buildEither(second: UIView) -> UIView {
        return second
    }
    
    // TODO: Support transformations
    static func buildExpression(_ view: UIView) -> UIView {
        return view
    }
    
    static func buildFinalResult(_ view: UIView) -> UIView {
        // TODO: Apply final layout pass
        return view
    }
}

enum ViewType {
    case label(String)
    case button(String, action: () -> Void)
    case container
    case stack(axis: Axis)
    case empty
}

enum Axis {
    case horizontal, vertical
}

struct UIView {
    let type: ViewType
    var children: [UIView] = []
    var modifiers: [Modifier] = []
    
    func findViews(ofType targetType: String) -> [UIView] {
        var found: [UIView] = []
        
        // TODO: Recursively find views matching type
        switch type {
        case .label(_) where targetType == "label":
            found.append(self)
        case .button(_, _) where targetType == "button":
            found.append(self)
        default:
            break
        }
        
        for child in children {
            found += child.findViews(ofType: targetType)
        }
        
        return found
    }
}

enum Modifier {
    case padding(Int)
    case background(String)
    case hidden(Bool)
}

// UI DSL
func Label(_ text: String) -> UIView {
    return UIView(type: .label(text))
}

func Button(_ title: String, action: @escaping () -> Void = {}) -> UIView {
    return UIView(type: .button(title, action: action))
}

func VStack(@UIBuilder _ content: () -> UIView) -> UIView {
    let view = content()
    return UIView(type: .stack(axis: .vertical), children: view.type.isContainer ? view.children : [view])
}

func HStack(@UIBuilder _ content: () -> UIView) -> UIView {
    let view = content()
    return UIView(type: .stack(axis: .horizontal), children: view.type.isContainer ? view.children : [view])
}

extension ViewType {
    var isContainer: Bool {
        switch self {
        case .container, .stack:
            return true
        default:
            return false
        }
    }
}

// View modifiers
extension UIView {
    func padding(_ value: Int) -> UIView {
        var modified = self
        modified.modifiers.append(.padding(value))
        return modified
    }
    
    func background(_ color: String) -> UIView {
        var modified = self
        modified.modifiers.append(.background(color))
        return modified
    }
    
    func hidden(_ isHidden: Bool) -> UIView {
        var modified = self
        modified.modifiers.append(.hidden(isHidden))
        return modified
    }
}

func main() {
    test("Type-safe configuration builder") {
        let config = Configuration {
            string("name", default: "Unknown")
            int("age", default: 0)
            bool("verified", default: false)
        }
        
        let values = config.parse([
            "name": "Alice",
            "age": "25",
            "verified": "true"
        ])
        
        assertEqual(values.0, "Alice", "Parsed name")
        assertEqual(values.1, 25, "Parsed age")
        assertEqual(values.2, true, "Parsed verified")
        
        // Test defaults
        let defaults = config.parse([:])
        assertEqual(defaults.0, "Unknown", "Default name")
        assertEqual(defaults.1, 0, "Default age")
        assertEqual(defaults.2, false, "Default verified")
    }
    
    test("Pipeline builder") {
        let pipeline = Pipeline {
            map { (x: Int) in x * 2 }
            filter { (x: Int) in x > 5 }
            map { (x: Int) in String(x) }
        }
        
        let result: String? = pipeline.execute(3)
        assertEqual(result, "6", "3 * 2 = 6, which passes filter")
        
        let filtered: String? = pipeline.execute(2)
        assertNil(filtered, "2 * 2 = 4, which fails filter")
    }
    
    test("Declarative UI builder") {
        let showDetails = true
        
        let ui = VStack {
            Label("Welcome")
                .padding(10)
                .background("blue")
            
            HStack {
                Label("Name:")
                Label("John Doe")
            }
            
            if showDetails {
                VStack {
                    Label("Details")
                    Button("Edit") { print("Edit tapped") }
                }
            }
            
            Button("Submit")
                .padding(20)
                .hidden(false)
        }
        
        let labels = ui.findViews(ofType: "label")
        assertEqual(labels.count, 4, "Should find all labels")
        
        let buttons = ui.findViews(ofType: "button")
        assertEqual(buttons.count, 2, "Should find Edit and Submit buttons")
    }
    
    test("Complex UI with modifiers") {
        let items = ["Apple", "Banana", "Cherry"]
        
        let ui = VStack {
            Label("Fruit List")
                .padding(15)
                .background("green")
            
            for (index, item) in items.enumerated() {
                HStack {
                    Label("\(index + 1).")
                    Label(item)
                    Button("Select") {
                        print("Selected \(item)")
                    }
                }
                .padding(5)
            }
        }
        
        let buttons = ui.findViews(ofType: "button")
        assertEqual(buttons.count, 3, "One button per fruit")
        
        // Check structure
        if case .stack(let axis) = ui.type {
            assertEqual(axis, .vertical, "Root is VStack")
        }
    }
    
    test("Pipeline with complex transformations") {
        struct User {
            let name: String
            let age: Int
        }
        
        let pipeline = Pipeline {
            map { (data: [String: Any]) in
                User(
                    name: data["name"] as? String ?? "",
                    age: data["age"] as? Int ?? 0
                )
            }
            filter { (user: User) in user.age >= 18 }
            map { (user: User) in user.name.uppercased() }
        }
        
        let adult: String? = pipeline.execute(["name": "Alice", "age": 25])
        assertEqual(adult, "ALICE", "Adult user processed")
        
        let minor: String? = pipeline.execute(["name": "Bob", "age": 16])
        assertNil(minor, "Minor filtered out")
    }
    
    runTests()
}

// Configuration builder implementation
struct Configuration<Values> {
    let parse: ([String: String]) -> Values
}

func Configuration<C0, C1>(@ConfigBuilder _ builder: () -> Config<(C0, C1)>) -> Configuration<(C0, C1)> {
    let config = builder()
    return Configuration { dict in
        config.parse("")!(dict)  // Simplified
    }
}

func Configuration<C0, C1, C2>(@ConfigBuilder _ builder: () -> Config<(C0, C1, C2)>) -> Configuration<(C0, C1, C2)> {
    let config = builder()
    return Configuration { dict in
        config.parse("")!(dict)  // Simplified
    }
}

// Pipeline builder implementation
func Pipeline(@PipelineBuilder _ builder: () -> Pipeline) -> Pipeline {
    return builder()
}