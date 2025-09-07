import Foundation

class PhraseService: ObservableObject {
    @Published var phrases: [Phrase] = []
    @Published var currentStreak: Int = 0
    private let persistenceService = PersistenceService()
    
    init() {
        loadPhrases()
        loadStreak()
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
        }
    }
    
    func phrases(for category: Category) -> [Phrase] {
        return phrases.filter { $0.category == category }
    }
    
    func favoritePhrases() -> [Phrase] {
        return phrases.filter { $0.isFavorite }
    }
}