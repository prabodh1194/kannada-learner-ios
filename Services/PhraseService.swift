import Foundation

class PhraseService: ObservableObject {
    @Published var phrases: [Phrase] = []
    private let persistenceService = PersistenceService()
    
    init() {
        loadPhrases()
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