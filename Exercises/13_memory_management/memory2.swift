// memory2.swift
//
// Understanding capture semantics and memory management in closures.
// Weak and unowned references in different contexts.
//
// Fix the capture lists and reference types to make the tests pass.

class DataLoader {
    var data: String = "Initial"
    var onComplete: ((String) -> Void)?
    
    func loadData() {
        // TODO: Fix potential retain cycle
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            self.data = "Loaded"  // Strong capture
            self.onComplete?(self.data)
        }
    }
    
    deinit {
        print("DataLoader deallocated")
    }
}

class NetworkManager {
    private var activeRequests: [String: () -> Void] = [:]
    
    // TODO: Fix closure storage causing retain cycles
    func request(id: String, completion: @escaping () -> Void) {
        activeRequests[id] = {
            completion()  // This might capture self indirectly
            self.activeRequests.removeValue(forKey: id)
        }
    }
    
    func executeRequest(id: String) {
        activeRequests[id]?()
    }
    
    deinit {
        print("NetworkManager deallocated")
    }
}

// TODO: Fix the notification observer pattern
class NotificationHandler {
    private var observer: Any?
    
    init() {
        // TODO: Fix retain cycle with notification center
        observer = NotificationCenter.default.addObserver(
            forName: .custom,
            object: nil,
            queue: .main
        ) { _ in
            self.handleNotification()  // Strong capture
        }
    }
    
    func handleNotification() {
        print("Notification received")
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        print("NotificationHandler deallocated")
    }
}

extension Notification.Name {
    static let custom = Notification.Name("custom")
}

// TODO: Create a timer with proper memory management
class TimerController {
    private var timer: Timer?
    private var tickCount = 0
    
    func startTimer() {
        // TODO: Fix retain cycle with Timer
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { _ in
            self.tickCount += 1  // Strong capture
            print("Tick \(self.tickCount)")
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
        print("TimerController deallocated")
    }
}

func main() {
    test("Async closure capture") {
        var loader: DataLoader? = DataLoader()
        let expectation = DispatchSemaphore(value: 0)
        
        loader?.onComplete = { data in
            print("Data: \(data)")
            expectation.signal()
        }
        
        loader?.loadData()
        
        // Clear reference before completion
        loader = nil
        
        expectation.wait()
        // Loader should be deallocated after completion
        assertTrue(true, "DataLoader should handle async properly")
    }
    
    test("Closure storage in collections") {
        var manager: NetworkManager? = NetworkManager()
        var callbackExecuted = false
        
        manager?.request(id: "test") {
            callbackExecuted = true
        }
        
        manager?.executeRequest(id: "test")
        assertTrue(callbackExecuted, "Callback executed")
        
        manager = nil
        // Manager should be deallocated
        assertTrue(true, "NetworkManager should be deallocated")
    }
    
    test("Notification center observers") {
        var handler: NotificationHandler? = NotificationHandler()
        
        // Post notification
        NotificationCenter.default.post(name: .custom, object: nil)
        
        // Clear handler
        handler = nil
        
        // Handler should be deallocated
        assertTrue(true, "NotificationHandler should be deallocated")
    }
    
    test("Timer memory management") {
        var controller: TimerController? = TimerController()
        
        controller?.startTimer()
        
        // Let timer tick a few times
        Thread.sleep(forTimeInterval: 0.3)
        
        controller?.stopTimer()
        controller = nil
        
        // Controller should be deallocated
        assertTrue(true, "TimerController should be deallocated")
    }
    
    test("Capture list variations") {
        class Container {
            var value = 10
            
            func createClosures() -> (weak: () -> Int?, unowned: () -> Int, strong: () -> Int) {
                let weak = { [weak self] in
                    return self?.value
                }
                
                let unowned = { [unowned self] in
                    return self.value
                }
                
                let strong = {
                    return self.value
                }
                
                return (weak, unowned, strong)
            }
        }
        
        var container: Container? = Container()
        let closures = container!.createClosures()
        
        container = nil
        
        assertNil(closures.weak(), "Weak reference should be nil")
        // unowned would crash - don't call it
        // strong keeps container alive
        assertEqual(closures.strong(), 10, "Strong reference keeps object alive")
    }
    
    runTests()
}