// optionals3.swift
//
// Optional chaining allows you to access properties and methods on optionals.
// If any link in the chain is nil, the whole expression returns nil.
//
// Fix the optional chaining to make the tests pass.

struct Person {
    var name: String
    var address: Address?
}

struct Address {
    var street: String
    var city: String
    var zipCode: String?
}

func getPersonInfo() -> (street: String?, city: String?, zip: String?) {
    let person1: Person? = Person(name: "Alice", 
                                  address: Address(street: "123 Main St", 
                                                 city: "Boston", 
                                                 zipCode: "02101"))
    let person2: Person? = Person(name: "Bob", address: nil)
    let person3: Person? = nil
    
    // TODO: Use optional chaining to get street (missing ? operator)
    let street = person1.address.street
    
    // TODO: Chain through multiple optionals to get city
    let city = person2?.address.city  // This will be nil - try person1
    
    // TODO: Handle nested optionals (zipCode is optional within optional Address)
    let zip = person1.address?.zipCode  // Need one more level
    
    return (street, city, zip)
}

func transformOptionals() -> (uppercased: String?, count: Int?, firstChar: Character?) {
    let text: String? = "hello"
    let empty: String? = ""
    let nilText: String? = nil
    
    // TODO: Use optional chaining to call uppercased()
    let uppercased = text.uppercased()  // Missing optional chaining
    
    // TODO: Get count with optional chaining (returns Int?)
    let count = empty.count  // Need optional chaining
    
    // TODO: Chain to get first character
    let firstChar = nilText?.first  // This is correct but try with 'text' instead
    
    return (uppercased, count, firstChar)
}

func main() {
    test("Optional chaining with structs") {
        let result = getPersonInfo()
        assertEqual(result.street, "123 Main St", "Should get street via chaining")
        assertEqual(result.city, "Boston", "Should get city from person1")
        assertEqual(result.zip, "02101", "Should get nested optional zipCode")
    }
    
    test("Optional chaining with methods") {
        let result = transformOptionals()
        assertEqual(result.uppercased, "HELLO", "Should uppercase the text")
        assertEqual(result.count, 0, "Empty string has count 0")
        assertEqual(result.firstChar, "h", "First character of 'hello'")
    }
    
    runTests()
}