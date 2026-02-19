// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Car{
    let brandName: String
    let modelName: String
    let yearNumber: Int


func carDetails() ->String{
    return """
    This \(brandName) model \(modelName) made in the year \(yearNumber)
    """
}
}

struct BankAccount{
    let owner: String
    var balance: Double

    func description() -> String{
        return """
        \(owner)'s account has $\(balance)

        """
    }
}

struct Rectangle{ 
    var width: Double
    var height: Double
    
    func area() -> String {
        return """
        the area of the rectangle is (\(width) * \(height))
        """
    }
}


struct Quest{ 
    var title: String
    var difficulty: String
    var experiance: String

    func printBadge() -> String{
        return """
        \(difficulty) quest: \(title) - XP \(experiance)
        """
    }
}

@main
struct SwiftPlayground {
    static func main() {

    let carsInGarage = [Car(brandName: "Ford", modelName: "mondeo", yearNumber: 2017),
    Car(brandName: "Ford", modelName: "trackhawk", yearNumber: 2016)] 
        
    print(carsInGarage[0].carDetails())
    print(carsInGarage[1].carDetails())
    
    let accounts = [BankAccount(owner: "sam", balance: 0.00),
    BankAccount(owner: "Sammy T", balance: 400)]

    print("\(accounts[0].description())")
    print("\(accounts[1].description())")

    let rectangle1 = Rectangle(width: 10.0, height: 15.5)
    let rectangle2 = Rectangle(width: 15.0, height: 20.1)

    if rectangle1 > rectangle2{

    }

    


    }
}
