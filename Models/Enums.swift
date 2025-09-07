import Foundation

enum Category: String, CaseIterable, Codable {
    case officeGreetings = "Office Greetings"
    case officeLunch = "Office Lunch"
    case officeMeetings = "Office Meetings"
    case shopping = "Shopping"
    case transportation = "Transportation"
    case restaurants = "Restaurants"
    case directions = "Directions"
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum MasteryLevel: String, CaseIterable, Codable {
    case new = "New"
    case learning = "Learning"
    case mastered = "Mastered"
}