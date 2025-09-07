import SwiftUI

struct ImportCollectionView: View {
    @ObservedObject var phraseService: PhraseService
    @Environment(\.presentationMode) var presentationMode
    @State private var importedCollection: SharedCollection?
    @State private var showingImportAlert = false
    @State private var importAlertMessage = ""
    
    var body: some View {
        VStack {
            if let collection = importedCollection {
                VStack(alignment: .leading, spacing: 16) {
                    Text(collection.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.neonGreen)
                    
                    Text("\(collection.phrases.count) phrases")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("Created: \(dateFormatter.string(from: collection.createdDate))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("Last updated: \(dateFormatter.string(from: collection.updatedDate))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(collection.phrases.indices, id: \.self) { index in
                                let phrase = collection.phrases[index]
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(phrase.kannadaText)
                                        .font(.headline)
                                        .foregroundColor(.neonGreen)
                                    Text(phrase.englishTranslation)
                                        .font(.body)
                                        .foregroundColor(.textPrimary)
                                    Text(phrase.phoneticPronunciation)
                                        .font(.caption)
                                        .italic()
                                        .foregroundColor(.textSecondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.darkSurface)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                
                Button(action: {
                    importCollection(collection)
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle")
                        Text("Import Collection")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.neonGreen)
                    .foregroundColor(.darkBackground)
                    .cornerRadius(12)
                }
                .padding()
            } else {
                VStack {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 50))
                        .foregroundColor(.textSecondary)
                    Text("No collection to import")
                        .font(.title2)
                        .foregroundColor(.textSecondary)
                        .padding()
                    Text("Share a collection file to this app to import it")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Import Collection")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Import Collection", isPresented: $showingImportAlert) {
            Button("OK") { }
        } message: {
            Text(importAlertMessage)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    func handleImportedData(_ data: Data) {
        do {
            let collection = try JSONDecoder().decode(SharedCollection.self, from: data)
            importedCollection = collection
        } catch {
            importAlertMessage = "Error importing collection: \(error.localizedDescription)"
            showingImportAlert = true
        }
    }
    
    private func importCollection(_ sharedCollection: SharedCollection) {
        // Convert SharedCollection to PhraseCollection
        var phraseIds: [String] = []
        
        // For each shared phrase, check if it already exists in our phrase list
        for sharedPhrase in sharedCollection.phrases {
            // Try to find an existing phrase with the same text
            if let existingPhrase = phraseService.phrases.first(where: {
                $0.kannadaText == sharedPhrase.kannadaText &&
                $0.englishTranslation == sharedPhrase.englishTranslation
            }) {
                // If found, use the existing phrase's ID
                phraseIds.append(existingPhrase.id.uuidString)
            } else {
                // If not found, create a new phrase
                let newPhrase = Phrase(
                    id: UUID(),
                    kannadaText: sharedPhrase.kannadaText,
                    englishTranslation: sharedPhrase.englishTranslation,
                    phoneticPronunciation: sharedPhrase.phoneticPronunciation,
                    audioFileName: sharedPhrase.audioFileName,
                    category: Category(rawValue: sharedPhrase.category) ?? .officeGreetings,
                    difficulty: DifficultyLevel(rawValue: sharedPhrase.difficulty) ?? .beginner,
                    isFavorite: false,
                    masteryLevel: .new
                )
                
                // Add the new phrase to our phrase list
                var updatedPhrases = phraseService.phrases
                updatedPhrases.append(newPhrase)
                phraseService.phrases = updatedPhrases
                phraseService.savePhrases()
                
                // Add the new phrase's ID to our collection
                phraseIds.append(newPhrase.id.uuidString)
            }
        }
        
        // Create a new PhraseCollection
        let newCollection = PhraseCollection(
            name: sharedCollection.name,
            phraseIds: phraseIds
        )
        
        // Add the new collection to our collections
        phraseService.addCollection(newCollection)
        
        // Show success message
        importAlertMessage = "Collection imported successfully!"
        showingImportAlert = true
        
        // Close the view after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}