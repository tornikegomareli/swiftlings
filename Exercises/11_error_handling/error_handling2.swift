// error_handling2.swift
//
// Error propagation allows errors to bubble up through function calls.
// The 'defer' statement executes code when leaving scope.
//
// Fix the error propagation and defer usage to make the tests pass.

enum FileError: Error {
    case notFound
    case permissionDenied
    case corrupted
}

class FileManager {
    private var openFiles: Set<String> = []
    
    // TODO: Make this function throw
    func openFile(_ filename: String) {  // Missing throws
        if filename.isEmpty {
            // Should throw FileError.notFound
        }
        
        if filename.hasPrefix(".") {
            // Should throw FileError.permissionDenied
        }
        
        openFiles.insert(filename)
    }
    
    func closeFile(_ filename: String) {
        openFiles.remove(filename)
    }
    
    func isOpen(_ filename: String) -> Bool {
        return openFiles.contains(filename)
    }
    
    // TODO: Fix error propagation
    func readFile(_ filename: String) throws -> String {
        openFile(filename)  // This throws but not handled
        
        // TODO: Add defer to ensure file is closed
        // defer should close the file even if an error occurs
        
        if filename.hasSuffix(".corrupt") {
            throw FileError.corrupted
        }
        
        closeFile(filename)  // This might not execute if error thrown
        return "Contents of \(filename)"
    }
}

// TODO: Create a function that doesn't propagate errors
func safeReadFile(_ filename: String, using manager: FileManager) -> String {
    // Handle errors here instead of propagating
    return manager.readFile(filename)  // This throws
}

// TODO: Use multiple defer statements
func processFiles(_ filenames: [String], using manager: FileManager) -> [String] {
    var results: [String] = []
    var processedCount = 0
    
    // TODO: Add defer to print summary
    // Should print "Processed X of Y files"
    
    for filename in filenames {
        // TODO: Add defer to increment processedCount
        
        do {
            let content = try manager.readFile(filename)
            results.append(content)
        } catch {
            results.append("Error: \(error)")
        }
    }
    
    return results
}

func main() {
    test("Error propagation") {
        let manager = FileManager()
        
        do {
            _ = try manager.readFile("")
            assertFalse(true, "Should throw notFound")
        } catch FileError.notFound {
            assertTrue(true, "Caught notFound error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
        
        do {
            _ = try manager.readFile(".hidden")
            assertFalse(true, "Should throw permissionDenied")
        } catch FileError.permissionDenied {
            assertTrue(true, "Caught permissionDenied error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Defer cleanup") {
        let manager = FileManager()
        
        // Test successful read
        do {
            let content = try manager.readFile("test.txt")
            assertEqual(content, "Contents of test.txt", "File read successfully")
            assertFalse(manager.isOpen("test.txt"), "File should be closed")
        } catch {
            assertFalse(true, "Should not throw for valid file")
        }
        
        // Test error case with cleanup
        do {
            _ = try manager.readFile("data.corrupt")
            assertFalse(true, "Should throw corrupted error")
        } catch FileError.corrupted {
            assertFalse(manager.isOpen("data.corrupt"), "File should be closed even after error")
        } catch {
            assertFalse(true, "Wrong error type")
        }
    }
    
    test("Error handling without propagation") {
        let manager = FileManager()
        
        assertEqual(safeReadFile("good.txt", using: manager), 
                   "Contents of good.txt", "Valid file read")
        assertEqual(safeReadFile(".hidden", using: manager), 
                   "Error: Permission denied", "Error handled gracefully")
    }
    
    test("Multiple defer statements") {
        let manager = FileManager()
        let files = ["file1.txt", ".hidden", "file2.txt", "data.corrupt"]
        
        // Capture print output
        let results = processFiles(files, using: manager)
        
        assertEqual(results.count, 4, "All files processed")
        assertTrue(results[0].contains("Contents"), "First file succeeded")
        assertTrue(results[1].contains("Error"), "Second file failed")
        assertTrue(results[2].contains("Contents"), "Third file succeeded")
        assertTrue(results[3].contains("Error"), "Fourth file failed")
        
        // Should have printed "Processed 4 of 4 files"
    }
    
    runTests()
}