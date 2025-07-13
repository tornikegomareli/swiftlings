// types2.swift
//
// Swift can automatically infer types from initial values.
// But sometimes we need to be explicit about types.
//
// Fix this code by adding necessary type annotations or initial values.


/// Function that demonstrates type inference and explicit type annotations
/// Fix the variable declarations to compile correctly
func getMeasurements() -> (temperature: Double, price: Double, message: String) {
    // TODO: Swift can't infer the type without an initial value
    // Either provide an initial value or add a type annotation
    let temperature
    temperature = 25.5
    
    // TODO: We want this to be a Double, not an Int
    // Add a type annotation or use a decimal literal
    let price = 100
    
    // This should work fine - type inference from the initial value
    let message = "The temperature is \(temperature)°C"
    
    return (temperature, price, message)
}

func test() {
    let result = getMeasurements()
    
    // Test temperature value and type
    assertEqual(result.temperature, 25.5, "Temperature should be 25.5")
    assertTrue(type(of: result.temperature) == Double.self, "Temperature should be of type Double")
    
    // Test price value and type
    assertEqual(result.price, 100.0, "Price should be 100.0")
    assertTrue(type(of: result.price) == Double.self, "Price should be of type Double, not Int")
    
    // Test message
    assertEqual(result.message, "The temperature is 25.5°C", "Message should interpolate temperature correctly")
    
    // Test that price is actually a Double by performing Double-specific operations
    let discountedPrice = result.price * 0.9
    assertEqual(discountedPrice, 90.0, "Should be able to perform floating-point operations on price")
}

func main() {
    test()
    runTests()
}