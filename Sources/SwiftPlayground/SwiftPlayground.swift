// The Swift Programming Language
// https://docs.swift.org/swift-book

import GRDB

@main
struct SwiftPlayground {
    static func main() {
        let dbPath = "Sources/SwiftPlayground/library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            print("Could not open database.")
            return
        }
        print("Connected to database.")

        //change to input later, placeholder rn 
    /// function to fetch all records from a table and print them
    
        let tables = ["Books","Loan,","Customer"]


    /// function to search for a specfic record
    }
}