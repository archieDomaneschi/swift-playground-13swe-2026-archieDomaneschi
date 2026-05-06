// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import GRDB

let tables = ["Loan", "Books", "Customer"]
// used to compare user input to limiatations in main menu
let mainMenuLowerBound = 1
// used to compare the user input in the main menu to the upper bound
let mainMenuUpperBound = 7
// main menu message that is printed anytime the user naviates to the main menu
let mainMessage =
    ("""
    would you like to: 
    1: find a singular file? 
    2: print an entire table? (viewing books will view availability)
    3: delete a file? 
    4: add a file? 
    5: process a return
    6: edit a customers record
    7: to quit

    """)

//used in editCustomer function to ask what the name they would like to change the name to
let customerFirstNameChangePrompt =
    ("please enter the name you would like the selcted custommers name changed to, or leave blank to leave unchanged")

//used in editCustomer function to ask what the name they would like to change the name to
let customerLastNameChangePrompt =
    ("please enter the last name you would like the selcted custommers name changed to, or leave blank to leave unchanged")

////used in editCustomer function to ask what phonenumber they would like to change the number to
let customerPhoneNumberChangePrompt =
    ("please enter the new phone number you would like the selcted custommers number changed to, or leave blank to leave unchanged")
//
//used in the editCustomer function to ask the user the customer ID they are altering
let customerChangePrompt = ("please enter the ID of the customer you are attempting to alter")

//used in the processReturn func
let loanReturnPrompt = ("please enter the ID of the loan being returned")

// this is hte prompt used to ask users how many books they are adding in addRecord
let amountPrompt = ("how many books would you like to add")

//this is always assigned to a new loan and gets changed to statusReturned when a return is processeed
let statusLoan = "Loaned"

// this is what gets useed in processReturn func
let statusReturn = "Returned"

// user is prompted this when they have finished a task.
let continuePrompt = ("press enter when you wnat to continue")

// used to check the amount used when asking how many books is beign added is valid(no less than 0)
let bookAmountLowerBound = 1
// used when getting date of publication, assuming the book was not written before years were 1 digit long (eg 1AD)
let oldestDateOfPublication = 1
// used when asking for the publication date assuming no book has been published in a year with 5 numbers
let newestPublication = 4

// shortest title length, used in the addFile function in case 2
let shortestTitle = 2

// longest possible title length used in addfile function in case 2
let longestTitle = 255

// used in the deleteRecord func to make it clear to the user what they chose to do
let deleteWelcomePrompt = ("you have chosen to delete a record, below are the options you have")

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
// the shortest phone number belongs to Niue at 4 used in add customer and editCustomer
let shortestPhoneNumber = 4

// longest possible phone number used in addCustomer and Edit customer
let longestPhoneNumber = 15

// the prompt used when adding a loan to the loan table, this is used in the addrecord function for customer ID
let customerIdPrompt = ("please input the ID of the customer seeking to take out a loan: ")

//the prompt used in the addrecord function to get the book ID of the desierd loan
let bookIdPrompt = ("please input the ID of the book the customer is seeking to loan out:")

// prompt used when asking for customer first name in addCustomer function
let firstNamePrompt = ("what is the customers first name? ")

// prompt used when asking for customer first name in addCustomer function
let lastNamePrompt = ("what is the customers last name? ")

// prompt used when asking for customer first name in addCustomer function
let phoneNumberPrompt = ("what is the customers phone number? ")

// prompt used when asking what the customerID of the record they are attempting to delete is in dleterecord func
let deletePrompt = ("please insert the ID of the record you want to delete ")

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

    ///the amount of books you are adding to the system
    var amount: Int

    var description: String {
        // see testing table for source of default and the solution i used
        "book ID: \(id, default: "N/A") |Title: \(title) |Author: \(author) |Date of Publication: \(year)|AmountLeft \(amount)"
    }
    /// to conform is Codable
    enum CodingKeys: String, CodingKey {
        case id = "BookID"
        case title = "Title"
        case author = "Author"
        case year = "YearPublished"
        case amount = "AmountAvailable"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let title = Column("Title")
        static let author = Column("Author")
        static let year = Column("YearPublished")
        static let id = Column("BookID")
        static let amount = Column("AmountAvailable")
    }
}
/// this Struct contains the blueprint and coding keys to creeate a new Customer
struct Customer: Identifiable, PersistableRecord, Codable, FetchableRecord, TableRecord,
    CustomStringConvertible
{
    /// an id given to any customer added, optional so i can pass null values and let GRDB create a new ID
    let id: Int?

    /// customer name
    var firstName: String

    ///customer last name

    var lastName: String
    /// custoomer phone number
    var phoneNumber: String

    /// description of customer
    var description: String {
        // *note* used VS code and a google to over come optional issues: "https://surl.lt/mdhdpd"
        "ID: \(id, default: "N/A" ) |Name: \(firstName) \(lastName) |Phone Number: \(phoneNumber)"
    }
    /// to conform is Codable
    enum CodingKeys: String, CodingKey {
        case id = "CustomerID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phoneNumber = "PhoneNumber"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let id = Column("CustomerID")
        static let firstName = Column("FirstName")
        static let lastName = ("LastName")
        static let phoneNumber = Column("PhoneNumber")

    }
}

struct Loan: Codable, FetchableRecord, TableRecord, CustomStringConvertible, PersistableRecord,
    MutablePersistableRecord
{
    /// an id given to any customer added,
    let customerID: Int

    /// so the loan is findable in future, optional to let GRDB create a new ID
    let loanID: Int?

    /// so an order can be allocated with a book
    let bookID: Int
    /// date book was borrowed
    let dateBorrowed: String
    /// date book was returned
    var dateReturned: String?

    ///weather the loan is out or returned
    var status: String

    /// description of customer
    var description: String {
        "CustomerID: \(customerID) |BookID: \(bookID) |Date Borrowed: \(dateBorrowed)|Status: \(status)"
    }
    /// to conform to Codable
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case loanID = "LoanID"
        case bookID = "BookID"
        case dateBorrowed = "DateBorrowed"
        case dateReturned = "DateReturn"
        case status = "Status"
    }
    /// because the names i have the DB dont conform to camelcase i need this
    enum Columns {
        static let customerID = Column("CustomerID")
        static let loanID = Column("LoanID")
        static let bookID = Column("BookID")
        static let dateBorrowed = Column("DateBorrowed")
        static let dateReturned = Column("DateReturned")
        static let status = Column("Status")

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
                var unAvailability: [String] = []
                var available: [String] = []
                let results = try Books.fetchAll(db)
                /// cycles through the results adding to unavailable if amount of books = 0
                for result in results {
                    if result.amount == 0 {
                        unAvailability.append(result.description)
                    } else {
                        available.append(result.description)
                    }
                }
                for available in available {
                    print("IN STOCK || \(available.description)")
                }
                for unAvailable in unAvailability {
                    print("OUT OF STOCK || \(unAvailable.description) ")
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
    // prints out the selected table
    let userSingleQuery = inputCheckNumberNoUpBoundry(
        prompt:
            " you have chosen to find a record in the  \(tables[tableNumber-1]) table, what ID are you looking for",
        lowerBound: IDsLowerBound)
    do {
        //once a input that is checked to be a int is retrived the input is used to find the loan
        try dbQueue.read { db in
            switch tableNumber {
            // uses table number from above to determine which table is being searched
            case 1:
                // safely retrives a loan using if let, becasue it could be nil i have a message that prints if it is
                if let result = try Loan.fetchOne(db, key: userSingleQuery) {
                    if let name = try Customer.fetchOne(db, key: result.customerID) {
                        print("\(result.description) |Loaned By: \(name.firstName)")
                    }
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
            if stringLength == 0 && upperBound == 0 {
                return userInputString
            }
            // checks if upperbound == 0, this is the number I use for no upper bound
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

/// stringgrabbernamechange, i had to make this becasue if i added in the -
///  = 0 statement in previous string grabber it would have broken other inputs
/// - Parameters:
///   - lowerBound: the longest a name can be
///   - upperBound: the longest a name can be
///   - prompt: what the user is asked to respond to
/// - Returns: a String only if the string is either empty or within requierments
func stringGrabberNameChange(lowerBound: Int, upperBound: Int, prompt: String) -> String {

    print(prompt)
    while true {
        if let userInputString = readLine() {
            let stringLength = userInputString.count
            if stringLength == 0 {
                return userInputString
            } else {
                if stringLength >= lowerBound && stringLength <= upperBound {
                    return userInputString
                } else {
                    print(
                        """
                        please ensure your input is longer than \(lowerBound) and shorter than \(upperBound) 
                        or left blank if you wish to make no change
                        """)
                }
            }
        }
    }
}

/// date grabber grabs the days date of when ever the user is taking out a book or returning a book
/// - Returns: date in dd-mm-yyyy format
func dateGrabber() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let dateNow = Date()
    let dateFormatted = formatter.string(from: dateNow)
    return dateFormatted
}

/// adds a singular record to the database, grabs all nescasry values in the code
/// - Parameter dbQueue: passes the connection to the database to the function
func addRecord(dbQueue: DatabaseQueue) {
    // to increase how readable it is and declutter the system
    system("clear")
    print(" you have chosen to add a record to a table, your options are:")
    /// gets user input between 1 and 3
    let tableNumber = inputCheckNumber(
        prompt: availableTables,
        lowerBound: tablesLowerBound, upperBound: tablesUpbound)
    /// only once a vlid input has been passed out of inputCheckNumber does this do block run
    do {
        /// runs the switch and nescary case depending on user input
        try dbQueue.write { db in
            switch tableNumber {
            // only trriggers when user inputs a 1
            case 1:
                // i get the customer ID outside of the struct so i can check it
                let customerId = inputCheckNumberNoUpBoundry(
                    prompt: customerIdPrompt, lowerBound: IDsLowerBound)
                // checks if its nill, if it is it runs an error message and returns to main menu
                if try Customer.fetchOne(db, key: customerId) == nil {
                    print("please ensure the Id you input exists")
                    // only if the Id exists does this code run
                } else {
                    // defines the newLoan
                    let newLoan = Loan(
                        // using the checked customer ID
                        customerID: customerId,

                        // leaves Loan ID blank for the Db to auto incriment
                        loanID: nil,
                        // only passes an ID into bookID when the input is a number greater than 0
                        bookID: inputCheckNumberNoUpBoundry(
                            prompt: bookIdPrompt, lowerBound: IDsLowerBound),

                        // uses dategrabber function to grab the date the book was handed out
                        dateBorrowed: dateGrabber(), dateReturned: nil, status: statusLoan)
                    //update the amount of books using bookID linked to loan
                    if var book = try Books.fetchOne(db, key: newLoan.bookID) {
                        // updates the amount of books available to one less
                        book.amount -= 1
                        // will try to insert the new loan
                        try newLoan.insert(db)
                        // only if the newloan was succesfully inserted the book amount gets updated
                        try book.update(db)
                        // so the customer knows all insertion functions are done and it was a success
                        print("record added succesfully")
                    } else {
                        // if the book ID could not be found this message is ran
                        print("this book does not exist")
                    }
                }

            case 2:
                // defines the new book structure
                let newBook = Books(
                    // passes a nil value to the DB so the DB can auto incriment it
                    id: nil,
                    // uses stringgrabber to ask for name, only sets title when answer is within bounds
                    title: stringGrabber(
                        lowerBound: shortestTitle, upperBound: longestTitle, prompt: bookTitlePrompt
                    ),
                    // same as befroe for author
                    author: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: bookAuthorPrompt),
                    // only when the input meets requierments is this value set
                    year: stringGrabber(
                        lowerBound: oldestDateOfPublication, upperBound: newestPublication,
                        prompt: yearOfPublicationPrompt),
                    // in case the user is adding multipule copies to the library

                    amount: inputCheckNumberNoUpBoundry(
                        prompt:
                            amountPrompt, lowerBound: bookAmountLowerBound))
                // trys to safely insert all information into the tables
                try newBook.insert(db)
                print("record added succesfully")

            // only triggers when user inputs a 3
            case 3:
                let newCustomer = Customer(
                    // leave ID nil and let DB auto incriment a new ID
                    id: nil,
                    // next three lines all grab customer infomration using string grabber
                    firstName: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: firstNamePrompt),
                    // checks length
                    lastName: stringGrabber(
                        lowerBound: shortestName, upperBound: longestName, prompt: lastNamePrompt),
                    phoneNumber: stringGrabber(
                        lowerBound: shortestPhoneNumber,
                        upperBound: longestPhoneNumber, prompt: phoneNumberPrompt))
                // trys to add in all customer details, because of functions used userinputs are safe by here
                try newCustomer.insert(db)
                print("record added succesfully")
            // in the event a value not between 1 and 3 gets passed to the switch this is passed
            default: print("that was not an option sorry")

            }

        }
        // any errors thrown by the trys get caught and printed here along with a more user friendly message
    } catch {
        // my user friednly error message
        print("please ensure any information you add is valid and exists")
        // splits up the system message from mine so it doesnt look like a crash
        print("\n")
        // system error message
        print("SYSTEM ERROR MESSAGE: \(error)")
    }
}

/// processLoanReturn is a function purely dedicated to proccessing a reutrn, only used when the vustomer presses 5
/// - Parameter dbQueue:
func processLoanReturn(dbQueue: DatabaseQueue) {
    print("you have chosen to return a book")
    // gets the loan ID but only continues when input is safe
    let loanToReturnId = inputCheckNumberNoUpBoundry(
        prompt: loanReturnPrompt, lowerBound: IDsLowerBound)
    do {
        // seeing as the only userinput needed is the ID of the order as the rest of the stuff is hard coded in
        try dbQueue.write { db in
            // only if the ID exists is it alterd, if it doesnt exist i run the catch messaeg
            if var loan = try Loan.fetchOne(db, key: loanToReturnId) {
                // checks if hte loan has already been proccesed 
                if loan.status != statusReturn {
                    // updates the columns of the loan to the returned status
                    loan.status = statusReturn
                    // updates the dateReturned column to the current date
                    loan.dateReturned = dateGrabber()

                    //finds the book id using the reference found in the loan
                    if var book = try Books.fetchOne(db, key: loan.bookID) {
                        // once the book ID is found the amount gets increased and then updated
                        book.amount += 1
                        // once both columns have beenupdated and the book has been found they get inserted
                        try loan.update(db)
                        // only once the loan is updated is teh book amount increased
                        try book.update(db)
                        print("Loan returned successfully")
                    }
                }else{print("Loan number \(loan.loanID, default: "N/A") has already been returned")}
            } else {
                // if the bookId cant be foundthis is ran
                print(
                    "This ID does not exist"
                )

            }

        }
        // any error thrown from a try block is handled here
    } catch { print(error) }
}
///edits a customers details
/// - Parameter dbQueue:
func editCustomer(dbQueue: DatabaseQueue) {
    // first thing the function does is find the custoemr attempting to be eddited
    let customerChange = inputCheckNumberNoUpBoundry(
        prompt: customerChangePrompt, lowerBound: IDsLowerBound)
    // once a valid id has been enterd (although unchecked if it exists)
    do {
        try dbQueue.write { db in
            //checks if the customer ID exists, if it doesnt all code that alters an ID is skipped
            if var customer = try Customer.fetchOne(db, key: customerChange) {
                // used so if the customer first name is left blank the name can be reset to what it was before later
                let customerFirstName = customer.firstName
                // used so if the customer last name is left blank the name can be reset to what it was before later
                let customerLastName = customer.lastName

                // used so if the customer phone number is left blank the name can be reset to what it was before later
                let customerPhoneNumber = customer.phoneNumber

                // grabs the new first name
                customer.firstName = stringGrabberNameChange(
                    lowerBound: shortestName,
                    upperBound: longestName, prompt: customerFirstNameChangePrompt)

                // checks if user left the name blank
                if customer.firstName == "" {
                    // if left blank the user first name is reset
                    customer.firstName = customerFirstName
                }

                // as above checks grabs the customer last name and checks if blank
                customer.lastName = stringGrabberNameChange(
                    lowerBound: shortestName,
                    upperBound: longestName, prompt: customerLastNameChangePrompt)

                // if blank the customer last name is restored
                if customer.lastName == "" {
                    customer.lastName = customerLastName
                }

                // uses string grabber to get the new phone number
                customer.phoneNumber = stringGrabberNameChange(
                    lowerBound: shortestPhoneNumber,
                    upperBound: longestPhoneNumber, prompt: customerPhoneNumberChangePrompt)
                //resets customer phone number if left blank
                if customer.phoneNumber == "" {
                    customer.phoneNumber = customerPhoneNumber
                }

                // once all records have been retrived and set to the proper value it is updated
                try customer.update(db)

            }
        }
    } catch { print("you ran into an error :\(error)") }
}

/// deletes a record based off of the suer input, works for all tables
/// - Parameter dbQueue: passes a connection to the data base to the function
func deleteRecord(dbQueue: DatabaseQueue) {
    system("clear")
    print(deleteWelcomePrompt)
    /// gets the desierd table number from the user
    let tableNumber = inputCheckNumber(
        prompt: availableTables, lowerBound: tablesLowerBound, upperBound: tablesUpbound)
    /// prints out the table the user has decided to alter
    print("you have chosen to delete a record from the \(tables[tableNumber - 1]) table")
    /// gets the ID the user wants to delete this is checked and used later in the case statements
    let id = inputCheckNumberNoUpBoundry(prompt: deletePrompt, lowerBound: IDsLowerBound)
    do {
        ///performs database operations
        try dbQueue.write { db in
            switch tableNumber {
            /// if the user responded to the prompt above with one they chose to lter theloan table
            case 1:
                if let record = try Loan.fetchOne(db, key: id) {
                    /// if the record exists it will try to delte the record from the database
                    try record.delete(db)
                    print("file deleted succesfully!")
                    /// if no record is found the else block is ran and the function is exited
                } else {
                    /// lets the user know no ID could be found
                    print("no record with ID : \(id) found, no changes have been made")
                }
            /// if the user input 2 then they wanted to alter the books table and checks if the ID they selected exists
            case 2:
                if let record = try Books.fetchOne(db, key: id) {
                    /// if the id exists it will attempt to delete the record
                    try record.delete(db)
                    print("file deleted succesfully!")
                    /// if the ID does not exist this else block is triggerd, prints no id coudl be found
                } else {
                    print("no record with ID : \(id) found, no changes have been made")
                }

            /// if the user input 3 they want to edit the customer table, checks if the selcted ID exists
            case 3:
                if let record = try Customer.fetchOne(db, key: id) {
                    /// if the ID exists the code will try to delte it from database, any  errors thrown are handeled by catch below
                    try record.delete(db)
                    print("file deleted succesfully!")
                    /// if Id does not exist this else block is ran and the function is exited
                } else {
                    print("no record with ID : \(id) found, no changes have been made")
                }
            // to make the switch exhaustave although this isnt exactly reachable given functions used for input
            default: print("error! not an option")
            }
        }
        /// if any error is thrown by the delte function this is ran
    } catch { print("you ran into an error: \(error)") }
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
            // needs to be made false every time the code is ran through, put here so when the user quits it can be-
            //set to true and skip the last message
            var userContinueBool: Bool = false
            /// main menu function, this function prints the main menu and checks the user input is valid
            let mainMenuOption = inputCheckNumber(
                prompt: mainMessage, lowerBound: mainMenuLowerBound, upperBound: mainMenuUpperBound)
            /// based on the different cases the user inputs it runs a different case corresponding to the desierd task
            switch mainMenuOption {
            case 1:
                // finds a single record based off of primary key
                findSingle(dbQueue: dbQueue)
            case 2:
                // prints an entire table
                printTable(dbQueue: dbQueue)
            case 3:
                // runs the delete function
                deleteRecord(dbQueue: dbQueue)
            case 4:
                // runs the add record function
                addRecord(dbQueue: dbQueue)
            case 5:
                //proccess a return
                processLoanReturn(dbQueue: dbQueue)
            case 6:
                // edits a customer
                editCustomer(dbQueue: dbQueue)
            case 7:
                print("Goodbye!")
                systemRunning = false
                userContinueBool = true

            default:
                print("please choose one of the above options")

            }

            while userContinueBool == false {
                print("press enter to continue")
                let userContinue = readLine()
                if userContinue == "" {
                    userContinueBool = true
                    system("clear")

                } else {
                    print("please only press enter")

                }

            }

        }

    }
}
