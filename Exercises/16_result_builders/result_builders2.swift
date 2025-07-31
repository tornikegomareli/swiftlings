// result_builders2.swift
//
// Advanced result builder features including expression building and limitations.
// Building complex DSLs with result builders.
//
// Fix the advanced result builder features to make the tests pass.

// TODO: Create a query builder
@resultBuilder
struct QueryBuilder {
    static func buildBlock(_ components: QueryComponent...) -> Query {
        return Query(components: [])  // Should combine components
    }
    
    static func buildExpression(_ table: String) -> QueryComponent {
        return .from(table)
    }
    
    static func buildExpression(_ component: QueryComponent) -> QueryComponent {
        return component
    }
    
    // TODO: Add support for optional WHERE clause
    static func buildOptional(_ component: QueryComponent?) -> QueryComponent {
        return component ?? .empty
    }
    
    // TODO: Support limited availability
    static func buildLimitedAvailability(_ component: QueryComponent) -> QueryComponent {
        return component
    }
}

enum QueryComponent {
    case select([String])
    case from(String)
    case `where`(String)
    case orderBy(String, ascending: Bool)
    case empty
}

struct Query {
    let components: [QueryComponent]
    
    func toSQL() -> String {
        // TODO: Build SQL string from components
        return "SELECT * FROM table"
    }
}

// Query DSL functions
func select(_ columns: String...) -> QueryComponent {
    return .select(columns)
}

func from(_ table: String) -> QueryComponent {
    return .from(table)
}

func `where`(_ condition: String) -> QueryComponent {
    return .where(condition)
}

func orderBy(_ column: String, ascending: Bool = true) -> QueryComponent {
    return .orderBy(column, ascending: ascending)
}

// TODO: Create a routing builder
@resultBuilder
struct RouteBuilder {
    static func buildBlock(_ components: Route...) -> [Route] {
        return components
    }
    
    // TODO: Support for-in loops
    static func buildArray(_ components: [[Route]]) -> [Route] {
        return []  // Should flatten
    }
    
    // TODO: Support finalize
    static func buildFinalResult(_ component: [Route]) -> Router {
        return Router(routes: component)
    }
}

struct Route {
    let method: String
    let path: String
    let handler: () -> String
}

struct Router {
    let routes: [Route]
    
    func handle(method: String, path: String) -> String? {
        // TODO: Find matching route and call handler
        return nil
    }
}

func get(_ path: String, handler: @escaping () -> String) -> Route {
    return Route(method: "GET", path: path, handler: handler)
}

func post(_ path: String, handler: @escaping () -> String) -> Route {
    return Route(method: "POST", path: path, handler: handler)
}

// TODO: Create a validation builder
@resultBuilder
struct ValidationBuilder {
    static func buildBlock(_ components: Validator...) -> Validator {
        return Validator { value in
            // TODO: All validators must pass
            return true
        }
    }
    
    static func buildExpression(_ validator: @escaping (String) -> Bool) -> Validator {
        return Validator(validate: validator)
    }
    
    static func buildExpression(_ validator: Validator) -> Validator {
        return validator
    }
}

struct Validator {
    let validate: (String) -> Bool
    
    func callAsFunction(_ value: String) -> Bool {
        return validate(value)
    }
}

// Validation DSL
func minLength(_ length: Int) -> Validator {
    return Validator { $0.count >= length }
}

func maxLength(_ length: Int) -> Validator {
    return Validator { $0.count <= length }
}

func contains(_ substring: String) -> Validator {
    return Validator { $0.contains(substring) }
}

func main() {
    test("Query builder") {
        let query = Query {
            select("id", "name", "email")
            from("users")
            where("age > 18")
            orderBy("name")
        }
        
        let sql = query.toSQL()
        assertEqual(sql, 
                   "SELECT id, name, email FROM users WHERE age > 18 ORDER BY name ASC",
                   "Should build correct SQL")
    }
    
    test("Optional query components") {
        let includeWhere = false
        
        let query = Query {
            select("*")
            from("products")
            if includeWhere {
                where("price < 100")
            }
            orderBy("price", ascending: false)
        }
        
        let sql = query.toSQL()
        assertEqual(sql,
                   "SELECT * FROM products ORDER BY price DESC",
                   "Should skip optional WHERE")
    }
    
    test("Route builder") {
        let router = Router {
            get("/") { "Home" }
            get("/about") { "About" }
            post("/users") { "User created" }
            
            // Dynamic routes
            for path in ["/api/v1", "/api/v2"] {
                get(path) { "API \(path)" }
            }
        }
        
        assertEqual(router.handle(method: "GET", path: "/"), "Home", "Home route")
        assertEqual(router.handle(method: "POST", path: "/users"), "User created", "POST route")
        assertEqual(router.handle(method: "GET", path: "/api/v1"), "API /api/v1", "Dynamic route")
        assertNil(router.handle(method: "GET", path: "/unknown"), "Unknown route")
    }
    
    test("Validation builder") {
        let emailValidator = Validator {
            minLength(5)
            maxLength(50)
            contains("@")
            { $0.contains(".") }  // Inline validator
        }
        
        assertTrue(emailValidator("test@example.com"), "Valid email")
        assertFalse(emailValidator("test"), "Too short")
        assertFalse(emailValidator("test@com"), "Missing dot")
        assertFalse(emailValidator("a@b.c" + String(repeating: "x", count: 50)), "Too long")
    }
    
    runTests()
}

// Query builder implementation
func Query(@QueryBuilder _ builder: () -> Query) -> Query {
    return builder()
}

// Router builder implementation  
func Router(@RouteBuilder _ builder: () -> Router) -> Router {
    return builder()
}

// Validator builder implementation
func Validator(@ValidationBuilder _ builder: () -> Validator) -> Validator {
    return builder()
}