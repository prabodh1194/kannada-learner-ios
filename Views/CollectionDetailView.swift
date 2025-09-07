import SwiftUI

struct CollectionDetailView: View {
    @ObservedObject var phraseService: PhraseService
    @State var collection: PhraseCollection
    @State private var showingAddPhrase = false
    @State private var searchText = ""
    
    var phrasesInCollection: [Phrase] {
        phraseService.phrases(in: collection)
    }
    
    var filteredPhrases: [Phrase] {
        if searchText.isEmpty {
            return phraseService.phrases
        } else {
            return phraseService.phrases.filter {
                $0.kannadaText.localizedCaseInsensitiveContains(searchText) ||
                $0.englishTranslation.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneticPronunciation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            // Collection info
            VStack(alignment: .leading, spacing: 8) {
                Text(collection.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.neonGreen)
                
                Text("\(phrasesInCollection.count) phrases")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Phrases in collection
            if !phrasesInCollection.isEmpty {
                List(phrasesInCollection) { phrase in
                    HStack {
                        PhraseRowView(phrase: phrase)
                        Spacer()
                        Button(action: {
                            removePhrase(phrase)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.neonPink)
                        }
                    }
                }
            } else {
                VStack {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.textSecondary)
                    Text("No phrases in this collection")
                        .font(.title2)
                        .foregroundColor(.textSecondary)
                        .padding()
                    Text("Add phrases to get started")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Add phrase button
            Button(action: {
                showingAddPhrase = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Phrases")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.neonGreen)
                .foregroundColor(.darkBackground)
                .cornerRadius(12)
            }
            .padding()
        }
        .sheet(isPresented: $showingAddPhrase) {
            AddPhraseToCollectionView(phraseService: phraseService, collection: $collection)
        }
        .navigationTitle(collection.name)
    }
    
    private func removePhrase(_ phrase: Phrase) {
        collection.removePhrase(phrase.id.uuidString)
        phraseService.updateCollection(collection)
    }
}

struct AddPhraseToCollectionView: View {
    @ObservedObject var phraseService: PhraseService
    @Binding var collection: PhraseCollection
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    
    var filteredPhrases: [Phrase] {
        let phrasesInCollection = Set(collection.phraseIds)
        let allPhrases = phraseService.phrases.filter {
            !phrasesInCollection.contains($0.id.uuidString)
        }
        
        if searchText.isEmpty {
            return allPhrases
        } else {
            return allPhrases.filter {
                $0.kannadaText.localizedCaseInsensitiveContains(searchText) ||
                $0.englishTranslation.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneticPronunciation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List(filteredPhrases) { phrase in
                    HStack {
                        PhraseRowView(phrase: phrase)
                        Spacer()
                        Button(action: {
                            addPhrase(phrase)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.neonGreen)
                        }
                    }
                }
            }
            .navigationTitle("Add Phrases")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func addPhrase(_ phrase: Phrase) {
        collection.addPhrase(phrase.id.uuidString)
        phraseService.updateCollection(collection)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search phrases...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

#Preview {
    NavigationView {
        CollectionDetailView(phraseService: PhraseService(), collection: PhraseCollection(name: "Sample Collection", phraseIds: []))
    }
}