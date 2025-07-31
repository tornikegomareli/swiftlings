// result_builders3.swift
//
// Result builders with complex control flow including loops and conditions.
// Building sophisticated DSLs with nested builders.
//
// Fix the result builder implementations to make the tests pass.

// TODO: Create a menu builder with nested sections
@resultBuilder
struct MenuBuilder {
    static func buildBlock(_ components: MenuItem...) -> [MenuItem] {
        return []  // Should return components
    }
    
    static func buildArray(_ components: [[MenuItem]]) -> [MenuItem] {
        return []  // Should flatten arrays
    }
    
    static func buildOptional(_ component: [MenuItem]?) -> [MenuItem] {
        return component ?? []
    }
    
    static func buildEither(first component: [MenuItem]) -> [MenuItem] {
        return component
    }
    
    static func buildEither(second component: [MenuItem]) -> [MenuItem] {
        return component
    }
}

@resultBuilder 
struct SectionBuilder {
    static func buildBlock(_ components: MenuItem...) -> [MenuItem] {
        return []  // Should return components
    }
}

enum MenuItem {
    case item(name: String, price: Double)
    case section(name: String, items: [MenuItem])
    case separator
    
    var totalPrice: Double {
        switch self {
        case .item(_, let price):
            return price
        case .section(_, let items):
            return 0  // Should sum nested items
        case .separator:
            return 0
        }
    }
}

// Menu DSL functions
func item(_ name: String, price: Double) -> MenuItem {
    return .item(name: name, price: price)
}

func section(_ name: String, @SectionBuilder _ content: () -> [MenuItem]) -> MenuItem {
    return .section(name: name, items: [])  // Should use content()
}

func separator() -> MenuItem {
    return .separator
}

// TODO: Create a form builder with validation
@resultBuilder
struct FormBuilder {
    static func buildBlock(_ components: FormField...) -> Form {
        return Form(fields: [])  // Should use components
    }
    
    static func buildExpression(_ field: FormField) -> FormField {
        return field
    }
    
    static func buildOptional(_ component: FormField?) -> FormField {
        return component ?? FormField(name: "", validator: { _ in true })
    }
}

struct FormField {
    let name: String
    let validator: (String) -> Bool
    var isRequired: Bool = false
    
    func validate(_ value: String) -> Bool {
        if isRequired && value.isEmpty {
            return false
        }
        return validator(value)
    }
}

struct Form {
    let fields: [FormField]
    
    func validate(_ data: [String: String]) -> Bool {
        // TODO: Validate all fields
        return true
    }
}

// Form DSL
func textField(_ name: String, required: Bool = false, validator: @escaping (String) -> Bool = { _ in true }) -> FormField {
    return FormField(name: name, validator: validator, isRequired: required)
}

func emailField(_ name: String, required: Bool = true) -> FormField {
    return FormField(name: name, validator: { $0.contains("@") }, isRequired: required)
}

// TODO: Create a layout builder with alignment
@resultBuilder
struct LayoutBuilder {
    static func buildBlock(_ components: LayoutElement...) -> Layout {
        return Layout(elements: [], alignment: .center)  // Should use components
    }
    
    static func buildArray(_ components: [Layout]) -> Layout {
        // TODO: Combine multiple layouts
        return Layout(elements: [], alignment: .center)
    }
}

enum Alignment {
    case left, center, right
}

struct LayoutElement {
    let content: String
    let width: Int
}

struct Layout {
    let elements: [LayoutElement]
    let alignment: Alignment
    
    func render(totalWidth: Int) -> String {
        // TODO: Render with proper alignment
        return ""
    }
}

// Layout DSL
func text(_ content: String, width: Int = 0) -> LayoutElement {
    return LayoutElement(content: content, width: width)
}

func hstack(alignment: Alignment = .left, @LayoutBuilder _ content: () -> Layout) -> Layout {
    let layout = content()
    return Layout(elements: layout.elements, alignment: alignment)
}

func main() {
    test("Menu builder with sections") {
        let menu = Menu {
            section("Appetizers") {
                item("Salad", price: 8.99)
                item("Soup", price: 6.99)
            }
            
            separator()
            
            section("Main Courses") {
                item("Steak", price: 24.99)
                item("Salmon", price: 19.99)
                item("Pasta", price: 14.99)
            }
            
            separator()
            
            section("Desserts") {
                item("Ice Cream", price: 5.99)
                item("Cake", price: 7.99)
            }
        }
        
        assertEqual(menu.items.count, 5, "Should have 3 sections + 2 separators")
        
        let mainSection = menu.items[2]
        assertEqual(mainSection.totalPrice, 59.97, "Main courses total")
    }
    
    test("Menu with conditional items") {
        let isVegetarian = true
        let hasSpecial = false
        
        let menu = Menu {
            section("Today's Menu") {
                item("Burger", price: 12.99)
                
                if isVegetarian {
                    item("Veggie Burger", price: 11.99)
                    item("Salad Bowl", price: 9.99)
                }
                
                if hasSpecial {
                    item("Chef's Special", price: 18.99)
                }
            }
        }
        
        let section = menu.items.first!
        if case .section(_, let items) = section {
            assertEqual(items.count, 3, "Should have burger + 2 veggie items")
        }
    }
    
    test("Form builder with validation") {
        let form = Form {
            textField("username", required: true) { $0.count >= 3 }
            emailField("email")
            textField("phone", required: false) { 
                $0.isEmpty || $0.allSatisfy { $0.isNumber || $0 == "-" }
            }
        }
        
        let validData = [
            "username": "john",
            "email": "john@example.com",
            "phone": "555-1234"
        ]
        assertTrue(form.validate(validData), "Valid data should pass")
        
        let invalidData = [
            "username": "jo",  // Too short
            "email": "invalid",  // No @
            "phone": "abc"
        ]
        assertFalse(form.validate(invalidData), "Invalid data should fail")
        
        let missingData = [
            "email": "test@example.com"
            // Missing required username
        ]
        assertFalse(form.validate(missingData), "Missing required field")
    }
    
    test("Layout builder with alignment") {
        let layout = hstack(alignment: .center) {
            text("Name:", width: 10)
            text("John Doe", width: 20)
            text("Age:", width: 5)
            text("25", width: 5)
        }
        
        let rendered = layout.render(totalWidth: 50)
        assertTrue(rendered.contains("Name:"), "Should contain labels")
        assertTrue(rendered.contains("John Doe"), "Should contain values")
        
        // Test right alignment
        let rightLayout = hstack(alignment: .right) {
            text("Total:", width: 10)
            text("$99.99", width: 10)
        }
        
        let rightRendered = rightLayout.render(totalWidth: 40)
        assertTrue(rightRendered.trimmingCharacters(in: .whitespaces).hasSuffix("$99.99"), 
                  "Should be right-aligned")
    }
    
    test("Nested layouts") {
        let layout = Layout {
            hstack {
                text("Header", width: 40)
            }
            
            for row in ["Row 1", "Row 2", "Row 3"] {
                hstack(alignment: .left) {
                    text("• \(row)", width: 40)
                }
            }
            
            hstack(alignment: .center) {
                text("Footer", width: 40)
            }
        }
        
        assertEqual(layout.elements.count, 5, "Header + 3 rows + footer")
    }
    
    runTests()
}

// Menu builder functions
func Menu(@MenuBuilder _ content: () -> [MenuItem]) -> Menu {
    return MenuType(items: content())
}

struct MenuType {
    let items: [MenuItem]
}

// Form builder function
func Form(@FormBuilder _ content: () -> Form) -> Form {
    return content()
}

// Layout builder function  
func Layout(@LayoutBuilder _ content: () -> Layout) -> Layout {
    return content()
}