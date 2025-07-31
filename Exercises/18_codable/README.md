# Codable

This section covers Swift's Codable protocol for encoding and decoding data, particularly JSON. Learn how to serialize Swift types and handle complex data transformations.

## Official Swift Documentation
- [Encoding and Decoding Custom Types - Swift Documentation](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)
- [Codable Protocol - Swift Standard Library](https://developer.apple.com/documentation/swift/codable)
- [JSONEncoder - Foundation](https://developer.apple.com/documentation/foundation/jsonencoder)
- [JSONDecoder - Foundation](https://developer.apple.com/documentation/foundation/jsondecoder)
- [Swift Evolution: Codable (SE-0166)](https://github.com/apple/swift-evolution/blob/main/proposals/0166-swift-archival-serialization.md)
- [Swift Evolution: Codable Synthesis for Enums (SE-0295)](https://github.com/apple/swift-evolution/blob/main/proposals/0295-codable-synthesis-for-enums-with-associated-values.md)

## Topics Covered

### Basic Codable
- Automatic synthesis
- CodingKeys
- Optional properties
- Nested types
- Date handling

### Custom Encoding/Decoding
- init(from decoder:)
- encode(to:)
- Custom transformations
- Polymorphic types
- Type erasure

### Advanced Patterns
- Property wrappers
- Dynamic keys
- Lossy decoding
- Validation
- User info

### Performance & Optimization
- Lazy decoding
- Streaming
- Partial decoding
- Caching strategies
- Differential encoding

## Key Concepts

1. **Automatic Synthesis**: Compiler generates Codable conformance
2. **Custom Keys**: Map between Swift properties and JSON keys
3. **Encoding Strategies**: Configure how types are encoded
4. **Property Wrappers**: Encapsulate decoding logic
5. **Performance**: Optimize for large data sets

## Basic Syntax

### Simple Codable
```swift
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}
```

### Custom Keys
```swift
struct Article: Codable {
    let id: Int
    let authorName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorName = "author_name"
    }
}
```

### Date Strategies
```swift
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .secondsSince1970
```

## Custom Implementation

### Custom Decoding
```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    
    // Custom transformation
    let hexColor = try container.decode(String.self, forKey: .color)
    self.color = Color(hex: hexColor)
}
```

### Custom Encoding
```swift
func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(color.hexString, forKey: .color)
}
```

### Nested Containers
```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    
    let addressContainer = try container.nestedContainer(
        keyedBy: AddressKeys.self, 
        forKey: .address
    )
    self.street = try addressContainer.decode(String.self, forKey: .street)
}
```

## Property Wrappers

### Default Values
```swift
@propertyWrapper
struct Default<T: Codable>: Codable {
    let wrappedValue: T
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(T.self)) ?? wrappedValue
    }
}

struct Settings: Codable {
    @Default var theme: String = "light"
}
```

### Lossy Arrays
```swift
@propertyWrapper
struct LossyArray<T: Codable>: Codable {
    var wrappedValue: [T]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [T] = []
        
        while !container.isAtEnd {
            if let element = try? container.decode(T.self) {
                elements.append(element)
            } else {
                _ = try? container.decode(AnyDecodable.self)
            }
        }
        
        self.wrappedValue = elements
    }
}
```

## Advanced Techniques

### Dynamic Keys
```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DynamicKey.self)
    var properties: [String: String] = [:]
    
    for key in container.allKeys {
        properties[key.stringValue] = try container.decode(
            String.self, 
            forKey: key
        )
    }
    
    self.properties = properties
}
```

### Polymorphic Decoding
```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)
    
    switch type {
    case "dog":
        self.animal = try Dog(from: decoder)
    case "cat":
        self.animal = try Cat(from: decoder)
    default:
        throw DecodingError.dataCorruptedError(...)
    }
}
```

### User Info
```swift
let decoder = JSONDecoder()
decoder.userInfo[.apiVersion] = 2

// In init(from:)
let version = decoder.userInfo[.apiVersion] as? Int ?? 1
```

## Best Practices

1. **Use Automatic Synthesis**: When possible
2. **Validate During Decoding**: Catch errors early
3. **Handle Missing Data**: Use optionals or defaults
4. **Consider Performance**: For large data sets
5. **Document Custom Behavior**: Explain non-obvious transformations

## Common Patterns

### Safe Decoding
```swift
let value = try container.decodeIfPresent(String.self, forKey: .key) ?? "default"
```

### Type Conversions
```swift
// String to Int
let stringValue = try container.decode(String.self, forKey: .number)
self.number = Int(stringValue) ?? 0
```

### Flattening
```swift
// Flatten nested structure
let nested = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .nested)
self.flatProperty = try nested.decode(String.self, forKey: .property)
```

## Tips

- Use `decodeIfPresent` for optional values
- Implement `Encodable` and `Decodable` separately if needed
- Test with malformed JSON
- Consider using property wrappers for reusable patterns
- Profile performance with large data sets