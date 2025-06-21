// types2.swift
//
// Swift can automatically infer types from initial values.
// But sometimes we need to be explicit about types.
//
// Fix this code by adding necessary type annotations or initial values.

// I AM NOT DONE

func main() {
    // TODO: Swift can't infer the type without an initial value
    let temperature
    temperature = 25.5
    
    // TODO: We want this to be a Double, not an Int
    let price = 100
    
    // This should work fine - type inference from the initial value
    let message = "The temperature is \(temperature)°C"
    
    print(message)
    print("Price: $\(price)")
}