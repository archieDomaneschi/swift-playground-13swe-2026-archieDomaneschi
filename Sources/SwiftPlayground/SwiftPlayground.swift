// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let mixed = ["cat", "7", "owl", "15", "dog", "3"]
        let numbers = mixed.compactMap{Int($0)}
        print(numbers)
        let isNumber = numbers.allSatisfy {Int($0) != nil}  
        print(isNumber)

    }
}
