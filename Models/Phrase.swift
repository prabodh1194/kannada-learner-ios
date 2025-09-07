import Foundation

struct Phrase: Identifiable, Codable {
    let id = UUID()
    let kannadaText: String
    let englishTranslation: String
    let phoneticPronunciation: String
    let audioFileName: String
    let category: Category
    let difficulty: DifficultyLevel
    var isFavorite: Bool
    var masteryLevel: MasteryLevel
}