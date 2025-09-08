import Foundation

struct Phrase: Codable, Equatable, Identifiable {
    let id: UUID
    var kannadaText: String
    var englishTranslation: String
    var phoneticPronunciation: String
    var audioFileName: String
    var category: Category
    var difficulty: DifficultyLevel
    var isFavorite: Bool
    var masteryLevel: MasteryLevel
    
    // Spaced repetition fields
    var lastReviewed: Date?
    var interval: Double // Days until next review
    var easeFactor: Double // Factor affecting interval changes
    var repetitionCount: Int // Number of successful repetitions
    
    // Computed property to get the full audio file path
    var audioFilePath: String {
        // In a real app, this would point to the actual audio file
        // For now, we'll return a placeholder
        return "audio/\(audioFileName)"
    }
    
    init(
        id: UUID = UUID(),
        kannadaText: String,
        englishTranslation: String,
        phoneticPronunciation: String,
        audioFileName: String,
        category: Category,
        difficulty: DifficultyLevel,
        isFavorite: Bool = false,
        masteryLevel: MasteryLevel = .new
    ) {
        self.id = id
        self.kannadaText = kannadaText
        self.englishTranslation = englishTranslation
        self.phoneticPronunciation = phoneticPronunciation
        self.audioFileName = audioFileName
        self.category = category
        self.difficulty = difficulty
        self.isFavorite = isFavorite
        self.masteryLevel = masteryLevel
        
        // Initialize spaced repetition fields
        self.lastReviewed = nil
        self.interval = 0.0
        self.easeFactor = 2.5 // Default ease factor
        self.repetitionCount = 0
    }
    
    static func == (lhs: Phrase, rhs: Phrase) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Spaced repetition methods
    mutating func updateSpacedRepetition(quality: Int) {
        // Quality should be 0-5, where 0 is worst and 5 is best
        
        // Update last reviewed date
        lastReviewed = Date()
        
        // If this is the first review
        if repetitionCount == 0 {
            interval = 1.0 // Review again in 1 day
            repetitionCount = 1
        } else {
            // If quality is poor, reset repetition count
            if quality < 3 {
                repetitionCount = 0
                interval = 1.0
            } else {
                // If quality is good, increase interval
                repetitionCount += 1
                
                // Calculate new interval based on quality and ease factor
                if repetitionCount == 1 {
                    interval = 1.0
                } else if repetitionCount == 2 {
                    interval = 6.0
                } else {
                    interval = interval * easeFactor
                }
            }
        }
        
        // Update ease factor based on quality
        easeFactor = easeFactor + (0.1 - (5 - Double(quality)) * (0.08 + (5 - Double(quality)) * 0.02))
        
        // Ensure ease factor doesn't drop below 1.3
        if easeFactor < 1.3 {
            easeFactor = 1.3
        }
    }
    
    // Check if phrase is due for review
    var isDueForReview: Bool {
        guard let lastReviewed = lastReviewed else {
            // If never reviewed, it's due
            return true
        }
        
        let nextReviewDate = Calendar.current.date(byAdding: .day, value: Int(interval), to: lastReviewed)!
        return Date() >= nextReviewDate
    }
    
    // Days until next review
    var daysUntilNextReview: Int {
        guard let lastReviewed = lastReviewed else {
            return 0
        }
        
        let nextReviewDate = Calendar.current.date(byAdding: .day, value: Int(interval), to: lastReviewed)!
        let components = Calendar.current.dateComponents([.day], from: Date(), to: nextReviewDate)
        return max(0, components.day ?? 0)
    }
}