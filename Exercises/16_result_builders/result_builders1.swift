// result_builders1.swift
//
// Result builders allow you to build up values using declarative syntax.
// They're used extensively in SwiftUI and other DSLs.
//
// Fix the result builder implementations to make the tests pass.

// TODO: Create a basic result builder
enum StringBuilder {  // Should be @resultBuilder
    static func buildBlock(_ components: String...) -> String {
        return ""  // Should join components
    }
}

// TODO: Use the result builder
func buildString(@StringBuilder _ content: () -> String) -> String {
    return content()
}

// TODO: Create a result builder for arrays
@resultBuilder
struct ArrayBuilder<Element> {
    static func buildBlock(_ components: Element...) -> [Element] {
        return []  // Should return array of components
    }
    
    // TODO: Add support for optionals
    static func buildOptional(_ component: [Element]?) -> [Element] {
        return []  // Handle optional
    }
    
    // TODO: Add support for either/or
    static func buildEither(first component: [Element]) -> [Element] {
        return component
    }
    
    static func buildEither(second component: [Element]) -> [Element] {
        return component
    }
}

// TODO: Create HTML builder
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: HTMLNode...) -> HTMLNode {
        return HTMLNode(tag: "div", children: [])  // Should combine components
    }
    
    static func buildExpression(_ expression: String) -> HTMLNode {
        return HTMLNode(tag: "text", content: expression)
    }
    
    static func buildExpression(_ expression: HTMLNode) -> HTMLNode {
        return expression
    }
}

struct HTMLNode {
    let tag: String
    var content: String?
    var children: [HTMLNode] = []
    
    func render() -> String {
        if tag == "text" {
            return content ?? ""
        }
        
        let childrenHTML = children.map { $0.render() }.joined()
        return "<\(tag)>\(childrenHTML)</\(tag)>"
    }
}

// Helper functions for HTML DSL
func div(@HTMLBuilder _ content: () -> HTMLNode) -> HTMLNode {
    let node = content()
    return HTMLNode(tag: "div", children: node.tag == "group" ? node.children : [node])
}

func p(_ text: String) -> HTMLNode {
    return HTMLNode(tag: "p", content: text)
}

func h1(_ text: String) -> HTMLNode {
    return HTMLNode(tag: "h1", content: text)
}

// TODO: Support arrays with for loops
@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: View...) -> [View] {
        return components
    }
    
    // TODO: Add buildArray for ForEach support
    static func buildArray(_ components: [[View]]) -> [View] {
        return []  // Should flatten
    }
}

struct View {
    let id: String
    let content: String
}

func createViews(@ViewBuilder _ content: () -> [View]) -> [View] {
    return content()
}

func main() {
    test("Basic string builder") {
        let result = buildString {
            "Hello"
            "World"
            "!"
        }
        
        assertEqual(result, "HelloWorld!", "Strings should be concatenated")
    }
    
    test("Array builder with optionals") {
        let includeMiddle = true
        
        let numbers = ArrayBuilder<Int>.buildBlock {
            1
            2
            if includeMiddle {
                3
            }
            4
        }
        
        assertEqual(numbers, [1, 2, 3, 4], "Should include conditional element")
        
        let withoutMiddle = ArrayBuilder<Int>.buildBlock {
            1
            2
            if false {
                3
            }
            4
        }
        
        assertEqual(withoutMiddle, [1, 2, 4], "Should skip false condition")
    }
    
    test("HTML builder") {
        let html = div {
            h1("Welcome")
            p("This is a paragraph")
            p("Another paragraph")
        }
        
        let rendered = html.render()
        assertEqual(rendered, 
                   "<div><h1>Welcome</h1><p>This is a paragraph</p><p>Another paragraph</p></div>",
                   "HTML should be properly structured")
    }
    
    test("Conditional HTML") {
        let showWarning = true
        
        let html = div {
            h1("Status")
            if showWarning {
                p("Warning: Check your settings")
            } else {
                p("All good!")
            }
        }
        
        assertTrue(html.render().contains("Warning"), "Should show warning")
    }
    
    test("Array builder with loops") {
        let items = ["Apple", "Banana", "Cherry"]
        
        let views = createViews {
            View(id: "header", content: "Fruits")
            
            for (index, item) in items.enumerated() {
                View(id: "item-\(index)", content: item)
            }
            
            View(id: "footer", content: "Total: \(items.count)")
        }
        
        assertEqual(views.count, 5, "Should have header + 3 items + footer")
        assertEqual(views[1].content, "Apple", "First item")
        assertEqual(views.last?.content, "Total: 3", "Footer content")
    }
    
    runTests()
}