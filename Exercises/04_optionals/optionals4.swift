// optionals4.swift
//
// The nil-coalescing operator (??) provides a default value for optionals.
// Multiple ?? operators can be chained for fallback values.
//
// Fix the nil-coalescing operations to make the tests pass.

func userPreferences() -> (theme: String, fontSize: Int, notifications: Bool) {
    // Simulating user preferences that might not be set
    let savedTheme: String? = nil
    let savedFontSize: Int? = nil
    let savedNotifications: Bool? = false
    
    // TODO: Provide default theme of "light"
    let theme = savedTheme  // Add nil-coalescing
    
    // TODO: Chain multiple fallbacks: saved -> recommended -> default
    let recommendedSize: Int? = nil
    let fontSize = savedFontSize ?? recommendedSize  // Need final fallback to 16
    
    // TODO: Use parentheses to control precedence
    let notifications = savedNotifications ?? true && false  // Should be (saved ?? true) && false
    
    return (theme, fontSize, notifications)
}

func parseConfiguration() -> [String: Any] {
    // Simulating config values that might be missing
    let config: [String: Any?] = [
        "host": nil,
        "port": 8080,
        "timeout": nil,
        "debug": nil
    ]
    
    var result: [String: Any] = [:]
    
    // TODO: Use nil-coalescing with dictionary access
    result["host"] = config["host"]  // Should default to "localhost"
    
    // TODO: Handle double optionals (dict access returns Any??)
    result["port"] = config["port"] ?? 3000  // This won't work as expected
    
    // TODO: Provide different defaults for different keys
    result["timeout"] = config["timeout"]  // Should default to 30
    result["debug"] = config["debug"]  // Should default to false
    
    return result
}

func main() {
    test("User preferences with defaults") {
        let prefs = userPreferences()
        assertEqual(prefs.theme, "light", "Should use default theme")
        assertEqual(prefs.fontSize, 16, "Should use final default size")
        assertFalse(prefs.notifications, "Should be false after AND operation")
    }
    
    test("Configuration parsing") {
        let config = parseConfiguration()
        assertEqual(config["host"] as? String, "localhost", "Default host")
        assertEqual(config["port"] as? Int, 8080, "Existing port value")
        assertEqual(config["timeout"] as? Int, 30, "Default timeout")
        assertEqual(config["debug"] as? Bool, false, "Default debug flag")
    }
    
    runTests()
}