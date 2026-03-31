// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
    let list:[Int] = [3,7,8,18]
    let sum = list.reduce(0){$0 + $1}
    print(sum)


    let odd = list.filter{ $0 % 2 != 0 }
    print(odd)
    
    let biggest = list.reduce(0){Swift.max($1,$0)}
    print(biggest)

    let under15 = list.filter{ $0 < 15 }
    print(under15)

        let roundTo10 = list.map{($0 + 9)/10 * 10 }
    print(roundTo10)


}

}