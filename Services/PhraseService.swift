import Foundation

class PhraseService: ObservableObject {
    @Published var phrases: [Phrase] = []
    
    init() {
        loadSamplePhrases()
    }
    
    func loadSamplePhrases() {
        phrases = SamplePhrases.all
    }
    
    func toggleFavorite(_ phrase: Phrase) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases[index].isFavorite.toggle()
        }
    }
    
    func updateMasteryLevel(for phrase: Phrase, to level: MasteryLevel) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases[index].masteryLevel = level
        }
    }
    
    func phrases(for category: Category) -> [Phrase] {
        return phrases.filter { $0.category == category }
    }
    
    func favoritePhrases() -> [Phrase] {
        return phrases.filter { $0.isFavorite }
    }
}