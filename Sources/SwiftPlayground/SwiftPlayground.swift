// The Swift Programming Language
// https://docs.swift.org/swift-book
struct Book{
    var title: String
    var author: String
    var pages: Int
    

    func bookSummary() -> String {
        return """
        \(title) by \(author) has \(pages) pages.
        """
    }
}

func summary(title: String, author: String, pages: Int) -> String {
    return """
    \(title) by \(author) has \(pages) pages.
    """
}

struct Temperature {


    static func toFahrenheit(celsius: Double) -> Double{
        return (celsius * 9/5) + 32
    }
    static func toCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
}

struct Timer{ 
    var seconds : Double
    var isRunning : Bool

    mutating func start() {
        isRunning = true
    }
    mutating func tick() {
        if isRunning == true{
            seconds += 1
        }
    }
    mutating func reset() {
        seconds = 0
        isRunning = false
    }
}

struct Cart{
    var itemsCount : Int

    static let freeShippingThreshold = 5 
    mutating func addItem(){
        itemsCount += 1
    }
    static func qualifiesForFreeShipping(count: Int) -> Bool {
        if count >= Cart.freeShippingThreshold{
            return true
        }
        else{
            return false
        }
    }
    func shippingMessage() -> String{ 
        if itemsCount >= Cart.freeShippingThreshold {
            return "you are eligable for free shipping"
        } else {
            return "You have \(itemsCount), you need \(Cart.freeShippingThreshold) to be eligable for free shipping."
        }
    

    }
}

struct Badge{
    var name: String
    var level: Int

    // out comes are identical as a computed value and as a function
    var label: String {
        return "\(name) - Level \(level)"
    }
}


@main
struct SwiftPlayground {
    static func main() {
        let book1 = Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", pages: 180)
        let book2 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", pages: 281)
        print(Temperature.toFahrenheit(celsius: 22))
        print(Temperature.toCelsius(fahrenheit: 65))
        print(Temperature.toCelsius(fahrenheit: 120))
        print(book1.bookSummary())
        print(book2.bookSummary())
        
        var timer = Timer(seconds: 0, isRunning: false)
        timer.start()
        print(timer.seconds)
        timer.tick()
        print(timer.seconds)
        timer.reset()
        print(timer.seconds)
        // all instance behaviour as function used are being called from the struct and I created an instance of the struct "Cart" when i created var cart1
        var amountofcycles = 0 
        var cart1 = Cart(itemsCount: 0) 
        while amountofcycles < 6 {
            cart1.addItem()
            
            amountofcycles += 1
            dump(cart1)
            // data is stored in the cart1 vairable so we can call the shippingMessage function to check if we are eligable for free shipping
            print(cart1.shippingMessage())

        }
        let badge1 = Badge(name: "sheriff", level: 3)
        print(badge1.label)

        }
        
        
    
}

