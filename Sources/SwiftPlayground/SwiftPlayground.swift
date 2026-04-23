// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB
let tables = ["Books", "Loan,", "Customer"]

/// this struct is the framework for a book with all information that is needed for a loan

struct Books:Identifiable, Codable, FetchableRecord, TableRecord{
    /// an id given to any book added
    let id: Int? 

    /// title of the book
    let title: String

    /// author of the book 
    let author: String

    /// year the book was published
    let year : String
/// to conform is Codable
    enum Codingkeys: String, CodingKey{
        case id = "BookID"
        case title = "Title"
        case author = "Author"
        case year = "Year_Published"
    }
    /// because the names i have the DB dont conform to camelcase i need this 
    enum Columns{ 
        static let title = Column("Title")
        static let author = Column("Author")
        static let year = Column("Year_Published")
        static let id = Column("BookID")
    }



}

@main
struct SwiftPlayground {


    static func main() {
        
        let dbPath = "Sources/SwiftPlayground/library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            print("Could not open database.")
            return
        }
        print("Connected to database.")


        print("Welcome to the onslow library")
        print("""
        would you like to: 
        1: find a singular file? 
        2: print an entire table? 
        3: delete a file? 
        4: add a file? 
        
        """)
        // hard coding a number rn will later ask for an input 
        let userDecision = ("1")
        
        //change to input later, placeholder rn
        /// function to fetch all records from a table and print them

        print(tables)
        let userTable = ("1")
        print("1. Loans 2. Books 3. Customers")
        let selectedTable = switch userTable{
            case "1" :  tables[0]
            case "2":   tables[1]
            case"3":    tables[2]
            
            default : ("please only pick from the above options")
        }
        print(selectedTable)
    
        

        /// function to search for a specfic record
    }
}
