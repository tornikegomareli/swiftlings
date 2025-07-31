// advanced_types2.swift
//
// Opaque types, existential types, and type erasure.
// Understanding Swift's advanced type system features.
//
// Fix the type system features to make the tests pass.

// TODO: Create opaque return type
protocol Shape {
    func area() -> Double
}

struct Circle: Shape {
    let radius: Double
    
    func area() -> Double {
        return 3.14159 * radius * radius
    }
}

struct Rectangle: Shape {
    let width: Double
    let height: Double
    
    func area() -> Double {
        return width * height
    }
}

// TODO: Use opaque type
func makeShape() -> Shape {  // Should return `some Shape`
    return Circle(radius: 5)
}

// TODO: Create type eraser
protocol Publisher {
    associatedtype Output
    func publish(_ value: Output)
}

// Type eraser for Publisher
struct AnyPublisher<Output> {  // Should implement Publisher
    private let _publish: (Output) -> Void
    
    init<P: Publisher>(_ publisher: P) where P.Output == Output {
        // TODO: Store publisher's publish method
        self._publish = { _ in }
    }
    
    func publish(_ value: Output) {
        // TODO: Call stored method
    }
}

// TODO: Existential types
protocol Drawable {
    func draw() -> String
}

struct Point: Drawable {
    let x: Int
    let y: Int
    
    func draw() -> String {
        return "Point at (\(x), \(y))"
    }
}

struct Line: Drawable {
    let start: Point
    let end: Point
    
    func draw() -> String {
        return "Line from \(start.draw()) to \(end.draw())"
    }
}

// TODO: Use existential container
func drawAll(_ items: [Drawable]) -> String {  // Should accept any Drawable
    // TODO: Draw all items
    return ""
}

// TODO: Primary associated types
protocol Collection {  // Should have <Element>
    associatedtype Element
    var count: Int { get }
    func contains(_ element: Element) -> Bool
}

// TODO: Constrained existentials
func processNumbers(_ collection: Collection) -> Int {  // Should constrain Element to Int
    // Can't access elements without knowing Element type
    return 0
}

// TODO: some vs any
protocol Animal {
    func makeSound() -> String
}

struct Dog: Animal {
    func makeSound() -> String { "Woof" }
}

struct Cat: Animal {
    func makeSound() -> String { "Meow" }
}

// TODO: Return consistent type
func getPet(preferDogs: Bool) -> Animal {  // Should use appropriate return type
    if preferDogs {
        return Dog()
    } else {
        return Cat()
    }
}

// TODO: Type-erasing wrapper
protocol Storage {
    associatedtype Item
    mutating func store(_ item: Item)
    func retrieve() -> Item?
}

struct AnyStorage<Item> {  // Complete type eraser
    // TODO: Add storage implementation
    
    mutating func store(_ item: Item) {
        // TODO: Implement
    }
    
    func retrieve() -> Item? {
        // TODO: Implement
        return nil
    }
}

func main() {
    test("Opaque return types") {
        let shape = makeShape()
        assertEqual(shape.area(), 78.53975, "Circle area", accuracy: 0.00001)
        
        // Can't access Circle-specific properties
        // This is the point of opaque types
        assertTrue(shape is Circle, "Should be Circle")
    }
    
    test("Type erasure") {
        struct IntPublisher: Publisher {
            func publish(_ value: Int) {
                print("Publishing: \(value)")
            }
        }
        
        let publisher = IntPublisher()
        let erased = AnyPublisher(publisher)
        
        var published = 0
        let testPublisher = AnyPublisher<Int> { value in
            published = value
        }
        
        testPublisher.publish(42)
        assertEqual(published, 42, "Type-erased publish")
    }
    
    test("Existential types") {
        let drawables: [any Drawable] = [
            Point(x: 10, y: 20),
            Line(start: Point(x: 0, y: 0), end: Point(x: 100, y: 100)),
            Point(x: 50, y: 50)
        ]
        
        let result = drawAll(drawables)
        assertTrue(result.contains("Point at (10, 20)"), "First point")
        assertTrue(result.contains("Line from"), "Line included")
        assertTrue(result.contains("Point at (50, 50)"), "Last point")
    }
    
    test("Primary associated types") {
        struct IntArray: Collection {
            typealias Element = Int
            private let items: [Int]
            
            init(_ items: Int...) {
                self.items = items
            }
            
            var count: Int { items.count }
            
            func contains(_ element: Int) -> Bool {
                return items.contains(element)
            }
        }
        
        let numbers = IntArray(1, 2, 3, 4, 5)
        let sum = processNumbers(numbers)
        assertEqual(sum, 15, "Sum of numbers")
    }
    
    test("some vs any") {
        let pet1 = getPet(preferDogs: true)
        let pet2 = getPet(preferDogs: false)
        
        assertEqual(pet1.makeSound(), "Woof", "Dog sound")
        assertEqual(pet2.makeSound(), "Meow", "Cat sound")
        
        // Both work with existential any
        let animals: [any Animal] = [pet1, pet2]
        assertEqual(animals.count, 2, "Two animals")
    }
    
    test("Complete type eraser") {
        struct StringStorage: Storage {
            private var value: String?
            
            mutating func store(_ item: String) {
                value = item
            }
            
            func retrieve() -> String? {
                return value
            }
        }
        
        var storage = AnyStorage<String>(StringStorage())
        storage.store("Hello")
        assertEqual(storage.retrieve(), "Hello", "Retrieved value")
        
        // Can use with any Storage type
        struct ArrayStorage<T>: Storage {
            private var items: [T] = []
            
            mutating func store(_ item: T) {
                items.append(item)
            }
            
            func retrieve() -> T? {
                return items.last
            }
        }
        
        var arrayStorage = AnyStorage<Int>(ArrayStorage<Int>())
        arrayStorage.store(42)
        arrayStorage.store(99)
        assertEqual(arrayStorage.retrieve(), 99, "Last stored value")
    }
    
    runTests()
}

// Extension for approximate equality
extension Double {
    func isApproximatelyEqual(to other: Double, accuracy: Double) -> Bool {
        return abs(self - other) <= accuracy
    }
}

func assertEqual(_ actual: Double, _ expected: Double, _ message: String, accuracy: Double) {
    if actual.isApproximatelyEqual(to: expected, accuracy: accuracy) {
        // Pass
    } else {
        assertionFailure("\(message): expected \(expected), got \(actual)")
    }
}