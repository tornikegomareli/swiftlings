// error_handling1.swift
//
// Swift uses error handling to respond to recoverable errors.
// Functions that can throw errors are marked with 'throws'.
//
// Fix the error handling to make the tests pass.

// TODO: Define an error type
enum ValidationError {  // Missing Error conformance
    case tooShort
    case tooLong
    case invalidCharacters
}

// TODO: Make this function throw errors
func validateUsername(_ username: String) -> Bool {  // Missing throws
    if username.count < 3 {
        return false  // Should throw .tooShort
    }
    
    if username.count > 20 {
        return false  // Should throw .tooLong
    }
    
    let validCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
    if username.rangeOfCharacter(from: validCharacters.inverted) != nil {
        return false  // Should throw .invalidCharacters
    }
    
    return true
}

// TODO: Add error handling
func processUsername(_ username: String) -> String {
    // Call validateUsername and handle errors
    let isValid = validateUsername(username)  // This will throw
    
    if isValid {
        return "Username '\(username)' is valid!"
    } else {
        return "Invalid username"
    }
}

// TODO: Create a function that uses try?
func checkUsername(_ username: String) -> Bool {
    // Use try? to convert throwing function to optional
    return validateUsername(username)  // Need to handle potential error
}

func main() {
    test("Basic error throwing") {
        do {
            _ = try validateUsername("ab")
            assertFalse(true, "Should throw tooShort error")
        } catch ValidationError.tooShort {
            assertTrue(true, "Caught tooShort error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        do {
            _ = try validateUsername("this_username_is_way_too_long")
            assertFalse(true, "Should throw tooLong error")
        } catch ValidationError.tooLong {
            assertTrue(true, "Caught tooLong error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Error handling in functions") {
        assertEqual(processUsername("alice"), "Username 'alice' is valid!", 
                   "Valid username processed")
        assertEqual(processUsername("a"), "Username too short", 
                   "Short username error message")
        assertEqual(processUsername("user@name"), "Invalid characters in username", 
                   "Invalid characters error message")
    }
    
    test("Try optional") {
        assertTrue(checkUsername("validuser"), "Valid username returns true")
        assertFalse(checkUsername("no"), "Invalid username returns false")
        assertFalse(checkUsername("user name"), "Invalid username returns false")
    }
    
    runTests()
}