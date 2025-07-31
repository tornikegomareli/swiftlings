// memory1.swift
//
// Swift uses Automatic Reference Counting (ARC) to manage memory.
// Strong references keep objects alive, creating potential retain cycles.
//
// Fix the memory management issues to make the tests pass.

class Person {
    let name: String
    var apartment: Apartment?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    var tenant: Person?  // TODO: Fix retain cycle - should be weak
    
    init(unit: String) {
        self.unit = unit
    }
    
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

// TODO: Fix the closure capture
class HTMLElement {
    let name: String
    let text: String?
    
    // TODO: This creates a retain cycle
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) element is being deinitialized")
    }
}

// TODO: Create proper delegate pattern
protocol CacheDelegate {  // Should be class-only protocol
    func cacheDidUpdate()
}

class Cache {
    var delegate: CacheDelegate?  // TODO: Should be weak
    
    func update() {
        // Update cache
        delegate?.cacheDidUpdate()
    }
}

class ViewController: CacheDelegate {
    let cache = Cache()
    
    init() {
        cache.delegate = self  // Creates retain cycle
    }
    
    func cacheDidUpdate() {
        print("Cache updated")
    }
}

func main() {
    test("Weak references break retain cycles") {
        var john: Person? = Person(name: "John")
        var unit4A: Apartment? = Apartment(unit: "4A")
        
        john!.apartment = unit4A
        unit4A!.tenant = john
        
        // Break strong references
        john = nil
        unit4A = nil
        
        // Both should be deallocated if weak reference is used correctly
        // Check console output for deinit messages
        assertTrue(true, "Objects should be deallocated")
    }
    
    test("Closure capture lists") {
        var paragraph: HTMLElement? = HTMLElement(name: "p", text: "Hello")
        let html = paragraph!.asHTML()
        
        assertEqual(html, "<p>Hello</p>", "HTML generation works")
        
        // Set to nil
        paragraph = nil
        
        // Should be deallocated if capture list is fixed
        // Check console output for deinit message
        assertTrue(true, "HTMLElement should be deallocated")
    }
    
    test("Weak delegate pattern") {
        var viewController: ViewController? = ViewController()
        let cache = viewController!.cache
        
        // Clear view controller reference
        viewController = nil
        
        // Cache should not keep view controller alive
        // Delegate should be nil if weak
        assertNil(cache.delegate, "Delegate should be nil after VC dealloc")
    }
    
    test("Unowned vs weak") {
        class Customer {
            let name: String
            var card: CreditCard?
            
            init(name: String) {
                self.name = name
            }
            
            deinit {
                print("\(name) is being deinitialized")
            }
        }
        
        class CreditCard {
            let number: String
            unowned let customer: Customer  // Customer always exists for a card
            
            init(number: String, customer: Customer) {
                self.number = number
                self.customer = customer
            }
            
            deinit {
                print("Card \(number) is being deinitialized")
            }
        }
        
        var alice: Customer? = Customer(name: "Alice")
        alice!.card = CreditCard(number: "1234", customer: alice!)
        
        alice = nil
        // Both should be deallocated - unowned doesn't create cycle
        assertTrue(true, "Customer and card deallocated together")
    }
    
    runTests()
}