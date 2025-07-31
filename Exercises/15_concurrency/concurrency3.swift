// concurrency3.swift
//
// Actors provide safe concurrent access to mutable state.
// MainActor ensures UI updates happen on the main thread.
//
// Fix the actor implementations to make the tests pass.

import Foundation

// TODO: Create an actor
class BankAccount {  // Should be actor
    private var balance: Double = 0
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func withdraw(_ amount: Double) -> Bool {
        if balance >= amount {
            balance -= amount
            return true
        }
        return false
    }
    
    func getBalance() -> Double {
        return balance
    }
}

// TODO: Create actor with isolated methods
actor Counter {
    private var value = 0
    
    // TODO: This should be nonisolated
    func getValue() -> Int {  // Can't access actor state synchronously
        return value
    }
    
    func increment() {
        value += 1
    }
    
    // TODO: Add async getter
    func getCurrentValue() -> Int {  // Should be async
        return value
    }
}

// TODO: Use MainActor
class ViewModel {  // Should be @MainActor
    var uiState = "Initial"
    
    func updateUI(_ newState: String) {
        uiState = newState
    }
    
    // TODO: Run on background
    func loadData() async {
        // This runs on MainActor - should run on background
        let data = await fetchHeavyData()
        updateUI(data)
    }
}

func fetchHeavyData() async -> String {
    try? await Task.sleep(nanoseconds: 100_000_000)
    return "Loaded data"
}

// TODO: Actor isolation
actor DataCache {
    private var cache: [String: String] = [:]
    
    func set(_ value: String, for key: String) {
        cache[key] = value
    }
    
    func get(_ key: String) -> String? {
        return cache[key]
    }
    
    // TODO: Allow synchronous access to immutable data
    var count: Int {  // Should be nonisolated
        return cache.count
    }
}

// TODO: Global actor
actor NetworkManager {  // Should be @globalActor
    static let shared = NetworkManager()
    
    private var activeRequests = 0
    
    func startRequest() {
        activeRequests += 1
    }
    
    func endRequest() {
        activeRequests -= 1
    }
    
    func getActiveCount() -> Int {
        return activeRequests
    }
}

func main() {
    test("Actor prevents data races") {
        let expectation = DispatchSemaphore(value: 0)
        let account = BankAccount()
        
        Task {
            // Concurrent deposits
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<100 {
                    group.addTask {
                        await account.deposit(1)
                    }
                }
            }
            
            let balance = await account.getBalance()
            assertEqual(balance, 100.0, "All deposits should be atomic")
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("Actor method isolation") {
        let expectation = DispatchSemaphore(value: 0)
        let counter = Counter()
        
        Task {
            await counter.increment()
            await counter.increment()
            
            let value = await counter.getCurrentValue()
            assertEqual(value, 2, "Counter should be 2")
            
            // Nonisolated method can be called synchronously
            let id = counter.id
            assertNotNil(id, "Should access nonisolated property")
            
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("MainActor for UI") {
        let expectation = DispatchSemaphore(value: 0)
        let viewModel = ViewModel()
        
        Task {
            await viewModel.loadData()
            
            // Check we're on main thread for UI updates
            await MainActor.run {
                assertEqual(viewModel.uiState, "Loaded data", "UI updated")
                assertTrue(Thread.isMainThread, "Should be on main thread")
            }
            
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("Actor with nonisolated members") {
        let expectation = DispatchSemaphore(value: 0)
        let cache = DataCache()
        
        Task {
            await cache.set("value1", for: "key1")
            await cache.set("value2", for: "key2")
            
            let value = await cache.get("key1")
            assertEqual(value, "value1", "Cache should work")
            
            // Nonisolated property can be accessed synchronously
            let count = cache.count
            assertEqual(count, 2, "Should have 2 items")
            
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    test("Global actor usage") {
        let expectation = DispatchSemaphore(value: 0)
        
        Task {
            await NetworkManager.shared.startRequest()
            await NetworkManager.shared.startRequest()
            
            let count = await NetworkManager.shared.getActiveCount()
            assertEqual(count, 2, "Should have 2 active requests")
            
            await NetworkManager.shared.endRequest()
            let newCount = await NetworkManager.shared.getActiveCount()
            assertEqual(newCount, 1, "Should have 1 active request")
            
            expectation.signal()
        }
        
        expectation.wait()
    }
    
    runTests()
}

// Extensions for nonisolated members
extension Counter {
    nonisolated var id: String {
        return "Counter"
    }
}

extension DataCache {
    nonisolated var isEmpty: Bool {
        return true  // Can't access cache here
    }
}