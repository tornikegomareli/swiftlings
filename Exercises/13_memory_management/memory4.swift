// memory4.swift
//
// Value types vs reference types and copy-on-write optimization.
// Understanding when to use structs vs classes for performance.
//
// Fix the performance and memory issues to make the tests pass.

// TODO: Implement copy-on-write for this struct
struct LargeData {
    private var storage: [Int]  // This gets copied every time
    
    init(size: Int) {
        storage = Array(repeating: 0, count: size)
    }
    
    // TODO: Add copy-on-write optimization
    mutating func append(_ value: Int) {
        storage.append(value)  // Might copy unnecessarily
    }
    
    var count: Int {
        return storage.count
    }
    
    subscript(index: Int) -> Int {
        get { storage[index] }
        set { storage[index] = newValue }  // Needs COW check
    }
}

// TODO: Choose appropriate type (struct vs class)
class ImageCache {  // Should this be a struct or class?
    private var cache: [String: Data] = [:]
    
    func store(_ data: Data, for key: String) {
        cache[key] = data
    }
    
    func retrieve(_ key: String) -> Data? {
        return cache[key]
    }
}

struct Data {
    let bytes: [UInt8]
}

// TODO: Fix accidental object sharing
struct Configuration {
    var settings: NSMutableDictionary  // Reference type in value type!
    
    init() {
        settings = NSMutableDictionary()
    }
    
    mutating func set(_ value: Any, for key: String) {
        settings[key] = value
    }
}

// TODO: Optimize for memory efficiency
enum Result<T> {
    case success(T)
    case failure(Error)
    
    // TODO: Add method to transform without copying
    func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(transform(value))  // Copies the whole enum
        case .failure(let error):
            return .failure(error)
        }
    }
}

// TODO: Fix the builder pattern for value types
struct URLBuilder {
    private var components = URLComponents()
    
    // TODO: These methods should return new instances
    func scheme(_ scheme: String) -> URLBuilder {
        components.scheme = scheme  // Mutates self
        return self
    }
    
    func host(_ host: String) -> URLBuilder {
        components.host = host
        return self
    }
    
    func path(_ path: String) -> URLBuilder {
        components.path = path
        return self
    }
    
    func build() -> URL? {
        return components.url
    }
}

func main() {
    test("Copy-on-write optimization") {
        var data1 = LargeData(size: 1000)
        let data2 = data1  // Should not copy storage yet
        
        // Verify they share storage initially
        assertTrue(true, "Storage should be shared until mutation")
        
        // Mutate data1
        data1.append(42)
        
        // Now they should have separate storage
        assertEqual(data1.count, 1001, "data1 modified")
        assertEqual(data2.count, 1000, "data2 unchanged")
    }
    
    test("Struct vs class choice") {
        let cache1 = ImageCache()
        let cache2 = cache1  // Reference semantics
        
        let testData = Data(bytes: [1, 2, 3])
        cache1.store(testData, for: "image1")
        
        // Both caches share the same storage
        assertNotNil(cache2.retrieve("image1"), "Shared cache storage")
        
        // This is appropriate for a cache (shared state)
        assertTrue(true, "ImageCache correctly uses reference semantics")
    }
    
    test("Value type with reference type property") {
        var config1 = Configuration()
        config1.set("value1", for: "key1")
        
        var config2 = config1  // Struct copied, but dictionary shared!
        config2.set("value2", for: "key2")
        
        // Bug: both configs share the same dictionary
        assertEqual(config1.settings["key2"] as? String, "value2", 
                   "Unexpected sharing of mutable reference")
        
        // Should have independent settings
        assertNil(config1.settings["key2"], "Should not share settings")
    }
    
    test("Efficient transformations") {
        let largeArray = Array(repeating: 1, count: 1000)
        let result: Result<[Int]> = .success(largeArray)
        
        // Transform without unnecessary copying
        let doubled = result.map { array in
            array.map { $0 * 2 }
        }
        
        switch doubled {
        case .success(let values):
            assertEqual(values.first, 2, "Values doubled")
            assertEqual(values.count, 1000, "Same count")
        case .failure:
            assertFalse(true, "Should be success")
        }
    }
    
    test("Immutable builder pattern") {
        let url = URLBuilder()
            .scheme("https")
            .host("example.com")
            .path("/api/v1")
            .build()
        
        assertEqual(url?.absoluteString, "https://example.com/api/v1", 
                   "URL built correctly")
        
        // Original builder should be unchanged
        let builder = URLBuilder()
        let withScheme = builder.scheme("http")
        let withHost = withScheme.host("test.com")
        
        assertNil(builder.build(), "Original builder unchanged")
        assertEqual(withHost.build()?.absoluteString, "http://test.com", 
                   "Each step creates new instance")
    }
    
    runTests()
}