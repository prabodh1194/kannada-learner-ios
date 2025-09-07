import Foundation

struct LearningGoal: Codable, Identifiable {
    let id = UUID()
    var name: String
    var target: Int // Number of phrases to master
    var current: Int // Number of phrases currently mastered
    var deadline: Date
    var createdDate: Date
    var updatedDate: Date
    var completed: Bool
    
    init(name: String, target: Int, deadline: Date) {
        self.name = name
        self.target = target
        self.current = 0
        self.deadline = deadline
        self.createdDate = Date()
        self.updatedDate = Date()
        self.completed = false
    }
    
    mutating func updateProgress(_ masteredCount: Int) {
        current = masteredCount
        updatedDate = Date()
        
        // Check if goal is completed
        if current >= target {
            completed = true
        }
    }
    
    mutating func markAsCompleted() {
        completed = true
        updatedDate = Date()
    }
    
    mutating func reopen() {
        completed = false
        updatedDate = Date()
    }
    
    var progressPercentage: Double {
        target > 0 ? Double(current) / Double(target) * 100 : 0
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline)
        return components.day ?? 0
    }
}