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
        
            
            
        }
        
    
}
