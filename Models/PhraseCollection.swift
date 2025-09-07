import Foundation

struct PhraseCollection: Codable, Identifiable {
    let id: UUID
    var name: String
    var phraseIds: [String] // UUIDs of phrases in this collection
    let createdDate: Date
    var updatedDate: Date
    
    init(name: String, phraseIds: [String]) {
        self.id = UUID()
        self.name = name
        self.phraseIds = phraseIds
        self.createdDate = Date()
        self.updatedDate = Date()
    }
    
    init(id: UUID, name: String, phraseIds: [String], createdDate: Date, updatedDate: Date) {
        self.id = id
        self.name = name
        self.phraseIds = phraseIds
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    mutating func addPhrase(_ phraseId: String) {
        if !phraseIds.contains(phraseId) {
            phraseIds.append(phraseId)
            updatedDate = Date()
        }
    }
    
    mutating func removePhrase(_ phraseId: String) {
        if let index = phraseIds.firstIndex(of: phraseId) {
            phraseIds.remove(at: index)
            updatedDate = Date()
        }
    }
}