import Foundation

struct PracticeReminder: Codable, Identifiable {
    let id = UUID()
    var time: Date
    var days: [Int] // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    var enabled: Bool
    let createdDate: Date
    var updatedDate: Date
    
    init(time: Date, days: [Int]) {
        self.time = time
        self.days = days
        self.enabled = true
        self.createdDate = Date()
        self.updatedDate = Date()
    }
    
    mutating func toggleEnabled() {
        enabled.toggle()
        updatedDate = Date()
    }
    
    mutating func updateTime(_ newTime: Date) {
        time = newTime
        updatedDate = Date()
    }
    
    mutating func updateDays(_ newDays: [Int]) {
        days = newDays
        updatedDate = Date()
    }
}