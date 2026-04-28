// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

let tables = ["Loan", "Books", "Customer"]
// used to compare user input to limiatations in main menu
let mainMenuLowerBound = 1
// used to compare the user input in the main menu to the upper bound
let mainMenuupperBound = 5
// main menu message that is printed anytime the user naviates to the main menu
let mainMessage =
    ("""
    would you like to: 
    1: find a singular file? 
    2: print an entire table? 
    3: delete a file? 
    4: add a file? 
    5: to quit

    """)
// user is prompted this when they have finished a task.
let continuePrompt = ("press enter when you wnat to continue")



// used when getting date of publication, assuming the book was not written before years were 1 digit long (eg 1AD)
let oldestDateOfPublication = 1
// used when asking for the publication date assuming no book has been published in a year with 5 numbers
let newestPublication = 4

// shortest title length, used in the addFile function in case 2
let shortestTitle = 2

// longest possible title length used in addfile function in case 2
let longestTitle = 255

//used in the addRFile function in case 2 to get the title of a book eing added
let bookTitlePrompt = ("please Input the title of the book the book you wish to add:")

// used in the addFile function in case 2 to get the authors name
let bookAuthorPrompt = ("please enter the the author of the book you desire to add?")

/// used in addFile function to get the year of publication for a book, used in case 2
let yearOfPublicationPrompt = ("what year was the book you wish to add published?")

// currently avaialble tables
let availableTables = "1. Loans 2. Books 3. Customers"
// used when searching for an id as the number can be infinietly large but never less than 0
let IDsLowerBound: Int = 0
// to avoid magic numbers this is used when ever the user has to select a table, any search, write or delete function
let tablesUpbound = 3

// same as above this is used anytime the user is asked for an input for a table
let tablesLowerBound = 1

// shortes a name can be is 2 letters long EG "io"
let shortestName = 2

// allowing ample length for any name
let longestName = 75

// the shortest phone number belongs to Niue at 4
let shortestPhoneNumber = 4

//the longhest phone number is 15
let longestPhoneNumber = 15

// the prompt used when adding a loan to the loan table, this is used in the addrecord function for customer ID
let customerIdPrompt = ("please input the ID of the customer seeking to take out a loan: ")

//the prompt used in the addrecord function to get the book ID of the desierd loan
let bookIdPrompt = ("please input the ID of the book the customer is seeking to loan out:")

//the prompt used when asking the user to input the date of loan
let dateBorrowedPrompt = ("please input todays date:")

// prompt used when asking for customer first name in addCustomer function
let firstNamePrompt = ("what is the customers first name? ")
// prompt used when asking for customer first name in addCustomer function
let lastNamePrompt = ("what is the customers last name? ")
// prompt used when asking for customer first name in addCustomer function
let phoneNumberPrompt = ("what is the customers phone number? ")

/// this struct is the framework for a book with all information that is needed to create a new book
struct Books: Identifiable, PersistableRecord, Codable, FetchableRecord, TableRecord,
    CustomStringConvertible
{
    /// an id given to any book added optional so i can pass null and let GRDB create a new ID using autoincrement
    let id: Int?

    /// title of the book
    let title: String

    /// author of the book
    let author: String

    /// year the book was published
    let year: String

    var description: String {
        // see testing table for source of default and the solution i used
        "book ID: \(id, default: "N/A") | Title: \(title) | Author: \(author) | Date of Publication: \(year)"
    }
    /// to conform is Codable
    enum CodingKeys: String, CodingKey {
        case id = "BookID"
        case title = "Title"
        case author = "Author"
        case year = "YearPublished"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let title = Column("Title")
        static let author = Column("Author")
        static let year = Column("YearPublished")
        static let id = Column("BookID")
    }
}
/// this Struct contains the blueprint and coding keys to creeate a new Customer
struct Customer: Identifiable, PersistableRecord, Codable, FetchableRecord, TableRecord,
    CustomStringConvertible
{
    /// an id given to any customer added, optional so i can pass null values and let GRDB create a new ID
    let id: Int?

    /// customer name
    let firstName: String

    ///customer last name

    let lastName: String
    /// custoomer phone number
    let phoneNumber: String

    /// description of customer
    var description: String {
        // *note* used VS code and a google to : "https://surl.lt/mdhdpd"
        "ID: \(id, default: "N/A" ) | Name: \(firstName) \(lastName) | Phone Number: \(phoneNumber)"
    }
    /// to conform is Codable
    enum CodingKeys: String, CodingKey {
        case id = "CustomerID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phoneNumber = "Phone_Number"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let id = Column("CustomerID")
        static let firstName = Column("FirstName")
        static let lastName = ("LastName")
        static let phoneNumber = Column("Phone_Number")

    }
}

struct Loan: Codable, FetchableRecord, TableRecord, CustomStringConvertible, PersistableRecord {
    /// an id given to any customer added,
    let customerID: Int

    /// so the loan is findable in future, optional to let GRDB create a new ID
    let loanID: Int?

    /// so an order can be allocated with a book
    let bookID: Int
    /// date book was borrowed
    let dateBorrowed: String
    /// date book was returned
    let dateReturned: String?

    /// description of customer
    var description: String {
        "CustomerID: \(customerID) |BookID: \(bookID) | Date Borrowed: \(dateBorrowed)"
    }
    /// to conform to Codable
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case loanID = "LoanID"
        case bookID = "BookID"
        case dateBorrowed = "DateBorrowed"
        case dateReturned = "DateReturn"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let customerID = Column("CustomerID")
        static let loanID = Column("LoanID")
        static let bookID = Column("BookID")
        static let dateBorrowed = Column("DateBorrowed")
        static let dateReturned = Column("DateReturned")

    }

}
/// input checker for number returns with boundries
/// - Parameters:
///   - prompt: the prompt the user is responding to
///   - lowerBound:the lower boundry of their answers
///   - upperBound: the upper boundry of their answers
/// - Returns: when both bounds are satisfied returns the user input
func inputCheckNumber(prompt: String, lowerBound: Int, upperBound: Int) -> Int {
    // will not be broken until a safe asnwer is passed
    while true {
        //prompt the user interacts with
        print(prompt)
        //checks if the user has inuted something and then if it is a number
        if let input = readLine(), let userNumber = Int(input) {
            //checks if the user input is between the specifed boundries
            if userNumber >= lowerBound && userNumber <= upperBound {
                return userNumber
            } else {
                // if the input is out of bounds but a number this error is thrown
                system("clear")
                print(userNumber)
                print("please ensure your input is between \(lowerBound) and \(upperBound)")
            }
        } else {
            // if the answer is not a number or nill this is thrown
            system("clear")
            print("please make sure you input a number ")
        }
    }
}

/// input checker for number returns with no upper bound (IDs)
/// - Parameters:
///   - prompt: the prompt the user is responding to
///   - lowerBound:the lower boundry of their answers
/// - Returns: when both bounds are satisfied returns the user input
func inputCheckNumberNoUpBoundry(prompt: String, lowerBound: Int, ) -> Int {
    // will not be broken until a safe asnwer is passed
    while true {
        //prompt the user interacts with
        print(prompt)
        //checks if the user has inuted something and then if it is a number
        if let input = readLine(), let userNumber = Int(input) {

            //checks if the user input is between the specifed boundries
            if userNumber >= lowerBound {

                return userNumber
            } else {
                // if the input is out of bounds but a number this error is thrown
                system("clear")
                print(userNumber)
                print("please ensure your input is above \(lowerBound) ")
            }
        } else {
            // if the answer is not a number or nill this is thrown
            system("clear")
            print("please make sure you input a number ")
        }
    }
}

/// prints out an entire table when the user selctes print table form the main menu currently
/// - Parameters:
///   - dbQueue: to start a connection with the database
///   - tableNumber: the selected table the user is seeking
func printTable(dbQueue: DatabaseQueue) {
    // clear all old now non essential info
    system("clear")
    print("you have chosen to view a full table, available options: ")
    // using the function before I get the number associated with the table the user is after
    let tableNumber = inputCheckNumber(
        prompt: availableTables, lowerBound: tablesLowerBound,
        upperBound: tablesUpbound)
    do {
        ///opens a qeuery
        try dbQueue.read { db in
            switch tableNumber {
            /// if the user slectes case1 it prints the loan table
            case 1:
                let results = try Loan.fetchAll(db)
                /// cycles through the results suing the description message
                for result in results {
                    print(result.description)
                }
            /// if the user selets 2 is prints the books table
            case 2:
                let results = try Books.fetchAll(db)
                /// cycles through the results suing the description message
                for result in results {
                    print(result.description)
                }
            /// if the user selctes table 3 loans is printed
            case 3:
                ///trys to fetch all recors, stores them in results
                let results = try Customer.fetchAll(db)
                /// cycles through the results suing the description message
                for result in results {
                    print(result.description)
                }

            default: print("please input a number")

            }
        }
    } catch {
        print("you ran into an error : \(error)")
    }

}
/// find single, finds a singular record based off of  the ID used in main menu function
/// - Parameter dbQueue: passes the connection to the db to the function
func findSingle(dbQueue: DatabaseQueue) {
    // clear all old now non essential info
    system("clear")
    print("you have chosen to search for a singular record, available tables: ")
    // using the function before I get the number associated with the table the user is after
    let tableNumber = inputCheckNumber(prompt: availableTables, lowerBound: 1, upperBound: 3)
    print(
        " you have chosen to find a record in the  \(tables[tableNumber-1]) table, what ID are you looking for"
    )
    let userSingleQuery = inputCheckNumberNoUpBoundry(prompt: ":", lowerBound: IDsLowerBound)
    do {
        try dbQueue.read { db in
            switch tableNumber {
            case 1:
                if let result = try Loan.fetchOne(db, key: userSingleQuery) {
                    print(result.description)
                } else {
                    print("no record with ID: \(userSingleQuery) could be found")
                }
            case 2:
                if let result = try Books.fetchOne(db, key: userSingleQuery) {
                    print(result.description)
                } else {
                    print("no record with ID: \(userSingleQuery) could be found")
                }
            case 3:
                if let result = try Customer.fetchOne(db, key: userSingleQuery) {
                    print(result.description)
                } else {
                    print("no record with ID: \(userSingleQuery) could be found")
                }
            default: print("no ID could be found")
            }
        }
    } catch { print("you ran into an error: \(error)") }

}

/// String grabber, function that safely unwraps a string and checks if it meets requerments of length
/// - Parameters:
///   - lowerBound: the lowest length the string the function is grabbing can be
///   - upperBound: the longest the string the function is grabbing can be
///   - prompt: the prompt the user is answering
/// - Returns: returns a string to where ever it was called from once the input satisfies all inputs
func stringGrabber(lowerBound: Int, upperBound: Int, prompt: String) -> String {
    print(prompt)
    while true {
        if let userInputString = readLine() {
            let stringLength = userInputString.count
            // checks if upperbound == 0, this is the number i use for no upper bound
            if upperBound == 0 && stringLength >= lowerBound {
                // if upperbound is 0 and input is longer than lower bound it returns the value
                return userInputString
            }
            // if upperbound is not 0 it runs the normal check if it is between boundries
            else {
                if stringLength >= lowerBound && stringLength <= upperBound {
                    return userInputString
                } else {
                    print(
                        "please ensure your input is longer than \(lowerBound) and shorter than \(upperBound)"
                    )
                }
            }

        } else {
            print("please ensure your input contains only letters and no numbers ")
        }
    }
}

/// date grabber grabs the days date of when ever the user is taking out a book
/// - Returns: date in dd-mm-yyyy format
func dateGrabber() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let dateNow = Date()
    let dateFormatted = formatter.string(from: dateNow)
    return dateFormatted
}

/// adds a singular customer to the database
/// - Parameter dbQueue: passes the connection to the database to the function
func addCustomer(dbQueue: DatabaseQueue) {
    print(" you have chosen to add a record to a table, your options are:")
    let tableNumber = inputCheckNumber(
        prompt: availableTables,
        lowerBound: tablesLowerBound, upperBound: tablesUpbound)
    do {
        try dbQueue.write { db in
            switch tableNumber {
            // only trriggers when user inputs a 1
            case 1:
                let newLoan = Loan(
                    /// using the checked customer ID
                    customerID: inputCheckNumberNoUpBoundry(
                        prompt: customerIdPrompt, lowerBound: IDsLowerBound),

                    /// leaves Loan ID blancustomerIdPromptk for the Db to auto incriment
                    loanID: nil,
                    bookID: inputCheckNumberNoUpBoundry(
                        prompt: bookIdPrompt, lowerBound: IDsLowerBound),

                    /// uses dategrabber function to grab the date the book was handed out
                    dateBorrowed: dateGrabber(), dateReturned: nil)
                /// will try to add the information to the loans table
                try newLoan.insert(db)

            case 2:
                let newBook = Books(
                    id: nil,
                    title: stringGrabber(
                        lowerBound: shortestTitle, upperBound: longestTitle, prompt: bookTitlePrompt
                    ),
                    author: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: bookAuthorPrompt),
                    year: stringGrabber(
                        lowerBound: oldestDateOfPublication, upperBound: newestPublication,
                        prompt: yearOfPublicationPrompt))
                // trys to safely insert all information into the tables
                try newBook.insert(db)

            // only triggers when user inputs a 3
            case 3:
                let newCustomer = Customer(
                    // leave ID nil and let DB auto incriment a new ID
                    id: nil,
                    /// next three lines all grab customer infomration using string grabber
                    firstName: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: firstNamePrompt),
                    lastName: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: lastNamePrompt),
                    phoneNumber: stringGrabber(
                        lowerBound: shortestPhoneNumber,
                        upperBound: longestPhoneNumber, prompt: phoneNumberPrompt))
                // trys to add in all customer details, because of functions used userinputs are safe by here
                try newCustomer.insert(db)

            default: print("that was not an option sorry")

            }

        }
        print("customer added succesfully")
    } catch {print("please ensure any information you add is valid and exists")
        print("ran into an error : \(error)") }
}

@main
struct SwiftPlayground {

    static func main() {
        var systemRunning = true
        let dbPath = "Sources/SwiftPlayground/library.db"
        /// trying to connect to database, sends an error f its unable
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            print("Could not open database.")
            return
        }
        print("Connected to database.")

        print("Welcome to the onslow library main menu")
        while systemRunning == true {

            /// main menu function, this function prints the main menu and checks the user input is valid
            let mainMenuOption = inputCheckNumber(
                prompt: mainMessage, lowerBound: mainMenuLowerBound, upperBound: mainMenuupperBound)
            /// based on the different cases the user inputs it runs a different case corresponding to the desierd task
            switch mainMenuOption {
            case 1:
                // finds a single record based off of primary key
                findSingle(dbQueue: dbQueue)
            case 2:
                // prints an entire table
                printTable(dbQueue: dbQueue)
            case 3:
                print("you have chosen to delete a file")
            case 4:
                addCustomer(dbQueue: dbQueue)
            case 5:
                print("Goodbye!")
                systemRunning = false

            default:
                print("please choose one of the above options")

            }
            

 
 
            

            //change to input later, placeholder rn
            /// function to fetch all records from a table and print them

            /// function to search for a specfic record
        }
    }
}
