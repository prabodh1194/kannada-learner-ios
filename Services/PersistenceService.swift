import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let phrasesKey = "SavedPhrases"
    private let streakKey = "CurrentStreak"
    private let lastPracticeDateKey = "LastPracticeDate"
    private let recentlyPracticedKey = "RecentlyPracticed"
    private let dailyGoalKey = "DailyGoal"
    private let practiceHistoryKey = "PracticeHistory"
    private let collectionsKey = "PhraseCollections"
    private let remindersKey = "PracticeReminders"
    private let practiceDatesKey = "PracticeDates"
    
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
    
    func saveDailyGoal(_ goal: Int) {
        userDefaults.set(goal, forKey: dailyGoalKey)
    }
    
    func loadDailyGoal() -> Int {
        // Default to 5 phrases per day
        return userDefaults.integer(forKey: dailyGoalKey) > 0 ? userDefaults.integer(forKey: dailyGoalKey) : 5
    }
    
    func savePracticeHistory(_ history: [PracticeSession]) {
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: practiceHistoryKey)
        }
    }
    
    func loadPracticeHistory() -> [PracticeSession] {
        if let data = userDefaults.data(forKey: practiceHistoryKey),
           let history = try? JSONDecoder().decode([PracticeSession].self, from: data) {
            return history
        }
        return []
    }
    
    func saveCollections(_ collections: [PhraseCollection]) {
        if let encoded = try? JSONEncoder().encode(collections) {
            userDefaults.set(encoded, forKey: collectionsKey)
        }
    }
    
    func loadCollections() -> [PhraseCollection] {
        if let data = userDefaults.data(forKey: collectionsKey),
           let collections = try? JSONDecoder().decode([PhraseCollection].self, from: data) {
            return collections
        }
        return []
    }
    
    func saveReminders(_ reminders: [PracticeReminder]) {
        if let encoded = try? JSONEncoder().encode(reminders) {
            userDefaults.set(encoded, forKey: remindersKey)
        }
    }
    
    func loadReminders() -> [PracticeReminder] {
        if let data = userDefaults.data(forKey: remindersKey),
           let reminders = try? JSONDecoder().decode([PracticeReminder].self, from: data) {
            return reminders
        }
        return []
    }
    
    func savePracticeDates(_ dates: [Date]) {
        // Convert dates to timestamps
        let timestamps = dates.map { $0.timeIntervalSince1970 }
        userDefaults.set(timestamps, forKey: practiceDatesKey)
    }
    
    func loadPracticeDates() -> [Date] {
        // Load timestamps and convert back to dates
        guard let timestamps = userDefaults.array(forKey: practiceDatesKey) as? [TimeInterval] else {
            return []
        }
        return timestamps.map { Date(timeIntervalSince1970: $0) }
    }
    
    func exportData() -> Data? {
        var exportDict: [String: Any] = [:]
        
        // Export phrases
        if let phrases = loadPhrases() {
            if let encodedPhrases = try? JSONEncoder().encode(phrases) {
                exportDict["phrases"] = encodedPhrases
            }
        }
        
        // Export streak
        exportDict["streak"] = loadStreak()
        
        // Export last practice date
        if let lastPracticeDate = loadLastPracticeDate() {
            exportDict["lastPracticeDate"] = lastPracticeDate.timeIntervalSince1970
        }
        
        // Export recently practiced
        exportDict["recentlyPracticed"] = loadRecentlyPracticed()
        
        // Export daily goal
        exportDict["dailyGoal"] = loadDailyGoal()
        
        // Export practice history
        let history = loadPracticeHistory()
        if let encodedHistory = try? JSONEncoder().encode(history) {
            exportDict["practiceHistory"] = encodedHistory
        }
        
        // Export collections
        let collections = loadCollections()
        if let encodedCollections = try? JSONEncoder().encode(collections) {
            exportDict["collections"] = encodedCollections
        }
        
        // Export reminders
        let reminders = loadReminders()
        if let encodedReminders = try? JSONEncoder().encode(reminders) {
            exportDict["reminders"] = encodedReminders
        }
        
        // Export practice dates
        let practiceDates = loadPracticeDates()
        if let encodedPracticeDates = try? JSONEncoder().encode(practiceDates) {
            exportDict["practiceDates"] = encodedPracticeDates
        }
        
        // Encode the export dictionary
        if let encodedData = try? JSONSerialization.data(withJSONObject: exportDict, options: .prettyPrinted) {
            return encodedData
        }
        
        return nil
    }
    
    func importData(_ data: Data) -> Bool {
        do {
            if let exportDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Import phrases
                if let phrasesData = exportDict["phrases"] as? Data {
                    userDefaults.set(phrasesData, forKey: phrasesKey)
                }
                
                // Import streak
                if let streak = exportDict["streak"] as? Int {
                    userDefaults.set(streak, forKey: streakKey)
                }
                
                // Import last practice date
                if let lastPracticeTimestamp = exportDict["lastPracticeDate"] as? TimeInterval {
                    let lastPracticeDate = Date(timeIntervalSince1970: lastPracticeTimestamp)
                    userDefaults.set(lastPracticeDate, forKey: lastPracticeDateKey)
                }
                
                // Import recently practiced
                if let recentlyPracticed = exportDict["recentlyPracticed"] as? [String] {
                    userDefaults.set(recentlyPracticed, forKey: recentlyPracticedKey)
                }
                
                // Import daily goal
                if let dailyGoal = exportDict["dailyGoal"] as? Int {
                    userDefaults.set(dailyGoal, forKey: dailyGoalKey)
                }
                
                // Import practice history
                if let historyData = exportDict["practiceHistory"] as? Data {
                    userDefaults.set(historyData, forKey: practiceHistoryKey)
                }
                
                // Import collections
                if let collectionsData = exportDict["collections"] as? Data {
                    userDefaults.set(collectionsData, forKey: collectionsKey)
                }
                
                // Import reminders
                if let remindersData = exportDict["reminders"] as? Data {
                    userDefaults.set(remindersData, forKey: remindersKey)
                }
                
                // Import practice dates
                if let practiceDatesData = exportDict["practiceDates"] as? Data {
                    userDefaults.set(practiceDatesData, forKey: practiceDatesKey)
                }
                
                return true
            }
        } catch {
            print("Error importing data: \(error)")
        }
        
        return false
    }
}