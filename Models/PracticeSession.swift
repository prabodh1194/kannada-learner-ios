import Foundation

struct PracticeSession: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let phrasesPracticed: Int
    let duration: TimeInterval // in seconds
    let masteryLevels: [String: Int] // mastery level to count
    
    init(date: Date, phrasesPracticed: Int, duration: TimeInterval, masteryLevels: [String: Int]) {
        self.date = date
        self.phrasesPracticed = phrasesPracticed
        self.duration = duration
        self.masteryLevels = masteryLevels
    }
}