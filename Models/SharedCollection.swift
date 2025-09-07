import Foundation

struct SharedCollection: Codable {
    let name: String
    let phrases: [SharedPhrase]
    let createdDate: Date
    let updatedDate: Date
    
    struct SharedPhrase: Codable {
        let kannadaText: String
        let englishTranslation: String
        let phoneticPronunciation: String
        let audioFileName: String
        let category: String
        let difficulty: String
    }
}