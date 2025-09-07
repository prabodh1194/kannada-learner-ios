import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let phrasesKey = "SavedPhrases"
    private let streakKey = "CurrentStreak"
    private let lastPracticeDateKey = "LastPracticeDate"
    private let recentlyPracticedKey = "RecentlyPracticed"
    
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
    
    func saveStreak(_ streak: Int) {
        userDefaults.set(streak, forKey: streakKey)
    }
    
    func loadStreak() -> Int {
        return userDefaults.integer(forKey: streakKey)
    }
    
    func saveLastPracticeDate(_ date: Date) {
        userDefaults.set(date, forKey: lastPracticeDateKey)
    }
    
    func loadLastPracticeDate() -> Date? {
        return userDefaults.object(forKey: lastPracticeDateKey) as? Date
    }
    
    func saveRecentlyPracticed(_ phraseIds: [String]) {
        userDefaults.set(phraseIds, forKey: recentlyPracticedKey)
    }
    
    func loadRecentlyPracticed() -> [String] {
        return userDefaults.array(forKey: recentlyPracticedKey) as? [String] ?? []
    }
}