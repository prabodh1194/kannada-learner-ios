import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let phrasesKey = "SavedPhrases"
    
    func savePhrases(_ phrases: [Phrase]) {
        if let encoded = try? JSONEncoder().encode(phrases) {
            userDefaults.set(encoded, forKey: phrasesKey)
        }
    }
    
    func loadPhrases() -> [Phrase]? {
        if let data = userDefaults.data(forKey: phrasesKey),
           let phrases = try? JSONDecoder().decode([Phrase].self, from: data) {
            return phrases
        }
        return nil
    }
    
    func clearPhrases() {
        userDefaults.removeObject(forKey: phrasesKey)
    }
}