// classes2.swift
//
// Classes support inheritance, allowing you to build hierarchies.
// Subclasses can override methods and properties from their superclass.
//
// Fix the inheritance and overrides to make the tests pass.

class Animal {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // TODO: Make this overridable
    func makeSound() -> String {  // Missing something to allow override
        return "Some generic animal sound"
    }
    
    // TODO: Make this overridable
    final var description: String {  // 'final' prevents override
        return "\(name) is \(age) years old"
    }
}

class Dog: Animal {
    var breed: String
    
    // TODO: Fix the initializer
    init(name: String, age: Int, breed: String) {
        self.breed = breed
        // Call super.init AFTER setting own properties
        super.init(name: name, age: age)
    }
    
    // TODO: Override the makeSound method
    func makeSound() -> String {  // Missing override keyword
        return "Woof!"
    }
    
    // TODO: Override the description property
    var description: String {  // Missing override keyword
        return "\(super.description) and is a \(breed)"
    }
}

class Cat: Animal {
    var isIndoor: Bool
    
    init(name: String, age: Int, isIndoor: Bool) {
        // TODO: Fix initialization order
        super.init(name: name, age: age)  // Should be after setting properties
        self.isIndoor = isIndoor
    }
    
    // TODO: Override makeSound
    override func makeSound() -> String {
        return "Meow"  // Should return "Meow!"
    }
}

func main() {
    test("Basic inheritance") {
        let animal = Animal(name: "Generic", age: 5)
        let dog = Dog(name: "Buddy", age: 3, breed: "Golden Retriever")
        let cat = Cat(name: "Whiskers", age: 2, isIndoor: true)
        
        assertEqual(animal.makeSound(), "Some generic animal sound", "Animal sound")
        assertEqual(dog.makeSound(), "Woof!", "Dog sound")
        assertEqual(cat.makeSound(), "Meow!", "Cat sound")
    }
    
    test("Property override") {
        let dog = Dog(name: "Max", age: 4, breed: "Labrador")
        assertEqual(dog.description, "Max is 4 years old and is a Labrador", 
                   "Dog description should include breed")
    }
    
    test("Polymorphism") {
        let animals: [Animal] = [
            Animal(name: "Generic", age: 1),
            Dog(name: "Fido", age: 2, breed: "Poodle"),
            Cat(name: "Mittens", age: 3, isIndoor: false)
        ]
        
        let sounds = animals.map { $0.makeSound() }
        assertEqual(sounds, ["Some generic animal sound", "Woof!", "Meow!"], 
                   "Polymorphic method calls")
    }
    
    runTests()
}