import Foundation
import GRDB

///a purchaser is the name for the reservation or purchaser at the vafe

struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// an id given to each purchaser
    let id: Int

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

struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// an id given to each order
    let id: Int

    ///namount of an item
    var amount: Int

    /// purchaser ID to reference purchaser table
    let purchaserID: Int

    enum CodingKeys: String, CodingKey {
        case id = "OrderID"
        case amount = "Amount"
        case purchaserID = "PurchaserID"
    }
}
struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// an id given to each item
    let id: Int

    ///name of the item
    var name: String

    /// amount of items
    var amount: Float

    enum CodingKeys: String, CodingKey {
        case id = "ItemID"
        case name = "Name"
        case amount = "Amount"

    }

}
	enum Columns {
		static let name = Column("Name")
		static let Count = Column("Count")
        static let reservedTable = Column("reservedTable")
	}

@main
struct SwiftPlayground {
    static func main() {
        let dpath = "Sources/SwiftPlayground/cafe.db"
        do {

            let dbqueue = try DatabaseQueue(path: dpath)
            print("connected to database")
            /// makes sure we are connected corrrectly
            try dbqueue.read({ database in try database.dumpSchema() })

            let purchaserId: Int = 1


            try dbqueue.read { db in
                let purchaser = try Purchaser.fetchOne(db, key: purchaserId)
                if let purchaser {
                    print("Found student: \(purchaser.name)")
                } else {
                    print("No student with id \(purchaserId)")
                }
            }
        } catch { print(error) }

    }

}
