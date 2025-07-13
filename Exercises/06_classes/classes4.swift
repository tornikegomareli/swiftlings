// classes4.swift
//
// Classes can use lazy properties, property observers, and class methods.
// Understanding when to use class vs static is important.
//
// Fix the property declarations and class methods to make the tests pass.

class DataLoader {
    let url: String
    
    // TODO: Make this lazy
    var data: String = {  // Missing lazy keyword
        print("Loading data from \(self.url)")  // Can't use self here without lazy
        return "Data from \(self.url)"
    }()
    
    init(url: String) {
        self.url = url
        print("DataLoader initialized")
    }
}

class Configuration {
    // TODO: Add static property for shared instance
    let shared = Configuration()  // Should be static
    
    var settings: [String: Any] = [:] {
        // TODO: Add property observer
        didSet {
            // Print when settings change
        }
    }
    
    // TODO: Make this private to enforce singleton
    init() {}
    
    // TODO: Change to class method that can be overridden
    static func reset() {  // static can't be overridden
        shared.settings = [:]
    }
}

class DebugConfiguration: Configuration {
    // TODO: Override the reset method
    func reset() {  // Missing override and class keyword
        super.reset()
        settings["debug"] = true
    }
}

class Counter {
    // TODO: Add static property for total count across all instances
    var totalCount = 0  // Should be static
    
    var count = 0 {
        // TODO: Update totalCount when count changes
        didSet {
            // Update the class-level total
        }
    }
    
    func increment() {
        count += 1
    }
    
    // TODO: Add class method to get total
    func getTotalCount() -> Int {  // Should be class/static method
        return totalCount
    }
}

func main() {
    test("Lazy properties") {
        print("Creating DataLoader...")
        let loader = DataLoader(url: "https://example.com")
        print("DataLoader created, data not loaded yet")
        
        // Access lazy property
        let data = loader.data
        assertEqual(data, "Data from https://example.com", "Lazy loaded data")
        
        // Second access doesn't reload
        let data2 = loader.data
        assertEqual(data2, "Data from https://example.com", "Same data returned")
    }
    
    test("Singleton and class methods") {
        Configuration.shared.settings["theme"] = "dark"
        assertEqual(Configuration.shared.settings["theme"] as? String, "dark", 
                   "Singleton settings")
        
        Configuration.reset()
        assertTrue(Configuration.shared.settings.isEmpty, 
                  "Settings cleared after reset")
        
        let debug = DebugConfiguration()
        DebugConfiguration.reset()
        assertEqual(debug.settings["debug"] as? Bool, true, 
                   "Debug configuration adds debug flag")
    }
    
    test("Static properties") {
        assertEqual(Counter.getTotalCount(), 0, "Initial total is 0")
        
        let c1 = Counter()
        c1.increment()
        c1.increment()
        
        let c2 = Counter()
        c2.increment()
        
        assertEqual(Counter.getTotalCount(), 3, "Total across all instances")
        assertEqual(c1.count, 2, "Instance 1 count")
        assertEqual(c2.count, 1, "Instance 2 count")
    }
    
    runTests()
}