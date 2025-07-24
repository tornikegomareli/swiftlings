// protocols4.swift
//
// Protocols are commonly used for delegation patterns and can have
// class-only constraints for reference semantics.
//
// Fix the delegation pattern and protocol constraints to make the tests pass.

// TODO: Define a class-only protocol for delegation
protocol DownloadDelegate {  // Missing class constraint
    func downloadDidStart()
    func downloadDidFinish(data: String)
    func downloadDidFail(error: String)
}

class Downloader {
    // TODO: Fix the delegate property (should be weak to avoid retain cycles)
    var delegate: DownloadDelegate?
    
    func startDownload() {
        delegate?.downloadDidStart()
        
        // Simulate download
        let success = true
        
        if success {
            delegate?.downloadDidFinish(data: "Downloaded content")
        } else {
            delegate?.downloadDidFail(error: "Network error")
        }
    }
}

// TODO: Make this class conform to DownloadDelegate
class ViewController {  // Missing conformance
    var statusText = "Ready"
    let downloader = Downloader()
    
    init() {
        // TODO: Set self as delegate
    }
    
    // Implement delegate methods
}

// TODO: Define a protocol that can only be adopted by classes
protocol Identifiable {  // How to make it class-only?
    var id: String { get set }
}

// TODO: Try to make a struct conform (this should fail with class-only protocol)
struct Product: Identifiable {  // This should cause an error if protocol is class-only
    var id: String
}

// For testing purposes, make a class version
class ProductClass: Identifiable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}

func main() {
    test("Delegation pattern") {
        let viewController = ViewController()
        
        // Start download
        viewController.downloader.startDownload()
        
        // Check that delegate methods were called
        assertEqual(viewController.statusText, "Download complete: Downloaded content", 
                   "Status should be updated by delegate")
    }
    
    test("Weak delegate reference") {
        var viewController: ViewController? = ViewController()
        let downloader = viewController!.downloader
        
        // Clear strong reference
        viewController = nil
        
        // Delegate should be nil (weak reference)
        assertNil(downloader.delegate, "Delegate should be released")
    }
    
    test("Class-only protocol") {
        // This test verifies that only classes can conform
        let product = ProductClass(id: "P123")
        product.id = "P456"
        assertEqual(product.id, "P456", "Can modify class property")
        
        // Note: The struct version should not compile if protocol is properly constrained
    }
    
    runTests()
}

// Implementations for delegate methods
extension ViewController: DownloadDelegate {
    func downloadDidStart() {
        statusText = "Downloading..."
    }
    
    func downloadDidFinish(data: String) {
        statusText = "Download complete: \(data)"
    }
    
    func downloadDidFail(error: String) {
        statusText = "Download failed: \(error)"
    }
}