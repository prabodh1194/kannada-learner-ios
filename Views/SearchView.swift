import SwiftUI

struct SearchView: View {
    @ObservedObject var phraseService: PhraseService
    @State private var searchText = ""
    @State private var selectedMasteryLevel: MasteryLevel? = nil
    
    var filteredPhrases: [Phrase] {
        var result = phraseService.phrases
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.kannadaText.localizedCaseInsensitiveContains(searchText) ||
                $0.englishTranslation.localizedCaseInsensitiveContains(searchText) ||
                $0.phoneticPronunciation.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply mastery level filter
        if let masteryLevel = selectedMasteryLevel {
            result = result.filter { $0.masteryLevel == masteryLevel }
        }
        
        return result
    }
    
    var body: some View {
        VStack {
            // Filter bar
            HStack {
                Text("Filter by:")
                    .foregroundColor(.textSecondary)
                
                Menu {
                    Button("All Levels", action: { selectedMasteryLevel = nil })
                    ForEach(MasteryLevel.allCases, id: \.self) { level in
                        Button(level.rawValue, action: { selectedMasteryLevel = level })
                    }
                } label: {
                    HStack {
                        Text(selectedMasteryLevel?.rawValue ?? "All Levels")
                            .foregroundColor(.neonGreen)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.neonGreen)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Search results
            List(filteredPhrases) { phrase in
                NavigationLink(destination: PhraseDetailView(phrase: phrase)) {
                    PhraseRowView(phrase: phrase)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search phrases...")
        .navigationTitle("Search")
    }
}

#Preview {
    NavigationView {
        SearchView(phraseService: PhraseService())
    }
}