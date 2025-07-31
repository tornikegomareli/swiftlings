// closures2.swift
//
// Escaping closures outlive the function they're passed to.
// Autoclosures delay evaluation until they're called.
//
// Fix the escaping and autoclosure usage to make the tests pass.

class AsyncManager {
    private var completionHandlers: [() -> Void] = []
    
    // TODO: Mark closure parameter as @escaping
    func addCompletion(_ handler: () -> Void) {
        completionHandlers.append(handler)  // Can't store non-escaping closure
    }
    
    func executeAll() {
        for handler in completionHandlers {
            handler()
        }
        completionHandlers.removeAll()
    }
}

// TODO: Use @autoclosure
func debugLog(_ message: String, condition: Bool) {  // Make message autoclosure
    if condition {
        print("DEBUG: \(message)")
    }
}

// TODO: Create function with multiple closure parameters
func fetchData(
    onSuccess: (String) -> Void,  // Should be @escaping
    onFailure: (Error) -> Void    // Should be @escaping
) {
    // Simulate async operation
    DispatchQueue.global().async {
        let success = Bool.random()
        
        DispatchQueue.main.async {
            if success {
                onSuccess("Data loaded")  // Won't compile without @escaping
            } else {
                onFailure(NSError(domain: "Test", code: 1))
            }
        }
    }
}

// TODO: Fix closure capture list
class Counter {
    var value = 0
    
    func incrementAsync(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.value += 1  // Strong reference cycle risk
            completion()
        }
    }
    
    func incrementAsyncSafe(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.value += 1  // Fixed with capture list
            completion()
        }
    }
}

// TODO: Use escaping closure with Result type
typealias CompletionHandler<T> = (Result<T, Error>) -> Void

func performAsyncOperation<T>(
    producing value: T,
    completion: CompletionHandler<T>  // Should be @escaping
) {
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 0.1)
        completion(.success(value))
    }
}

func main() {
    test("Escaping closures") {
        let manager = AsyncManager()
        var results: [String] = []
        
        manager.addCompletion { results.append("First") }
        manager.addCompletion { results.append("Second") }
        manager.addCompletion { results.append("Third") }
        
        assertEqual(results, [], "Handlers not executed yet")
        
        manager.executeAll()
        assertEqual(results, ["First", "Second", "Third"], "All handlers executed")
    }
    
    test("Autoclosure") {
        var logMessages: [String] = []
        
        // Override print for testing
        let originalPrint = print
        func print(_ items: Any...) {
            logMessages.append(items.map { "\($0)" }.joined())
        }
        
        debugLog("This should log", condition: true)
        debugLog("This should not log", condition: false)
        
        // Complex expression that shouldn't be evaluated
        debugLog("\(1 + 2 + 3 + 4 + 5)", condition: false)
        
        assertEqual(logMessages.count, 1, "Only one message logged")
        assertTrue(logMessages[0].contains("This should log"), "Correct message")
    }
    
    test("Multiple escaping closures") {
        let expectation = DispatchSemaphore(value: 0)
        var result: String?
        
        fetchData(
            onSuccess: { data in
                result = data
                expectation.signal()
            },
            onFailure: { error in
                result = "Error: \(error)"
                expectation.signal()
            }
        )
        
        expectation.wait()
        assertNotNil(result, "Should have a result")
        assertTrue(result == "Data loaded" || result!.contains("Error"), 
                  "Valid result")
    }
    
    test("Capture lists") {
        var counter: Counter? = Counter()
        let expectation = DispatchSemaphore(value: 0)
        
        counter?.incrementAsyncSafe {
            expectation.signal()
        }
        
        let weakCounter = counter
        counter = nil  // Release strong reference
        
        expectation.wait()
        assertNil(weakCounter, "Counter should be released")
    }
    
    test("Generic escaping closures") {
        let expectation = DispatchSemaphore(value: 0)
        var result: Int?
        
        performAsyncOperation(producing: 42) { asyncResult in
            switch asyncResult {
            case .success(let value):
                result = value
            case .failure:
                result = -1
            }
            expectation.signal()
        }
        
        expectation.wait()
        assertEqual(result, 42, "Async operation completed")
    }
    
    runTests()
}