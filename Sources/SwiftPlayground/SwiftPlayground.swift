// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
struct Student: Identifiable{
    var name: String
    var age: Int
    let id: UUID
}
struct Course: CustomStringConvertible{
    let id: UUID
    let title : String

    var description: String{
        return "Course: \(title) with id: \(id)"
    }

}


struct Enrolment: Codable{
    let studentID: Int
    let CourseID: Int
}

struct ScoreEntry: Comparable {
    let studentID:UUID
    var points : Float
    static func < (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool {
        return lhs.points < rhs.points
    }

}
@main
struct SwiftPlayground {
    static func main() {
        let enrolment = Enrolment(studentID: 26712, CourseID: 68321)
        let data = try! JSONEncoder().encode(enrolment)
        print(data)
        let decodedEnrolment = try! JSONDecoder().decode(Enrolment.self, from: data)
        print(decodedEnrolment)

    }
}
