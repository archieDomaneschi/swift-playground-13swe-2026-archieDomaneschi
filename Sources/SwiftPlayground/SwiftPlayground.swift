// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Car {
    let brandName: String
    let modelName: String
    let yearNumber: Int

    func carDetails() -> String {
        return """
            This \(brandName) model \(modelName) made in the year \(yearNumber)
            """
    }
}

struct BankAccount {
    let owner: String
    var balance: Double

    func description() -> String {
        return """
            \(owner)'s account has $\(balance)

            """
    }
}

struct Rectangle {
    var width: Double
    var height: Double

    func area() -> Double {

        print("the area of the rectangle is \(width * height) meters squared")
        return width * height
    }
}

struct Quest {
    var title: String
    var difficulty: Int
    var experiance: Int

    func printBadge() -> String {
        return """
            quest: \(title), Difficulty: \(difficulty)  - XP \(experiance)
            """
    }
}
func sortDifficulty(quests: [Quest]) -> [Quest] {
            return quests.sorted { $0.difficulty > $1.difficulty }
}

@main
struct SwiftPlayground {
    static func main() {

        let carsInGarage = [
            Car(brandName: "Ford", modelName: "mondeo", yearNumber: 2017),
            Car(brandName: "Ford", modelName: "trackhawk", yearNumber: 2016),
        ]

        print(carsInGarage[0].carDetails())
        print(carsInGarage[1].carDetails())

        let accounts = [
            BankAccount(owner: "sam", balance: 0.00),
            BankAccount(owner: "Sammy T", balance: 400),
        ]

        print("\(accounts[0].description())")
        print("\(accounts[1].description())")

        let rectangle1 = Rectangle(width: 10.0, height: 15.5)
        let rectangle2 = Rectangle(width: 15.0, height: 20.1)
        print(rectangle1.area())
        print(rectangle2.area())
        if rectangle1.area() > rectangle2.area() {
            print("rectangle one has a larger area than rectangle two")

        } else {
            print("rectangle two has a larger area than rectangle one")
        }

        let quests = [
            Quest(title: "Defeat the dragon", difficulty: 5, experiance: 50),
            Quest(title: "Find the lost sword", difficulty: 3, experiance: 30),
            Quest(title: "Rescue the princess", difficulty: 4, experiance: 40),
        ]
        let questsSorted = sortDifficulty(quests: quests)
        for quest in questsSorted {
            print(quest.printBadge())

        }
        
        }
    }

