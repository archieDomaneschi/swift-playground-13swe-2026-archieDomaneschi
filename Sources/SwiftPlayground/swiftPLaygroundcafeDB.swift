import Foundation
import GRDB

///a purchaser is the name for the reservation or purchaser at the vafe

struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// an id given to each purchaser
    let id: Int?

    ///name of the Purchasser
    var name: String

    /// amount of people at a table
    var count: Int

    /// name of the table
    var reservedTable: String

    enum CodingKeys: String, CodingKey {
        case id = "purchaserID"
        case name = "Name"
        case count = "Count"
        case reservedTable = "reservedTable"
    }
    enum Columns {
        static let name = Column("Name")
        static let Count = Column("Count")
        static let reservedTable = Column("reservedTable")
        static let purchaserID = Column("PurchaserID")
    }
}
/// contents of the order that is sent to the kitchen
struct orderLine: Codable, FetchableRecord, PersistableRecord {
    /// an id given to each purchaser
    let id: Int

    ///name of the Purchasser
    var quantity: Int

    /// amount of people at a table
    let itemID: Int

    enum CodingKeys: String, CodingKey {
        case id = "OrdrID"
        case quantity = "Quantity"
        case itemID = "ItemID"
    }
}

struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    /// an id given to each order
    let id: Int

    ///namount of an item
    var price: Int

    /// purchaser ID to reference purchaser table
    let purchaserID: Int

    enum CodingKeys: String, CodingKey {
        case id = "OrderID"
        case price = "Price"
        case purchaserID = "PurchaserID"
    }
    enum Columns {
        static let purchaserID = Column("PurchaserID")
        static let price = Column("Price")
        static let id = Column("OrderID")
    }
    var description: String {
        return "Order(id: \(id), price: \(price), purchaserID: \(purchaserID))"
    }
}
// An it
struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    /// an id given to each item
    let id: Int

    ///name of the item
    var name: String

    /// price of the item
    var price: Double

    enum CodingKeys: String, CodingKey {
        case id = "ItemID"
        case name = "Name"
        case price = "Price"

    }
    enum Columns {
        static let name = Column("Name")
        static let price = Column("Price")
        static let id = Column("ItemID")
    }
    var description: String {
        return "Item(id: \(id), name: \(name), price: \(price))"
    }

}

@main
struct SwiftPlayground {
    static func main() {
        let dpath = "Sources/SwiftPlayground/cafe.db"
        do {
            // creates a database queue to connect to the cafe.db file, if the file does not exist it will be created
            guard let dbqueue = try? DatabaseQueue(path: dpath) else {
                print("could not connect to database")
                return
            }
            print("connected to database")
            /// makes sure we are connected corrrectly
            //try dbqueue.read({ database in try database.dumpSchema() })

            let purchaserId: Int = 1

            try dbqueue.read { db in
                let purchaser = try Purchaser.fetchOne(db, key: purchaserId)
                if let purchaser {
                    // if a purchaser is found with the given ID, it will print out the name of the purchaser
                    print("Found Purchaser: \(purchaser.name)")
                } else {
                    // if no purchaser is found with the given ID, it will print out a message saying that no purchaser was found
                    print("No Purchaser with ID \(purchaserId)")
                }
                // setting query
                let selectedReservedTable = ("roof top table")
                let purchasers =
                    // trys to find all purchasers, if no results are found it will print out an empty array
                    try Purchaser
                    .filter(Purchaser.Columns.reservedTable == selectedReservedTable)
                    .order(Purchaser.Columns.name)
                    .fetchAll(db)
                // prints out all results from search for the reserved table
                for purchaser in purchasers {
                    print("\(purchaser.name) has the \(purchaser.reservedTable)")
                }
            }
            let itemTryingToFind: String = "cheeseburger"

            try dbqueue.read { db in
                let item = try Item.filter(Item.Columns.name == itemTryingToFind).fetchOne(db)
                if let item {
                    // if an item is found with the given ID, it will print out the name of the item
                    print(item.description)
                } else {
                    // if no item is found with the given ID, it will print out a message saying that no item was found
                    print("No item called \(itemTryingToFind)")
                }
            }
            let orderNumToFind: Int = 0
            try dbqueue.read { db in
                let order = try Order.fetchOne(db, key: orderNumToFind)
                let purchaser = try Purchaser.fetchOne(db, key: orderNumToFind)
                if let order, let purchaser {
                    // if an order is found with the given ID, it will print out the price of the order and the name of the purchaser
                    print("Order \(order.id) for \(purchaser.name) costs \(order.price) with \(purchaser.count) people at the table")
                } else {
                    // if no order is found with the given ID, it will print out a message saying that no order was found
                    print("No order with ID \(orderNumToFind)")
                }
            }


        try dbqueue.write { db in
            // creates a new purchaser with the name "John Doe", a count of 4, and a reserved table of "roof top table"
            var newPurchaser = Purchaser(
            id: nil, 
            name: "Alex", 
            count: 4, 
            reservedTable: "Window Seat"
    )
            // inserts the new purchaser into the database
            try newPurchaser.insert(db)
        }
        } catch { print(error) }

        // if any errors are thrown during the database connection or queries, it will catch the error and print it out

    }

}
