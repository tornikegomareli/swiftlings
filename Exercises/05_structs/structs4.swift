// structs4.swift
//
// Mutating methods can modify struct properties.
// Structs need explicit mutating keyword for methods that change properties.
//
// Fix the mutating methods and initializers to make the tests pass.

struct Counter {
    var value: Int = 0
    
    // TODO: Make this method mutating
    func increment() {
        value += 1  // Can't modify without mutating
    }
    
    // TODO: Make this method mutating
    func increment(by amount: Int) {
        value += amount
    }
    
    // TODO: Make this method mutating
    func reset() {
        value = 0
    }
    
    // This method doesn't need mutating - why?
    func isPositive() -> Bool {
        return value > 0
    }
}

struct BankAccount {
    private var balance: Double
    let accountNumber: String
    
    // TODO: Fix the initializer
    init(accountNumber: String) {
        // Initialize all properties
        self.accountNumber = accountNumber
        // Missing balance initialization
    }
    
    // TODO: Add custom initializer with initial deposit
    // init(accountNumber: String, initialDeposit: Double)
    
    // TODO: Make this mutating
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    // TODO: Make this mutating and add validation
    func withdraw(_ amount: Double) -> Bool {
        balance -= amount  // Should check if sufficient funds
        return true
    }
    
    // Getter doesn't need mutating
    func getBalance() -> Double {
        return balance
    }
}

func main() {
    test("Counter mutations") {
        var counter = Counter()
        
        counter.increment()
        assertEqual(counter.value, 1, "Should increment by 1")
        
        counter.increment(by: 5)
        assertEqual(counter.value, 6, "Should increment by 5")
        
        counter.reset()
        assertEqual(counter.value, 0, "Should reset to 0")
    }
    
    test("Bank account") {
        var account1 = BankAccount(accountNumber: "12345")
        assertEqual(account1.getBalance(), 0.0, "Default balance should be 0")
        
        var account2 = BankAccount(accountNumber: "67890", initialDeposit: 100.0)
        assertEqual(account2.getBalance(), 100.0, "Initial deposit of 100")
        
        account2.deposit(50.0)
        assertEqual(account2.getBalance(), 150.0, "Balance after deposit")
        
        let success = account2.withdraw(30.0)
        assertTrue(success, "Withdrawal should succeed")
        assertEqual(account2.getBalance(), 120.0, "Balance after withdrawal")
        
        let failure = account2.withdraw(200.0)
        assertFalse(failure, "Insufficient funds withdrawal should fail")
        assertEqual(account2.getBalance(), 120.0, "Balance unchanged after failed withdrawal")
    }
    
    runTests()
}