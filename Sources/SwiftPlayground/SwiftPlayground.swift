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
struct ScoreEntry: Comparable {
    let studentID:UUID
    var points : Float
    static func < (lhs: ScoreEntry, rhs: ScoreEntry) -> Bool {
        return lhs.points < rhs.points
    }
}
struct EnrolmentCodeable: Codable{
    let studentID: UUID
    let CourseID: String
}

struct Enrolment: Hashable, Codable{
    let studentID: UUID
    let CourseID: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(studentID)
        hasher.combine(CourseID)
        
    
}


@main
struct SwiftPlayground {
    static func main() {
        let enrolment = Enrolment(studentID: UUID(), CourseID: "SWE13")
        print(enrolment.hashValue)
        let student1 = Student(name: "Jules", age: 16, id: UUID())
        let student2 = Student(name: "Stan", age: 17, id: UUID())
        let student3 = Student(name: "Ash", age: 18, id: UUID())
        let course1 = Course(id: UUID(), title: "13SWE")
        let enrolment1 = Enrolment(studentID: (student1.id), CourseID: (enrolment.CourseID))
        let enrolment2 = Enrolment(studentID: (student2.id), CourseID: (enrolment.CourseID))
        let enrolment3 = Enrolment(studentID: (student1.id), CourseID: (enrolment.CourseID))
        print(course1)

        let enrolment1Encoded = try? JSONEncoder().encode(enrolment1)
        let enrolment1Decoded = try? JSONDecoder().decode(Enrolment.self, from: enrolment1Encoded!)
        let enrolment2Encoded = try? JSONEncoder().encode(enrolment2)
        let enrolment2Decoded = try? JSONDecoder().decode(Enrolment.self, from: enrolment2Encoded!)
        let allenrolmentsSet: Set<Enrolment> = [enrolment1, enrolment2, enrolment3]
        print(allenrolmentsSet.count)
        print("enrolment 1 hashvalue : \(enrolment1Decoded.hashValue)")
        print("enrolment 2 hashvalue : \(enrolment2Decoded.hashValue)")

        let student1Score = ScoreEntry(studentID: student1.id, points: 50.0)
        let student2Score = ScoreEntry(studentID: student2.id, points: 55.0)
        let student3Score = ScoreEntry(studentID: student3.id, points: 55.0)
        let scoresArray = [student1Score.points, student2Score.points, student3Score.points]
        let scoresArraySorted = scoresArray.sorted()
        print("Sorted scores: \(scoresArraySorted)")
        if student2Score.points == student3Score.points {
            print("Student 2 and Student 3 have the same score.")
        } else {
            print("Student 2 and Student 3 have different scores.")
        }

        
        

        var scoreEntries = [ScoreEntry(studentID: UUID(), points: 85.0),
                            ScoreEntry(studentID: UUID(), points: 92.5),
                            ScoreEntry(studentID: UUID(), points: 78.0)]
        scoreEntries.sort()
        for entry in scoreEntries{
            print(entry.points)
        
        }

        }
    }

