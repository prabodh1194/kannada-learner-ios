import Foundation

class PhraseService: ObservableObject {
    @Published var phrases: [Phrase] = []
    @Published var currentStreak: Int = 0
    @Published var dailyGoal: Int = 5
    @Published var practiceHistory: [PracticeSession] = []
    @Published var collections: [PhraseCollection] = []
    @Published var reminders: [PracticeReminder] = []
    private let persistenceService = PersistenceService()
    private var recentlyPracticedIds: [String] = []
    private var sessionStartDate: Date?
    private var sessionPhrasesPracticed: Int = 0
    
    init() {
        loadPhrases()
        loadStreak()
        loadRecentlyPracticed()
        loadDailyGoal()
        loadPracticeHistory()
        loadCollections()
        loadReminders()
    }
    
    func loadPhrases() {
        // Try to load saved phrases
        if let savedPhrases = persistenceService.loadPhrases() {
            phrases = savedPhrases
        } else {
            // If no saved phrases, load sample data
            loadSamplePhrases()
        }
    }
    
    func loadSamplePhrases() {
        phrases = SamplePhrases.all
        savePhrases()
    }
    
    func savePhrases() {
        persistenceService.savePhrases(phrases)
    }
    
    func loadStreak() {
        currentStreak = persistenceService.loadStreak()
    }
    
    func saveStreak() {
        persistenceService.saveStreak(currentStreak)
    }
    
    func loadRecentlyPracticed() {
        recentlyPracticedIds = persistenceService.loadRecentlyPracticed()
    }
    
    func saveRecentlyPracticed() {
        persistenceService.saveRecentlyPracticed(recentlyPracticedIds)
    }
    
    func loadDailyGoal() {
        dailyGoal = persistenceService.loadDailyGoal()
    }
    
    func saveDailyGoal() {
        persistenceService.saveDailyGoal(dailyGoal)
    }
    
    func loadPracticeHistory() {
        practiceHistory = persistenceService.loadPracticeHistory()
    }
    
    func savePracticeHistory() {
        persistenceService.savePracticeHistory(practiceHistory)
    }
    
    func loadCollections() {
        collections = persistenceService.loadCollections()
        
        // If no collections loaded, load sample collections
        if collections.isEmpty {
            loadSampleCollections()
        }
    }
    
    func loadSampleCollections() {
        collections = SamplePhrases.sampleCollections
        saveCollections()
    }
    
    func saveCollections() {
        persistenceService.saveCollections(collections)
    }
    
    func loadReminders() {
        reminders = persistenceService.loadReminders()
    }
    
    func saveReminders() {
        persistenceService.saveReminders(reminders)
    }
    
    func addReminder(_ reminder: PracticeReminder) {
        reminders.append(reminder)
        saveReminders()
    }
    
    func updateReminder(_ reminder: PracticeReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveReminders()
        }
    }
    
    func deleteReminder(_ reminder: PracticeReminder) {
        reminders.removeAll(where: { $0.id == reminder.id })
        saveReminders()
    }
    
    func startPracticeSession() {
        sessionStartDate = Date()
        sessionPhrasesPracticed = 0
    }
    
    func endPracticeSession() {
        guard let startDate = sessionStartDate else { return }
        
        let duration = Date().timeIntervalSince(startDate)
        
        // Count mastery levels for this session
        var masteryCounts: [String: Int] = [:]
        for phrase in phrases {
            let count = masteryCounts[phrase.masteryLevel.rawValue, default: 0] + 1
            masteryCounts[phrase.masteryLevel.rawValue] = count
        }
        
        let session = PracticeSession(
            date: startDate,
            phrasesPracticed: sessionPhrasesPracticed,
            duration: duration,
            masteryLevels: masteryCounts
        )
        
        practiceHistory.append(session)
        savePracticeHistory()
        
        // Reset session variables
        sessionStartDate = nil
        sessionPhrasesPracticed = 0
    }
    
    func updateStreak() {
        let today = Date()
        if let lastPracticeDate = persistenceService.loadLastPracticeDate() {
            let calendar = Calendar.current
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            let lastPracticeComponents = calendar.dateComponents([.year, .month, .day], from: lastPracticeDate)
            
            // Check if it's the same day
            if todayComponents == lastPracticeComponents {
                // Already practiced today, no change to streak
                return
            }
            
            // Check if it's the next day
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
               calendar.isDate(yesterday, inSameDayAs: lastPracticeDate) {
                // Practiced yesterday, increment streak
                currentStreak += 1
            } else {
                // Missed a day, reset streak
                currentStreak = 1
            }
        } else {
            // First practice, start streak
            currentStreak = 1
        }
        
        // Save the streak and today's date
        saveStreak()
        persistenceService.saveLastPracticeDate(today)
    }
    
    func toggleFavorite(_ phrase: Phrase) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases[index].isFavorite.toggle()
            savePhrases()
        }
    }
    
    func updateMasteryLevel(for phrase: Phrase, to level: MasteryLevel) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases[index].masteryLevel = level
            savePhrases()
        }
    }
    
    func updatePhrase(_ updatedPhrase: Phrase) {
        if let index = phrases.firstIndex(where: { $0.id == updatedPhrase.id }) {
            phrases[index] = updatedPhrase
            savePhrases()
            
            // Add to recently practiced (limit to 10)
            let phraseId = updatedPhrase.id.uuidString
            if !recentlyPracticedIds.contains(phraseId) {
                recentlyPracticedIds.insert(phraseId, at: 0)
            } else {
                // Move to front if already in list
                recentlyPracticedIds.removeAll(where: { $0 == phraseId })
                recentlyPracticedIds.insert(phraseId, at: 0)
            }
            
            // Limit to 10 most recent
            if recentlyPracticedIds.count > 10 {
                recentlyPracticedIds = Array(recentlyPracticedIds.prefix(10))
            }
            
            saveRecentlyPracticed()
            
            // Increment session phrases practiced
            sessionPhrasesPracticed += 1
        }
    }
    
    func phrases(for category: Category) -> [Phrase] {
        return phrases.filter { $0.category == category }
    }
    
    func favoritePhrases() -> [Phrase] {
        return phrases.filter { $0.isFavorite }
    }
    
    func recentlyPracticedPhrases() -> [Phrase] {
        return recentlyPracticedIds.compactMap { id in
            phrases.first { $0.id.uuidString == id }
        }
    }
    
    // Statistics methods
    func totalPhrases() -> Int {
        return phrases.count
    }
    
    func masteredPhrases() -> Int {
        return phrases.filter { $0.masteryLevel == .mastered }.count
    }
    
    func learningPhrases() -> Int {
        return phrases.filter { $0.masteryLevel == .learning }.count
    }
    
    func newPhrases() -> Int {
        return phrases.filter { $0.masteryLevel == .new }.count
    }
    
    func favoritePhrasesCount() -> Int {
        return favoritePhrases().count
    }
    
    func phrasesByDifficulty(_ difficulty: DifficultyLevel) -> Int {
        return phrases.filter { $0.difficulty == difficulty }.count
    }
    
    func masteredPhrasesByCategory(_ category: Category) -> Int {
        return phrases.filter { $0.category == category && $0.masteryLevel == .mastered }.count
    }
    
    func learningPhrasesByCategory(_ category: Category) -> Int {
        return phrases.filter { $0.category == category && $0.masteryLevel == .learning }.count
    }
    
    func newPhrasesByCategory(_ category: Category) -> Int {
        return phrases.filter { $0.category == category && $0.masteryLevel == .new }.count
    }
    
    // Review methods
    func phrasesNeedingReview() -> [Phrase] {
        // Return phrases that are new or learning
        return phrases.filter { $0.masteryLevel == .new || $0.masteryLevel == .learning }
    }
    
    func difficultPhrases() -> [Phrase] {
        // Return phrases that are new (assuming these are the most difficult)
        return phrases.filter { $0.masteryLevel == .new }
    }
    
    // Collection methods
    func addCollection(_ collection: PhraseCollection) {
        collections.append(collection)
        saveCollections()
    }
    
    func updateCollection(_ collection: PhraseCollection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
            saveCollections()
        }
    }
    
    func deleteCollection(_ collection: PhraseCollection) {
        collections.removeAll(where: { $0.id == collection.id })
        saveCollections()
    }
    
    func phrases(in collection: PhraseCollection) -> [Phrase] {
        return phrases.filter { phrase in
            collection.phraseIds.contains(phrase.id.uuidString)
        }
    }
    
    // Daily goal methods
    func setDailyGoal(_ goal: Int) {
        dailyGoal = goal
        saveDailyGoal()
    }
    
    func phrasesPracticedToday() -> Int {
        // In a real app, you would track the actual number of phrases practiced today
        // For now, we'll return a random number for demonstration purposes
        return Int.random(in: 0...dailyGoal)
    }
    
    func goalProgress() -> Double {
        return Double(phrasesPracticedToday()) / Double(dailyGoal)
    }
    
    func exportData() -> Data? {
        return persistenceService.exportData()
    }
    
    func importData(_ data: Data) -> Bool {
        let success = persistenceService.importData(data)
        if success {
            // Reload data after import
            loadPhrases()
            loadStreak()
            loadRecentlyPracticed()
            loadDailyGoal()
            loadPracticeHistory()
            loadCollections()
            loadReminders()
        }
        return success
    }
}