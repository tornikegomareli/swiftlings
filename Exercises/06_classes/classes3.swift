// classes3.swift
//
// Classes can have deinitializers and type properties/methods.
// Access control restricts visibility of properties and methods.
//
// Fix the access control and type members to make the tests pass.

class FileHandler {
    // TODO: Make this private
    var fileHandle: String?
    
    // TODO: Add a static property to track open files
    var openFileCount = 0  // Should be static/class
    
    let filename: String
    
    init(filename: String) {
        self.filename = filename
        // TODO: Increment the open file count
        openFileCount += 1  // Can't access instance property
    }
    
    // TODO: Add deinitializer
    // deinit should decrement openFileCount
    
    // TODO: Make this private
    func openFile() {
        fileHandle = "Handle for \(filename)"
        print("Opened \(filename)")
    }
    
    // Public method that uses private method
    func readContents() -> String {
        if fileHandle == nil {
            openFile()
        }
        return "Contents of \(filename)"
    }
    
    // TODO: Add static method to get open file count
    func getOpenFileCount() -> Int {  // Should be static
        return openFileCount
    }
}

class BankVault {
    // TODO: Use proper access levels
    var balance: Double = 0  // Should be private
    let vaultID: String      // Should be public (already is by default)
    var pin: String          // Should be private
    
    init(vaultID: String, pin: String) {
        self.vaultID = vaultID
        self.pin = pin
    }
    
    // TODO: Fix access level
    private func verifyPin(_ inputPin: String) -> Bool {  // Too restrictive
        return inputPin == pin
    }
    
    // Public methods that use private data
    func deposit(_ amount: Double, pin: String) -> Bool {
        guard verifyPin(pin) else { return false }
        balance += amount
        return true
    }
    
    func checkBalance(_ pin: String) -> Double? {
        guard verifyPin(pin) else { return nil }
        return balance
    }
}

func main() {
    test("Static properties and deinit") {
        assertEqual(FileHandler.getOpenFileCount(), 0, "No files open initially")
        
        var handler1: FileHandler? = FileHandler(filename: "test1.txt")
        var handler2: FileHandler? = FileHandler(filename: "test2.txt")
        assertEqual(FileHandler.getOpenFileCount(), 2, "Two files open")
        
        handler1 = nil  // Should trigger deinit
        assertEqual(FileHandler.getOpenFileCount(), 1, "One file after deinit")
        
        handler2 = nil
        assertEqual(FileHandler.getOpenFileCount(), 0, "No files after all deinit")
    }
    
    test("Access control") {
        let vault = BankVault(vaultID: "VAULT123", pin: "1234")
        
        // These should work through public interface
        assertTrue(vault.deposit(100.0, pin: "1234"), "Deposit with correct pin")
        assertFalse(vault.deposit(50.0, pin: "0000"), "Deposit with wrong pin")
        
        assertEqual(vault.checkBalance("1234"), 100.0, "Check balance with correct pin")
        assertNil(vault.checkBalance("0000"), "Check balance with wrong pin")
        
        // vaultID should be accessible
        assertEqual(vault.vaultID, "VAULT123", "Vault ID is public")
        
        // Direct access to private members would cause compilation errors
        // vault.balance = 1000  // This should not compile
        // vault.pin = "0000"    // This should not compile
    }
    
    runTests()
}