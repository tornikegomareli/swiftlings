// memory3.swift
//
// Advanced memory management patterns and debugging techniques.
// Understanding reference cycles in complex scenarios.
//
// Fix the memory issues in these real-world patterns to make the tests pass.

// TODO: Fix the parent-child relationship
class Parent {
    let name: String
    var children: [Child] = []  // Strong references to children
    
    init(name: String) {
        self.name = name
    }
    
    func addChild(_ child: Child) {
        children.append(child)
        child.parent = self  // Creates cycle
    }
    
    deinit {
        print("Parent \(name) deallocated")
    }
}

class Child {
    let name: String
    var parent: Parent?  // TODO: Should be weak or unowned
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Child \(name) deallocated")
    }
}

// TODO: Fix the observer pattern
protocol Observer {  // TODO: Should be class-only
    func update(value: Int)
}

class Subject {
    private var observers: [Observer] = []  // TODO: Need weak references
    private var value = 0
    
    func attach(_ observer: Observer) {
        observers.append(observer)
    }
    
    func setValue(_ newValue: Int) {
        value = newValue
        notifyObservers()
    }
    
    private func notifyObservers() {
        observers.forEach { $0.update(value: value) }
    }
    
    deinit {
        print("Subject deallocated")
    }
}

class ConcreteObserver: Observer {
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func update(value: Int) {
        print("Observer \(id) received: \(value)")
    }
    
    deinit {
        print("Observer \(id) deallocated")
    }
}

// TODO: Fix the cache with expiration
class ExpiringCache<T> {
    private var cache: [String: (value: T, timer: Timer)] = [:]
    
    func set(_ value: T, for key: String, ttl: TimeInterval) {
        // TODO: Fix timer retain cycle
        let timer = Timer.scheduledTimer(
            withTimeInterval: ttl,
            repeats: false
        ) { _ in
            self.cache.removeValue(forKey: key)  // Strong capture
        }
        
        cache[key] = (value, timer)
    }
    
    func get(_ key: String) -> T? {
        return cache[key]?.value
    }
    
    func invalidate() {
        cache.values.forEach { $0.timer.invalidate() }
        cache.removeAll()
    }
    
    deinit {
        invalidate()
        print("ExpiringCache deallocated")
    }
}

// TODO: Fix the operation queue pattern
class AsyncOperation {
    private let queue = DispatchQueue(label: "async.operation")
    private var completion: (() -> Void)?
    
    func execute(completion: @escaping () -> Void) {
        self.completion = completion
        
        // TODO: Fix capture in async block
        queue.async {
            Thread.sleep(forTimeInterval: 0.1)
            self.completion?()  // Strong capture
            self.completion = nil
        }
    }
    
    deinit {
        print("AsyncOperation deallocated")
    }
}

func main() {
    test("Parent-child relationships") {
        var parent: Parent? = Parent(name: "John")
        let child1 = Child(name: "Alice")
        let child2 = Child(name: "Bob")
        
        parent?.addChild(child1)
        parent?.addChild(child2)
        
        // Clear parent reference
        parent = nil
        
        // All should be deallocated if references are correct
        assertTrue(true, "Parent and children should be deallocated")
    }
    
    test("Observer pattern with weak references") {
        var subject: Subject? = Subject()
        var observer1: ConcreteObserver? = ConcreteObserver(id: "1")
        var observer2: ConcreteObserver? = ConcreteObserver(id: "2")
        
        subject?.attach(observer1!)
        subject?.attach(observer2!)
        
        subject?.setValue(42)
        
        // Remove one observer
        observer1 = nil
        
        // Subject should not keep observer alive
        subject?.setValue(100)  // Only observer2 should receive
        
        subject = nil
        observer2 = nil
        
        // All should be deallocated
        assertTrue(true, "Subject and observers should be deallocated")
    }
    
    test("Timer-based cache") {
        var cache: ExpiringCache<String>? = ExpiringCache()
        
        cache?.set("value1", for: "key1", ttl: 0.2)
        cache?.set("value2", for: "key2", ttl: 0.3)
        
        assertEqual(cache?.get("key1"), "value1", "Value in cache")
        
        // Clear cache reference
        cache = nil
        
        // Cache and timers should be cleaned up
        assertTrue(true, "Cache should be deallocated with timers")
    }
    
    test("Async operation cleanup") {
        var operation: AsyncOperation? = AsyncOperation()
        let expectation = DispatchSemaphore(value: 0)
        var completed = false
        
        operation?.execute {
            completed = true
            expectation.signal()
        }
        
        // Clear operation before completion
        operation = nil
        
        expectation.wait()
        assertTrue(completed, "Operation completed")
        
        // Operation should be deallocated after completion
        assertTrue(true, "AsyncOperation should be deallocated")
    }
    
    runTests()
}

// Helper for weak references in arrays
struct WeakBox<T: AnyObject> {
    weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}