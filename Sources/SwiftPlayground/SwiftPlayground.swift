// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB
let tables = ["Books", "Loan,", "Customer"]
// used to compare user input to limiatations in main menu 
let mainMenuLowerBound = 1
// used to compare the user input in the main menu to the upper bound
let mainMenuupperBound = 4
// main menu message that is printed anytime the user naviates to the main menu 
let mainMessage = ("""
        would you like to: 
        1: find a singular file? 
        2: print an entire table? 
        3: delete a file? 
        4: add a file? 
        
        """)
    
// currently avaialble tables
let availableTables = "1. Loans 2. Books 3. Customers"
/// this struct is the framework for a book with all information that is needed for a loan

struct Books:Identifiable, PersistableRecord, Codable, FetchableRecord, TableRecord,CustomStringConvertible{
    /// an id given to any book added
    let id: Int64 

    /// title of the book
    let title: String

    /// author of the book 
    let author: String

    /// year the book was published
    let year : String

    var description: String{
        "book ID: \(id) | Title: \(title) | Author: \(author) | Date of Publication: \(year)"
    }
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

struct Customer:Identifiable, PersistableRecord, Codable, FetchableRecord, TableRecord,CustomStringConvertible{
    /// an id given to any customer added
    let id: Int64 

    /// customer name
    let name: String

    /// custoomer phone number
    let phoneNumber: String

    /// description of customer
    var description: String{
        "ID: \(id) | Name: \(name) | Phone Number: \(phoneNumber)"
    }
/// to conform is Codable
    enum Codingkeys: String, CodingKey{
        case id = "ID"
        case name = "Name"
        case phoneNumber = "Phone Number"
    }
    /// because the names i have the DB dont conform to camelcase i need this 
    enum Columns{ 
        static let id = Column("ID")
        static let name = Column("Name")
        static let phoneNumber = Column("Phone_Number")

    }
}

    struct Loan:Codable, FetchableRecord, TableRecord,CustomStringConvertible, PersistableRecord{
    /// an id given to any customer added
    let customerID: Int

    /// customer name
    let loanID: Int

    /// custoomer phone number
    let bookID: Int

    let dateBorrowed: String

    let dateReturned: String

    /// description of customer
    var description: String{
        "CustomerID: \(customerID) |BookID\(bookID) | Date Borrowed: \(dateBorrowed)"
    }
/// to conform is Codable
    enum Codingkeys: String, CodingKey{
        case customerid = "CustomerID"
        case loanID = "LoanID"
        case bookID = "BookID"
        case dateBorrowed = "DateBorrowed"
        case dateReturned = "DateReturned"
    }
    /// because the names i have the DB dont conform to camelcase i need this 
    enum Columns{ 
        static let customerID = Column("CustomerID")
        static let loanID = Column("LoanID")
        static let bookID = Column("BookID")
        static let dateBorrowed = Column("DateBorrowed")
        static let dateReturned = Column("DateReturned")

    }





}
/// input checker for number returns 
/// - Parameters: 
///   - prompt: the prompt the user is responding to
///   - lowerBound:the lower boundry of their answers  
///   - upperBound: the upper boundry of their answers 
/// - Returns: when both bounds are satisfied returns the user input 
func inputCheckNumber(prompt: String, lowerBound: Int, upperBound: Int) -> Int{ 
    // will not be broken until a safe asnwer is passed 
    while true{ 
        //prompt the user interacts with
        print(prompt)
        //checks if the user has inuted something and then if it is a number 
        if let input = readLine(), let userNumber = Int(input){
            //checks if the user input is between the specifed boundries 
            if  userNumber >= lowerBound && userNumber <= upperBound {
                return userNumber
            }
            else{
                // if the input is out of bounds but a number this error is thrown
                system("clear")
                print(userNumber)
                print("please ensure your input is between \(lowerBound) and \(upperBound)")
            }
        } else{
            // if the answer is not a number or nill this is thrown 
            system("clear")
            print("please make sure you input a number ")
        }
    }
}
/// prints out an entire table "incomplete need to fix case 2"
/// - Parameters:
///   - dbQueue: to start a connection with the database 
///   - tableNumber: the selected table the user is seeking
func printTable(dbQueue: DatabaseQueue){
    let tableNumber = inputCheckNumber(prompt: availableTables, lowerBound: 1, upperBound: 3)
    do{
        try dbQueue.read{ db in 
    switch tableNumber{
        case 1 : 
            let results = try Books.fetchAll(db)
            for result in results{
                print(result.description)
            }

        case 2 : let results = try Loan.fetchAll(db)
            for result in results{
                print(result.description)
            }
        
        
        case 3 : 
            let results = try Customer.fetchAll(db)
            for result in results{
                print(result.description)
            }
        
        
        
        default:print( "please input a number")

            }
        }
    }catch{
        print("you ran into an error : \(error)")
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
    
        /// main menu function, this function prints the main menu and checks the user input is valid 
        let mainMenuOption = inputCheckNumber(prompt: mainMessage , lowerBound: mainMenuLowerBound, upperBound: mainMenuupperBound)
        print(mainMenuOption)

        
        switch mainMenuOption{
            case 1: 
                print("you have chosen to find a singular file")
            case 2: 
                printTable(dbQueue: dbQueue)
            case 3: 
                print("you have chosen to delete a file")
            case 4: 
                print(" you have chosen to add a file")
        default:
            print("please pick an option  from the list")
        }
        
        //change to input later, placeholder rn
        /// function to fetch all records from a table and print them
        print(tables)

        

    
        

        /// function to search for a specfic record
    }
}
