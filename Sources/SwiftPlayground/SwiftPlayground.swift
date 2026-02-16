// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let mixed = ["cat", "7", "owl", "15", "dog", "3"]
        let numbers = mixed.compactMap{Int($0)}
        print(numbers)
        let isNumber = mixed.allSatisfy {Int($0) != nil}  
        print(isNumber)
        let sightings = [
        (name: "moth", score: 3),
        (name: "wolf", score: 9),
        (name: "raven", score: 4),
        (name: "mist", score: 7),
        (name: "wisp", score: 2)
        ]
            let sightingsFilter = sightings.filter{ sighting in return sighting.name.hasPrefix("m")  
            || sighting.name.hasPrefix("w")}
            print(sightingsFilter)
            let filterdScores = sightingsFilter.map{$0.score}.reduce(0){score in return $0 + $1}
            print(filterdScores)
            
    }
}
