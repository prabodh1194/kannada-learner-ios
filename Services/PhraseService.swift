import Foundation

class PhraseService: ObservableObject {
    @Published var phrases: [Phrase] = []
    @Published var currentStreak: Int = 0
    @Published var dailyGoal: Int = 5
    private let persistenceService = PersistenceService()
    private var recentlyPracticedIds: [String] = []
    
    init() {
        loadPhrases()
        loadStreak()
        loadRecentlyPracticed()
        loadDailyGoal()
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
        }
        return success
    }
}