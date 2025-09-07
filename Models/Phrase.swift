import Foundation

struct Phrase: Identifiable, Codable, Equatable {
    let id: UUID
    let kannadaText: String
    let englishTranslation: String
    let phoneticPronunciation: String
    let audioFileName: String
    let category: Category
    let difficulty: DifficultyLevel
    var isFavorite: Bool
    var masteryLevel: MasteryLevel
    
    // Computed property to get the full audio file path
    var audioFilePath: String {
        // In a real app, this would point to the actual audio file
        // For now, we'll return a placeholder
        return "audio/\(audioFileName)"
    }
    
    static func == (lhs: Phrase, rhs: Phrase) -> Bool {
        return lhs.id == rhs.id
    }
}